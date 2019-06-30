$fn = 100;

rack_diameter = 10;
rack_width = 155;

brace_height = 180;
brace_width = 240;
brace_thickness = 2;

module draw_brace() {
    // Support portion
    difference() {
        cube([brace_width, brace_thickness, brace_height]);
    }
        
    // Top portion
    translate([0, 0, brace_height])
    difference() {
        color("blue")
        cube([brace_width, rack_diameter + brace_thickness, rack_diameter / 2 + brace_thickness]);
        
        translate([0, brace_thickness + rack_diameter / 2, 0])
        rotate([0, 90, 0])
        cylinder(h = brace_width, d = rack_diameter);
    }
}

module join() {
    union() {
        translate([0, rack_width / 2 - rack_diameter - brace_thickness, 0])
            draw_brace();
        mirror([0, 1, 0])
            translate([0, rack_width / 2- rack_diameter - brace_thickness, 0])
                draw_brace();
    }
    
    translate([0, -rack_width / 2 + rack_diameter, 0])
        cube([brace_thickness, rack_width - 2 * rack_diameter, brace_height + rack_diameter / 2 + brace_thickness]);
    color("red")
    translate([0, -rack_width / 2, brace_height + rack_diameter / 2])
        cube([brace_width, rack_width, brace_thickness]);
}

module assemble() {
    join();
    
    intersection() {
        hull() join();
        union() {
            fender_radius = 195;
            translate([fender_radius, rack_width / 2 - rack_diameter, 0])
            rotate([90, 0, 0]) {
                difference() {
                    cylinder(h = rack_width - 2 * rack_diameter, r = fender_radius);
                    cylinder(h = rack_width - 2 * rack_diameter, r = fender_radius - brace_thickness);
                }
            }
        }
    }
}

rotate([0, -90, 0])
assemble();