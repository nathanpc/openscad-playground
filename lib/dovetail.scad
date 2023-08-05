/**
 * dovetail.scad
 * A dovetail generator to easily lock modular pieces together.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

eps = 0.001;

/**
 * Creates a 2D trapezoid with a shrinking tolerance factor.
 *
 * @param w   Major width of the trapezoid.
 * @param h   Height of the trapezoid.
 * @param a   Side angle of the trapezoid.
 * @param tol Absolute amount to shrink the part as a whole.
 */
module trapezoid(w, h = 4, a = 2, tol = 0.4) {
	function at(val, t) = val + (tol / 2);
	function st(val, t) = val - (tol / 2);
	
	translate([st(-(w / 2)), st(-(h / 2)), 0])
		polygon(points = [[at(a), 0], [0, st(h)], [st(w), st(h)],
			[st(w - a), 0]]);
}

/**
 * Creates a male or female dovetail joint.
 *
 * @param gender Dovetail gender. ("male" or "female")
 * @param w      Width of the mating face.
 * @param d      Depth of the mating face.
 * @param sm     Margin from the side of the mating face to the end of the
 *               dovetail joint.
 * @param th     Dovetail trapezoid height.
 * @param ta     Side angle of the dovetail trapezoid.
 * @param tol    Absolute tolerance of the fit.
 */
module dovetail(gender, w, d, sm = 5, th = 4, ta = 2, tol = 0.4) {
	dt_eps = 0.001;

	if (gender == "male") {
		// Male Dovetail.
		translate([tol / 1.5, d / 2, th / 2])
		rotate([90, 0, 0])
		linear_extrude(d)
			trapezoid(w - (sm * 2), th, ta, tol);
	} else if (gender == "female") {
		union() {
			// Female dovetail.
			translate([0, (d / 2) + (dt_eps / 2), th / 2])
			rotate([90, 0, 0])
			linear_extrude(d + dt_eps)
				trapezoid(w - (sm * 2), th, ta, 0);
			
			// Tolerance of the fit. Removes a bit of height from the
			// mating surface.
			cube([w + dt_eps, d + dt_eps, tol + 0.2 + dt_eps], center = true);
		}
	} else {
		// Unknown gender.
		assert(false, "Unknown dovetail gender");
	}
}

/**
 * Creates a cap for a male dovetail to cover the last object in a modular
 * system.
 *
 * @param w Dovetail surface width.
 * @param d Dovetail surface depth.
 * @param h Cap height.
 */
module dovetail_cap(w, d, h) {
	difference() {
		cube([w, d, h], center = true);
	
		translate([0, 0, -h / 2])
			dovetail("female", w, d);
	}
}
