### 🚀 **Tạo ứng dụng UI bằng Avalonia UI trên Windows và đóng gói bằng Docker để chạy trên macOS/Linux**
Avalonia UI là một **framework UI đa nền tảng**, tương thích với **Windows, macOS, Linux**. Dưới đây là cách **tạo ứng dụng Avalonia UI trên Windows**, build Docker image, và deploy để chạy trên macOS/Linux.

---

## ✅ **Bước 1: Cài đặt Avalonia UI trên Windows**
Trước tiên, bạn cần cài đặt **.NET SDK 8.0** và Avalonia UI Template.

1️⃣ **Cài đặt .NET SDK 8.0**  
Tải về và cài đặt từ [Trang chủ .NET](https://dotnet.microsoft.com/en-us/download/dotnet/8.0).

2️⃣ **Cài đặt Avalonia UI Template**  
Mở **Command Prompt (CMD) hoặc PowerShell** và chạy:
```powershell
dotnet new install Avalonia.Templates
```
Kiểm tra template:
```powershell
dotnet new avalonia --list
```

---

## 🏗 **Bước 2: Tạo ứng dụng Avalonia UI**
Chạy lệnh sau để tạo ứng dụng **Avalonia UI**:
```powershell
dotnet new avalonia.app -o MyAvaloniaApp
cd MyAvaloniaApp
```

---

## 🎨 **Bước 3: Chỉnh sửa UI (Tùy chọn)**
Mở file `MainWindow.axaml` và cập nhật UI:
```xml
<Window xmlns="https://github.com/avaloniaui"
        Title="Avalonia UI on Docker"
        Width="400" Height="200">
    <StackPanel>
        <TextBlock HorizontalAlignment="Center" Margin="10" FontSize="18"
                   Text="Hello from Avalonia UI running in Docker!" />
        <Button Content="Click Me" HorizontalAlignment="Center" Click="OnClick"/>
    </StackPanel>
</Window>
```
Cập nhật `MainWindow.axaml.cs`:
```csharp
using Avalonia.Controls;
using Avalonia.Interactivity;

namespace MyAvaloniaApp
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void OnClick(object? sender, RoutedEventArgs e)
        {
            var messageBox = new Window
            {
                Content = new TextBlock
                {
                    Text = "Button Clicked!",
                    HorizontalAlignment = Avalonia.Layout.HorizontalAlignment.Center,
                    VerticalAlignment = Avalonia.Layout.VerticalAlignment.Center
                },
                Width = 200,
                Height = 100
            };
            messageBox.Show();
        }
    }
}
```

---

## 🔨 **Bước 4: Build & Xuất bản ứng dụng**
Trước khi đóng gói Docker, cần **xuất bản (publish) ứng dụng** dưới dạng **self-contained** để có thể chạy độc lập.

### **Xuất bản ứng dụng trên Windows**
Chạy lệnh sau để build ứng dụng:
```powershell
dotnet publish -c Release -o out --runtime linux-x64 --self-contained true
```
Lệnh này sẽ:
- **`-c Release`**: Build ở chế độ Release.
- **`-o out`**: Xuất kết quả vào thư mục `out`.
- **`--runtime linux-x64`**: Tạo bản build cho Linux.
- **`--self-contained true`**: Bao gồm toàn bộ runtime .NET để chạy độc lập.

---

## 📦 **Bước 5: Viết Dockerfile**
Trong thư mục `MyAvaloniaApp`, tạo file `Dockerfile`:
```dockerfile
# Sử dụng Linux base image có GTK+ (cần cho Avalonia UI)
FROM ubuntu:latest

# Cài đặt dependencies cho Avalonia UI
RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libx11-xcb1 \
    libxcb-shape0 \
    libxcb-xfixes0

# Đặt thư mục làm việc
WORKDIR /app

# Sao chép ứng dụng từ thư mục build vào container
COPY out/ ./

# Chạy ứng dụng Avalonia UI
CMD ["./MyAvaloniaApp"]
```

---

## 🔥 **Bước 6: Build Docker Image**
Chạy lệnh sau để build Docker image:
```powershell
docker build -t myavaloniaapp .
```

---

## 🚀 **Bước 7: Chạy ứng dụng trong Docker**
Trên **Windows**, chạy Docker bằng WSL2 hoặc trên Linux/macOS với lệnh:
```bash
docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix myavaloniaapp
```
🚨 **Lưu ý**:
- Trên **Linux/macOS**, cần chạy **X11 server** để hiển thị giao diện đồ họa.

### **Cấu hình X11 trên macOS/Linux**
Trên **macOS**, cần cài đặt **XQuartz**:
```bash
brew install xquartz
```
Trên **Ubuntu**, cài đặt X11:
```bash
sudo apt install -y x11-apps
```
Sau đó chạy:
```bash
xhost +local:
```

---

## 🚀 **Bước 8: Đẩy Image lên Docker Hub**
1️⃣ **Đăng nhập vào Docker Hub**
```powershell
docker login
```

2️⃣ **Tag & Push Image**
```powershell
docker tag myavaloniaapp yourdockerhubusername/myavaloniaapp:latest
```
```powershell
docker push yourdockerhubusername/myavaloniaapp:latest
```

---

## 🎯 **Bước 9: Chạy ứng dụng trên macOS hoặc Ubuntu**
Trên máy **macOS hoặc Ubuntu**, chỉ cần cài Docker và chạy lệnh sau:
```bash
docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix yourdockerhubusername/myavaloniaapp
```
Nếu thành công, cửa sổ UI của ứng dụng Avalonia sẽ hiển thị trên màn hình. 🚀

---

## 🎯 **Tóm tắt quy trình**
| Bước | Mô tả |
|------|-------|
| **1** | Cài đặt .NET SDK 8.0 và Avalonia UI trên Windows |
| **2** | Tạo ứng dụng Avalonia UI |
| **3** | Thiết kế giao diện UI |
| **4** | Build và publish ứng dụng cho Linux |
| **5** | Viết `Dockerfile` với Ubuntu base image |
| **6** | Build Docker Image |
| **7** | Chạy thử trên Docker Windows/Linux/macOS |
| **8** | Đẩy image lên Docker Hub |
| **9** | Chạy ứng dụng trên macOS/Linux |

---

🎉 **Xong! Bạn đã deploy ứng dụng Avalonia UI thành công bằng Docker! 🚀**