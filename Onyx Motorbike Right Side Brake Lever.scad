$fn = 100;
vertical_height = 9;

module draw() {
    linear_extrude(height = vertical_height) {
        difference() {
            polygon(points = [
                [7, 15], [7, 0], [19, 0], [50, 15], // Lower nub
                [60, 16], [105, 22], [105, 30], [60, 30], // Lever
                [3.5, 46], [2.5, 42], [4.25, 41.25], // Upper left nub
                [0, 28], [0, 24], // Latch point
            ]);
            
            // Cutout for mounting bolt
            translate([8, 27])
                circle(r = 4.5);
        }
        
        // Hand anchor on right
        translate([105, 29])
            circle(r = 7);
    }

    // Piston trigger
    translate([10, 6.5, vertical_height / 2])
        scale([2, 1, 1])
            sphere(r = 3);
}

draw();