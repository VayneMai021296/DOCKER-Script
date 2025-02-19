# 🚀 Ý nghĩa của `runs-on`, `--platform` và `FROM` trong CI/CD với Docker

---

## 1️⃣ `runs-on` trong GitHub Actions Workflow

### 🔹 **Ý nghĩa**
- `runs-on` xác định hệ điều hành (runner) mà GitHub Actions sử dụng để thực thi các job CI/CD.
- GitHub cung cấp các runner sẵn có như:
  - `ubuntu-latest`
  - `windows-latest`
  - `macos-latest`
- Có thể sử dụng **self-hosted runners** nếu cần.

### 🔹 **Ví dụ**
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
```
👉 **GitHub Actions sẽ sử dụng một máy ảo Ubuntu để chạy các bước trong job `build`.**

### 🔹 **Mục đích**
- Xác định môi trường để chạy các lệnh trong CI/CD.
- **Không ảnh hưởng đến môi trường bên trong Docker container**.

---

## 2️⃣ `--platform` trong Docker Build

### 🔹 **Ý nghĩa**
- Flag `--platform` trong `docker build` xác định **kiến trúc CPU và hệ điều hành** mà image sẽ hỗ trợ.
- Ví dụ các nền tảng phổ biến:
  - `linux/amd64` (x86_64, phổ biến trên PC)
  - `linux/arm64` (Apple Silicon, AWS Graviton)
  - `windows/amd64` (Windows Containers)

### 🔹 **Ví dụ**
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t myimage .
```
👉 **Lệnh trên tạo một multi-platform image có thể chạy trên cả `amd64 (x86_64)` và `arm64 (ARM-based CPUs như Apple M1/M2)`.**

### 🔹 **Mục đích**
- Giúp image có thể chạy trên **nhiều loại kiến trúc phần cứng**.
- Hữu ích khi triển khai trên **macOS ARM64, Linux AMD64**, hoặc **Windows**.

---

## 3️⃣ `FROM` trong Dockerfile

### 🔹 **Ý nghĩa**
- `FROM` là dòng đầu tiên của Dockerfile, xác định **image gốc (base image)** mà Docker container sẽ sử dụng.
- Tất cả các lệnh tiếp theo sẽ được thực thi trên nền tảng của image này.

### 🔹 **Ví dụ**
```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:9.0
```
👉 **Base image này cung cấp môi trường có sẵn `.NET SDK 9.0` để build ứng dụng.**

### 🔹 **Mục đích**
- Xác định **môi trường bên trong container** (hệ điều hành, thư viện, công cụ có sẵn).
- **Không liên quan đến hệ điều hành của máy build hoặc máy chạy CI/CD**.

---

## 🎯 Tóm tắt sự khác biệt

| Thành phần | Ý nghĩa | Ảnh hưởng đến |
|------------|---------|---------------|
| **`runs-on`** (GitHub Actions) | Xác định hệ điều hành của GitHub Runner | Máy ảo CI/CD |
| **`--platform`** (Docker Build) | Xác định kiến trúc CPU & OS cho image | Nền tảng mà image có thể chạy |
| **`FROM`** (Dockerfile) | Xác định môi trường bên trong container | Hệ điều hành và công cụ bên trong container |

💡 **Ví dụ thực tế**:
1. **GitHub Actions sử dụng Ubuntu để build image Docker**:
   ```yaml
   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - name: Build multi-platform Docker image
           run: docker buildx build --platform linux/amd64,linux/arm64 -t myimage .
   ```
2. **Dockerfile sử dụng image base phù hợp**:
   ```dockerfile
   FROM ubuntu:22.04
   RUN apt update && apt install -y curl
   ```

🚀 **Kết luận**:
- `runs-on`: Xác định **máy build CI/CD**.
- `--platform`: Xác định **nền tảng mà image có thể chạy**.
- `FROM`: Xác định **môi trường bên trong container**.

---

