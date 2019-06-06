plate_width = 190;
plate_length = 94;
plate_height = 2;

plate_border = 4;
plate_border_height = 1;

cup_upper_diameter = 40;
cup_lower_diameter = 32;
cup_cutout_diameter = 17;
cup_height = 45;
cup_thickness = 2;
cup_rim_height = 2;
cup_rim_thickness = 1;

draw_plate();
//draw_cup();


module draw_plate() {
    rows = 2;
    cols = 4;
    x_spacing = (plate_width - cols * (cup_upper_diameter + cup_thickness)) / (cols + 1);
    y_spacing = (plate_length - rows * (cup_upper_diameter + cup_thickness)) / (rows + 1);
    difference() {
        cube([plate_width, plate_length, plate_height], false);
                
        for(row = [1:rows]) {
            for(col = [1:cols]) {
                x_offset = (cup_upper_diameter + cup_thickness + x_spacing) * col - (cup_upper_diameter + cup_thickness) / 2;
                y_offset = (cup_upper_diameter + cup_thickness + y_spacing) * row - (cup_upper_diameter + cup_thickness) / 2;
                
                translate([x_offset, y_offset, -cup_height + plate_height])
                    cylinder(d1 = cup_lower_diameter + cup_thickness, d2 = cup_upper_diameter + cup_thickness, h = cup_height);
            }
        }
        
    }
    
    // Draw border: B, T, L, R
    translate([-plate_border, -plate_border, 0])
        cube([plate_width + 2 * plate_border, plate_border, plate_border_height]);
    translate([-plate_border, plate_length, 0])
        cube([plate_width + 2 * plate_border, plate_border, plate_border_height]);
    translate([-plate_border, -plate_border, 0])
        cube([plate_border, plate_length + 2 * plate_border, plate_border_height]);
    translate([plate_width, -plate_border, 0])
        cube([plate_border, plate_length + 2 * plate_border, plate_border_height]);
}

module draw_cup() {
    difference() {
        cylinder(d1 = cup_lower_diameter + cup_thickness, d2 = cup_upper_diameter + cup_thickness, h = cup_height);
        cylinder(d1 = cup_lower_diameter, d2 = cup_upper_diameter, h = cup_height);
    }
    
    slope=(cup_upper_diameter-cup_lower_diameter)/(cup_height - 0); //m = (y2-y1)/(x2-x1)
    difference() {
        cylinder(d1 = cup_lower_diameter, d2 = cup_lower_diameter + slope * cup_thickness, h = cup_thickness);
        cylinder(d = cup_cutout_diameter, h = cup_thickness);
    }
    translate([0, 0, cup_height])
        difference() {
            cylinder(d1 = cup_upper_diameter + cup_thickness, d2 = cup_upper_diameter + cup_thickness + 2 * cup_rim_thickness, h = cup_rim_height);
            cylinder(d1 = cup_upper_diameter, d2 = cup_upper_diameter + slope * cup_rim_height, h = cup_rim_height);
        }
}