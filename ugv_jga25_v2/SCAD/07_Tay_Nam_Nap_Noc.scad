// ==============================================================================
// 07. TAY NẮM MÓC MỞ NẮP NÓC XE (ORANGE ROOF CANOPY PULL HANDLE)
// BỘ PHẬN IN 3D SỐ 7 - SỐ LƯỢNG CẦN IN: 1 CÁI
// ĐÃ ĐƯỢC ĐẶT NẰM PHẲNG TRÊN MẶT BÀN IN (Z = 0)
// VẬT LIỆU KHUYÊN DÙNG: PLA / PETG MÀU CAM HOẶC ĐỎ NỔI BẬT
// ==============================================================================
$fn = 36;

module Roof_Handle_Printable() {
    translate([0, 0, 2.5]) {
        difference() {
            hull() {
                cube([18.0, 56.0, 5.0], center = true);
                translate([4.0, 0, 4.0]) cube([8.0, 42.0, 2.0], center = true);
            }
            translate([1.0, 0, 1.0]) cube([8.0, 36.0, 8.0], center = true);
            // 2 Lỗ ốc chìm M2.5 để bắt cố định vào nắp
            translate([0, -18.0, 0]) cylinder(d=2.8, h=10, center=true);
            translate([0, 18.0, 0]) cylinder(d=2.8, h=10, center=true);
        }
    }
}

Roof_Handle_Printable();
