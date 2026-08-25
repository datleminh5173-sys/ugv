// ==============================================================================
// 01. ĐỘNG CƠ GIẢM TỐC DC MY1016Z (12V 250W - 9 RĂNG)
// MÔ HÌNH 3D CHUẨN XÁC THEO BẢN VẼ KỸ THUẬT & HÌNH ẢNH THỰC TẾ
// ==============================================================================
// Tác giả: Antigravity CAD System
// Tọa độ gốc (0,0,0): TÂM TRỤC ĐẦU RA (OUTPUT SHAFT CENTER) TẠI MẶT TRƯỚC HỘP SỐ
// Hệ trục:
//   +X: Hướng ra phía trước dọc theo trục quay (Output Shaft)
//   -X: Hướng về phía sau (thân motor)
//   +Z: Hướng lên trên
//   -Z: Hướng xuống dưới mặt sàn chân đế
//   +Y: Hướng sang bên phải (nhìn từ trước vào)
//   -Y: Hướng sang bên trái
// ==============================================================================

$fn = 60;

// ==============================================================================
// 1. THÔNG SỐ KÍCH THƯỚC CHUẨN (DIMENSIONS IN MM)
// ==============================================================================

// [1.1] TRỤC RA & NHÔNG 9 RĂNG
SHAFT_L           = 18.0;   // Chiều dài trục nhô ra (mm)
SHAFT_D           = 11.0;   // Đường kính cốt trục (mm)
SHAFT_THREAD_D    = 8.5;    // Đường kính ren M8 đầu trục (mm)
SHAFT_THREAD_L    = 5.0;    // Chiều dài đoạn ren (mm)
KEY_L             = 10.0;   // Chiều dài chốt then (mm)
KEY_W             = 3.0;    // Bề rộng chốt then (mm)

// Nhông xích 9 răng (#410 / xích xe đạp)
SPROCKET_TEETH    = 9;
SPROCKET_OD       = 42.0;   // Đường kính đỉnh răng (mm)
SPROCKET_PCD      = 36.0;   // Đường kính vòng chia (mm)
SPROCKET_RD       = 28.0;   // Đường kính chân răng (mm)
SPROCKET_THICK    = 3.8;    // Độ dày bản nhông (mm)
SPROCKET_POS_X    = 4.0;    // Vị trí đặt nhông từ mặt bích (mm)

// [1.2] HỘP SỐ GIẢM TỐC NHÔM ĐÚC (ALUMINUM GEARBOX)
GEARBOX_L         = 30.0;   // Bề dày hộp số (mm)
DRUM_MAIN_D       = 98.0;   // Đường kính trống tròn lớn phía trước (chứa trục ra)
DRUM_MAIN_DEPTH   = 16.0;   // Độ sâu trống tròn trước (mm)

// Tâm thân động cơ lệch góc chéo xuống dưới - sang phải (nhìn từ trước)
MOTOR_OFFSET_Y    = 28.0;   // Lệch sang phải 28mm
MOTOR_OFFSET_Z    = -38.0;  // Lệch xuống dưới 38mm
DRUM_SUB_D        = 86.0;   // Đường kính trống tròn phụ phía dưới

// 3 Lỗ ốc M6 mặt bích tam giác (Khoảng cách chuẩn: 84mm - 75mm - 62mm)
FLANGE_H1 = [  0.0,  45.0]; // Lỗ 1: Đỉnh trên (12h)
FLANGE_H2 = [ 33.0, -22.0]; // Lỗ 2: Gờ bên phải
FLANGE_H3 = [-28.0, -35.0]; // Lỗ 3: Gờ bên trái/dưới

// [1.3] THÂN MOTOR ĐEN & NẮP ĐUÔI
MOTOR_D           = 101.0;  // Đường kính thân motor (mm)
MOTOR_L           = 84.0;   // Chiều dài vỏ trụ đen (mm)
REAR_CAP_L        = 9.0;    // Chiều dài nắp nhôm sau (mm)

// [1.4] CHÂN ĐẾ BẮT ĐÁY (BASE MOUNT FOOT)
SHAFT_CENTER_H    = 82.0;   // Chiều cao tâm trục ra đến đáy đế (82mm)
BASE_Z            = -SHAFT_CENTER_H; // Z = -82mm
BASE_W            = 112.0;  // Chiều rộng đế (112mm)
BASE_L            = 65.0;   // Chiều dài đế (mm)
BASE_THICK        = 3.5;    // Độ dày thép đế (mm)
BASE_HOLE_DIST_Y  = 95.0;   // Khoảng cách 2 lỗ ốc M6 (95mm)
BASE_HOLE_D       = 6.5;    // Đường kính lỗ ốc M6

// ==============================================================================
// 2. CÁC MODULE CHI TIẾT
// ==============================================================================

// [2.1] HỘP GIẢM TỐC NHÔM ĐÚC MẶT TRƯỚC (ALUMINUM GEARBOX HOUSING)
module Part_Gearbox_Housing() {
    color([0.80, 0.83, 0.86]) { // Màu nhôm đúc sáng
        difference() {
            union() {
                // Khối đế lưng hộp số (Backplate Hull)
                translate([-GEARBOX_L, 0, 0]) {
                    rotate([0, 90, 0]) {
                        linear_extrude(height = GEARBOX_L - DRUM_MAIN_DEPTH) {
                            hull() {
                                circle(d = DRUM_MAIN_D + 4);
                                translate([MOTOR_OFFSET_Z, MOTOR_OFFSET_Y])
                                    circle(d = DRUM_SUB_D + 4);
                                // Các vấu gờ bắt ốc
                                translate([FLANGE_H1[1], FLANGE_H1[0]]) circle(d = 16);
                                translate([FLANGE_H2[1], FLANGE_H2[0]]) circle(d = 16);
                                translate([FLANGE_H3[1], FLANGE_H3[0]]) circle(d = 16);
                            }
                        }
                    }
                }

                // Trống tròn chính phía trước (Main Drum - chứa trục ra)
                translate([-DRUM_MAIN_DEPTH, 0, 0]) {
                    rotate([0, 90, 0]) {
                        cylinder(d1 = DRUM_MAIN_D + 2, d2 = DRUM_MAIN_D, h = DRUM_MAIN_DEPTH);
                    }
                }

                // Trống tròn phụ phía dưới (Sub Drum - liên kết thân motor)
                translate([-DRUM_MAIN_DEPTH, MOTOR_OFFSET_Y, MOTOR_OFFSET_Z]) {
                    rotate([0, 90, 0]) {
                        cylinder(d1 = DRUM_SUB_D + 2, d2 = DRUM_SUB_D, h = DRUM_MAIN_DEPTH * 0.7);
                    }
                }

                // Ụ đỡ vòng bi trục ra phía trước
                rotate([0, 90, 0])
                    cylinder(d = 30, h = 4.0);
            }

            // Khoét 3 lỗ ốc M6 mặt bích trước (Triangle 84 - 75 - 62)
            translate([-GEARBOX_L - 1, 0, 0]) {
                for (h_pt = [FLANGE_H1, FLANGE_H2, FLANGE_H3]) {
                    translate([0, h_pt[0], h_pt[1]])
                        rotate([0, 90, 0])
                        cylinder(d = 6.0, h = GEARBOX_L + 2);
                }
            }

            // Rãnh vát viền tạo gờ đúc cơ khí
            translate([0.1, 0, 0])
                rotate([0, 90, 0])
                difference() {
                    cylinder(d = DRUM_MAIN_D + 10, h = 2);
                    cylinder(d = DRUM_MAIN_D - 4, h = 3, center = true);
                }
        }

        // NAN HOA GÂN CHỊU LỰC MẶT TRƯỚC (RADIAL RIBS - NẰM TRỌN TRÊN MẶT TRỐNG)
        // [A] 12 Gân nan hoa trên trống chính quanh trục ra
        intersection() {
            // Giới hạn nằm trong mặt tròn trống chính
            rotate([0, 90, 0])
                cylinder(d = DRUM_MAIN_D - 12, h = 2.0);
            
            // Cụm 12 gân nan hoa
            union() {
                for (a = [0 : 30 : 330]) {
                    rotate([a, 0, 0])
                        translate([0.8, 26, 0])
                        rotate([0, 90, 0])
                        cube([1.6, 26, 1.8], center = true);
                }
            }
        }

        // [B] 8 Gân nan hoa trên trống phụ phía dưới
        translate([-(DRUM_MAIN_DEPTH * 0.3), MOTOR_OFFSET_Y, MOTOR_OFFSET_Z]) {
            intersection() {
                rotate([0, 90, 0])
                    cylinder(d = DRUM_SUB_D - 14, h = 2.0);
                
                union() {
                    for (a = [0 : 45 : 315]) {
                        rotate([a, 0, 0])
                            translate([0.8, 22, 0])
                            rotate([0, 90, 0])
                            cube([1.6, 22, 1.8], center = true);
                    }
                }
            }
        }

        // Ốc vít siết ghép 2 nửa vỏ hộp số (Perimeter Screws)
        color([0.90, 0.90, 0.92]) {
            screw_pts = [
                [FLANGE_H1[0] + 12, FLANGE_H1[1] - 4],
                [FLANGE_H1[0] - 12, FLANGE_H1[1] - 4],
                [FLANGE_H2[0] - 2,  FLANGE_H2[1] + 14],
                [FLANGE_H2[0] - 8,  FLANGE_H2[1] - 14],
                [FLANGE_H3[0] + 6,  FLANGE_H3[1] + 14],
                [FLANGE_H3[0] - 4,  FLANGE_H3[1] - 14]
            ];
            for (pt = screw_pts) {
                translate([0.2, pt[0], pt[1]])
                    rotate([0, 90, 0]) {
                        cylinder(d = 5.5, h = 2.0);
                        translate([0, 0, 2.0])
                            cylinder(d = 3.0, h = 0.5);
                    }
            }
        }
    }
}

// [2.2] THÂN MOTOR ĐEN & NẮP ĐUÔI (STATOR CYLINDER & REAR ENDCAP)
module Part_Motor_Stator() {
    x_start = -GEARBOX_L;
    x_end   = x_start - MOTOR_L;

    // Vỏ trụ motor bằng thép sơn đen bóng
    color([0.14, 0.14, 0.15]) {
        translate([x_end, MOTOR_OFFSET_Y, MOTOR_OFFSET_Z])
            rotate([0, 90, 0])
            cylinder(d = MOTOR_D, h = MOTOR_L);
    }

    // Nhãn thông số kỹ thuật (Sticker kim loại dán trên lưng)
    color([0.92, 0.92, 0.88]) {
        translate([x_start - MOTOR_L * 0.5, MOTOR_OFFSET_Y, MOTOR_OFFSET_Z + MOTOR_D/2 + 0.1])
            cube([MOTOR_L * 0.55, 45, 0.6], center = true);
    }

    // Nắp nhôm tản nhiệt đuôi motor (Rear Aluminum Endcap)
    color([0.76, 0.79, 0.82]) {
        translate([x_end, MOTOR_OFFSET_Y, MOTOR_OFFSET_Z]) {
            rotate([0, -90, 0]) {
                // Vỏ nắp sau
                cylinder(d1 = MOTOR_D, d2 = MOTOR_D * 0.92, h = REAR_CAP_L);
                
                // Ụ đỡ bạc đạn đuôi
                translate([0, 0, REAR_CAP_L])
                    cylinder(d = 32, h = 4.0);
                
                // 12 Nan hoa tản nhiệt hướng tâm ở nắp sau
                for (a = [0 : 30 : 330]) {
                    rotate([0, 0, a])
                        translate([MOTOR_D * 0.25, 0, REAR_CAP_L/2])
                        cube([MOTOR_D * 0.42, 2.2, REAR_CAP_L + 1], center = true);
                }
            }
        }
    }

    // Dây nguồn chịu tải cao (Đỏ: +12V, Đen: GND)
    color([0.85, 0.12, 0.12]) { // Dây Đỏ (+)
        translate([x_end - 4, MOTOR_OFFSET_Y - 22, MOTOR_OFFSET_Z - 20])
            rotate([0, -115, -15])
            cylinder(d = 4.8, h = 55);
    }
    color([0.12, 0.12, 0.12]) { // Dây Đen (-)
        translate([x_end - 4, MOTOR_OFFSET_Y - 16, MOTOR_OFFSET_Z - 22])
            rotate([0, -115, -15])
            cylinder(d = 4.8, h = 55);
    }
}

// [2.3] CỤM TRỤC RA, THEN CAVET & NHÔNG 9 RĂNG (DRIVE SHAFT & SPROCKET)
module Part_Drive_Shaft() {
    // Trục thép chính
    color([0.42, 0.44, 0.47]) {
        rotate([0, 90, 0]) {
            cylinder(d = SHAFT_D, h = SHAFT_L - SHAFT_THREAD_L);
            translate([0, 0, SHAFT_L - SHAFT_THREAD_L])
                cylinder(d = SHAFT_THREAD_D, h = SHAFT_THREAD_L);
        }
    }

    // Chốt then (Keyway)
    color([0.82, 0.68, 0.22]) {
        translate([SPROCKET_POS_X + 2, 0, SHAFT_D/2 - 0.8])
            cube([KEY_L, KEY_W, KEY_W], center = true);
    }

    // Nhông xích 9 răng chuẩn #410
    color([0.26, 0.28, 0.30]) {
        translate([SPROCKET_POS_X, 0, 0]) {
            rotate([0, 90, 0]) {
                // Moay-ơ vòng trong của nhông
                cylinder(d = 24, h = SPROCKET_THICK + 2.5);

                // Đĩa răng 9 chấu
                linear_extrude(height = SPROCKET_THICK) {
                    for (i = [0 : SPROCKET_TEETH - 1]) {
                        rotate([0, 0, i * (360 / SPROCKET_TEETH)]) {
                            polygon(points = [
                                [-4.0, SPROCKET_RD/2],
                                [-1.8, SPROCKET_OD/2],
                                [ 1.8, SPROCKET_OD/2],
                                [ 4.0, SPROCKET_RD/2]
                            ]);
                        }
                    }
                    circle(d = SPROCKET_RD);
                }
            }
        }
    }

    // Đai ốc tán lục giác có vành hãm đầu trục (Flanged Hex Nut)
    color([0.88, 0.88, 0.90]) {
        translate([SHAFT_L - SHAFT_THREAD_L, 0, 0])
            rotate([0, 90, 0]) {
                cylinder(d = 16, h = 1.2);
                translate([0, 0, 1.2])
                    cylinder(d = 14, h = 4.0, $fn = 6);
            }
    }
}

// [2.4] CHÂN ĐẾ BẮT ĐÁY (STEEL MOUNTING FOOT)
module Part_Base_Foot() {
    x_center = -GEARBOX_L - MOTOR_L * 0.5;

    color([0.12, 0.12, 0.14]) { // Thép dập sơn đen
        translate([x_center - BASE_L/2, 0, BASE_Z]) {
            difference() {
                union() {
                    // Bản đế phẳng rộng 112mm (đối xứng qua tâm Y=0)
                    translate([0, -BASE_W/2, 0])
                        cube([BASE_L, BASE_W, BASE_THICK]);

                    // Tai dập cong ôm đỡ thân motor phía trên
                    translate([0, -MOTOR_D * 0.38 + MOTOR_OFFSET_Y, 0])
                        cube([BASE_L, MOTOR_D * 0.76, abs(BASE_Z - MOTOR_OFFSET_Z) - MOTOR_D * 0.40]);
                }

                // 2 Lỗ ốc M6 chân đế (cách nhau 95mm đối xứng)
                translate([BASE_L/2, -BASE_HOLE_DIST_Y/2, -1])
                    cylinder(d = BASE_HOLE_D, h = BASE_THICK + 3);
                translate([BASE_L/2,  BASE_HOLE_DIST_Y/2, -1])
                    cylinder(d = BASE_HOLE_D, h = BASE_THICK + 3);

                // Rãnh thoát phoi giữa
                translate([BASE_L/2, MOTOR_OFFSET_Y, -1])
                    cylinder(d = 20, h = BASE_THICK + 3);
            }
        }
    }
}

// [2.5] BÁT GÁ PHỤ KIỆN BẮT MẶT BÍCH (BLACK ACCESSORY BRACKET)
module Part_Accessory_Bracket() {
    color([0.18, 0.18, 0.20]) {
        translate([-0.5, 0, 0]) {
            difference() {
                rotate([0, 90, 0]) {
                    linear_extrude(height = 3.5) {
                        polygon(points = [
                            [-45, -45],
                            [ 58, -38],
                            [ 48,  65],
                            [-35,  55]
                        ]);
                    }
                }
                // Lỗ tâm trục
                rotate([0, 90, 0])
                    cylinder(d = 36, h = 10, center = true);

                // 3 Lỗ ốc M6 bắt mặt bích
                for (h_pt = [FLANGE_H1, FLANGE_H2, FLANGE_H3]) {
                    translate([-2, h_pt[0], h_pt[1]])
                        rotate([0, 90, 0])
                        cylinder(d = 6.6, h = 8);
                }
            }
        }
    }
}

// ==============================================================================
// 3. MODULE LẮP RÁP TỔNG THỂ (MAIN ASSEMBLY)
// ==============================================================================
module MY1016Z_Assembly(show_bracket = false, show_sprocket = true, show_base = true) {
    Part_Gearbox_Housing();
    Part_Motor_Stator();
    
    if (show_sprocket) {
        Part_Drive_Shaft();
    }
    
    if (show_base) {
        Part_Base_Foot();
    }
    
    if (show_bracket) {
        Part_Accessory_Bracket();
    }
}

// ==============================================================================
// 4. CÔNG CỤ DỰNG KHUNG GẦM UGV (CAD INTEGRATION TOOLS)
// ==============================================================================

// Khối bao an toàn chiếm chỗ (Bounding Box)
module MY1016Z_Bounding_Box(clearance = 2.0) {
    x_min = -GEARBOX_L - MOTOR_L - REAR_CAP_L - clearance;
    x_max = SHAFT_L + clearance;
    y_min = -BASE_W/2 - clearance;
    y_max =  BASE_W/2 + clearance;
    z_min = BASE_Z - clearance;
    z_max = DRUM_MAIN_D/2 + 10 + clearance;

    color([1, 0, 0, 0.20]) {
        translate([x_min, y_min, z_min])
            cube([x_max - x_min, y_max - y_min, z_max - z_min]);
    }
}

// Dưỡng khoan 2 lỗ M6 chân đế sàn xe
module MY1016Z_Drill_Template_Base(hole_h = 30) {
    x_center = -GEARBOX_L - MOTOR_L * 0.5;
    color([0, 1, 0]) {
        translate([x_center, -BASE_HOLE_DIST_Y/2, BASE_Z - hole_h/2])
            cylinder(d = BASE_HOLE_D, h = hole_h, center = true);
        translate([x_center,  BASE_HOLE_DIST_Y/2, BASE_Z - hole_h/2])
            cylinder(d = BASE_HOLE_D, h = hole_h, center = true);
    }
}

// Dưỡng khoan 3 lỗ M6 mặt bích trước
module MY1016Z_Drill_Template_Face(hole_h = 30) {
    color([0, 0.6, 1]) {
        rotate([0, 90, 0])
            cylinder(d = 34, h = hole_h, center = true);

        for (h_pt = [FLANGE_H1, FLANGE_H2, FLANGE_H3]) {
            translate([0, h_pt[0], h_pt[1]])
                rotate([0, 90, 0])
                cylinder(d = 6.6, h = hole_h, center = true);
        }
    }
}

// ==============================================================================
// 5. HIỂN THỊ MẪU
// ==============================================================================
MY1016Z_Assembly(show_bracket = false, show_sprocket = true, show_base = true);

// MY1016Z_Accessory_Bracket();
// MY1016Z_Bounding_Box();
// MY1016Z_Drill_Template_Base();
// MY1016Z_Drill_Template_Face();
