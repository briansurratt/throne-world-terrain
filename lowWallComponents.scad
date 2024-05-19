
include<constants.scad>


// footer factory
// for (a =[1:5]) {
//     translate([10 * a, 0,0]) 
//     footerRun(a);
// }



// test


// testBase();

// translate([0,0,unitHeight]){
// capInnerRadius();

// translate([unitHeight-capWidth,-capWidth,0]) 
// rotate(a = 90) 
// capInterfaceCorner();

// translate([-capWidth,unitHeight-capWidth,0])
// rotate(a = 180)
// mirror([1,0,0])
// capInterfaceCorner();
// }

// translate([unitHeight,0,0]) 


flatWallSection(5);

// units = number of inches 
module flatWallSection(units=2) {

translate([0,units * inchRatio,0])
    rotate([90,0,0])
    linear_extrude(units * inchRatio) {
        fillet(3) 
        polygon([
            [0,0],
            [0,facadeThickness],
            [unitHeight - stepHeight,facadeThickness],
            [unitHeight - stepHeight,capEdgeDepth],
            [unitHeight, capEdgeDepth],
            [unitHeight,0]
        ]);

    }

    layFlatFooter(units);

    startingOffset = inchRatio * 0.25;
    incrementalOffset = inchRatio * 0.5;
    numberOfBits = units * 2;
    
    for(i = [1 : 1 : numberOfBits]) {
        offset = startingOffset + (i - 1) * incrementalOffset;
        translate([unitHeight,offset,0])
        capAlignmentMale();
    }
    
}




module capAlignmentMale() {
    cylinder(r = 1, h=stepTred);
}

module capAlignmentFemale() {
    cylinder(r = 1.1, h=stepTred);
}


module layFlatFooter(units = 2) {
    translate([0,0,stepTred]) {
        rotate([0,90,0]) {
            footerRun(units);
        }
    }
}



module fillet(r) {
   offset(r = -r) {
     offset(delta = r) {
       children();
     }
   }
}























module testBase() {
//    translate([capWidth,capWidth,0]) 
    difference() {
    cube ([2*unitHeight, 2*unitHeight, unitHeight]);
    cylinder(r=unitHeight,h=unitHeight);
    }
}

// footerRun(5);

// footerCorner();
// minimumFootCorner();
// interfaceFooterCorner();
// footerInsideRadius();
// footerInsideRadius(2);





// capRun(2);
// capInnerRadius();
//  capInnerRadius(1,true,true);
// capInnerRadius(1,true,false);

// capInnerRadius(2);
// capInnerRadius(2,true,true);
// capInnerRadius(2,true,false);
// capCorner();
// capInterfaceCorner();

// #cylinder(h = 5 , r=unitHeight);

// translate([stepTred,stepTred,0]) 
//translate([capWidth,-(capWidth+unitHeight),0]) 
// translate([unitHeight,0,0]) 
// %cube (unitHeight);
// %cylinder(r=unitHeight,h=5);

module footerInsideRadius(unitRadius = 1) {

    r = unitRadius * unitHeight;
    inset = r - taperWidth;

    rotate_extrude(angle = 90, convexity = 10) 
    translate([inset,0,0]) 
    // rotate([-90,0,0]) 
    projection(cut=true) 
    rotate([90,0,0]) 
    footerRun();
    
}


module footerRun(units = 1) {

    difference() {
    cube([stepTred, unitHeight * units, stepHeight +  stepTred]);

    translate([0,-0.5, stepHeight + stepTred]) 
    rotate([-90,0,0]) 
        cylinder(unitHeight  * units + 1 , r = stepTred);
    }

}

module minimumFootCorner() {
    footerCorner(2*taperWidth, 2*taperWidth);
}

module interfaceFooterCorner() {
    footerCorner(taperWidth-stepTred, unitHeight);
}

module footerCorner(l = unitHeight, w = unitHeight) {

    modl = l  + stepTred;
    modw = w + stepTred;

    difference() {

    union() { 
        cube([modw, stepTred,  stepHeight +  stepTred]); // x
        cube([stepTred, modl, stepHeight +  stepTred]); // y
    }


    // x
    translate([-0.5, 0,stepHeight + stepTred]) 
    rotate([0,90,0]) 
        cylinder(modw + 1 , r = stepTred);

    // y
    translate([0,-0.5, stepHeight + stepTred]) 
    rotate([-90,0,0]) 
        cylinder(modl + 1 , r = stepTred);
    }
    
  
}


// cap factory

// for (a =[1:5]) {
//     translate([10 * a, 0,0]) 
//    capRun(a);
// }

module capRun(units = 1) {
    translate([0,unitHeight,0])
    rotate([90,0,0]) 
    linear_extrude(unitHeight * units)
    capPoly();
}

module capPoly() {
    polygon(
        [
            [0,0], 
            [0,capHeight],
            [capWidth,capHeight],
            [capWidth, taperHeight],
            [capWidth + taperWidth, 0]
    //,
      //       [capWidth,0],
        //    [capWidth,-capWidth]
    ]);
}

module capIntegrationCut() {

    
    translate([0,0,-capWidth]) {
        linear_extrude(capHeight + 2 * capWidth) {

            polygon([
                [0,0],
                [0, 2 * taperWidth],
                [2 * taperWidth ,2 *taperWidth]
            ]);

        }
    }
}

module capInnerRadius(unitRadius = 1, yInterface=false,xInterface=false) {

    r = unitRadius * unitHeight;
    inset = r - capWidth;

    //     rotate(a = 180) 
    // capIntegrationCut();

    difference() {
        union() {
            rotate_extrude(angle = 90, convexity = 10)
            translate([inset,0,0]) 
            capPoly();
        }

        if (yInterface) {
            translate([0,inset,0]) 
            capIntegrationCut();
        }


        if (xInterface) {
            translate([inset+2*taperWidth,2 * taperWidth,0]) 
            rotate(a = 180) 
            capIntegrationCut();
        }
    }

}


module taperSizedCapCorner() {
    capCorner(taperWidth);
}

// module capInterfaceCorner() {
//     difference() {
//         capCorner(0,unitHeight );
//             rotate(a = -90) 
//         capIntegrationCut();
//     }
// }


module capInterfaceCorner() {
    difference() {
        capCorner(taperWidth, unitHeight);
        translate([capWidth,0,0]) 
            rotate(a = -90) 
            capIntegrationCut();
    }
}

module capCorner (x = unitHeight, y = unitHeight ) {

    // x
    translate([x+capWidth,0,0]) 
    rotate([90,0,-90]) 
    linear_extrude(x + capWidth)
    capPoly();


    // y
    rotate([90,0,0]) 
    linear_extrude(y + capWidth)
    capPoly();


}