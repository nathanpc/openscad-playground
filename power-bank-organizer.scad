/**
 * power-bank-organizer.scad
 * An organizer drawer for my various power banks.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

// Ensure a high-quality render.
$fn = $preview ? 36 : 360;

/**
 * Single 18650 cell square tube power bank style.
 *
 * @param height Height of the power bank.
 */
module pb_1c_tube(height = 90) {
	color("orange")
	cube([26, 26, height], center = true);
}

/**
 * Single pouch cell flat case power bank style.
 *
 * @param height Height of the power bank.
 */
module pb_1c_flat(height = 110) {
	color("lightgreen")
	cube([10, 69, height], center = true);
}

/**
 * 3x 18650 cell rounded square tube power bank style.
 *
 * @param height Height of the power bank.
 */
module pb_3c_rdtube(height = 90) {
	width = 61;
	diam = 23;
	spacing = (width / 2) - (diam / 2);

	color("green")
	union() {
		// Middle fill.
		cube([(diam / 4) + (width / 2) + 2, diam, height], center = true);

		// Rounded ends.
		translate([-spacing, 0, 0])
			cylinder(h = height, d = diam, center = true);
		translate([spacing, 0, 0])
			cylinder(h = height, d = diam, center = true);
	}
}

/**
 * Sony CP-V3B power bank.
 *
 * @param height Height of the power bank.
 */
module pb_sony_cpv3b(height = 85) {
	ovalw = 26;
	ovald = 68;
	ovh = 4;

	color("blue")
	translate([ovh, 0, 0])
	linear_extrude(height, center = true)
	difference() {
		// Main oval shape.
		resize([ovalw, ovald])
			circle(d = 20);
		
		// Cutoff part.
		translate([-(ovh + (ovalw / 2)), 0, 0])
		resize([ovalw, ovald])
			square(10, center = true);
	}
}

//pb_1c_tube();
pb_1c_flat();
//pb_3c_rdtube();
//pb_sony_cpv3b();