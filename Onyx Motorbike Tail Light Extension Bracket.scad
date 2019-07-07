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

wire_guard_outer_diameter = 25.4;
wire_guard_thickness = 4;
wire_guard_total_height = 140;
wire_guard_cutout_width = 6;
wire_guard_total_length = 270;

module wire_guard_2d_base(rotation_angle = 0) {
    translate([wire_guard_outer_diameter / 2, 0, 0])
    rotate([0, 0, rotation_angle])
    difference() {
        circle(d = wire_guard_outer_diameter);
        circle(d = wire_guard_outer_diameter - wire_guard_thickness);
        translate([0, -wire_guard_cutout_width / 2])
            square([wire_guard_outer_diameter, wire_guard_cutout_width]);
    }
}

module draw_wire_guard() {
    // Lower curve near bracket
    translate([wire_guard_outer_diameter / 2, 0, wire_guard_outer_diameter]) {
        rotate([0, 90, 0]) {
            rotate_extrude(angle = 90) {
                wire_guard_2d_base(90);
            }
        }
    }
    
    // Upward pipe from bracket
    upper_section_from_bracket_height = wire_guard_total_height - 2 * wire_guard_outer_diameter;
    translate([0, wire_guard_outer_diameter / 2, wire_guard_outer_diameter]) {
        linear_extrude(height = upper_section_from_bracket_height) {
            wire_guard_2d_base();
        }
    }
    
    // Upper curve away from bracket
    translate([wire_guard_outer_diameter / 2, wire_guard_outer_diameter, wire_guard_outer_diameter + upper_section_from_bracket_height]) {
        rotate([0, -90, 0]) {
            rotate_extrude(angle = -90) {
                wire_guard_2d_base(-90);
            }
        }
    }
    
    // Lateral pipe into frame
    lateral_pipe_distance = wire_guard_total_length - wire_guard_outer_diameter;
    translate([0, wire_guard_total_length - wire_guard_outer_diameter + wire_guard_outer_diameter, wire_guard_outer_diameter / 2 + upper_section_from_bracket_height + wire_guard_outer_diameter]) {
        rotate([90, 0, 0]) {
            linear_extrude(height = lateral_pipe_distance) {
                wire_guard_2d_base();
            }
        }
    }
}

//draw_upper_brace();
//draw_lower_brace();
draw_wire_guard();