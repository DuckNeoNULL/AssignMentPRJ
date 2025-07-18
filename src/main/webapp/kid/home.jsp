<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xin chào, ${child.fullName}!</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Baloo+2:wght@400;500;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/kid/css/style.css">
</head>
<body>

    <div class="kid-container">
        <!-- Main Navigation Sidebar -->
        <nav class="main-nav">
            <div class="nav-brand">
                <i class="bi bi-shield-check-fill"></i>
                <span>KidSocial</span>
            </div>
            <ul>
                <li><a href="#welcome" class="nav-link active"><i class="bi bi-house-heart-fill"></i><span>Trang chủ</span></a></li>
                <li><a href="#create" class="nav-link"><i class="bi bi-palette-fill"></i><span>Tạo</span></a></li>
                <li><a href="#learn" class="nav-link"><i class="bi bi-joystick"></i><span>Học & Vui</span></a></li>
                <li><a href="#social" class="nav-link"><i class="bi bi-people-fill"></i><span>Bạn bè</span></a></li>
                <li><a href="#personal" class="nav-link"><i class="bi bi-gem"></i><span>Cá nhân</span></a></li>
            </ul>
            <div class="nav-footer">
                <div id="logout-timer">
                    <i class="bi bi-clock-history"></i> Tự động đăng xuất trong: <strong>15:00</strong>
                </div>
                <a href="#" class="logout-button">
                    <i class="bi bi-box-arrow-right"></i>
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
                <a href="#" class="action-card color-1">
                    <i class="bi bi-camera-fill"></i><span>Chụp ảnh</span>
                </a>
                <a href="${pageContext.request.contextPath}/kid/draw.jsp" class="action-card color-2">
                    <i class="bi bi-brush-fill"></i><span>Vẽ</span>
                </a>
                <a href="#" class="action-card color-3">
                    <i class="bi bi-mic-fill"></i><span>Kể chuyện</span>
                </a>
                <a href="#" class="action-card color-4">
                    <i class="bi bi-controller"></i><span>Chơi game</span>
                </a>
                <a href="#" class="action-card color-5">
                    <i class="bi bi-book-fill"></i><span>Đọc sách</span>
                </a>
                <a href="#" class="action-card color-6">
                    <i class="bi bi-chat-quote-fill"></i><span>Nói chuyện</span>
                </a>
            </section>

            <div class="content-grid">
                <!-- 2. Creative Zone -->
                <section id="create" class="content-section">
                    <h2 class="section-title"><i class="bi bi-stars"></i> Khu vực sáng tạo</h2>
                    <div class="card-deck">
                        <div class="item-card">
                            <i class="bi bi-file-earmark-plus-fill icon-bg"></i>
                            <h3>Bài viết mới</h3>
                            <p>Chia sẻ ảnh và văn bản.</p>
                            <a href="${pageContext.request.contextPath}/kid/create-post" class="cta-button">Tạo</a>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-easel-fill icon-bg"></i>
                            <h3>Bảng vẽ</h3>
                            <p>Vẽ một tác phẩm nghệ thuật.</p>
                            <a href="${pageContext.request.contextPath}/kid/draw.jsp" class="cta-button">Vẽ</a>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-journal-album icon-bg"></i>
                            <h3>Truyện tạo</h3>
                            <p>Sử dụng mẫu để tạo một câu chuyện.</p>
                            <a href="${pageContext.request.contextPath}/story" class="cta-button">Bắt đầu</a>
                        </div>
                    </div>
                </section>

                <!-- 3. Learning & Fun Zone -->
                <section id="learn" class="content-section">
                    <h2 class="section-title"><i class="bi bi-lightbulb-fill"></i> Học & Vui</h2>
                    <div class="card-deck">
                        <a href="${pageContext.request.contextPath}/stories/audio" class="item-card">
                            <i class="bi bi-headphones icon-bg"></i>
                            <h3>Truyện audio</h3>
                            <p>Nghe các câu chuyện thú vị.</p>
                            <span class="cta-button">Nghe</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/videos" class="item-card">
                            <i class="bi bi-film icon-bg"></i>
                            <h3>Video học tập</h3>
                            <p>Xem các video ngắn, vui vẻ.</p>
                            <span class="cta-button">Xem</span>
                        </a>
                    </div>
                </section>

                <!-- 4. Safe Social Area -->
                <section id="social" class="content-section">
                    <h2 class="section-title"><i class="bi bi-heart-fill"></i> Bạn bè & Gia đình</h2>
                    <div class="card-deck">
                        <div class="item-card">
                            <i class="bi bi-person-check-fill icon-bg"></i>
                            <h3>Bài viết bạn bè</h3>
                            <p>Xem những gì bạn bè chia sẻ.</p>
                            <button class="cta-button">Xem</button>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-send-check-fill icon-bg"></i>
                            <h3>Tin nhắn</h3>
                            <p>Nói chuyện với bạn bè đã được phê duyệt.</p>
                            <button class="cta-button">Nói chuyện</button>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-house-heart-fill icon-bg"></i>
                            <h3>Tường gia đình</h3>
                            <p>Chia sẻ với mẹ và bố.</p>
                            <button class="cta-button">Ghé thăm</button>
                        </div>
                    </div>
                </section>

                <!-- 5. Personal Space -->
                <section id="personal" class="content-section">
                    <h2 class="section-title"><i class="bi bi-box2-heart-fill"></i> Không gian cá nhân</h2>
                    <div class="card-deck">
                        <div class="item-card">
                            <i class="bi bi-image-alt icon-bg"></i>
                            <h3>Tác phẩm của tôi</h3>
                            <p>Bộ sưu tập các tác phẩm của bạn.</p>
                            <button class="cta-button">Mở</button>
                        </div>
                        <div class="item-card">
                             <i class="bi bi-award-fill icon-bg"></i>
                            <h3>Bằng khen</h3>
                            <p>Xem tất cả các bằng khen bạn đã đạt được.</p>
                            <button class="cta-button">Xem</button>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-journals icon-bg"></i>
                            <h3>Truyện của tôi</h3>
                            <p>Đọc các cuộc phiêu lưu đã lưu.</p>
                            <button class="cta-button">Đọc</button>
                        </div>
                    </div>
                </section>
            </div>
        </main>
    </div>

    <!-- =============== CHATBOT UI =============== -->
    <div id="chatbot-container">
        <!-- Chatbot toggle button -->
        <button id="chatbot-toggle">
            <i class="bi bi-robot"></i>
            <i class="bi bi-x-lg" style="display: none;"></i>
        </button>

        <!-- Chatbot window -->
        <div id="chatbot-window" class="hidden">
            <div id="chatbot-header">
                <i class="bi bi-robot"></i>
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

    </style>
    <!-- =============== END OF CHATBOT STYLES =============== -->

</body>
</html> 