/**
 * cnc-laser-spacers.scad
 * CNC laser cutting spacers.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

use <lib/threads.scad>;

// Parameters.
body_diam         = 11;
bottom_height     = 30;
top_height        = 25;
top_screw_length  = 15;
bore_length       = 22;
mag_height        = 1;
mag_diam          = 6;

// Cylinder resolution.
$fn = 40;

// Spacer's bottom part.
module bottom_part() {
    difference() {
        // Shell.
        cylinder(h = bottom_height, d = body_diam);
        
        // M6x1 hole.
        translate([0, 0, bottom_height - bore_length])
            metric_thread(6, 1, bore_length);
            //cylinder(h = bore_length, d = 5);
        
        cylinder(h = mag_height, d = mag_diam);
    }
}

// Spacer's top part.
module top_part() {
    union() {
        // M6x1 screw.
        metric_thread(6, 1, top_screw_length);
        
        // Top body.
        difference() {
            translate([0, 0, top_screw_length])
                cylinder(h = top_height, d = body_diam);
            
            translate([0, 0, top_screw_length + top_height - mag_height])
                cylinder(h = mag_height, d = mag_diam);
        }
    }
}

// Spacer in its fully closed position.
module closed_spacer() {
    bottom_part();
    translate([0, 0, bottom_height - top_screw_length])
        top_part();
}

// Show everything side-by-side.
translate([0, 20, 0])
    bottom_part();
translate([0, 0, bottom_height - top_screw_length])
    top_part();
translate([0, -20, 0])
    closed_spacer();
