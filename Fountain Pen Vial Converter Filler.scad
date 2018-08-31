$fn = 50;
vial_outer_diameter = 11;
lip_height = 0.5;
depth_into_vial = 55;

converter_metal_inner_diameter = 2.0625;
converter_metal_outer_diameter = 3.5;
converter_metal_height = 6.0; // Err slightly small here for a tight fit to create the vacuum.

converter_plastic_inner_diameter = 6.0;
converter_plastic_outer_diameter = 6.75;
converter_plastic_height = 14.0; // Err large here for a tight fit with the metal insert

fitting_excess_height = 2;
fitting_excess_diameter = 2;

fitting_height = converter_plastic_height + fitting_excess_height + lip_height;

hose_inner_diameter = 1.0;
hose_outer_diameter = 3.0;
hose_height = depth_into_vial - fitting_height;

module fitting() {
    difference() {
        union() {
            // Create a solid base for the converter to be pushed into.
            cylinder(h = converter_plastic_height + fitting_excess_height, d = converter_plastic_outer_diameter + fitting_excess_diameter);
            // Draw the lip
            translate([0, 0, converter_plastic_height + fitting_excess_height])
                cylinder(h = lip_height, d = vial_outer_diameter);
        }
        
        // Cut out space for metal converter insert
        translate([0, 0, fitting_height - converter_metal_height])
            cylinder(h = converter_metal_height, d = converter_metal_outer_diameter);
    
        // Cut out space for plastic converter insert
        translate([0, 0, fitting_height - converter_plastic_height]) {
            difference() {
                cylinder(h = converter_plastic_height, d = converter_plastic_outer_diameter);
                cylinder(h = converter_plastic_height, d = converter_plastic_inner_diameter);
            }
        }
        
        // Cut out air gap for hose
        cylinder(h = fitting_height, d = hose_inner_diameter);
    }
}

module hose() {
    difference() {
        cylinder(h = hose_height, d = hose_outer_diameter);
        cylinder(h = hose_height, d = hose_inner_diameter);
    }
}

module build() {
    hose();
    translate([0, 0, hose_height])
        fitting();
}

build();
