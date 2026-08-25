// ==============================================================================
// 01. KHUNG THÂN XE UGV LIỀN KHỐI (MONOLITHIC CHASSIS BODY)
// BỘ PHẬN IN 3D SỐ 1 - SỐ LƯỢNG CẦN IN: 1 CÁI
// NÂNG CẤP: NÓC XE CAO HƠN (chassis_top_z = 125mm), GẦM CAO RÁO VƯỢT ĐỊA HÌNH
// ĐÃ ĐƯỢC ĐẶT NẰM PHẲNG TRÊN MẶT BÀN IN (Z = 0)
// VẬT LIỆU KHUYÊN DÙNG: PETG / PLA+ / ABS (INFILL 30-40%)
// ==============================================================================
$fn = 36;

bracket_thick  = 3.5;
bracket_W      = 37.0;
base_L         = 25.0;
chassis_top_z  = 125.0;  // Nâng nóc xe cao lên 125mm
side_wall_z0   = -14.0;
foot_L         = 32.0;
side_wall_H    = 34.0;   // Chiều cao vách gá
pin_top_z      = 14.0;   // Vị trí tâm lỗ M3 trên
pin_bottom_z   = -8.0;   // Vị trí tâm lỗ M3 dưới
motor_center_z = -16.5;  // Tâm trục động cơ JGA25 chuẩn
arm_L          = 70.0;

L_belly       = 140.0;
y_front_mount = -base_L - arm_L;             // -95mm
y_rear_mount  = y_front_mount - L_belly;     // -235mm
box_y_center  = (y_front_mount + y_rear_mount) / 2; // -165mm
suspension_X  = 130.0;

W_belly       = 350.0;
W_corridor    = 176.0;
L_nose        = 85.0;
L_tail        = 85.0;

y_nose_tip    = y_front_mount + L_nose;      // -10mm
y_tail_tip    = y_rear_mount - L_tail;       // -320mm
box_H         = chassis_top_z - side_wall_z0;// 139mm (khoang chứa cực kỳ rộng rãi)
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

module Snap_Pin_Stud() {
    pin_d   = 6.0;   // Thân trụ xoay D=6mm
    pin_L   = 5.6;   // Dài 5.6mm (cho thanh đòn dày 5mm + 0.6mm xoay trơn)
    cap_d   = 7.6;   // Mũ nấm phình to 7.6mm
    cap_L   = 3.8;   // Mũ nấm cao 3.8mm
    slot_w  = 1.2;   // Rãnh xẻ chữ thập (+)

    difference() {
        union() {
            // Gờ đệm boss chống cọ xát
            cylinder(d = 12.0, h = 0.8);
            // Thân trụ xoay trơn mượt
            translate([0, 0, 0.8])
                cylinder(d = pin_d, h = pin_L);
            // Mũ nấm khóa vát côn
            translate([0, 0, 0.8 + pin_L]) {
                cylinder(d = cap_d, h = 0.8);
                translate([0, 0, 0.8])
                    cylinder(d1 = cap_d, d2 = pin_d - 1.8, h = cap_L - 0.8);
            }
        }

        // Rãnh xẻ chữ thập (+) tạo 4 cánh đàn hồi
        translate([0, 0, 0.8 + pin_L * 0.35 + (pin_L * 0.65 + cap_L)/2]) {
            cube([slot_w, cap_d + 4.0, pin_L * 0.65 + cap_L + 1.0], center = true);
            cube([cap_d + 4.0, slot_w, pin_L * 0.65 + cap_L + 1.0], center = true);
        }
        // Lỗ giảm ứng suất gốc rãnh
        translate([0, 0, 0.8 + pin_L * 0.35])
            sphere(d = slot_w * 1.5);
    }
}

module Integrated_Chassis_Mount_Station() {
    ear_posY     = -base_L/2 + foot_L/2;
    gusset_thick = 3.5;
    gusset_L_y   = 28.0;
    gusset_H_z   = 48.0;
    shock_ear_w  = 5.0;
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
                // Chân đế tròn mở rộng D=12mm vuốt côn mượt lên cổ D=5.2mm
                cylinder(d1 = 12.0, d2 = 5.2, h = 4.0);
                translate([0, 0, -4.0]) cylinder(d = 5.2, h = 4.0);
                // Quả cầu lồi D=10.0mm tròn láng
                translate([0, 0, -8.0])
                    sphere(d = 10.0);
            }

            // Gân tăng cứng hông
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

// KHUNG THÂN XE ĐƯỢC ĐẶT CHUẨN Z=0 ĐỂ IN TRỰC TIẾP
translate([0, 0, -side_wall_z0]) {
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

            Integrated_Fender_Deck();
            mirror([1, 0, 0]) Integrated_Fender_Deck();
            translate([0, box_y_center * 2, 0]) mirror([0, 1, 0]) Integrated_Fender_Deck();
            translate([0, box_y_center * 2, 0]) mirror([1, 0, 0]) mirror([0, 1, 0]) Integrated_Fender_Deck();

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

            // Bản lề hông trái
            for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
                translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0]) {
                    rotate([90, 0, 0])
                        cylinder(d = 10.0, h = 18.0, center = true);
                }
            }

            // Ngàm khóa hông phải
            translate([W_belly/2 + 3.0, box_y_center, chassis_top_z - 4.0]) {
                difference() {
                    cube([10.0, 42.0, 12.0], center = true);
                    translate([0, 0, 2.0]) cube([12.0, 30.0, 8.0], center = true);
                }
            }
        }

        // Khoét rỗng
        translate([0, 0, side_wall_z0 + wall_t])
            linear_extrude(height = box_H + 5.0)
            offset(r = -wall_t)
            polygon(points = chassis_outer_poly);

        // Lỗ trục bản lề D=3.2mm
        for (hy = [box_y_center - 40.0, box_y_center + 40.0]) {
            translate([-W_belly/2 - 3.5, hy, chassis_top_z + 4.0])
                rotate([90, 0, 0])
                cylinder(d = 3.2, h = 30.0, center = true);
        }

        // 4 Lỗ viên thuốc luồn dây điện
        for (sx = [-1, 1]) {
            hull() {
                translate([sx * suspension_X, y_front_mount, 14.0])
                    rotate([90, 0, 0])
                    cylinder(d = 8.5, h = wall_t * 3, center = true);
                translate([sx * suspension_X, y_front_mount, 1.0])
                    rotate([90, 0, 0])
                    cylinder(d = 8.5, h = wall_t * 3, center = true);
            }
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

    // Viền cao su lỗ viên thuốc
    for (sx = [-1, 1]) {
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

    // Trụ standoff M3
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
