bracket_depth = 80;

g1000_width = 312.00;
g1000_height = 217.00;
bezel_width = 3;
frame_width = g1000_width + 2 * bezel_width;
frame_height = 20; //g1000_height + 2 * bezel_width;

bracket_width = 50; //frame_width / 2;
bracket_bottom_thickness = bezel_width;

clasp_y_offset = 29;
clasp_thickness = 2;
clasp_hole_offset = 5.5;
clasp_hole_diameter = 3.0;
clasp_width = clasp_hole_offset * 2;
clasp_height = clasp_width;

ledge_forward_protrusion = 24;
ledge_thickness = 2;


module draw_bottom() {
    cube([bracket_width, bracket_depth, bracket_bottom_thickness]);
}

module draw_ledge() {
    translate([0, -ledge_forward_protrusion, -ledge_thickness])
        cube([bracket_width, bracket_depth + ledge_forward_protrusion, ledge_thickness]);
}

module draw_outer_side() {
    cube([bezel_width, clasp_y_offset + clasp_thickness, frame_height]);
}

module draw_clasp() {
    translate([bezel_width, clasp_y_offset, bracket_bottom_thickness]) {
        difference() {
            cube([clasp_width, clasp_thickness, clasp_height]);
            
            
            translate([clasp_hole_offset, clasp_thickness / 2, clasp_hole_offset])
                rotate([90, 0, 0])
                    cylinder(h = clasp_thickness, d = clasp_hole_diameter, center = true);
            
        }
    }
}

module draw_left() {
    draw_bottom();
    draw_outer_side();
    draw_clasp();
    draw_ledge();
}

module draw_right() {
    draw_bottom();
    translate([bracket_width - bracket_bottom_thickness, 0, 0])
        draw_outer_side();
    translate([bracket_width - 2 * bracket_bottom_thickness - clasp_width, 0, 0])
        draw_clasp();
    draw_ledge();
}

draw_left();
//draw_right();