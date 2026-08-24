
 = 24;
box_H = 94.0;
wall_t = 3.0;

chassis_poly = [
    [0, 45], [110, 45], [110, 15],
    [32, 15], [32, -110],
    [110, -110], [110, -230],
    [32, -230], [32, -355],
    [110, -355], [110, -385], [0, -385],
    [-110, -385], [-110, -355],
    [-32, -355], [-32, -230],
    [-110, -230], [-110, -110],
    [-32, -110], [-32, 15],
    [-110, 15], [-110, 45]
];

difference() {
    linear_extrude(height = box_H)
        polygon(points = chassis_poly);

    translate([0, 0, wall_t])
        linear_extrude(height = box_H + 2)
        offset(r = -wall_t)
        polygon(points = chassis_poly);
}
