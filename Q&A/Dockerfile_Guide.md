# Dockerfile là gì?

## 1. Giới thiệu về Dockerfile
**Dockerfile** là một tệp văn bản chứa tập hợp các lệnh cần thiết để xây dựng một **Docker image**. Nó giúp tự động hóa quá trình tạo container bằng cách chỉ định từng bước cài đặt, thiết lập môi trường và chạy ứng dụng.

Dockerfile hoạt động như một tập lệnh hướng dẫn để Docker biết cách tạo ra một **image** một cách nhất quán và có thể tái sử dụng.

---

## 2. Cách hoạt động của Dockerfile
Dockerfile được sử dụng để xây dựng một **Docker image** thông qua lệnh:

```sh
docker build -t my-image .
```

Lệnh này sẽ đọc các hướng dẫn trong **Dockerfile**, thực thi từng dòng lệnh, và tạo ra một image hoàn chỉnh.

---

## 3. Cấu trúc cơ bản của Dockerfile

### 3.1. FROM - Chỉ định Image nền
```dockerfile
FROM ubuntu:latest
```
- **FROM** là lệnh bắt buộc, xác định image nền sẽ sử dụng.
- Ví dụ: Sử dụng Ubuntu mới nhất làm image gốc.

### 3.2. RUN - Thực thi lệnh trong quá trình build
```dockerfile
RUN apt-get update && apt-get install -y curl
```
- **RUN** cho phép thực thi lệnh trong quá trình xây dựng image.
- Ví dụ: Cập nhật danh sách package và cài đặt `curl`.

### 3.3. COPY - Sao chép file từ máy host vào container
```dockerfile
COPY app.py /app/app.py
```
- **COPY** sao chép tệp hoặc thư mục từ máy tính host vào trong container.
- Ví dụ: Sao chép `app.py` vào thư mục `/app/` trong container.

### 3.4. WORKDIR - Thiết lập thư mục làm việc
```dockerfile
WORKDIR /app
```
- **WORKDIR** đặt thư mục làm việc mặc định khi container chạy.
- Ví dụ: Đặt thư mục `/app` làm thư mục chính của ứng dụng.

### 3.5. CMD - Thiết lập lệnh chạy khi container khởi động
```dockerfile
CMD ["python", "app.py"]
```
- **CMD** chỉ định lệnh mặc định để chạy khi container khởi động.
- Dùng kiểu **array** (`["lệnh", "tham số"]`) giúp tránh vấn đề với shell.

### 3.6. ENTRYPOINT - Định nghĩa lệnh chính của container
```dockerfile
ENTRYPOINT ["python", "app.py"]
```
- **ENTRYPOINT** giống `CMD`, nhưng không thể bị ghi đè khi chạy container bằng `docker run`.
- Dùng khi container chỉ chạy một ứng dụng cụ thể.

### 3.7. EXPOSE - Mở cổng
```dockerfile
EXPOSE 5000
```
- **EXPOSE** chỉ định cổng mà container sẽ lắng nghe.

### 3.8. ENV - Thiết lập biến môi trường
```dockerfile
ENV APP_ENV=production
```
- **ENV** đặt biến môi trường trong container.

### 3.9. VOLUME - Gắn kết thư mục
```dockerfile
VOLUME ["/data"]
```
- **VOLUME** tạo thư mục có thể chia sẻ giữa container và máy host.

---

## 4. Ví dụ một Dockerfile đầy đủ
Giả sử chúng ta có một ứng dụng Flask trong `app.py`. Ta có thể viết Dockerfile như sau:

```dockerfile
# Chọn image Python làm nền
FROM python:3.9

# Đặt thư mục làm việc
WORKDIR /app

# Sao chép mã nguồn vào container
COPY . /app

# Cài đặt các dependencies
RUN pip install -r requirements.txt

# Mở cổng 5000
EXPOSE 5000

# Chạy ứng dụng Flask
CMD ["python", "app.py"]
```

### Cách sử dụng
1. **Build image từ Dockerfile**:
   ```sh
   docker build -t my-flask-app .
   ```
2. **Chạy container từ image đã build**:
   ```sh
   docker run -p 5000:5000 my-flask-app
   ```

---

## 5. So sánh CMD và ENTRYPOINT
| CMD | ENTRYPOINT |
|------|------------|
| Có thể bị ghi đè bằng `docker run` | Không thể bị ghi đè trực tiếp |
| Dùng cho các lệnh mặc định | Dùng khi container chỉ chạy một ứng dụng duy nhất |
| Ví dụ: `CMD ["nginx", "-g", "daemon off;"]` | Ví dụ: `ENTRYPOINT ["nginx", "-g", "daemon off;"]` |

---

## 6. Lợi ích của Dockerfile
- **Tự động hóa**: Giúp xây dựng môi trường nhanh chóng và dễ dàng.
- **Nhất quán**: Image được tạo từ Dockerfile sẽ có cùng cấu hình trên mọi môi trường.
- **Tiện lợi**: Dễ dàng chia sẻ và triển khai ứng dụng trên các hệ thống khác nhau.
- **Tái sử dụng**: Có thể mở rộng Dockerfile cho nhiều dự án khác nhau.

---

## 7. Kết luận
Dockerfile là một phần quan trọng trong hệ sinh thái Docker, giúp tự động hóa quá trình tạo image và container. Bằng cách hiểu rõ các lệnh cơ bản và cách viết Dockerfile hiệu quả, bạn có thể triển khai ứng dụng nhanh chóng, ổn định và linh hoạt.
