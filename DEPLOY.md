# Hướng dẫn deploy lên MonsterASP.NET

Website TECHBLUE chạy ASP.NET Core + SQL Server. MonsterASP.NET có sẵn cả hai nên
không cần sửa code.

---

## Bước 0 — Kiểm tra phiên bản .NET (làm trước tiên)

Project đang nhắm **.NET 10** (`<TargetFramework>net10.0</TargetFramework>`).

Vào phần thông tin gói hosting của MonsterASP.NET xem có hỗ trợ .NET 10 chưa.
Nếu chưa, hạ về .NET 8 (bản LTS, hầu hết host đều có):

```xml
<!-- Web_ban_đt/TechStoreWeb.csproj -->
<TargetFramework>net8.0</TargetFramework>
```

Rồi hạ luôn các package cho khớp:

```bash
dotnet add Web_ban_đt package Microsoft.EntityFrameworkCore.SqlServer --version 8.0.*
dotnet add Web_ban_đt package Microsoft.AspNetCore.Authentication.Facebook --version 8.0.*
dotnet add Web_ban_đt package Microsoft.AspNetCore.Authentication.Google --version 8.0.*
dotnet build
```

---

## Bước 1 — Tạo tài khoản và site

1. Đăng ký tại https://www.monsterasp.net (gói Free).
2. Trong Control Panel, tạo một **Website** mới, ghi lại tên miền được cấp
   (dạng `ten-cua-ban.runasp.net`).
3. Tạo một **MSSQL Database**. Ghi lại chuỗi kết nối do panel cung cấp,
   dạng:

```
Data Source=<server>;Initial Catalog=<db>;User Id=<user>;Password=<pass>;TrustServerCertificate=True
```

---

## Bước 2 — Nạp dữ liệu sản phẩm

Dùng SQL Server Management Studio (SSMS) kết nối tới database vừa tạo bằng
thông tin ở Bước 1, rồi chạy file `Database/data.sql`.

Các bảng `ChatCustomerMemories`, `ChatMessageLogs`, `PromotionProducts` **không**
nằm trong `data.sql` — chúng được tạo tự động khi app khởi động lần đầu.

---

## Bước 3 — Tạo file cấu hình production

Tạo file `appsettings.Production.json` (file này đã bị `.gitignore` chặn,
**không** commit lên Git):

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=...;Initial Catalog=...;User Id=...;Password=...;TrustServerCertificate=True"
  },
  "Chatbot": {
    "Provider": "OpenAI",
    "Model": "gpt-4o",
    "ApiKey": "<api key that>",
    "ApiUrl": "https://api.yescale.io/v1/chat/completions",
    "MaxRetrievedChunks": 8
  },
  "Authentication": {
    "Google": {
      "ClientId": "<client id>",
      "ClientSecret": "<client secret>"
    },
    "Facebook": {
      "AppId": "<app id>",
      "AppSecret": "<app secret>"
    }
  }
}
```

---

## Bước 4 — Đổi mật khẩu admin mặc định

**Bắt buộc.** Mật khẩu mặc định `adminpassword` nằm công khai trong mã nguồn trên
GitHub, để nguyên là ai cũng vào được trang quản trị.

Thêm vào `web.config` trong gói publish, ngay dưới thẻ `<aspNetCore ...>`:

```xml
<aspNetCore processPath="dotnet" arguments=".\TechStoreWeb.dll" ...>
  <environmentVariables>
    <environmentVariable name="SEED_ADMIN_PASSWORD" value="<mat khau manh cua ban>" />
  </environmentVariables>
</aspNetCore>
```

Lưu ý: biến này chỉ có tác dụng khi database **chưa có** tài khoản Admin nào.
Nếu đã lỡ chạy và tạo admin với mật khẩu mặc định, hãy đăng nhập rồi đổi mật khẩu
trong trang Hồ sơ.

---

## Bước 5 — Build và upload

```bash
dotnet publish Web_ban_đt/TechStoreWeb.csproj -c Release -o ./publish
```

Copy `appsettings.Production.json` (Bước 3) vào thư mục `publish`, sửa `web.config`
(Bước 4), rồi upload **toàn bộ nội dung** thư mục `publish` lên thư mục gốc của
website qua FTP hoặc công cụ Web Deploy mà MonsterASP.NET cung cấp.

Gói publish khoảng 62 MB / 422 file.

---

## Bước 6 — Cập nhật OAuth redirect URI

Nếu không làm bước này, nút đăng nhập Google/Facebook sẽ báo lỗi.

**Google Cloud Console** → Credentials → OAuth 2.0 Client ID → Authorized redirect URIs:

```
https://ten-cua-ban.runasp.net/signin-google
```

**Facebook for Developers** → App → Facebook Login → Settings → Valid OAuth Redirect URIs:

```
https://ten-cua-ban.runasp.net/signin-facebook
```

---

## Bước 7 — Kiểm tra sau khi deploy

- [ ] Trang chủ hiện đủ sản phẩm và ảnh
- [ ] Tìm kiếm và phân trang hoạt động
- [ ] Đăng ký tài khoản mới, đăng nhập lại được
- [ ] Thêm vào giỏ, đặt hàng thành công, tồn kho bị trừ
- [ ] Đăng nhập admin, vào được `/Admin/Products`
- [ ] Chatbot trả lời (cần API key còn số dư)

---

## Xử lý sự cố

**Lỗi HTTP 500.30 / 500.31** — sai phiên bản .NET. Quay lại Bước 0.

**Trang trắng, không báo lỗi** — bật log để xem nguyên nhân: sửa `web.config`
thành `stdoutLogEnabled="true"`, tạo thư mục `logs`, chạy lại rồi mở file trong đó.
Nhớ tắt lại sau khi xong.

**Lỗi kết nối database** — kiểm tra chuỗi kết nối và chắc chắn có
`TrustServerCertificate=True`.

**Chatbot chỉ trả lời chung chung** — API key hết số dư hoặc sai. Xem log để rõ,
lúc đó chatbot chạy bằng câu trả lời dự phòng lấy thẳng từ dữ liệu sản phẩm.
