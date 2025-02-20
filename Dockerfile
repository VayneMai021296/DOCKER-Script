# ==========================
#   1) Stage build
# ==========================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Đặt thư mục làm việc
WORKDIR /src

# Sao chép toàn bộ mã nguồn (bao gồm .sln, .csproj, ...)
COPY . . 

# (Tuỳ chọn) Liệt kê file để debug
RUN ls -la
RUN find . -name "*.csproj"

# Restore và build
RUN dotnet restore MyAvaloniaApp/MyAvaloniaApp.csproj
RUN dotnet build MyAvaloniaApp/MyAvaloniaApp.csproj -c Release --no-restore

# Publish
RUN dotnet publish MyAvaloniaApp/MyAvaloniaApp.csproj -c Release -o /app/publish --no-build

# ==========================
#   2) Stage runtime
# ==========================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS runtime

# Cài đặt các thư viện cần thiết cho GUI (X11, GTK, v.v.)
# RUN apt-get update && apt-get install -y \
#     libx11-6 \
#     libxcomposite1 \
#     libxcursor1 \
#     libxi6 \
#     libxrandr2 \
#     libxrender1 \
#     libxtst6 \
#     libgtk-3-0 \
#     mesa-utils \
#     x11-apps \
#     xauth \
#     dbus-x11 \
#     xvfb
# Update 
RUN apt-get update
RUN sudo apt update && sudo apt install -y qemu qemu-user-static
RUN docker run --rm --privileged tonistiigi/binfmt --install all
# Thiết lập biến môi trường cho X11
#ENV DISPLAY=:99
#ENV QT_X11_NO_MITSHM=1

# Tạo user không phải root
RUN useradd -ms /bin/bash matrixshowinguser

# Tạo thư mục /tmp/.X11-unix nếu chưa có, đặt quyền truy cập
# RUN mkdir -p /tmp/.X11-unix \
#    && chmod 1777 /tmp/.X11-unix \
#    && chown root:root /tmp/.X11-unix

# Đặt thư mục làm việc
WORKDIR /app

# Sao chép kết quả publish từ stage build
COPY --from=build /app/publish . 

# Chạy ứng dụng với user không phải root
USER matrixshowinguser

# Khởi động Xvfb trước khi chạy ứng dụng Avalonia
CMD ["dotnet", "MyAvaloniaApp.dll"]
