# 🔐 SSH: Secure Shell - Giải thích và Cách Sử Dụng

## 🚀 **1. SSH là gì?**
### 🔹 **SSH (Secure Shell) là gì?**
- **SSH (Secure Shell)** là giao thức mạng giúp **kết nối từ xa (remote access)** và **quản lý hệ thống** một cách **bảo mật**.
- **Mã hóa dữ liệu** giúp chống nghe lén, giả mạo và tấn công trung gian.
- Được sử dụng rộng rãi để quản lý máy chủ Linux/Unix từ xa.

### 🔹 **SSH hoạt động như thế nào?**
- SSH sử dụng **cặp khóa mã hóa**:
  - **Khóa công khai (Public Key)** - Lưu trên máy chủ.
  - **Khóa riêng tư (Private Key)** - Lưu trên máy khách.
- Xác thực có thể dùng:
  - **Mật khẩu (Password-based authentication)**
  - **Khóa SSH (Key-based authentication)**

---

## 🖥 **2. Cách sử dụng SSH để remote và quản lý hệ thống**

### 🔹 **1️⃣ Kết nối SSH đến máy chủ từ xa**
#### 👉 **Truy cập SSH bằng mật khẩu**
```bash
ssh username@remote_host
```
Ví dụ:
```bash
ssh root@192.168.1.100
```
- `username` → Tên tài khoản trên máy chủ từ xa.
- `remote_host` → Địa chỉ IP hoặc domain của máy chủ.

---

### 🔹 **2️⃣ Kết nối SSH bằng SSH Key**
#### 👉 **Tạo SSH Key trên máy khách**
```bash
ssh-keygen -t rsa -b 4096
```
- Lưu khóa tại **~/.ssh/id_rsa** (Private Key) và **~/.ssh/id_rsa.pub** (Public Key).

#### 👉 **Copy Public Key lên máy chủ từ xa**
```bash
ssh-copy-id username@remote_host
```
Hoặc nếu không có `ssh-copy-id`:
```bash
cat ~/.ssh/id_rsa.pub | ssh username@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```
- Sau đó, có thể kết nối **không cần mật khẩu**:
```bash
ssh username@remote_host
```

---

### 🔹 **3️⃣ Chạy lệnh từ xa qua SSH**
```bash
ssh username@remote_host "ls -lah /var/www"
```
- Thực thi lệnh từ xa mà không cần đăng nhập.

---

### 🔹 **4️⃣ Chuyển file giữa máy khách và máy chủ qua SCP**
#### 👉 **Copy file từ máy khách lên máy chủ**
```bash
scp local_file username@remote_host:/remote/directory/
```
#### 👉 **Copy file từ máy chủ về máy khách**
```bash
scp username@remote_host:/remote/file local_directory/
```

---

### 🔹 **5️⃣ Chuyển file qua SFTP (Giao diện dòng lệnh)**
#### 👉 **Kết nối SFTP**
```bash
sftp username@remote_host
```
- **Lệnh trong SFTP**:
  - `ls` - Liệt kê file trên máy chủ.
  - `put local_file` - Upload file lên máy chủ.
  - `get remote_file` - Tải file về máy khách.

---

## 🔥 **3. Cấu hình SSH Server trên máy chủ (Ubuntu/Linux)**
### 🔹 **Cài đặt SSH Server**
```bash
sudo apt update
sudo apt install openssh-server -y
```

### 🔹 **Kiểm tra trạng thái SSH**
```bash
systemctl status ssh
```

### 🔹 **Chỉnh sửa file cấu hình SSH (nếu cần)**
```bash
sudo nano /etc/ssh/sshd_config
```
Một số tùy chỉnh quan trọng:
- **Thay đổi cổng SSH** (mặc định là 22):
  ```bash
  Port 2222
  ```
- **Chỉ cho phép SSH Key (tắt đăng nhập bằng mật khẩu)**:
  ```bash
  PasswordAuthentication no
  ```

Sau đó **restart SSH service**:
```bash
sudo systemctl restart ssh
```

---

## 🎯 **4. Các lệnh SSH hữu ích**
| Lệnh | Mô tả |
|------|------|
| `ssh username@remote_host` | Kết nối SSH |
| `ssh username@remote_host "command"` | Chạy lệnh từ xa |
| `scp file user@remote:/path/` | Copy file qua SCP |
| `sftp username@remote_host` | Kết nối SFTP |
| `systemctl restart ssh` | Khởi động lại SSH Server |

---

## 🚀 **5. Kết luận**
- **SSH là công cụ quan trọng giúp quản lý máy chủ từ xa một cách an toàn**.
- **Nên sử dụng SSH Key thay vì mật khẩu để bảo mật tốt hơn**.
- **Có thể dùng SSH để chạy lệnh từ xa, chuyển file, và cấu hình máy chủ**.

🔥 **Bạn đã thử sử dụng SSH chưa? Nếu có lỗi gì, hãy kiểm tra lại cấu hình!** 🚀
