// ==============================================================================
// 08. CHỐT CÀI XOAY ĐÀN HỒI XẺ RÃNH CHỮ THẬP (CROSS-SLOTTED ROTARY SNAP-PIN)
// BỘ PHẬN IN 3D SỐ 8 - DÙNG CHO CÁC KHỚP XOAY HỆ TREO, BẢN LỀ, PHUỘC NHÚN
// NGUYÊN LÝ:
// 1. THÂN TRỤ TRÒN ĐÚT VÀO LỖ ĐỂ XOAY TỰ DO 360 ĐỘ
// 2. MŨ NẤM CÓ GỜ KHÓA VÀ ĐẦU VÁT CÔN DẪN HƯỚNG ĐỂ ẤN VÀO NHẸ NHÀNG
// 3. XẺ RÃNH CHỮ THẬP (+) TẠO 4 CÁNH ĐÀN HỒI: KHI ẤN VÀO BÓP CỤP LẠI,
//    KHI QUA HẾT LỖ TỰ ĐỘNG BẬT BUNG XÒE RA -> VƯỚNG MŨ KHÓA CHỐNG TUỘT 100%!
// KHÔNG CẦN DÙNG BULÔNG, ỐC VÍT HAY TÁN KIM LOẠI
// VẬT LIỆU TỐT NHẤT: PETG / ABS / NYLON (CÓ ĐỘ DẺO ĐÀN HỒI CAO)
// ==============================================================================
$fn = 48;

module Cross_Slotted_Snap_Pin(
    pin_d     = 6.0,   // Đường kính thân chốt xoay (D=6mm)
    grip_L    = 8.5,   // Chiều dài kẹp qua 2 vách lỗ xoay
    cap_d     = 7.8,   // Đường kính mũ nấm khóa (phình to hơn lỗ 1.8mm)
    cap_L     = 4.0,   // Chiều cao mũ nấm
    slot_w    = 1.2,   // Chiều rộng rãnh xẻ chữ thập (+)
    head_d    = 11.0,  // Đường kính gờ chặn đuôi chốt
    head_t    = 2.5    // Độ dày gờ chặn đuôi
) {
    difference() {
        union() {
            // [1] Gờ chặn đuôi (chống chốt bị lọt qua lỗ)
            cylinder(d = head_d, h = head_t);

            // [2] Thân trụ xoay trơn mượt
            translate([0, 0, head_t])
                cylinder(d = pin_d, h = grip_L);

            // [3] Mũ nấm khóa đầu chốt (Retaining Barb Cap)
            translate([0, 0, head_t + grip_L]) {
                // Gờ khóa vuông giữ chặt mép lỗ
                cylinder(d = cap_d, h = 0.8);
                // Nón vát côn 40 độ dẫn hướng khi đút vào lỗ
                translate([0, 0, 0.8])
                    cylinder(d1 = cap_d, d2 = pin_d - 1.8, h = cap_L - 0.8);
            }
        }

        // [4] Khoét 2 rãnh xẻ chữ thập vuông góc (+) tạo 4 cánh đàn hồi
        translate([0, 0, head_t + grip_L * 0.4 + (grip_L * 0.6 + cap_L)/2]) {
            cube([slot_w, cap_d + 4.0, grip_L * 0.6 + cap_L + 1.0], center = true);
            cube([cap_d + 4.0, slot_w, grip_L * 0.6 + cap_L + 1.0], center = true);
        }

        // Lỗ tròn giảm ứng suất tập trung ở gốc rãnh chữ thập (chống nứt gãy)
        translate([0, 0, head_t + grip_L * 0.4])
            sphere(d = slot_w * 1.5);
    }
}

print_mode = "batch"; // "single" = Xem/in 1 chốt, "batch" = In cả cụm 8 chốt

if (print_mode == "single") {
    Cross_Slotted_Snap_Pin();
} else {
    // XẾP 8 CHỐT CÀI TRÊN BÀN IN Z = 0 ĐỂ IN 1 LẦN CHO CẢ 4 BÁNH XE
    for (row = [0, 1]) {
        for (col = [0, 1, 2, 3]) {
            translate([col * 16.0 - 24.0, row * 16.0 - 8.0, 0])
                Cross_Slotted_Snap_Pin();
        }
    }
}
