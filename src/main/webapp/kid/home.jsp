<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kid Social Network</title>
    <!-- Google Fonts: Space Grotesk & Orbitron for Space Theme -->
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700&family=Orbitron:wght@700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/kid/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/kid/css/space-modern.css">
</head>
<body>

    <div class="kid-container">
        <!-- Main Navigation Sidebar -->
        <nav class="main-nav">
            <div class="nav-brand">
                <!-- SVG icon: Tàu vũ trụ -->
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><ellipse cx="16" cy="20" rx="10" ry="4" fill="#3cf2ff" opacity="0.3"/><path d="M16 3c-2 0-3.5 2.5-4.5 5.5C10 12 8 18 8 18s2.5 1 8 1 8-1 8-1-2-6-3.5-9.5C19.5 5.5 18 3 16 3z" fill="#3cf2ff" stroke="#a259ff" stroke-width="1.5"/><circle cx="16" cy="10" r="2.5" fill="#ffe156" stroke="#3cf2ff" stroke-width="1.2"/></svg>
                <span>KidSocial</span>
            </div>
            <ul>
                <li><a href="#welcome" class="nav-link active">
                    <!-- SVG: Nhà hình tàu vũ trụ -->
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><path d="M16 4l10 8v14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2V12l10-8z" fill="#3cf2ff" stroke="#a259ff" stroke-width="1.5"/><rect x="12" y="18" width="8" height="6" rx="2" fill="#ffe156"/></svg>
                    <span>Trang chủ</span></a></li>
                <li><a href="#create" class="nav-link">
                    <!-- SVG: Hành tinh + cọ vẽ -->
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="10" fill="#a259ff" opacity="0.7"/><path d="M22 10l-8 8" stroke="#ffe156" stroke-width="2"/><ellipse cx="22" cy="10" r="2" ry="1" fill="#3cf2ff"/><rect x="20" y="8" width="4" height="2" rx="1" fill="#ffe156"/></svg>
                    <span>Tạo</span></a></li>
                <li><a href="#learn" class="nav-link">
                    <!-- SVG: Tay cầm chơi game hình sao Thổ -->
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><ellipse cx="16" cy="18" rx="10" ry="5" fill="#ffe156" opacity="0.5"/><rect x="10" y="12" width="12" height="8" rx="4" fill="#3cf2ff"/><circle cx="13" cy="16" r="1.5" fill="#a259ff"/><circle cx="19" cy="16" r="1.5" fill="#a259ff"/></svg>
                    <span>Học & Vui</span></a></li>
                <li><a href="#social" class="nav-link">
                    <!-- SVG: Hai phi hành gia -->
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="11" cy="13" r="4" fill="#3cf2ff"/><circle cx="21" cy="13" r="4" fill="#ffe156"/><ellipse cx="11" cy="22" rx="5" ry="3" fill="#3cf2ff" opacity="0.5"/><ellipse cx="21" cy="22" rx="5" ry="3" fill="#ffe156" opacity="0.5"/></svg>
                    <span>Bạn bè</span></a></li>
                <li><a href="#personal" class="nav-link">
                    <!-- SVG: Ngôi sao lấp lánh -->
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><polygon points="16,5 18,13 26,13 19,17 21,25 16,20 11,25 13,17 6,13 14,13" fill="#ffe156" stroke="#a259ff" stroke-width="1.2"/></svg>
                    <span>Cá nhân</span></a></li>
            </ul>
            <div class="nav-footer">
                <div id="logout-timer">
                    <!-- SVG: Đồng hồ -->
                    <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><circle cx="11" cy="11" r="10" stroke="#ffe156" stroke-width="2" fill="none"/><path d="M11 6v5l3 3" stroke="#ffe156" stroke-width="2" stroke-linecap="round"/></svg> Tự động đăng xuất trong: <strong>15:00</strong>
                </div>
                <a href="#" class="logout-button">
                    <!-- SVG: Mũi tên thoát tàu -->
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path d="M5 12h14M13 6l6 6-6 6" stroke="#ff6bcb" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                    <span>Đăng xuất</span>
                </a>
            </div>
        </nav>

        <!-- Main Content Area -->
        <main class="main-content">
            <!-- 1. Welcome Area -->
            <header id="welcome" class="welcome-header">
                <div class="greeting">
                    <img src="https://i.pravatar.cc/80?u=${child.childId}" alt="Avatar" class="avatar">
                    <div>
                        <h1>Xin chào, <c:out value="${child.fullName}"/>!</h1>
                        <p class="fun-date-weather">
                            <i class="bi bi-calendar-heart"></i> Thứ Hai, 17 Tháng 7 &nbsp;&nbsp; 
                            <i class="bi bi-brightness-high-fill"></i> Nắng nóng!
                        </p>
                    </div>
                </div>
                <div class="mood-selector">
                    <p>Bạn cảm thấy thế nào?</p>
                    <div class="mood-icons">
                        <button class="mood-icon" data-mood="Happy"><img src="https://img.icons8.com/emoji/48/000000/grinning-face-with-big-eyes.png" alt="Happy"/></button>
                        <button class="mood-icon" data-mood="Excited"><img src="https://img.icons8.com/emoji/48/000000/star-struck.png" alt="Excited"/></button>
                        <button class="mood-icon" data-mood="Okay"><img src="https://img.icons8.com/emoji/48/000000/neutral-face.png" alt="Okay"/></button>
                        <button class="mood-icon" data-mood="Sad"><img src="https://img.icons8.com/emoji/48/000000/sad-but-relieved-face.png" alt="Sad"/></button>
                    </div>
                </div>
            </header>

            <!-- Quick Actions Panel -->
            <section class="quick-actions">
                <a href="${pageContext.request.contextPath}/kid/create-post" class="action-card color-1">
                    <!-- SVG: Sổ tay bay giữa các vì sao -->
                    <svg width="48" height="48" viewBox="0 0 48 48" fill="none"><rect x="8" y="10" width="28" height="28" rx="6" fill="#ffe156" stroke="#a259ff" stroke-width="2"/><path d="M12 14l20 20" stroke="#3cf2ff" stroke-width="2"/><circle cx="36" cy="12" r="4" fill="#3cf2ff" opacity="0.7"/></svg>
                    <span>Viết bài</span>
                </a>
                <a href="${pageContext.request.contextPath}/kid/draw.jsp" class="action-card color-2">
                    <!-- SVG: Ngôi sao vẽ dải ngân hà -->
                    <svg width="48" height="48" viewBox="0 0 48 48" fill="none"><polygon points="24,8 27,20 40,20 29,28 32,40 24,32 16,40 19,28 8,20 21,20" fill="#3cf2ff" stroke="#a259ff" stroke-width="1.5"/><path d="M24 32 Q28 36 36 36" stroke="#ffe156" stroke-width="2"/></svg>
                    <span>Vẽ tranh</span>
                </a>
                <a href="${pageContext.request.contextPath}/kid/create-story.jsp" class="action-card color-3">
                    <!-- SVG: Hành tinh + bút lông -->
                    <svg width="48" height="48" viewBox="0 0 48 48" fill="none"><circle cx="24" cy="24" r="12" fill="#a259ff" opacity="0.7"/><rect x="32" y="12" width="6" height="2" rx="1" fill="#ffe156"/><path d="M30 18l-8 8" stroke="#ffe156" stroke-width="2"/></svg>
                    <span>Viết truyện</span>
                </a>
                <a href="${pageContext.request.contextPath}/stories/audio" class="action-card color-4">
                    <!-- SVG: Tai nghe sao Thổ -->
                    <svg width="48" height="48" viewBox="0 0 48 48" fill="none"><ellipse cx="24" cy="32" rx="14" ry="6" fill="#ffe156" opacity="0.5"/><rect x="14" y="18" width="20" height="16" rx="8" fill="#3cf2ff"/><circle cx="18" cy="26" r="3" fill="#a259ff"/><circle cx="30" cy="26" r="3" fill="#a259ff"/></svg>
                    <span>Nghe truyện</span>
                </a>
                <a href="${pageContext.request.contextPath}/videos" class="action-card color-5">
                    <!-- SVG: Màn hình video vũ trụ -->
                    <svg width="48" height="48" viewBox="0 0 48 48" fill="none"><rect x="10" y="14" width="28" height="20" rx="6" fill="#3cf2ff"/><polygon points="22,20 32,24 22,28" fill="#ffe156"/></svg>
                    <span>Xem video</span>
                </a>
                <a href="${pageContext.request.contextPath}/kid/friendship" class="action-card color-6">
                    <!-- SVG: Hai phi hành gia nhỏ -->
                    <svg width="48" height="48" viewBox="0 0 48 48" fill="none"><circle cx="16" cy="20" r="6" fill="#3cf2ff"/><circle cx="32" cy="20" r="6" fill="#ffe156"/><ellipse cx="16" cy="34" rx="8" ry="4" fill="#3cf2ff" opacity="0.5"/><ellipse cx="32" cy="34" rx="8" ry="4" fill="#ffe156" opacity="0.5"/></svg>
                    <span>Kết bạn</span>
                </a>
            </section>

            <!-- Replace legacy learn/social/personal sections with modern layout -->

            <!-- LEARNING & FUN -->
            <div class="section" id="learn">
              <h2 class="section-h"><svg width="28" height="28" viewBox="0 0 24 24" fill="#E88D9A"><circle cx="12" cy="12" r="10"/></svg> Học & Vui</h2>
              <div class="section-deck">
                <a href="${pageContext.request.contextPath}/stories/audio" class="card">
                  <span class="card-icon"><svg viewBox="0 0 24 24"><rect x="4" y="6" width="16" height="12" rx="6" fill="var(--space-cyan)"/></svg></span>
                  <h3 class="card-title">Nghe Truyện</h3>
                  <p class="card-desc">Những câu chuyện cổ tích thú vị.</p>
                  <button class="btn">Bay đến</button>
                </a>
                <a href="${pageContext.request.contextPath}/videos" class="card">
                  <span class="card-icon"><svg viewBox="0 0 24 24"><rect width="18" height="12" x="3" y="6" rx="2" fill="var(--space-cyan)"/><polygon points="10,8 16,12 10,16" fill="var(--space-yellow)"/></svg></span>
                  <h3 class="card-title">Video Học tập</h3>
                  <p class="card-desc">Xem video vui nhộn và học hỏi.</p>
                  <button class="btn">Khám phá</button>
                </a>
              </div>
            </div>

            <!-- FRIENDS & FAMILY -->
            <div class="section" id="social">
              <h2 class="section-h"><svg width="28" height="28" viewBox="0 0 24 24" fill="#FFC857"><circle cx="12" cy="12" r="10"/></svg> Bạn bè & Gia đình</h2>
              <div class="section-deck">
                <a href="${pageContext.request.contextPath}/kid/friendship" class="card">
                  <span class="card-icon"><svg viewBox="0 0 24 24"><circle cx="8" cy="10" r="4" fill="var(--space-cyan)"/><circle cx="16" cy="10" r="4" fill="var(--space-yellow)"/></svg></span>
                  <h3 class="card-title">Kết bạn</h3>
                  <p class="card-desc">Tìm bạn mới và kết nối.</p>
                  <button class="btn">Khám phá</button>
                </a>
                <a href="${pageContext.request.contextPath}/kid/friend-posts" class="card">
                  <span class="card-icon"><svg viewBox="0 0 24 24"><rect width="20" height="14" x="2" y="5" rx="3" fill="var(--space-yellow)"/></svg></span>
                  <h3 class="card-title">Bài viết Bạn bè</h3>
                  <p class="card-desc">Xem chia sẻ từ bạn bè.</p>
                  <button class="btn">Bay đến</button>
                </a>
                <a href="#" class="card" onclick="openChatbot()">
                  <span class="card-icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="8" fill="var(--space-yellow)"/></svg></span>
                  <h3 class="card-title">Chat với Kiki</h3>
                  <p class="card-desc">Trò chuyện với bạn ảo thông minh.</p>
                  <button class="btn">Trò chuyện</button>
                </a>
              </div>
            </div>

            <!-- PERSONAL SPACE -->
            <div class="section" id="personal">
              <h2 class="section-h"><svg width="28" height="28" viewBox="0 0 24 24" fill="#52dee5"><circle cx="12" cy="12" r="10"/></svg> Không gian cá nhân</h2>
              <div class="section-deck">
                <a href="${pageContext.request.contextPath}/kid/my-posts" class="card">
                  <span class="card-icon"><svg viewBox="0 0 24 24"><rect width="18" height="18" x="3" y="3" rx="4" fill="var(--space-yellow)"/></svg></span>
                  <h3 class="card-title">Bài viết của tôi</h3>
                  <p class="card-desc">Xem lại những gì bạn đã đăng.</p>
                  <button class="btn">Khám phá</button>
                </a>
                <a href="${pageContext.request.contextPath}/kid/achievements" class="card">
                  <span class="card-icon"><svg viewBox="0 0 24 24"><polygon points="12,2 15,14 12,11 9,14" fill="var(--space-cyan)"/></svg></span>
                  <h3 class="card-title">Thành tích</h3>
                  <p class="card-desc">Xem những cột mốc của bạn.</p>
                  <button class="btn">Bay đến</button>
                </a>
              </div>
            </div>

            <!-- Remove old feature-section blocks below (if any) -->
            <!-- ... existing code for chatbot etc remains ... -->
        </main>
    </div>

    <!-- =============== CHATBOT UI =============== -->
    <div id="chatbot-container">
        <!-- Chatbot toggle button -->
        <button id="chatbot-toggle">
            <!-- SVG: Đầu robot Kiki -->
            <svg width="38" height="38" viewBox="0 0 48 48" fill="none"><ellipse cx="24" cy="32" rx="14" ry="6" fill="#3cf2ff" opacity="0.5"/><circle cx="24" cy="20" r="10" fill="#ffe156" stroke="#a259ff" stroke-width="2"/><ellipse cx="20" cy="18" rx="2" ry="3" fill="#3cf2ff"/><ellipse cx="28" cy="18" rx="2" ry="3" fill="#3cf2ff"/><rect x="20" y="26" width="8" height="2" rx="1" fill="#a259ff"/></svg>
            <svg class="close-icon" width="28" height="28" viewBox="0 0 28 28" fill="none" style="display: none;"><circle cx="14" cy="14" r="13" stroke="#ff6bcb" stroke-width="2" fill="none"/><path d="M9 9l10 10M19 9l-10 10" stroke="#ff6bcb" stroke-width="2" stroke-linecap="round"/></svg>
        </button>

        <!-- Chatbot window -->
        <div id="chatbot-window" class="hidden">
            <div id="chatbot-header">
                <!-- SVG: Đầu robot Kiki nhỏ -->
                <svg width="32" height="32" viewBox="0 0 48 48" fill="none"><ellipse cx="24" cy="32" rx="14" ry="6" fill="#3cf2ff" opacity="0.5"/><circle cx="24" cy="20" r="10" fill="#ffe156" stroke="#a259ff" stroke-width="2"/><ellipse cx="20" cy="18" rx="2" ry="3" fill="#3cf2ff"/><ellipse cx="28" cy="18" rx="2" ry="3" fill="#3cf2ff"/><rect x="20" y="26" width="8" height="2" rx="1" fill="#a259ff"/></svg>
                <span>Kiki - Người bạn ảo</span>
            </div>
            <div id="chatbot-messages">
                <!-- Messages will be appended here -->
            </div>
            <div id="chatbot-input-container">
                <input type="text" id="chatbot-input" placeholder="Hỏi Kiki điều gì đó...">
                <button id="chatbot-send"><i class="bi bi-send-fill"></i></button>
            </div>
        </div>
    </div>
    <!-- =============== END OF CHATBOT UI =============== -->


    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/kid/js/main.js"></script>

    <!-- =============== CHATBOT SCRIPT =============== -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const chatbotToggle = document.getElementById('chatbot-toggle');
            const chatbotWindow = document.getElementById('chatbot-window');
            const toggleOpenIcon = chatbotToggle.querySelector('.bi-robot');
            const toggleCloseIcon = chatbotToggle.querySelector('.bi-x-lg');
            const messagesContainer = document.getElementById('chatbot-messages');
            const input = document.getElementById('chatbot-input');
            const sendButton = document.getElementById('chatbot-send');

            // --- Toggle Chat Window ---
            chatbotToggle.addEventListener('click', () => {
                chatbotWindow.classList.toggle('hidden');
                toggleOpenIcon.style.display = chatbotWindow.classList.contains('hidden') ? 'block' : 'none';
                toggleCloseIcon.style.display = chatbotWindow.classList.contains('hidden') ? 'none' : 'block';
                if (!chatbotWindow.classList.contains('hidden')) {
                    addBotMessage("Chào bạn, tớ là Kiki! Bạn có muốn Kiki giúp gì không, ví dụ như 'đố vui' hoặc 'vẽ gì đây'?");
                }
            });

            // --- Send Message ---
            const sendMessage = async () => {
                const messageText = input.value.trim();
                if (messageText === '') return;

                addUserMessage(messageText);
                input.value = '';
                showTypingIndicator();

                try {
                    const response = await fetch('${pageContext.request.contextPath}/chatbot', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'Accept': 'application/json'
                        },
                        body: JSON.stringify({ message: messageText })
                    });
                    
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }

                    const rawResponse = await response.text();
                    removeTypingIndicator();
                    handleBotResponse(rawResponse);

                } catch (error) {
                    console.error('Error fetching chatbot response:', error);
                    removeTypingIndicator();
                    addBotMessage("Ôi, có vẻ như Kiki đang gặp sự cố kết nối. Bạn thử lại sau nhé!", true);
                }
            };

            sendButton.addEventListener('click', sendMessage);
            input.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });

            // --- Handle Bot Response (Text or JSON) ---
            function handleBotResponse(response) {
                try {
                    const data = JSON.parse(response);
                    // It's a JSON response with an intent
                    if (data.intent) {
                        executeIntent(data);
                    } else {
                        // Should not happen with our prompt, but as a fallback
                        addBotMessage(response);
                    }
                } catch (e) {
                    // It's a plain text response
                    addBotMessage(response);
                }
            }
            
            // --- Execute Actions based on Intent ---
            function executeIntent(data) {
                let botMessage = `Tớ có một ý tưởng tuyệt vời cho bạn đây!`; // Default message
                
                switch (data.intent) {
                    case 'generate_creative_idea':
                        botMessage = `${data.title}: ${data.description}`;
                        addBotMessage(botMessage);
                        // Highlight the relevant creative button
                        if(data.type === 'drawing') {
                            highlightActivity('.action-card[href*="draw.jsp"]');
                        } else if (data.type === 'story') {
                            highlightActivity('.action-card[href*="story"]');
                        }
                        break;
                    case 'suggest_activity':
                        botMessage = data.prompt;
                        addBotMessage(botMessage);
                        break;
                    case 'create_quiz':
                        const quiz = data.questions[0];
                        botMessage = `Đây là một câu đố vui cho bạn: **${quiz.question}**`;
                        addBotMessage(botMessage);
                        // You can extend this to show options as buttons
                        break;
                    case 'find_content':
                        botMessage = `Tuyệt! Hãy cùng tìm ${data.content_type} về **${data.topic}** nhé!`;
                        addBotMessage(botMessage);
                        // Here you could redirect or open a modal with search results
                        break;
                    case 'error':
                        botMessage = data.message;
                        addBotMessage(botMessage, true);
                        break;
                    default:
                        addBotMessage("Tớ chưa hiểu ý bạn lắm. Bạn thử hỏi cách khác xem sao?");
                }
            }

            // --- UI Helper Functions ---
            function addUserMessage(text) {
                const messageElement = document.createElement('div');
                messageElement.className = 'chat-message user-message';
                messageElement.innerText = text;
                messagesContainer.appendChild(messageElement);
                scrollToBottom();
            }

            function addBotMessage(text, isError = false) {
                const messageElement = document.createElement('div');
                messageElement.className = 'chat-message bot-message';
                if(isError) messageElement.classList.add('error');
                messageElement.innerHTML = text; // Use innerHTML to render bold tags etc.
                messagesContainer.appendChild(messageElement);
                scrollToBottom();
            }

            function showTypingIndicator() {
                const typingElement = document.createElement('div');
                typingElement.className = 'chat-message bot-message typing-indicator';
                typingElement.innerHTML = '<span></span><span></span><span></span>';
                typingElement.id = 'typing-indicator';
                messagesContainer.appendChild(typingElement);
                scrollToBottom();
            }

            function removeTypingIndicator() {
                const typingElement = document.getElementById('typing-indicator');
                if (typingElement) {
                    typingElement.remove();
                }
            }
            
            function highlightActivity(selector) {
                const element = document.querySelector(selector);
                if (element) {
                    element.classList.add('highlight');
                    setTimeout(() => {
                        element.classList.remove('highlight');
                    }, 3000); // Highlight for 3 seconds
                }
            }

            function scrollToBottom() {
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }
            
            // Function to open chatbot from button
            window.openChatbot = function() {
                chatbotWindow.classList.remove('hidden');
                toggleOpenIcon.style.display = 'none';
                toggleCloseIcon.style.display = 'block';
                addBotMessage("Chào bạn, tớ là Kiki! Bạn có muốn Kiki giúp gì không, ví dụ như 'đố vui' hoặc 'vẽ gì đây'?");
            }
        });
    </script>
    
    <!-- =============== CHATBOT STYLES =============== -->
    <style>
        #chatbot-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
        }

        #chatbot-toggle {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ff6b6b, #feca57);
            border: none;
            color: white;
            font-size: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: transform 0.2s ease;
        }
        #chatbot-toggle:hover {
            transform: scale(1.1);
        }

        #chatbot-window {
            width: 350px;
            height: 500px;
            background-color: #f9f9f9;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.25);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            transition: all 0.3s ease-in-out;
            position: absolute;
            bottom: 80px;
            right: 0;
        }
        #chatbot-window.hidden {
            transform: scale(0);
            opacity: 0;
            pointer-events: none;
        }

        #chatbot-header {
            background: linear-gradient(135deg, #ff6b6b, #feca57);
            color: white;
            padding: 15px;
            font-weight: 500;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        #chatbot-messages {
            flex-grow: 1;
            padding: 15px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .chat-message {
            padding: 10px 15px;
            border-radius: 18px;
            max-width: 80%;
            line-height: 1.4;
        }
        .user-message {
            background-color: #007bff;
            color: white;
            align-self: flex-end;
            border-bottom-right-radius: 4px;
        }
        .bot-message {
            background-color: #e9e9eb;
            color: #333;
            align-self: flex-start;
            border-bottom-left-radius: 4px;
        }
        .bot-message.error {
            background-color: #ffebee;
            color: #c62828;
            font-weight: 500;
        }

        #chatbot-input-container {
            display: flex;
            padding: 10px;
            border-top: 1px solid #ddd;
        }
        #chatbot-input {
            flex-grow: 1;
            border: 1px solid #ccc;
            border-radius: 20px;
            padding: 10px 15px;
            font-size: 14px;
            font-family: 'Baloo 2', cursive;
            margin-right: 10px;
        }
        #chatbot-input:focus {
            outline: none;
            border-color: #ff6b6b;
        }
        #chatbot-send {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: none;
            background-color: #ff6b6b;
            color: white;
            font-size: 18px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        #chatbot-send:hover {
            background-color: #e55a5a;
        }
        
        /* Typing Indicator */
        .typing-indicator span {
            height: 8px;
            width: 8px;
            float: left;
            margin: 0 1px;
            background-color: #9E9EA1;
            display: block;
            border-radius: 50%;
            opacity: 0.4;
            animation: 1s blink infinite;
        }
        .typing-indicator span:nth-child(2) { animation-delay: .2s; }
        .typing-indicator span:nth-child(3) { animation-delay: .4s; }
        @keyframes blink {
            50% { opacity: 1; }
        }

        /* Highlight effect */
        .highlight {
            transition: all 0.3s ease-in-out;
            box-shadow: 0 0 15px 5px #feca57 !important;
            transform: scale(1.05);
        }

        .friends-icon { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .post-icon { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .draw-icon { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .story-icon { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
        .settings-icon { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }

    </style>
    <!-- =============== END OF CHATBOT STYLES =============== -->

</body>
</html> 