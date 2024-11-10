include<constants.scad>

// flatWallSection(3);
finishedWall(5,startCorner=false,endCorner= true, withLip = true, withRibs=true);

// wallProfile(withLip = false);

// corner(withLip = true);

// flatWallSection(3, withLip=true, withRibs=true);



module finishedWall(
    units=2, 
    startCorner=false, 
    endCorner=false, 
    withLip=false,
    withRibs=false
    ){

    echo(str("units = ", units));
    echo(str("startCorner = ", startCorner));
    echo(str("endCorner = ", endCorner));
    echo(str("withLip = ", withLip));
    echo(str("withRibs = ", withRibs));

    totalLength = units * inchRatio;

    union() {

         flatWallSection(units,withLip,withRibs);

        if (startCorner == true) {
            translate([0,-(stepTred+1),0])
            corner(withLip=withLip);
        }
        
        if (endCorner == true )  {
            translate([0,totalLength + stepTred + facadeThickness,0])
            mirror([0,1,0]) corner(withLip=withLip);
        }
    }
}


module flatWallSection(units =2, withLip=false, withRibs=false) {

    totalLength = units * inchRatio;

    translate([0,units * inchRatio,0])
    rotate([90,0,0])
        linear_extrude(totalLength) {
            wallProfile(withLip);
        }

    if (withLip != true &&  withRibs) {

        numberOfRibs = units;

        for(i = [1 : numberOfRibs]) {
            translate([0,inchRatio/2 + (i -1)  * inchRatio]){
                wallRib();
            }
        }

    }

}

module corner(withLip = false) {
    
    intersection() {
        flatWallSection(1);
        translate([0,stepTred+1,-inchRatio+ stepTred + 1])
        rotate([90,0,0]) flatWallSection(1);
    }


    if (withLip){
        translate([inchRatio,0,0]) 
        cube([stepHeight, stepTred + 1, stepTred  + 1]) ;
    }
}

module fillet(r) {
   offset(r = -r) {
     offset(delta = r) {
       children();
     }
   }
}


module wallProfile(withLip = false) {

    startVector = [
            [0,0],
            [0,stepTred + 1],
            [stepHeight,stepTred],
            [stepHeight,facadeThickness],
            [unitHeight - stepHeight,facadeThickness],
            [unitHeight - stepHeight,stepTred],
            [unitHeight, stepTred + 1]
    ];

    lipVector = withLip ? [             
        [unitHeight + stepHeight, stepTred + 1],
        [unitHeight + stepHeight, stepTred],
        [unitHeight + 1, stepTred]
    ] : [];

    endVector = [[unitHeight,0]];

    polyVector = concat(startVector,lipVector,endVector);

    fillet(3) {
        polygon(polyVector);
    }

}


module wallRib() {

    outerZ = ribSpikeDepth + 1.15;

    elipseZ = outerZ - facadeThickness - ribThickness;


    translate([unitHeight/2,0,0.125 + outerZ/2]) 
    rotate([90,0,0])
    linear_extrude(height = ribWidth, center=true)

    difference() {
        square(size=[unitHeight, outerZ], center=true);    
        translate([0,outerZ/2,0]) 
        elipse(unitHeight - 2 * stepHeight, elipseZ * 2);
    }

    wallRibCap();
    translate([unitHeight- stepHeight,0,0]) wallRibCap();

}

module wallRibCap()  {

    translate([stepHeight, 0, .5 + (stepHeight * sqrt(3) / 2)])
    rotate([0,-90,0])
    linear_extrude(stepHeight)
    regular_polygon(3, ribSpikeDepth);

}

 module regular_polygon(order = 4, r=1){
     angles=[ for (i = [0:order-1]) i*(360/order) ];
     coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
     polygon(coords);
 }

module elipse (w = 30, l = 10) {
    resize([w,l])circle(d=20);
}
