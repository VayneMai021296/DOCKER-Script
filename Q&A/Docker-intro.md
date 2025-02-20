# 🚀 Docker Là Gì? Các Thành Phần và Quy Trình Deploy Ứng Dụng

## 1️⃣ Docker là gì?
Docker là một nền tảng **mã nguồn mở** giúp đóng gói, phân phối và chạy ứng dụng trong các container một cách **nhanh chóng, linh hoạt và nhất quán**.

### 🔥 Lợi ích của Docker:
- **Portability**: Ứng dụng chạy nhất quán trên mọi môi trường.
- **Isolation**: Mỗi container là một môi trường độc lập.
- **Scalability**: Dễ dàng mở rộng với Docker Swarm hoặc Kubernetes.
- **Efficiency**: Ít tài nguyên hơn so với VM (Virtual Machine).

---

## 2️⃣ Các Thành Phần Chính của Docker

### 🏗 1. Docker Engine
- **Docker Daemon (`dockerd`)**: Quản lý container.
- **Docker CLI (`docker`)**: Công cụ dòng lệnh.
- **REST API**: Giao diện lập trình.

### 📦 2. Docker Image
- Image là một **template chỉ đọc** chứa tất cả dependencies của ứng dụng.
- Ví dụ: **Nginx**, **MySQL**, **Node.js**.

```sh
docker pull nginx
docker images
```

### 🚀 3. Docker Container
- Container là **instance của image** đang chạy.
- Có thể **start, stop, restart, remove** container.

```sh
docker run -d -p 8080:80 nginx
docker ps
docker stop <container-id>
docker rm <container-id>
```

### 🌍 4. Docker Registry (Docker Hub)
- Là nơi lưu trữ Docker Image.

```sh
docker push myrepo/myimage:latest
docker pull myrepo/myimage:latest
```

### 💾 5. Docker Volume
- Lưu trữ dữ liệu bên ngoài container.

```sh
docker volume create mydata
docker run -v mydata:/data nginx
```

### 🔀 6. Docker Network
- Docker cung cấp các loại network:
  - **bridge** (mặc định)
  - **host**
  - **none**
  - **overlay** (Docker Swarm)

```sh
docker network create mynetwork
docker network ls
```

---

## 3️⃣ Quy Trình Deploy Ứng Dụng Lên Server bằng Docker

### 🔹 1. Viết Dockerfile
```dockerfile
FROM node:18
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

### 🔹 2. Build Docker Image
```sh
docker build -t myapp .
```

### 🔹 3. Push Image lên Docker Hub hoặc Private Registry
```sh
docker tag myapp myrepo/myapp:latest
docker push myrepo/myapp:latest
```

### 🔹 4. Deploy trên Server
- SSH vào server.
- Pull image từ Docker Hub.
- Chạy container.

```sh
docker pull myrepo/myapp:latest
docker run -d -p 3000:3000 --name myapp myrepo/myapp:latest
```

### 🔹 5. Quản lý Logs & Monitor
```sh
docker logs -f myapp
docker ps
docker inspect myapp
```

### 🔹 6. Dùng Docker Compose (nếu cần)
Nếu ứng dụng gồm nhiều service, dùng `docker-compose.yml`.

```yaml
version: '3.8'
services:
  app:
    image: myrepo/myapp:latest
    ports:
      - "3000:3000"
    depends_on:
      - db
  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: example
```

Chạy với:
```sh
docker-compose up -d
```

---

## 4️⃣ Tóm Tắt
- **Docker** giúp đóng gói ứng dụng thành container.
- **Các thành phần chính**: Docker Engine, Image, Container, Registry, Volume, Network.
- **Quy trình deploy**:
  1. Viết Dockerfile.
  2. Build Image.
  3. Push Image lên Registry.
  4. Deploy trên server.
  5. Monitor logs.
  6. Dùng Docker Compose nếu có nhiều service.

🚀 **Docker giúp quá trình phát triển và deploy ứng dụng nhanh chóng, linh hoạt, và hiệu quả hơn!**
