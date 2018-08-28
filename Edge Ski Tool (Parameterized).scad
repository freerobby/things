``file_rest_width = 25;
ski_rest_width = 30;
file_rest_thickness = 3.5;
ski_rest_thickness = 2.5;
height = 60;
text_height = 9;
text_thickness = 0.25;

reinforcement_width = 14;
reinforcement_proportion = 1.0;

module tool(angle) {
    color("green")
difference() {
    translate([0, -reinforcement_width * sqrt(2) / 2, (height - height * reinforcement_proportion) / 2])
        rotate([0, 0, 45])
            cube([reinforcement_width, reinforcement_width, height * reinforcement_proportion]);
    
    translate([0, -2 * reinforcement_width, (height - height * reinforcement_proportion) / 2])
        cube([2 * reinforcement_width, 2 * reinforcement_width, height * reinforcement_proportion]);
    translate([-2 * reinforcement_width, -reinforcement_width, (height - height * reinforcement_proportion) / 2])
        cube([2 * reinforcement_width, 2 * reinforcement_width, height * reinforcement_proportion]);
}


color("red")
cube([ski_rest_width - ski_rest_thickness / 2, ski_rest_thickness, height]);

color("blue")
difference() {
    translate([file_rest_thickness, 0, 0])
        rotate([0, 0, angle])
            cube([file_rest_width, file_rest_thickness, height]);
    
    translate([-ski_rest_thickness, -ski_rest_thickness, 0])
        cube([ski_rest_width - ski_rest_thickness / 2, ski_rest_thickness, height]);
}
            

    
translate([ski_rest_width - 1.25 * text_height, ski_rest_thickness, 1])
    rotate([90, 0, 180])
        linear_extrude(height = text_thickness)
            text(
                font = "Arial Rounded MT Bold",
                text = str(angle, "°"),
                size = text_height,
                halign = "center"
            );
}

for (angle_offset = [0:1:4]) {
    translate([(ski_rest_width + 3) * angle_offset, 0, 0])
        rotate([90, 0, 0])
            tool(90 + angle_offset);
}
