$fn = 20;

frame_width = 200;
frame_length = 200;
frame_height = 25;

rows = 8;
cols = 4;

divider_thickness = 1;
edge_thickness = 2;
bottom_thickness = 1;

joint_radius = 5;
inner_joint_radius = 3;
inner_joint_height = 5;
inner_joint_radius_spacing = 0.5;
inner_joint_height_spacing = 3;

echo("Compartment size (mm): ", frame_width / cols, " x ", frame_length / rows);

module draw_frame() {
    difference() {
        cube([frame_width, frame_length, frame_height]);
        
        // Cutouts for joints
        cylinder(frame_height, r = joint_radius);
        translate([frame_width, 0, 0]) {
            cylinder(frame_height, r = joint_radius);
        }
        translate([frame_width, frame_length, 0]) {
            cylinder(frame_height, r = joint_radius);
        }
        translate([0, frame_length, 0]) {
            cylinder(frame_height, r = joint_radius);
        }
        
        translate([edge_thickness, edge_thickness, bottom_thickness]) {
            cube([frame_width - 2 * edge_thickness, frame_length - 2 * edge_thickness, frame_height - bottom_thickness]);
        }
    }
}

module draw_cells() {
    for (row_offset = [frame_length / rows:frame_length / rows:frame_length - 1]) {
        translate([0, row_offset, 0]) {
            cube([frame_width, divider_thickness, frame_height]);
        }
    }
    
    for (col_offset = [frame_width / cols:frame_width / cols:frame_width - 1]) {
        translate([col_offset, 0, 0]) {
            cube([divider_thickness, frame_length, frame_height]);
        }
    }
}

module draw_joint() {
    difference() {
        cylinder(frame_height, r = joint_radius);
        
        cylinder(inner_joint_height + inner_joint_height_spacing, r = inner_joint_radius + inner_joint_radius_spacing);
    }
    
    translate([0, 0, frame_height]) {
        cylinder(inner_joint_height, r = inner_joint_radius);
    }
}

module draw_joints() {
    draw_joint();
    translate([frame_width, 0, 0]) {
        draw_joint();
    }
    translate([frame_width, frame_length, 0]) {
        draw_joint();
    }
    translate([0, frame_length, 0]) {
        draw_joint();
    }
}


draw_frame();
draw_cells();
    
draw_joints();