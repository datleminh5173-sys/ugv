// ==============================================================================
// 01. ĐỘNG CƠ DC ATS_MOTOR 150W (ZY6812 / MY6812) & GÁ ĐỠ HEAVY-DUTY KIỂU JGA25
// FILE DUY NHẤT (ALL-IN-ONE): ĐỘNG CƠ + GÁ ĐỠ ÔM THÂN + BU-LÔNG M5 + PULY 3M
// ==============================================================================
// MÀU SẮC CHUẨN THỰC TẾ:
// - Thân động cơ: Đen bóng kim loại nguyên bản (Black Steel)
// - 2 Nắp bích trước/sau & Gờ bạc đạn: Nhôm phay sáng màu bạc (Silver Aluminum)
// - Gá đỡ động cơ: Nhựa in 3D màu đen nhám kỹ thuật (Matte Black PETG)
// - Puly đai 3M: Màu cam thể thao / Nhôm anot (Orange/Anodized)
// - 3 Bu-lông M5: Thép mạ kẽm màu vàng (Zinc-plated Gold)
// ==============================================================================

$fn = 60;

// ==============================================================================
// 1. THÔNG SỐ HÌNH HỌC ĐỘNG CƠ ATS 150W (ZY6812 / MY6812)
// ==============================================================================
MOTOR_D           = 68.0;   // Đường kính thân kim loại motor (mm)
MOTOR_L           = 89.0;   // Chiều dài thân vỏ kim loại (mm)
FRONT_CAP_L       = 6.0;    // Chiều dày nắp nhôm trước (mm)
REAR_CAP_L        = 6.0;    // Chiều dày nắp nhôm sau (mm)

FRONT_BOSS_D      = 29.5;   // Gờ định vị bạc đạn trước (mm)
FRONT_BOSS_H      = 3.5;    // Độ nhô gờ trước (mm)

REAR_BOSS_D       = 30.0;   // Gờ bạc đạn đuôi sau (mm)
REAR_BOSS_H       = 5.0;    // Độ nhô gờ sau (mm)

SHAFT_D           = 8.0;    // Đường kính cốt trục ra (mm)
SHAFT_L           = 22.0;   // Chiều dài trục nhô ra ngoài (mm)
SHAFT_FLAT_DEPTH  = 0.8;    // Độ sâu vát D (chiều dày còn lại 7.2mm)
SHAFT_FLAT_L      = 16.0;   // Chiều dài đoạn vát phẳng (mm)

// 3 Lỗ bắt ốc mặt bích tam giác đều 120°
MOUNT_PITCH       = 35.6;   // Khoảng cách giữa 2 lỗ kề nhau (mm)
MOUNT_RADIUS      = 20.55;  // Bán kính từ tâm trục ra mỗi lỗ (PCD = 41.1mm)
MOUNT_HOLE_D      = 4.2;    // Đường kính lỗ ren M5 (mm)
MOUNT_HOLE_DEPTH  = 8.0;    // Độ sâu lỗ ren (mm)

// ==============================================================================
// 2. THÔNG SỐ GÁ ĐỠ HEAVY-DUTY (BẢN GÁ Ở TRÊN - KHE HỞ IN 3D CHỐNG KẸT)
// ==============================================================================
MOTOR_BORE_D      = 70.0;   // Đường kính khoét lòng vòm (70mm so với motor 68mm -> hở 1.0mm mỗi bên, chống kẹt in 3D)
BRACKET_WALL_T    = 4.5;    // Độ dày vách vòm ôm (4.5mm)
OUTER_R           = MOTOR_BORE_D/2 + BRACKET_WALL_T; // Bán kính ngoài vòm = 39.5mm
SLEEVE_L          = 52.0;   // Chiều dài vòm ôm thân motor (mm)

BASE_PLATE_W      = 82.0;   // Bề rộng bản gá trên (mm)
BASE_PLATE_L      = 52.0;   // Chiều dài bản gá bắt sàn (bằng chiều dài vòm = 52mm phẳng phiu)
BASE_PLATE_T      = 5.0;    // Độ dày bản gá bắt sàn (5mm)

MOTOR_CENTER_H    = 42.0;   // Khoảng cách từ tâm trục motor lên mặt dưới bản gá trên (mm)
TOP_Z             = MOTOR_CENTER_H; // Cao độ mặt dưới bản gá trên (Z = +42mm)

// ==============================================================================
// 3. MODULE CHI TIẾT ĐỘNG CƠ ATS 150W (MÀU ĐEN BÓNG THÉP NGUYÊN BẢN)
// ==============================================================================
module Part_Dong_Co_150W() {
    difference() {
        union() {
            // [A] Toàn bộ thân vỏ thép đen bóng (100% Solid Black Steel)
            color([0.08, 0.08, 0.10])
            translate([-MOTOR_L + REAR_CAP_L, 0, 0])
            rotate([0, 90, 0])
            cylinder(d = MOTOR_D, h = MOTOR_L - FRONT_CAP_L - REAR_CAP_L);

            // [B] Nắp nhôm sau (Màu nhôm phay sáng)
            color([0.78, 0.80, 0.82])
            translate([-MOTOR_L, 0, 0])
            rotate([0, 90, 0])
            cylinder(d = MOTOR_D, h = REAR_CAP_L);

            // Gờ bạc đạn sau
            color([0.72, 0.74, 0.76])
            translate([-MOTOR_L - REAR_BOSS_H, 0, 0])
            rotate([0, 90, 0])
            cylinder(d = REAR_BOSS_D, h = REAR_BOSS_H);

            // [C] Nắp bích nhôm trước (Màu nhôm phay sáng)
            color([0.78, 0.80, 0.82])
            translate([-FRONT_CAP_L, 0, 0])
            rotate([0, 90, 0])
            cylinder(d = MOTOR_D, h = FRONT_CAP_L);

            // Gờ bạc đạn trước
            color([0.72, 0.74, 0.76])
            rotate([0, 90, 0])
            cylinder(d = FRONT_BOSS_D, h = FRONT_BOSS_H);

            // [D] Trục thép chữ D (Inox sáng bóng)
            color([0.88, 0.90, 0.92])
            rotate([0, 90, 0])
            difference() {
                cylinder(d = SHAFT_D, h = SHAFT_L);
                // Vát D
                translate([-SHAFT_D, SHAFT_D/2 - SHAFT_FLAT_DEPTH, SHAFT_L - SHAFT_FLAT_L])
                cube([SHAFT_D * 2, SHAFT_D, SHAFT_FLAT_L + 1]);
            }
        }

        // [E] 3 Lỗ ren M5 mặt bích tam giác đều 120° (90°, 210°, 330°)
        for (ang = [90, 210, 330]) {
            translate([-MOUNT_HOLE_DEPTH + 0.1, MOUNT_RADIUS * cos(ang), MOUNT_RADIUS * sin(ang)])
            rotate([0, 90, 0])
            cylinder(d = MOUNT_HOLE_D, h = MOUNT_HOLE_DEPTH + 1);
        }

        // [F] 2 Vít chìm giữ nắp máy (0° và 180°)
        for (ang = [0, 180]) {
            translate([-3, 24 * cos(ang), 24 * sin(ang)])
            rotate([0, 90, 0])
            cylinder(d = 3.5, h = 4);
        }
    }
}

// ==============================================================================
// 4. MODULE GÁ ĐỠ ĐỘNG CƠ HEAVY-DUTY (MÀU XANH LÁ CÂY IN 3D)
// ==============================================================================
module Part_Ga_Do_Kieu_JGA25() {
    color([0.18, 0.72, 0.28]) { // Màu xanh lá cây nổi bật (Vibrant Green)
        difference() {
            union() {

                // [A] Mặt đứng trước bắt mặt bích motor (Dày 5mm)
                translate([0, -BASE_PLATE_W/2, -OUTER_R])
                cube([5.0, BASE_PLATE_W, (TOP_Z + BASE_PLATE_T) - (-OUTER_R)]);

                // [B] Vòm ống trụ ôm thân motor (Tâm Z = 0, Dài 52mm)
                translate([-SLEEVE_L, 0, 0])
                rotate([0, 90, 0])
                cylinder(r = OUTER_R, h = SLEEVE_L);

                // [C] Bản gá bắt sàn ở TRÊN CÙNG (Dày 5mm, Z = TOP_Z đến TOP_Z + BASE_PLATE_T)
                translate([-BASE_PLATE_L, -BASE_PLATE_W/2, TOP_Z])
                cube([BASE_PLATE_L, BASE_PLATE_W, BASE_PLATE_T]);

                // [D] Khối gân liên kết đặc kết nối vòm ôm lên bản gá trên (Liền khối siêu cứng)
                translate([-BASE_PLATE_L, -BASE_PLATE_W/2, 0])
                cube([BASE_PLATE_L, BASE_PLATE_W, TOP_Z]);
            }

            // --- CÁC PHẦN KHOÉT RỖNG (DIFFERENCE) ---

            // 1. LÒNG VÒM ÔM THÂN MOTOR (D = 70.0mm -> Khe hở 1.0mm mỗi bên, KHÔNG BỊ KẸT IN 3D)
            translate([-SLEEVE_L - 1, 0, 0])
            rotate([0, 90, 0]) {
                cylinder(d = MOTOR_BORE_D, h = SLEEVE_L + 2);
                // Vát mép miệng sau (Chamfer Lead-in rộng 73mm) giúp đút motor nhẹ nhàng
                translate([0, 0, 0])
                cylinder(d1 = MOTOR_BORE_D + 3.0, d2 = MOTOR_BORE_D, h = 4.0);
            }

            // 2. Lỗ tròn thoát gờ bạc đạn tâm trước
            translate([-2, 0, 0])
            rotate([0, 90, 0])
            cylinder(d = 31.0, h = 10);

            // 3. 3 Rãnh hạt đậu tam giác đều 120° bắt bu-lông M5 (Góc 90°, 210°, 330°)
            for (ang = [90, 210, 330]) {
                hull() {
                    translate([-2, 18.5 * cos(ang), 18.5 * sin(ang)])
                    rotate([0, 90, 0])
                    cylinder(d = 5.5, h = 10);

                    translate([-2, 22.5 * cos(ang), 22.5 * sin(ang)])
                    rotate([0, 90, 0])
                    cylinder(d = 5.5, h = 10);
                }
            }

            // 4. Khoét khe hở giải nhiệt và giảm trọng lượng ở đáy vòm
            translate([-SLEEVE_L - 1, -MOTOR_BORE_D/2 + 8, -OUTER_R - 1])
            cube([SLEEVE_L + 2, MOTOR_BORE_D - 16, 5]);

            // 5. 4 Lỗ bắt bu-lông M6 trên BẢN GÁ TRÊN (Bắt treo lên khung sàn gầm xe)
            for (by = [-BASE_PLATE_W/2 + 12, BASE_PLATE_W/2 - 12]) {
                for (bx = [-12, -BASE_PLATE_L + 12]) {
                    translate([bx, by, TOP_Z - 1])
                    cylinder(d = 6.5, h = BASE_PLATE_T + 2);
                    // Vát chìm nón đầu ốc M6
                    translate([bx, by, TOP_Z + BASE_PLATE_T - 1.5])
                    cylinder(d1 = 6.5, d2 = 11.5, h = 2.0);
                }
            }

            // 6. Lỗ thoát khí giải nhiệt trên đỉnh bản gá
            translate([-SLEEVE_L/2, 0, 0])
            cylinder(d = 16.0, h = TOP_Z + BASE_PLATE_T + 5);
        }
    }
}

// ==============================================================================
// 5. CÁC PHỤ KIỆN BU-LÔNG & PULY
// ==============================================================================
module Part_Bu_Long_M5() {
    color([0.95, 0.85, 0.2]) { // Màu bu-lông mạ vàng/kẽm
        for (ang = [90, 210, 330]) {
            translate([5.0 + 3.5, MOUNT_RADIUS * cos(ang), MOUNT_RADIUS * sin(ang)])
            rotate([0, -90, 0]) {
                // Đầu ốc lục giác M5
                cylinder(d = 8.5, h = 3.5, $fn = 6);
                // Thân ren ốc M5
                translate([0, 0, 3.5])
                cylinder(d = 5.0, h = 12, $fn = 30);
            }
        }
    }
}

module Part_Puly_Dai_3M() {
    color([0.85, 0.35, 0.15]) { // Màu cam puly anodized
        translate([5.0 + 4.0, 0, 0])
        rotate([0, 90, 0]) {
            // Vành chặn đai 1
            cylinder(d = 26, h = 1.5);
            // Thân răng puly 16T
            translate([0, 0, 1.5])
            cylinder(d = 20, h = 10);
            // Vành chặn đai 2
            translate([0, 0, 11.5])
            cylinder(d = 26, h = 1.5);
            // Cổ kẹp ốc chí puly
            translate([0, 0, 13])
            difference() {
                cylinder(d = 16, h = 6);
                cylinder(d = 8.1, h = 7);
            }
        }
    }
}

// ==============================================================================
// 6. MODULE LẮP RÁP TỔNG THỂ (MAIN ASSEMBLY)
// ==============================================================================
module ATS_150W_Assembly(
    show_motor    = true,  // Hiển thị thân động cơ ATS 150W (màu đen)
    show_bracket  = true,  // Hiển thị gá đỡ ôm thân (màu đen nhám)
    show_bolts    = true,  // Hiển thị 3 bu-lông lục giác M5
    show_pulley   = true   // Hiển thị puly truyền động đai 3M
) {
    if (show_motor) {
        Part_Dong_Co_150W();
    }

    if (show_bracket) {
        Part_Ga_Do_Kieu_JGA25();
    }

    if (show_bolts && show_bracket) {
        Part_Bu_Long_M5();
    }

    if (show_pulley) {
        Part_Puly_Dai_3M();
    }
}

// ==============================================================================
// 7. HIỂN THỊ MẶC ĐỊNH KHI MỞ FILE
// ==============================================================================
ATS_150W_Assembly(
    show_motor    = true,
    show_bracket  = true,
    show_bolts    = true,
    show_pulley   = true
);
