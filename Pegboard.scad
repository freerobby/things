$fn = 10;

width_in_inches = 4;
length_in_inches = 4;

height = 4.7625; // 3/16"
hole_diameter = 6;

accessory_hole_diameter = 4;
accessory_hole_inset_diameter = 8;
accessory_hole_inset_height = 3;


MM_PER_INCH = 25.4;
width = width_in_inches * MM_PER_INCH;
length = length_in_inches * MM_PER_INCH;

board();

// Draw the board
module board() {
    difference() {
        cube([width, length, height]);
      
        holes();
        accessory_holes();
    }
}

// Draw the holes
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