$fn = 50;

handlebar_diameter = 22;
handlebar_mount_thickness = 3;

handlebar_offset = 10;

clasp_insert_diameter = 4;
clasp_catch_diameter = 9;
clasp_grasp_thickness = 4;
clasp_spacing = 2;

cut_width = 10;
bedplate_length = 9;

mount_width = 20;

module handlebar_cutout() {
    translate([-mount_width / 2, 0, 0]) {
        rotate([0, 90, 0]) {
            linear_extrude(mount_width) {
                // Cutout
                translate([0, -cut_width / 2])
                    square([handlebar_diameter, cut_width]);
            }
        }
    }
}

module handlebar_mount() {
    translate([-mount_width / 2, 0, 0]) {
        rotate([0, 90, 0]) {
            linear_extrude(mount_width) {
                difference() {
                    // Outer circle
                    circle(d = handlebar_diameter + 2 * handlebar_mount_thickness);
                    
                    // Inner circle (cutout)
                    circle(d = handlebar_diameter);
                }
            }
        }
    }
}

module offset() {
    translate([-mount_width / 2, -clasp_insert_diameter / 2, 0]) {
        rotate([0, 90, 0]) {
            linear_extrude(mount_width) {
                // Outer circle
                square([handlebar_offset, clasp_insert_diameter]);
            }
        }
    }
}

module clasp() {
    // Upper portion
    translate([0, 0, clasp_spacing - handlebar_mount_thickness])
        linear_extrude(clasp_grasp_thickness) {
            circle(d = clasp_catch_diameter);
        }
    
    // Lower portion
    translate([0, 0, -handlebar_mount_thickness])
        linear_extrude(clasp_spacing) {
            circle(d = clasp_insert_diameter);
        }
}

module print() {
    difference() {
        handlebar_mount();
        handlebar_cutout();
    }
    translate([0, 0, handlebar_diameter / 2 + handlebar_offset])
        offset();
    translate([0, 0, handlebar_diameter / 2 + handlebar_mount_thickness + handlebar_offset])
        clasp();
}

print();
