# Giải Thích Chi Tiết Dockerfile Cho Ứng Dụng Avalonia

## 🚀 Phần 1: Build Ứng Dụng (.NET SDK Image)
```dockerfile
# Chọn base image phù hợp cho build
FROM mcr.microsoft.com/dotnet/sdk:9.0-preview AS build
```
- **Base image `mcr.microsoft.com/dotnet/sdk:9.0-preview`**:  
  - Dùng để **build, restore dependencies** và **publish** ứng dụng .NET.
  - Phiên bản `9.0-preview` hỗ trợ Avalonia chạy trên .NET 9.0 preview.

```dockerfile
# Set thư mục làm việc
WORKDIR /src
```
- **WORKDIR `/src`**:  
  - Mọi thao tác như copy code, restore dependencies, build sẽ diễn ra trong `/src`.

```dockerfile
# Copy file dự án trước để cache dependencies
COPY *.sln ./
COPY MyAvaloniaApp/*.csproj MyAvaloniaApp/
```
- **COPY `*.sln` và `*.csproj` trước**:
  - Giúp **cache dependencies**, tối ưu build thời gian sau.

```dockerfile
# Restore dependencies
RUN dotnet restore MyAvaloniaApp/MyAvaloniaApp.csproj
```
- **Tải về dependencies (NuGet packages)** để chuẩn bị build ứng dụng.

```dockerfile
# Copy toàn bộ source code
COPY . .
```
- **Copy toàn bộ source code sau khi đã restore dependencies**.

```dockerfile
# Build ứng dụng dưới dạng release
RUN dotnet publish MyAvaloniaApp/MyAvaloniaApp.csproj -c Release -o /app/publish
```
- **Build ứng dụng** ở chế độ **Release Mode**, xuất file `.dll`, `.exe` vào `/app/publish`.

---

## 🚀 Phần 2: Runtime Environment (.NET ASP.NET Image)
```dockerfile
# Chọn base image phù hợp cho runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0-preview AS runtime
```
- **Base image `mcr.microsoft.com/dotnet/aspnet:9.0-preview`**:  
  - Image nhẹ hơn SDK, chỉ chứa **ASP.NET runtime** để chạy ứng dụng.

```dockerfile
# Cài đặt thư viện X11, Mesa, và dbus-x11 để hỗ trợ GUI
RUN apt-get update && apt-get install -y \
    libx11-6 \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxtst6 \
    libgtk-3-0 \
    mesa-utils \
    x11-apps \
    xauth \
    dbus-x11 \
    xvfb
```
- **Cài đặt thư viện X11 cần thiết để chạy GUI trong Docker**.

```dockerfile
# Thiết lập biến môi trường X11
ENV DISPLAY=:99
ENV QT_X11_NO_MITSHM=1
```
- **Xác định X server ảo chạy trên `:99`**, giúp Avalonia render GUI trong môi trường Docker.

```dockerfile
# Tạo user non-root để chạy ứng dụng an toàn
RUN useradd -ms /bin/bash avaloniauser
```
- **Chạy ứng dụng với user non-root để bảo mật hơn**.

```dockerfile
# Tạo thư mục /tmp/.X11-unix nếu chưa tồn tại, đặt quyền root và gán quyền truy cập
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix && chown root:root /tmp/.X11-unix
```
- **Tạo thư mục `/tmp/.X11-unix`**, nơi X server trao đổi dữ liệu GUI.
- **Cấp quyền `1777`** để đảm bảo mọi user có thể sử dụng X server an toàn.

```dockerfile
# Set thư mục làm việc
WORKDIR /app
```
- **Chỉ định thư mục chứa ứng dụng đã build**.

```dockerfile
# Copy file từ build sang runtime
COPY --from=build /app/publish .
```
- **Copy file từ giai đoạn build (`/app/publish`) sang runtime container**.

```dockerfile
# Chạy ứng dụng với user non-root để tăng cường bảo mật
USER avaloniauser
```
- **Chạy ứng dụng với user `avaloniauser`** thay vì root để tránh lỗ hổng bảo mật.

```dockerfile
# Khởi động Xvfb trước khi chạy ứng dụng Avalonia
CMD ["sh", "-c", "Xvfb :99 -screen 0 1920x1080x24 & dotnet MyAvaloniaApp.dll"]
```
- **Khởi động `Xvfb` để tạo màn hình ảo trước khi chạy ứng dụng Avalonia**.
- **Chạy ứng dụng `dotnet MyAvaloniaApp.dll` sau khi Xvfb đã khởi động**.

---

## 🎯 Tóm Tắt
| Dòng Code | Ý Nghĩa |
|-----------|---------|
| `FROM mcr.microsoft.com/dotnet/sdk:9.0-preview AS build` | Dùng .NET SDK để build ứng dụng |
| `WORKDIR /src` | Thiết lập thư mục làm việc |
| `COPY *.sln ./` | Copy file `.sln` để cache dependencies |
| `RUN dotnet restore` | Tải về các gói NuGet |
| `RUN dotnet publish` | Build ứng dụng dạng Release |
| `FROM mcr.microsoft.com/dotnet/aspnet:9.0-preview AS runtime` | Dùng runtime nhẹ để chạy app |
| `RUN apt-get install -y ...` | Cài thư viện X11 để hỗ trợ GUI |
| `CMD ["sh", "-c", "Xvfb :99 -screen 0 1920x1080x24 & dotnet MyAvaloniaApp.dll"]` | Chạy Xvfb và ứng dụng Avalonia |

Sau khi hiểu rõ từng bước, bạn có thể **tinh chỉnh Dockerfile** để tối ưu hơn nữa! 🚀
