/**
 * bridge-test.scad
 * A simple part to test the bridge settings of a slicer.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

eps = 0.05;

// Side support dimensions. (W x D x H)
sw = 3;
sd = 10;
sh = 5;

// Bridge dimensions. (Thickness x Width)
bt = 0.2;
bw = 15;

union() {
	cube([sw, sd, sh]);
	translate([sw - eps, 0, sh - bt])
		cube([bw + eps, sd, bt]);
	translate([sw +bw, 0, 0])
		cube([sw, sd, sh]);
}