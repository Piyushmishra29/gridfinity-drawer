// Drawer 2: 145 x 242 mm space -> 3x5 gridfinity + flush Skadis L-border.
// Grid plate (native, 126 x 210, x +-63 y +-105 z 0..5) + back strip (31.5) + left strip (18.5).
// Flush 5mm, slots cut through, edges softened like drawer 1.

include <gridfinity-rebuilt-baseplate.scad>

deck = 5;
cham = 0.8;
corner_r = 4;
slot_w = 5; slot_l = 15;
pitch = 20;

// plate outline: x -81.5..63, y -105..136.5
bx0 = -81.5; bx1 = 63; by0 = -105; by1 = 136.5;
gx0 = -63; gy1 = 105;               // grid region edges adjoining the strips

module obround2d(cx, cy) {
    translate([cx, cy]) hull() {
        translate([0, -(slot_l - slot_w)/2]) circle(d = slot_w, $fn = 48);
        translate([0,  (slot_l - slot_w)/2]) circle(d = slot_w, $fn = 48);
    }
}

module slot_cut(cx, cy) {
    translate([0, 0, -1]) linear_extrude(deck + 2) obround2d(cx, cy);
    hull() {
        translate([0, 0, deck - cham]) linear_extrude(0.01) obround2d(cx, cy);
        translate([0, 0, deck + 0.01]) linear_extrude(0.01) offset(r = cham) obround2d(cx, cy);
    }
}

// convex 2D rect with selected corners rounded, chamfer-extruded via hull
module soft_prism(shape_pts_rect, round_corners) {
    // shape passed via children: children(0) = 2D shape
    hull() {
        linear_extrude(deck - cham) children(0);
        translate([0, 0, deck - 0.01]) linear_extrude(0.01) offset(r = -cham) children(0);
    }
}

module back_strip2d() {   // x bx0..bx1, y gy1..by1; round both back corners
    hull() {
        translate([bx0, gy1]) square([bx1 - bx0, by1 - gy1 - corner_r]);
        translate([bx0 + corner_r, by1 - corner_r]) circle(r = corner_r, $fn = 64);
        translate([bx1 - corner_r, by1 - corner_r]) circle(r = corner_r, $fn = 64);
    }
}

module left_strip2d() {   // x bx0..gx0, y by0..gy1; round front-left corner
    hull() {
        translate([bx0, by0 + corner_r]) square([gx0 - bx0, gy1 - by0 - corner_r]);
        translate([bx0 + corner_r, by0 + corner_r]) circle(r = corner_r, $fn = 64);
        translate([bx0 + corner_r, by0]) square([gx0 - bx0 - corner_r, gy1 - by0]);
    }
}

// slot positions
back_yc = (gy1 + by1) / 2;                          // 120.75
back_xs = [for (i = [0:5]) -59.25 + i * pitch];     // 6 slots across the back
left_xc = (bx0 + gx0) / 2;                          // -72.25
left_ys = [for (i = [0:8]) -80 + i * pitch];        // 9 slots down the left

difference() {
    union() {
        soft_prism() back_strip2d();
        soft_prism() left_strip2d();
    }
    for (x = back_xs) slot_cut(x, back_yc);
    for (y = left_ys) slot_cut(left_xc, y);
}
