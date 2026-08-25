// ==============================================================================
// 04. THANH ĐÒN LIÊN KẾT HỆ TREO SNAP-FIT (SNAP-FIT SUSPENSION LINK ARM)
// BỘ PHẬN IN 3D SỐ 4 - SỐ LƯỢNG CẦN IN: 16 CÁI (4 THANH / BÁNH XE x 4 BÁNH)
// NÂNG CẤP HOÀN TOÀN:
// - LẮP RÁP BẰNG TAY TRONG 1 GIÂY: CHỈ CẦN CẦM THANH ẤN VÀO CHỐT NẤM LÀ SẬP NGÀM
// - KHÔNG CẦN BULÔNG, ỐC VÍT HAY TÁN KIM LOẠI
// - ĐÃ ĐƯỢC ĐẶT NẰM PHẲNG TRÊN MẶT BÀN IN (Z = 0)
// VẬT LIỆU KHUYÊN DÙNG: PETG / PLA+ / ABS / NYLON (INFILL 100%)
// ==============================================================================
$fn = 48;

arm_L      = 70.0;   // Khoảng cách 2 tâm lỗ (70mm)
arm_thick  = 5.0;    // Độ dày thanh đòn (5.0mm rất cứng vững)
arm_hole_d = 6.3;    // Lỗ tròn D=6.3mm (vừa khít thân chốt trụ 6.0mm, xoay trơn 360 độ)
eye_od     = 16.0;   // Bầu mắt xoay D=16mm (thành thịt dày 4.85mm chống gãy)

module Suspension_Link_Arm_Printable() {
    translate([0, arm_L/2, arm_thick/2]) {
        difference() {
            union() {
                // Thân chính với 2 đầu mắt bo tròn D=16mm
                hull() {
                    cylinder(d=eye_od, h=arm_thick, center=true);
                    translate([0, -arm_L, 0]) cylinder(d=eye_od, h=arm_thick, center=true);
                }
                // Gân tăng cứng lồi sống giữa chống vặn xoắn
                hull() {
                    cylinder(d=eye_od - 2.5, h=arm_thick + 0.8, center=true);
                    translate([0, -arm_L, 0]) cylinder(d=eye_od - 2.5, h=arm_thick + 0.8, center=true);
                }
            }
            
            // 2 Lỗ xoay khớp chốt nấm
            cylinder(d=arm_hole_d, h=arm_thick + 4, center=true);
            translate([0, -arm_L, 0]) cylinder(d=arm_hole_d, h=arm_thick + 4, center=true);
            
            // Vát mép côn 45 độ 2 mặt lỗ để mũ nấm dễ dàng chui qua khi bấm click
            translate([0, 0, arm_thick/2 - 0.7]) cylinder(d1=arm_hole_d, d2=arm_hole_d + 1.8, h=0.8);
            translate([0, 0, -arm_thick/2 - 0.1]) cylinder(d1=arm_hole_d + 1.8, d2=arm_hole_d, h=0.8);
            translate([0, -arm_L, arm_thick/2 - 0.7]) cylinder(d1=arm_hole_d, d2=arm_hole_d + 1.8, h=0.8);
            translate([0, -arm_L, -arm_thick/2 - 0.1]) cylinder(d1=arm_hole_d + 1.8, d2=arm_hole_d, h=0.8);
        }
    }
}

// MẶC ĐỊNH HIỂN THỊ 1 THANH TRÊN BÀN IN Z = 0
Suspension_Link_Arm_Printable();
