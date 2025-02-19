# 🛠️ CI/CD for .NET Console App with Docker

## **📌 Giới thiệu**
Tài liệu này hướng dẫn cách tự động hóa quy trình **build, test, tạo Docker image và push lên Docker Hub** cho ứng dụng .NET Console bằng **GitHub Actions**.

---

## **📂 Cấu trúc thư mục**
Giả sử bạn có thư mục chứa ứng dụng .NET Console như sau:

```
/DotnetHelloDocker
│── /HelloWorldApp
│   │── HelloWorldApp.csproj
│   │── Program.cs
│   │── Dockerfile
│── .github/workflows/
│   │── docker-build.yml  <-- File GitHub Actions
```

---

## **📜 Nội dung file `.github/workflows/docker-build.yml`**
Tạo file `docker-build.yml` trong thư mục `.github/workflows/`:

```yaml
name: Build & Push .NET Console App to Docker Hub

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '7.0'

      - name: Restore dependencies
        run: dotnet restore HelloWorldApp

      - name: Build application
        run: dotnet build HelloWorldApp --configuration Release --no-restore

      - name: Run tests (nếu có)
        run: dotnet test HelloWorldApp --configuration Release --no-build

      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build Docker Image
        run: |
          docker build -t ${{ secrets.DOCKER_USERNAME }}/hello-world-dotnet:latest -f HelloWorldApp/Dockerfile .

      - name: Push Docker Image to Docker Hub
        run: docker push ${{ secrets.DOCKER_USERNAME }}/hello-world-dotnet:latest
```

---

## **⚙️ Hướng dẫn sử dụng**
### **Bước 1: Thiết lập secrets trên GitHub**
- Truy cập **GitHub Repository** của bạn.
- Vào **Settings** → **Secrets and variables** → **Actions**.
- Thêm **2 secrets**:
  - `DOCKER_USERNAME`: Tên tài khoản Docker Hub.
  - `DOCKER_PASSWORD`: Mật khẩu hoặc **Access Token** của Docker Hub.

---

### **Bước 2: Commit & Push lên GitHub**
Chạy lệnh sau:
```bash
git add .
git commit -m "Add GitHub Actions for Docker build & push"
git push origin main
```

---

### **Bước 3: Kiểm tra Workflow**
- Truy cập **GitHub Repository** → **Actions**.
- Xem trạng thái của workflow **"Build & Push .NET Console App to Docker Hub"**.

---

## **🐳 Kiểm tra và chạy Docker container**
Sau khi push lên Docker Hub, bạn có thể tải về và chạy container bằng lệnh:

```bash
docker pull your-docker-username/hello-world-dotnet:latest
docker run --rm your-docker-username/hello-world-dotnet
```

---

## **📌 Kết luận**
- Workflow này giúp **tự động hóa toàn bộ quy trình CI/CD** cho ứng dụng .NET Console.
- Mỗi lần **push lên nhánh `main`**, GitHub Actions sẽ **build code, test, tạo Docker image và push lên Docker Hub**.
- Hỗ trợ môi trường **Linux (`amd64`)** và có thể mở rộng thêm.

🚀 **Giờ đây, bạn chỉ cần commit code là có ngay Docker image mới trên Docker Hub!**
