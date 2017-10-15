$fn = 100;

thickness = 1.0;
height = 31;
width = 80;

top_arch_radius = 10;
top_arch_extension_angle = 60;
bottom_arch_radius = 5;
bottom_arch_extension_angle = 60;

// Base plate
cube([width, thickness, height]);

// Upper grasp
translate([width, 0, -top_arch_radius + height])
    rotate([90, -90, -90])
        rotate_extrude(angle = top_arch_extension_angle)
            translate([top_arch_radius, 0, 0])
                square([thickness, width]);
                

// Lower grasp
translate([0, 0, bottom_arch_radius])
    rotate([90, 90, 90])
        rotate_extrude(angle = bottom_arch_extension_angle)
            translate([bottom_arch_radius, 0, 0])
                square([thickness, width]);

// Handle
handle_depth = 10;
handle_reinforcement_depth = 2;
handle_thickness = 2;

grip_depth = 2;
grip_height = 4;

// Extension
translate([0, -handle_depth, (height - handle_thickness) / 2])
    cube([width, handle_depth, handle_thickness]);
    
// Friction grip
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
