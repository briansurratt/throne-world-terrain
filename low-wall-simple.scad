include<constants.scad>

$fn = $preview ? 32 : 128;

// big set peice walls, lhs only
// all with lip, no rib

// step face
// finishedWall(run=49,startCorner=true,endCorner= true, withLip = true, withRibs=false);

// front face
//finishedWall(run=129,startCorner=false,endCorner= true, withLip = true, withRibs=false);


// side face, printed in halves, no corners
// total length = 228
// finishedWall(run=114,startCorner=false,endCorner= false, withLip = true, withRibs=false);

// rear wing face
//finishedWall(run=154,startCorner=true,endCorner= false, withLip = true, withRibs=false);

// rear center, printed in halves, no corners
// total length =  254
// finishedWall(run=254 / 2,startCorner=true,endCorner= false, withLip = true, withRibs=false);

// front face arc
// insideRoundCorner(radius=2*inchRatio, withLip = true);


// rear face arc
insideRoundCorner(radius=inchRatio, withLip = true);


// experiment calls
// flatWallSection(3);
// finishedWall(run=35,startCorner=true,endCorner= true, withLip = true, withRibs=true);
// finishedWall(run = 50,startCorner=true,endCorner= true, withLip = true, withRibs=true);

// wallProfile(withLip = false);

// corner(withLip = true);

// insideRoundCorner(radius=2*inchRatio, withLip = true);
// outsideRoundCorner(radius=1*inchRatio, withLip = true);

// insideSemiCircle(radius=1*inchRatio, withLip = true);
// outsideSemiCircle(radius=1*inchRatio, withLip = true);

//flatWallSection(100, withLip=false, withRibs=true);

module finishedWall(
    units=2, 
    run=0,
    startCorner=false, 
    endCorner=false, 
    withLip=false,
    withRibs=false
    ){

    echo(str("units = ", units));
    echo(str("run = ", run));
    echo(str("startCorner = ", startCorner));
    echo(str("endCorner = ", endCorner));
    echo(str("withLip = ", withLip));
    echo(str("withRibs = ", withRibs));

    // if the run is not specified use the units
    totalLength = (run == 0) ? (units * inchRatio) : run ;


    echo(str("totalLength = ", totalLength));

    union() {

         flatWallSection(totalLength,withLip,withRibs);

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


module flatWallSection(totalLength =75, withLip=false, withRibs=false) {

    echo("******************************")
    echo("flatWallSection")
    echo(str("totalLength = ", totalLength));
    echo(str("withLip = ", withLip));
    echo(str("withRibs = ", withRibs));
    

    translate([0,totalLength,0])
    rotate([90,0,0])
        linear_extrude(totalLength) {
            wallProfile(withLip);
        }

    if (withLip != true &&  withRibs) {

        // minimum 1/2 from start / divided by inch
        
        numberOfRibs = round((totalLength - inchRatio) / inchRatio);
        // numberOfRibs = round(totalLength / inchRatio);

        echo(str("numberOfRibs = ", numberOfRibs));

        calculatedSpacing = (totalLength - inchRatio) / (numberOfRibs - 1) ;
        echo(str("calculatedSpacing = ", calculatedSpacing));
        

        for(i = [1 : numberOfRibs]) {
            translate([0,inchRatio/2 + (i -1)  * calculatedSpacing]){
                wallRib();
            }
        }

    }

    echo("******************************");

}

module corner(withLip = false) {
    
    intersection() {
        flatWallSection(inchRatio);
        translate([0,stepTred+1,-inchRatio+ stepTred + 1])
        rotate([90,0,0]) flatWallSection(inchRatio);
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

module insideRoundCorner(radius = inchRatio, withLip = false) {
    roundCorner(radius, withLip);
}

module insideSemiCircle(radius = inchRatio, withLip = false) {
    roundCorner(radius, withLip,faceAngle=180);
}

module outsideRoundCorner(radius = inchRatio, withLip = false) {
    roundCorner(radius * -1, withLip);
}

module outsideSemiCircle(radius = inchRatio, withLip = false) {
    roundCorner(radius * -1, withLip,faceAngle=180);
}


module roundCorner(radius = inchRatio, withLip = false, faceAngle=90) {

        rotate_extrude(angle=faceAngle) {
        translate([radius,0,0])
        rotate([0,0,90])
        translate([-inchRatio/2, 0,0])   
        wallProfile(withLip);
    }

}