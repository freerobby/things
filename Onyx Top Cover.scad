$fn=100;

wall_thickness = 2;
wall_height = 50;
wall_length = 502;
wall_spacing = 140;

top_height = 33;
front_slice_angle = -30;
back_slice_angle = 43;

lock_cutout_width = 16;
lock_cutout_radius = 9.5;
lock_cutout_offset = 74;

rubber_cutout_radius = 3.5;
rubber_cutout_offset = 372;
rubber_cutout_center_distance = 35;

join_length = 4;
join_factor = 8;
join_clearance = 4;

front_crop = 2;
back_crop = 2;

module wall() {
    cube([wall_thickness, wall_length, wall_height]);
}

module top() {
    rotate([90, 0, 0])
        scale([1.0, top_height / (wall_spacing + 2 * wall_thickness) * 2])
            linear_extrude(wall_length) {
                difference() {
                    circle(d = wall_spacing + 2 * wall_thickness);
                    
                    circle(d = wall_spacing);
                    translate([-wall_spacing/2 - wall_thickness, -wall_spacing - 2 * wall_thickness, 0])
                        square(wall_spacing + 2 * wall_thickness);
                }
            }
}

module front_slice() {
    rotate([front_slice_angle, 0, 0])
        translate([0, -wall_spacing, 0])
            cube([wall_spacing + 2 * wall_thickness, wall_spacing, 2 * (wall_height + top_height)]);
}

module back_slice() {
    translate([0, wall_length, 0])
        rotate([back_slice_angle, 0, 0])
            translate([0, 0, 0])
                cube([wall_spacing + 2 * wall_thickness, wall_spacing, 2 * (wall_height + top_height)]);
}

module lock_cutout() {
    difference() {
        translate([wall_spacing / 2 + wall_thickness, lock_cutout_offset + lock_cutout_radius, 0])
            cylinder(h = 2 * (wall_height + top_height), r = lock_cutout_radius);
        
        translate([wall_spacing / 2 + wall_thickness + lock_cutout_width / 2, lock_cutout_offset, 0])
            cube([lock_cutout_width, lock_cutout_radius * 2, 2 * (wall_height + top_height)]);
        translate([wall_spacing / 2 + wall_thickness - 3 * lock_cutout_width / 2, lock_cutout_offset, 0])
            cube([lock_cutout_width, lock_cutout_radius * 2, 2 * (wall_height + top_height)]);
    }
}

module rubber_cutout() {
    translate([wall_spacing / 2 + wall_thickness, rubber_cutout_offset, 0])
        cylinder(h = 2 * (wall_height + top_height), r = rubber_cutout_radius);
    translate([wall_spacing / 2 + wall_thickness, rubber_cutout_offset + rubber_cutout_center_distance, 0])
        cylinder(h = 2 * (wall_height + top_height), r = rubber_cutout_radius);
}

module crop() {
    translate([0, -wall_spacing, 0])
        cube([wall_spacing + 2 * wall_thickness, wall_spacing, wall_height + top_height]);
}

module cover() {
    difference() {
        union() {
            wall();
            translate([wall_spacing + wall_thickness, 0, 0])
                wall();

            translate([(wall_spacing + 2 * wall_thickness) / 2, wall_length, wall_height])
                top();
        }
        
        front_slice();
        back_slice();
        lock_cutout();
        rubber_cutout();
        
        translate([0, front_crop, 0])
            crop();
        translate([0, wall_spacing + wall_length - back_crop, 0])
            crop();

    }
}

module top_join() {
    rotate([90, 0, 0])
        scale([1.0, top_height / (wall_spacing + 2 * wall_thickness) * 2])
            linear_extrude(join_length) {
                difference() {
                    circle(d = wall_spacing + 2 * wall_thickness);
                    
                    circle(d = wall_spacing - (join_factor * 2 - 2) * wall_thickness);
                    translate([-wall_spacing/2 - wall_thickness, -wall_spacing - 2 * wall_thickness, 0])
                        square(wall_spacing + 2 * wall_thickness);
                }
            }
}
module wall_join() {
    translate([0, 0, join_clearance])
    cube([wall_thickness * join_factor, join_length, wall_height - join_clearance]);
}
module join() {
    translate([0, -join_length / 2, 0])
        wall_join();
    translate([wall_thickness + wall_spacing - (join_factor - 1) * wall_thickness, -join_length / 2, 0])
        wall_join();
    
    translate([(wall_spacing + 2 * wall_thickness) / 2, join_length / 2, wall_height])
        top_join();
}


module print1() {
    cover();
}

module print2_base() {
    cover();
    translate([0, wall_length / 2])
        join();
}

module print2_1() {
    difference() {
        print2_base();
        
        translate([0, 0, 0])
            cube([wall_thickness * 2 + wall_spacing, wall_length / 2, wall_height + top_height]);
    }
}

module print2_2() {
    difference() {
        print2_base();
        
        translate([0, wall_length / 2, 0])
            cube([wall_thickness * 2 + wall_spacing, wall_length / 2, wall_height + top_height]);
    }
};

print2_1();
print2_2();