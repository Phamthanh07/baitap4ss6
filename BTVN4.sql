
/* 
   PHÂN TÍCH HIỆU NĂNG:
   
   1. Cách 1 (Lọc trễ - Bad Practice): 
      - Hệ thống phải nạp toàn bộ hàng triệu đơn hàng (bao gồm cả đơn Hủy/Lỗi) vào RAM.
      - CPU phải thực hiện gom nhóm (Group By) trên một khối lượng dữ liệu khổng lồ không cần thiết.
      - Sau đó mới dùng HAVING để vứt bỏ các đơn không thành công. 
      => Gây lãng phí tài nguyên RAM/CPU cực lớn, có thể làm treo máy chủ Database.

   2. Cách 2 (Lọc sớm - Clean Code/High Performance):
      - Mệnh đề WHERE loại bỏ các đơn Hủy/Lỗi ngay từ đầu.
      - Hệ thống chỉ phải nạp và xử lý các đơn 'COMPLETED' (số lượng ít hơn nhiều).
      - CPU thực hiện gom nhóm trên tập dữ liệu đã tinh lọc.
      => Tốc độ truy vấn nhanh hơn, tiết kiệm tài nguyên và bảo vệ máy chủ.
*/

/* 
   Yêu cầu nghiệp vụ:
   1. Trạng thái: 'COMPLETED'.
   2. Số lượng đơn đặt: >= 50.
   3. Doanh thu trung bình mỗi đơn: > 3.000.000 VNĐ.
*/

-- Sử dụng Cách 2 để tối ưu hiệu năng:
SELECT 
    hotel_id,
    COUNT(booking_id) AS total_completed_bookings,
    AVG(total_price) AS average_revenue
FROM 
    Bookings
WHERE 
    -- Lọc sớm: Loại bỏ các đơn không thành công trước khi gom nhóm
    status = 'COMPLETED'
GROUP BY 
    hotel_id
HAVING 
    -- Lọc trên kết quả tổng hợp
    COUNT(booking_id) >= 50 
    AND AVG(total_price) > 3000000;

/*
   - Nguyên tắc vàng trong SQL: "Filter as early as possible" (Lọc dữ liệu càng sớm càng tốt).
   - Chỉ đưa vào HAVING những điều kiện liên quan đến hàm tổng hợp (COUNT, AVG, SUM...).
   - Các điều kiện về thuộc tính dòng (status, category,...) luôn luôn nên nằm ở WHERE.
*/

-- KẾT THÚC BÀI LÀM