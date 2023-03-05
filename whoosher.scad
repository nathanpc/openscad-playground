//MR WHOOSH FLAMETHROWER MKII
//DO NOT EVER MAKE ONE OF THESE
//HIGH RISK OF FIRE AND BURNS
//adjust these two variables to suit
//leave the "=" and ";" intact
width = 25;  //width of squirter base
dia = 40;  //diameter of tealight cup

//don't modify anything below
$fn = 40;
block = width + 2;

difference() {
    union() {
        // Base for spray unit.
        translate([0, -13.5, 0])
            cube([90, 27, 2]);
        
        // Block for mounting wings.
        translate([35, -(block / 2), 0])
            cube([50, block, 10]);
        
        // Tea light base.
        translate([0, 0, 0])  
            cylinder(h = 6, d1 = dia + 2, d2 = dia + 2);
    }
    
    // Tea light insert.
    translate([0, 0, 2])
        cylinder(h = 5,d1 = dia,d2 = dia);
    
    // Base thermal isolation hole.
    translate([0, 0, -1])
        cylinder(h = 4, d1 = dia - 6, d2 = dia - 6);
    
    // Sprayer base wings.
    translate([34, -(width / 2), 2])
        cube([52, width, 10]);
}