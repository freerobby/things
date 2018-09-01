$fn = 100;
vial_outer_diameter = 16.0;
vial_inner_diameter = 14.0;
lip_height = 0.5;
centering_ring_height = 1.0;
depth_into_vial = 55;

converter_plastic_inner_diameter = 5.75;
converter_plastic_outer_diameter = 7.5;
converter_plastic_height = 8.0; // Err large here for a tight fit with the metal insert

fitting_excess_height = 1.0 - lip_height; // We want a total of 1mm on the bottom of the fitting
fitting_excess_diameter = 2; // 1 mm wall all the way around

fitting_height = converter_plastic_height + fitting_excess_height + lip_height;

hose_inner_diameter = 2.0;
hose_outer_diameter = 4.0;
hose_height = depth_into_vial - fitting_height;

module fitting() {
    difference() {
        union() {
            // Create a solid base for the converter to be pushed into.
            cylinder(h = converter_plastic_height + fitting_excess_height, d = converter_plastic_outer_diameter + fitting_excess_diameter);
            // Draw the centering ring
            translate([0, 0, fitting_height - lip_height - centering_ring_height])
                cylinder(h = centering_ring_height, d = vial_inner_diameter);
            // Draw the lip
            translate([0, 0, converter_plastic_height + fitting_excess_height])
                cylinder(h = lip_height, d = vial_outer_diameter);
        }
    
        // Cut out space for plastic converter insert
        translate([0, 0, fitting_height - converter_plastic_height]) {
            difference() {
                cylinder(h = converter_plastic_height, d = converter_plastic_outer_diameter);
                
                // Keep the top half constant
                translate([0, 0, converter_plastic_height / 2])
                    cylinder(h = converter_plastic_height / 2, d = converter_plastic_inner_diameter);
                
                // Contour the bottom half to create a fit-mount
                cylinder(
                    h = converter_plastic_height,
                    d1 = converter_plastic_outer_diameter,
                    d2 = converter_plastic_inner_diameter
                );
            }
        }
        
        // Cut out air gap for hose
        cylinder(h = fitting_height, d = hose_inner_diameter);
    }
}

module hose() {
    straight_height = hose_height - hose_outer_diameter / 2;
    difference() {
        union() {
            translate([0, 0, hose_outer_diameter / 2])
                cylinder(h = straight_height, d = hose_outer_diameter);
            translate([0, 0, hose_outer_diameter / 2])
                sphere(d = hose_outer_diameter);
        }
        cylinder(h = hose_height, d = hose_inner_diameter);
    }
}

module build() {
    hose();
    translate([0, 0, hose_height])
        fitting();
}

build();
