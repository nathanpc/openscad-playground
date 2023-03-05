/**
 * memorystick-holder.scad
 * A Sony Memory Stick holder.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

// Generation parameters.
nslots  = 6;
spacing = 5;

// Memory Stick dimensions.
ms_width = 3.2;
ms_depth = 22.2;
ms_height = 50;

// Memory Stick Pro Duo dimensions.
mspd_width = 2.2;
mspd_depth = 20.8;
mspd_height = 31;

// Spacings dimensions.
floorh = 1.5;
expo_top = 15;

// Ensure a high-end render.
$fs = $preview ? 2 : 0.1;

/**
 * A single Sony Memory Stick cutout.
 *
 * @param type Type of Memory Stick ("ms" or "produo").
 */
module memorystick(type) {
	if (type == "ms") {
		color("lightpink")
		cube([ms_width, ms_depth, ms_height], center = true);
	}
	
	if (type == "produo") {
		color("lightpink")
		cube([mspd_width, mspd_depth, mspd_height], center = true);
	}
}

/**
 * Builds up a Memory Stick slot array.
 *
 * @param type  Type of Memory Stick ("ms" or "produo").
 * @param slots Number of slots.
 */
module slot_array(type, slots) {
	// Regular
	if (type == "ms") {
		width = ms_width;
		
		// Span the slots.
		translate([-((spacing + width) * (slots - 1)) / 2, 0, 0])
		for (i = [0 : (slots - 1)]) {
			translate([((width / 2) + (spacing + (width / 2))) * i, 0, 0])
				memorystick(type);
		}
	}
	
	// Pro Duo
	if (type == "produo") {
		width = mspd_width;

		// Span the slots.
		translate([-((spacing + width) * (slots - 1)) / 2, 0, 0])
		for (i = [0 : (slots - 1)]) {
			translate([((width / 2) + (spacing + (width / 2))) * i, 0, 0])
				memorystick(type);
		}
	}
}

/**
 * Builds up te Memory Stick case.
 *
 * @param type  Type of Memory Stick ("ms" or "produo").
 * @param slots Number of slots.
 */
module ms_case(type, slots = nslots) {
	// Regular
	if (type == "ms") {
		width = ms_width;
		depth = ms_depth;
		height = ms_height;
		
		difference() {
			// Case
			translate([0, 0, -expo_top / 2])
				cube([
					((spacing + width) * nslots) + spacing,
					(spacing * 2) + depth,
					height + floorh - expo_top
				], center = true);

			// Slots
			translate([0, 0, (floorh / 2) + 0.01])
				slot_array(type, slots);
		}
	}
	
	// Correct if needed for Pro Duo cards.
	if (type == "produo") {
		width = mspd_width;
		depth = mspd_depth;
		height = mspd_height;
		
		difference() {
			// Case
			translate([0, 0, -expo_top / 2])
				cube([
					((spacing + width) * nslots) + spacing,
					(spacing * 2) + depth,
					height + floorh - expo_top
				], center = true);

			// Slots
			translate([0, 0, (floorh / 2) + 0.01])
				slot_array(type, slots);
		}
	}
}

// Build a case.
ms_case("produo");
