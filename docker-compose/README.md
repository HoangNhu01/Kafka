# Redpanda Quickstart (Docker Compose)

README hướng dẫn cách chạy stack Redpanda + Console + Connect + MinIO trong thư mục `docker-compose`.

## Hiện trạng
- Mục tiêu: dựng môi trường demo Redpanda multi-broker (3 brokers) kèm Console, Connect và MinIO (Tiered Storage).
- File chính: `docker-compose.yml` (đã cấu hình các service: redpanda-0/1/2, console, connect, minio, createtopic, registerschema, deploytransform,...)
- Cấu hình bootstrap: `bootstrap.yml` (xác thực, tiered storage, metrics, ...)

---
## Yêu cầu (Prerequisites) ✅
- Docker Desktop (Windows) hoặc Docker Engine + Docker Compose v2
- PowerShell (mặc định trong môi trường Windows của bạn)
- Ít nhất 4 CPU và 4GB RAM (nhiều hơn sẽ tốt hơn cho 3 brokers).

---
## Chạy nhanh (Quickstart) ▶️
Mở PowerShell tại thư mục `docker-compose` và chạy:

```powershell
# 1) Khởi dựng toàn bộ stack (sẽ kéo image nếu cần)
docker compose -f docker-compose.yml up -d --build

# 2) Kiểm tra trạng thái service
docker compose -f docker-compose.yml ps

# 3) Xem logs (ví dụ redpanda-0)
docker compose -f docker-compose.yml logs -f redpanda-0
```


> Lưu ý: các service này phụ thuộc vào `redpanda-0` đang ở trạng thái healthy.

---
## Kiểm tra hoạt động
- Console UI: http://localhost:8080  (user/password: `superuser` / `secretpassword` nếu dùng basic auth được bật)
- MinIO console: http://localhost:9001  (username: `minio`, password: `redpandaTieredStorage7`)
- Schema Registry endpoints (example): http://localhost:18081 (redpanda-0)

Kiểm tra cluster từ trong container:

```powershell
# Kiểm tra cluster bằng rpk (chạy trong container redpanda-0)
docker compose -f docker-compose.yml exec redpanda-0 rpk cluster info -X user=superuser -X pass=secretpassword

# Kiểm tra topic
docker compose -f docker-compose.yml exec redpanda-0 rpk topic list -X user=superuser -X pass=secretpassword
```

---
## Dừng và dọn dẹp 🧹
```powershell
# Stop all services
docker compose -f docker-compose.yml down

# Stop & remove volumes (xóa dữ liệu)
docker compose -f docker-compose.yml down -v
```

---
## Bảo mật & cấu hình quan trọng 🔒
- Mật khẩu hiện tại nằm trong `docker-compose.yml` và `bootstrap.yml` (ví dụ `secretpassword`, `redpandaTieredStorage7`). **Không để như vậy trong production.**
- Đổi credentials bằng cách sử dụng secret manager hoặc biến môi trường an toàn.
- Nếu bật Tiered Storage trong production, bật TLS cho S3 endpoint và sử dụng IAM/secret store phù hợp.

---
## Tiềm ẩn lỗi thường gặp & xử lý ⚠️
- Port conflict: nếu port host đã bị chiếm (ví dụ 8080, 19092, 9000), sửa mapping trong `docker-compose.yml`.
- Healthcheck fail: kiểm tra `docker compose logs <service>` để biết lý do (chờ vài chục giây sau khi start lần đầu).
- Tài nguyên Docker không đủ: tăng CPU/memory settings trong Docker Desktop.
- Volumes: nếu muốn dữ liệu dễ truy cập trên host, chuyển sang bind mounts trong `volumes` (ví dụ `./data/redpanda-0:/var/lib/redpanda/data`).

---
## Gợi ý nâng cao
- Thay các credential plaintext bằng Docker secrets hoặc environment variables lấy từ CI/CD secret store.
- Kích hoạt TLS/HTTPS cho MinIO và Redpanda khi chạy ngoài môi trường local.
- Tự động hóa: viết script PowerShell để kiểm tra và chạy tuần tự `createtopic`, `registerschema`, `deploytransform` và sau đó start `console`.

---
Nếu bạn muốn, mình có thể:
- Thêm một script PowerShell `start.ps1` để tự động hoá các bước start & verify. ✅
- Thêm hướng dẫn chi tiết thao tác với `rpk` hoặc ví dụ cURL với PandaProxy/Schema Registry. 🔁

---
Những thay đổi này mình sẽ lưu tại `docker-compose/README.md` — muốn cập nhật thêm nội dung chi tiết nào không?