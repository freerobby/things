bracket_width = 275;
bracket_depth = 55;
bracket_thickness = 25.4 * 0.75;
honeycomb_hole_diameter = 5;
honeycomb_hole_upper_diameter = 10;
honeycomb_hole_upper_depth = 2;
honeycomb_spacings = [0, 93.5, 133.5, 227];
honeycomb_hole_y_offset = 33;

latch_width = 30;
latch_depth = 40;
latch_thickness = 10;
latch_lateral_play = 1;

drywall_hole_diameter = 4;
drywall_hole_lower_diameter = 9;
drywall_hole_lower_depth = 4;

module draw_full_bracket() {
    difference() {
        union() {
            // Left latch
            draw_latch();
            // Left mount
            translate([latch_width, 0, 0])
                draw_single_bracket();
            // Right latch
            translate([latch_width + bracket_width, 0, 0])
                draw_latch();
        }
        
        translate([latch_width / 2, bracket_depth / 2, 0]) {
            cylinder(h = bracket_thickness, d = drywall_hole_diameter);
            cylinder(h = drywall_hole_lower_depth, d = drywall_hole_lower_diameter);
        }
        
        translate([latch_width + bracket_width + latch_width / 2, bracket_depth / 2, 0]) {
            cylinder(h = bracket_thickness, d = drywall_hole_diameter);
            cylinder(h = drywall_hole_lower_depth, d = drywall_hole_lower_diameter);
        }
    }
}

module draw_left_bracket() {
    intersection() {
        draw_full_bracket();
        cube([(bracket_width / 2 + latch_width), bracket_depth, bracket_thickness]);
    }
}
module draw_right_bracket() {
    intersection() {
        draw_full_bracket();
        translate([(bracket_width / 2 + latch_width), 0, 0])
            cube([(bracket_width / 2 + latch_width), bracket_depth, bracket_thickness]);
    }
}

module draw_latch() {
    translate([0, (bracket_depth - latch_depth) / 2, bracket_thickness - latch_thickness])
        cube([latch_width, latch_depth, latch_thickness]);
}

module draw_latch_enclosure() {
    difference() {
        cube([latch_width * 2, bracket_depth, bracket_thickness]);
        
        translate([latch_width, latch_lateral_play / 2, 0])
            draw_latch();
        translate([latch_width, -latch_lateral_play / 2, 0])
            draw_latch();
        
        translate([latch_width / 2, bracket_depth / 2, 0]) {
            cylinder(h = bracket_thickness, d = drywall_hole_diameter);
            cylinder(h = drywall_hole_lower_depth, d = drywall_hole_lower_diameter);
        }
        
        translate([3 * latch_width / 2, bracket_depth / 2, 0]) {
            cylinder(h = bracket_thickness, d = drywall_hole_diameter);
            cylinder(h = drywall_hole_lower_depth, d = drywall_hole_lower_diameter);
        }
    }
}

module draw_latch_middle_enclosure() {
    difference() {
        cube([latch_width * 3, bracket_depth, bracket_thickness]);
        
        translate([0, latch_lateral_play / 2, 0])
            draw_latch();
        translate([0, -latch_lateral_play / 2, 0])
            draw_latch();
        
        translate([latch_width * 2, latch_lateral_play / 2, 0])
            draw_latch();
        translate([latch_width * 2, -latch_lateral_play / 2, 0])
            draw_latch();
        
        translate([latch_width * 3 / 2, bracket_depth / 2, 0]) {
            cylinder(h = bracket_thickness, d = drywall_hole_diameter);
            cylinder(h = drywall_hole_lower_depth, d = drywall_hole_lower_diameter);
        }
        
        translate([latch_width / 2, bracket_depth / 2, 0]) {
            cylinder(h = bracket_thickness, d = drywall_hole_diameter);
            cylinder(h = drywall_hole_lower_depth, d = drywall_hole_lower_diameter);
        }
        
        translate([5 * latch_width / 2, bracket_depth / 2, 0]) {
            cylinder(h = bracket_thickness, d = drywall_hole_diameter);
            cylinder(h = drywall_hole_lower_depth, d = drywall_hole_lower_diameter);
        }
    }
}

module draw_single_bracket() {
    difference() {
        cube([bracket_width, bracket_depth, bracket_thickness]);
        
        draw_holes(honeycomb_spacings);
    }
}

module draw_holes(spacings) {
    side_spacing = (bracket_width - max(spacings)) / 2;
    
    // Draw lowers
    for (x_offset = spacings) {
        translate([x_offset + honeycomb_hole_diameter / 2 + side_spacing, honeycomb_hole_y_offset, 0])
            cylinder(h = bracket_thickness, d = honeycomb_hole_diameter);
    }
    
    // Draw uppers
    for (x_offset = spacings) {
        translate([x_offset + honeycomb_hole_diameter / 2 + side_spacing, honeycomb_hole_y_offset, bracket_thickness - honeycomb_hole_upper_depth])
            cylinder(h = honeycomb_hole_upper_depth, d = honeycomb_hole_upper_diameter);
    }
}

//draw_left_bracket();
//draw_right_bracket();

//draw_full_bracket();
//draw_latch_enclosure();
draw_latch_middle_enclosure();