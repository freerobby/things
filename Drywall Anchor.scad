$fn = 40;

length = 22;
taper_distance = 7;

screw_solid_diameter = 2.4;
screw_thread_diameter = 4;
screw_tension_adding_diameter = 0.5; // How much extra diameter (other than the thread diameter) to create by pressing the screw in.

pilot_hole_diameter = 6.35;
separator_thickness = 1.0;

flange_thickness = 1;
flange_protrusion = 1;
taper_angle = -5;

difference() {
    cylinder(d = pilot_hole_diameter, h = length);
    
    // Threaded screw hole for the taper
    cylinder(d = screw_thread_diameter, h = taper_distance);
    // Transition to solid screw hole the rest of the way
    translate([0, 0, taper_distance])
        cylinder(d1 = screw_thread_diameter, d2 = screw_solid_diameter - screw_tension_adding_diameter, h = length - taper_distance);
    
    // Create separator
    separator_length = length - taper_distance;
    translate([0, 0, separator_length / 2 + taper_distance])
        cube([separator_thickness, pilot_hole_diameter, separator_length], center = true);
    rotate([0, 0, 90])
    translate([0, 0, separator_length / 2 + taper_distance])
        cube([separator_thickness, pilot_hole_diameter, separator_length], center = true);
}

// Create flanges
for (i = [0 : 1 : 3]) {
    rotate([0, 0, 45 + i * 90])
        flange();
}

module flange() {
    circular_segment_offset = (pilot_hole_diameter / 2) - sqrt((pilot_hole_diameter / 2) * (pilot_hole_diameter / 2) - flange_thickness * flange_thickness / 4);
    translate([pilot_hole_diameter / 2 - circular_segment_offset, flange_thickness / 2, 0])
    rotate([90, 0, 0])
    linear_extrude(height = flange_thickness)
    polygon(points = 
        [
            [0, 0], [flange_protrusion, 0], [0, length]
        ]
    );
}
