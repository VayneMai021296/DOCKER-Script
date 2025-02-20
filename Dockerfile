# ==========================
#   1) Stage build
# ==========================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Đặt thư mục làm việc
WORKDIR /src

# Sao chép toàn bộ mã nguồn (bao gồm .sln, .csproj, ...)
COPY . . 

# Kiểm tra kiến trúc CPU của container để debug
RUN uname -m

# Restore và build ứng dụng
RUN dotnet restore MyAvaloniaApp/MyAvaloniaApp.csproj
RUN dotnet build MyAvaloniaApp/MyAvaloniaApp.csproj -c Release --no-restore

# Publish ứng dụng với `--no-self-contained` để tránh lỗi QEMU
RUN dotnet publish MyAvaloniaApp/MyAvaloniaApp.csproj -c Release -o /app/publish --no-build --no-self-contained

# ==========================
#   2) Stage runtime
# ==========================
# Sử dụng runtime .NET 9 chính thức từ Microsoft
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS runtime

# Sử dụng Ubuntu 22.04 (không chỉ định `--platform`)
FROM ubuntu:22.04

# Cập nhật danh sách package và cài đặt thư viện GUI cần thiết
#RUN apt-get update && apt-get install -y \
    #libx11-6 \
    #libxcomposite1 \
    #libxcursor1 \
    #libxi6 \
    #libxrandr2 \
    #libxrender1 \
    #libxtst6 \
    #libgtk-3-0 \
    #mesa-utils \
    #x11-apps \
    #xauth \
    #dbus-x11 \
    #xvfb \
    #gnome-themes-extra \
    #libasound2 \
    #&& rm -rf /var/lib/apt/lists/*

# Kiểm tra kiến trúc của hệ thống
RUN uname -m

# Thiết lập biến môi trường cho X11
ENV DISPLAY=:99
ENV QT_X11_NO_MITSHM=1

# Tạo user không phải root để chạy GUI an toàn
RUN useradd -ms /bin/bash avaloniauser

# Tạo thư mục /tmp/.X11-unix nếu chưa có, đặt quyền truy cập
#RUN mkdir -p /tmp/.X11-unix \
   # && chmod 1777 /tmp/.X11-unix \
     # && chown root:root /tmp/.X11-unix

# Đặt thư mục làm việc
WORKDIR /app

# Sao chép kết quả publish từ stage build
COPY --from=build /app/publish . 

# Chạy ứng dụng với user không phải root
USER avaloniauser

# Chạy Xvfb để giả lập màn hình trước khi chạy ứng dụng Avalonia
CMD ["dotnet", "MyAvaloniaApp.dll"]
