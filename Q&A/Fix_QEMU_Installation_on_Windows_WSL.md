# 🚀 Fix lỗi cài `qemu` trên Windows (WSL 2)

## ❌ **Lỗi gặp phải**
```bash
E: Package 'qemu' has no installation candidate
```
Lỗi này xảy ra do:
1. **Ubuntu trên WSL chưa cập nhật đầy đủ repository.**
2. **Gói `qemu` đã thay đổi tên hoặc không có sẵn trên phiên bản Ubuntu hiện tại.**
3. **Bạn đang sử dụng Ubuntu 24.04 (`noble`), có thể một số package chưa được cập nhật đầy đủ.**

---

## ✅ **Cách fix lỗi**
### **🔹 Cách 1: Cài đặt `qemu-system` thay thế**
Thử cài đặt `qemu-system` thay vì `qemu`:
```bash
sudo apt update && sudo apt install -y qemu-system qemu-user-static
```
Nếu lệnh trên không hoạt động, hãy thử:
```bash
sudo apt update && sudo apt install -y qemu-system-x86 qemu-user-static
```

---

### **🔹 Cách 2: Cập nhật danh sách package đầy đủ**
```bash
sudo apt update --fix-missing
sudo apt upgrade -y
sudo apt install -y qemu-system qemu-user-static
```
Nếu vẫn bị lỗi, hãy thêm repository `universe`:
```bash
sudo add-apt-repository universe
sudo apt update
sudo apt install -y qemu-system qemu-user-static
```

---

### **🔹 Cách 3: Cài `qemu` từ PPA**
Nếu package `qemu` không có trong repository chính thức, hãy thêm PPA:
```bash
sudo add-apt-repository ppa:jacob/virtualisation
sudo apt update
sudo apt install -y qemu-system qemu-user-static
```

---

### **🔹 Cách 4: Cài đặt `qemu` từ source**
Nếu tất cả cách trên không hoạt động, bạn có thể cài `qemu` từ mã nguồn:
```bash
sudo apt update && sudo apt install -y build-essential libglib2.0-dev libpixman-1-dev
git clone https://gitlab.com/qemu-project/qemu.git
cd qemu
./configure --target-list=x86_64-softmmu,aarch64-softmmu
make -j$(nproc)
sudo make install
```
Lệnh này sẽ biên dịch `qemu` từ mã nguồn.

---

## 🎯 **Tóm lại: Cách tốt nhất**
1. **Thử cài `qemu-system` trước:**
   ```bash
   sudo apt install -y qemu-system qemu-user-static
   ```
2. **Nếu lỗi, thử thêm repository `universe`:**
   ```bash
   sudo add-apt-repository universe
   sudo apt update
   sudo apt install -y qemu-system qemu-user-static
   ```
3. **Nếu vẫn lỗi, dùng PPA:**
   ```bash
   sudo add-apt-repository ppa:jacob/virtualisation
   sudo apt update
   sudo apt install -y qemu-system qemu-user-static
   ```
4. **Nếu tất cả đều thất bại, build từ source:**
   ```bash
   git clone https://gitlab.com/qemu-project/qemu.git
   cd qemu
   ./configure --target-list=x86_64-softmmu,aarch64-softmmu
   make -j$(nproc)
   sudo make install
   ```

Sau khi cài đặt thành công, kiểm tra `qemu` bằng:
```bash
qemu-system-x86_64 --version
```

🚀 **Bạn thử cách nào và có lỗi gì không?** Hãy kiểm tra lại và báo lỗi nếu cần! 🔥
