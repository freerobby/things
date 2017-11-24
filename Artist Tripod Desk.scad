// 0.75" thin 1/8" Lip on left hand side to clip a brush holder or water bucket

shelf_width = 280;
shelf_depth = 153;
shelf_height = 5;

rear_cutout_width = 185;
rear_cutout_depth = 26;

backrest_depth = 7;
backrest_height = 40;

backrest_center_clearance = 140;

left_lip_height = 12;
left_lip_width = 3;

module shelf() {
    cube([shelf_width, shelf_depth, shelf_height]);
}

module rear_cutout() {
    translate([(shelf_width-rear_cutout_width)/2, shelf_depth - rear_cutout_depth, 0])
        cube([rear_cutout_width, rear_cutout_depth, shelf_height]);
    
    translate([(shelf_width - rear_cutout_width) / 2, shelf_depth - rear_cutout_depth + (rear_cutout_depth / 2), 0])
        cylinder(h = shelf_height, d = rear_cutout_depth);
    
    translate([(shelf_width + rear_cutout_width) / 2, shelf_depth - rear_cutout_depth + (rear_cutout_depth / 2), 0])
        cylinder(h = shelf_height, d = rear_cutout_depth);
}

module backrest() {
    translate([0, shelf_depth, 0])
        difference() {
            cube([shelf_width, backrest_depth, backrest_height]);
            
            translate([(shelf_width - backrest_center_clearance) / 2, 0, 0])
                cube([backrest_center_clearance, backrest_depth, backrest_height]);
        }
}

module left_lip() {
    translate([0, 0, shelf_height])
        cube([left_lip_width, shelf_depth, left_lip_height]);
}

difference() {
    shelf();
    
    rear_cutout();
}

backrest();
left_lip();