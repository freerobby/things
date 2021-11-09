$fn = 100;
    
lid_clearance_diameter = 104.0;
lid_protruding_edge_width = 2.0;
lid_protruding_edge_height = 5.0;
lid_thickness = 1.0;

center_hole_diameter = 3;

sipping_area_small_diameter = 4;
sipping_area_ratio = 3;

vent_area_ratio = 3;
vent_each_width = 2;
vent_each_spacing = 2;
vent_area_small_diameter = (vent_each_width + vent_each_spacing) * 4 - vent_each_spacing;

clasp_diameter = 20;

mouth_protector_height = 15;
mouth_protector_angle = 30;

difference() {
    // Base of lid
    cylinder(h = lid_thickness, d = lid_clearance_diameter);
    
    // Center hole
    cylinder(h= lid_thickness, d = center_hole_diameter);
    

    // Sipping area
    translate([0, -lid_clearance_diameter / 2 + sipping_area_small_diameter * 1.5, 0])
        scale([sipping_area_ratio, 1, 1])
            cylinder(h = lid_thickness, d = sipping_area_small_diameter);
    
    // Vent area
    translate([0, lid_clearance_diameter / 2 - vent_area_small_diameter, 0])
            difference() {
                scale([vent_area_ratio, 1, 1])
                    cylinder(h = lid_thickness, d = vent_area_small_diameter);
                for (i = [-vent_area_small_diameter * vent_area_ratio / 2 : vent_each_width + vent_each_spacing : vent_area_small_diameter * vent_area_ratio / 2]) {
                    translate([i, -vent_area_small_diameter / 2, 0])
                        cube([vent_each_spacing, vent_area_small_diameter, lid_thickness]);
                }
            };
};

// Lip
rotate_extrude(angle = 360) {
    rotate([0, 0, 90])
    translate([0, -(lid_clearance_diameter + 2 * lid_protruding_edge_width) / 2])
        square([lid_thickness + lid_protruding_edge_height, lid_protruding_edge_width]);
};

// Clasp
difference() {
    rotate([0, 0, 45])
        translate([(lid_clearance_diameter + 2 * lid_protruding_edge_width) / 2, 0, 0])
            cylinder(h = lid_thickness + lid_protruding_edge_height, d = clasp_diameter);
    
    cylinder(h = lid_thickness + lid_protruding_edge_height, d = lid_clearance_diameter + 2 * lid_protruding_edge_width);
}

// Mouth Protector
rotate([0, 0, -90 - mouth_protector_angle / 2])
rotate_extrude(angle = mouth_protector_angle) {
    rotate([0, 0, 90])
    translate([0, -(lid_clearance_diameter + 2 * lid_protruding_edge_width) / 2])
        square([mouth_protector_height, lid_protruding_edge_width]);
};