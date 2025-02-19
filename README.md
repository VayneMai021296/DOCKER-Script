# DOCKER-Script
# Docker là gì?
Docker là một nền tảng **mã nguồn mở** giúp **đóng gói (package), phân phối (ship), và chạy (run)** các ứng dụng một cách dễ dàng trong môi trường được gọi là **container**. Container là một dạng môi trường ảo hóa nhẹ, giúp đảm bảo ứng dụng có thể chạy đồng nhất trên nhiều hệ thống khác nhau mà không cần lo lắng về sự khác biệt của môi trường.

---

## 🛠 Cách deploy một dự án bằng Docker
### 🚀 Bước 1: Cài đặt Docker
Trước tiên, bạn cần cài đặt Docker trên máy của mình.  
Tải về tại: [Docker Official Website](https://www.docker.com/)

Sau khi cài đặt, kiểm tra Docker bằng lệnh:
```bash
docker --version
```
Nếu hiển thị phiên bản Docker, bạn đã cài đặt thành công.

---

### 🏗 Bước 2: Tạo `Dockerfile`
Trong thư mục gốc của dự án, tạo một file có tên `Dockerfile` để định nghĩa cách xây dựng container.

Ví dụ: Nếu bạn có một ứng dụng Python chạy với Flask (`app.py`), `Dockerfile` có thể trông như sau:
```dockerfile
# Sử dụng image Python chính thức
FROM python:3.9

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy tất cả file từ thư mục dự án vào container
COPY . .

# Cài đặt các thư viện cần thiết
RUN pip install -r requirements.txt

# Khai báo cổng chạy ứng dụng
EXPOSE 5000

# Lệnh chạy ứng dụng khi container khởi động
CMD ["python", "app.py"]
```

---

### 📦 Bước 3: Build Docker Image
Sau khi có `Dockerfile`, bạn cần **build** một Docker image từ nó.

Chạy lệnh sau trong thư mục dự án (nơi có `Dockerfile`):
```bash
docker build -t my-app .
```
Trong đó:
- `-t my-app` đặt tên cho image là `my-app`
- `.` là vị trí Dockerfile (thư mục hiện tại)

---

### ▶ Bước 4: Chạy Container từ Image
Sau khi build xong image, bạn có thể chạy container bằng lệnh:
```bash
docker run -d -p 5000:5000 --name my-running-app my-app
```
Giải thích:
- `-d`: Chạy container ở chế độ **detached** (chạy nền)
- `-p 5000:5000`: Ánh xạ cổng `5000` từ container ra ngoài
- `--name my-running-app`: Đặt tên container là `my-running-app`
- `my-app`: Tên của image đã build

Kiểm tra container đang chạy:
```bash
docker ps
```

Dừng container:
```bash
docker stop my-running-app
```

Xóa container:
```bash
docker rm my-running-app
```

---

### 🏗 Bước 5: Docker Compose (Tùy chọn)
Nếu dự án có nhiều dịch vụ (ví dụ: backend + database), bạn có thể sử dụng `docker-compose` để quản lý nhiều container dễ dàng.

Tạo file `docker-compose.yml`:
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "5000:5000"
    depends_on:
      - db
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydatabase
```

Chạy bằng:
```bash
docker-compose up -d
```

Dừng bằng:
```bash
docker-compose down
```

---

### 🚀 Bước 6: Deploy lên Cloud (AWS, GCP, Azure, Docker Hub)
Bạn có thể đẩy image lên **Docker Hub** để sử dụng trên các server khác:
```bash
docker tag my-app mydockerhubusername/my-app:latest
docker push mydockerhubusername/my-app:latest
```

Trên server khác, kéo về và chạy:
```bash
docker pull mydockerhubusername/my-app:latest
docker run -d -p 5000:5000 mydockerhubusername/my-app
```

Hoặc deploy lên **AWS ECS, Kubernetes (K8s)**, v.v.

---

## 💡 Tổng kết
1. **Tạo Dockerfile** để mô tả cách chạy ứng dụng.
2. **Build image** bằng lệnh `docker build`.
3. **Chạy container** bằng `docker run`.
4. **Dùng Docker Compose** nếu có nhiều dịch vụ.
5. **Đưa lên Cloud** để deploy trên môi trường production.

⚡ Xong! Bạn đã deploy thành công dự án bằng Docker! 🚀

---

## 📚 Tài liệu tham khảo
- [Docker Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

