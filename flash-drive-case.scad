/**
 * flash-drive-case.scad
 * A simple flash drive organizer case.
 *
 * @author Nathan Campos <nathan@innoveworkshop.com>
 */

use <lib/rounded-cube.scad>;

// General parameters.
$fs = 0.1;
nslots = 3;
slot_spacing = 8;

// Case parts parameters.
side_wall = 10;
cs_height = 17;

// Generic flash drive dimensions.
fd_width = 11;
fd_depth = 70;
fd_height = 23;

/**
 * A rough representation of a generic flash drive.
 */
module generic_flash_drive() {
    color("grey")
        roundedcube([fd_width, fd_depth, fd_height], radius = 1);
}

/**
 * Creates a row of flash drive slots.
 *
 * @param slots   Number of slots for flash drives.
 * @param spacing Space between each slot.
 */
module flash_drive_row(slots, spacing) {
    for (i = [0 : (slots - 1)]) {
        translate([(fd_width * i) + (spacing * i), 0, 0])
            generic_flash_drive();
    }
}

/**
 * Builds up the bottom of the case.
 *
 * @param sd_margin  Side margin of the case.
 * @param height     Height of the case's bottom part.
 * @param slots      Number of slots for flash drives.
 * @param spacing    Space between each flash drive slot.
 * @param fl_height  Height of the floor of the case.
 * @param csl_height Height of the case slot for the top case to index.
 */
module case_bottom(sd_margin, height, slots, spacing, fl_height = 2, csl_height = 5) {
    slots_area = (fd_width * slots) + (spacing * (slots - 1));
    case_width = slots_area + (sd_margin * 2);
    case_depth = (sd_margin * 2) + fd_depth;
    fghl_diam = 17;
    eps = 0.01;

    difference() {
        // Case itself.
        roundedcube([case_width, case_depth, height], radius = 3, apply_to = "z");

        union() {
            // Top case indexing ledge.
            color("green")
            translate([sd_margin / 4, sd_margin / 4, height - csl_height])
                cube([case_width - (sd_margin / 2),
                    case_depth - (sd_margin / 2),
                    csl_height + eps]);
            
            // Finger holes.
            color("red")
            translate([case_width / 2, case_depth / 2, height])
            rotate([0, 90, 0])
                cylinder(h = slots_area + sd_margin,
                    d = fghl_diam,
                    center = true);

            // Put slots.
            translate([sd_margin, sd_margin, fl_height])
                flash_drive_row(slots, spacing);
        }
    }
}

/**
 * Builds up the top of the case.
 *
 * @param sd_margin     Side margin of the case.
 * @param slots         Number of slots for flash drives.
 * @param spacing       Space between each flash drive slot.
 * @param cl_height     Height of the ceiling of the case.
 * @param csl_depth     Depth of the bottom case slot for indexing.
 * @param bottom_height Height of the bottom case part.
 * @param h_tol         Tolerance for the space between the flash drives and the ceiling of the case.
 */
module case_top(sd_margin, slots, spacing, cl_height = 2, csl_depth = 5, bottom_height = cs_height, h_tol = 5) {
    slots_area = (fd_width * slots) + (spacing * (slots - 1));
    case_width = slots_area + (sd_margin * 2);
    case_depth = (sd_margin * 2) + fd_depth;
    case_height = h_tol + cl_height + (fd_height + cl_height) - bottom_height;
    eps = 0.01;
    index_tol = 0.5;
    skgrd_tol = 1.5;

    union() {
        difference() {
            union() {
                // Case outside.
                roundedcube([case_width, case_depth, case_height], radius = 3, apply_to = "z");
                
                // Indexing lip.
                color("blue")
                translate([(sd_margin / 4) + index_tol, (sd_margin / 4) + index_tol, index_tol - csl_depth])
                    cube([case_width - (sd_margin / 2) - (index_tol * 2),
                        case_depth - (sd_margin / 2) - (index_tol * 2),
                        csl_depth]);
            }
            
            // Hull for the flash drives.
            color("violet")
            translate([sd_margin / 2, sd_margin / 2, -csl_depth])
                cube([case_width - sd_margin,
                    case_depth - sd_margin,
                    case_height - cl_height + csl_depth]);
        }
        
        // Shake guards.
        for (i = [0 : slots]) {
            color("pink")
            translate([(sd_margin / 4) + index_tol + (skgrd_tol / 2) + ((spacing + fd_width) * i), (case_depth / 2) - (fd_depth / 4), -csl_depth + index_tol + 1])
                cube([spacing - (skgrd_tol * 2),
                    fd_depth / 2,
                    case_height + csl_depth - index_tol - 1 - eps]);
        }
    }
}

/**
 * Generates an assembled case.
 *
 * @param halves_spacing Spacing between the halves.
 */
module case_assembly(halves_spacing) {
    case_bottom(side_wall, cs_height, nslots, slot_spacing);
    translate([0, 0, cs_height + halves_spacing])
        case_top(side_wall, nslots, slot_spacing);
}

/**
 * Generates the top case flipped for printing.
 */
module case_top_flipped() {
    rotate([180, 0, 0])
        case_top(side_wall, nslots, slot_spacing);
}

/**
 * Generates both halves of the case in a position optimal for printing.
 */
module case_both_print() {
    translate([0, 5, 0])
        case_bottom(side_wall, cs_height, nslots, slot_spacing);
    translate([0, -5, 15])
        case_top_flipped();
}

//case_assembly(20);
case_both_print();
//case_bottom(side_wall, cs_height, nslots, slot_spacing);
//case_top_flipped();