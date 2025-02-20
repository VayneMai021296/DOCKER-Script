# 🚀 Docker Compose và Dockerfile cho Ứng Dụng C# ConsoleApp + PostgreSQL

## 1️⃣ Docker Compose là gì?
Docker Compose là một công cụ giúp **quản lý và chạy nhiều container** cùng một lúc bằng cách sử dụng một file cấu hình duy nhất (`docker-compose.yml`). Điều này giúp triển khai các ứng dụng có nhiều thành phần (ví dụ: ứng dụng C# + database) một cách dễ dàng.

---

## 2️⃣ Sự khác nhau giữa Docker Compose và Dockerfile  

| Đặc điểm | Dockerfile | Docker Compose |
|----------|------------|----------------|
| **Chức năng** | Định nghĩa cách build một image | Định nghĩa và quản lý nhiều container |
| **Cấu trúc** | Chỉ là một file hướng dẫn build image | Là một file YAML cấu hình ứng dụng |
| **Cách sử dụng** | Dùng `docker build` để tạo image | Dùng `docker-compose up` để chạy nhiều container |
| **Quản lý service** | Không có | Quản lý nhiều container cùng một lúc |
| **Dùng để làm gì?** | Xây dựng image cho container | Quản lý và chạy toàn bộ hệ thống |

📌 **Tóm lại:**  
- **Dockerfile** giúp **tạo image** từ một cấu hình cụ thể.  
- **Docker Compose** giúp **quản lý và khởi động nhiều container** cùng lúc.

---

## 3️⃣ Ví dụ: C# ConsoleApp + PostgreSQL

Giả sử chúng ta có một ứng dụng **C# ConsoleApp** cần kết nối với **PostgreSQL**.

---

### 🔹 1. Viết Dockerfile cho ứng dụng C# ConsoleApp

📄 **`Dockerfile`**
```dockerfile
# Sử dụng image .NET SDK để build ứng dụng
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

# Copy file csproj và restore các package
COPY ConsoleApp.csproj ./
RUN dotnet restore

# Copy toàn bộ source code vào container và build ứng dụng
COPY . ./
RUN dotnet publish -c Release -o out

# Tạo image chạy ứng dụng
FROM mcr.microsoft.com/dotnet/runtime:7.0
WORKDIR /app
COPY --from=build-env /app/out ./
CMD ["dotnet", "ConsoleApp.dll"]
```

📌 **Giải thích:**
- Sử dụng `mcr.microsoft.com/dotnet/sdk:7.0` để build ứng dụng.
- Copy source code và chạy lệnh `dotnet restore` để lấy các package cần thiết.
- Build ứng dụng với `dotnet publish`.
- Chạy ứng dụng trong container với `dotnet ConsoleApp.dll`.

---

### 🔹 2. Viết file `docker-compose.yml` để chạy ứng dụng cùng PostgreSQL  

📄 **`docker-compose.yml`**
```yaml
version: "3.8"

services:
  app:
    build: .
    depends_on:
      - db
    environment:
      - ConnectionStrings__DefaultConnection=Host=db;Port=5432;Username=postgres;Password=example
    networks:
      - app_network

  db:
    image: postgres:15
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: example
      POSTGRES_DB: mydatabase
    ports:
      - "5432:5432"
    volumes:
      - db_data:/var/lib/postgresql/data
    networks:
      - app_network

volumes:
  db_data:

networks:
  app_network:
```

📌 **Giải thích:**
- **Dịch vụ `app` (ứng dụng C#)**:
  - Build từ `Dockerfile`.
  - Kết nối đến database `db` thông qua biến môi trường `ConnectionStrings__DefaultConnection`.
  - Thuộc `app_network` (mạng Docker riêng cho ứng dụng).

- **Dịch vụ `db` (PostgreSQL)**:
  - Sử dụng image `postgres:15`.
  - Mở cổng **5432** để truy cập database.
  - Lưu dữ liệu vào volume `db_data`.

---

### 🔹 3. Chạy ứng dụng với Docker Compose  

📌 **Bước 1: Build và chạy toàn bộ hệ thống**
```sh
docker-compose up -d
```
- `-d`: Chạy container ở chế độ nền.

📌 **Bước 2: Kiểm tra các container đang chạy**
```sh
docker-compose ps
```

📌 **Bước 3: Kiểm tra logs của ứng dụng**
```sh
docker-compose logs -f app
```

📌 **Bước 4: Dừng toàn bộ dịch vụ**
```sh
docker-compose down
```

---

## 🎯 4️⃣ Tóm tắt

| Dockerfile | Docker Compose |
|------------|---------------|
| Dùng để xây dựng image container | Dùng để chạy và quản lý nhiều container |
| Chỉ định cách setup một container | Dễ dàng liên kết nhiều container với nhau |
| Dùng với `docker build` và `docker run` | Dùng với `docker-compose up` |
| Chỉ cần khi tạo image | Giúp quản lý toàn bộ ứng dụng |

🚀 **Docker Compose giúp triển khai ứng dụng C# ConsoleApp + PostgreSQL một cách dễ dàng và nhanh chóng!**
