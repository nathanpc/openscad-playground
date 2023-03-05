//MR WHOOFLER FIRE FOAM MAKER
//DO NOT EVER MAKE ONE OF THESE
$fn=100;
difference(){
    union(){
        difference(){
            union(){
                //first additions
                //finger rim
                translate([0,0,0])  
                cylinder(h=3,d1=45,d2=45);
                //base
                translate([0,0,3])  
                cylinder(h=20,d1=30,d2=15);
                //upper cone
                translate([0,0,23])  
                cylinder(h=40,d1=15,d2=50);
                //upper rim
                translate([0,0,63])  
                cylinder(h=10,d1=50,d2=50);
            }
            
            //first subtractions
            //inner foam cone
            translate([0,0,25])  
            cylinder(h=38,d1=15,d2=48);
            //inner base
            translate([0,0,-1])  
            cylinder(h=23,d1=30,d2=12);
            //upper rim
            translate([0,0,63])  
            cylinder(h=11,d1=48,d2=48);
        }
        
        //second additions
        //injector base
        translate([0,0,0])  
        cylinder(h=23,d1=12,d2=12);
        //diffuser cone
        translate([0,0,25])  
        cylinder(h=10,d1=15,d2=0);
    }
    
    //second subtractions
    //twelve radial vents
    translate([0,0,25])
    for (i=[0:30:330])rotate([65, 0, i]){
        cylinder(h=8, d1=1, d2=1);
    }

    //diffuser cone inner
    translate([0,0,24])  
    cylinder(h=10,d1=14,d2=0);
    //4mm injector entrance
    translate([0,0,-1])  
    cylinder(h=4,d1=4,d2=4);
    //tapered transition
    translate([0,0,3])  
    cylinder(h=5,d1=4,d2=3);
    //seal taper
    translate([0,0,8])  
    cylinder(h=5,d1=3,d2=2.8);
    //tapered transition
    translate([0,0,13])  
    cylinder(h=1,d1=2.8,d2=1);
    //gas feed pipe
    translate([0,0,12])  
    cylinder(h=15,d1=1,d2=1);
    
    //x-ray box
    //translate([-30,-30,-1])
    //cube([60,30,100]);
}