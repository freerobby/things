total_height = 250;

top_width = 50;
top_depth = 30;
top_height = 3;

bottom_width = 150;
bottom_depth = 50;

tentacle_radius = 3.5;
tentacle_height = total_height - top_height;

translate([0, 0, total_height - top_height - top_height / 2])
    cube([top_width, top_depth, top_height], true);
    
tentacle_length = sqrt(pow((top_width/2-bottom_width/2), 2) + pow((top_depth/2-bottom_depth/2), 2) + pow((tentacle_height-0), 2));
echo("Tentacle height: ", tentacle_height);
echo("Tentacle length: ", tentacle_length);

y_rotation = atan((bottom_width / 2 - top_width / 2) / tentacle_height);
x_rotation = atan((bottom_depth / 2 - top_depth / 2) / tentacle_height);

module draw_leg() {
    translate([-bottom_width / 2, bottom_depth / 2, 0])
        rotate([x_rotation, y_rotation, 0])
            cylinder(h = tentacle_length, r = tentacle_radius);
}

module draw_legs() {
    draw_leg();
    mirror([1, 0, 0])
        draw_leg();
    mirror([0, 1, 0]) {
        draw_leg();
        mirror([1, 0, 0])
            draw_leg();
    }
}

draw_legs();

module upper_section() {
    hull()
    intersection() {
        draw_legs();
        translate([0, 0, total_height - top_height - top_height / 2])
            cube([top_width * 2, top_depth * 2, top_height * 2], true);
    }
        
}
upper_section();