include<constants.scad>


//steps();

// cap factory

for (a =[2:6]) {
    translate([0, (a-1) * (2 * unitHeight + 20),0]) 
   steps(a);
}


// footerInterface();

module steps(units = 4) {

    depth = 2 * unitHeight;
    width = units * unitHeight;

    for(i = [0 : 1 : 11]) {
        translate([0,i*stepTred, 0]) 
        cube([width, depth- i*stepTred, (i + 1) * stepHeight]) ;
    }

    translate([width-stepTred,0,0]) 
    footerInterface ();

    translate([stepTred,0,0]) 
    mirror([1,0,0]) 
    footerInterface ();


}



module footerInterface() {
    interfaceLength = 2 * stepTred;

difference() {
    cube([stepTred,interfaceLength, 3 *stepHeight]) ;
    translate([0,-0.5, stepHeight + stepTred]) {
        rotate([-90,0,0])  {
            cylinder(interfaceLength + 1, r = stepTred);
        }
    }
}
}



