/**
 * modular-smd-reel-holder.scad
 * A modular SMD reel holder to organize all of our SMD parts.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

// Constants
eps = 0.01;
$fn = $preview ? 64 : 180;

// Reel dimensions.
reel_diam = 178;
reel_gutter_diam = 60;
reel_hole_diam = 13.5;
reel_tape_width = 9;

// Holder dimensions.
holder_pocket_depth = reel_tape_width + 4;
holder_wall = 3;

// Threaded rod dimensions.
thread_rod_diam = 5;  // M4 with plenty of tolerance.

/**
 * Builds a mockup of an SMD reel for testing.
 *
 * @param outer  Outer diameter.
 * @param hole   Center hole diameter.
 * @param tape   Tape width.
 * @param gutter Diameter of the gutter in center.
 * @param wall   Outer wall thickness.
 */
module smd_reel(outer, hole, tape = 9, gutter = 60, wall = 1.5) {
	outerw = tape + (wall * 2) - eps;
	side_offset = (tape / 2) + (wall / 2);

	color("lightgrey")
	difference() {
		union() {
			// Gutter.
			cylinder(h = wall, d = gutter - eps, center = true);
			difference() {
				cylinder(h = outerw, d = gutter, center = true);
				cylinder(h = outerw + eps, d = gutter - wall,
					center = true);
			}
			
			// Bottom side.
			translate([0, 0, side_offset])
			difference() {
				cylinder(h = wall, d = outer, center = true);
				cylinder(h = wall + eps, d = gutter - eps,
					center = true);
			}
			
			// Top side.
			translate([0, 0, -side_offset])
			difference() {
				cylinder(h = wall, d = outer, center = true);
				cylinder(h = wall + eps, d = gutter - eps,
					center = true);
			}
		}

		// Center hole.
		cylinder(h = outerw + eps, d = hole, center = true);
	}
}

/**
 * Builds up a single-sided SMD reel holder module.
 *
 * @param reel_outer Outer diameter of the SMD reel.
 * @param reel_hole  Center hole diameter of the SMD reel.
 * @param reel_width Outer width of the SMD reel.
 * @param rod_diam   Threaded rod support hole diameter.
 * @param gap        Gap betweeen the reel and the outer frame.
 * @param wall       Outer wall thickness.
 */
module holder_module(reel_outer, reel_hole, reel_width, rod_diam,
		gap = 5, wall = 3) {
	gap2 = gap * 2;
	tape_slit = 2;
	tape_rest = 4;
	
	// Side wall generator.
	module side_wall(depth) {
		linear_extrude(depth)
			polygon([
				[-reel_outer / 2, (-reel_outer / 2) - (gap * 1.5)],
				[(reel_outer / 2) + gap, (-reel_outer / 2) - (gap * 1.5)],
				[(reel_outer / 2) + gap, reel_hole * 2],
				[-reel_hole, reel_hole * 2],
				[-reel_outer / 2, (-reel_outer / 2) + 20]
			]);
	}
	
	// Internal cutouts generator.
	module internal_cutouts(depth) {
		// Tape out slit.
		translate([(reel_outer / 2) + wall, -10, 0])
		rotate([0, 0, 15])
			cube([tape_slit, 100, depth], center = true);
		
		// Tape park slit.
		translate([(reel_outer / 2) + gap - tape_rest, (-reel_outer / 2) + 20, 0])
		difference() {
			// Slit.
			translate([tape_rest * 3, 0, 0])
				cylinder(h = depth, d = tape_rest * 8, center = true);

			// Holding peg.
			translate([tape_rest / 1, 0, 0])
				cylinder(h = depth, d = tape_rest * 2, center = true);
		}
		
		// Reel pocket.
		cylinder(h = depth, d = reel_outer + gap, center = true);
	}
	
	// Holes for the threaded rod to go through.
	module rod_holes(diam) {
		rohalf = reel_outer / 2;

		cylinder(h = 100, d = diam, center = true);
		translate([-rohalf + (gap * 3), -rohalf + gap2, 0])
			cylinder(h = 100, d = diam, center = true);
		translate([rohalf - (gap * 3), -rohalf + gap2, 0])
			cylinder(h = 100, d = diam, center = true);
	}

	difference() {
		#union() {
			// Center axle.
			translate([0, 0, (reel_width / 2) + wall])
				cylinder(h = reel_width, d = reel_hole - 1,
					center = true);

			// Side wall.
			side_wall(wall);
			translate([0, 0, wall - eps])
			difference() {
				side_wall(reel_width - eps);
				internal_cutouts(reel_width * 2);
			}
		}
		
		rod_holes(rod_diam);
	}
}

// SMD reel.
if ($preview) {
	translate([0, 0, holder_wall + (holder_pocket_depth / 2)])
		smd_reel(reel_diam, reel_hole_diam);
}

// Reel holder.
holder_module(reel_diam, reel_hole_diam, holder_pocket_depth,
	thread_rod_diam, wall = holder_wall);
