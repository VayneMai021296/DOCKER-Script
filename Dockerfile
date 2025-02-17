# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0-preview AS build
WORKDIR /src

# Copy entire solution first
COPY . .

# List files to debug
RUN ls -la
# Find all csproj files
RUN find . -name "*.csproj"

# Restore and build
RUN dotnet restore **/*.csproj
RUN dotnet build **/*.csproj -c Release
RUN dotnet publish **/*.csproj -c Release -o /app/publish

# Runtime stage
FROM ubuntu:latest
WORKDIR /app

# Install dependencies for .NET and Avalonia
RUN apt-get update && apt-get install -y \
    wget \
    apt-transport-https \
    software-properties-common

# Add Microsoft package repository
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

# Install .NET runtime and Avalonia dependencies
RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libx11-xcb1 \
    libxcb-shape0 \
    libxcb-xfixes0 \
    dotnet-runtime-9.0

COPY --from=build /app/publish .
CMD ["./MyAvaloniaApp"]
