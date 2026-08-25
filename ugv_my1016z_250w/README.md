# Dự Án UGV - Động Cơ Giảm Tốc DC MY1016Z / MY1016Z2 / MY1016Z3

Dự án thiết kế mô hình 3D OpenSCAD và tích hợp cụm dẫn động động cơ giảm tốc công suất cao **MY1016Z / MY1016Z2 / MY1016Z3** cho xe tự hành UGV / AGV / Robot địa hình.

Nguồn thông số chính hãng: **[TYHE Motors (www.tyhemotors.com/my1016z)](https://www.tyhemotors.com/my1016z)** & Bản vẽ thiết kế CAD 2D/3D.

## 1. Thư Viện Bản Vẽ Kỹ Thuật & Ảnh Thực Tế

### A. Ảnh & Bản vẽ từ TYHE Motors (`images/tyhe/`):
- [Ảnh 1: Góc nghiêng mặt trước](images/tyhe/TYHE_MY1016Z_01_Front_Angle.jpg)
- [Ảnh 2: Nhìn ngang thân & đế](images/tyhe/TYHE_MY1016Z_02_Side_View.jpg)
- [Ảnh 3: Nắp tản nhiệt sau & dây nguồn](images/tyhe/TYHE_MY1016Z_03_Rear_Angle.jpg)
- [Ảnh 4: Trục ra & nhông xích 9 răng](images/tyhe/TYHE_MY1016Z_04_Shaft_CloseUp.jpg)
- [Ảnh 5: Nhìn từ trên xuống](images/tyhe/TYHE_MY1016Z_05_Top_View.jpg)
- [Ảnh 6: Mặt đáy chân đế bắt sàn](images/tyhe/TYHE_MY1016Z_06_Bottom_Base.jpg)
- [Bản vẽ 7: Kích thước hình học TYHE](images/tyhe/TYHE_MY1016Z_07_Dimensional_Drawing.png)
- [Bản vẽ 8: Đặc tính động cơ & hộp số](images/tyhe/TYHE_MY1016Z_08_Motor_Drawing_Specs.png)

### B. Bản vẽ CAD 2D & Ảnh thực tế (`images/`):
- [Bản vẽ 1: Hình chiếu cạnh & Chân đế](images/04_Ban_Ve_Kich_Thuoc_Canh_Va_Chan_De.png)
- [Bản vẽ 2: Mặt trước hộp số & Tâm lỗ](images/05_Ban_Ve_Mat_Truoc_Va_Tam_Lo.png)
- [Bản vẽ 3: CAD chi tiết góc nghiêng 15°](images/08_Ban_Ve_CAD_Chi_Tiet_Goc_Nghieng_15Do.png)
- [Ảnh thực tế 1: Động cơ & nhông 9T](images/06_Anh_Thuc_Te_Goc_Nghieng_MY1016Z.png)
- [Ảnh thực tế 2: Tem nhãn thông số](images/07_Anh_Thuc_Te_Nhan_Thong_So.png)

## 2. Bảng Tóm Tắt Thông Số Kỹ Thuật

- **Điện áp**: 12V / 24V DC
- **Công suất**: 250W (thân dài $102\text{ mm}$, peak $300\text{W}$) / 350W (thân dài $117\text{ mm}$)
- **Tốc độ động cơ**: $2700 - 3300\text{ RPM}$
- **Tỷ số giảm tốc**: $9.78:1$ (hoặc $9:1$) $\rightarrow$ **Tốc độ đầu ra**: $\approx 300 - 330\text{ RPM}$
- **Mô-men xoắn**: $5.0 - 12.5\text{ N.m}$ ($50\text{ kg.cm}$)
- **Vật liệu**: Vỏ hợp kim kẽm (Zinc alloy), bánh răng thép tôi cứng (Steel gear), vòng bi cầu (Ball bearing)
- **Độ rơ bánh răng (Backlash)**: $\le 2^\circ$
- **Lực hướng kính / dọc trục tối đa**: $\le 5\text{ kgf}$ (Radial) / $\le 10\text{ kgf}$ (Axial) / $\le 20\text{ kgf}$ (Press)
- **Truyền động**: Nhông xích 9 răng, bước xích $12.7\text{ mm}$ (chuẩn xích #410 / xích xe đạp), đường kính con lăn $\varnothing 7.95\text{ mm}$
- **Khoảng cách tâm 2 trục**: $39\text{ mm}$ (tâm motor $\leftrightarrow$ tâm trục ra)
- **Đường kính thân motor**: $\varnothing 101\text{ mm}$
- **Chiều cao tâm trục**: $81 - 82\text{ mm}$ (tính từ đáy chân đế)
- **Khoảng cách lỗ chân đế**: $95 \pm 0.11\text{ mm} \times 42 \pm 0.08\text{ mm}$ (4 lỗ $\varnothing 6.5\text{ mm}$)

Chi tiết thông số xem tại: [THONG_SO_DONG_CO_MY1016Z.md](THONG_SO_DONG_CO_MY1016Z.md)
