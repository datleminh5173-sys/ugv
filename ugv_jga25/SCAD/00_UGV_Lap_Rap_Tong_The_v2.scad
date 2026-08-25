// ==============================================================================
// 00. XE ROBOT TỰ HÀNH UGV 4 BÁNH (4WD) - BẢN V2 CƠ CẤU LẮP GHÉP CƠ KHÍ HOÀN CHỈNH
// ==============================================================================
// CÁC HỆ THỐNG CƠ CẤU LIÊN KẾT CƠ KHÍ CHUYÊN DỤNG (MECHANICAL JOINTS):
// 1. MỘNG TRƯỢT MANG CÁ ĐỨNG (VERTICAL DOVETAIL INTERLOCKING RAILS):
//    - 4 Cụm mộng đuôi én góc 60 độ chịu lực cắt và chống vặn xoắn tuyệt đối.
// 2. MẶT BÍCH KÈM HỐC TÁN LỤC GIÁC ÂM CHÌM (CAPTIVE M3 HEX NUT FLANGES):
//    - 8 Hốc tán M3 tiêu chuẩn (S=5.5mm) đúc sẵn bên trong thành vách,
//      cho phép siết bulông M3 cứng như một khối đúc liền mà không bị tuột.
// 3. RAY TRƯỢT GÀI VÈ GIÁP HÔNG (SLIDE-IN FENDER RAILS & SNAP-STOPS):
//    - 4 Vè chắn giáp hông trượt gài theo rãnh mang cá ngang + chốt khóa M3.
// 4. BẢN LÈ KÉP CÓ TRỤC ĐỊNH HƯỚNG & KHÓA GÀI BẬT NHANH (SNAP-LOCK LATCH):
//    - Nắp nóc xe có ngàm khóa đàn hồi dạng mỏ vịt tự khóa khi đóng nắp.
// ==============================================================================

$fn = 32;

// [1] BỘ TÙY CHỌN HIỂN THỊ (CUSTOMIZER)
part_select = "all_assembled";
// Các lựa chọn:
// "all_assembled"        : Toàn bộ xe lắp ghép hoàn thiện (kèm hiển thị ốc bulông)
// "exploded_modules"    : Bóc tách từng module rời (thấy rõ rãnh mang cá & hốc tán)
// "print_chassis_parts" : Trải phẳng các module thân xe trên bàn in Z=0
// "module_1_belly"      : [M1] Khoang bụng trung tâm (Có mộng mang cá + Hốc tán)
// "module_2_front"      : [M2] Mũi trước & Tháp treo trước (Có rãnh âm mang cá)
// "module_3_rear"       : [M3] Đuôi sau & Tháp treo sau (Có rãnh âm mang cá)
// "module_4_fenders"    : [M4] 4 Tấm vè giáp nóc hông (Có rãnh trượt gài)
// "module_5_roof"       : [M5] Nắp nóc xe mở bản lề & Ngàm khóa
// "module_6_suspension" : [M6] 1 Cụm treo & Bánh xe độc lập

roof_open_angle = 0.0;   // Góc mở nắp nóc (0 = Đóng, 45 = Mở nghiêng, 80 = Mở đứng)
exploded_gap    = 55.0;  // Khoảng cách bóc tách khi chọn "exploded_modules"
show_fasteners  = true;  // Hiển thị bulông thép M3 & tán lục giác liên kết

// [2] THÔNG SỐ CƠ BẢN HỆ TREO (CHUẨN 100% NGUYÊN BẢN)
bracket_thick  = 3.5;    // Độ dày tấm gá (3.5mm)
bracket_W      = 37.0;   // Chiều rộng gá xám (37mm)
base_L         = 25.0;   // Chiều dài bản gá
hole_screw_d   = 3.4;    // Lỗ ốc M3 (D=3.4mm)
motor_center_z = -16.5;  // Tâm trục động cơ JGA25
bracket_R      = 15.0;   // Bán kính vòm gá motor

side_wall_H    = 34.0;   
side_wall_z0   = -14.0;  

pin_top_z      = 14.0;
pin_bottom_z   = -8.0;

arm_L          = 70.0;   // Chiều dài thanh đòn (70mm)
arm_thick      = 5.0;    // Độ dày thanh đòn gia cố (5.0mm)
chassis_top_z  = 125.0;  // Chiều cao đỉnh vách nóc (125mm)
foot_L         = 32.0;   // Chiều dài tai ngắn chữ L

piston_p1_y    = -13.0;
piston_p1_z    = bracket_thick + 8.0;

piston_p2_y    = -base_L - arm_L + foot_L/2;
piston_p2_z    = chassis_top_z - bracket_thick - 8.0;

piston_dy      = piston_p2_y - piston_p1_y;
piston_dz      = piston_p2_z - piston_p1_z;

piston_total_L = sqrt(piston_dy * piston_dy + piston_dz * piston_dz);
piston_angle   = atan2(abs(piston_dy), piston_dz);

// [3] KÍCH THƯỚC HÌNH HỌC KHUNG THÂN XE CHIA MODULE
L_belly        = 140.0;                       // Chiều dài khoang bụng giữa
y_front_mount  = -base_L - arm_L;             // Vách trước bụng: Y = -95.0mm
y_rear_mount   = y_front_mount - L_belly;     // Vách sau bụng:  Y = -235.0mm
box_y_center   = (y_front_mount + y_rear_mount) / 2; // Tâm khoang bụng = -165.0mm
suspension_X   = 130.0;                       // Tọa độ X cụm treo (±130mm)

W_belly        = 350.0;                       // Bề rộng sườn bụng (350mm)
W_corridor     = 176.0;                       // Bề rộng mũi & đuôi (176mm)
L_nose         = 85.0;                        // Chiều dài mũi (85mm)
L_tail         = 85.0;                        // Chiều dài đuôi (85mm)
y_nose_tip     = y_front_mount + L_nose;      // Đỉnh mũi xe = -10.0mm
y_tail_tip     = y_rear_mount - L_tail;       // Đáy đuôi xe = -320.0mm

box_H          = chassis_top_z - side_wall_z0;// Chiều cao thùng xe = 109.0mm
wall_t         = 3.2;                         // Độ dày thành vách hộp (3.2mm)
flange_t       = 4.5;                         // Độ dày mặt bích nối (4.5mm)

// Đa giác 2D đáy thùng xe chuẩn
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

// ==============================================================================
// CÁC THƯ VIỆN CƠ CẤU MỘNG MANG CÁ & HỐC TÁN LỤC GIÁC (JOINERY PRIMITIVES)
// ==============================================================================

// Mộng mang cá đực (Male Dovetail Tenon)
module Dovetail_Tenon_Vertical(w_base = 12.0, w_tip = 18.0, depth = 6.0, height = 70.0) {
    linear_extrude(height = height, center = true) {
        polygon(points = [
            [-w_base/2, 0],
            [ w_base/2, 0],
            [ w_tip/2,  depth],
            [-w_tip/2,  depth]
        ]);
    }
}

// Rãnh mang cá cái (Female Dovetail Mortise với khe hở trượt 0.3mm)
module Dovetail_Mortise_Vertical(w_base = 12.6, w_tip = 18.6, depth = 6.4, height = 75.0) {
    linear_extrude(height = height, center = true) {
        polygon(points = [
            [-w_base/2, -0.1],
            [ w_base/2, -0.1],
            [ w_tip/2,  depth],
            [-w_tip/2,  depth]
        ]);
    }
}

// Hốc nhét tán lục giác M3 (Captive M3 Nut Pocket S=5.5mm, H=2.8mm)
module M3_Nut_Pocket_Slot(depth = 12.0) {
    union() {
        // Lỗ xuyên bulông M3
        cylinder(d = hole_screw_d, h = depth + 10.0, center = true);
        // Hốc tán lục giác
        rotate([0, 0, 30])
            cylinder(r = (5.6 / cos(30)) / 2, h = 3.0, center = true, $fn = 6);
        // Rãnh trượt dẫn hướng thả tán vào từ trên
        translate([0, 5.0, 0])
            cube([5.7, 10.0, 3.0], center = true);
    }
}

// Mô hình bulông lục giác chìm M3 bằng thép
module Render_M3_Bolt(length = 16.0) {
    color([0.85, 0.88, 0.92]) {
        // Đầu trụ lục giác chìm
        difference() {
            cylinder(d = 5.5, h = 3.0);
            translate([0, 0, 1.2]) cylinder(r = (2.6/cos(30))/2, h = 2.0, $fn=6);
        }
        // Thân ren
        translate([0, 0, -length]) cylinder(d = 3.0, h = length);
    }
    // Tán M3
    color([0.75, 0.78, 0.82]) {
        translate([0, 0, -length + 1.5])
            cylinder(r = (5.5/cos(30))/2, h = 2.4, center=true, $fn=6);
    }
}

// ==============================================================================
// CHI TIẾT HỆ TREO & BÁNH XE
// ==============================================================================

module Snap_Pin_Stud() {
    pin_d   = 6.0;
    pin_L   = 5.6;
    cap_d   = 7.6;
    cap_L   = 3.8;
    slot_w  = 1.2;

    difference() {
        union() {
            cylinder(d = 12.0, h = 0.8, $fn=24);
            translate([0, 0, 0.8]) cylinder(d = pin_d, h = pin_L, $fn=24);
            translate([0, 0, 0.8 + pin_L]) {
                cylinder(d = cap_d, h = 0.8, $fn=24);
                translate([0, 0, 0.8])
                    cylinder(d1 = cap_d, d2 = pin_d - 1.8, h = cap_L - 0.8, $fn=24);
            }
        }
        translate([0, 0, 0.8 + pin_L * 0.35 + (pin_L * 0.65 + cap_L)/2]) {
            cube([slot_w, cap_d + 4.0, pin_L * 0.65 + cap_L + 1.0], center = true);
            cube([cap_d + 4.0, slot_w, pin_L * 0.65 + cap_L + 1.0], center = true);
        }
    }
}

module Suspension_Link_Arm_Green(length = arm_L) {
    eye_od_snap     = 16.0;
    arm_hole_d_snap = 6.3;

    color([0.15, 0.78, 0.35]) difference() {
        union() {
            hull() {
                cylinder(d=eye_od_snap, h=arm_thick, center=true);
                translate([0, -length, 0]) cylinder(d=eye_od_snap, h=arm_thick, center=true);
            }
            hull() {
                cylinder(d=eye_od_snap - 2.5, h=arm_thick + 1.0, center=true);
                translate([0, -length, 0]) cylinder(d=eye_od_snap - 2.5, h=arm_thick + 1.0, center=true);
            }
        }
        cylinder(d=arm_hole_d_snap, h=arm_thick + 4, center=true);
        translate([0, -length, 0]) cylinder(d=arm_hole_d_snap, h=arm_thick + 4, center=true);
    }
}

module Motor_Bracket_Gray() {
    fillet_r     = 6.0;
    ring_L       = 36.0;
    motor_bore_d = 25.6;

    color([0.60, 0.62, 0.66]) difference() {
        union() {
            translate([0, -base_L/2, bracket_thick/2])
                cube([bracket_W, base_L, bracket_thick], center=true);

            translate([0, bracket_thick/2, (motor_center_z - bracket_R + bracket_thick)/2])
                cube([bracket_W, bracket_thick, abs(motor_center_z - bracket_R) + bracket_thick], center=true);

            translate([0, 0, motor_center_z])
                rotate([90, 0, 0])
                cylinder(r=bracket_R, h=ring_L);

            translate([0, -base_L/2, (motor_center_z + bracket_R + bracket_thick/2)/2])
                cube([2*bracket_R, base_L, abs(motor_center_z + bracket_R - bracket_thick/2) + 0.1], center=true);

            hull() {
                translate([0, -base_L + 1, bracket_thick/2])
                    cube([18, 2, bracket_thick], center=true);
                translate([0, -ring_L + 3, motor_center_z + bracket_R - 1])
                    cube([16, 2, 3], center=true);
            }

            for (side_x = [-1, 1]) {
                posX = side_x * (bracket_W/2 - bracket_thick/2);
                translate([posX, 0, 0])
                    rotate([90, 0, 90])
                    linear_extrude(height = bracket_thick, center = true)
                    hull() {
                        translate([-base_L/2, side_wall_z0 + 1]) square([base_L, 2], center=true);
                        translate([-fillet_r, (side_wall_z0 + side_wall_H) - fillet_r]) circle(r=fillet_r);
                        translate([-base_L + fillet_r, (side_wall_z0 + side_wall_H) - fillet_r]) circle(r=fillet_r);
                    }
                
                for (posZ = [pin_bottom_z, pin_top_z]) {
                    translate([side_x * (bracket_W/2), -base_L/2, posZ])
                        rotate([0, side_x * 90, 0])
                        Snap_Pin_Stud();
                }
            }

            translate([0, piston_p1_y, piston_p1_z]) sphere(d = 10.0);
            translate([0, piston_p1_y, piston_p1_z])
                rotate([piston_angle, 0, 0])
                translate([0, 0, -3.5])
                cylinder(d = 5.0, h = 4.0, center = true);

            hull() {
                translate([0, piston_p1_y, bracket_thick]) cylinder(d = 12.0, h = 0.5);
                translate([0, piston_p1_y, piston_p1_z])
                    rotate([piston_angle, 0, 0])
                    translate([0, 0, -4.5])
                    cylinder(d = 5.6, h = 1.0, center = true);
            }
        }

        translate([0, 1, motor_center_z])
            rotate([90, 0, 0]) {
                cylinder(d=motor_bore_d, h=ring_L + 5);
                translate([0, 0, ring_L - 1.5]) cylinder(d1=motor_bore_d, d2=motor_bore_d + 1.8, h=2.5);
            }

        translate([0, bracket_thick/2, motor_center_z])
            rotate([90, 0, 0]) cylinder(d=7.2, h=bracket_thick + 4, center=true);

        for (offset_x = [-8.5, 8.5]) {
            translate([offset_x, bracket_thick/2, motor_center_z])
                rotate([90, 0, 0]) cylinder(d=hole_screw_d, h=bracket_thick + 4, center=true);
        }

        for (dx = [-7, 7]) {
            for (dy = [-6, -20]) {
                translate([dx, dy, -1]) cylinder(d=hole_screw_d, h=bracket_thick + 4);
                translate([dx, dy, -0.1]) cylinder(d1=5.5, d2=hole_screw_d, h=1.5);
            }
        }
    }
}

// BỘ PHUỘC GIẢM XÓC V2 DÀY D=6.8mm, ĐĨA CHÉN D=30mm
module Spring_Piston_SnapFit_V2(total_L = piston_total_L) {
    collar_od_val    = 30.0;
    collar_thick_val = 4.0;
    cup_rim_h_val    = 2.8;
    cylinder_od_val  = 13.0;
    cyl_h_val        = total_L * 0.52;
    rod_h_val        = total_L * 0.58;

    // Chén dưới & Xilanh Xanh Cobalt
    color([0.20, 0.50, 0.88]) {
        difference() {
            union() {
                sphere(d = 14.0);
                translate([0, 0, 3.5]) cylinder(d1 = 12.0, d2 = 14.0, h = 4.5);
            }
            sphere(d = 10.2);
            translate([0, 0, -7.5]) cylinder(d1 = 11.0, d2 = 8.6, h = 3.5);
            translate([0, 0, -14.0]) cylinder(d = 12.0, h = 7.0);
            cube([1.2, 18.0, 18.0], center = true);
            cube([18.0, 1.2, 18.0], center = true);
        }

        translate([0, 0, 8.0]) {
            difference() {
                union() {
                    translate([0, 0, -collar_thick_val]) cylinder(d=collar_od_val, h=collar_thick_val);
                    cylinder(d=collar_od_val, h=cup_rim_h_val);
                }
                translate([0, 0, -0.1]) cylinder(d=27.6, h=cup_rim_h_val + 1.0);
            }
        }

        difference() {
            union() {
                translate([0, 0, 8.0]) cylinder(d=cylinder_od_val, h=cyl_h_val);
                translate([0, 0, 8.0]) cylinder(d1=15.0, d2=cylinder_od_val, h=3.0);
            }
            translate([0, 0, 7.9]) cylinder(d=9.4, h=cyl_h_val - 3.5 + 0.1);
            translate([0, 0, 8.0 + cyl_h_val - 3.5]) cylinder(d=8.2, h=3.6);
            translate([0, 0, 8.0 + cyl_h_val - 1.5]) cylinder(d1=8.2, d2=10.0, h=1.6);
            for (wz = [18.0 : 12.0 : 8.0 + cyl_h_val - 8.0]) {
                translate([0, 0, wz]) cube([cylinder_od_val + 4.0, 4.0, 5.0], center=true);
            }
        }
    }

    // Chén trên & Ty piton Bạc
    color([0.72, 0.74, 0.78]) {
        translate([0, 0, total_L]) {
            rotate([180, 0, 0]) {
                difference() {
                    union() {
                        sphere(d = 14.0);
                        translate([0, 0, 3.5]) cylinder(d1 = 12.0, d2 = 14.0, h = 4.5);
                    }
                    sphere(d = 10.2);
                    translate([0, 0, -7.5]) cylinder(d1 = 11.0, d2 = 8.6, h = 3.5);
                    translate([0, 0, -14.0]) cylinder(d = 12.0, h = 7.0);
                    cube([1.2, 18.0, 18.0], center = true);
                    cube([18.0, 1.2, 18.0], center = true);
                }

                translate([0, 0, 8.0]) {
                    difference() {
                        union() {
                            translate([0, 0, -collar_thick_val]) cylinder(d=collar_od_val, h=collar_thick_val);
                            cylinder(d=collar_od_val, h=cup_rim_h_val);
                        }
                        translate([0, 0, -0.1]) cylinder(d=27.6, h=cup_rim_h_val + 1.0);
                    }
                }

                difference() {
                    union() {
                        translate([0, 0, 8.0]) cylinder(d=7.6, h=rod_h_val - 4.5);
                        translate([0, 0, 8.0 + rod_h_val - 4.5]) {
                            cylinder(d=8.8, h=1.0);
                            translate([0, 0, 1.0]) cylinder(d1=8.8, d2=5.6, h=3.5);
                        }
                        translate([0, 0, 8.0]) cylinder(d1=13.0, d2=7.6, h=3.0);
                    }
                    translate([0, 0, 8.0 + rod_h_val - 8.0]) {
                        cube([1.2, 11.0, 16.0], center=true);
                        cube([11.0, 1.2, 16.0], center=true);
                    }
                }
            }
        }
    }

    // Lò xo Đỏ Thể Thao D=6.8mm
    color([0.90, 0.15, 0.15]) {
        spring_start_z = 8.0;
        spring_end_z   = total_L - 8.0;
        spring_height  = spring_end_z - spring_start_z;
        turns          = 5.0;
        steps          = 80;
        r_mean         = 10.2;
        wire_d         = 6.8;

        difference() {
            union() {
                translate([0, 0, spring_start_z + wire_d/2])
                    rotate_extrude($fn=48) translate([r_mean, 0, 0]) circle(d=wire_d, $fn=24);

                for (i = [0 : steps - 1]) {
                    t1 = i / steps;
                    t2 = (i + 1) / steps;
                    z1 = spring_start_z + wire_d/2 + t1 * (spring_height - wire_d);
                    z2 = spring_start_z + wire_d/2 + t2 * (spring_height - wire_d);
                    a1 = t1 * turns * 360;
                    a2 = t2 * turns * 360;
                    hull() {
                        translate([r_mean * cos(a1), r_mean * sin(a1), z1]) sphere(d=wire_d, $fn=20);
                        translate([r_mean * cos(a2), r_mean * sin(a2), z2]) sphere(d=wire_d, $fn=20);
                    }
                }

                translate([0, 0, spring_end_z - wire_d/2])
                    rotate_extrude($fn=48) translate([r_mean, 0, 0]) circle(d=wire_d, $fn=24);
            }
            translate([0, 0, spring_start_z - 15.0]) cube([60.0, 60.0, 30.0], center=true);
            translate([0, 0, spring_end_z + 15.0]) cube([60.0, 60.0, 30.0], center=true);
        }
    }
}

// BÁNH XE TỔ ONG D=96mm
module Honeycomb_Wheel_Assembly(OD = 96.0, width = 34.0) {
    rim_d   = 48.0;
    tire_od = OD;
    n_cells = 18;

    color([0.28, 0.30, 0.34]) {
        difference() {
            union() {
                cylinder(d=rim_d, h=width);
                cylinder(d=rim_d + 3.0, h=3.0);
                translate([0, 0, width - 3.0]) cylinder(d=rim_d + 3.0, h=3.0);
            }
            translate([0, 0, -1]) cylinder(r=(12.3 / cos(30)) / 2, h=7.0, $fn=6);
            translate([0, 0, -2]) cylinder(d=4.5, h=width + 4);
        }
    }

    color([0.15, 0.15, 0.15]) {
        difference() {
            cylinder(d=tire_od, h=width);
            translate([0, 0, -1]) cylinder(d=rim_d, h=width + 2);
            for (i = [0 : n_cells - 1]) {
                rotate([0, 0, i * (360 / n_cells)])
                    translate([30.0, 0, -1])
                    cylinder(r=(7.0 / cos(30)) / 2, h=width + 2, $fn=6);
                rotate([0, 0, i * (360 / n_cells) + 10.0])
                    translate([38.5, 0, -1])
                    cylinder(r=(8.2 / cos(30)) / 2, h=width + 2, $fn=6);
            }
        }
    }

    color([0.10, 0.55, 0.95]) {
        translate([0, 0, width - 4.5]) {
            difference() {
                cylinder(r=(7.0 / cos(30)) / 2, h=4.0, $fn=6);
                translate([0, 0, -1]) cylinder(d=4.0, h=6.0);
            }
        }
    }
}

// CỤM GÓC BÁNH XE HOÀN THIỆN
module Single_Suspension_Corner_Module() {
    Motor_Bracket_Gray();

    color([0.84, 0.86, 0.88]) {
        translate([0, -19.0, motor_center_z])
            rotate([-90, 0, 0]) {
                cylinder(d=25.0, h=19.0);
                translate([0, 0, -31.0]) cylinder(d=24.4, h=31.0);
            }
    }

    translate([0, 13.5, motor_center_z])
        rotate([-90, 0, 0])
        Honeycomb_Wheel_Assembly(OD = 96.0, width = 34.0);

    for (side_x = [-1, 1]) {
        arm_posX = side_x * (bracket_W/2 + arm_thick/2 + 0.8);
        translate([arm_posX, -base_L/2, pin_top_z])
            rotate([0, 90, 0]) Suspension_Link_Arm_Green(length = arm_L);
        translate([arm_posX, -base_L/2, pin_bottom_z])
            rotate([0, 90, 0]) Suspension_Link_Arm_Green(length = arm_L);
    }

    translate([0, piston_p1_y, piston_p1_z])
        rotate([piston_angle, 0, 0])
        Spring_Piston_SnapFit_V2(total_L = piston_total_L);
}

// Gá Tháp Treo trên khung
module Chassis_Mount_Station_Geometry() {
    ear_posY     = -base_L/2 + foot_L/2;
    gusset_thick = 3.5;
    gusset_L_y   = 28.0;
    gusset_H_z   = 36.0;

    difference() {
        union() {
            translate([-bracket_W/2 + bracket_thick/2, 0, (pin_top_z + pin_bottom_z)/2])
                cube([bracket_thick, base_L, side_wall_H], center=true);

            translate([bracket_W/2 - bracket_thick/2, 0, (pin_top_z + pin_bottom_z)/2])
                cube([bracket_thick, base_L, side_wall_H], center=true);

            for (side_x = [-1, 1]) {
                for (posZ = [pin_bottom_z, pin_top_z]) {
                    translate([side_x * (bracket_W/2), 0, posZ])
                        rotate([0, side_x * 90, 0])
                        Snap_Pin_Stud();
                }
            }

            translate([0, ear_posY, piston_p2_z]) sphere(d = 10.0);
            translate([0, ear_posY, piston_p2_z])
                rotate([piston_angle, 0, 0])
                translate([0, 0, 3.5])
                cylinder(d = 5.0, h = 4.0, center = true);

            hull() {
                translate([0, ear_posY, chassis_top_z - bracket_thick])
                    cylinder(d = 12.0, h = 0.5, center = true);
                translate([0, ear_posY, piston_p2_z])
                    rotate([piston_angle, 0, 0])
                    translate([0, 0, 4.5])
                    cylinder(d = 5.6, h = 1.0, center = true);
            }

            for (side_x = [-1, 1]) {
                posX = side_x * (bracket_W/2 - gusset_thick/2);
                translate([posX, -base_L/2, chassis_top_z - bracket_thick]) {
                    rotate([90, 0, 90])
                        linear_extrude(height = gusset_thick, center = true)
                        polygon(points = [[0, 0], [gusset_L_y, 0], [0, -gusset_H_z]]);
                }
            }
        }
    }
}

// ==============================================================================
// 5 MODULE THÂN XE V2 VỚI CƠ CẤU LẮP GHÉP MỘNG MANG CÁ & HỐC TÁN M3
// ==============================================================================

// ------------------------------------------------------------------------------
// [MODULE 1] KHOANG BỤNG TRUNG TÂM (CENTRAL BELLY HULL)
// Kích thước: 350mm x 140mm x 109mm (Khớp bàn in 320x390 xoay dọc)
// Màu: Xám Đen Nhám Slate [0.22, 0.24, 0.28]
// Cơ cấu: 4 Mộng Đực Mang Cá Đứng + 8 Hốc Tán Lục Giác M3 Đúc Sẵn
// ------------------------------------------------------------------------------
module Module_1_Central_Belly_Hull() {
    color([0.22, 0.24, 0.28]) {
        difference() {
            union() {
                // Thùng chính bụng xe
                translate([0, box_y_center, (chassis_top_z + side_wall_z0)/2])
                    cube([W_belly, L_belly, box_H], center = true);

                // Gờ miệng trên
                translate([0, box_y_center, chassis_top_z - 2.0])
                    cube([W_belly + 6.0, L_belly + 4.0, 4.0], center = true);

                // Bản lề sườn trái
                for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                    translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0])
                        rotate([90, 0, 0]) cylinder(d = 10.0, h = 18.0, center = true);
                }

                // Ngàm khóa sườn phải
                translate([W_belly/2 + 3.0, box_y_center, chassis_top_z - 4.0]) {
                    difference() {
                        cube([10.0, 42.0, 12.0], center = true);
                        translate([0, 0, 2.0]) cube([12.0, 30.0, 8.0], center = true);
                    }
                }

                // [CƠ CẤU 1] 4 MỘNG MANG CÁ ĐỰC ĐỨNG (MALE DOVETAILS)
                // 2 Mộng phía trước hướng về Module 2
                for (sx = [-55.0, 55.0]) {
                    translate([sx, y_front_mount, (chassis_top_z + side_wall_z0)/2])
                        rotate([0, 0, 0])
                        Dovetail_Tenon_Vertical(w_base = 12.0, w_tip = 18.0, depth = 6.0, height = 75.0);
                }
                // 2 Mộng phía sau hướng về Module 3
                for (sx = [-55.0, 55.0]) {
                    translate([sx, y_rear_mount, (chassis_top_z + side_wall_z0)/2])
                        rotate([0, 0, 180])
                        Dovetail_Tenon_Vertical(w_base = 12.0, w_tip = 18.0, depth = 6.0, height = 75.0);
                }

                // [CƠ CẤU 3] 4 RAY TRƯỢT GÀI VÈ GIÁP HÔNG (SLIDE-IN FENDER RAILS)
                for (sx = [-1, 1]) {
                    for (fy = [y_front_mount + 15, y_rear_mount - 15 + L_belly]) {
                        translate([sx * (W_belly/2 - 2.0), fy, chassis_top_z - 8.0])
                            rotate([0, sx * 90, 0])
                            cylinder(d = 8.0, h = 6.0, center = true);
                    }
                }
            }

            // Khoét rỗng thùng xe
            translate([0, box_y_center, side_wall_z0 + wall_t + (box_H + 5)/2])
                cube([W_belly - 2*wall_t, L_belly - 2*wall_t, box_H + 5], center = true);

            // Cửa thông khoang trước & sau
            translate([0, y_front_mount, (chassis_top_z + side_wall_z0)/2 + 8])
                cube([W_corridor - 2*wall_t - 4, 25.0, box_H - 24], center = true);
            translate([0, y_rear_mount, (chassis_top_z + side_wall_z0)/2 + 8])
                cube([W_corridor - 2*wall_t - 4, 25.0, box_H - 24], center = true);

            // Lỗ trục bản lề D=3.2mm
            for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0])
                    rotate([90, 0, 0]) cylinder(d = 3.2, h = 30.0, center = true);
            }

            // [CƠ CẤU 2] 8 HỐC TÁN LỤC GIÁC M3 ÂM CHÌM (CAPTIVE NUT POCKETS)
            // 4 Hốc mặt bích trước
            for (sx = [-W_corridor/2 + 12, W_corridor/2 - 12]) {
                for (sz = [side_wall_z0 + 20, chassis_top_z - 20]) {
                    translate([sx, y_front_mount - wall_t - 1.5, sz])
                        rotate([90, 0, 0])
                        M3_Nut_Pocket_Slot(depth = 16.0);
                }
            }
            // 4 Hốc mặt bích sau
            for (sx = [-W_corridor/2 + 12, W_corridor/2 - 12]) {
                for (sz = [side_wall_z0 + 20, chassis_top_z - 20]) {
                    translate([sx, y_rear_mount + wall_t + 1.5, sz])
                        rotate([-90, 0, 0])
                        M3_Nut_Pocket_Slot(depth = 16.0);
                }
            }
        }

        // Khay pin Li-Po / 18650 tích hợp rãnh đai Velcro
        translate([0, box_y_center, side_wall_z0 + wall_t]) {
            difference() {
                cube([80.0, 130.0, 14.0], center = true);
                translate([0, 0, 2.0]) cube([74.0, 124.0, 16.0], center = true);
                translate([0, -32.0, -3.5]) cube([84.0, 20.0, 4.0], center = true);
                translate([0, 32.0, -3.5])  cube([84.0, 20.0, 4.0], center = true);
            }
        }

        // Trụ bắt ốc PCB Standoffs
        for (sx = [-120, -60, 60, 120]) {
            for (sy = [box_y_center - 35, box_y_center + 35]) {
                translate([sx, sy, side_wall_z0 + wall_t])
                    difference() {
                        cylinder(d=6.0, h=6.0);
                        translate([0, 0, 1]) cylinder(d=2.5, h=6);
                    }
            }
        }
    }
}

// ------------------------------------------------------------------------------
// [MODULE 2] MŨI TRƯỚC & THÁP TREO TRƯỚC (FRONT BAY & SUSPENSION TOWERS)
// Kích thước: 176mm x 95mm x 109mm
// Màu: Cyber Orange [0.95, 0.42, 0.12]
// Cơ cấu: 2 Rãnh Âm Mang Cá Đứng + 4 Lỗ Bắt Bulông M3 Mặt Bích
// ------------------------------------------------------------------------------
module Module_2_Front_Bay() {
    color([0.95, 0.42, 0.12]) {
        difference() {
            union() {
                // Vỏ mũi trước
                translate([0, 0, side_wall_z0]) {
                    linear_extrude(height = box_H)
                        polygon(points = [
                            [ W_corridor/2,  y_nose_tip],
                            [ W_corridor/2,  y_front_mount],
                            [-W_corridor/2,  y_front_mount],
                            [-W_corridor/2,  y_nose_tip]
                        ]);
                    translate([0, 0, box_H - 4.0])
                        linear_extrude(height = 4.0)
                        offset(r = 3.0)
                        polygon(points = [
                            [ W_corridor/2,  y_nose_tip],
                            [ W_corridor/2,  y_front_mount],
                            [-W_corridor/2,  y_front_mount],
                            [-W_corridor/2,  y_nose_tip]
                        ]);
                }

                // 2 Cụm Gá Tháp Treo Trước Đúc Liền
                translate([-suspension_X, -base_L/2 - arm_L, 0]) mirror([1, 0, 0]) Chassis_Mount_Station_Geometry();
                translate([suspension_X, -base_L/2 - arm_L, 0])  Chassis_Mount_Station_Geometry();

                // Mặt bích tăng cứng liên kết
                translate([0, y_front_mount + flange_t/2, (chassis_top_z + side_wall_z0)/2])
                    cube([W_corridor, flange_t, box_H], center = true);
            }

            // Khoét rỗng lòng mũi
            translate([0, 0, side_wall_z0 + wall_t]) {
                linear_extrude(height = box_H + 5.0)
                    offset(r = -wall_t)
                    polygon(points = [
                        [ W_corridor/2,  y_nose_tip],
                        [ W_corridor/2,  y_front_mount + 2],
                        [-W_corridor/2,  y_front_mount + 2],
                        [-W_corridor/2,  y_nose_tip]
                    ]);
            }

            // 2 Lỗ luồn dây viên thuốc
            for (sx = [-1, 1]) {
                hull() {
                    translate([sx * suspension_X, y_front_mount, 14.0]) rotate([90, 0, 0]) cylinder(d = 8.5, h = 30, center = true);
                    translate([sx * suspension_X, y_front_mount, 1.0])  rotate([90, 0, 0]) cylinder(d = 8.5, h = 30, center = true);
                }
            }

            // [CƠ CẤU 1] 2 RÃNH ÂM MANG CÁ ĐỨNG ĐÓN MỘNG MODULE 1 (FEMALE DOVETAILS)
            for (sx = [-55.0, 55.0]) {
                translate([sx, y_front_mount - 0.1, (chassis_top_z + side_wall_z0)/2])
                    rotate([0, 0, 0])
                    Dovetail_Mortise_Vertical(w_base = 12.6, w_tip = 18.6, depth = 6.4, height = 78.0);
            }

            // [CƠ CẤU 2] 4 LỖ XUYÊN BULÔNG M3 MẶT BÍCH
            for (sx = [-W_corridor/2 + 12, W_corridor/2 - 12]) {
                for (sz = [side_wall_z0 + 20, chassis_top_z - 20]) {
                    translate([sx, y_front_mount + 10.0, sz])
                        rotate([90, 0, 0])
                        cylinder(d = hole_screw_d, h = 30.0, center = true);
                    // Hốc vát mép đầu bulông chìm
                    translate([sx, y_front_mount + flange_t + 1.0, sz])
                        rotate([90, 0, 0])
                        cylinder(d = 6.2, h = 8.0, center = true);
                }
            }

            // Khe gió khí động học (Louver Vents)
            for (vy = [-55, -45, -35]) {
                translate([W_corridor/2, vy, 40.0]) rotate([0, 30, 0]) cube([12.0, 6.0, 2.5], center=true);
                translate([-W_corridor/2, vy, 40.0]) rotate([0, -30, 0]) cube([12.0, 6.0, 2.5], center=true);
            }
        }
    }
}

// ------------------------------------------------------------------------------
// [MODULE 3] ĐUÔI SAU & THÁP TREO SAU (REAR BAY & SUSPENSION TOWERS)
// Kích thước: 176mm x 95mm x 109mm
// Màu: Cyber Orange [0.95, 0.42, 0.12]
// Cơ cấu: 2 Rãnh Âm Mang Cá Đứng + 4 Lỗ Bắt Bulông M3 Mặt Bích
// ------------------------------------------------------------------------------
module Module_3_Rear_Bay() {
    color([0.95, 0.42, 0.12]) {
        difference() {
            union() {
                translate([0, 0, side_wall_z0]) {
                    linear_extrude(height = box_H)
                        polygon(points = [
                            [ W_corridor/2,  y_rear_mount],
                            [ W_corridor/2,  y_tail_tip],
                            [-W_corridor/2,  y_tail_tip],
                            [-W_corridor/2,  y_rear_mount]
                        ]);
                    translate([0, 0, box_H - 4.0])
                        linear_extrude(height = 4.0)
                        offset(r = 3.0)
                        polygon(points = [
                            [ W_corridor/2,  y_rear_mount],
                            [ W_corridor/2,  y_tail_tip],
                            [-W_corridor/2,  y_tail_tip],
                            [-W_corridor/2,  y_rear_mount]
                        ]);
                }

                // 2 Cụm Gá Tháp Treo Sau
                translate([-suspension_X, box_y_center * 2 - (-base_L/2 - arm_L), 0])
                    mirror([1, 0, 0]) mirror([0, 1, 0]) Chassis_Mount_Station_Geometry();
                translate([suspension_X, box_y_center * 2 - (-base_L/2 - arm_L), 0])
                    mirror([0, 1, 0]) Chassis_Mount_Station_Geometry();

                // Mặt bích tăng cứng
                translate([0, y_rear_mount - flange_t/2, (chassis_top_z + side_wall_z0)/2])
                    cube([W_corridor, flange_t, box_H], center = true);
            }

            translate([0, 0, side_wall_z0 + wall_t]) {
                linear_extrude(height = box_H + 5.0)
                    offset(r = -wall_t)
                    polygon(points = [
                        [ W_corridor/2,  y_rear_mount - 2],
                        [ W_corridor/2,  y_tail_tip],
                        [-W_corridor/2,  y_tail_tip],
                        [-W_corridor/2,  y_rear_mount - 2]
                    ]);
            }

            // 2 Lỗ luồn dây viên thuốc
            for (sx = [-1, 1]) {
                hull() {
                    translate([sx * suspension_X, y_rear_mount, 14.0]) rotate([90, 0, 0]) cylinder(d = 8.5, h = 30, center = true);
                    translate([sx * suspension_X, y_rear_mount, 1.0])  rotate([90, 0, 0]) cylinder(d = 8.5, h = 30, center = true);
                }
            }

            // [CƠ CẤU 1] 2 RÃNH ÂM MANG CÁ ĐỨNG ĐÓN MỘNG MODULE 1
            for (sx = [-55.0, 55.0]) {
                translate([sx, y_rear_mount + 0.1, (chassis_top_z + side_wall_z0)/2])
                    rotate([0, 0, 180])
                    Dovetail_Mortise_Vertical(w_base = 12.6, w_tip = 18.6, depth = 6.4, height = 78.0);
            }

            // [CƠ CẤU 2] 4 LỖ XUYÊN BULÔNG M3 MẶT BÍCH
            for (sx = [-W_corridor/2 + 12, W_corridor/2 - 12]) {
                for (sz = [side_wall_z0 + 20, chassis_top_z - 20]) {
                    translate([sx, y_rear_mount - 10.0, sz])
                        rotate([90, 0, 0])
                        cylinder(d = hole_screw_d, h = 30.0, center = true);
                    translate([sx, y_rear_mount - flange_t - 1.0, sz])
                        rotate([90, 0, 0])
                        cylinder(d = 6.2, h = 8.0, center = true);
                }
            }
        }
    }
}

// ------------------------------------------------------------------------------
// [MODULE 4] 4 TẤM VÈ GIÁP NÓC HÔNG (MODULAR FENDER DECKS)
// Kích thước: 105mm x 94mm x 42mm
// Màu: Xám Kim Loại Gunmetal [0.45, 0.48, 0.52]
// Cơ cấu: Rãnh Trượt Gài Khóa Clip-On M3 Chống Rung
// ------------------------------------------------------------------------------
module Single_Fender_Deck_Piece() {
    fender_in_x  = 88.0;   
    fender_out_x = 182.0;  
    fender_w     = fender_out_x - fender_in_x; 
    fender_L     = 105.0;  
    fender_thick = 3.5;    
    lip_H        = 42.0;   
    arch_R       = 56.0;   

    difference() {
        union() {
            translate([fender_in_x, -95.0, chassis_top_z - fender_thick])
                cube([fender_w, fender_L, fender_thick]);

            translate([fender_out_x - fender_thick, -95.0, chassis_top_z - lip_H])
                cube([fender_thick, fender_L, lip_H]);

            for (rib_y = [-80 : 18 : -26]) {
                translate([132.0, rib_y, chassis_top_z])
                    rotate([0, 0, 25])
                    hull() {
                        cube([26.0, 5.0, 0.1], center=true);
                        translate([0, 0, 1.5]) cube([22.0, 3.0, 0.1], center=true);
                    }
            }

            // Gờ rãnh trượt Clip-on gài vào khung xe
            translate([fender_in_x + 6.0, -95.0 + 15.0, chassis_top_z - fender_thick - 5.0]) {
                difference() {
                    cube([12.0, 20.0, 10.0], center = true);
                    translate([-4.0, 0, 0]) cube([6.0, 22.0, 12.0], center = true);
                }
            }
        }

        // Vòm bánh xe
        translate([fender_out_x - fender_thick - 1, 0, motor_center_z])
            rotate([0, 90, 0]) cylinder(r = arch_R, h = fender_thick + 4);

        // Lỗ ốc M3 khóa vè vào khung
        translate([fender_in_x + 6.0, -95.0 + 15.0, chassis_top_z - fender_thick - 5.0])
            rotate([0, 90, 0]) cylinder(d = hole_screw_d, h = 20.0, center = true);
    }
}

module Module_4_All_Fenders() {
    color([0.45, 0.48, 0.52]) {
        Single_Fender_Deck_Piece();
        mirror([1, 0, 0]) Single_Fender_Deck_Piece();
        translate([0, box_y_center * 2, 0]) mirror([0, 1, 0]) Single_Fender_Deck_Piece();
        translate([0, box_y_center * 2, 0]) mirror([1, 0, 0]) mirror([0, 1, 0]) Single_Fender_Deck_Piece();
    }
}

// ------------------------------------------------------------------------------
// [MODULE 5] NẮP NÓC XE MỞ BẢN LỀ V2 (HINGED CANOPY ROOF LID)
// Kích thước: 350mm x 320mm x 15mm
// Màu: Xám Titan [0.30, 0.33, 0.38] + Chữ SUMO V2 Trắng + Tay Nắm Cam
// Cơ cấu: Bản Lề Kép Trục Thép D=3mm + Ngàm Khóa Tự Bật Quick-Latch
// ------------------------------------------------------------------------------
module Module_5_Hinged_Roof_Lid() {
    lid_thick   = 3.5;
    sealing_lip = 3.0;

    translate([-W_belly/2 - 3.5, 0, chassis_top_z + 4.0])
    rotate([0, -roof_open_angle, 0])
    translate([W_belly/2 + 3.5, 0, -(chassis_top_z + 4.0)]) {

        // Thân nắp nóc xe
        color([0.30, 0.33, 0.38]) {
            difference() {
                union() {
                    translate([0, 0, chassis_top_z])
                        linear_extrude(height = lid_thick)
                        offset(r = 1.5)
                        polygon(points = chassis_outer_poly);

                    translate([0, 0, chassis_top_z - sealing_lip])
                        linear_extrude(height = sealing_lip)
                        offset(r = -wall_t - 0.6)
                        polygon(points = chassis_outer_poly);

                    // Bản lề trái
                    for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                        for (oy = [-12.0, 12.0]) {
                            translate([-W_belly/2 - 3.5, hy + oy, chassis_top_z + 4.0])
                                rotate([90, 0, 0]) cylinder(d = 10.0, h = 6.0, center = true);
                        }
                        translate([-W_belly/2 + 10.0, hy, chassis_top_z + 2.0])
                            cube([26.0, 36.0, 4.0], center = true);
                    }

                    // Ngàm khóa phải
                    translate([W_belly/2 + 2.0, box_y_center, chassis_top_z - 3.0]) {
                        hull() {
                            cube([5.0, 24.0, 8.0], center = true);
                            translate([2.0, 0, -4.0]) cube([2.0, 20.0, 2.0], center = true);
                        }
                    }

                    // Khung viền logo
                    translate([0, box_y_center, chassis_top_z + lid_thick]) {
                        rotate([0, 0, -90]) {
                            difference() {
                                cube([160.0, 54.0, 2.0], center = true);
                                cube([152.0, 46.0, 4.0], center = true);
                            }
                        }
                    }

                    // Đế cảm biến LiDAR
                    translate([0, y_nose_tip - 45.0, chassis_top_z + lid_thick]) {
                        cylinder(d = 76.0, h = 2.5);
                    }
                }

                // Lỗ chốt bản lề
                for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                    translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0])
                        rotate([90, 0, 0]) cylinder(d = 3.2, h = 45.0, center = true);
                }

                // Hốc tay nắm mở nắp
                translate([W_belly/2 - 15.0, box_y_center, chassis_top_z + lid_thick/2])
                    cube([16.0, 48.0, lid_thick + 2.0], center = true);

                // 4 Lỗ ốc M3 gắn LiDAR
                for (ang = [45, 135, 225, 315]) {
                    translate([28.0 * cos(ang), (y_nose_tip - 45.0) + 28.0 * sin(ang), chassis_top_z - 1])
                        cylinder(d = 3.4, h = lid_thick + 6.0);
                }
            }
        }

        // Chữ SUMO V2 nổi màu trắng
        color([0.95, 0.95, 0.95]) {
            translate([0, box_y_center, chassis_top_z + lid_thick]) {
                rotate([0, 0, -90]) {
                    linear_extrude(height = 2.4)
                        text("SUMO V2", size = 28, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
                }
            }
        }

        // Tay nắm móc màu Cam
        color([0.95, 0.42, 0.12]) {
            translate([W_belly/2 - 15.0, box_y_center, chassis_top_z + lid_thick - 1.0]) {
                difference() {
                    hull() {
                        cube([18.0, 56.0, 5.0], center = true);
                        translate([4.0, 0, 4.0]) cube([8.0, 42.0, 2.0], center = true);
                    }
                    translate([1.0, 0, 1.0]) cube([8.0, 36.0, 8.0], center = true);
                }
            }
        }

        // Chốt trục thép bản lề màu bạc
        color("Silver") {
            for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0])
                    rotate([90, 0, 0]) cylinder(d = 3.0, h = 40.0, center = true);
            }
        }
    }
}

// ==============================================================================
// HIỂN THỊ CÁC BULÔNG THÉP M3 LIÊN KẾT GIỮA CÁC MODULE (FASTENER HARDWARE)
// ==============================================================================
module Fastener_Hardware_Assembly() {
    if (show_fasteners) {
        // 4 Bulông M3 liên kết Mũi Trước (Module 2) vào Thùng Bụng (Module 1)
        for (sx = [-W_corridor/2 + 12, W_corridor/2 - 12]) {
            for (sz = [side_wall_z0 + 20, chassis_top_z - 20]) {
                translate([sx, y_front_mount + flange_t + 1.0, sz])
                    rotate([90, 0, 0])
                    Render_M3_Bolt(length = 16.0);
            }
        }
        // 4 Bulông M3 liên kết Đuôi Sau (Module 3) vào Thùng Bụng (Module 1)
        for (sx = [-W_corridor/2 + 12, W_corridor/2 - 12]) {
            for (sz = [side_wall_z0 + 20, chassis_top_z - 20]) {
                translate([sx, y_rear_mount - flange_t - 1.0, sz])
                    rotate([-90, 0, 0])
                    Render_M3_Bolt(length = 16.0);
            }
        }
    }
}

// ==============================================================================
// ĐIỀU KHIỂN RENDER THEO CÁC CHẾ ĐỘ XUẤT (VIEW SELECTION)
// ==============================================================================

if (part_select == "module_1_belly") {
    // Xuất riêng Module 1 (Khoang bụng)
    Module_1_Central_Belly_Hull();

} else if (part_select == "module_2_front") {
    // Xuất riêng Module 2 (Mũi trước)
    Module_2_Front_Bay();

} else if (part_select == "module_3_rear") {
    // Xuất riêng Module 3 (Đuôi sau)
    Module_3_Rear_Bay();

} else if (part_select == "module_4_fenders") {
    // Xuất riêng 4 Vè Giáp Hông
    Module_4_All_Fenders();

} else if (part_select == "module_5_roof") {
    // Xuất riêng Nắp Nóc Xe
    Module_5_Hinged_Roof_Lid();

} else if (part_select == "module_6_suspension") {
    // Xuất riêng 1 Cụm Treo & Bánh
    Single_Suspension_Corner_Module();

} else if (part_select == "print_chassis_parts") {
    // Bố trí trải phẳng 3 module thân xe trên bàn in Z=0 (Vừa trọn bàn in 320x390)
    translate([0, 0, -side_wall_z0])
        Module_1_Central_Belly_Hull();

    translate([0, 160.0, -side_wall_z0])
        Module_2_Front_Bay();

    translate([0, -160.0, -side_wall_z0])
        Module_3_Rear_Bay();

} else if (part_select == "exploded_modules") {
    // Bóc tách trực quan thấy rõ rãnh mang cá & cơ cấu ghép
    Module_1_Central_Belly_Hull();

    translate([0, exploded_gap, 0])
        Module_2_Front_Bay();

    translate([0, -exploded_gap, 0])
        Module_3_Rear_Bay();

    translate([0, 0, exploded_gap * 0.8])
        Module_4_All_Fenders();

    translate([0, 0, exploded_gap * 1.8])
        Module_5_Hinged_Roof_Lid();

    // 4 Cụm bánh xe tách rộng ra 4 phía
    translate([-suspension_X - exploded_gap, 0, 0])
        Single_Suspension_Corner_Module();

    translate([suspension_X + exploded_gap, 0, 0])
        mirror([1, 0, 0]) Single_Suspension_Corner_Module();

    translate([-suspension_X - exploded_gap, box_y_center * 2, 0])
        mirror([0, 1, 0]) Single_Suspension_Corner_Module();

    translate([suspension_X + exploded_gap, box_y_center * 2, 0])
        mirror([1, 0, 0]) mirror([0, 1, 0]) Single_Suspension_Corner_Module();

    // Hiển thị bulông tách lớp
    translate([0, exploded_gap * 1.4, 0])
        Fastener_Hardware_Assembly();

} else { // "all_assembled" (Mặc định: Toàn bộ xe ghép mộng & bulông hoàn chỉnh)
    // 1. Khoang bụng (Xám đen nhám)
    Module_1_Central_Belly_Hull();

    // 2. Mũi trước (Cam thể thao - Ghép mộng mang cá)
    Module_2_Front_Bay();

    // 3. Đuôi sau (Cam thể thao - Ghép mộng mang cá)
    Module_3_Rear_Bay();

    // 4. 4 Vè giáp nóc hông (Gunmetal - Gài rãnh trượt)
    Module_4_All_Fenders();

    // 5. Nắp nóc xe mở bản lề (Titan + Trắng + Cam)
    Module_5_Hinged_Roof_Lid();

    // 6. Bulông thép M3 liên kết cơ khí
    Fastener_Hardware_Assembly();

    // 7. 4 Cụm bánh xe & Hệ treo 4 góc
    translate([-suspension_X, 0, 0])
        Single_Suspension_Corner_Module();

    translate([suspension_X, 0, 0])
        mirror([1, 0, 0])
        Single_Suspension_Corner_Module();

    translate([-suspension_X, box_y_center * 2, 0])
        mirror([0, 1, 0])
        Single_Suspension_Corner_Module();

    translate([suspension_X, box_y_center * 2, 0])
        mirror([1, 0, 0])
        mirror([0, 1, 0])
        Single_Suspension_Corner_Module();
}
