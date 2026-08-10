# Gridfinity Drawer Baseplates — 15 in × 20.5 cm

Custom [Gridfinity](https://gridfinity.xyz/) baseplates sized to exactly fill a drawer measuring **15 in × 20.5 cm (381 × 205 mm)**.

The drawer holds a **9 × 4 grid** of standard 42 mm Gridfinity squares. Since that's too wide for a single print on a Bambu (256 × 256 mm) bed, it's split into two plates that sit side by side.

## Files

| File | Grid | Printed size | Notes |
|---|---|---|---|
| `baseplate_left_5x4_fitted.stl` | 5 × 4 | 212.5 × 204.5 mm | Extra margin on left + back edges |
| `baseplate_right_4x4_fitted.stl` | 4 × 4 | 168.0 × 204.5 mm | Extra margin on right + back edges |
| `baseplate_5x4.stl` | 5 × 4 | 210 × 168 mm | Plain grid, no drawer padding |
| `baseplate_4x4.stl` | 4 × 4 | 168 × 168 mm | Plain grid, no drawer padding |

The `_fitted` plates use the fit-to-drawer padding so the pair fills the drawer edge-to-edge (380.5 × 204.5 mm total — 0.5 mm clearance so they don't jam). The plain plates are included in case you want the grid-only version for a different drawer.

## Print settings

- **Style**: thin baseplate (5 mm tall), no magnet or screw holes — sits loose in the drawer
- No supports needed, prints flat as-is
- 2 walls, 15% infill is plenty
- Any material works; PLA is fine for drawer use

## How they were generated

Rendered with [gridfinity-rebuilt-openscad](https://github.com/kennetek/gridfinity-rebuilt-openscad) by kennetek (MIT licensed):

```bash
# left plate (5×4, padded to 212.5 × 204.5)
openscad -o baseplate_left_5x4_fitted.stl \
  -D gridx=5 -D gridy=4 -D style_plate=0 -D style_hole=0 \
  -D distancex=212.5 -D distancey=204.5 -D fitx=-1 -D fity=1 \
  gridfinity-rebuilt-baseplate.scad

# right plate (4×4, padded to 168 × 204.5)
openscad -o baseplate_right_4x4_fitted.stl \
  -D gridx=4 -D gridy=4 -D style_plate=0 -D style_hole=0 \
  -D distancex=168 -D distancey=204.5 -D fitx=1 -D fity=1 \
  gridfinity-rebuilt-baseplate.scad
```

Gridfinity was created by [Zack Freedman](https://www.youtube.com/watch?v=ra_9zU-mnl8); any standard Gridfinity bin (Printables, MakerWorld, etc.) snaps onto these plates.
