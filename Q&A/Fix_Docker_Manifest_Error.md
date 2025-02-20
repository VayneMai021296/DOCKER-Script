# Fix lỗi "no matching manifest for linux/arm64/v8 in the manifest list entries" khi chạy Docker trên macOS M1/M2

## 1. Nguyên nhân lỗi
Lỗi **"no matching manifest for linux/arm64/v8 in the manifest list entries"** xảy ra khi bạn cố gắng chạy một Docker image trên **macOS Silicon (M1/M2, kiến trúc ARM64)** nhưng image không hỗ trợ nền tảng **linux/arm64/v8**.

### Các nguyên nhân chính:
- Bạn đã **build image trên Windows**, nhưng không build đúng định dạng multi-platform.
- Image bạn build **không hỗ trợ `linux/arm64/v8` (Mac M1/M2)**.
- Image bị cache trên máy và không thực sự build đúng `--platform`.

---

## 2. Giải pháp khắc phục

### **2.1. Kiểm tra manifest của image**
Trước tiên, kiểm tra image có hỗ trợ nền tảng nào bằng lệnh:
```sh
docker manifest inspect <your-image>:latest
```
Ví dụ:
```sh
docker manifest inspect my-app:latest
```
Nếu output **không có** `linux/arm64/v8`, có nghĩa là image chưa được build đúng cho nền tảng này.

---

### **2.2. Dùng `docker buildx` để build đúng kiến trúc**
Hãy build image với **multi-platform** bằng `docker buildx`:
```sh
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64/v8 -t my-app:latest .
```
📌 **Lưu ý**: 
- `linux/amd64`: Dành cho Windows/Linux x86_64.
- `linux/arm64/v8`: Dành cho macOS Silicon M1/M2.

Nếu bạn **push image lên Docker Hub**, hãy dùng:
```sh
docker buildx build --platform linux/amd64,linux/arm64/v8 -t my-app:latest --push .
```

Sau đó trên **macOS**, pull lại image:
```sh
docker pull my-app:latest
docker run --platform linux/arm64/v8 my-app
```

---

### **2.3. Kiểm tra lại `FROM` trong Dockerfile**
Nếu Dockerfile của bạn sử dụng một base image không hỗ trợ `arm64`, hãy đổi sang image hỗ trợ.

Ví dụ:
```dockerfile
# ❌ SAI: Image không hỗ trợ ARM64
FROM debian:jessie
```
Thay bằng:
```dockerfile
# ✅ ĐÚNG: Image hỗ trợ ARM64
FROM debian:bullseye
```

Một số image hỗ trợ ARM64 tốt:
| Base Image | Hỗ trợ `arm64` |
|------------|---------------|
| `ubuntu:latest` | ✅ |
| `debian:bullseye` | ✅ |
| `alpine:latest` | ✅ |
| `node:18-alpine` | ✅ |
| `python:3.9-slim` | ✅ |

---

### **2.4. Xóa cache và thử lại**
Docker có thể đang cache lại image sai kiến trúc. Hãy xóa cache và build lại:
```sh
docker buildx prune -a
docker buildx build --no-cache --platform linux/amd64,linux/arm64/v8 -t my-app:latest .
```

---

## 3. Kết luận
Nếu bạn đang **build trên Windows nhưng chạy trên Mac M1/M2**, hãy:
1. **Dùng `docker buildx`** để build multi-platform (`--platform linux/arm64/v8`).
2. **Kiểm tra base image** (`FROM`) có hỗ trợ ARM64 hay không.
3. **Dùng `--push` để push image**, sau đó pull lại trên macOS.
4. **Xóa cache (`docker buildx prune -a`)** và thử lại nếu vẫn gặp lỗi.

🚀 **Áp dụng cách này, bạn sẽ chạy Docker image trên Mac M1/M2 thành công!** 🚀
