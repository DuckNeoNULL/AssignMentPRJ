<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thành tích của tôi - Kid Social Network</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #FF6B9D;
            --secondary-color: #4ECDC4;
            --accent-color: #FFE66D;
            --success-color: #95E1D3;
            --warning-color: #FCE38A;
            --danger-color: #F38181;
            --dark-color: #2C3E50;
            --light-color: #F8F9FA;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Fredoka', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: var(--dark-color);
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            color: white;
        }
        
        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        .back-button {
            position: absolute;
            top: 20px;
            left: 20px;
            background: rgba(255,255,255,0.2);
            border: 2px solid rgba(255,255,255,0.3);
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .back-button:hover {
            background: rgba(255,255,255,0.3);
            color: white;
            transform: translateY(-2px);
        }
        
        .stats-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: none;
        }
        
        .level-section {
            background: linear-gradient(135deg, #FF6B9D, #4ECDC4);
            color: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .level-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .level-number {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .xp-bar {
            background: rgba(255,255,255,0.3);
            border-radius: 25px;
            height: 20px;
            margin: 15px 0;
            overflow: hidden;
        }
        
        .xp-fill {
            background: linear-gradient(90deg, #FFE66D, #FFD700);
            height: 100%;
            border-radius: 25px;
            transition: width 0.5s ease;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-item {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }
        
        .stat-item:hover {
            transform: translateY(-5px);
            border-color: var(--primary-color);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
            font-weight: 500;
        }
        
        .badges-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .section-title {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 25px;
            color: var(--dark-color);
            text-align: center;
        }
        
        .badges-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .badge-card {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            border: 3px solid transparent;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .badge-card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }
        
        .badge-card.special {
            background: linear-gradient(135deg, #FFD700, #FFA500);
            color: white;
        }
        
        .badge-icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }
        
        .badge-name {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .badge-description {
            font-size: 0.9rem;
            color: #6c757d;
            line-height: 1.4;
        }
        
        .badge-date {
            font-size: 0.8rem;
            color: #adb5bd;
            margin-top: 10px;
        }
        
        .special-badge {
            background: linear-gradient(135deg, #FFD700, #FFA500);
            color: white;
        }
        
        .special-badge .badge-description {
            color: rgba(255,255,255,0.8);
        }
        
        .special-badge .badge-date {
            color: rgba(255,255,255,0.6);
        }
        
        .leaderboard-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .leaderboard-item {
            display: flex;
            align-items: center;
            padding: 15px;
            margin-bottom: 10px;
            background: #f8f9fa;
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        
        .leaderboard-item:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }
        
        .leaderboard-rank {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-right: 15px;
            min-width: 40px;
        }
        
        .leaderboard-info {
            flex: 1;
        }
        
        .leaderboard-name {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .leaderboard-xp {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .no-achievements {
            text-align: center;
            padding: 50px;
            color: #6c757d;
        }
        
        .no-achievements i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .badges-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Back Button -->
        <a href="${pageContext.request.contextPath}/kid/home" class="back-button">
            <i class="bi bi-arrow-left"></i> Quay lại
        </a>
        
        <!-- Header -->
        <div class="header">
            <h1>🏆 Thành tích của tôi</h1>
            <p>Xem những gì bạn đã đạt được và tiếp tục phấn đấu!</p>
        </div>
        
        <!-- Level Section -->
        <c:choose>
            <c:when test="${testMode == 'true'}">
                <div class="level-section">
                    <div class="level-title">Nhà sáng tạo nhí</div>
                    <div class="level-number">Cấp 1</div>
                    <div class="xp-info">
                        <strong>0</strong> / 1000 XP
                    </div>
                    <div class="xp-bar">
                        <div class="xp-fill" style="width: 0%"></div>
                    </div>
                    <div class="xp-to-next">
                        Cần thêm <strong>1000</strong> XP để lên cấp 2
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="level-section">
                    <div class="level-title">${userStats.levelTitle}</div>
                    <div class="level-number">Cấp ${userStats.currentLevel}</div>
                    <div class="xp-info">
                        <strong>${userStats.totalXp}</strong> / ${userStats.currentLevel * 1000} XP
                    </div>
                    <div class="xp-bar">
                        <div class="xp-fill" style="width: ${userStats.levelProgress}%"></div>
                    </div>
                    <div class="xp-to-next">
                        Cần thêm <strong>${userStats.xpToNextLevel}</strong> XP để lên cấp ${userStats.currentLevel + 1}
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
        
        <!-- Statistics Section -->
        <div class="stats-card">
            <h2 class="section-title">📊 Thống kê hoạt động</h2>
            <c:choose>
                <c:when test="${testMode == 'true'}">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-icon">✍️</div>
                            <div class="stat-number">0</div>
                            <div class="stat-label">Bài viết đã viết</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">🎨</div>
                            <div class="stat-number">0</div>
                            <div class="stat-label">Bức vẽ đã tạo</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">📖</div>
                            <div class="stat-number">0</div>
                            <div class="stat-label">Truyện đã viết</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">🤝</div>
                            <div class="stat-number">0</div>
                            <div class="stat-label">Bạn bè đã kết</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">📚</div>
                            <div class="stat-number">0</div>
                            <div class="stat-label">Truyện đã nghe</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">🎬</div>
                            <div class="stat-number">0</div>
                            <div class="stat-label">Video đã xem</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">💬</div>
                            <div class="stat-number">0</div>
                            <div class="stat-label">Lần chat với Kiki</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">🏆</div>
                            <div class="stat-number">0</div>
                            <div class="stat-label">Huy hiệu đã đạt</div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-icon">✍️</div>
                            <div class="stat-number">${userStats.postsCount}</div>
                            <div class="stat-label">Bài viết đã viết</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">🎨</div>
                            <div class="stat-number">${userStats.drawingsCount}</div>
                            <div class="stat-label">Bức vẽ đã tạo</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">📖</div>
                            <div class="stat-number">${userStats.storiesCount}</div>
                            <div class="stat-label">Truyện đã viết</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">🤝</div>
                            <div class="stat-number">${userStats.friendsCount}</div>
                            <div class="stat-label">Bạn bè đã kết</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">📚</div>
                            <div class="stat-number">${userStats.audioStoriesHeard}</div>
                            <div class="stat-label">Truyện đã nghe</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">🎬</div>
                            <div class="stat-number">${userStats.videosWatched}</div>
                            <div class="stat-label">Video đã xem</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">💬</div>
                            <div class="stat-number">${userStats.chatSessions}</div>
                            <div class="stat-label">Lần chat với Kiki</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-icon">🏆</div>
                            <div class="stat-number">${achievementCount}</div>
                            <div class="stat-label">Huy hiệu đã đạt</div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Special Achievements Section -->
        <c:if test="${testMode != 'true' and not empty specialAchievements}">
            <div class="badges-section">
                <h2 class="section-title">🥇 Thành tích đặc biệt</h2>
                <div class="badges-grid">
                    <c:forEach var="achievement" items="${specialAchievements}">
                        <div class="badge-card special-badge">
                            <div class="badge-icon">${achievement.icon}</div>
                            <div class="badge-name">${achievement.badgeName}</div>
                            <div class="badge-description">${achievement.description}</div>
                            <div class="badge-date">
                                <fmt:formatDate value="${achievement.earnedDate}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
        
        <!-- Regular Achievements Section -->
        <div class="badges-section">
            <h2 class="section-title">🏅 Huy hiệu của bạn</h2>
            <c:choose>
                <c:when test="${testMode == 'true'}">
                    <div class="no-achievements">
                        <i class="bi bi-emoji-frown"></i>
                        <h3>Chưa có huy hiệu nào</h3>
                        <p>Hãy tham gia các hoạt động để nhận huy hiệu đầu tiên!</p>
                    </div>
                </c:when>
                <c:when test="${not empty achievements}">
                    <div class="badges-grid">
                        <c:forEach var="achievement" items="${achievements}">
                            <c:if test="${!achievement.special}">
                                <div class="badge-card" style="border-color: ${achievement.badgeColor}">
                                    <div class="badge-icon">${achievement.icon}</div>
                                    <div class="badge-name">${achievement.badgeName}</div>
                                    <div class="badge-description">${achievement.description}</div>
                                    <div class="badge-date">
                                        <fmt:formatDate value="${achievement.earnedDate}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-achievements">
                        <i class="bi bi-emoji-frown"></i>
                        <h3>Chưa có huy hiệu nào</h3>
                        <p>Hãy tham gia các hoạt động để nhận huy hiệu đầu tiên!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Leaderboard Section -->
        <c:if test="${testMode != 'true' and not empty topUsers}">
            <div class="leaderboard-section">
                <h2 class="section-title">🏆 Bảng xếp hạng</h2>
                <c:forEach var="user" items="${topUsers}" varStatus="status">
                    <div class="leaderboard-item">
                        <div class="leaderboard-rank">
                            <c:choose>
                                <c:when test="${status.index == 0}">🥇</c:when>
                                <c:when test="${status.index == 1}">🥈</c:when>
                                <c:when test="${status.index == 2}">🥉</c:when>
                                <c:otherwise>#${status.index + 1}</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="leaderboard-info">
                            <div class="leaderboard-name">Người dùng #${user.childId}</div>
                            <div class="leaderboard-xp">${user.totalXp} XP - Cấp ${user.currentLevel}</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Add some animations
        document.addEventListener('DOMContentLoaded', function() {
            // Animate XP bar
            const xpFill = document.querySelector('.xp-fill');
            if (xpFill) {
                setTimeout(() => {
                    xpFill.style.width = xpFill.style.width;
                }, 500);
            }
            
            // Add hover effects to stat items
            const statItems = document.querySelectorAll('.stat-item');
            statItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px) scale(1.05)';
                });
                
                item.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });
            
            // Add click effects to badge cards
            const badgeCards = document.querySelectorAll('.badge-card');
            badgeCards.forEach(card => {
                card.addEventListener('click', function() {
                    this.style.transform = 'scale(0.95)';
                    setTimeout(() => {
                        this.style.transform = 'scale(1)';
                    }, 150);
                });
            });
        });
    </script>
</body>
</html> 