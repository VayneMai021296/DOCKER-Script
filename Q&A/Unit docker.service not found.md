# Fix Lỗi "Unit docker.service not found"

## 🔍 Nguyên nhân
Lỗi **"Unit docker.service not found"** xảy ra khi hệ thống không tìm thấy service Docker. Nguyên nhân có thể là:
1. Docker chưa được cài đặt.
2. Docker bị lỗi hoặc dịch vụ không được đăng ký đúng cách.
3. Hệ thống không sử dụng `systemd` để quản lý Docker.
4. Docker daemon không chạy.

---

## 🛠 Cách Fix Lỗi "Unit docker.service not found"

### 🔹 1. Kiểm tra Docker đã cài đặt chưa
Chạy lệnh:
```bash
which docker
```
Nếu không có output, nghĩa là Docker chưa được cài đặt hoặc không có trong `$PATH`.

Kiểm tra phiên bản Docker:
```bash
docker --version
```
Nếu thấy lỗi **"command not found"**, bạn cần cài đặt Docker.

---

### 🔹 2. Cài đặt Docker nếu chưa có
Chạy lệnh sau để cài đặt Docker:
```bash
sudo apt-get update
sudo apt-get install -y docker.io
```
Sau đó, thử kiểm tra lại:
```bash
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
```

---

### 🔹 3. Kiểm tra danh sách dịch vụ Docker
Chạy lệnh sau để xem các dịch vụ liên quan đến Docker:
```bash
systemctl list-units --type=service | grep -i docker
```
Nếu không thấy **docker.service**, có thể Docker không chạy dưới dạng `systemd`.

---

### 🔹 4. Chạy Docker thủ công
Nếu Docker không có dịch vụ `systemd`, có thể chạy thủ công:
```bash
sudo dockerd
```
Sau đó, mở một terminal khác và thử chạy:
```bash
docker ps
```
Nếu Docker chạy được theo cách này, có thể `systemd` không quản lý Docker, và bạn cần khởi động nó bằng cách thêm Docker vào `systemctl`:
```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

---

### 🔹 5. Kiểm tra Docker daemon chạy không
Chạy:
```bash
ps aux | grep dockerd
```
Nếu không có `dockerd` trong danh sách, thử khởi động lại bằng:
```bash
sudo systemctl start docker
```

Nếu vẫn không được, kiểm tra log lỗi của Docker:
```bash
sudo journalctl -u docker --no-pager | tail -n 50
```

---

### 🔹 6. Cài đặt lại Docker hoàn toàn
Nếu các cách trên không hiệu quả, gỡ cài đặt và cài đặt lại:
```bash
sudo apt-get remove --purge docker docker.io containerd runc
sudo apt-get update
sudo apt-get install -y docker.io
```
Sau đó, khởi động lại Docker:
```bash
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
```

---

## 🚀 Kết Luận

| Lỗi gặp phải | Nguyên nhân | Cách fix |
|-------------|------------|----------|
| `Unit docker.service not found` | Docker chưa được cài | `sudo apt-get install -y docker.io` |
| `docker: command not found` | Docker chưa có trong `$PATH` | Cài lại Docker |
| `systemctl start docker` không chạy | Docker daemon không hoạt động | Chạy `sudo dockerd` |
| Docker không có trong `systemctl` | Dịch vụ Docker chưa được đăng ký | `sudo systemctl daemon-reload` |

Sau khi làm theo các bước trên, thử chạy lại:
```bash
docker run --rm myavaloniaapp
```

Nếu vẫn gặp lỗi, hãy kiểm tra log với:
```bash
sudo journalctl -u docker --no-pager | tail -n 50
```
Và gửi mình để debug tiếp! 🚀
