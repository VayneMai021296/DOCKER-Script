# Danh sách Lệnh Docker Đầy Đủ

## 🐳 1. Lệnh Docker CLI cơ bản
```sh
docker version          # Kiểm tra phiên bản Docker
docker info             # Hiển thị thông tin về Docker daemon
docker login            # Đăng nhập vào Docker Hub hoặc registry
docker logout           # Đăng xuất khỏi Docker Hub hoặc registry
docker search <image>   # Tìm kiếm image trên Docker Hub
docker pull <image>     # Tải về image từ Docker Hub
docker push <image>     # Đẩy image lên Docker Hub hoặc registry
docker tag <image> <new-name>  # Gán tag mới cho một image
```

---

## 📦 2. Lệnh Quản lý Image
```sh
docker images                 # Liệt kê các image đã tải về
docker rmi <image>             # Xóa một image
docker build -t <image-name> . # Build image từ Dockerfile
docker save -o <file.tar> <image> # Lưu image thành file `.tar`
docker load -i <file.tar>      # Nạp image từ file `.tar`
```

---

## 🚀 3. Lệnh Quản lý Container
```sh
docker run <image>             # Chạy container từ image
docker run -d <image>          # Chạy container ở chế độ nền
docker run --rm <image>        # Chạy container và tự xóa sau khi dừng
docker run -p 8080:80 <image>  # Map port 8080 của host sang 80 của container
docker ps                      # Liệt kê các container đang chạy
docker ps -a                   # Liệt kê tất cả container (bao gồm đã dừng)
docker stop <container>        # Dừng container
docker start <container>       # Khởi động lại container đã dừng
docker restart <container>     # Khởi động lại container
docker kill <container>        # Dừng container ngay lập tức
docker rm <container>          # Xóa container
docker logs <container>        # Xem log của container
docker exec -it <container> bash # Mở terminal bên trong container
docker inspect <container>     # Xem chi tiết thông tin container
```

---

## 📁 4. Lệnh Quản lý Volume & Bind Mount
```sh
docker volume create <volume>          # Tạo volume mới
docker volume ls                        # Liệt kê tất cả volume
docker volume rm <volume>               # Xóa volume
docker run -v my-volume:/data <image>   # Mount volume vào container
docker run -v /host/path:/container/path <image>  # Mount thư mục từ host vào container
```

---

## 🔀 5. Lệnh Quản lý Network
```sh
docker network ls                       # Liệt kê mạng trong Docker
docker network create <network-name>     # Tạo mạng mới
docker network rm <network-name>         # Xóa mạng
docker network inspect <network-name>    # Xem thông tin mạng
docker network connect <network> <container>  # Kết nối container vào mạng
docker network disconnect <network> <container>  # Ngắt kết nối container khỏi mạng
```

---

## 🏗 6. Docker Compose
```sh
docker-compose up             # Khởi động tất cả container theo `docker-compose.yml`
docker-compose up -d          # Chạy ở chế độ nền
docker-compose down           # Dừng và xóa container
docker-compose ps             # Liệt kê container đang chạy
docker-compose logs           # Xem log của tất cả container
docker-compose restart        # Restart tất cả container
docker-compose build          # Build lại image từ `docker-compose.yml`
```

---

## 📜 7. Dockerfile Commands
```dockerfile
FROM <image>              # Chỉ định base image
RUN <command>             # Chạy lệnh trong quá trình build image
CMD ["command", "arg1"]   # Chạy command khi container khởi động
ENTRYPOINT ["command", "arg1"]  # Thiết lập entrypoint mặc định
COPY <src> <dest>         # Copy file từ host vào container
ADD <src> <dest>          # Copy file và tự động giải nén nếu là `.tar`
WORKDIR <path>            # Thiết lập thư mục làm việc
ENV <key>=<value>         # Đặt biến môi trường
EXPOSE <port>             # Khai báo port để container sử dụng
VOLUME <path>             # Tạo volume mount point
USER <username>           # Chạy container với user cụ thể
```

---

Đây là danh sách toàn bộ lệnh Docker quan trọng giúp bạn làm việc với container, image, network, volume, và Docker Compose. 🚀
