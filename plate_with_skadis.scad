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

module skadis_slot(x) {
    translate([x, 0, 0]) hull() {
        translate([0, yc - (slot_l - slot_w)/2, 0]) cylinder(h = 20, d = slot_w, center = true, $fn = 48);
        translate([0, yc + (slot_l - slot_w)/2, 0]) cylinder(h = 20, d = slot_w, center = true, $fn = 48);
    }
}

// rail (implicit union with the library's plate output):
// open frame of perimeter walls + a slotted deck band centered on the slot row
difference() {
    union() {
        // perimeter walls, full rail height
        difference() {
            translate([X0, py, 0]) cube([X1 - X0, rail_d, cavity_h + deck]);
            translate([X0 + wall, py + wall, -1]) cube([X1 - X0 - 2*wall, rail_d - 2*wall, 2 + cavity_h + deck]);
        }
        // deck band spanning wall to wall
        translate([X0, yc - deck_d/2, cavity_h]) cube([X1 - X0, deck_d, deck]);
    }
    for (i = [0 : NSLOTS - 1]) translate([0, 0, cavity_h + deck/2]) skadis_slot(sx0 + i * pitch);
}
// ribs supporting the deck bridges (only under the deck band)
for (i = [0 : NSLOTS]) {
    rx = sx0 - pitch/2 + i * pitch;
    if (rx > X0 + wall + rib/2 && rx < X1 - wall - rib/2)
        translate([rx - rib/2, yc - deck_d/2, 0]) cube([rib, deck_d, cavity_h]);
}
