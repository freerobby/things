shelf_width = 271;
shelf_depth = 178;
shelf_height = 5;

rear_cutout_width = 165;
rear_cutout_depth = 26;

backrest_depth = 7;
backrest_height = 40;

backrest_center_clearance = 120;

left_lip_height = 12;
left_lip_width = 3;

back_brace_diameter = 30;

rounding_radius = 1.5;

module shelf() {
//    cube([shelf_width, shelf_depth, shelf_height]);
    roundedcube([shelf_width, shelf_depth, shelf_height], radius = rounding_radius, apply_to = "ymin");
    
    back_brace();
}

module back_brace() {
    translate([rounding_radius, shelf_depth - back_brace_diameter,shelf_height])
    difference() {
        cube([shelf_width - 2 * rounding_radius, back_brace_diameter, back_brace_diameter]);
        
        translate([0, back_brace_diameter / 2, back_brace_diameter / 2])
            rotate([0, 90, 0])
                cylinder(h = shelf_width, d = back_brace_diameter);

        translate([0, -back_brace_diameter / 2, 0])
            cube([shelf_width, back_brace_diameter, back_brace_diameter]);
        
        translate([0, 0, back_brace_diameter / 2])
            cube([shelf_width, back_brace_diameter, back_brace_diameter]);
    };
}

module rear_cutout() {
    translate([(shelf_width-rear_cutout_width)/2, shelf_depth - rear_cutout_depth, 0])
        cube([rear_cutout_width, rear_cutout_depth, shelf_height + back_brace_diameter]);
    
    translate([(shelf_width - rear_cutout_width) / 2, shelf_depth - rear_cutout_depth + (rear_cutout_depth / 2), 0])
        cylinder(h = shelf_height + back_brace_diameter, d = rear_cutout_depth);
    
    translate([(shelf_width + rear_cutout_width) / 2, shelf_depth - rear_cutout_depth + (rear_cutout_depth / 2), 0])
        cylinder(h = shelf_height + back_brace_diameter, d = rear_cutout_depth);
}

module backrest() {
    translate([0, shelf_depth, 0])
        difference() {
            cube([shelf_width, backrest_depth, backrest_height]);
            
            translate([(shelf_width - backrest_center_clearance - backrest_height) / 2, 0, 0])
                cube([backrest_center_clearance + backrest_height, backrest_depth, backrest_height]);
        }
                
    translate([(shelf_width - backrest_center_clearance) / 2 - backrest_height /2, shelf_depth + backrest_depth, backrest_height / 2])
        rotate([90, 0, 0])
            cylinder(h = backrest_depth, d = backrest_height);
        
    translate([(shelf_width + backrest_center_clearance) / 2 + backrest_height / 2, shelf_depth + backrest_depth, backrest_height / 2])
        rotate([90, 0, 0])
            cylinder(h = backrest_depth, d = backrest_height);
}

module left_lip() {
    roundedcube([left_lip_width, shelf_depth, shelf_height + left_lip_height], radius = rounding_radius, apply_to = "ymin");
}

difference() {
    shelf();
    
    rear_cutout();
}

backrest();
left_lip();



// More information: https://danielupshaw.com/openscad-rounded-corners/

// Set to 0.01 for higher definition curves (renders slower)
$fs = 0.10;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}