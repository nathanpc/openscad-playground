/**
 * pcmcia-card-organizer.scad
 * A PCMCIA card organizer tower.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

// For more information about the spec: https://support.dynabook.com/support/viewContentDetail?contentId=108256

// Generation parameters.
nslots2 = 7;      // Number of Type II slots.
nslots3 = 4;      // Number of Type III slots.
spacing = 5;      // Spacing between slots.
expo_depth = 10;  // Depth of card to leave exposed in front.

// PCMCIA card dimensions.
pcmcia_depth = 85.6;     // Overall depth.
pcmcia_width = 55.0;     // Overall width.
pcmcia_cwidth = 50.8;    // Center section width.
pcmcia_cheight2 = 5.8;   // Center section height for Type II.
pcmcia_xcheight3 = 6.8;  // Center section extra height for Type III.
pcmcia_rheight = 3.8;    // Rail guide height.

/**
 * Gets the height of a PCMCIA card depending on its type.
 *
 * @param  type Type of the PCMCIA card. (Can be 2 or 3)
 * @return      Height of the PCMCIA card.
 */
function pcmcia_height(type = 2) =
	(type == 2) ? pcmcia_cheight2 : (pcmcia_rheight + ((pcmcia_cheight2 - pcmcia_rheight) / 2) + pcmcia_xcheight3);

// Calculates the height of the array.
/**
 * Gets the height of a PCMCIA card slot array.
 *
 * @param  type  Type of the PCMCIA card. (Can be 2 or 3)
 * @param  slots Number of slots in the array.
 * @return       Height of the PCMCIA card.
 */
function slot_array_height(type, slots) =
	(spacing + pcmcia_height(type)) * slots;

/**
 * Generates a PCMCIA card slot.
 *
 * @param type Type of the PCMCIA card. (Can be 2 or 3)
 */
module pcmcia_slot(type = 2) {
	// Ensure we have a correct type.
	assert((type >= 2) && (type <= 3));

	union() {
		// Common rail guides for all types.
		cube([pcmcia_width, pcmcia_depth, pcmcia_rheight], center = true);
		cube([pcmcia_cwidth, pcmcia_depth, pcmcia_cheight2], center = true);
	
		// Extra height for Type III cards.
		if (type == 3) {
			translate([0, 0, (pcmcia_xcheight3 + pcmcia_rheight) / 2])
				cube([pcmcia_cwidth, pcmcia_depth, pcmcia_xcheight3], center = true);
		}
	}
}

/**
 * Builds up a slot array.
 *
 * @param type  Type of the PCMCIA card. (Can be 2 or 3)
 * @param slots Number of slots.
 */
module slot_array(type, slots) {
	// Correct the offset for Type III cards.
	function slot_offset(type) =
		(type == 3) ? (pcmcia_xcheight3 - ((pcmcia_cheight2 - pcmcia_rheight) / 2)) / 2 : 0;

	// Calculates the slot position in the array.
	function slot_pos(type, index) =
		((pcmcia_height(type) / 2) + (spacing + (pcmcia_height(type) / 2))) * index;
	
	// Span the slots.
	translate([0, 0, -(slot_array_height(type, slots - 1)) / 2])
	for (i = [0 : (slots - 1)]) {
		translate([0, 0, slot_pos(type, i) - slot_offset(type)])
			pcmcia_slot(type);
	}
}

/**
 * Builds a mixed card type slot array.
 *
 * @param slots2 Number of Type II card slots.
 * @param slots3 Number of Type III card slots.
 */
module mixed_slot_array(slots2, slots3) {
	recenter_offset =
		((slot_array_height(2, slots2) - slot_array_height(3, slots3)) / 2);

	translate([0, 0, recenter_offset])
	union() {
		// Bottom Type II slots.
		translate([0, 0, -slot_array_height(2, slots2) / 2])
			slot_array(type = 2, slots = slots2);
		
		// Top Type III slots.
		translate([0, 0, slot_array_height(3, slots3) / 2])
			slot_array(type = 3, slots = slots3);
	}
}

/**
 * Builds the organizer enclosure.
 *
 * @param exposed  Exposed card depth.
 * @param slots2   Number of Type II card slots.
 * @param slots3   Number of Type III card slots.
 * @param backface Depth of the backface of the enclosure.
 */
module slot_enclosure(exposed, slots2, slots3, backface = 3) {
	h = slot_array_height(2, slots2) + slot_array_height(3, slots3);

	difference() {
		// Outer case.
		translate([0, (exposed / 2) + (backface / 2), 0])
			cube([pcmcia_width + (spacing * 2), pcmcia_depth - exposed + backface, h + spacing], center = true);
		
		// Slots
		color("pink")
			mixed_slot_array(slots2, slots3);
	}
}

// Build up the enclosure.
slot_enclosure(expo_depth, nslots2, nslots3);