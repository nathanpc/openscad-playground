/**
 * eink-tablet-holder.scad
 * Holding rails for a Silvercrest HG06333C writing tablet. This
 * is meant to be printed as a pair and mounted to the side of a
 * cabinet where the tablet can be slid into.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

// Tablet dimensions.
tw = 150;  // Tablet width.
td = 6;    // Tablet depth.

// Feature dimensions.
ch = 15;  // Channel height.
sw = 3;   // Stop width.

// Mechanical dimensions.
fh = 1.5;  // Floor height.
wd = 2;    // Wall depth.
cs = 1;    // Channel slop.

difference() {
	// Main body.
	cube([tw + sw, td + (wd * 2) + cs, ch + fh]);

	// Slot cutout.
	translate([sw, wd, fh])
		cube([tw + 1, td + cs, ch + 1]);
}
