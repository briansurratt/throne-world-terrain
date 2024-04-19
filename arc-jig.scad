use <libs/arc.scad>;
include <constants.scad>;

// arcJig();
arcJig(2 * inchRatio);

module arcJig(radius = inchRatio) {

    jigThickness = 2;
    wireChannel = 0.5;
    negativeThickness = 4;

    jigLength = radius  + 2 * inchRatio;
    jigWidth = radius* 1.25;
    foamDepth = 1 * inchRatio - 1;

    difference() {
    union() {
    cube([jigLength, jigThickness, foamDepth]); // z
    cube([jigLength, jigWidth ,jigThickness]);  // x
    }


    translate([inchRatio,0, -1])  {
    #linear_extrude(height = negativeThickness) 
    rotate(45) 
    arc (
        radius = radius,
        thickness = wireChannel,
        angle = 90,
        fragments = 64
    );

    translate([radius, -1,0]) 
    cube([wireChannel,negativeThickness-1, inchRatio + 2]);
    };
    }
        
}