inchRatio = 25.4;
nozzelThickness = 0.4;
subUnitSide = 6 * inchRatio;


unitHeight = 1 * inchRatio;
// stepHeight = unitHeight / 12;
stepHeight = unitHeight / 11;
stepTred = (2 * unitHeight) / 11;

$fn = $preview ? 32 : 64;


capHeight = 2 * stepHeight;
capWidth = 4 * nozzelThickness;
taperHeight = .75;
taperWidth = stepTred;

default_wall = 2;


// how thick to make the continuous flat surface of the wall
facadeThickness = 1;
capEdgeDepth = stepTred * 1.5;


// total depth of the rib spike
ribSpikeDepth = stepTred;
ribThickness = 0.5; // how far the rib sticks up from wall facade
ribWidth = 1; // side to side on the rib

