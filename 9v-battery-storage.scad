/**
 * 9v-battery-storage.scad
 * 9V (PP3) battery storage tray.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

use <lib/rounded-cube.scad>;

// General parameters.
tray_height = 30;
nslots = 3;
slot_spacing = 2;
side_wall = 3.5;
floor_hgt = 2;

// PP3 battery general dimensions.
pp3_width = 17.5;
pp3_depth = 27.5;
pp3_height = 49;

// Ensure a high-end render.
$fs = $preview ? 2 : 0.1;

/**
 * Simulates the space occupied by a PP3 battery including the top contacts.
 */
module batt() {
	color("grey")
		roundedcube([pp3_width, pp3_depth, pp3_height], radius = 1);
}

/**
 * Generates a row of batteries with a specific spacing in between.
 *
 * @param slots   Number of battery slots in the row.
 * @param spacing Space between each slot.
 */
module batt_row(slots, spacing = slot_spacing) {
	for (i = [0 : (slots - 1)]) {
		translate([(pp3_width + spacing) * i, 0, 0])
			batt();
	}
}

/**
 * Adds some text branding to the tray.
 *
 * @param side_wcenter Side X center point.
 * @param side_hcenter Side Z center point.
 * @param depth        Depth of the text into the side of the tray.
 */
module text_branding(side_wcenter, side_hcenter, depth = 1.5) {
	eps = 0.01;
	
	// 9V label.
	color("green")
	translate([side_wcenter, depth - eps, side_hcenter])
	rotate([90, 0, 0])
	linear_extrude(depth)
		text("9V", size = 15, halign = "center", valign = "center",
			font = "DejaVu Sans:style=Book", $fn = 50);
}

/**
 * Generates a battery tray.
 *
 * @param slots   Number of battery slots.
 * @param wall    Thickness of the walls of the tray.
 * @param floorh  Thickness of the floor of the tray.
 * @param spacing Spacing between each battery.
 */
module tray(height, slots, wall = side_wall, floorh = floor_hgt, spacing = slot_spacing) {
	batt_rwidth = ((pp3_width + spacing) * slots) - spacing;
	wall2 = wall * 2;

	difference() {
		// Tray base.
		roundedcube([batt_rwidth + wall2, pp3_depth + wall2, height],
			radius = 2);
		
		union() {
			// Branding text.
			text_branding((batt_rwidth + wall2) / 2, height / 2);

			// Batteries.
			translate([wall, wall, floorh])
				batt_row(slots);
		}
	}
}

// Generate the tray to be printed.
tray(tray_height, nslots);
