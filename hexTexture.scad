use<libs/honeycomb.scad>
include<constants.scad>

wallThickness = 3;

baseThickness = 2;
wallHieght = baseThickness + 3;

honeycombWall = 3 * nozzelThickness;

linear_extrude(baseThickness + 1)  {
    honeycomb(subUnitSide, subUnitSide,5, honeycombWall);
}

baseside = subUnitSide+ wallThickness;
cube([baseside,baseside,baseThickness]);

translate([0,subUnitSide,0]) cube([baseside, wallThickness, wallHieght]); 
translate([subUnitSide,0,0]) cube([wallThickness,baseside,  wallHieght]); 

