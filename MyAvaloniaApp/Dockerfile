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
RUN dotnet restore MyAvaloniaApp.csproj
RUN dotnet build MyAvaloniaApp.csproj -c Release --no-restore

# Publish ứng dụng với `--no-self-contained` để tránh lỗi QEMU
RUN dotnet publish MyAvaloniaApp.csproj -c Release -o /app/publish --no-build --no-self-contained

# ==========================
#   2) Stage runtime
# ==========================
# Sử dụng runtime .NET 9 chính thức từ Microsoft
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime

# Đặt thư mục làm việc
WORKDIR /app

# Sao chép kết quả publish từ stage build
COPY --from=build /app/publish . 

# Khởi chạy ứng dụng
CMD ["dotnet", "MyAvaloniaApp.dll"]
