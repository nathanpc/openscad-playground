/**
 * usb-thumb-holder.scad
 * A holder for USB thumb devices that have an exposed USB port and
 * isn't very thick.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

// Generation parameters.
nslots  = 10;
spacing = 5;
cased   = 22;

// USB port dimensions.
portw = 4.6;
portd = 12.5;
porth = 12.1;

// Spacings dimensions.
floorh = 1.5;

// Ensure a high-end render.
$fs = $preview ? 2 : 0.1;

/**
 * USB slot cube.
 *
 * @param center Center up the slot.
 */
module usb_slot(center = true) {
	cube([portw, portd, porth], center = center);
}

/**
 * Builds up a USB slot array.
 *
 * @param slots Number of USB slots.
 */
module slot_array(slots = nslots) {
	translate([-((spacing + portw) * (slots - 1)) / 2, 0, 0])
	for (i = [0 : (slots - 1)]) {
		color("red")
		translate([((portw / 2) + (spacing + (portw / 2))) * i, 0, 0])
			usb_slot();
	}
}

// Build up the case.
difference() {
	// Case
	cube([((spacing + portw) * nslots) + spacing, cased, porth + floorh], center = true);

	// Slots
	translate([0, 0, (floorh / 2) + 0.01])
		slot_array();
}