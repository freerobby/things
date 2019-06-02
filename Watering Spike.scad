thickness = 1.0;

// Dimensions of main water tank
tank_radius = 36.0;
tank_lip = 6.0;

// Dimensions of pipe for main water tank
pipe_length = 30;
pipe_radius = 20;
pipe_min_radius = 6;

// Dimensions of spout
spout_length = 70;
spout_hole_radius = 1.0;
spout_min_radius = 3;
spout_hole_every = 25;

// Height at which pipe intersects with main water tank
intersection_height = sqrt(pow(tank_radius, 2) - pow(pipe_radius, 2));

// Dimensions of cap for main water tank
cap_height = 8;

module draw_spike() {
    translate([0, 0, tank_radius]) {
            draw_tank();
    translate([0, 0, intersection_height - thickness])
        draw_pipe();
    translate([0, 0, intersection_height + pipe_length - thickness])
        draw_spout();
    }
}

draw_spike();
//draw_cap();

// Draw Tank
module draw_tank() {
    difference() {
        sphere(r = tank_radius);
        sphere(r = tank_radius - thickness);
        
        // Crop out area above pipe connection
        translate([0, 0, intersection_height - thickness])
            cylinder(h = tank_radius, r = pipe_radius);
        
        // Crop out area below cylinder connection
        translate([0, 0, -tank_radius / 2])
            cube([2 * tank_radius, 2 * tank_radius, tank_radius], true);
    }
    
    // Draw the cylinder
    translate([0, 0, -tank_radius])
        difference() {
            cylinder(h = tank_radius, r = tank_radius);
            cylinder(h = tank_radius, r = tank_radius - thickness);
        }
        
    // Draw the lip
    translate([0, 0, -tank_radius])
        difference() {
            cylinder(h = thickness, r = tank_radius);
            cylinder(h = thickness, r = tank_radius - tank_lip);
        }
}

// Draw pipe
module draw_pipe() {
    difference() {
        cylinder(h = pipe_length, r1 = pipe_radius, r2 = pipe_min_radius);
        cylinder(h = pipe_length, r1 = pipe_radius - thickness, r2 = pipe_min_radius - thickness);
    }
}

// Draw spout
module draw_spout() {
    difference() {
        cylinder(h = spout_length, r1 = pipe_min_radius, r2 = spout_min_radius);
        cylinder(h = spout_length, r1 = pipe_min_radius - thickness, r2 = spout_min_radius - thickness);
        
        // Cut out water-flow holes
        for (this_hole_z = [spout_hole_radius:spout_hole_every:spout_length-spout_hole_radius]) {
            translate([0, 0, this_hole_z])
                rotate([0, 90, 0])
                    cylinder(h = pipe_radius, r = spout_hole_radius);
        }
    }
    
    // Seal top of spout
    translate([0, 0, spout_length])
        cylinder(h = thickness, r = spout_min_radius);
}

// Draw cap
module draw_cap() {
    union() {
        cylinder(h = thickness, r = tank_radius + thickness);
        difference() {
            cylinder(h = cap_height, r = tank_radius + thickness);
            cylinder(h = cap_height, r = tank_radius);
        }
    }
}


// V = (4 /3 ) * PI * r^3
volume_sphere = 4 / 3 * 3.14159265358595 * tank_radius * tank_radius * tank_radius / 2;
// V = PI * r^2 * h
volume_cylinder = 3.14159265358595 * tank_radius * tank_radius * tank_radius;
volume_oz = (volume_sphere + volume_cylinder) / 29573.5;
echo("Volume: ", volume_oz, " oz");