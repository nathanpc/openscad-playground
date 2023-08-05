/**
 * dovetail-test.scad
 * A test of locking modular things together.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

use <lib/dovetail.scad>

eps = 0.001;

difference() {
	union() {
		color("red")
		translate([0, 0, 15])
			dovetail("male", 30, 30);

		cube([30, 30, 30], center = true);
	}

	color("red")
	translate([0, 0, -15 - eps])
		dovetail("female", 30, 30);
}

#color("teal")
translate([0, 0, 15 + 3])
	dovetail_cap(30, 30, 6);
