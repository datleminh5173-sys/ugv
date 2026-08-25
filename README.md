# 🚜 BỘ THIẾT KẾ ROBOT UGV ĐA TẢI TRỌNG (UGV ROBOT PLATFORMS)

Kho lưu trữ thiết kế phần cứng, mô hình 3D (OpenSCAD, STL, 3MF) và tài liệu kỹ thuật cho các nền tảng xe tự hành mặt đất (**Unmanned Ground Vehicle - UGV**).

---

## 📂 CẤU TRÚC KHO LƯU TRỮ (REPOSITORY STRUCTURE)

```text
ugv/
├── 📁 ugv_jga25_v1/            # UGV JGA25 Bản V1 (Khung Liền Khối - In máy khổ lớn)
│   ├── 📁 SCAD/                # Mã nguồn mô hình OpenSCAD
│   ├── 📁 STL/                 # File STL sẵn sàng in 3D
│   ├── 📁 3MF/                 # File 3MF tối ưu slicer
│   └── 📄 README.md
│
├── 📁 ugv_jga25_v2/            # UGV JGA25 Bản V2 (Chia 5 Module ghép mộng mang cá - In vừa bàn 320x390)
│   ├── 📁 SCAD/                # File lắp ráp tổng thể V2 & chi tiết
│   ├── 📁 STL/                 # File STL in 3D
│   ├── 📁 3MF/                 # File 3MF tối ưu slicer
│   └── 📄 README.md
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

## ⚡ SO SÁNH CÁC NỀN TẢNG (PLATFORM COMPARISON)

| Nền Tảng | Động Cơ | Tải Trọng | Đặc Điểm Thân Xe | Kích Thước Khung Xe | Bàn In Phù Hợp |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`ugv_jga25_v1`** | JGA25 (12V/24V) | $< 8\text{ kg}$ | **Liền khối nguyên bản** (Zero-Bolts) | $364 \times 320 \times 125\text{ mm}$ | Khổ lớn $\ge 400\text{mm}$ |
| **`ugv_jga25_v2`** | JGA25 (12V/24V) | $< 8\text{ kg}$ | **Chia 5 Module** (Mộng mang cá + Ốc M3) | Module lớn nhất $350 \times 140\text{ mm}$ | **Bàn in $320 \times 390\text{mm}$** hoặc $256\text{mm}$ |
| **`ugv_dc_150w`** | ATS 150W (Cốt 12mm) | $15 - 30\text{ kg}$ | Bắt đế cứng vững chịu lực cao | Thiết kế theo khung gầm xe tải trung | Mọi máy in 3D |
| **`ugv_my1016z_250w`** | MY1016Z 250W | $40 - 80\text{ kg}$ | Truyền động nhông xích 410 tải nặng | Thiết kế theo khung gầm xe tải nặng | Mọi máy in 3D |

---
*Bản quyền thiết kế © 2026 - Tác giả: datleminh5173-sys*
