# 🚜 BỘ THIẾT KẾ ROBOT UGV ĐA TẢI TRỌNG (UGV ROBOT PLATFORMS)

Kho lưu trữ thiết kế phần cứng, mô hình 3D (OpenSCAD, STL, 3MF) và tài liệu kỹ thuật cho 3 nền tảng xe tự hành mặt đất (**Unmanned Ground Vehicle - UGV**) theo các dải công suất và tải trọng khác nhau.

---

## 📂 CẤU TRÚC KHO LƯU TRỮ (REPOSITORY STRUCTURE)

```text
ugv/
├── 📁 ugv_jga25/               # UGV Cỡ Nhỏ (Động cơ JGA25 - 12V/24V)
│   ├── 📁 SCAD/                # Mã nguồn mô hình OpenSCAD
│   ├── 📁 STL/                 # File STL sẵn sàng in 3D
│   ├── 📁 3MF/                 # File 3MF tối ưu slicer
│   └── 📄 README.md            # Hướng dẫn in 3D & lắp ráp chi tiết
│
├── 📁 ugv_dc_150w/             # UGV Cỡ Trung (Động cơ DC ATS 150W cốt 12mm)
│   ├── 📁 SCAD/                # Bản vẽ 3D động cơ & Gá đỡ bắt đế
│   ├── 📁 images/              # Hình ảnh thực tế & kích thước kỹ thuật
│   └── 📄 THONG_SO_DONG_CO_ATS_150W.md
│
└── 📁 ugv_my1016z_250w/        # UGV Cỡ Lớn (Động cơ DC MY1016Z 250W - Nhông 9 răng)
    ├── 📁 SCAD/                # Bản vẽ 3D động cơ MY1016Z
    ├── 📁 images/              # Kích thước, sơ đồ chân & nhông xích
    ├── 📄 README.md            # Thông số vận hành & tỉ số truyền
    └── 📄 THONG_SO_DONG_CO_MY1016Z.md
```

---

## ⚡ TỔNG QUAN CÁC NỀN TẢNG (PLATFORM OVERVIEW)

| Thông Số / Nền Tảng | 🤖 1. `ugv_jga25` | 🚜 2. `ugv_dc_150w` | 🚛 3. `ugv_my1016z_250w` |
| :--- | :--- | :--- | :--- |
| **Phân khúc tải trọng** | **Tải nhẹ** ($< 8\text{ kg}$) | **Tải trung bình** ($15 - 30\text{ kg}$) | **Tải nặng** ($40 - 80\text{ kg}$) |
| **Động cơ sử dụng** | GA25 / JGA25 (DC 12V/24V) | ATS DC 150W (Cốt 12mm D-cut) | MY1016Z 250W (Nhông 9 răng xích 410) |
| **Hệ thống treo** | Độc lập 4 bánh khớp cầu Snap-fit + Lò xo nhún D=6.8mm | Khung gầm tải trung / Bắt đế cứng vững | Khung gầm tải nặng / Truyền động xích |
| **Cơ chế lắp ráp** | Không dùng bu lông (Zero-Bolts / Zero-Screws) | Bắt ốc chân đế ren M6 / M8 | Gá chân đế 4 lỗ M6 cố định |
| **Đặc điểm nổi bật** | In 3D 100%, lắp ráp bằng tay trong 1 phút | Lực kéo khỏe, cốt trục 12mm bền bỉ | Mô-men xoắn cực lớn, leo dốc & vượt địa hình |

---

## 🛠️ CHI TIẾT CÁC DỰ ÁN

### 1. [ugv_jga25](./ugv_jga25/) - Robot UGV In 3D Toàn Diện Không Ốc Vít
- **Khung gầm liền khối:** Thân xe nguyên khối tích hợp sẵn họng trượt khớp cầu và khoang chứa mạch điều khiển/pin.
- **Hệ treo khớp cầu đàn hồi:** Gá đỡ động cơ góc nghiêng $30^\circ$, chén cầu đàn hồi Snap-fit tháo lắp trong 1 giây.
- **Bộ giảm xóc cải tiến:** Ty piton tự khóa, đĩa chặn ôm lò xo $D=30\text{ mm}$ cùng lò xo sợi dày $D=6.8\text{ mm}$ nét mịn.
- **Bánh xe tổ ong:** Bánh xe Airless đàn hồi, gờ gai bám đường chống trượt.

### 2. [ugv_dc_150w](./ugv_dc_150w/) - Động Cơ ATS 150W & Gá Đỡ Bắt Đế
- **Mô hình 3D OpenSCAD:** Chi tiết vỏ động cơ, hộp số giảm tốc vuông góc, cốt ra $\varnothing 12\text{ mm}$.
- **Gá đỡ bắt đế:** Thiết kế tấm gá chịu lực dày $4\text{ mm} - 6\text{ mm}$, tối ưu trọng tâm cho khung xe cỡ trung.

### 3. [ugv_my1016z_250w](./ugv_my1016z_250w/) - Động Cơ Tải Nặng MY1016Z 250W
- **Truyền động:** Nhông xích chuẩn xe đạp điện (9 răng bước xích $1/2"$), tích hợp sẵn chân đế bắt ốc 4 điểm.
- **Khả năng kéo:** Tải trọng kéo lên tới $80\text{ kg}$, phù hợp cho các bài toán AGV vận chuyển kho bãi hoặc robot cứu hộ.

---

## 🚀 HƯỚNG DẪN SỬ DỤNG
1. **Mở và tùy biến mô hình:** Sử dụng phần mềm [OpenSCAD](https://openscad.org/) để mở các file trong thư mục `SCAD/` của từng dự án.
2. **In 3D:** Sử dụng các file `.stl` hoặc `.3mf` (khuyến nghị dùng Bambu Studio / OrcaSlicer / Cura / PrusaSlicer).
   - Chất liệu khuyến nghị: **PETG / PLA+ / ABS / TPU**.
   - Độ dày thành (Walls): $\ge 4$ layers. Infill: $30\% - 50\%$ Gyroid.

---
*Bản quyền thiết kế © 2026 - Tác giả: datleminh5173-sys*
