// ==============================================================================
// 06. PHUỘC LÒ XO PITON KHỚP CẦU ĐÀN HỒI (SNAP-FIT BALL-SOCKET SHOCK ABSORBER)
// BỘ PHẬN IN 3D SỐ 6 - SỐ LƯỢNG CẦN IN: 4 CỤM (MỖI CỤM GỒM 2 CHI TIẾT + LÒ XO)
// NÂNG CẤP HOÀN TOÀN:
// 1. ĐĨA CHẶN LÒ XO CÓ VÀNH GỜ ÔM SÂU 2.5mm (SPRING RETAINING CUP) GIÚP ĐẦU LÒ XO
//    ĂN KHỚP HOÀN TOÀN, KHÔNG BỊ TRƯỢT LỆCH, BÁM DÍNH IN 3D CỰC CHẮC
// 2. LÒ XO SỢI SIÊU DÀY D=6.2mm VỚI 2 ĐẦU PHẲNG TÌ KHÍT 100% VÀO MẶT ĐĨA
// 3. 2 ĐẦU PHUỘC LÀ 2 CHÉN CẦU LÕM XẺ RÃNH ĐÀN HỒI (SNAP-FIT BALL SOCKET)
//    LẮP RÁP TRONG 1 GIÂY BẰNG TAY (ZERO BOLTS / ZERO SCREWS)
// ==============================================================================
$fn = 48;

part_select = "all"; // "all" = In cả 3 chi tiết (Xilanh + Ty piton + Lò xo), "both" = 2 chi tiết piton, "spring" = Chỉ lò xo

bracket_thick  = 3.5;
base_L         = 25.0;
arm_L          = 70.0;
foot_L         = 32.0;
chassis_top_z  = 125.0;

piston_p1_y    = -13.0;
piston_p1_z    = bracket_thick + 8.0;
piston_p2_y    = -base_L - arm_L + foot_L/2;
piston_p2_z    = chassis_top_z - bracket_thick - 8.0;
piston_dy      = piston_p2_y - piston_p1_y;
piston_dz      = piston_p2_z - piston_p1_z;
piston_total_L = sqrt(piston_dy * piston_dy + piston_dz * piston_dz);

collar_od       = 30.0;  // Đĩa chặn mở rộng lên D=30mm
collar_thick    = 4.0;   // Độ dày đáy đĩa 4.0mm
cup_rim_h       = 2.8;   // Vành chén gờ ôm lò xo cao 2.8mm
cylinder_od     = 13.0;  // Vỏ ngoài xilanh D=13mm
cylinder_bore_d = 8.5;   // Lòng xilanh D=8.5mm
piston_rod_d    = 7.8;   // Ty trục D=7.8mm

// MODULE CHÉN CẦU LÕM XẺ RÃNH ĐÀN HỒI
module Snap_Ball_Socket() {
    socket_od = 14.0;  // Vỏ ngoài chén cầu D=14mm
    ball_id   = 10.2;  // Lòng cầu D=10.2mm
    mouth_d   = 8.6;   // Miệng chén D=8.6mm
    slit_w    = 1.2;   // Rãnh xẻ dọc đàn hồi

    difference() {
        union() {
            sphere(d = socket_od);
            translate([0, 0, 3.5])
                cylinder(d1 = 12.0, d2 = 14.0, h = 4.5);
        }

        sphere(d = ball_id);

        translate([0, 0, -socket_od/2 - 0.5])
            cylinder(d1 = mouth_d + 2.5, d2 = mouth_d, h = 3.5);
        translate([0, 0, -socket_od])
            cylinder(d = mouth_d + 4.0, h = socket_od/2 + 0.1);

        translate([0, 0, -2.0]) {
            cube([slit_w, socket_od + 4.0, socket_od + 4.0], center = true);
            cube([socket_od + 4.0, slit_w, socket_od + 4.0], center = true);
        }
    }
}

// [1] CHI TIẾT 1: THÂN XILANH VÀ ĐĨA CHÉN ÔM LÒ XO DƯỚI (LOWER CYLINDER)
module Shock_Lower_Cylinder(total_L = piston_total_L) {
    cyl_h       = total_L * 0.52;
    chamber_d   = 9.4; // Lòng trong khoang rộng 9.4mm (Mũ ngàm lơ lửng không chạm thành, chống sột soạt)
    mouth_lip_d = 8.2; // Vành miệng hãm 8.2mm giữ mũ ngàm chống văng
    lip_h       = 3.5; // Chiều cao vành miệng

    union() {
        // Chén cầu lõm ngàm đàn hồi đầu dưới
        Snap_Ball_Socket();

        // Đĩa đỡ lò xo có vành gờ chén ôm khít lò xo
        translate([0, 0, 8.0]) {
            difference() {
                union() {
                    // Bản đĩa chính D=30mm
                    translate([0, 0, -collar_thick])
                        cylinder(d=collar_od, h=collar_thick);
                    // Vành chén ôm ngoài lò xo
                    cylinder(d=collar_od, h=cup_rim_h);
                }
                // Hốc lõm chứa lò xo D=27.6mm sâu 2.8mm
                translate([0, 0, -0.1])
                    cylinder(d=27.6, h=cup_rim_h + 1.0);
            }
        }

        // Thân vỏ xilanh rỗng lòng bậc 2 tầng giảm ma sát
        difference() {
            union() {
                translate([0, 0, 8.0])
                    cylinder(d=cylinder_od, h=cyl_h);
                translate([0, 0, 8.0])
                    cylinder(d1=15.0, d2=cylinder_od, h=3.0);
            }
            
            // Tầng 1: Lòng khoang rộng D=9.4mm bên trong (mũ ngàm trượt êm không chạm thành)
            translate([0, 0, 7.9])
                cylinder(d=chamber_d, h=cyl_h - lip_h + 0.1);
            
            // Tầng 2: Vành miệng hẹp D=8.2mm ở đỉnh miệng để hãm mũ ngàm
            translate([0, 0, 8.0 + cyl_h - lip_h])
                cylinder(d=mouth_lip_d, h=lip_h + 0.1);

            // Vát mép miệng xilanh góc 45 độ dẫn hướng ép ngàm
            translate([0, 0, 8.0 + cyl_h - 1.5])
                cylinder(d1=mouth_lip_d, d2=mouth_lip_d + 1.8, h=1.6);

            // Cửa sổ hông thoát khí & tra dầu bôi trơn
            for (wz = [18.0 : 12.0 : 8.0 + cyl_h - 8.0]) {
                translate([0, 0, wz])
                    cube([cylinder_od + 4.0, 4.0, 5.0], center=true);
            }
        }
    }
}

// [2] CHI TIẾT 2: TY TRỤC PITON VÀ ĐĨA CHÉN ÔM LÒ XO TRÊN CÓ MŨ NGÀM TỰ KHÓA
module Shock_Upper_Piston(total_L = piston_total_L) {
    rod_h      = total_L * 0.58;
    rod_d      = 7.6;  // Thân ty D=7.6mm (khe hở 0.3mm với miệng 8.2mm trượt êm ru)
    barb_d     = 8.8;  // Mũ ngàm tự khóa D=8.8mm
    barb_L     = 4.5;  // Chiều cao mũ nón
    slot_w     = 1.2;  // Rãnh xẻ chữ thập (+) đàn hồi
    slot_depth = 16.0; // Chiều sâu xẻ rãnh đàn hồi

    union() {
        // Chén cầu lõm ngàm đàn hồi đầu trên
        Snap_Ball_Socket();

        // Đĩa đỡ lò xo có vành gờ chén ôm khít lò xo
        translate([0, 0, 8.0]) {
            difference() {
                union() {
                    translate([0, 0, -collar_thick])
                        cylinder(d=collar_od, h=collar_thick);
                    cylinder(d=collar_od, h=cup_rim_h);
                }
                translate([0, 0, -0.1])
                    cylinder(d=27.6, h=cup_rim_h + 1.0);
            }
        }

        // Cụm ty trục piton có mũ ngàm đàn hồi xẻ rãnh chữ thập
        difference() {
            union() {
                // Thân ty trượt D=7.6mm
                translate([0, 0, 8.0])
                    cylinder(d=rod_d, h=rod_h - barb_L);

                // Mũ nón ngàm tự khóa D=8.8mm vát chóp 45 độ
                translate([0, 0, 8.0 + rod_h - barb_L]) {
                    cylinder(d=barb_d, h=1.0);
                    translate([0, 0, 1.0])
                        cylinder(d1=barb_d, d2=5.6, h=barb_L - 1.0);
                }

                // Gờ gia cố chân ty
                translate([0, 0, 8.0])
                    cylinder(d1=13.0, d2=rod_d, h=3.0);
            }

            // Rãnh xẻ chữ thập (+) đàn hồi ở đầu ty để co giãn khi ấn vào
            translate([0, 0, 8.0 + rod_h - slot_depth/2 + 0.1]) {
                cube([slot_w, barb_d + 2.0, slot_depth], center=true);
                cube([barb_d + 2.0, slot_w, slot_depth], center=true);
            }
        }
    }
}

// [3] CHI TIẾT 3: LÒ XO DÀY HEAVY-DUTY D=6.8mm NÉT MỊN CÓ 2 ĐẦU MÀI PHẲNG TỊT 100%
module Heavy_Duty_Coil_Spring(total_L = piston_total_L) {
    spring_start_z = 8.0;
    spring_end_z   = total_L - 8.0;
    spring_height  = spring_end_z - spring_start_z;
    turns          = 5.0;
    steps          = 128; // Tăng bước chia xoắn lên 128 giúp đường cong lò xo tròn nét mịn
    r_mean         = 10.2; // Bán kính vòng lò xo tối ưu (lòng trong D=13.6mm chống cạ thành xilanh)
    wire_d         = 6.8;  // Dây lò xo tăng độ dày lên 6.8mm cực kỳ cứng cáp và sắc nét

    difference() {
        union() {
            // Vòng đế tròn phẳng dưới đáy
            translate([0, 0, spring_start_z + wire_d/2])
                rotate_extrude($fn=64)
                translate([r_mean, 0, 0])
                circle(d=wire_d, $fn=32);

            // Các vòng xoắn thân chính
            for (i = [0 : steps - 1]) {
                t1 = i / steps;
                t2 = (i + 1) / steps;
                z1 = spring_start_z + wire_d/2 + t1 * (spring_height - wire_d);
                z2 = spring_start_z + wire_d/2 + t2 * (spring_height - wire_d);
                a1 = t1 * turns * 360;
                a2 = t2 * turns * 360;
                hull() {
                    translate([r_mean * cos(a1), r_mean * sin(a1), z1]) sphere(d=wire_d, $fn=24);
                    translate([r_mean * cos(a2), r_mean * sin(a2), z2]) sphere(d=wire_d, $fn=24);
                }
            }

            // Vòng đỉnh tròn phẳng trên cùng
            translate([0, 0, spring_end_z - wire_d/2])
                rotate_extrude($fn=64)
                translate([r_mean, 0, 0])
                circle(d=wire_d, $fn=32);
        }

        // Cắt mài phẳng tịt 100% mặt đáy tại Z = spring_start_z (bám bàn in hoàn hảo)
        translate([0, 0, spring_start_z - 15.0])
            cube([60.0, 60.0, 30.0], center=true);

        // Cắt mài phẳng tịt 100% mặt đỉnh tại Z = spring_end_z (tì khít tuyệt đối vào chén phuộc)
        translate([0, 0, spring_end_z + 15.0])
            cube([60.0, 60.0, 30.0], center=true);
    }
}

// ==============================================================================
// XUẤT RA BÀN IN Z = 0
// ==============================================================================
if (part_select == "both") {
    translate([-18.0, 0, 7.0])
        Shock_Lower_Cylinder();

    translate([18.0, 0, 7.0])
        Shock_Upper_Piston();
} else if (part_select == "spring") {
    Heavy_Duty_Coil_Spring();
} else if (part_select == "all") {
    translate([-28.0, 0, 7.0]) Shock_Lower_Cylinder();
    translate([0, 0, 7.0])      Shock_Upper_Piston();
    translate([28.0, 0, -8.0])  Heavy_Duty_Coil_Spring();
}
