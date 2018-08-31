shelf_width = 271;
shelf_depth = 178;
shelf_height = 3;

rear_cutout_width = 200;
rear_cutout_depth = 31;

backrest_depth = 3;
backrest_height = 30;
    
backrest_center_clearance = 120;

left_lip_height = 12;
left_lip_width = 3;

back_brace_diameter = 30;

module shelf() {
    cube([shelf_width, shelf_depth, shelf_height]);
    
    back_brace();
}

module back_brace() {
    translate([0, shelf_depth - back_brace_diameter,shelf_height])
    difference() {
        cube([shelf_width, back_brace_diameter, back_brace_diameter]);
        
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
    cube([left_lip_width, shelf_depth, shelf_height + left_lip_height]);
}


module build_shelf() {
    difference() {
        shelf();
        rear_cutout();
    }
    backrest();
    left_lip();
}

palette_width = shelf_width - left_lip_width;
palette_depth = shelf_depth - rear_cutout_depth;
palette_thickness = 1;
palette_shelf_depth = 16;
palette_shelf_thickness = 1.5;

num_palette_shelves = 4;

module palette_base() {
    cube([palette_width, palette_depth, palette_thickness]);
}
module palette_border() {
    translate([0, 0, palette_thickness])
        difference() {
            cube([palette_width, palette_depth, palette_shelf_depth]);
            
            translate([palette_shelf_thickness, palette_shelf_thickness, 0])
                cube([palette_width - 2 * palette_shelf_thickness, palette_depth - 2 * palette_shelf_thickness, palette_shelf_depth]);
        }
}

module vertical_reinforcement(length, radius, spacing) {
    module single_reinforcement() {
        difference() {
            cube([length, radius, radius]);
            
            translate([0, 0, radius])
            rotate([0, 90 ,0])
                cylinder(h = length, r = radius);
        }
    }
    
    translate([0, -radius, 0]) {
        single_reinforcement();
        // .001 gets rid of warning; ditch that when openscad fixed
        translate([length, 2 * radius + spacing - .001, 0])
            rotate([0, 0, 180])
                single_reinforcement();
    }
}

module palette_shelves() {
    shelf_every = palette_depth / (num_palette_shelves + 1);
    for (shelf_index = [1:1:num_palette_shelves]) {
        translate([0, shelf_index * shelf_every, palette_thickness]) {
            cube([palette_width, palette_shelf_thickness, palette_shelf_depth]);
            
            vertical_reinforcement(palette_width, 2, palette_shelf_thickness);
        }
        translate([palette_thickness, shelf_index * shelf_every + palette_shelf_thickness, palette_thickness]) {
            rotate([0, -90, 180])
                vertical_reinforcement(palette_shelf_depth, 2, palette_shelf_thickness);
        }
        translate([palette_thickness + palette_width - 2 * palette_shelf_thickness, shelf_index * shelf_every, palette_thickness]) {
            rotate([0, -90, 0])
                vertical_reinforcement(palette_shelf_depth, 2, palette_shelf_thickness);
        }
    }
}

module build_palette() {
    palette_base();
    palette_border();
    palette_shelves();
}

// Build one at a time:
//build_shelf();
build_palette();


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