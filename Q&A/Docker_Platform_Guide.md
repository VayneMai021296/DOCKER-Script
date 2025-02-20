# Giải thích tham số `--platform` trong `docker build`

## 1. Giới thiệu
Tham số `--platform` trong lệnh `docker build` được sử dụng để chỉ định kiến trúc phần cứng (**CPU architecture**) mà bạn muốn build image. Điều này rất quan trọng khi bạn cần tạo Docker images có thể chạy trên nhiều loại thiết bị với các kiến trúc CPU khác nhau.

Ví dụ lệnh:
```sh
docker build --platform linux/amd64 -t my-image .
```
sẽ yêu cầu Docker xây dựng image dành cho kiến trúc **AMD64 (x86_64)** trên hệ điều hành **Linux**.

---

## 2. Các giá trị phổ biến của `--platform`
| Giá trị | Kiến trúc CPU | Mô tả |
|---------|--------------|-------|
| `linux/amd64` | x86_64 | Kiến trúc phổ biến trên máy tính để bàn, server |
| `linux/arm64` | AArch64 | Kiến trúc trên Apple M1/M2, Raspberry Pi, AWS Graviton |
| `linux/arm/v7` | ARMv7 | Các thiết bị nhúng, Raspberry Pi 3 |
| `linux/arm/v6` | ARMv6 | Raspberry Pi đời cũ |
| `linux/ppc64le` | PowerPC64 | Một số hệ thống IBM |
| `linux/s390x` | IBM Z | Hệ thống mainframe IBM |

---

## 3. Vì sao cần chỉ định `--platform`?
### 3.1. Để build image đa nền tảng (multi-platform)
Một số ứng dụng cần chạy trên nhiều nền tảng khác nhau, ví dụ:
- Một ứng dụng cần chạy trên cả **Linux server (amd64)** và **Raspberry Pi (arm64)**.
- Một ứng dụng cần chạy trên máy tính **Mac M1/M2 (arm64)** nhưng cũng cần chạy trên **Windows/Linux (amd64)**.

Sử dụng lệnh:
```sh
docker buildx build --platform linux/amd64,linux/arm64 -t my-image .
```
sẽ giúp bạn tạo **multi-platform image**, có thể chạy trên cả hai nền tảng.

### 3.2. Để build image trên kiến trúc khác với máy build
Ví dụ: Nếu bạn đang chạy Docker trên **MacBook M1/M2 (arm64)** nhưng cần build một image chạy trên **server x86_64 (amd64)**, bạn có thể làm như sau:

```sh
docker build --platform linux/amd64 -t my-app .
```
Điều này đặc biệt hữu ích khi phát triển phần mềm trên máy tính Apple Silicon nhưng triển khai trên hệ thống x86_64.

### 3.3. Để kiểm tra tính tương thích của ứng dụng
Bạn có thể sử dụng tham số này để kiểm tra xem ứng dụng của mình có chạy đúng trên nền tảng khác hay không mà không cần phải có thiết bị thật.

Ví dụ, nếu bạn có một ứng dụng viết bằng **Go** hoặc **Rust**, bạn có thể kiểm tra xem nó có chạy đúng trên **ARM64** bằng cách:

```sh
docker build --platform linux/arm64 -t my-go-app .
```

---

## 4. Sử dụng `--platform` với `docker run`
Sau khi build image với nhiều nền tảng, bạn cũng có thể kiểm tra nó bằng cách chạy container trên một nền tảng cụ thể:

```sh
docker run --platform linux/arm64 my-image
```
Lệnh này yêu cầu Docker sử dụng `linux/arm64`, ngay cả khi hệ thống bạn đang chạy là `amd64`.

---

## 5. Lưu ý quan trọng khi sử dụng `--platform`
### 5.1. Docker Desktop hỗ trợ build đa nền tảng thông qua QEMU emulation
- Nếu hệ điều hành của bạn không khớp với kiến trúc yêu cầu, Docker sẽ tự động sử dụng **QEMU** để giả lập.
- Ví dụ: Trên macOS (ARM64), khi build `linux/amd64`, Docker có thể sử dụng **QEMU** để giả lập.

### 5.2. Sử dụng `docker buildx` để build multi-platform
Nếu bạn muốn build nhiều nền tảng cùng lúc, sử dụng `docker buildx`:
```sh
docker buildx build --platform linux/amd64,linux/arm64 -t my-image .
```
Điều này giúp tạo một image có thể chạy trên nhiều loại CPU mà không cần build riêng từng cái.

---

## 6. Kết luận
- Tham số `--platform` trong `docker build` giúp chỉ định kiến trúc CPU khi build image.
- Hữu ích khi bạn cần hỗ trợ **nhiều nền tảng (multi-platform)** hoặc khi bạn **build trên một hệ thống nhưng deploy trên hệ thống khác**.
- Nếu cần build nhiều kiến trúc cùng lúc, sử dụng **Docker Buildx**.

