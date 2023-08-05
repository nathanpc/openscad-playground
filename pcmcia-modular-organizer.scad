/**
 * pcmcia-modular-organizer.scad
 * A modular PCMCIA card organizer tower.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

use <lib/dovetail.scad>

thing_to_build = "type3";  // type2, type3, base, top2, top3

// Generation parameters.
eps = 0.001;      // Epsilon overlap. 
side_wall = 5;    // Side wall width.
dt_margin = 2.5;  // Margin between the slot and the dovetail.
expo_depth = 15;  // Depth of card to leave exposed in front.

// PCMCIA card dimensions.
// For more information about the spec:
// https://support.dynabook.com/support/viewContentDetail?contentId=108256
pcmcia_depth = 85.6;     // Overall depth.
pcmcia_width = 55.0;     // Overall width.
pcmcia_cwidth = 50.8;    // Center section width.
pcmcia_cheight2 = 5.8;   // Center section height for Type II.
pcmcia_xcheight3 = 6.8;  // Center section extra height for Type III.
pcmcia_rheight = 3.8;    // Rail guide height.

/**
 * Build a thing!
 *
 * @param thing The thing to be built. Can be "type2", "type3",
 *              "base", "top2", "top3".
 */
module build_thing(thing) {	
	rotate([-90, 0, 0])
	if (thing == "type2") {
		// Build up the Type II enclosure.
		slot_module(2, expo_depth);
	} else if (thing == "type3") {
		// Build up the Type III enclosure.
		slot_module(3, expo_depth);
	} else if (thing == "top2") {
		// Build up the Type II top cap enclosure.
		slot_module(2, expo_depth, topdt = false);
	} else if (thing == "top3") {
		// Build up the Type III top cap enclosure.
		slot_module(3, expo_depth, topdt = false);
	} else if (thing == "base") {
		// Build the tapered base.
		module_base_tapered(10, 10, expo_depth);
	} else {
		assert(false, "Unknown thing");
	}
}

/**
 * Gets the height of a PCMCIA card depending on its type.
 *
 * @param  type Type of the PCMCIA card. (Can be 2 or 3)
 *
 * @return Height of the PCMCIA card.
 */
function pcmcia_height(type = 2) =
	(type == 2) ? pcmcia_cheight2 : (pcmcia_rheight + ((pcmcia_cheight2 - pcmcia_rheight) / 2) + pcmcia_xcheight3);

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
 * Builds an organizer module.
 *
 * @param type     Type of the PCMCIA card. (Can be 2 or 3)
 * @param exposed  Exposed card depth.
 * @param backface Depth of the backface of the enclosure.
 * @param topdt    Should the top dovetail be included?
 */
module slot_module(type, exposed, backface = 3, topdt = true) {
	// Correct the offset for Type III cards.
	function slot_offset(type) =
		(type == 3) ? (pcmcia_xcheight3 - ((pcmcia_cheight2 - pcmcia_rheight) / 2)) / 2 : 0;
	
	// Sizing and positioning.
	yo = (exposed / 2) + (backface / 2);
	mw = pcmcia_width + (side_wall * 2);
	md = pcmcia_depth - exposed + backface;
	mh = pcmcia_height(type) + (dt_margin * 2);
	
	union() {
		color("red")
		translate([0, yo, mh / 2])
		if (topdt) {
			// Top male dovetail.
			dovetail("male", mw, md);
		} else {
			// Top cap.
			translate([0, 0, 2 - eps])
				cube([mw, md, 4], center = true);
		}

		// The enclosure itself.
		difference() {
			// Outer case.
			translate([0, yo, -2])
				cube([mw, md, mh + 4], center = true);
			
			// Slot.
			color("pink")
			translate([0, 0, slot_offset(type) * -1])
				pcmcia_slot(type);
		
			// Bottom female dovetail.
			color("teal")
			translate([0, yo, -(mh / 2) - 4 - eps])
				dovetail("female", mw, md);
		}
	}
}

/**
 * Builds a top cap for a module, hiding the ugly dovetail.
 *
 * @param exposed  Exposed card depth.
 * @param backface Depth of the backface of the enclosure.
 * @param h        Height of the cap.
 */
module module_cap(exposed, backface = 3, h = 8) {
	// Sizing and positioning.
	yo = (exposed / 2) + (backface / 2);
	mw = pcmcia_width + (side_wall * 2);
	md = pcmcia_depth - exposed + backface;

	translate([0, yo, 0])
		dovetail_cap(mw, md, h);
}

/**
 * Builds a PS2-inspired bottom base for a module, hiding the ugly
 * dovetail.
 *
 * @param side_width Width of the sides of the base.
 * @param sunken     Height to sunken the module into the base.
 * @param exposed    Exposed card depth.
 * @param backface   Depth of the backface of the enclosure.
 * @param h          Height of the cap.
 * @param tol        Tolerance given between the module and base sides.
 */
module module_base_tapered(side_width, sunken, exposed,
		backface = 3, h = 20, tol = .8) {
	// Sizing and positioning.
	yo = (exposed / 2) + (backface / 2);
	mw = pcmcia_width + (side_wall * 2);
	md = pcmcia_depth - exposed + backface;
	bw = mw + (2 * side_width);
	dth = 4;

	translate([0, yo, 0])
	union() {
		// Top male dovetail.
		color("red")
		translate([0, 0, (h / 2) - sunken])
			dovetail("male", mw, md);
		
		// Base itself.
		difference() {
			// Base shape.
			translate([0, (md / 2), 0])
			rotate([90, 180, 0])
			linear_extrude(md)
				trapezoid(bw, h, side_width, 0);

			// Sunken block.
			color("teal")
			translate([0, 0, (h / 2) - (sunken / 2)])
				cube([mw + tol, md + tol, sunken + eps], center = true);
		}
	}
}

// Build the thing!
build_thing(thing_to_build);
