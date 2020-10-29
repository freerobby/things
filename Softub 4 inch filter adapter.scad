$fn = 200;

large_filter_diameter = (5 + 3/32) * 25.4;
small_filter_diameter = 4 * 25.4;
base_height = 0.25 * 25.4;
wall_height = 1.25 * 25.4;
wall_thickness = 5;
cutout_width = 1 * 25.4;

module generate_section(outer_d, inner_d, cutout_w, height, offset_h, offset_inner) {
    translate([0, 0, offset_h]) {
        linear_extrude(height) {
            difference() {
                circle (d = outer_d);
                translate([0, offset_inner])
                    circle (d = inner_d);
                translate([0, outer_d / 2])
                    square ([cutout_w, outer_d], true);
            }
        }
    }
}

generate_section(
    large_filter_diameter,
    small_filter_diameter,
    cutout_width,
    base_height,
    0,
    (large_filter_diameter - small_filter_diameter)/2 - wall_thickness
);

generate_section(
    large_filter_diameter,
    large_filter_diameter - wall_thickness * 2,
    cutout_width,
    wall_height,
    base_height,
    0
);

// 3", 4", 1 + 3/32" hypotenuse, 0.5"