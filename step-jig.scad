include <constants.scad>;
use <steps.scad>;

interior_x_in = 1;
interior_y_in = 2;
interior_z_in = 4;

exterior_x  = interior_x_in * inchRatio +  default_wall;
exterior_y = interior_y_in * inchRatio + 2 * default_wall;
exterior_z = interior_z_in * inchRatio + 2 * default_wall;

channel = 1;
channel_y = channel + stepHeight;
channel_z = channel + stepTred;

// difference() {
//     cube([exterior_x, exterior_y, exterior_z]);
//     translate([default_wall,default_wall,default_wall]) {
//         cube([exterior_x - 2 * default_wall, exterior_y - 2 * default_wall, exterior_z]);
//     }


//     stepChannel();

//     translate([exterior_x - default_wall,0,0])  stepChannel();

// }

// module stepChannel() {
//     for(i = [1 : 1 : 11]) {
//         translate([
//             -1, 
//             default_wall - channel + (i * stepHeight),  
//             default_wall + stepTred * (i)]) 
//         cube([
//             2 * default_wall,
//             channel,
//             channel_z]);
//     }


//     for(i = [1 : 1 : 11]) {
//         translate([
//             -1, 
//             default_wall - channel + (i-1) * stepHeight,  
//             default_wall + stepTred* i]) 
//         cube([2 * default_wall,channel_y,channel]);
//     }
// }

difference() {
translate([-default_wall,-default_wall,0]) cube ([default_wall,exterior_y,exterior_z]);
translate([-default_wall * 2,-default_wall + 5,+5]) cube ([default_wall* 2,exterior_y - 10,exterior_z - 10]);
}



translate([0,-default_wall,0]) xBlade();
translate([0,exterior_y- 2 * default_wall,0]) xBlade();

translate([0,-default_wall,exterior_z- inchRatio]) xBlade();
translate([0,exterior_y- 2 * default_wall,exterior_z- inchRatio]) xBlade();


stepProjection();
translate([0,0,exterior_z- default_wall]) 
stepProjection(); 



module xBlade() {
    cube ([exterior_x,default_wall,inchRatio]);
}

module stepProjection() {

    linear_extrude(default_wall) {
        projection(true) 
        translate([0,0, 15])
        rotate([0,90,0]) 
        steps(1);
    }

}

translate([-default_wall, -default_wall, exterior_z/ 2 -default_wall ]) 
#cube ([default_wall, exterior_y, 5 ]);
