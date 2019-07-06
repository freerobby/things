$fn = 100;

outer_border = 1;

plastic_width = 19;
plastic_thickness = 3;
plastic_height = 10;

blade_height = 6;
blade_width = 5;
blade_thickness = 0.75;

blade_spacing = 4;

wire_awg = 14;

function wire_diameter_from_awg(awg) = 0.127 * pow(92, (36 - awg)/39);

difference() {
    cube([plastic_width + 2 * outer_border, plastic_thickness + 2 * outer_border, plastic_height + blade_height + outer_border]);
    
    fuse_height = plastic_height + blade_height;
    
    holder_thickness = plastic_thickness + 2 * outer_border;
    
    // Plastic cutouot
    translate([outer_border, outer_border, fuse_height - plastic_height + outer_border])
        cube([plastic_width, plastic_thickness, plastic_height]);
    
    // Left blade cutout
    translate([outer_border + plastic_width / 2 - blade_width - blade_spacing / 2, holder_thickness / 2 - blade_thickness / 2, outer_border])
        cube([blade_width, blade_thickness, blade_height]);
    
    // Right blade cutout
    translate([outer_border + plastic_width / 2 + blade_spacing / 2, holder_thickness / 2 - blade_thickness / 2, outer_border])
        cube([blade_width, blade_thickness, blade_height]);
    
    wire_cutout_depth = holder_thickness / 2; // Half thickness of fuse holder
    wire_cutout_diameter = wire_diameter_from_awg(wire_awg);

    // Left wire insert
    translate([outer_border + plastic_width / 2 - blade_spacing / 2 - blade_width / 2, wire_cutout_depth / 2, outer_border + blade_height - wire_cutout_diameter / 2])
        rotate([90, 0, 0])
            cylinder(h = wire_cutout_depth, d = wire_cutout_diameter, center = true);
            
    // Right wire insert
    translate([outer_border + plastic_width / 2 + blade_spacing / 2 + blade_width / 2, wire_cutout_depth / 2, outer_border + blade_height - wire_cutout_diameter / 2])
        rotate([90, 0, 0])
            cylinder(h = wire_cutout_depth, d = wire_cutout_diameter, center = true);

    // Left wire cutout
    translate([
        outer_border + plastic_width / 2 - blade_spacing / 2 - blade_width / 2,
        holder_thickness / 2,
        blade_height / 2 + outer_border
    ])
        cube([wire_cutout_diameter, wire_cutout_diameter * 2, blade_height], center= true);

    // Right wire cutout
    translate([
        outer_border + plastic_width / 2 + blade_spacing / 2 + blade_width / 2,
        holder_thickness / 2,
        blade_height / 2 + outer_border
    ])
        cube([wire_cutout_diameter, wire_cutout_diameter * 2, blade_height], center= true);
}