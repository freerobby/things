$fn = 100;

rack_diameter = 10;
rack_width = 155;

brace_height = 180;
brace_width = 240 / 3;
brace_thickness = 5;

support_width = 5;
support_height = 10;
support_inset = 3;
support_every = 30;

module draw_support() {
    cube([support_height, support_width, rack_width + support_inset * 2]);
}

module draw_brace() {
    // Support portion
    difference() {
        cube([brace_width, brace_thickness, brace_height]);
        
        // Center support areas
        for (i = [(rack_diameter / 2):support_every:brace_height]) {
            offset = rack_diameter + brace_width;
            
            translate([brace_width / 3 - support_width / 2, brace_thickness - support_inset, brace_height - i - support_height])
                cube([support_width, support_inset, support_height]);
            translate([brace_width / 3 * 2 - support_width / 2, brace_thickness - support_inset, brace_height - i - support_height])
                cube([support_width, support_inset, support_height]);
        }
    }
        
    // Top portion
    translate([0, 0, brace_height])
    difference() {
        cube([brace_width, rack_diameter + 2 * brace_thickness, rack_diameter]);
        
        translate([0, brace_thickness + rack_diameter / 2, 0])
        rotate([0, 90, 0])
        cylinder(h = brace_width, d = rack_diameter);
    }
}

translate([0, brace_height + rack_diameter, 0])
rotate([90, 0, 0])
draw_brace();



/*
translate([0, support_height, 0])
    rotate([-90, 0, 0])
        draw_support();
*/