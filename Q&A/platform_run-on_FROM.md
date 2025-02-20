# Mối quan hệ giữa `runs-on`, `FROM`, và `--platform` trong GitHub Actions và Docker

Khi thực hiện CI/CD bằng GitHub Actions và làm việc với Docker, ba yếu tố chính cần quan tâm:

- `runs-on` trong GitHub Actions
- `FROM` trong Dockerfile
- `--platform` trong lệnh `docker build --platform`

Chúng có quan hệ mật thiết và ảnh hưởng đến quá trình build, chạy container.

---

## 1. **`runs-on` trong GitHub Actions**
`runs-on` xác định môi trường (runner) mà workflow sẽ chạy trên GitHub Actions. Ví dụ:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3
```

GitHub cung cấp các runner chính như:
- `ubuntu-latest`, `ubuntu-22.04`, `ubuntu-20.04`
- `windows-latest`
- `macos-latest`
- Hoặc tự host runner (`self-hosted`)

Runner này là môi trường nơi Docker Engine chạy, ảnh hưởng đến việc build và chạy container.

---

## 2. **`FROM` trong Dockerfile**
`FROM` trong Dockerfile xác định base image mà container sử dụng. Ví dụ:

```dockerfile
FROM ubuntu:22.04
```

Base image này ảnh hưởng đến môi trường runtime bên trong container, nhưng không nhất thiết phải khớp với hệ điều hành của runner GitHub Actions.

Nếu build image cho một kiến trúc khác (ví dụ: `arm64` trên runner `x86_64`), cần dùng `--platform`.

---

## 3. **`--platform` trong lệnh `docker build --platform`**
Lệnh này cho phép chỉ định kiến trúc mục tiêu của image:

```sh
docker build --platform linux/arm64 -t my-image .
```

Điều này quan trọng khi:
- Runner GitHub Actions chạy trên `x86_64`, nhưng bạn muốn build image cho `arm64` để chạy trên Raspberry Pi hoặc AWS Graviton.
- Nếu không chỉ định `--platform`, Docker mặc định sử dụng kiến trúc của runner.

---

## **Mối quan hệ giữa `runs-on`, `FROM`, và `--platform`**

| Thành phần | Chức năng | Ảnh hưởng đến |
|------------|----------|--------------|
| `runs-on` | Xác định hệ điều hành của runner GitHub Actions | Nền tảng chạy Docker Engine |
| `FROM` | Chỉ định base image cho container | Hệ điều hành bên trong container |
| `--platform` | Chỉ định kiến trúc mục tiêu của image | Kiến trúc CPU của image |

Ví dụ thực tế:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Build multi-platform image
        run: |
          docker buildx create --use
          docker buildx build --platform linux/amd64,linux/arm64 -t my-image .
```

- `runs-on: ubuntu-latest` ⇒ Runner là Ubuntu, chạy Docker Engine trên `x86_64`.
- `FROM ubuntu:22.04` trong Dockerfile ⇒ Container chạy Ubuntu 22.04.
- `--platform linux/arm64,linux/amd64` ⇒ Build image cho cả `x86_64` và `arm64`.

---

## **Tóm tắt**
- `runs-on` xác định hệ điều hành của runner GitHub Actions.
- `FROM` chỉ định base image bên trong container.
- `--platform` xác định kiến trúc mục tiêu của image, giúp build đa nền tảng.

Nếu không cần build đa kiến trúc, có thể bỏ `--platform`. Nếu cần build cho `arm64` trên runner `x86_64`, phải dùng `docker buildx` với `--platform`.
