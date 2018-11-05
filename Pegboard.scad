$fn = 15;

width_in_inches = 10;
length_in_inches = 10;

height = 4.5;
hole_diameter = 6;

accessory_hole_diameter = 4;
accessory_hole_inset_diameter = 9;
accessory_hole_inset_height = 3;

spacer_height = 13;
spacer_diameter = 8;


MM_PER_INCH = 25.4;
width = width_in_inches * MM_PER_INCH;
length = length_in_inches * MM_PER_INCH;

board();
//screw_spacer();
//spacer();

module screw_spacers() {
    for (i = [1 : 1 : 4]) {
        translate([-spacer_diameter / 2 - 3, i * (spacer_diameter + 3), 0]) {
            screw_spacer();
        }
    }
}


module board() {
    difference() {
        cube([width, length, height]);
      
        holes();
        accessory_holes();
    }
}

module holes() {
    for (row = [1 : 1 : width_in_inches]) {
        for (col = [1 : 1 : length_in_inches]) {
            translate([row * MM_PER_INCH - MM_PER_INCH/2, col * MM_PER_INCH - MM_PER_INCH/2, height / 2])
                cylinder(h = height, d = hole_diameter, center = true);
        }
    }
}

module accessory_holes() {
    for (row = [1 : 1 : width_in_inches - 1]) {
        for (col = [1 : 1 : length_in_inches - 1]) {
            translate([row * MM_PER_INCH, col * MM_PER_INCH, height / 2])
                cylinder(h = height, d = accessory_hole_diameter, center = true);
            
            translate([row * MM_PER_INCH, col * MM_PER_INCH, height - (accessory_hole_inset_height / 2)])
                cylinder(h = accessory_hole_inset_height, d = accessory_hole_inset_diameter, center = true);
        }
    }
}

module spacer() {
    hole_length = height - accessory_hole_inset_height;
    horizontal_overlap = 1;
    
    // Spacer
    color("cyan")
        cylinder(h = spacer_height, d = spacer_diameter);
    
    // Latch
    translate([0, 0, spacer_height])
        difference() {
            union() {
                color("yellow")
                cylinder(h = hole_length, d = accessory_hole_diameter);
                
                translate([horizontal_overlap / 3, 0, hole_length + horizontal_overlap])
                    color("red")
                        sphere(d = accessory_hole_diameter);
                translate([-horizontal_overlap / 3, 0, hole_length + horizontal_overlap])
                    color("red")
                        sphere(d = accessory_hole_diameter);
            }
            
            translate([-horizontal_overlap / 2, -accessory_hole_diameter / 2, 0])
                cube([horizontal_overlap, accessory_hole_diameter, hole_length + accessory_hole_inset_height]);
        }
}

module screw_spacer() {
    // Spacer
    color("cyan")
        difference() {
            cylinder(h = spacer_height, d = spacer_diameter);
            
            cylinder(h = spacer_height, d = accessory_hole_diameter);
        }
}