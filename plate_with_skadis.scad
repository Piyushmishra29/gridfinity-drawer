// Gridfinity baseplate (native, grid-only depth) + Skadis rail butted on the back edge.
// Pass through -D: gridx, gridy, style_plate, style_hole, distancex, fitx (library params)
// plus X0/X1 (plate x extents), NSLOTS. Plate y back edge = gridy*42/2, z 0..5.

include <gridfinity-rebuilt-baseplate.scad>

X0 = -1; X1 = 1;    // -D overridden
NSLOTS = 1;

rail_d = 36.5;      // fills drawer depth beyond the grid
wall = 2;
deck = 5;           // Skadis board thickness at the slots — accessory clips need this
deck_d = 25;        // deck is a band around the slots, not the full strip
cavity_h = 6;       // hook clearance under the deck
slot_w = 5; slot_l = 15;
pitch = 20;
rib = 1.6;

py = gridy * 42 / 2;          // plate back edge (84 for gridy=4)
yc = py + rail_d / 2;
sx0 = (X0 + X1)/2 - (NSLOTS - 1) * pitch / 2;

corner_r = 4;       // matches the gridfinity plate outer corner
cham = 0.8;         // 45-degree top-edge chamfer, matches the gridfinity look

module obround2d(x) {
    translate([x, yc]) hull() {
        translate([0, -(slot_l - slot_w)/2]) circle(d = slot_w, $fn = 48);
        translate([0,  (slot_l - slot_w)/2]) circle(d = slot_w, $fn = 48);
    }
}

// strip footprint: square front edge (mates the plate), R4 back corners
module strip2d() {
    hull() {
        translate([X0, py]) square([X1 - X0, rail_d - corner_r]);
        translate([X0 + corner_r, py + rail_d - corner_r]) circle(r = corner_r, $fn = 64);
        translate([X1 - corner_r, py + rail_d - corner_r]) circle(r = corner_r, $fn = 64);
    }
}

// slot cutter with a chamfered mouth
module skadis_slot(x) {
    translate([0, 0, -1]) linear_extrude(deck + 2) obround2d(x);
    hull() {
        translate([0, 0, deck - cham]) linear_extrude(0.01) obround2d(x);
        translate([0, 0, deck + 0.01]) linear_extrude(0.01) offset(r = cham) obround2d(x);
    }
}

// rail (implicit union with the library's plate output):
// FLUSH variant — solid 5mm strip level with the plate, slots cut through,
// top perimeter chamfered and back corners rounded to match the gridfinity edges.
// Standard Skadis hooks cannot mount (no cavity behind); slots serve custom
// screw/twist-anchor accessories designed for a floor-backed board.
difference() {
    hull() {
        linear_extrude(deck - cham) strip2d();
        translate([0, 0, deck - 0.01]) linear_extrude(0.01) offset(r = -cham) strip2d();
    }
    for (i = [0 : NSLOTS - 1]) skadis_slot(sx0 + i * pitch);
}
