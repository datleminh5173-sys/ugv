// ==============================================================================
// 05. BÁNH XE LỐP TỔ ONG ĐỊA HÌNH KHÔNG HƠI (HONEYCOMB AIRLESS WHEEL D=88mm)
// BỘ PHẬN IN 3D SỐ 5 - SỐ LƯỢNG CẦN IN: 4 CÁI
// ĐÃ ĐƯỢC ĐẶT NẰM PHẲNG TRÊN MẶT BÀN IN (Z = 0)
// VẬT LIỆU TỐI ƯU NHẤT: NHỰA DẺO TPU (SHORE 95A HOẶC 85A)
// ==============================================================================
$fn = 36;

module Honeycomb_Airless_Wheel_Printable(OD = 88.0, width = 32.0) {
    rim_d       = 46.0;
    tire_od     = OD;
    n_cells     = 18;
    
    difference() {
        union() {
            // Thân bánh xe & Mâm đáy trong
            cylinder(d=tire_od, h=width);
            cylinder(d=rim_d + 3.0, h=3.0);
            translate([0, 0, width - 3.0])
                cylinder(d=rim_d + 3.0, h=3.0);

            // Gai địa hình ngoài lốp
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

        // Lòng mâm & Lỗ khớp lục giác 12.3mm (chuẩn RC Hex 12mm)
        translate([0, 0, -1])
            cylinder(r=(12.3 / cos(30)) / 2, h=7.0, $fn=6);
        translate([0, 0, -2])
            cylinder(d=4.5, h=width + 4);
        translate([0, 0, width - 6.0])
            cylinder(d=11.0, h=7.0);

        // 6 Lỗ nan hoa mâm xe
        for (ang = [0 : 60 : 300]) {
            rotate([0, 0, ang])
                translate([14.0, 0, 7.0])
                cylinder(d=6.5, h=width - 14.0);
        }

        // Rãnh giữa lốp
        translate([0, 0, width/2])
            difference() {
                cylinder(d=tire_od + 10, h=4.0, center=true);
                cylinder(d=tire_od - 4.0, h=5.0, center=true);
            }

        // Khía gai lốp
        for (ang = [0 : 10 : 350]) {
            rotate([0, 0, ang + 5])
                translate([tire_od/2, 0, 7.5])
                cube([4.0, 2.0, 10.0], center=true);
            rotate([0, 0, ang])
                translate([tire_od/2, 0, width - 7.5])
                cube([4.0, 2.0, 10.0], center=true);
        }

        // Vòng lỗ tổ ong trong (18 lỗ lục giác D=6.4mm)
        for (i = [0 : n_cells - 1]) {
            rotate([0, 0, i * (360 / n_cells)])
                translate([28.0, 0, -1])
                rotate([0, 0, 30])
                cylinder(r=(6.4 / cos(30)) / 2, h=width + 2, $fn=6);
        }

        // Vòng lỗ tổ ong ngoài (18 lỗ lục giác D=7.8mm)
        for (i = [0 : n_cells - 1]) {
            rotate([0, 0, i * (360 / n_cells) + 10.0])
                translate([35.8, 0, -1])
                rotate([0, 0, 30])
                cylinder(r=(7.8 / cos(30)) / 2, h=width + 2, $fn=6);
        }
    }
}

// ĐẶT NẰM TRÊN MẶT BÀN IN Z = 0
Honeycomb_Airless_Wheel_Printable(OD = 88.0, width = 32.0);
