$fn = 100;

thickness = 1;
height = 32;
width = 10;

top_arch_radius = 10;
top_arch_extension_angle = 150;
bottom_arch_radius = 7;
bottom_arch_extension_angle = 80;

relief_radius = 1;
relief_angle = 180;

handle_depth = 10;
handle_reinforcement_depth = 2;
handle_thickness = 2;

grip_depth = 2;
grip_height = 4;

rotate([0, -90, 0])
union() {
// Base plate
translate([0, 0, 2 * relief_radius])    
    cube([width, thickness, height - 4 * relief_radius]);

// Upper grasp
translate([width, 0, -top_arch_radius + height])
    rotate([90, -90, -90])
        rotate_extrude(angle = top_arch_extension_angle)
            translate([top_arch_radius, 0, 0])
                square([thickness, width]);
// Upper grasp relief
translate([0, 0, -relief_radius + height])
    rotate([90, -90, 90])
        rotate_extrude(angle = relief_angle)
            translate([relief_radius, 0, 0])
                square([thickness, width]);
                

// Lower grasp
translate([0, 0, bottom_arch_radius])
    rotate([90, 90, 90])
        rotate_extrude(angle = bottom_arch_extension_angle)
            translate([bottom_arch_radius, 0, 0])
                square([thickness, width]);
// Lower grasp relief
translate([width, 0, relief_radius])
    rotate([90, 90, -90])
        rotate_extrude(angle = relief_angle)
            translate([relief_radius, 0, 0])
                square([thickness, width]);

// Handle extension
translate([0, -handle_depth, (height - handle_thickness) / 2])
    cube([width, handle_depth, handle_thickness]);
    
// Handle friction grip
translate([0, -handle_depth - grip_depth, (height - grip_height) / 2])
    difference() {
        cube([width, grip_depth, grip_height]);
        
        translate([0, grip_depth, grip_height / 2 + grip_depth + handle_thickness / 2])
            rotate([0, 90, 0])
                cylinder(h = width, r = grip_depth);
        
        translate([0, grip_depth, grip_height / 2 - grip_depth - handle_thickness / 2])
            rotate([0, 90, 0])
                cylinder(h = width, r = grip_depth);
    }
    
// Reinforcement
translate([0, -handle_reinforcement_depth, (height - handle_thickness) / 2 + handle_thickness])
    difference() {
        cube([width, handle_reinforcement_depth, handle_reinforcement_depth]);

        translate([0, 0, handle_reinforcement_depth])
            rotate([0, 90, 0])
                cylinder(h = width, r = handle_reinforcement_depth);
    }
    
translate([0, -handle_reinforcement_depth, (height - handle_thickness) / 2 - handle_thickness])
    difference() {
        cube([width, handle_reinforcement_depth, handle_reinforcement_depth]);
        
        translate([0, 0, 0])
            rotate([0, 90, 0])
                cylinder(h = width, r = handle_reinforcement_depth);
    }
}