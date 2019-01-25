$fn = 50;

connection_bottom_thickness = 1;

pin_diameter = 1.0;
pin_center_spacing = 2;

alignment_cylinder_inner_diameter = 3.5;
alignment_cylinder_outer_diameter = 4.5;
alignment_cylinder_height = 8;

housing_width = 12;
housing_length = 13;
housing_height = 10;

grab_diameter = housing_length * sqrt(2);
grab_thickness = 2;

module wire_paths() {
    translate([-pin_center_spacing / 2, -pin_center_spacing / 2, 0])
        cylinder(h = housing_height, d = pin_diameter);
    translate([-pin_center_spacing / 2, pin_center_spacing / 2, 0])
        cylinder(h = housing_height, d = pin_diameter);
    translate([pin_center_spacing / 2, -pin_center_spacing / 2, 0])
        cylinder(h = housing_height, d = pin_diameter);
    translate([pin_center_spacing / 2, pin_center_spacing / 2, 0])
        cylinder(h = housing_height, d = pin_diameter);
}

module connector_guide() {
    translate([-0.5, -alignment_cylinder_inner_diameter / 2, 0])
        linear_extrude(height = alignment_cylinder_height)
            polygon([[0, 0], [1, 0], [0.5, 0.5]]);
}

module connector() {
    // Alignment ring around connections
    /*
    difference() {
        cylinder(h = alignment_cylinder_height, d = alignment_cylinder_outer_diameter);
        cylinder(h = alignment_cylinder_height, d = alignment_cylinder_inner_diameter);
    }
    */

    // Bottom/base of connections
    difference() {
        cylinder(h = connection_bottom_thickness, d = alignment_cylinder_outer_diameter);
        
        wire_paths();
    }
    
    /*
    connector_guide();
    rotate([0, 0, -90])
        connector_guide();
    rotate([0, 0, 90])
        connector_guide();
    */
}

housing_lower_thickness = 1;
housing_cutout_diameter = 9.5;

module housing() {
    difference() {
        cylinder(h = grab_thickness, d = grab_diameter);
        wire_paths();
        // Cut out upper recess latch
        translate([0, housing_cutout_diameter / 2, housing_height / 2])
            cube([3.25, 7/2, housing_height], center = true);
    }
    difference() {
        translate([0, 0, housing_height / 2])
            cube([housing_width, housing_length, housing_height], center = true);
        
        translate([0, 0, housing_lower_thickness]) {
            // Cut out center circle
            cylinder(h = housing_height - housing_lower_thickness, d = housing_cutout_diameter);
            
            // Cut out upper rectangle
            translate([0, 3.5, (housing_height - housing_lower_thickness) / 2])
                cube([housing_cutout_diameter, 1.5, housing_height - housing_lower_thickness], center = true);
            
            // Cut out lower rectangle
            translate([0, -3.5, (housing_height - housing_lower_thickness) / 2])
                cube([housing_cutout_diameter, 1.5, housing_height - housing_lower_thickness], center = true);
            
            // Cut out center rectangle
            translate([0, 0, (housing_height - housing_lower_thickness) / 2])
                cube([housing_cutout_diameter, 3.0, housing_height - housing_lower_thickness], center = true);
            
            // Cut out lower recess
            translate([0, -housing_cutout_diameter/2, (housing_height - housing_lower_thickness) / 2])
                cube([1.5, 5/2, housing_height - housing_lower_thickness], center = true);
        }
        
        // Cut out upper recess
        translate([0, housing_cutout_diameter / 2, housing_height / 2])
            cube([3.25, 7/2, housing_height], center = true);
        
        // Cut out wire pass-thru
        wire_paths();
    }
}

housing();
connector();