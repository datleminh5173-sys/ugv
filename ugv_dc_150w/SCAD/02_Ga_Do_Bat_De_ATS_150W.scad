// ==============================================================================
// 02. GÁ ĐỠ ĐỘNG CƠ ATS 150W HEAVY-DUTY (KIỂU ÔM THÂN JGA25 - BẢN GÁ Ở TRÊN)
// PHỤ KIỆN GÁ ĐỘNG CƠ LÊN KHUNG XE UGV / BÀN MÁY TẢI NẶNG
// ==============================================================================
// MÀU SẮC: MÀU XANH LÁ CÂY IN 3D (VIBRANT GREEN)
// ==============================================================================

$fn = 60;

use <01_Dong_Co_ATS_150W.scad>

// Tùy chọn hiển thị
SHOW_MOTOR_PREVIEW = true; // Bật/tắt hiển thị động cơ lắp vào gá

// Module gá đỡ độc lập
module Ga_Do_ATS_150W_Printable() {
    Part_Ga_Do_Kieu_JGA25();
}

// 1. Hiển thị gá đỡ
Ga_Do_ATS_150W_Printable();

// 2. Hiển thị động cơ và ốc đi kèm để kiểm tra độ khớp
if (SHOW_MOTOR_PREVIEW) {
    Part_Dong_Co_150W();
    Part_Bu_Long_M5();
    Part_Puly_Dai_3M();
}
