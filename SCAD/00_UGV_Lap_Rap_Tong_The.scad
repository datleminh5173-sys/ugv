// ==============================================================================
// XE ROBOT TỰ HÀNH UGV 4 BÁNH (4WD): 4 CỤM TREO ĐỘC LẬP + LỐP TỔ ONG
// BẢN NÂNG CẤP: LỖ LUỒN DÂY HÌNH VIÊN THUỐC (PILL-SHAPED SLOT) KÉO DÀI XUỐNG DƯỚI
// THA HỒ LUỒN CẢ ĐẦU JACK CẮM JST-XH / DUPONT MÀ KHÔNG CẦN CẮT THÁO DÂY
// ==============================================================================
$fn = 36;

// [THÔNG SỐ ĐÓNG/MỞ NẮP NÓC XE THEO TRỤC X]
roof_open_angle = 0.0;   // Góc mở nắp nóc lật sang bên (0 = Đóng kín, 45 = Mở nghiêng, 80 = Mở đứng)

bracket_thick  = 3.5;    // Độ dày tấm gá gia cố (3.5mm)
bracket_W      = 37.0;   // Chiều rộng gá xám (37mm)
base_L         = 25.0;   // Chiều dài bản gá
hole_screw_d   = 3.4;    // Đường kính lỗ ốc M3 (3.4mm xỏ trơn mượt)
motor_center_z = -16.5;  // Tâm trục động cơ JGA25 chuẩn
bracket_R      = 15.0;   // Bán kính bo đáy gá motor

// THÔNG SỐ VÁCH KÉO DÀI GÁ MOTOR
side_wall_H    = 34.0;   
side_wall_z0   = -14.0;  

// THÔNG SỐ VỊ TRÍ TÂM LỖ XOAY M3
pin_top_z      = 14.0;   // Vị trí tâm lỗ M3 trên
pin_bottom_z   = -8.0;   // Vị trí tâm lỗ M3 dưới

// THÔNG SỐ THANH ĐÒN LIÊN KẾT HEAVY-DUTY (THANH MÀU XANH LÁ)
arm_L          = 70.0;   // Khoảng cách 2 tâm lỗ (70mm)
arm_thick      = 5.0;    // Độ dày thanh đòn gia cố (5.0mm)
arm_hole_d     = 3.4;    // Lỗ xoay bulông M3 (D=3.4mm)
eye_od         = 14.0;   // Bầu mắt xoay D=14.0mm
arm_clearance  = 0.6;    // Khe hở trượt chống cấn 0.6mm
boss_d         = 12.0;   // Gờ đệm xoay
boss_h         = 0.8;    // Độ dày đệm boss
shock_ear_w    = 5.0;    // Độ dày tai bắt phuộc gia cố (5.0mm)

// THÔNG SỐ KHUNG XE CHỮ L
chassis_top_z  = 125.0;  // Chiều cao đỉnh vách chữ L nâng lên 125mm (Nóc cao)
foot_L         = 32.0;   // Chiều dài tấm ngắn đỉnh chữ L nhô ra theo chiều Y dương

// THÔNG SỐ TÍNH TOÁN TỰ ĐỘNG CHO PHUỘC PITON KHỚP 100% VỚI 2 TAI GÁ
piston_p1_y    = -13.0;
piston_p1_z    = bracket_thick + 8.0;

piston_p2_y    = -base_L - arm_L + foot_L/2;
piston_p2_z    = chassis_top_z - bracket_thick - 8.0;

piston_dy      = piston_p2_y - piston_p1_y;
piston_dz      = piston_p2_z - piston_p1_z;

piston_total_L = sqrt(piston_dy * piston_dy + piston_dz * piston_dz);
piston_angle   = atan2(abs(piston_dy), piston_dz);

// 1. MODULE BULÔNG THÉP M3 VÀ TÁN TỰ KHÓA NYLOC (DÙNG CHO TAI PHUỘC)
module M3_Bolt_Assembly(bolt_L = 16.0) {
    color([0.85, 0.88, 0.92]) {
        difference() {
            cylinder(d=5.5, h=3.0, center=true);
            translate([0, 0, 0.5]) cylinder(r=(2.5/cos(30))/2, h=2.2, $fn=6);
        }
        translate([0, 0, bolt_L/2 + 1.5])
            cylinder(d=3.0, h=bolt_L, center=true);
    }
    color([0.15, 0.5, 0.9]) {
        translate([0, 0, bolt_L + 1.5])
            difference() {
                cylinder(r=(5.5/cos(30))/2, h=4.0, center=true, $fn=6);
                cylinder(d=3.0, h=5.0, center=true);
            }
    }
}

// 2. MODULE CHỐT NẤM ĐÀN HỒI XẺ RÃNH CHỮ THẬP (+) ĐÚC LIỀN
module Snap_Pin_Stud() {
    pin_d   = 6.0;   // Thân trụ xoay D=6mm
    pin_L   = 5.6;   // Dài 5.6mm (cho thanh đòn dày 5mm + 0.6mm xoay trơn)
    cap_d   = 7.6;   // Mũ nấm phình to 7.6mm
    cap_L   = 3.8;   // Mũ nấm cao 3.8mm
    slot_w  = 1.2;   // Rãnh xẻ chữ thập (+)

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

// 3. MODULE THANH ĐÒN LIÊN KẾT SNAP-FIT (THANH MÀU XANH LÁ)
module Suspension_Link_Arm(length = arm_L) {
    eye_od_snap     = 16.0;
    arm_hole_d_snap = 6.3;

    color([0.2, 0.75, 0.3]) difference() {
        union() {
            hull() {
                cylinder(d=eye_od_snap, h=arm_thick, center=true);
                translate([0, -length, 0]) cylinder(d=eye_od_snap, h=arm_thick, center=true);
            }
            // Gân tăng cứng sống giữa
            hull() {
                cylinder(d=eye_od_snap - 2.5, h=arm_thick + 0.8, center=true);
                translate([0, -length, 0]) cylinder(d=eye_od_snap - 2.5, h=arm_thick + 0.8, center=true);
            }
        }
        cylinder(d=arm_hole_d_snap, h=arm_thick + 4, center=true);
        translate([0, -length, 0]) cylinder(d=arm_hole_d_snap, h=arm_thick + 4, center=true);
    }
}

// 4. MODULE GÁ SỐ 1: GÁ ĐỠ MOTOR TÍCH HỢP CHỐT NẤM (bracket_W = 37mm, vách dày 3.5mm)
module Motor_Bracket_Gray() {
    fillet_r     = 6.0;
    ring_L       = 36.0;
    motor_bore_d = 25.6;

    color([0.55, 0.58, 0.62]) difference() {
        union() {
            // [A] Mặt phẳng gá chính (dày 3.5mm)
            translate([0, -base_L/2, bracket_thick/2])
                cube([bracket_W, base_L, bracket_thick], center=true);

            // [B] Mặt đứng trước (dày 3.5mm)
            translate([0, bracket_thick/2, (motor_center_z - bracket_R + bracket_thick)/2])
                cube([bracket_W, bracket_thick, abs(motor_center_z - bracket_R) + bracket_thick], center=true);

            // [C] VÒNG ĐỠ ĐỘNG CƠ KÉO DÀI ÔM THÂN MOTOR (ring_L = 36mm)
            translate([0, 0, motor_center_z])
                rotate([90, 0, 0])
                cylinder(r=bracket_R, h=ring_L);

            // Khối gân liên kết từ vòm đỡ lên mặt phẳng gá chính
            translate([0, -base_L/2, (motor_center_z + bracket_R + bracket_thick/2)/2])
                cube([2*bracket_R, base_L, abs(motor_center_z + bracket_R - bracket_thick/2) + 0.1], center=true);

            // Gân vát vuốt nối từ mép bản gá xuống đuôi vòng đỡ
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

            // [E] QUẢ CẦU LỒI KHỚP PHUỘC (MALE BALL STUD D=10mm)
            translate([0, -13.0, bracket_thick]) {
                cylinder(d1 = 12.0, d2 = 6.0, h = 4.0);
                cylinder(d = 6.0, h = 8.0);
                translate([0, 0, 8.0])
                    sphere(d = 10.0);
                translate([0, 6, 3])
                    rotate([45, 0, 0])
                    cube([5.0, 4, 6], center=true);
            }
        }

        // Lòng trong vòng đỡ ôm động cơ JGA25 (D = 25.6mm bù co ngót in 3D + vát mép miệng sau)
        translate([0, 1, motor_center_z])
            rotate([90, 0, 0]) {
                cylinder(d=motor_bore_d, h=ring_L + 5);
                translate([0, 0, ring_L - 1.5])
                    cylinder(d1=motor_bore_d, d2=motor_bore_d + 1.8, h=2.5);
            }

        // Lỗ tâm trục & 2 lỗ ren M3 động cơ JGA25 (giữ nguyên chuẩn ±8.5mm)
        translate([0, bracket_thick/2, motor_center_z])
            rotate([90, 0, 0]) cylinder(d=7.2, h=bracket_thick + 4, center=true);

        for (offset_x = [-8.5, 8.5]) {
            translate([offset_x, bracket_thick/2, motor_center_z])
                rotate([90, 0, 0]) cylinder(d=hole_screw_d, h=bracket_thick + 4, center=true);
        }

        // 4 Lỗ ốc M3 mặt bản đế (giữ nguyên chuẩn dx = ±7mm)
        for (dx = [-7, 7]) {
            for (dy = [-6, -20]) {
                translate([dx, dy, -1]) cylinder(d=hole_screw_d, h=bracket_thick + 4);
                translate([dx, dy, -0.1]) cylinder(d1=5.5, d2=hole_screw_d, h=1.5);
            }
        }
    }
}

// 5. MODULE PHUỘC PITON KHỚP CẦU ĐÀN HỒI (SNAP-FIT BALL SOCKET)
module Spring_Piston_SnapFit(total_L = piston_total_L) {
    collar_od_val   = 28.0;
    collar_thick_val= 4.0;
    cup_rim_h_val   = 2.5;
    cylinder_od_val = 13.0;
    cylinder_bore_val= 8.5;
    piston_rod_val  = 7.8;
    cyl_h_val       = total_L * 0.52;
    rod_h_val       = total_L * 0.58;

    // [A] Cụm chén cầu lõm dưới & Xilanh màu xanh có đĩa chén ôm lò xo
    color([0.2, 0.5, 0.85]) {
        // Chén cầu lõm dưới
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

        // Đĩa đỡ lò xo có vành gờ chén ôm khít chân lò xo
        translate([0, 0, 8.0]) {
            difference() {
                union() {
                    translate([0, 0, -collar_thick_val])
                        cylinder(d=collar_od_val, h=collar_thick_val);
                    cylinder(d=collar_od_val, h=cup_rim_h_val);
                }
                translate([0, 0, -0.1])
                    cylinder(d=25.4, h=cup_rim_h_val + 1.0);
            }
        }

        difference() {
            union() {
                translate([0, 0, 8.0]) cylinder(d=cylinder_od_val, h=cyl_h_val);
                translate([0, 0, 8.0]) cylinder(d1=15.0, d2=cylinder_od_val, h=3.0);
            }
            translate([0, 0, 7.9]) cylinder(d=cylinder_bore_val, h=cyl_h_val + 3.0);
            for (wz = [18.0 : 12.0 : 8.0 + cyl_h_val - 8.0]) {
                translate([0, 0, wz]) cube([cylinder_od_val + 4.0, 4.0, 5.0], center=true);
            }
        }
    }

    // [B] Cụm chén cầu lõm trên & Ty piton màu xám có đĩa chén ôm lò xo
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
                            cylinder(d=25.4, h=cup_rim_h_val + 1.0);
                    }
                }

                translate([0, 0, 8.0])
                    cylinder(d=piston_rod_val, h=rod_h_val);
                translate([0, 0, 8.0])
                    cylinder(d1=13.0, d2=piston_rod_val, h=3.0);
            }
        }
    }

    // [C] Lò xo siêu dày Heavy-Duty D=6.2mm với 2 đầu phẳng tì khít 100%
    color([0.9, 0.15, 0.15]) {
        spring_start_z = 8.0;
        spring_end_z   = total_L - 8.0;
        spring_height  = spring_end_z - spring_start_z;
        turns          = 5.5;
        steps          = 80;
        r_mean         = 9.4;
        wire_d         = 6.2; // Dây lò xo dày 6.2mm

        // Vòng đáy phẳng tiếp xúc 360 độ vào đĩa dưới
        translate([0, 0, spring_start_z + wire_d/2 - 0.5])
            rotate_extrude($fn=36) translate([r_mean, 0, 0]) circle(d=wire_d, $fn=16);

        // Các vòng xoắn
        for (i = [0 : steps - 1]) {
            t1 = i / steps;
            t2 = (i + 1) / steps;
            z1 = spring_start_z + t1 * spring_height;
            z2 = spring_start_z + t2 * spring_height;
            a1 = t1 * turns * 360;
            a2 = t2 * turns * 360;
            hull() {
                translate([r_mean * cos(a1), r_mean * sin(a1), z1]) sphere(d=wire_d, $fn=12);
                translate([r_mean * cos(a2), r_mean * sin(a2), z2]) sphere(d=wire_d, $fn=12);
            }
        }

        // Vòng đỉnh phẳng tiếp xúc 360 độ vào đĩa trên
        translate([0, 0, spring_end_z - wire_d/2 + 0.5])
            rotate_extrude($fn=36) translate([r_mean, 0, 0]) circle(d=wire_d, $fn=16);
    }
}

// 6. MODULE ỐC VÍT ĐẦU CHÌM BAKE
module screw_bake_head() {
    color("DimGray") difference() {
        cylinder(d1=2.8, d2=3.6, h=1.2);
        translate([0, 0, 0.7]) cube([3.2, 0.6, 1.2], center=true);
        translate([0, 0, 0.7]) cube([0.6, 3.2, 1.2], center=true);
    }
}

// 7. MODULE ĐỘNG CƠ GIẢM TỐC JGA25 KÈM ENCODER
module JGA25_Motor_Complete() {
    L_gearbox = 19.0;
    L_motor   = 31.0;
    D_body    = 24.4;
    D_gearbox = 25.0;

    color([0.82, 0.84, 0.86]) difference() {
        cylinder(d=D_gearbox, h=L_gearbox);
        translate([0, 8.5, L_gearbox - 6]) cylinder(d=3.0, h=7);
        translate([0, -8.5, L_gearbox - 6]) cylinder(d=3.0, h=7);
        translate([8.0, 0, L_gearbox - 1.5]) cylinder(d=3.8, h=2);
        translate([-8.0, 0, L_gearbox - 1.5]) cylinder(d=3.8, h=2);
    }
    translate([8.0, 0, L_gearbox - 1.2]) screw_bake_head();
    translate([-8.0, 0, L_gearbox - 1.2]) screw_bake_head();

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

        wire_colors = [
            [0.85, 0.1, 0.1], [0.1, 0.1, 0.1], [0.9, 0.8, 0.1],
            [0.1, 0.7, 0.2], [0.1, 0.3, 0.8], [0.9, 0.9, 0.9]
        ];
        for (i = [0 : 5]) {
            color(wire_colors[i]) {
                translate([-5 + i * 2, D_body/2 - 2.5, -5]) 
                    rotate([180, 0, (i - 2.5) * 3]) 
                    cylinder(d=1.2, h=38);
            }
        }
    }
}

// 8. MODULE KHỚP NỐI LỤC GIÁC ĐỒNG THAU 4MM (HEX 12MM RC WHEEL HUB)
module Brass_Hex_Hub_4mm() {
    color([0.85, 0.68, 0.2]) {
        difference() {
            union() {
                cylinder(d=11.5, h=11.0);
                translate([0, 0, 11.0])
                    cylinder(r=12.0 / cos(30) / 2, h=7.0, $fn=6);
            }
            translate([0, 0, -1])
                cylinder(d=4.05, h=12.5);
            translate([0, 0, 10.0])
                cylinder(d=3.8, h=9.0);
            for (ang = [90, 180]) {
                rotate([0, 0, ang])
                    translate([0, 0, 5.5])
                    rotate([90, 0, 0])
                    cylinder(d=3.0, h=15, center=true);
            }
        }
    }
    
    color([0.2, 0.2, 0.2]) {
        for (ang = [90, 180]) {
            rotate([0, 0, ang])
                translate([0, 5.2, 5.5])
                rotate([90, 0, 0])
                difference() {
                    cylinder(d=2.9, h=1.5, center=true);
                    translate([0, 0, 0.5]) cylinder(r=1.5/cos(30)/2, h=1, center=true, $fn=6);
                }
        }
    }
}

// 9. MODULE BÁNH XE LỐP TỔ ONG ĐỊA HÌNH KHÔNG HƠI (HONEYCOMB AIRLESS WHEEL D=88mm)
module Honeycomb_Airless_Wheel(OD = 88.0, width = 32.0) {
    rim_d       = 46.0;
    tire_od     = OD;
    n_cells     = 18;
    
    // [A] Mâm đáy trong & Khớp lục giác
    color([0.25, 0.27, 0.30]) {
        difference() {
            union() {
                cylinder(d=rim_d, h=width);
                cylinder(d=rim_d + 3.0, h=3.0);
                translate([0, 0, width - 3.0])
                    cylinder(d=rim_d + 3.0, h=3.0);
            }
            translate([0, 0, -1])
                cylinder(r=(12.3 / cos(30)) / 2, h=7.0, $fn=6);
            translate([0, 0, -2])
                cylinder(d=4.5, h=width + 4);
            translate([0, 0, width - 6.0])
                cylinder(d=11.0, h=7.0);
            for (ang = [0 : 60 : 300]) {
                rotate([0, 0, ang])
                    translate([14.0, 0, 7.0])
                    cylinder(d=6.5, h=width - 14.0);
            }
        }
    }
    
    // [B] Lốp tổ ong & gai địa hình
    color([0.16, 0.16, 0.16]) {
        difference() {
            union() {
                cylinder(d=tire_od, h=width);
                for (ang = [0 : 10 : 350]) {
                    rotate([0, 0, ang])
                        translate([tire_od/2 - 0.2, 0, 7.5])
                        rotate([0, 35, 0])
                        cube([2.4, 4.0, 7.0], center=true);
                    rotate([0, 0, ang + 5])
                        translate([tire_od/2 - 0.2, 0, width - 7.5])
                        rotate([0, -35, 0])
                        cube([2.4, 4.0, 7.0], center=true);
                }
            }
            translate([0, 0, -1])
                cylinder(d=rim_d, h=width + 2);
            translate([0, 0, width/2])
                difference() {
                    cylinder(d=tire_od + 10, h=4.0, center=true);
                    cylinder(d=tire_od - 4.0, h=5.0, center=true);
                }
            for (ang = [0 : 10 : 350]) {
                rotate([0, 0, ang + 5])
                    translate([tire_od/2, 0, 7.5])
                    cube([4.0, 2.0, 10.0], center=true);
                rotate([0, 0, ang])
                    translate([tire_od/2, 0, width - 7.5])
                    cube([4.0, 2.0, 10.0], center=true);
            }
            for (i = [0 : n_cells - 1]) {
                rotate([0, 0, i * (360 / n_cells)])
                    translate([28.0, 0, -1])
                    rotate([0, 0, 30])
                    cylinder(r=(6.4 / cos(30)) / 2, h=width + 2, $fn=6);
            }
            for (i = [0 : n_cells - 1]) {
                rotate([0, 0, i * (360 / n_cells) + 10.0])
                    translate([35.8, 0, -1])
                    rotate([0, 0, 30])
                    cylinder(r=(7.8 / cos(30)) / 2, h=width + 2, $fn=6);
            }
        }
    }
    
    // [C] Tán nhôm M4 khóa bánh
    color([0.1, 0.55, 0.95]) {
        translate([0, 0, width - 4.5]) {
            difference() {
                cylinder(r=(7.0 / cos(30)) / 2, h=4.0, $fn=6);
                translate([0, 0, -1])
                    cylinder(d=4.0, h=6.0);
            }
        }
    }
}

// 10. MODULE CỤM BÁNH XE & THANH ĐÒN TREO (GẮN NGOÀI BÁNH XE)
module Wheel_Motor_Assembly() {
    Motor_Bracket_Gray();

    translate([0, -19.0, motor_center_z])
        rotate([-90, 0, 0])
        JGA25_Motor_Complete();

    translate([0, 2.5, motor_center_z])
        rotate([-90, 0, 0])
        Brass_Hex_Hub_4mm();

    translate([0, 13.5, motor_center_z])
        rotate([-90, 0, 0])
        Honeycomb_Airless_Wheel(OD = 96.0, width = 34.0);

    color("Silver") {
        translate([-8.5, bracket_thick + 0.2, motor_center_z]) rotate([90, 0, 0]) screw_bake_head();
        translate([8.5, bracket_thick + 0.2, motor_center_z]) rotate([90, 0, 0]) screw_bake_head();
    }

    // 4 Thanh đòn liên kết Snap-Fit màu xanh lá (arm_L = 70mm, bracket_W = 37mm)
    for (side_x = [-1, 1]) {
        arm_posX = side_x * (bracket_W/2 + arm_thick/2 + 0.8);

        translate([arm_posX, -base_L/2, pin_top_z]) {
            rotate([0, 90, 0])
                Suspension_Link_Arm(length = arm_L);
        }

        translate([arm_posX, -base_L/2, pin_bottom_z]) {
            rotate([0, 90, 0])
                Suspension_Link_Arm(length = arm_L);
        }
    }

    // Phuộc Piton Khớp Cầu Đàn Hồi Snap-Fit
    translate([0, piston_p1_y, piston_p1_z])
        rotate([piston_angle, 0, 0])
        Spring_Piston_SnapFit(total_L = piston_total_L);
}

// ==============================================================================
// 11. KHUNG THÂN XE UGV HỢP NHẤT TOÀN BỘ LIỀN KHỐI (MONOLITHIC CHASSIS)
// ==============================================================================

// CÁC THÔNG SỐ HÌNH HỌC THÂN XE
L_belly       = 140.0;                       // Chiều dài khoang bụng giữa 2 bánh (140mm)
y_front_mount = -base_L - arm_L;             // Vách trước bụng: Y = -95.0mm
y_rear_mount  = y_front_mount - L_belly;     // Vách sau bụng:  Y = -235.0mm
box_y_center  = (y_front_mount + y_rear_mount) / 2; // Tâm khoang bụng = -165.0mm
suspension_X  = 130.0;                       // Khoảng cách tâm cụm treo (±130mm)

// KÍCH THƯỚC CHIỀU RỘNG X CÁC PHÂN ĐOẠN
W_belly       = 350.0;                       // Bề rộng 2 hông bụng xe mở rộng ra 350mm (PHỦ RA NGOÀI NGANG MÉP BÁNH XE)
W_corridor    = 176.0;                       // Bề rộng khoang đầu và đuôi (176mm: hở 20mm né cụm treo)

L_nose        = 85.0;                        // Chiều dài mũi xe nhô ra trước (85mm)
L_tail        = 85.0;                        // Chiều dài đuôi xe nhô ra sau (85mm)

y_nose_tip    = y_front_mount + L_nose;      // Đỉnh mũi xe = -10.0mm
y_tail_tip    = y_rear_mount - L_tail;       // Đáy đuôi xe = -320.0mm

box_H         = chassis_top_z - side_wall_z0;// Chiều cao hộp thân = 109.0mm
wall_t        = 3.0;                         // Độ dày vách hộp (3mm)

// ĐA GIÁC ĐÁY 2D THÂN XE
chassis_outer_poly = [
    // [1] Mũi trước (Rộng 176mm, né cụm treo)
    [ W_corridor/2,  y_nose_tip],
    [ W_corridor/2,  y_front_mount],
    
    // [2] Hông bụng xe vươn rộng ra 2 bên (Rộng 350mm)
    [ W_belly/2,     y_front_mount],
    [ W_belly/2,     y_rear_mount],
    
    // [3] Đuôi sau (Rộng 176mm, né cụm treo)
    [ W_corridor/2,  y_rear_mount],
    [ W_corridor/2,  y_tail_tip],
    
    // [4] Nửa bên trái đối xứng
    [-W_corridor/2,  y_tail_tip],
    [-W_corridor/2,  y_rear_mount],
    
    // [5] Hông bụng bên trái vươn rộng ra ngoài (Rộng 350mm)
    [-W_belly/2,     y_rear_mount],
    [-W_belly/2,     y_front_mount],
    
    // [6] Mũi trước bên trái
    [-W_corridor/2,  y_front_mount],
    [-W_corridor/2,  y_nose_tip]
];

// MODULE CỤM GÁ TREO ĐƯỢC ĐÚC LIỀN VÀO THÂN XE (TẠI 1 GÓC) - BẢN HEAVY-DUTY
module Integrated_Chassis_Mount_Station() {
    ear_posY     = -base_L/2 + foot_L/2;
    gusset_thick = 3.5;
    gusset_L_y   = 28.0;
    gusset_H_z   = 36.0;
    hole_m3_d    = 3.4;

    difference() {
        union() {
            // 2 Vách bên gá treo (dày 3.5mm)
            translate([-bracket_W/2 + bracket_thick/2, 0, (pin_top_z + pin_bottom_z)/2])
                cube([bracket_thick, base_L, side_wall_H], center=true);

            translate([bracket_W/2 - bracket_thick/2, 0, (pin_top_z + pin_bottom_z)/2])
                cube([bracket_thick, base_L, side_wall_H], center=true);

            // 4 CHỐT NẤM ĐÀN HỒI ĐÚC LIỀN NHÔ RA 2 BÊN
            for (side_x = [-1, 1]) {
                for (posZ = [pin_bottom_z, pin_top_z]) {
                    translate([side_x * (bracket_W/2), 0, posZ])
                        rotate([0, side_x * 90, 0])
                        Snap_Pin_Stud();
                }
            }

            // [E] QUẢ CẦU LỒI KHỚP PHUỘC TRÊN KHUNG XE (MALE BALL STUD D=10mm)
            translate([0, ear_posY, chassis_top_z - bracket_thick]) {
                cylinder(d1 = 12.0, d2 = 6.0, h = 4.0);
                translate([0, 0, -4.0]) cylinder(d = 6.0, h = 4.0);
                translate([0, 0, -8.0])
                    sphere(d = 10.0);
                translate([0, -5, -4])
                    rotate([-45, 0, 0])
                    cube([5.0, 4, 6], center=true);
            }

            // Gân tăng cứng hông (dày 3.5mm)
            for (side_x = [-1, 1]) {
                posX = side_x * (bracket_W/2 - gusset_thick/2);
                translate([posX, -base_L/2, chassis_top_z - bracket_thick]) {
                    rotate([90, 0, 90])
                        linear_extrude(height = gusset_thick, center = true)
                        polygon(points = [
                            [0, 0],
                            [gusset_L_y, 0],
                            [0, -gusset_H_z]
                        ]);
                }
            }
        }
    }
}

// MODULE TẤM GIÁP NÓC CHE PHỦ PHUỘC & BÁNH XE ĐÚC LIỀN VÀO KHUNG XE
module Integrated_Fender_Deck() {
    fender_in_x  = 88.0;   
    fender_out_x = 182.0;  
    fender_w     = fender_out_x - fender_in_x; 
    fender_L     = 105.0;  
    fender_thick = 3.5;    
    lip_H        = 42.0;   
    arch_R       = 56.0;   

    difference() {
        union() {
            translate([fender_in_x, -95.0, chassis_top_z - fender_thick]) {
                cube([fender_w, fender_L, fender_thick]);
            }

            translate([fender_out_x - fender_thick, -95.0, chassis_top_z - lip_H]) {
                cube([fender_thick, fender_L, lip_H]);
            }

            for (rib_y = [-80 : 18 : -26]) {
                translate([132.0, rib_y, chassis_top_z])
                    rotate([0, 0, 25])
                    hull() {
                        cube([26.0, 5.0, 0.1], center=true);
                        translate([0, 0, 1.5]) cube([22.0, 3.0, 0.1], center=true);
                    }
            }
        }

        translate([fender_out_x - fender_thick - 1, 0, motor_center_z])
            rotate([0, 90, 0])
            cylinder(r = arch_R, h = fender_thick + 4);
    }
}

// TOÀN BỘ KHUNG THÂN XE HỢP NHẤT LIỀN KHỐI 100% (MONOLITHIC UNIFIED UGV CHASSIS)
module UGV_Unified_Monolithic_Chassis() {
    color([0.26, 0.28, 0.32]) {
        difference() {
            union() {
                // [1] Hộp thân xe chính (Thùng xe rỗng ruột)
                translate([0, 0, side_wall_z0]) {
                    linear_extrude(height = box_H)
                        polygon(points = chassis_outer_poly);

                    // Gờ miệng trên thùng xe
                    translate([0, 0, box_H - 4.0])
                        linear_extrude(height = 4.0)
                        offset(r = 3.0)
                        polygon(points = chassis_outer_poly);
                }

                // [2] 4 Cụm Giáp nóc bảo vệ bánh xe & phuộc đúc liền vào thùng
                Integrated_Fender_Deck();
                mirror([1, 0, 0]) Integrated_Fender_Deck();
                translate([0, box_y_center * 2, 0]) mirror([0, 1, 0]) Integrated_Fender_Deck();
                translate([0, box_y_center * 2, 0]) mirror([1, 0, 0]) mirror([0, 1, 0]) Integrated_Fender_Deck();

                // [3] 4 Cụm Vách gá treo đúc liền vào thân xe
                translate([-suspension_X, -base_L/2 - arm_L, 0])
                    mirror([1, 0, 0])
                    Integrated_Chassis_Mount_Station();

                translate([suspension_X, -base_L/2 - arm_L, 0])
                    Integrated_Chassis_Mount_Station();

                translate([-suspension_X, box_y_center * 2 - (-base_L/2 - arm_L), 0])
                    mirror([1, 0, 0])
                    mirror([0, 1, 0])
                    Integrated_Chassis_Mount_Station();

                translate([suspension_X, box_y_center * 2 - (-base_L/2 - arm_L), 0])
                    mirror([0, 1, 0])
                    Integrated_Chassis_Mount_Station();

                // [4] BẢN LỀ MỞ HÔNG THEO HƯỚNG TRỤC X (ĐẶT Ở MẠN SƯỜN TRÁI X = -W_belly/2)
                for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                    translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0]) {
                        rotate([90, 0, 0])
                            cylinder(d = 10.0, h = 18.0, center = true);
                    }
                }

                // [5] KHỚP NGÀM ĐÓN KHÓA SNAP-LOCK Ở MẠN SƯỜN PHẢI (X = +W_belly/2)
                translate([W_belly/2 + 3.0, box_y_center, chassis_top_z - 4.0]) {
                    difference() {
                        cube([10.0, 42.0, 12.0], center = true);
                        translate([0, 0, 2.0]) cube([12.0, 30.0, 8.0], center = true);
                    }
                }
            }

            // [6] Khoét rỗng 100% lòng trong thân xe
            translate([0, 0, side_wall_z0 + wall_t])
                linear_extrude(height = box_H + 5.0)
                offset(r = -wall_t)
                polygon(points = chassis_outer_poly);

            // [7] Lỗ trục bản lề hông trái D=3.2mm (dọc theo trục Y)
            for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0])
                    rotate([90, 0, 0])
                    cylinder(d = 3.2, h = 30.0, center = true);
            }

            // [8] 4 LỖ LUỒN DÂY HÌNH VIÊN THUỐC (PILL-SHAPED SLOTS: W=8.5mm, H=19mm)
            // Kéo dài từ Z = +14.0mm xuống Z = +1.0mm
            for (sx = [-1, 1]) {
                // 2 Lỗ phía trước (Front Bays)
                hull() {
                    translate([sx * suspension_X, y_front_mount, 14.0])
                        rotate([90, 0, 0])
                        cylinder(d = 8.5, h = wall_t * 3, center = true);
                    translate([sx * suspension_X, y_front_mount, 1.0])
                        rotate([90, 0, 0])
                        cylinder(d = 8.5, h = wall_t * 3, center = true);
                }

                // 2 Lỗ phía sau (Rear Bays)
                hull() {
                    translate([sx * suspension_X, y_rear_mount, 14.0])
                        rotate([90, 0, 0])
                        cylinder(d = 8.5, h = wall_t * 3, center = true);
                    translate([sx * suspension_X, y_rear_mount, 1.0])
                        rotate([90, 0, 0])
                        cylinder(d = 8.5, h = wall_t * 3, center = true);
                }
            }
        }

        // [9] Viền bo cao su bảo vệ hình viên thuốc (Pill-Shaped Grommet Collars)
        for (sx = [-1, 1]) {
            // Trước
            difference() {
                hull() {
                    translate([sx * suspension_X, y_front_mount, 14.0])
                        rotate([90, 0, 0])
                        cylinder(d = 12.5, h = wall_t + 1.2, center = true);
                    translate([sx * suspension_X, y_front_mount, 1.0])
                        rotate([90, 0, 0])
                        cylinder(d = 12.5, h = wall_t + 1.2, center = true);
                }
                hull() {
                    translate([sx * suspension_X, y_front_mount, 14.0])
                        rotate([90, 0, 0])
                        cylinder(d = 8.5, h = wall_t + 3, center = true);
                    translate([sx * suspension_X, y_front_mount, 1.0])
                        rotate([90, 0, 0])
                        cylinder(d = 8.5, h = wall_t + 3, center = true);
                }
            }
            // Sau
            difference() {
                hull() {
                    translate([sx * suspension_X, y_rear_mount, 14.0])
                        rotate([90, 0, 0])
                        cylinder(d = 12.5, h = wall_t + 1.2, center = true);
                    translate([sx * suspension_X, y_rear_mount, 1.0])
                        rotate([90, 0, 0])
                        cylinder(d = 12.5, h = wall_t + 1.2, center = true);
                }
                hull() {
                    translate([sx * suspension_X, y_rear_mount, 14.0])
                        rotate([90, 0, 0])
                        cylinder(d = 8.5, h = wall_t + 3, center = true);
                    translate([sx * suspension_X, y_rear_mount, 1.0])
                        rotate([90, 0, 0])
                        cylinder(d = 8.5, h = wall_t + 3, center = true);
                }
            }
        }

        // [10] Trụ bắt ốc M3 PCB Standoffs trong lòng xe
        for (sx = [-120, -60, 0, 60, 120]) {
            for (sy = [box_y_center - 35, box_y_center + 35]) {
                translate([sx, sy, side_wall_z0 + wall_t])
                    difference() {
                        cylinder(d=6.0, h=6.0);
                        translate([0, 0, 1]) cylinder(d=2.5, h=6);
                    }
            }
        }
        for (sx = [-50, 0, 50]) {
            for (sy = [y_nose_tip - 25, y_tail_tip + 25]) {
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
// 12. MODULE NẮP NÓC XE MỞ HÔNG THEO HƯỚNG TRỤC X (SIDE-HINGED CANOPY)
// ==============================================================================
module UGV_Removable_Hinged_Roof_Lid() {
    lid_thick    = 3.5;
    sealing_lip  = 3.0; // Gờ gài chống trượt & chống bụi/nước

    // Trục xoay bản lề đặt tại mép sườn hông trái: [-W_belly/2 - 3.5, 0, chassis_top_z + 4.0]
    translate([-W_belly/2 - 3.5, 0, chassis_top_z + 4.0])
    rotate([0, -roof_open_angle, 0])
    translate([W_belly/2 + 3.5, 0, -(chassis_top_z + 4.0)]) {

        // [A] THÂN NẮP NÓC XE (MÀU XÁM GIÁP ĐỒNG BỘ)
        color([0.32, 0.35, 0.40]) {
            difference() {
                union() {
                    // [1] Tấm nóc chính phủ kín 100% miệng thùng xe
                    translate([0, 0, chassis_top_z])
                        linear_extrude(height = lid_thick)
                        offset(r = 1.5)
                        polygon(points = chassis_outer_poly);

                    // [2] Gờ lọt lòng chống trượt & kín nước phía dưới
                    translate([0, 0, chassis_top_z - sealing_lip])
                        linear_extrude(height = sealing_lip)
                        offset(r = -wall_t - 0.6)
                        polygon(points = chassis_outer_poly);

                    // [3] 2 Ngàm bản lề sườn trái đúc liền nắp nóc
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

                    // [5] Chữ SUMO dập nổi thể thao xoay ngang -90 độ & viền khung trên nóc
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

                // [6] Lỗ xỏ chốt xoay bản lề D=3.2mm (dọc theo trục Y)
                for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                    translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0])
                        rotate([90, 0, 0])
                        cylinder(d = 3.2, h = 45.0, center = true);
                }

                // [7] Hốc tay nắm móc ngón tay mở nắp phía sườn phải
                translate([W_belly/2 - 15.0, box_y_center, chassis_top_z + lid_thick/2]) {
                    cube([16.0, 48.0, lid_thick + 2.0], center = true);
                }
            }
        }

        // [B] TAY NẮM MÓC NHỰA MÀU CAM BÊN SƯỜN PHẢI ĐỂ CẠY MỞ NẮP
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

        // [C] CHỐT TRỤC XOAY BẢN LỀ BẰNG THÉP (SILVER PINS DỌC THEO HÔNG TRÁI)
        color("Silver") {
            for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0])
                    rotate([90, 0, 0])
                    cylinder(d = 3.0, h = 40.0, center = true);
            }
        }
    }
}

// ==============================================================================
// LẮP RÁP HOÀN THIỆN TOÀN BỘ XE ROBOT UGV 4 BÁNH + NẮP NÓC XE MỞ HÔNG THEO TRỤC X
// ==============================================================================

// [1] TOÀN BỘ KHUNG THÂN XE UGV HỢP NHẤT LIỀN KHỐI 100%
UGV_Unified_Monolithic_Chassis();

// [2] NẮP NÓC XE MỞ HÔNG THEO TRỤC X VỚI BẢN LỀ TRÁI & KHÓA GÀI PHẢI
UGV_Removable_Hinged_Roof_Lid();

// [3] 4 CỤM BÁNH XE, ĐỘNG CƠ, THANH ĐÒN VÀ PHUỘC LÒ XO

// Góc 1: Bánh Trước - Trái (Front-Left)
translate([-suspension_X, 0, 0])
    Wheel_Motor_Assembly();

// Góc 2: Bánh Trước - Phải (Front-Right - Đối xứng qua trục X)
translate([suspension_X, 0, 0])
    mirror([1, 0, 0])
    Wheel_Motor_Assembly();

// Góc 3: Bánh Sau - Trái (Rear-Left - Đối xứng ra phía sau qua trục Y)
translate([-suspension_X, box_y_center * 2, 0])
    mirror([0, 1, 0])
    Wheel_Motor_Assembly();

// Góc 4: Bánh Sau - Phải (Rear-Right - Đối xứng chuẩn xác qua cả trục X và trục Y)
translate([suspension_X, box_y_center * 2, 0])
    mirror([1, 0, 0])
    mirror([0, 1, 0])
    Wheel_Motor_Assembly();