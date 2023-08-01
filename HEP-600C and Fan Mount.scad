$fn = 20;

chassis_width = 49.2125;

short_wall_height = 12;
tall_wall_height = 142.875;
wall_width = 6;
wall_length = 25;

vertical_spacing = 10;

module draw_riser() {
    cube([chassis_width + 2 * wall_width, wall_length, vertical_spacing]);
}

module draw_short_wall() {
    cube([wall_width, wall_length, short_wall_height]);
}
module draw_tall_wall() {
    knob_curve_diameter = 4.5;
    knob_protrusion = 4;
    knob_center_y_offset = 8 - knob_curve_diameter / 2;
    knob_flat_length = 6;
    
    knob_z_offsets = [23.8, 120.65];
    
    hole_radius = 3.2;
    hole_z_offsets = [19, 129];
    
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

color("blue") {
    draw_riser();
}

color("yellow") {
    translate([0, 0, vertical_spacing])
        draw_short_wall();

    translate([chassis_width + wall_width, 0, vertical_spacing])
        draw_tall_wall();
}