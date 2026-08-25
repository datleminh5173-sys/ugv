// ==============================================================================
// 02. NẮP NÓC XE CÓ BẢN LỀ & KHÓA SNAP-LOCK (ROOF CANOPY LID)
// BỘ PHẬN IN 3D SỐ 2 - SỐ LƯỢNG CẦN IN: 1 CÁI
// NÂNG CẤP: ĐỒNG BỘ VỚI NÓC XE CAO 125mm (chassis_top_z = 125.0mm)
// ĐÃ ĐƯỢC ĐẶT NẰM PHẲNG TRÊN MẶT BÀN IN (Z = 0)
// VẬT LIỆU KHUYÊN DÙNG: PETG / PLA+ / ABS
// ==============================================================================
$fn = 36;

bracket_thick  = 3.5;
bracket_W      = 37.0;
base_L         = 25.0;
chassis_top_z  = 125.0; // Nâng nóc xe cao lên 125mm
arm_L          = 70.0;
wall_t         = 3.0;

L_belly       = 140.0;
y_front_mount = -base_L - arm_L;             // -95mm
y_rear_mount  = y_front_mount - L_belly;     // -235mm
box_y_center  = (y_front_mount + y_rear_mount) / 2; // -165mm

W_belly       = 350.0;
W_corridor    = 176.0;
L_nose        = 85.0;
L_tail        = 85.0;

y_nose_tip    = y_front_mount + L_nose;      // -10mm
y_tail_tip    = y_rear_mount - L_tail;       // -320mm

chassis_outer_poly = [
    [ W_corridor/2,  y_nose_tip],
    [ W_corridor/2,  y_front_mount],
    [ W_belly/2,     y_front_mount],
    [ W_belly/2,     y_rear_mount],
    [ W_corridor/2,  y_rear_mount],
    [ W_corridor/2,  y_tail_tip],
    [-W_corridor/2,  y_tail_tip],
    [-W_corridor/2,  y_rear_mount],
    [-W_belly/2,     y_rear_mount],
    [-W_belly/2,     y_front_mount],
    [-W_corridor/2,  y_front_mount],
    [-W_corridor/2,  y_nose_tip]
];

lid_thick    = 3.5;
sealing_lip  = 3.0;

// ĐẶT NẰM PHẲNG TRÊN BÀN IN Z = 0
translate([0, 0, -(chassis_top_z - sealing_lip)]) {
    difference() {
        union() {
            // [1] Tấm nóc chính
            translate([0, 0, chassis_top_z])
                linear_extrude(height = lid_thick)
                offset(r = 1.5)
                polygon(points = chassis_outer_poly);

            // [2] Gờ lọt lòng chống trượt
            translate([0, 0, chassis_top_z - sealing_lip])
                linear_extrude(height = sealing_lip)
                offset(r = -wall_t - 0.6)
                polygon(points = chassis_outer_poly);

            // [3] 2 Ngàm bản lề sườn trái đúc liền
            for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                for (oy = [-12.0, 12.0]) {
                    translate([-W_belly/2 - 3.5, hy + oy, chassis_top_z + 4.0]) {
                        rotate([90, 0, 0])
                            cylinder(d = 10.0, h = 6.0, center = true);
                    }
                }
                translate([-W_belly/2 + 10.0, hy, chassis_top_z + 2.0]) {
                    cube([26.0, 36.0, 4.0], center = true);
                }
            }

            // [4] Lưỡi ngàm khóa bấm Snap-Lock phía sườn phải
            translate([W_belly/2 + 2.0, box_y_center, chassis_top_z - 3.0]) {
                hull() {
                    cube([5.0, 24.0, 8.0], center = true);
                    translate([2.0, 0, -4.0]) cube([2.0, 20.0, 2.0], center = true);
                }
            }

            // [5] Chữ SUMO dập nổi thể thao xoay ngang -90 độ & khung viền đúc liền trên nóc
            translate([0, box_y_center, chassis_top_z + lid_thick]) {
                rotate([0, 0, -90]) {
                    linear_extrude(height = 2.2)
                        text("SUMO", size = 34, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");

                    difference() {
                        cube([154.0, 54.0, 2.0], center = true);
                        cube([146.0, 46.0, 4.0], center = true);
                    }
                }
            }
        }

        // [6] Lỗ xỏ chốt xoay bản lề D=3.2mm
        for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
            translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0])
                rotate([90, 0, 0])
                cylinder(d = 3.2, h = 45.0, center = true);
        }

        // [7] Hốc tay nắm mở nắp phía sườn phải
        translate([W_belly/2 - 15.0, box_y_center, chassis_top_z + lid_thick/2]) {
            cube([16.0, 48.0, lid_thick + 2.0], center = true);
        }
    }
}
