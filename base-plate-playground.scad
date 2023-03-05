$fn = 40;

difference() {
    union() {
        cube([100, 50, 10], center = true);
        translate([0, 0, 7.5])
            cube([80, 30, 5], center = true);
    }
    
    translate([47, 22, 0])
        cylinder(h = 5.1, d = 3);
    translate([-47, 22, 0])
        cylinder(h = 5.1, d = 3);
    translate([47, -22, 0])
        cylinder(h = 5.1, d = 3);
    translate([-47, -22, 0])
        cylinder(h = 5.1, d = 3);
}

// For smooth cyls: http://forum.openscad.org/Round-shapes-created-in-openscad-are-not-smooth-but-hexigonal-td24407.html
//  For 3D printing I set $fa to 6 and $fs to half the extrusion width. That gives 60 sides for large circles (best to make it a multiple of four). Smaller circles hit the $fs limit and have less sides