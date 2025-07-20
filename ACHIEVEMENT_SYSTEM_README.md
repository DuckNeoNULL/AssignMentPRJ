# 🏆 Hệ thống Thành tích (Achievement System)

## 📋 Tổng quan

Hệ thống thành tích được thiết kế để khuyến khích trẻ em tham gia các hoạt động sáng tạo và học tập trên nền tảng Kid Social Network. Hệ thống bao gồm:

- **Huy hiệu (Badges)**: Thưởng cho các hoạt động cụ thể
- **Cấp độ (Levels)**: Hệ thống XP và cấp độ tăng dần
- **Thống kê (Statistics)**: Theo dõi hoạt động của người dùng
- **Bảng xếp hạng (Leaderboard)**: So sánh với bạn bè

## 🗄️ Cấu trúc Database

### Bảng UserStats
```sql
CREATE TABLE dbo.UserStats (
    child_id INT PRIMARY KEY REFERENCES dbo.Children(child_id),
    posts_count INT DEFAULT 0,
    drawings_count INT DEFAULT 0,
    stories_count INT DEFAULT 0,
    friends_count INT DEFAULT 0,
    audio_stories_heard INT DEFAULT 0,
    videos_watched INT DEFAULT 0,
    chat_sessions INT DEFAULT 0,
    total_xp INT DEFAULT 0,
    current_level INT DEFAULT 1,
    last_updated DATETIME2 DEFAULT GETDATE()
);
```

### Bảng Achievements
```sql
CREATE TABLE dbo.Achievements (
    achievement_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT REFERENCES dbo.Children(child_id),
    badge_type NVARCHAR(50) NOT NULL,
    badge_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    icon NVARCHAR(50),
    earned_date DATETIME2 DEFAULT GETDATE(),
    is_special BIT DEFAULT 0
);
```

## 🏅 Các loại Huy hiệu

### 1. Huy hiệu Bài viết (POSTS)
- **Nhà văn nhí**: Viết được 5 bài viết (100 XP)
- **Nhà văn chuyên nghiệp**: Viết được 20 bài viết (200 XP)

### 2. Huy hiệu Vẽ tranh (DRAWINGS)
- **Họa sĩ nhí**: Vẽ được 10 bức tranh (150 XP)
- **Họa sĩ tài năng**: Vẽ được 30 bức tranh (300 XP)

### 3. Huy hiệu Bạn bè (FRIENDS)
- **Bạn bè tốt**: Kết bạn với 5 người (80 XP)
- **Bạn bè thân thiện**: Kết bạn với 15 người (200 XP)

### 4. Huy hiệu Nghe truyện (AUDIO)
- **Mọt sách**: Nghe 20 truyện audio (120 XP)
- **Thính giả xuất sắc**: Nghe 50 truyện audio (250 XP)

### 5. Huy hiệu Xem video (VIDEOS)
- **Người xem chăm chỉ**: Xem 15 video học tập (100 XP)
- **Học sinh xuất sắc**: Xem 40 video học tập (200 XP)

### 6. Huy hiệu Chat (CHAT)
- **Người trò chuyện**: Chat với Kiki 10 lần (80 XP)
- **Bạn thân của Kiki**: Chat với Kiki 30 lần (150 XP)

### 7. Huy hiệu Đặc biệt (SPECIAL)
- **Người đầu tiên**: Là người đầu tiên viết bài trong ngày (500 XP)
- Các huy hiệu đặc biệt khác có thể được thêm vào

## 📊 Hệ thống Cấp độ

### Công thức tính cấp độ:
```
Cấp độ = (Tổng XP / 1000) + 1
```

### Danh hiệu theo cấp độ:
- **Cấp 1-3**: "Nhà sáng tạo nhí"
- **Cấp 4-6**: "Nghệ sĩ tài năng"
- **Cấp 7-9**: "Nhà văn chuyên nghiệp"
- **Cấp 10+**: "Bậc thầy sáng tạo"

## 🛠️ Cách sử dụng trong Code

### 1. Import AchievementHelper
```java
import util.AchievementHelper;
```

### 2. Tích hợp vào các Servlet

#### Trong CreatePostServlet:
```java
// Sau khi tạo bài viết thành công
AchievementHelper.incrementPostCount(request.getSession());
```

#### Trong DrawServlet:
```java
// Sau khi lưu bức vẽ thành công
AchievementHelper.incrementDrawingCount(request.getSession());
```

#### Trong StoryServlet:
```java
// Sau khi tạo truyện thành công
AchievementHelper.incrementStoryCount(request.getSession());
```

#### Trong ChatbotServlet:
```java
// Sau khi chat thành công
AchievementHelper.incrementChatCount(request.getSession());
```

### 3. Thêm XP tùy chỉnh
```java
// Thưởng XP cho hoạt động đặc biệt
AchievementHelper.addXp(request.getSession(), 50);
```

### 4. Trao huy hiệu đặc biệt
```java
// Trao huy hiệu đặc biệt
AchievementHelper.awardSpecialAchievement(
    request.getSession(), 
    "Người đầu tiên", 
    "Là người đầu tiên viết bài trong ngày"
);
```

## 🎨 Giao diện

### Trang Thành tích (/kid/achievements)
- **Header**: Tiêu đề và mô tả
- **Level Section**: Hiển thị cấp độ hiện tại và thanh XP
- **Statistics Grid**: 8 thống kê hoạt động chính
- **Special Achievements**: Huy hiệu đặc biệt (nếu có)
- **Regular Achievements**: Tất cả huy hiệu thường
- **Leaderboard**: Bảng xếp hạng top 5 người dùng

### Thiết kế
- **Màu sắc**: Gradient xanh-tím, phù hợp với trẻ em
- **Font**: Fredoka - font thân thiện với trẻ em
- **Icons**: Emoji và Bootstrap Icons
- **Animations**: Hover effects và transitions mượt mà
- **Responsive**: Tương thích với mobile và tablet

## 📱 Tính năng

### 1. Tự động trao huy hiệu
- Hệ thống tự động kiểm tra và trao huy hiệu khi đạt điều kiện
- Không trùng lặp huy hiệu đã đạt được

### 2. Cập nhật thống kê real-time
- Thống kê được cập nhật ngay lập tức khi có hoạt động mới
- Hiển thị số liệu chính xác và cập nhật

### 3. Bảng xếp hạng
- Hiển thị top 5 người dùng có XP cao nhất
- Cập nhật theo thời gian thực

### 4. Responsive Design
- Giao diện tối ưu cho mọi thiết bị
- Grid layout tự động điều chỉnh

## 🔧 Cấu hình

### 1. Database
Chạy file `KidSocialDB.sql` để tạo các bảng cần thiết và dữ liệu mẫu.

### 2. Web.xml
Không cần cấu hình thêm, servlet đã được đăng ký với annotation.

### 3. Dependencies
Đảm bảo có các dependency sau trong `pom.xml`:
- Jakarta EE 10
- JSTL
- SQL Server JDBC Driver

## 🚀 Triển khai

### 1. Build project
```bash
mvn clean package
```

### 2. Deploy
- Copy file WAR vào thư mục webapps của Tomcat
- Khởi động Tomcat server

### 3. Truy cập
- URL: `http://localhost:8080/kid/achievements`
- Yêu cầu đăng nhập với tài khoản trẻ em

## 🐛 Troubleshooting

### 1. Lỗi Database
- Kiểm tra kết nối database
- Đảm bảo các bảng đã được tạo
- Kiểm tra quyền truy cập

### 2. Lỗi Servlet
- Kiểm tra log Tomcat
- Đảm bảo annotation @WebServlet đúng
- Kiểm tra import statements

### 3. Lỗi Giao diện
- Kiểm tra console browser
- Đảm bảo CSS/JS được load đúng
- Kiểm tra JSTL tags

## 📈 Mở rộng

### 1. Thêm huy hiệu mới
1. Cập nhật `AchievementService.checkAndAwardAchievements()`
2. Thêm logic kiểm tra điều kiện mới
3. Cập nhật giao diện nếu cần

### 2. Thêm loại hoạt động mới
1. Thêm cột mới vào bảng `UserStats`
2. Cập nhật model `UserStats`
3. Thêm method trong `AchievementHelper`
4. Tích hợp vào servlet tương ứng

### 3. Tùy chỉnh giao diện
- Chỉnh sửa CSS trong `achievements.jsp`
- Thêm animations mới
- Tùy chỉnh màu sắc và layout

## 📞 Hỗ trợ

Nếu gặp vấn đề, vui lòng:
1. Kiểm tra log hệ thống
2. Xem lại cấu hình database
3. Đảm bảo tất cả dependencies đã được cài đặt
4. Liên hệ team phát triển nếu cần hỗ trợ thêm 