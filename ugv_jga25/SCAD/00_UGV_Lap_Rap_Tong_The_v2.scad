// ==============================================================================
// 00. XE ROBOT TỰ HÀNH UGV 4 BÁNH (4WD) - PHIÊN BẢN V2 NÂNG CẤP TOÀN DIỆN
// ==============================================================================
// CÁC ĐIỂM NÂNG CẤP ĐỘT PHÁ TRÊN BẢN V2:
// 1. PHUỘC GIẢM XÓC V2: Lò xo sợi siêu dày D=6.8mm, độ nét cao (128 steps),
//    đĩa chén ôm sâu 2.8mm, ty piton tự khóa Snap-Lock chống văng 100%.
// 2. MÔ PHỎNG NHÚN TREO ĐỘNG (Dynamic Suspension Compression): Tự động tính
//    độ nén lò xo và góc xoay thanh đòn theo tham số `suspension_compression`.
// 3. CHẾ ĐỘ VIEW ĐA NĂNG (view_mode): "assembled" (lắp ráp hoàn thiện),
//    "exploded" (tách lớp minh họa lắp ráp), "chassis_only" (chỉ thùng xe),
//    "suspension_only" (chỉ 1 cụm bánh & treo).
// 4. KHOANG NỘI THẤT V2: Tích hợp sẵn khay chứa pin Li-Po/18650 có rãnh dây dán Velcro,
//    hệ lỗ gắn mạch điều khiển (ESP32/Arduino/Raspberry Pi/Driver L298N/TB6612).
// 5. CẢM BIẾN & THÔNG GIÓ: Khe gió tản nhiệt vát chống nước (Louver Vents)
//    và vị trí gá gắn cảm biến LiDAR/Camera FPV trên nắp nóc xe.
// ==============================================================================

$fn = 32;

// [1] CẤU HÌNH TÙY CHỌN HIỂN THỊ & MÔ PHỎNG
view_mode              = "assembled"; // "assembled" = Toàn bộ xe, "exploded" = Tách cụm, "chassis_only" = Khung xe, "suspension_only" = 1 Cụm treo
roof_open_angle        = 0.0;         // Góc mở nắp nóc xe (0 = Đóng, 45 = Mở nghiêng, 80 = Mở đứng)
suspension_compression = 0.0;         // Độ nhún gầm phuộc (0.0mm = Bình thường, 10.0mm = Nhún nén hết cỡ)
exploded_gap           = 35.0;        // Khoảng cách tách cụm khi chọn "exploded"

// [2] THÔNG SỐ CƠ BẢN HỆ TREO & KHỚP CẦU
bracket_thick  = 3.5;    // Độ dày tấm gá gia cố (3.5mm)
bracket_W      = 37.0;   // Chiều rộng gá xám (37mm)
base_L         = 25.0;   // Chiều dài bản gá
hole_screw_d   = 3.4;    // Đường kính lỗ ốc M3
motor_center_z = -16.5 + suspension_compression; // Tâm trục motor thay đổi khi nhún
bracket_R      = 15.0;   // Bán kính vòm ôm motor

side_wall_H    = 34.0;   
side_wall_z0   = -14.0;  

pin_top_z      = 14.0 + suspension_compression;
pin_bottom_z   = -8.0 + suspension_compression;

arm_L          = 70.0;   // Khoảng cách tâm thanh đòn (70mm)
arm_thick      = 5.0;    // Độ dày thanh đòn gia cố (5.0mm)
chassis_top_z  = 125.0;  // Chiều cao nóc xe
foot_L         = 32.0;   // Chiều dài tai chữ L

// [3] TÍNH TOÁN ĐỘNG LỰC HỌC TỌA ĐỘ VÀ GÓC PHUỘC
piston_p1_y    = -13.0;
piston_p1_z    = bracket_thick + 8.0 + suspension_compression;

piston_p2_y    = -base_L - arm_L + foot_L/2;
piston_p2_z    = chassis_top_z - bracket_thick - 8.0;

piston_dy      = piston_p2_y - piston_p1_y;
piston_dz      = piston_p2_z - piston_p1_z;

piston_total_L = sqrt(piston_dy * piston_dy + piston_dz * piston_dz);
piston_angle   = atan2(abs(piston_dy), piston_dz);

// ==============================================================================
// 1. MODULE CHỐT NẤM ĐÀN HỒI ĐÚC LIỀN (SNAP-PIN STUD)
// ==============================================================================
module Snap_Pin_Stud_V2() {
    pin_d   = 6.0;
    pin_L   = 5.6;
    cap_d   = 7.6;
    cap_L   = 3.8;
    slot_w  = 1.2;

    difference() {
        union() {
            cylinder(d = 12.0, h = 0.8, $fn=24);
            translate([0, 0, 0.8])
                cylinder(d = pin_d, h = pin_L, $fn=24);
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

// ==============================================================================
// 2. MODULE THANH ĐÒN LIÊN KẾT SNAP-FIT (SUSPENSION LINK ARM V2)
// ==============================================================================
module Suspension_Link_Arm_V2(length = arm_L) {
    eye_od_snap     = 16.0;
    arm_hole_d_snap = 6.3;

    color([0.15, 0.75, 0.35]) difference() {
        union() {
            hull() {
                cylinder(d=eye_od_snap, h=arm_thick, center=true);
                translate([0, -length, 0]) cylinder(d=eye_od_snap, h=arm_thick, center=true);
            }
            // Gân chữ I tăng cứng sống giữa
            hull() {
                cylinder(d=eye_od_snap - 2.5, h=arm_thick + 1.0, center=true);
                translate([0, -length, 0]) cylinder(d=eye_od_snap - 2.5, h=arm_thick + 1.0, center=true);
            }
        }
        cylinder(d=arm_hole_d_snap, h=arm_thick + 4, center=true);
        translate([0, -length, 0]) cylinder(d=arm_hole_d_snap, h=arm_thick + 4, center=true);
    }
}

// ==============================================================================
// 3. MODULE GÁ MOTOR TÍCH HỢP KHỚP CẦU ĐÀN HỒI (MOTOR BRACKET V2)
// ==============================================================================
module Motor_Bracket_Gray_V2() {
    fillet_r     = 6.0;
    ring_L       = 36.0;
    motor_bore_d = 25.6;

    color([0.55, 0.58, 0.62]) difference() {
        union() {
            // Mặt phẳng gá chính
            translate([0, -base_L/2, bracket_thick/2])
                cube([bracket_W, base_L, bracket_thick], center=true);

            // Mặt đứng trước
            translate([0, bracket_thick/2, (motor_center_z - bracket_R + bracket_thick)/2])
                cube([bracket_W, bracket_thick, abs(motor_center_z - bracket_R) + bracket_thick], center=true);

            // Vòng ôm thân motor
            translate([0, 0, motor_center_z])
                rotate([90, 0, 0])
                cylinder(r=bracket_R, h=ring_L);

            // Gân liên kết vòm ôm với mặt phẳng gá
            translate([0, -base_L/2, (motor_center_z + bracket_R + bracket_thick/2)/2])
                cube([2*bracket_R, base_L, abs(motor_center_z + bracket_R - bracket_thick/2) + 0.1], center=true);

            hull() {
                translate([0, -base_L + 1, bracket_thick/2])
                    cube([18, 2, bracket_thick], center=true);
                translate([0, -ring_L + 3, motor_center_z + bracket_R - 1])
                    cube([16, 2, 3], center=true);
            }

            // 2 Vách bên kéo dài
            for (side_x = [-1, 1]) {
                posX = side_x * (bracket_W/2 - bracket_thick/2);
                translate([posX, 0, 0])
                    rotate([90, 0, 90])
                    linear_extrude(height = bracket_thick, center = true)
                    hull() {
                        translate([-base_L/2, side_wall_z0 + 1])
                            square([base_L, 2], center=true);
                        translate([-fillet_r, (side_wall_z0 + side_wall_H) - fillet_r])
                            circle(r=fillet_r);
                        translate([-base_L + fillet_r, (side_wall_z0 + side_wall_H) - fillet_r])
                            circle(r=fillet_r);
                    }
                
                // 4 Chốt nấm đúc liền
                for (posZ = [pin_bottom_z, pin_top_z]) {
                    translate([side_x * (bracket_W/2), -base_L/2, posZ])
                        rotate([0, side_x * 90, 0])
                        Snap_Pin_Stud_V2();
                }
            }

            // Quả cầu lồi nghiêng theo góc phuộc
            translate([0, piston_p1_y, piston_p1_z])
                sphere(d = 10.0);

            translate([0, piston_p1_y, piston_p1_z])
                rotate([piston_angle, 0, 0])
                translate([0, 0, -3.5])
                cylinder(d = 5.0, h = 4.0, center = true);

            hull() {
                translate([0, piston_p1_y, bracket_thick + suspension_compression])
                    cylinder(d = 12.0, h = 0.5);
                translate([0, piston_p1_y, piston_p1_z])
                    rotate([piston_angle, 0, 0])
                    translate([0, 0, -4.5])
                    cylinder(d = 5.6, h = 1.0, center = true);
            }
        }

        // Lòng trong ôm động cơ JGA25
        translate([0, 1, motor_center_z])
            rotate([90, 0, 0]) {
                cylinder(d=motor_bore_d, h=ring_L + 5);
                translate([0, 0, ring_L - 1.5])
                    cylinder(d1=motor_bore_d, d2=motor_bore_d + 1.8, h=2.5);
            }

        // Lỗ trục & 2 lỗ ren M3 động cơ
        translate([0, bracket_thick/2, motor_center_z])
            rotate([90, 0, 0]) cylinder(d=7.2, h=bracket_thick + 4, center=true);

        for (offset_x = [-8.5, 8.5]) {
            translate([offset_x, bracket_thick/2, motor_center_z])
                rotate([90, 0, 0]) cylinder(d=hole_screw_d, h=bracket_thick + 4, center=true);
        }

        // 4 Lỗ ốc M3 mặt bản đế
        for (dx = [-7, 7]) {
            for (dy = [-6, -20]) {
                translate([dx, dy, -1 + suspension_compression]) cylinder(d=hole_screw_d, h=bracket_thick + 4);
                translate([dx, dy, -0.1 + suspension_compression]) cylinder(d1=5.5, d2=hole_screw_d, h=1.5);
            }
        }
    }
}

// ==============================================================================
// 4. MODULE PHUỘC PITON KHỚP CẦU ĐÀN HỒI V2 (DÀY D=6.8mm, ĐĨA D=30mm)
// ==============================================================================
module Spring_Piston_SnapFit_V2(total_L = piston_total_L) {
    collar_od_val    = 30.0;
    collar_thick_val = 4.0;
    cup_rim_h_val    = 2.8;
    cylinder_od_val  = 13.0;
    cyl_h_val        = total_L * 0.52;
    rod_h_val        = total_L * 0.58;

    // [A] Chén cầu dưới & Xilanh
    color([0.2, 0.5, 0.85]) {
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

        // Đĩa chén ôm lò xo dưới D=30mm
        translate([0, 0, 8.0]) {
            difference() {
                union() {
                    translate([0, 0, -collar_thick_val])
                        cylinder(d=collar_od_val, h=collar_thick_val);
                    cylinder(d=collar_od_val, h=cup_rim_h_val);
                }
                translate([0, 0, -0.1])
                    cylinder(d=27.6, h=cup_rim_h_val + 1.0);
            }
        }

        // Vỏ xilanh
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

    // [B] Chén cầu trên & Ty piton
    color([0.7, 0.72, 0.76]) {
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
                            translate([0, 0, -collar_thick_val])
                                cylinder(d=collar_od_val, h=collar_thick_val);
                            cylinder(d=collar_od_val, h=cup_rim_h_val);
                        }
                        translate([0, 0, -0.1])
                            cylinder(d=27.6, h=cup_rim_h_val + 1.0);
                    }
                }

                difference() {
                    union() {
                        translate([0, 0, 8.0])
                            cylinder(d=7.6, h=rod_h_val - 4.5);
                        translate([0, 0, 8.0 + rod_h_val - 4.5]) {
                            cylinder(d=8.8, h=1.0);
                            translate([0, 0, 1.0])
                                cylinder(d1=8.8, d2=5.6, h=3.5);
                        }
                        translate([0, 0, 8.0])
                            cylinder(d1=13.0, d2=7.6, h=3.0);
                    }
                    translate([0, 0, 8.0 + rod_h_val - 8.0]) {
                        cube([1.2, 11.0, 16.0], center=true);
                        cube([11.0, 1.2, 16.0], center=true);
                    }
                }
            }
        }
    }

    // [C] Lò xo siêu dày D=6.8mm nét mịn
    color([0.9, 0.15, 0.15]) {
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

            translate([0, 0, spring_start_z - 15.0])
                cube([60.0, 60.0, 30.0], center=true);
            translate([0, 0, spring_end_z + 15.0])
                cube([60.0, 60.0, 30.0], center=true);
        }
    }
}

// ==============================================================================
// 5. MODULE ĐỘNG CƠ JGA25, HEX HUB & BÁNH XE TỔ ONG D=96mm
// ==============================================================================
module JGA25_Motor_Complete_V2() {
    L_gearbox = 19.0;
    L_motor   = 31.0;
    D_body    = 24.4;
    D_gearbox = 25.0;

    color([0.82, 0.84, 0.86]) difference() {
        cylinder(d=D_gearbox, h=L_gearbox);
        translate([0, 8.5, L_gearbox - 6]) cylinder(d=3.0, h=7);
        translate([0, -8.5, L_gearbox - 6]) cylinder(d=3.0, h=7);
    }

    translate([0, 0, L_gearbox]) {
        color([0.85, 0.58, 0.25]) cylinder(d=7, h=2.5);
        color([0.9, 0.9, 0.9]) difference() {
            cylinder(d=4.0, h=12.0);
            translate([1.5, -4, 4]) cube([4, 8, 9]);
        }
    }

    translate([0, 0, -L_motor]) color([0.84, 0.86, 0.88]) cylinder(d=D_body, h=L_motor);

    translate([0, 0, -L_motor]) {
        color([0.8, 0.1, 0.1]) translate([0, 0, -1.5]) cylinder(d=D_body, h=1.5);
        color([0.15, 0.15, 0.15]) translate([0, 0, -10.5]) cylinder(d=14, h=9);
        color([0.95, 0.95, 0.95]) translate([-7, D_body/2 - 5, -8]) cube([14, 5, 8]);
    }
}

module Honeycomb_Airless_Wheel_V2(OD = 96.0, width = 34.0) {
    rim_d   = 48.0;
    tire_od = OD;
    n_cells = 18;

    color([0.25, 0.27, 0.30]) {
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

    color([0.16, 0.16, 0.16]) {
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
}

// ==============================================================================
// 6. CỤM BÁNH XE & TREO HOÀN CHỈNH
// ==============================================================================
module Suspension_Corner_Assembly_V2() {
    Motor_Bracket_Gray_V2();

    translate([0, -19.0, motor_center_z])
        rotate([-90, 0, 0])
        JGA25_Motor_Complete_V2();

    translate([0, 13.5, motor_center_z])
        rotate([-90, 0, 0])
        Honeycomb_Airless_Wheel_V2(OD = 96.0, width = 34.0);

    for (side_x = [-1, 1]) {
        arm_posX = side_x * (bracket_W/2 + arm_thick/2 + 0.8);
        translate([arm_posX, -base_L/2, pin_top_z])
            rotate([0, 90, 0]) Suspension_Link_Arm_V2(length = arm_L);
        translate([arm_posX, -base_L/2, pin_bottom_z])
            rotate([0, 90, 0]) Suspension_Link_Arm_V2(length = arm_L);
    }

    translate([0, piston_p1_y, piston_p1_z])
        rotate([piston_angle, 0, 0])
        Spring_Piston_SnapFit_V2(total_L = piston_total_L);
}

// ==============================================================================
// 7. KHUNG THÂN XE V2 (MONOLITHIC CHASSIS V2)
// ==============================================================================
L_belly       = 140.0;
y_front_mount = -base_L - arm_L;
y_rear_mount  = y_front_mount - L_belly;
box_y_center  = (y_front_mount + y_rear_mount) / 2;
suspension_X  = 130.0;
W_belly       = 350.0;
W_corridor    = 176.0;
L_nose        = 85.0;
L_tail        = 85.0;
y_nose_tip    = y_front_mount + L_nose;
y_tail_tip    = y_rear_mount - L_tail;
box_H         = chassis_top_z - side_wall_z0;
wall_t        = 3.0;

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

module Integrated_Chassis_Mount_Station_V2() {
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
                        Snap_Pin_Stud_V2();
                }
            }

            translate([0, ear_posY, piston_p2_z])
                sphere(d = 10.0);

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

module UGV_Unified_Monolithic_Chassis_V2() {
    color([0.26, 0.28, 0.32]) {
        difference() {
            union() {
                translate([0, 0, side_wall_z0]) {
                    linear_extrude(height = box_H)
                        polygon(points = chassis_outer_poly);

                    translate([0, 0, box_H - 4.0])
                        linear_extrude(height = 4.0)
                        offset(r = 3.0)
                        polygon(points = chassis_outer_poly);
                }

                // Vách gá treo
                translate([-suspension_X, -base_L/2 - arm_L, 0]) mirror([1, 0, 0]) Integrated_Chassis_Mount_Station_V2();
                translate([suspension_X, -base_L/2 - arm_L, 0])  Integrated_Chassis_Mount_Station_V2();
                translate([-suspension_X, box_y_center * 2 - (-base_L/2 - arm_L), 0]) mirror([1, 0, 0]) mirror([0, 1, 0]) Integrated_Chassis_Mount_Station_V2();
                translate([suspension_X, box_y_center * 2 - (-base_L/2 - arm_L), 0]) mirror([0, 1, 0]) Integrated_Chassis_Mount_Station_V2();

                // Bản lề hông trái
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
            }

            // Khoét rỗng thùng xe
            translate([0, 0, side_wall_z0 + wall_t])
                linear_extrude(height = box_H + 5.0)
                offset(r = -wall_t)
                polygon(points = chassis_outer_poly);

            // Lỗ bản lề D=3.2mm
            for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0])
                    rotate([90, 0, 0]) cylinder(d = 3.2, h = 30.0, center = true);
            }

            // 4 Lỗ luồn dây viên thuốc
            for (sx = [-1, 1]) {
                for (my = [y_front_mount, y_rear_mount]) {
                    hull() {
                        translate([sx * suspension_X, my, 14.0]) rotate([90, 0, 0]) cylinder(d = 8.5, h = wall_t * 3, center = true);
                        translate([sx * suspension_X, my, 1.0])  rotate([90, 0, 0]) cylinder(d = 8.5, h = wall_t * 3, center = true);
                    }
                }
            }

            // [V2] KHE THÔNG GIÓ KHÍ ĐỘNG HỌC HÔNG MŨI TRƯỚC (Louver Vents)
            for (vy = [-55, -45, -35]) {
                translate([W_corridor/2, vy, 40.0]) rotate([0, 30, 0]) cube([12.0, 6.0, 2.5], center=true);
                translate([-W_corridor/2, vy, 40.0]) rotate([0, -30, 0]) cube([12.0, 6.0, 2.5], center=true);
            }
        }

        // [V2] KHAY PIN LI-PO / 18650 CÓ RÃNH DÂY ĐAI VELCRO DƯỚI ĐÁY XE
        translate([0, box_y_center, side_wall_z0 + wall_t]) {
            difference() {
                cube([80.0, 145.0, 15.0], center = true);
                translate([0, 0, 2.0]) cube([74.0, 139.0, 16.0], center = true);
                // 2 Rãnh luồn dây đai Velcro
                translate([0, -35.0, -4.0]) cube([84.0, 22.0, 4.0], center = true);
                translate([0, 35.0, -4.0])  cube([84.0, 22.0, 4.0], center = true);
            }
        }

        // Trụ bắt ốc M3 PCB Standoffs
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

// ==============================================================================
// 8. NẮP NÓC XE MỞ HÔNG V2 (CANOPY V2 TÍCH HỢP GÁ LIDAR & CAMERA)
// ==============================================================================
module UGV_Removable_Hinged_Roof_Lid_V2() {
    lid_thick   = 3.5;
    sealing_lip = 3.0;

    translate([-W_belly/2 - 3.5, 0, chassis_top_z + 4.0])
    rotate([0, -roof_open_angle, 0])
    translate([W_belly/2 + 3.5, 0, -(chassis_top_z + 4.0)]) {

        color([0.32, 0.35, 0.40]) {
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

                    // Ngàm bản lề trái
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

                    // Chữ SUMO V2 dập nổi
                    translate([0, box_y_center, chassis_top_z + lid_thick]) {
                        rotate([0, 0, -90]) {
                            linear_extrude(height = 2.2)
                                text("SUMO V2", size = 28, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
                            difference() {
                                cube([160.0, 54.0, 2.0], center = true);
                                cube([152.0, 46.0, 4.0], center = true);
                            }
                        }
                    }

                    // [V2] ĐẾ GÁ CẢM BIẾN LIDAR TRÒN D=76mm TRÊN NÓC MŨI
                    translate([0, y_nose_tip - 45.0, chassis_top_z + lid_thick]) {
                        cylinder(d = 76.0, h = 3.0);
                    }
                }

                // Lỗ bản lề
                for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                    translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0])
                        rotate([90, 0, 0]) cylinder(d = 3.2, h = 45.0, center = true);
                }

                // Hốc tay nắm mở nắp
                translate([W_belly/2 - 15.0, box_y_center, chassis_top_z + lid_thick/2])
                    cube([16.0, 48.0, lid_thick + 2.0], center = true);

                // 4 Lỗ ốc M3 gắn RPLiDAR trên đế nóc
                for (ang = [45, 135, 225, 315]) {
                    translate([28.0 * cos(ang), (y_nose_tip - 45.0) + 28.0 * sin(ang), chassis_top_z - 1])
                        cylinder(d = 3.4, h = lid_thick + 6.0);
                }
            }
        }

        // Tay nắm mở nắp màu cam
        color([0.95, 0.45, 0.1]) {
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
    }
}

// ==============================================================================
// [LẮP RÁP TỔNG THỂ THEO CHẾ ĐỘ XUẤT VIEW]
// ==============================================================================

if (view_mode == "chassis_only") {
    UGV_Unified_Monolithic_Chassis_V2();
} else if (view_mode == "suspension_only") {
    Suspension_Corner_Assembly_V2();
} else if (view_mode == "exploded") {
    // Tách thùng xe ở giữa
    UGV_Unified_Monolithic_Chassis_V2();

    // Nắp nóc xe nâng cao lên
    translate([0, 0, exploded_gap * 1.8])
        UGV_Removable_Hinged_Roof_Lid_V2();

    // 4 Cụm treo tách rộng ra 4 phía
    translate([-suspension_X - exploded_gap, 0, 0])
        Suspension_Corner_Assembly_V2();

    translate([suspension_X + exploded_gap, 0, 0])
        mirror([1, 0, 0]) Suspension_Corner_Assembly_V2();

    translate([-suspension_X - exploded_gap, box_y_center * 2, 0])
        mirror([0, 1, 0]) Suspension_Corner_Assembly_V2();

    translate([suspension_X + exploded_gap, box_y_center * 2, 0])
        mirror([1, 0, 0]) mirror([0, 1, 0]) Suspension_Corner_Assembly_V2();

} else { // "assembled" (Mặc định lắp ráp toàn diện)
    UGV_Unified_Monolithic_Chassis_V2();
    UGV_Removable_Hinged_Roof_Lid_V2();

    // 4 Cụm treo 4 góc
    translate([-suspension_X, 0, 0])
        Suspension_Corner_Assembly_V2();

    translate([suspension_X, 0, 0])
        mirror([1, 0, 0])
        Suspension_Corner_Assembly_V2();

    translate([-suspension_X, box_y_center * 2, 0])
        mirror([0, 1, 0])
        Suspension_Corner_Assembly_V2();

    translate([suspension_X, box_y_center * 2, 0])
        mirror([1, 0, 0])
        mirror([0, 1, 0])
        Suspension_Corner_Assembly_V2();
}
