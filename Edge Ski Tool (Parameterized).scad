width = 10;
thickness = 2;
height = 40;
angle = 87;
text_height = 3;
text_thickness = 0.25;

difference() {
    cube([width - thickness/2, thickness, height]);
    
    translate([0, 0, 0])
        rotate([0, 0, angle])
            cube([width, thickness, height]);
}

translate([thickness, 0, 0])
    rotate([0, 0, angle])
        cube([width, thickness, height]);
    
translate([5.5, thickness, 1])
rotate([90, 0, 180])
linear_extrude(height = text_thickness)
    text(
        font = "Arial Rounded MT Bold",
        text = str(angle, "°"),
        size = text_height,
        halign = "center"
    );