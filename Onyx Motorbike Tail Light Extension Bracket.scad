$fn = 50;

lower_rack_width = 153; // End to end
lower_rack_diameter = 9;
bracket_section_extra_height = 4;
bracket_overhang = 8;

tail_light_cutout_hole_diameter = 15;
tail_light_screw_hole_diameter = 7;
tail_light_hole_spacing = 66; // Center to center

holes_y_extra_offset = 3; // Amount to push mounting holes toward rear of bracket
left_hole_x_offset = lower_rack_width / 2 - tail_light_hole_spacing / 2 + bracket_overhang;
right_hole_x_offset = lower_rack_width / 2 + tail_light_hole_spacing / 2 + bracket_overhang;
bracket_depth = 30;
bracket_width = lower_rack_width + 2 * bracket_overhang;
bracket_section_height = lower_rack_diameter / 2 + bracket_section_extra_height;

module draw_tail_light_cutout_holes() {
    translate([left_hole_x_offset, bracket_depth / 2 - holes_y_extra_offset, 0])
        cylinder(h = bracket_section_height, d = tail_light_cutout_hole_diameter);
    translate([right_hole_x_offset, bracket_depth / 2 - holes_y_extra_offset, 0])
        cylinder(h = bracket_section_height, d = tail_light_cutout_hole_diameter);
}

module draw_tail_light_screw_holes() {
    translate([left_hole_x_offset, bracket_depth / 2 - holes_y_extra_offset, 0])
        cylinder(h = bracket_section_height, d = tail_light_screw_hole_diameter);
    translate([right_hole_x_offset, bracket_depth / 2 - holes_y_extra_offset, 0])
        cylinder(h = bracket_section_height, d = tail_light_screw_hole_diameter);
}

module draw_simulated_railings() {
    translate([lower_rack_diameter / 2 + bracket_overhang, 0, 0])
        rotate([-90, 0, 0])
            cylinder(h = bracket_depth, d = lower_rack_diameter);
    
    translate([lower_rack_width - lower_rack_diameter / 2 + bracket_overhang, 0, 0])
        rotate([-90, 0, 0])
            cylinder(h = bracket_depth, d = lower_rack_diameter);
}

module draw_upper_brace() {
    difference() {
        cube([bracket_width, bracket_depth, bracket_section_height]);
        
        draw_tail_light_screw_holes();
        draw_simulated_railings();
    }
}

module draw_lower_brace() {
    translate([0, 0, -bracket_section_height])
        difference() {
            cube([bracket_width, bracket_depth, bracket_section_height]);
            
            draw_tail_light_cutout_holes();
            translate([0, 0, bracket_section_height])
            draw_simulated_railings();
        }
}

draw_upper_brace();
draw_lower_brace();