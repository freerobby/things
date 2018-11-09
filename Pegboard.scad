$fn = 15;

width_in_inches = 10;
length_in_inches = 9;

height = 4.5;
hole_diameter = 6;

accessory_hole_diameter = 4;
accessory_hole_inset_diameter = 9;
accessory_hole_inset_height = 3;

spacer_height = 13;
spacer_diameter = 8;

hollow_width = 8;
hollow_area_thickness = 2;


MM_PER_INCH = 25.4;
width = width_in_inches * MM_PER_INCH;
length = length_in_inches * MM_PER_INCH;

coupler();
//board();

module coupler() {
    spacer();
    
    translate([2 * MM_PER_INCH, 0, 0])
        spacer();
    
    translate([0, -spacer_diameter / 2, 0])
        cube([2 * MM_PER_INCH, spacer_diameter, spacer_height]);
}

module joiner_n(n) {
    max_index = sqrt(n) - 1;
    for (x = [0 : 1 : max_index]) {
        for (y = [0 : 1 : max_index]) {
            translate([x * MM_PER_INCH, y * MM_PER_INCH, 0])
                spacer();
        }
    }
    
    translate([-spacer_diameter / 2, 0, 0])
        cube([max_index * MM_PER_INCH + spacer_diameter, max_index * MM_PER_INCH, spacer_height / 2]);
    translate([0, -spacer_diameter / 2, 0])
        cube([max_index * MM_PER_INCH, max_index * MM_PER_INCH + spacer_diameter, spacer_height / 2]);
}

module joiner_16() {
    joiner_n(16);
}

module joiner_4() {
    max_index = 2;
    for (x = [0 : 2 : max_index]) {
        for (y = [0 : 2 : max_index]) {
            translate([x * MM_PER_INCH, y * MM_PER_INCH, 0])
                spacer();
        }
    }
    
    translate([-spacer_diameter / 2, 0, 0])
        cube([max_index * MM_PER_INCH + spacer_diameter, max_index * MM_PER_INCH, spacer_height / 2]);
    translate([0, -spacer_diameter / 2, 0])
        cube([max_index * MM_PER_INCH, max_index * MM_PER_INCH + spacer_diameter, spacer_height / 2]);
}

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
        //hollow_board();
    }
}

module hollow_board() {
    module draw_row(row) {
        hollow_length = min(width_in_inches - row - 0.5, length_in_inches - 1) * MM_PER_INCH * sqrt(2);
        
        translate([(row - 0.5) * MM_PER_INCH, 0, 0])
            translate([MM_PER_INCH * sqrt(2) / 3, MM_PER_INCH * sqrt(2) / 3, 0])
                rotate([0, 0, 45])
                    translate([hollow_length / 2, 0, 0]) {
                        
                        cube([hollow_length, hollow_width, height], center = true);
                        translate([-hollow_length / 2, 0, 0])
                            cylinder(h = height, d = hollow_width, center = true);
                        translate([hollow_length / 2, 0, 0])
                            cylinder(h = height, d = hollow_width, center = true);
                    }
    }
    
    module draw_col(col, cols) {
        hollow_length = min(length_in_inches - (cols - col + 1) - 0.5, width_in_inches - 1) * MM_PER_INCH * sqrt(2);
        
        translate([0, (cols - col + 0.5) * MM_PER_INCH, 0])
            translate([MM_PER_INCH * sqrt(2) / 3, MM_PER_INCH * sqrt(2) / 3, 0])
                rotate([0, 0, 45])
                    translate([hollow_length / 2, 0, 0]) {
                        cube([hollow_length, hollow_width, height], center = true);
                        translate([-hollow_length / 2, 0, 0])
                            cylinder(h = height, d = hollow_width, center = true);
                        translate([hollow_length / 2, 0, 0])
                            cylinder(h = height, d = hollow_width, center = true);
                    }

    }
    
    rows = width_in_inches - 1;
    for (row = [1 : 1 : rows]) {
        translate([0, 0, height / 2 + hollow_area_thickness])
        draw_row(row);
        
        translate([0, length, height / 2 + hollow_area_thickness])
            rotate([180, 0, 0])
                draw_row(row);
    }
    
    cols = length_in_inches - 1;
    for (col = [1 : 1 : cols]) {
        translate([0, 0, height / 2 + hollow_area_thickness])
        draw_col(col, cols);
        
        translate([0, length, height / 2 + hollow_area_thickness])
            rotate([180, 0, 0])
                draw_col(col, cols);
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