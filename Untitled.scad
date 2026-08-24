// ==============================================================================
// XE ROBOT TỰ HÀNH UGV 4 BÁNH (4WD): 4 CỤM TREO ĐỘC LẬP + LỐP TỔ ONG
// BẢN NÂNG CẤP: TẠO KHOẢNG HỞ RỘNG RÃI (20mm) GIỮA THÀNH XE VÀ CƠ CẤU GIẢM SỐC
// CHỐNG CẠ VÁCH KHI NHÚN NHẢY - W_corridor = 176mm, W_belly = 300mm
// ==============================================================================
$fn = 36;

bracket_thick  = 2.0;    // Độ dày tấm gá (mm)
bracket_W      = 37.0;   // Chiều rộng gá xám (37mm)
base_L         = 25.0;   // Chiều dài bản gá
hole_screw_d   = 3.2;    // Đường kính lỗ ốc M3
motor_center_z = -16.5;  // Tâm trục động cơ (đặt phía dưới, theo trục Z âm)
bracket_R      = 14.5;   // Bán kính bo đáy gá motor

// THÔNG SỐ VÁCH KÉO DÀI GÁ MOTOR
side_wall_H    = 32.0;   
side_wall_z0   = -14.0;  

// THÔNG SỐ VỊ TRÍ CHỐT XOAY
pin_top_z      = 14.0;   // Vị trí chốt trên theo Z
pin_bottom_z   = -8.0;   // Vị trí chốt dưới theo Z

// THÔNG SỐ THANH ĐÒN LIÊN KẾT (THANH MÀU XANH LÁ)
arm_L          = 70.0;   // Khoảng cách 2 tâm lỗ (70mm)
arm_thick      = 3.0;    // Độ dày thanh đòn
arm_hole_d     = 4.8;    // Lỗ xoay D=4.8mm
arm_clearance  = 0.5;    // Khe hở trượt chống cấn 0.5mm

// THÔNG SỐ GÁ KHUNG XE CHỮ L (GÁ MÀU XÁM)
chassis_top_z  = 95.0;   // Chiều cao đỉnh vách chữ L (+95mm)
foot_L         = 32.0;   // Chiều dài tấm ngắn đỉnh chữ L nhô ra theo chiều Y dương

// THÔNG SỐ TÍNH TOÁN TỰ ĐỘNG CHO PHUỘC PITON KHỚP 100% VỚI 2 TAI GÁ XÁM
piston_p1_y    = -13.0;
piston_p1_z    = bracket_thick + 8.0;

piston_p2_y    = -base_L - arm_L + foot_L/2;
piston_p2_z    = chassis_top_z - bracket_thick - 8.0;

piston_dy      = piston_p2_y - piston_p1_y;
piston_dz      = piston_p2_z - piston_p1_z;

piston_total_L = sqrt(piston_dy * piston_dy + piston_dz * piston_dz);
piston_angle   = atan2(abs(piston_dy), piston_dz);

// 1. MODULE CHỐT SNAP-FIT GỜ NÓN DẤU CỘNG (+) CHO KHỚP XOAY THANH ĐÒN
module Arm_Snap_Fit_Pin() {
    shaft_d     = 4.5;  // Thân chốt xoay D=4.5mm
    barb_d      = 5.3;  // Gờ móc nón nở ra 5.3mm
    barb_tip_d  = 2.8;  // Đỉnh nón vát nhỏ D=2.8mm
    shaft_len   = 3.8;  // Chiều dài thân chốt qua thanh đòn
    barb_len    = 2.4;  // Chiều dài chóp gờ nón
    slot_w      = 0.8;  // Bề rộng rãnh xẻ co giãn
    slot_depth  = shaft_len * 0.75 + barb_len;

    difference() {
        union() {
            cylinder(d=shaft_d, h=shaft_len);
            translate([0, 0, shaft_len])
                cylinder(d1=barb_d, d2=barb_tip_d, h=barb_len);
        }
        translate([0, 0, (shaft_len + barb_len) - slot_depth/2 + 0.1]) {
            cube([slot_w, barb_d + 2, slot_depth + 0.2], center=true);
            cube([barb_d + 2, slot_w, slot_depth + 0.2], center=true);
        }
    }
}

// 2. MODULE THANH ĐÒN LIÊN KẾT 2 ĐẦU (THANH MÀU XANH LÁ)
module Suspension_Link_Arm(length = arm_L) {
    color([0.2, 0.75, 0.3]) difference() {
        hull() {
            cylinder(d=10, h=arm_thick, center=true);
            translate([0, -length, 0]) cylinder(d=10, h=arm_thick, center=true);
        }
        cylinder(d=arm_hole_d, h=arm_thick + 2, center=true);
        translate([0, -length, 0]) cylinder(d=arm_hole_d, h=arm_thick + 2, center=true);
    }
}

// 3. MODULE GÁ SỐ 1: GÁ ĐỠ MOTOR (bracket_W = 37mm)
module Motor_Bracket_Gray() {
    fillet_r = 6.0;

    color([0.55, 0.58, 0.62]) difference() {
        union() {
            // [A] Mặt phẳng gá chính
            translate([0, -base_L/2 + bracket_thick/2, bracket_thick/2])
                cube([bracket_W, base_L, bracket_thick], center=true);

            // [B] Mặt đứng trước
            translate([0, bracket_thick/2, motor_center_z/2])
                cube([bracket_W, bracket_thick, abs(motor_center_z)], center=true);

            // [C] Vòm bo cong đáy gá motor
            translate([0, bracket_thick/2, motor_center_z])
                rotate([90, 0, 0])
                cylinder(r=bracket_R, h=bracket_thick, center=true);

            // [D] 2 Vách bên kéo dài
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
            }

            // [E] CƠ CẤU TAI VÒM
            translate([0, -13.0, bracket_thick]) {
                hull() {
                    translate([-1.5, -5, 0]) cube([3, 10, 1]);
                    translate([0, 0, 8]) rotate([0, 90, 0]) cylinder(d=10, h=3, center=true);
                    translate([-1.5, -5, 7]) cube([3, 10, 1]);
                }
            }

            // [F] 4 Chốt xoay Snap-fit
            for (side_x = [-1, 1]) {
                posX = side_x * (bracket_W/2);
                for (posZ = [pin_bottom_z, pin_top_z]) {
                    translate([posX, -base_L/2, posZ])
                        rotate([0, side_x * 90, 0])
                        Arm_Snap_Fit_Pin();
                }
            }
        }

        // Lỗ tâm trục & 2 lỗ ren M3 động cơ JGA25 (giữ nguyên chuẩn ±8.5mm)
        translate([0, bracket_thick/2, motor_center_z])
            rotate([90, 0, 0]) cylinder(d=7.2, h=bracket_thick + 2, center=true);

        for (offset_x = [-8.5, 8.5]) {
            translate([offset_x, bracket_thick/2, motor_center_z])
                rotate([90, 0, 0]) cylinder(d=hole_screw_d, h=bracket_thick + 2, center=true);
        }

        // 4 Lỗ ốc M3 mặt bản đế (giữ nguyên chuẩn dx = ±7mm)
        for (dx = [-7, 7]) {
            for (dy = [-6, -20]) {
                translate([dx, dy, -1]) cylinder(d=hole_screw_d, h=bracket_thick + 4);
                translate([dx, dy, -0.1]) cylinder(d1=5.0, d2=hole_screw_d, h=1);
            }
        }

        // Lỗ tai xỏ phuộc D=4.5mm
        translate([0, -13.0, bracket_thick + 8])
            rotate([0, 90, 0])
            cylinder(d=4.5, h=10, center=true);
    }
}

// 4. MODULE GÁ SỐ 2: GÁ KHUNG XE CHỮ L (bracket_W = 37mm)
module Chassis_L_Bracket_With_Ear() {
    wall_total_H = chassis_top_z - side_wall_z0; 
    ear_posY     = -base_L/2 + foot_L/2;
    gusset_thick = 2.5;
    gusset_L_y   = 28.0;
    gusset_H_z   = 36.0;
    
    color([0.55, 0.58, 0.62]) difference() {
        union() {
            // [A] Vách đứng
            translate([0, -base_L/2, side_wall_z0 + wall_total_H/2])
                cube([bracket_W, bracket_thick, wall_total_H], center=true);

            // [B] Tấm ngắn đỉnh chữ L
            translate([0, ear_posY, chassis_top_z - bracket_thick/2])
                cube([bracket_W, foot_L, bracket_thick], center=true);

            // [C] 2 Vách bên giữ 4 chốt xoay
            translate([-bracket_W/2 + bracket_thick/2, 0, (pin_top_z + pin_bottom_z)/2])
                cube([bracket_thick, base_L, side_wall_H], center=true);

            translate([bracket_W/2 - bracket_thick/2, 0, (pin_top_z + pin_bottom_z)/2])
                cube([bracket_thick, base_L, side_wall_H], center=true);

            // [D] CƠ CẤU TAI VÒM
            translate([0, ear_posY, chassis_top_z - bracket_thick]) {
                hull() {
                    translate([-1.5, -5, -1]) cube([3, 10, 1]);
                    translate([0, 0, -8]) rotate([0, 90, 0]) cylinder(d=10, h=3, center=true);
                    translate([-1.5, -5, -7]) cube([3, 10, 1]);
                }
            }

            // [E] 4 Chốt xoay Snap-fit
            for (side_x = [-1, 1]) {
                posX = side_x * (bracket_W/2);
                for (posZ = [pin_bottom_z, pin_top_z]) {
                    translate([posX, 0, posZ])
                        rotate([0, side_x * 90, 0])
                        Arm_Snap_Fit_Pin();
                }
            }

            // [F] 2 GÂN TRỢ LỰC TAM GIÁC
            for (side_x = [-1, 1]) {
                posX = side_x * (bracket_W/2 - gusset_thick/2);
                translate([posX, -base_L/2, chassis_top_z - bracket_thick]) {
                    rotate([90, 0, 90])
                        linear_extrude(height = gusset_thick, center = true)
                        difference() {
                            polygon(points = [
                                [0, 0],
                                [gusset_L_y, 0],
                                [0, -gusset_H_z]
                            ]);
                            polygon(points = [
                                [4.0, -4.0],
                                [gusset_L_y - 9.0, -4.0],
                                [4.0, -(gusset_H_z - 10.0)]
                            ]);
                        }
                }
            }
        }

        // 4 Lỗ ốc M3 tấm đỉnh chữ L
        for (dx = [-7, 7]) {
            for (dy = [-base_L/2 + 6, -base_L/2 + 26]) {
                translate([dx, dy, chassis_top_z - bracket_thick - 1])
                    cylinder(d=hole_screw_d, h=bracket_thick + 3);
                translate([dx, dy, chassis_top_z - 0.9])
                    cylinder(d1=hole_screw_d, d2=5.0, h=1);
            }
        }

        // LỖ XỎ TRÒN TRÊN TAI VÒM (D=4.5mm)
        translate([0, ear_posY, chassis_top_z - bracket_thick - 8])
            rotate([0, 90, 0])
            cylinder(d=4.5, h=10, center=true);

        // Lỗ ốc M3 vách đứng
        for (hole_z = [pin_top_z + 15, pin_top_z + 35, pin_top_z + 55, pin_top_z + 75]) {
            if (hole_z < chassis_top_z - 8) {
                translate([0, -base_L/2 - 2, hole_z])
                    rotate([-90, 0, 0]) cylinder(d=hole_screw_d, h=bracket_thick + 4);
            }
        }
    }
}

// 5. MODULE CHỐT SNAP-FIT CO GIÃN CHO PHUỘC PITON
module Snap_Fit_Pin_Left() {
    pin_outer_d = 4.0;
    pin_barb_d  = 4.7;
    barb_tip_d  = 2.4;
    ear_gap     = 3.6;
    barb_L      = 2.4;
    slot_w      = 0.8;
    slot_depth  = ear_gap * 0.75 + barb_L;

    rotate([0, -90, 0]) {
        difference() {
            union() {
                cylinder(d=pin_outer_d, h=ear_gap);
                translate([0, 0, ear_gap])
                    cylinder(d1=pin_barb_d, d2=barb_tip_d, h=barb_L);
            }
            translate([0, 0, (ear_gap + barb_L) - slot_depth/2 + 0.1]) {
                cube([slot_w, pin_barb_d + 2, slot_depth + 0.2], center=true);
                cube([pin_barb_d + 2, slot_w, slot_depth + 0.2], center=true);
            }
        }
    }
}

// 6. MODULE PHUỘC LÒ XO PITON TO DÀY HẦM HỐ
module Spring_Piston_SnapFit(total_L = piston_total_L) {
    piston_rod_d    = 5.0;   // Ty trục D=5.0mm
    cylinder_od     = 11.5;  // Vỏ xilanh D=11.5mm
    cylinder_bore_d = 7.0;   // Lòng xilanh D=7.0mm
    collar_od       = 25.0;  // Đĩa chặn D=25mm
    collar_thick    = 3.5;   // Độ dày đĩa 3.5mm
    
    spring_od       = 23.5;  // Lò xo ngoài D=23.5mm
    wire_d          = 5.6;   // Sợi dây D=5.6mm
    r_mean          = (spring_od - wire_d) / 2;
    cyl_h           = total_L * 0.46;

    // [A] Cụm đầu gá dưới & Vỏ xilanh xanh
    color([0.2, 0.5, 0.85]) {
        difference() {
            union() {
                translate([3.55, 0, 4.0])
                    cube([3.5, 11.0, 8.0], center=true);
                translate([3.55, 0, 0])
                    rotate([0, 90, 0])
                    cylinder(d=11.0, h=3.5, center=true);
                translate([0, 0, 8.0 - collar_thick/2])
                    cylinder(d=collar_od, h=collar_thick, center=true);
                translate([0, 0, 8.0])
                    cylinder(d1=13.0, d2=cylinder_od, h=3.0);
                translate([1.8, 0, 4.0])
                    cube([3.8, 11.0, 8.0], center=true);
            }
            translate([0, 0, 4.0])
                cube([3.6, 13.0, 9.0], center=true);
        }

        translate([1.8, 0, 0])
            Snap_Fit_Pin_Left();

        difference() {
            translate([0, 0, 8.0])
                cylinder(d=cylinder_od, h=cyl_h);
            
            translate([0, 0, 7.9])
                cylinder(d=cylinder_bore_d, h=cyl_h + 1.0);

            for (win_z = [16.0 : 10.0 : 8.0 + cyl_h - 6.0]) {
                translate([0, 0, win_z])
                    cube([cylinder_od + 3.0, 5.0, 5.0], center=true);
                translate([0, 0, win_z])
                    cube([5.0, cylinder_od + 3.0, 5.0], center=true);
            }
        }
    }

    // [B] Cụm đầu gá trên & Ty trục xám
    color([0.2, 0.5, 0.85]) {
        difference() {
            union() {
                translate([3.55, 0, total_L - 4.0])
                    cube([3.5, 11.0, 8.0], center=true);
                translate([3.55, 0, total_L])
                    rotate([0, 90, 0])
                    cylinder(d=11.0, h=3.5, center=true);
                translate([0, 0, total_L - 8.0 + collar_thick/2])
                    cylinder(d=collar_od, h=collar_thick, center=true);
                translate([0, 0, total_L - 8.0 - 3.0])
                    cylinder(d1=cylinder_od, d2=13.0, h=3.0);
                translate([1.8, 0, total_L - 4.0])
                    cube([3.8, 11.0, 8.0], center=true);
            }
            translate([0, 0, total_L - 4.0])
                cube([3.6, 13.0, 9.0], center=true);
        }

        translate([1.8, 0, total_L])
            Snap_Fit_Pin_Left();
    }

    // Ty trục xám D=5.0mm
    rod_bottom_z = total_L * 0.30;
    color("Silver") {
        translate([0, 0, rod_bottom_z])
            cylinder(d=piston_rod_d, h=total_L - 8.0 - rod_bottom_z);
    }

    // [C] Lò xo xoắn siêu dày
    color([0.95, 0.2, 0.2]) {
        spring_start_z = 8.0;
        spring_end_z   = total_L - 8.0;
        spring_height  = spring_end_z - spring_start_z;
        turns          = 6.0;
        steps          = 100;

        translate([0, 0, spring_start_z])
            rotate_extrude($fn=36)
            translate([r_mean, 0, 0])
            circle(d=wire_d, $fn=24);

        translate([0, 0, spring_end_z])
            rotate_extrude($fn=36)
            translate([r_mean, 0, 0])
            circle(d=wire_d, $fn=24);

        for (i = [0 : steps - 1]) {
            t1 = i / steps;
            t2 = (i + 1) / steps;
            z1 = spring_start_z + t1 * spring_height;
            z2 = spring_start_z + t2 * spring_height;
            a1 = t1 * turns * 360;
            a2 = t2 * turns * 360;

            hull() {
                translate([r_mean * cos(a1), r_mean * sin(a1), z1]) sphere(d=wire_d, $fn=16);
                translate([r_mean * cos(a2), r_mean * sin(a2), z2]) sphere(d=wire_d, $fn=16);
            }
        }
    }
}

// 7. MODULE ỐC VÍT ĐẦU CHÌM BAKE
module screw_bake_head() {
    color("DimGray") difference() {
        cylinder(d1=2.8, d2=3.6, h=1.2);
        translate([0, 0, 0.7]) cube([3.2, 0.6, 1.2], center=true);
        translate([0, 0, 0.7]) cube([0.6, 3.2, 1.2], center=true);
    }
}

// 8. MODULE ĐỘNG CƠ GIẢM TỐC JGA25 KÈM ENCODER
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

// 9. MODULE KHỚP NỐI LỤC GIÁC ĐỒNG THAU 4MM (HEX 12MM RC WHEEL HUB)
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

// 10. MODULE BÁNH XE LỐP TỔ ONG ĐỊA HÌNH KHÔNG HƠI (HONEYCOMB AIRLESS WHEEL D=88mm)
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

// 11. MODULE 1 CỤM TREO ĐỘC LẬP HOÀN CHỈNH (MOTOR + TREO + PHUỘC + BÁNH XE)
module Single_Suspension_Corner() {
    Motor_Bracket_Gray();

    translate([0, -19.0, motor_center_z])
        rotate([-90, 0, 0])
        JGA25_Motor_Complete();

    translate([0, 2.5, motor_center_z])
        rotate([-90, 0, 0])
        Brass_Hex_Hub_4mm();

    translate([0, 13.5, motor_center_z])
        rotate([-90, 0, 0])
        Honeycomb_Airless_Wheel(OD = 88.0, width = 32.0);

    color("Silver") {
        translate([-8.5, bracket_thick + 0.2, motor_center_z]) rotate([90, 0, 0]) screw_bake_head();
        translate([8.5, bracket_thick + 0.2, motor_center_z]) rotate([90, 0, 0]) screw_bake_head();
    }

    // 4 Thanh đòn liên kết màu xanh lá (arm_L = 70mm, bracket_W = 37mm)
    for (side_x = [-1, 1]) {
        arm_posX = side_x * (bracket_W/2 + arm_clearance + arm_thick/2);
        
        translate([arm_posX, -base_L/2, pin_top_z]) {
            rotate([0, 90, 0])
                Suspension_Link_Arm(length = arm_L);
        }
        
        translate([arm_posX, -base_L/2, pin_bottom_z]) {
            rotate([0, 90, 0])
                Suspension_Link_Arm(length = arm_L);
        }
    }

    // Gá Khung Xe Chữ L Màu Xám
    translate([0, -base_L/2 - arm_L, 0])
        Chassis_L_Bracket_With_Ear();

    // Phuộc Piton Lò Xo
    translate([0, piston_p1_y, piston_p1_z])
        rotate([piston_angle, 0, 0])
        Spring_Piston_SnapFit(total_L = piston_total_L);
}

// ==============================================================================
// 12. MODULE HỘP THÂN XE UGV CÓ HỐ HÕM TREO RỘNG RÃI (KHÔNG CẠ VÁCH KHI NHÚN)
// ==============================================================================

// CÁC THÔNG SỐ HÌNH HỌC THÂN XE
L_belly       = 140.0;                       // Chiều dài khoang bụng giữa 2 bánh (140mm)
y_front_mount = -base_L - arm_L;             // Vách trước bụng: Y = -95.0mm
y_rear_mount  = y_front_mount - L_belly;     // Vách sau bụng:  Y = -235.0mm
box_y_center  = (y_front_mount + y_rear_mount) / 2; // Tâm khoang bụng = -165.0mm
suspension_X  = 130.0;                       // Khoảng cách tâm cụm treo (±130mm)

// KHOẢNG HỞ RỘNG RÃI CHO CƠ CẤU TREO TỰ DO NHÚN NHẢY
W_belly       = 300.0;                       // Bề rộng vách gá bụng (300mm: đỡ trọn 100% vách gá chữ L)
W_corridor    = 176.0;                       // Bề rộng khoang đầu/đuôi (176mm: vách cách thanh đòn 20mm, cực kỳ thông thoáng)

L_nose        = 85.0;                        // Chiều dài mũi xe nhô ra trước (85mm)
L_tail        = 85.0;                        // Chiều dài đuôi xe nhô ra sau (85mm)

y_nose_tip    = y_front_mount + L_nose;      // Đỉnh mũi xe = -10.0mm
y_tail_tip    = y_rear_mount - L_tail;       // Đáy đuôi xe = -320.0mm

box_H         = chassis_top_z - side_wall_z0;// Chiều cao hộp thân = 109.0mm
wall_t        = 3.0;                         // Độ dày vách hộp (3mm)

// ĐA GIÁC ĐÁY 2D THÂN XE STEPPED WIDE-BODY (12 ĐIỂM VUÔNG VẮN CHUẨN XÁC)
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

module UGV_Continuous_Tub() {
    color([0.28, 0.30, 0.34]) difference() {
        union() {
            // [1] Khối thân hộp chính
            linear_extrude(height = box_H)
                polygon(points = chassis_outer_poly);

            // [2] Gờ vành miệng hộp dày 4mm xung quanh đỉnh trên
            translate([0, 0, box_H - 4.0])
                linear_extrude(height = 4.0)
                offset(r = 3.0)
                polygon(points = chassis_outer_poly);
        }

        // [3] KHOÉT RỖNG TOÀN BỘ LÒNG TRONG
        translate([0, 0, wall_t])
            linear_extrude(height = box_H + 5.0)
            offset(r = -wall_t)
            polygon(points = chassis_outer_poly);

        // [4] Các lỗ bắt ốc M3 liên kết 4 gá chữ L (Vách trước bụng Y=-95 & Vách sau bụng Y=-235)
        for (sx = [-1, 1]) {
            posX = sx * suspension_X;
            // Vách trước bụng
            for (hz = [pin_top_z + 15, pin_top_z + 35, pin_top_z + 55, pin_top_z + 75]) {
                if (hz < chassis_top_z - 8) {
                    translate([posX, y_front_mount, hz - side_wall_z0])
                        rotate([90, 0, 0])
                        cylinder(d=hole_screw_d, h=wall_t + 4, center=true);
                }
            }
            // Vách sau bụng
            for (hz = [pin_top_z + 15, pin_top_z + 35, pin_top_z + 55, pin_top_z + 75]) {
                if (hz < chassis_top_z - 8) {
                    translate([posX, y_rear_mount, hz - side_wall_z0])
                        rotate([90, 0, 0])
                        cylinder(d=hole_screw_d, h=wall_t + 4, center=true);
                }
            }
        }

        // [5] 4 Lỗ luồn dây điện động cơ & encoder ở 4 góc hông bụng
        for (sx = [-1, 1]) {
            for (sy = [y_front_mount - 18, y_rear_mount + 18]) {
                translate([sx * (W_belly/2), sy, 20])
                    rotate([0, 90, 0])
                    cylinder(d=8.0, h=wall_t + 4, center=true);
            }
        }

        // [6] Lưới lỗ M3 viền miệng trên để lắp nắp che hoặc khung cảm biến
        for (sx = [-1, 1]) {
            for (dy = [y_rear_mount + 25 : 30 : y_front_mount - 25]) {
                translate([sx * (W_belly/2 + 1.5), dy, box_H - 10])
                    cylinder(d=2.8, h=12);
            }
            for (dy = [y_front_mount + 15 : 25 : y_nose_tip - 10]) {
                translate([sx * (W_corridor/2 + 1.5), dy, box_H - 10])
                    cylinder(d=2.8, h=12);
            }
            for (dy = [y_tail_tip + 10 : 25 : y_rear_mount - 15]) {
                translate([sx * (W_corridor/2 + 1.5), dy, box_H - 10])
                    cylinder(d=2.8, h=12);
            }
        }
        for (dx = [-W_corridor/2 + 15 : 30 : W_corridor/2 - 15]) {
            translate([dx, y_nose_tip + 1.5, box_H - 10])
                cylinder(d=2.8, h=12);
            translate([dx, y_tail_tip - 1.5, box_H - 10])
                cylinder(d=2.8, h=12);
        }
    }

    // [7] Trụ bắt ốc M3 (PCB Standoffs) gắn mạch điều khiển, pin ở đáy lòng xe
    color([0.35, 0.38, 0.42]) {
        for (sx = [-50, 0, 50]) {
            for (sy = [y_tail_tip + 25, box_y_center - 35, box_y_center + 35, y_nose_tip - 25]) {
                translate([sx, sy, wall_t])
                    difference() {
                        cylinder(d=6.0, h=6.0);
                        translate([0, 0, 1]) cylinder(d=2.5, h=6);
                    }
            }
        }
    }

    // [8] TAY CẦM / CẢN VA TRƯỚC VÀ SAU
    color([0.22, 0.24, 0.26]) {
        bumper_w = W_corridor - 36; // Bề rộng cản 140mm
        // Cản trước
        translate([0, y_nose_tip + 10.0, box_H/2]) {
            rotate([0, 90, 0])
                cylinder(d=10.0, h=bumper_w, center=true);
            for (sx = [-1, 1]) {
                translate([sx * (bumper_w/2 - 12), -5.0, 0])
                    rotate([90, 0, 0])
                    cylinder(d=8.0, h=10.0, center=true);
            }
        }

        // Cản sau
        translate([0, y_tail_tip - 10.0, box_H/2]) {
            rotate([0, 90, 0])
                cylinder(d=10.0, h=bumper_w, center=true);
            for (sx = [-1, 1]) {
                translate([sx * (bumper_w/2 - 12), 5.0, 0])
                    rotate([90, 0, 0])
                    cylinder(d=8.0, h=10.0, center=true);
            }
        }
    }
}

// ==============================================================================
// LẮP RÁP HOÀN THIỆN TOÀN BỘ XE ROBOT UGV 4 BÁNH & THÂN HỘP RỖNG TRÊN
// ==============================================================================

// [1] HỘP THÂN XE UGV LIỀN KHỐI TOÀN BỘ ĐẦU - BỤNG - ĐUÔI RỖNG TRÊN
translate([0, 0, side_wall_z0])
    UGV_Continuous_Tub();

// [2] 4 CỤM BÁNH XE & HỆ THỐNG TREO ĐỘC LẬP TẠI 4 GÓC XE

// Góc 1: Bánh Trước - Trái (Front-Left)
translate([-suspension_X, 0, 0])
    Single_Suspension_Corner();

// Góc 2: Bánh Trước - Phải (Front-Right - Đối xứng qua trục X)
translate([suspension_X, 0, 0])
    mirror([1, 0, 0])
    Single_Suspension_Corner();

// Góc 3: Bánh Sau - Trái (Rear-Left - Đối xứng ra phía sau qua trục Y)
translate([-suspension_X, box_y_center * 2, 0])
    mirror([0, 1, 0])
    Single_Suspension_Corner();

// Góc 4: Bánh Sau - Phải (Rear-Right - Đối xứng chuẩn xác qua cả trục X và trục Y)
translate([suspension_X, box_y_center * 2, 0])
    mirror([1, 0, 0])
    mirror([0, 1, 0])
    Single_Suspension_Corner();