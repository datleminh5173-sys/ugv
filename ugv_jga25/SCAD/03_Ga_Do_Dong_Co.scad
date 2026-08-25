// ==============================================================================
// 03. GÁ ĐỠ ĐỘNG CƠ BÁNH XE TÍCH HỢP CHỐT NẤM & QUẢ CẦU LỒI
// (SNAP-PIN & BALL-STUD MOTOR BRACKET)
// BỘ PHẬN IN 3D SỐ 3 - SỐ LƯỢNG CẦN IN: 4 CÁI
// ĐẶC ĐIỂM NÂNG CẤP HOÀN TOÀN:
// 1. TÍCH HỢP QUẢ CẦU LỒI D=10mm ĐỂ GẮN KHỚP CẦU ĐÀN HỒI VỚI PHUỘC PITON
// 2. 4 CHỐT NẤM ĐÀN HỒI XẺ RÃNH CHỮ THẬP (+) ĐÚC LIỀN 2 BÊN VÁCH GÁ
// 3. LẮP RÁP BẰNG TAY TRONG 1 GIÂY (ZERO BOLTS / ZERO SCREWS)
// ĐÃ ĐƯỢC ĐẶT NẰM PHẲNG TRÊN MẶT BÀN IN (Z = 0)
// VẬT LIỆU KHUYÊN DÙNG: PETG / ABS / NYLON (INFILL 60-100%)
// ==============================================================================
$fn = 48;

bracket_thick  = 3.5;    // Độ dày vách 3.5mm
bracket_W      = 37.0;   // Chiều rộng gá (37mm)
base_L         = 25.0;   // Chiều dài bản gá (25mm)
hole_screw_d   = 3.4;    // Đường kính lỗ ốc M3
motor_center_z = -16.5;  // Tâm trục động cơ JGA25 chuẩn
bracket_R      = 15.0;   // Bán kính ngoài vòm đỡ (R=15mm)
side_wall_H    = 34.0;   // Chiều cao vách bên
side_wall_z0   = -14.0;  // Đáy vách bên
arm_L          = 70.0;
foot_L         = 32.0;
chassis_top_z  = 125.0;

piston_p1_y    = -13.0;
piston_p1_z    = bracket_thick + 8.0;
piston_p2_y    = -base_L - arm_L + foot_L/2;
piston_p2_z    = chassis_top_z - bracket_thick - 8.0;
piston_dy      = piston_p2_y - piston_p1_y;
piston_dz      = piston_p2_z - piston_p1_z;
piston_angle   = atan2(abs(piston_dy), piston_dz); // Góc nghiêng của phuộc
pin_top_z      = 14.0;   // Vị trí tâm chốt M3 trên
pin_bottom_z   = -8.0;   // Vị trí tâm chốt M3 dưới

module Snap_Pin_Stud() {
    pin_d   = 6.0;   // Thân trụ xoay D=6mm
    pin_L   = 5.6;   // Dài 5.6mm (cho thanh đòn dày 5mm + 0.6mm xoay trơn)
    cap_d   = 7.6;   // Mũ nấm phình to 7.6mm
    cap_L   = 3.8;   // Mũ nấm cao 3.8mm
    slot_w  = 1.2;   // Rãnh xẻ chữ thập (+)

    difference() {
        union() {
            cylinder(d = 12.0, h = 0.8);
            translate([0, 0, 0.8])
                cylinder(d = pin_d, h = pin_L);
            translate([0, 0, 0.8 + pin_L]) {
                cylinder(d = cap_d, h = 0.8);
                translate([0, 0, 0.8])
                    cylinder(d1 = cap_d, d2 = pin_d - 1.8, h = cap_L - 0.8);
            }
        }

        translate([0, 0, 0.8 + pin_L * 0.35 + (pin_L * 0.65 + cap_L)/2]) {
            cube([slot_w, cap_d + 4.0, pin_L * 0.65 + cap_L + 1.0], center = true);
            cube([cap_d + 4.0, slot_w, pin_L * 0.65 + cap_L + 1.0], center = true);
        }
        translate([0, 0, 0.8 + pin_L * 0.35])
            sphere(d = slot_w * 1.5);
    }
}

module Motor_Bracket_Printable() {
    fillet_r     = 6.0;
    ring_L       = 36.0; // Kéo dài ra 36mm ôm trọn motor
    motor_bore_d = 25.6; // Bù trừ co ngót in 3D cho JGA25

    difference() {
        union() {
            // [A] Mặt phẳng gá chính (dày 3.5mm)
            translate([0, -base_L/2, bracket_thick/2])
                cube([bracket_W, base_L, bracket_thick], center=true);

            // [B] Mặt đứng trước bắt mặt bích motor (dày 3.5mm)
            translate([0, bracket_thick/2, (motor_center_z - bracket_R + bracket_thick)/2])
                cube([bracket_W, bracket_thick, abs(motor_center_z - bracket_R) + bracket_thick], center=true);

            // [C] Vòng đỡ động cơ ôm thân motor
            translate([0, 0, motor_center_z])
                rotate([90, 0, 0])
                cylinder(r=bracket_R, h=ring_L);

            // Khối thịt liền khối nối vòm đỡ lên bản gá
            translate([0, -base_L/2, (motor_center_z + bracket_R + bracket_thick/2)/2])
                cube([2*bracket_R, base_L, abs(motor_center_z + bracket_R - bracket_thick/2) + 0.1], center=true);

            // Gân vát vuốt nối mép bản gá xuống đuôi vòm đỡ
            hull() {
                translate([0, -base_L + 1, bracket_thick/2])
                    cube([18, 2, bracket_thick], center=true);
                translate([0, -ring_L + 3, motor_center_z + bracket_R - 1])
                    cube([16, 2, 3], center=true);
            }

            // [D] 2 Vách bên kéo dài (dày 3.5mm)
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
                
                // 4 CHỐT NẤM ĐÀN HỒI ĐÚC LIỀN NHÔ RA 2 BÊN
                for (posZ = [pin_bottom_z, pin_top_z]) {
                    translate([side_x * (bracket_W/2), -base_L/2, posZ])
                        rotate([0, side_x * 90, 0])
                        Snap_Pin_Stud();
                }
            }

            // [E] QUẢ CẦU LỒI NGHIÊNG ĐỒNG TRỤC THEO HƯỚNG PHUỘC (ANGLED BALL STUD)
            // Quả cầu tròn láng D=10.0mm
            translate([0, piston_p1_y, piston_p1_z])
                sphere(d = 10.0);

            // Cổ trụ thon D=5.0mm nghiêng theo hướng phuộc
            translate([0, piston_p1_y, piston_p1_z])
                rotate([piston_angle, 0, 0])
                translate([0, 0, -3.5])
                cylinder(d = 5.0, h = 4.0, center = true);

            // Chân đế vuốt côn liền khối từ mặt phẳng gá lên cổ cầu (KHÔNG LƠ LỬNG)
            hull() {
                translate([0, piston_p1_y, bracket_thick])
                    cylinder(d = 12.0, h = 0.5);
                translate([0, piston_p1_y, piston_p1_z])
                    rotate([piston_angle, 0, 0])
                    translate([0, 0, -4.5])
                    cylinder(d = 5.6, h = 1.0, center = true);
            }
        }

        // Lòng trong vòng đỡ ôm động cơ JGA25
        translate([0, 1, motor_center_z])
            rotate([90, 0, 0]) {
                cylinder(d=motor_bore_d, h=ring_L + 5);
                translate([0, 0, ring_L - 1.5])
                    cylinder(d1=motor_bore_d, d2=motor_bore_d + 1.8, h=2.5);
            }

        // Lỗ tâm trục & 2 lỗ ren M3 động cơ JGA25
        translate([0, bracket_thick/2, motor_center_z])
            rotate([90, 0, 0]) cylinder(d=7.2, h=bracket_thick + 4, center=true);

        for (offset_x = [-8.5, 8.5]) {
            translate([offset_x, bracket_thick/2, motor_center_z])
                rotate([90, 0, 0]) cylinder(d=hole_screw_d, h=bracket_thick + 4, center=true);
        }

        // 4 Lỗ ốc M3 mặt bản đế
        for (dx = [-7, 7]) {
            for (dy = [-6, -20]) {
                translate([dx, dy, -1]) cylinder(d=hole_screw_d, h=bracket_thick + 4);
                translate([dx, dy, -0.1]) cylinder(d1=5.5, d2=hole_screw_d, h=1.5);
            }
        }
    }
}

// ĐẶT NẰM PHẲNG BÀN IN Z = 0
translate([0, 0, -(motor_center_z - bracket_R)])
    Motor_Bracket_Printable();
