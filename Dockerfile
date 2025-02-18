# Chọn base image phù hợp cho build
FROM mcr.microsoft.com/dotnet/sdk:9.0-preview AS build

# Set thư mục làm việc
WORKDIR /src

# Copy file dự án trước để cache dependencies
COPY *.sln ./
COPY MyAvaloniaApp/*.csproj MyAvaloniaApp/

# Restore dependencies
RUN dotnet restore MyAvaloniaApp/MyAvaloniaApp.csproj

# Copy toàn bộ source code
COPY . .

# Build ứng dụng dưới dạng release
RUN dotnet publish MyAvaloniaApp/MyAvaloniaApp.csproj -c Release -o /app/publish

# Chọn base image phù hợp cho runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0-preview AS runtime

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

# Thiết lập biến môi trường X11
ENV DISPLAY=:99
ENV QT_X11_NO_MITSHM=1

# Tạo user non-root để chạy ứng dụng an toàn
RUN useradd -ms /bin/bash avaloniauser 

# Tạo thư mục /tmp/.X11-unix nếu chưa tồn tại và gán quyền
# Tạo thư mục /tmp/.X11-unix nếu chưa tồn tại, đặt quyền root và gán quyền truy cập
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix && chown root:root /tmp/.X11-unix

# Set thư mục làm việc
WORKDIR /app

# Copy file từ build sang runtime
COPY --from=build /app/publish .

# Chạy ứng dụng với user non-root để tăng cường bảo mật
USER avaloniauser

# Khởi động Xvfb trước khi chạy ứng dụng Avalonia
CMD ["sh", "-c", "Xvfb :99 -screen 0 1920x1080x24 & dotnet MyAvaloniaApp.dll"]
