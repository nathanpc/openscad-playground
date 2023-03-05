/**
 * cnc-table-grab-screw.scad
 * Screw grabbers for raising and lowering the table in the
 * K40 CNC laser.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

use <lib/threads.scad>;

// Cylinder resolution.
$fn = 40;

module grab_screw(show_threads) {
    difference() {
        // Main body.
        cylinder(h = 30, d = 11);
        
        // M3 thread.
        if (show_threads) {
            metric_thread(diameter = 3, pitch = 0.5, length = 30);
        } else {
            translate([0, 0, -5])
                cylinder(h = 30 + 10, d = 3);
        }
        
        // Top M3 nut pocket.
        translate([0, 0, 27])
            cylinder(h = 3 + 1, d = 7);
        
        // Bottom M3 nut pocket.
        translate([0, 0, -1])
            cylinder(h = 3 + 1, d = 7);
    }
}

difference() {
    grab_screw(true);
    translate([0, -5.5, -1])
        cube([5.5, 11, 30 + 2]);
}
