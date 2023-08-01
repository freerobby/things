$fn = 20;

chassis_width = 49.2125;

short_wall_height = 12;
tall_wall_height = 142.875;
wall_width = 6;
wall_length = 38;

vertical_spacing = 10;

base_width = chassis_width + 2 * wall_width + 10;
base_length = wall_length + 10;
base_height = 3;

total_w = chassis_width + 2 * wall_width;
module draw_base() {
    translate([-(base_width - total_w), -base_length + wall_length, 0])
        cube([base_width, base_length, base_height]);
}

module draw_riser() {
    cube([chassis_width + 2 * wall_width, wall_length, vertical_spacing]);
}

module draw_tall_wall() {
    knob_curve_diameter = 4.5;
    knob_protrusion = 4;
    knob_center_y_offset = 8 - knob_curve_diameter / 2;
    knob_flat_length = 6;
    
    knob_z_offsets = [24, 120];
    
    hole_radius = 2.5;
    hole_z_offsets = [15, 73, 129];
    
    module draw_knob(z_offset) {
        translate([-knob_protrusion, knob_center_y_offset, z_offset]) {
            rotate([0, 90, 0]) {
                cylinder(h = knob_protrusion, d = knob_curve_diameter);
            }
        }
        translate([-knob_protrusion, 0, z_offset - knob_curve_diameter / 2]) {
            cube([knob_protrusion, knob_center_y_offset, knob_curve_diameter]);
        }
    }
    
    module draw_hole(z_offset) {
        translate([0, knob_center_y_offset, z_offset]) {
            rotate([0, 90, 0]) {
                cylinder(h = wall_width, r = hole_radius);
            }
        }
    }
    
    difference() {
        union() {
            cube([wall_width, wall_length, tall_wall_height]);
            for (i = knob_z_offsets) {
                draw_knob(i);
            }
        }
        
        for (i = hole_z_offsets) {
            draw_hole(i);
        }
    }
}

module draw_fan_mount() {
    fan_hole_diameter = 4.3;
    fan_hole_spacing = 105;
    fan_width = 120;
    fan_depth = 25;
    
    fan_y_offset = -20;
    fan_z_offset = vertical_spacing + (tall_wall_height - fan_width) / 2;
    
    bracket_height = fan_hole_diameter * 3;
    bracket_depth = 5;
    
    hole_offset = (fan_width - fan_hole_spacing) / 2;
    
    // Lower bracket
    translate([
        (total_w - fan_width) / 2,
        fan_y_offset,
        vertical_spacing + (tall_wall_height - fan_hole_spacing) / 2 - bracket_height / 2
    ]) {
        difference() {
            cube([total_w + (fan_width - total_w) / 2, -fan_y_offset, bracket_height]);
            
            translate([-wall_width, bracket_depth, 0])
                cube([total_w + (fan_width - total_w) / 2, -fan_y_offset, bracket_height]);
            
            translate([hole_offset, -fan_y_offset, bracket_height / 2]) {
                rotate([90, 0, 0]) {
                    cylinder(h = -fan_y_offset, d = fan_hole_diameter);
                }
            }
        }
    }
    // Upper bracket
    translate([
        (total_w - fan_width) / 2,
        fan_y_offset,
        vertical_spacing + (tall_wall_height - fan_hole_spacing) / 2 - bracket_height / 2 + fan_hole_spacing
    ]) {
        difference() {
            cube([total_w + (fan_width - total_w) / 2, -fan_y_offset, bracket_height]);
            
            translate([-wall_width, bracket_depth, 0])
                cube([total_w + (fan_width - total_w) / 2, -fan_y_offset, bracket_height]);
            
            translate([hole_offset, -fan_y_offset, bracket_height / 2]) {
                rotate([90, 0, 0]) {
                    cylinder(h = -fan_y_offset, d = fan_hole_diameter);
                }
            }
        }
    }
    
    module draw_fan() {
        color("red") {
            difference() {
                cube([fan_width, fan_depth, fan_width]);
                
                translate([hole_offset, fan_depth, hole_offset]) {
                    rotate([90, 0, 0]) {
                        cylinder(h = fan_depth, d = fan_hole_diameter);
                    }
                }
                translate([fan_width - hole_offset, fan_depth, hole_offset]) {
                    rotate([90, 0, 0]) {
                        cylinder(h = fan_depth, d = fan_hole_diameter);
                    }
                }
                translate([fan_width - hole_offset, fan_depth, fan_width - hole_offset]) {
                    rotate([90, 0, 0]) {
                        cylinder(h = fan_depth, d = fan_hole_diameter);
                    }
                }
                translate([hole_offset, fan_depth, fan_width - hole_offset]) {
                    rotate([90, 0, 0]) {
                        cylinder(h = fan_depth, d = fan_hole_diameter);
                    }
                }
            }
        }
    }
    
    translate([(total_w - fan_width) / 2, fan_y_offset - fan_depth, fan_z_offset]) {
        draw_fan();
    }
}
draw_fan_mount();


module draw_front() {
    color("blue") {
        draw_riser();
    }

    color("yellow") {
        translate([chassis_width + wall_width, 0, vertical_spacing])
            draw_tall_wall();
    }

    color("green") {
        draw_base();
    }
}
module draw_rear() {
    mirror([0, 1, 0]) draw_front();
}

draw_front();
//draw_rear();