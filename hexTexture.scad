use<libs/honeycomb.scad>
include<constants.scad>

wallThickness = 3;

baseThickness = 2;
wallHieght = baseThickness + 3;

honeycombWall = nozzelThickness;

module unit() {
    linear_extrude(baseThickness + 2)  {
        honeycomb(subUnitSide, subUnitSide,5.5, honeycombWall);
    }

    baseside = subUnitSide;
    cube([baseside,baseside,baseThickness]);
}

// unit();
// mirror([0,1,0]) unit();
// mirror([1,0,0]) unit();
mirror([0,1,0]) mirror([1,0,0]) unit();
