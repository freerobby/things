/*
color("red")
translate([14.25, 18.5, 0])
scale([0.75, 0.75, 0.75])
    import("/Users/robby/Desktop/Pump+Impeller/files/WirnikPompkiErr1.stl");
*/

blade_support_or = 4;
blade_support_ir = 2.5;
blade_height = 5;
blade_length = 13;
blade_thickness = 1.5;

latch_or = 6;
latch_ir = 4.5;
latch_height = 8;
clasp_width = 1.5;
clasp_thickness = 1.5;

$fn = 50;
//translate([0,0,1])
difference() {
    union() {
        cylinder(h = blade_height, r1 = blade_support_or, r2 = latch_or);
        
        for (i = [1:6]) {
            rotate_angle = i * (360 / 6);
            rotate([0, 0, rotate_angle])
            translate([-blade_thickness / 2, blade_support_ir, 0])
                cube([blade_thickness, blade_length, blade_height]);
        }
    }
    cylinder(h = blade_height, r1 = blade_support_ir, r2 = latch_ir);
}

translate([0, 0, blade_height]) {
    difference() {
        cylinder(h = latch_height, r = latch_or);
        cylinder(h = latch_height, r = latch_ir);
    }
    
    for (i = [1:3]) {
        rotate([0, 0, i * 360 / 3])
            translate([-clasp_width / 2, latch_ir - clasp_thickness, -blade_height])
                cube([clasp_width, clasp_thickness, latch_height + blade_height]);
    }
}