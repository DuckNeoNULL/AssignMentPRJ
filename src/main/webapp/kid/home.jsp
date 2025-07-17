<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kid's Corner</title>

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
                <li><a href="#welcome" class="nav-link active"><i class="bi bi-house-heart-fill"></i><span>Home</span></a></li>
                <li><a href="#create" class="nav-link"><i class="bi bi-palette-fill"></i><span>Create</span></a></li>
                <li><a href="#learn" class="nav-link"><i class="bi bi-joystick"></i><span>Learn & Fun</span></a></li>
                <li><a href="#social" class="nav-link"><i class="bi bi-people-fill"></i><span>Friends</span></a></li>
                <li><a href="#personal" class="nav-link"><i class="bi bi-gem"></i><span>My Stuff</span></a></li>
            </ul>
            <div class="nav-footer">
                <div id="logout-timer">
                    <i class="bi bi-clock-history"></i> Auto Logout in: <strong>15:00</strong>
                </div>
                <a href="#" class="logout-button">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
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
                        <h1>Hi, <c:out value="${child.fullName}"/>!</h1>
                        <p class="fun-date-weather">
                            <i class="bi bi-calendar-heart"></i> Tuesday, July 17 &nbsp;&nbsp; 
                            <i class="bi bi-brightness-high-fill"></i> Sunny Day!
                        </p>
                    </div>
                </div>
                <div class="mood-selector">
                    <p>How are you feeling?</p>
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
                    <i class="bi bi-camera-fill"></i><span>Take Photo</span>
                </a>
                <a href="#" class="action-card color-2">
                    <i class="bi bi-brush-fill"></i><span>Draw</span>
                </a>
                <a href="#" class="action-card color-3">
                    <i class="bi bi-mic-fill"></i><span>Tell a Story</span>
                </a>
                <a href="#" class="action-card color-4">
                    <i class="bi bi-controller"></i><span>Play a Game</span>
                </a>
                <a href="#" class="action-card color-5">
                    <i class="bi bi-book-fill"></i><span>Read a Book</span>
                </a>
                <a href="#" class="action-card color-6">
                    <i class="bi bi-chat-quote-fill"></i><span>Chat</span>
                </a>
            </section>

            <div class="content-grid">
                <!-- 2. Creative Zone -->
                <section id="create" class="content-section">
                    <h2 class="section-title"><i class="bi bi-stars"></i> Creative Zone</h2>
                    <div class="card-deck">
                        <div class="item-card">
                            <i class="bi bi-file-earmark-plus-fill icon-bg"></i>
                            <h3>New Post</h3>
                            <p>Share a photo and text.</p>
                            <a href="${pageContext.request.contextPath}/kid/create-post" class="cta-button">Create</a>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-easel-fill icon-bg"></i>
                            <h3>Drawing Pad</h3>
                            <p>Paint a masterpiece.</p>
                            <button class="cta-button">Draw</button>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-journal-album icon-bg"></i>
                            <h3>Story Maker</h3>
                            <p>Use templates to make a story.</p>
                            <button class="cta-button">Start</button>
                        </div>
                    </div>
                </section>

                <!-- 3. Learning & Fun Zone -->
                <section id="learn" class="content-section">
                    <h2 class="section-title"><i class="bi bi-lightbulb-fill"></i> Learning & Fun</h2>
                    <div class="card-deck">
                        <div class="item-card">
                            <i class="bi bi-headphones icon-bg"></i>
                            <h3>Audio Stories</h3>
                            <p>Listen to fun adventures.</p>
                            <button class="cta-button">Listen</button>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-puzzle-fill icon-bg"></i>
                            <h3>Brain Puzzles</h3>
                            <p>Challenge your mind.</p>
                            <button class="cta-button">Play</button>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-film icon-bg"></i>
                            <h3>Learning Videos</h3>
                            <p>Watch short, fun videos.</p>
                            <button class="cta-button">Watch</button>
                        </div>
                    </div>
                </section>

                <!-- 4. Safe Social Area -->
                <section id="social" class="content-section">
                    <h2 class="section-title"><i class="bi bi-heart-fill"></i> Friends & Family</h2>
                    <div class="card-deck">
                        <div class="item-card">
                            <i class="bi bi-person-check-fill icon-bg"></i>
                            <h3>Friend Feed</h3>
                            <p>See what your friends share.</p>
                            <button class="cta-button">View</button>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-send-check-fill icon-bg"></i>
                            <h3>Messages</h3>
                            <p>Chat with approved friends.</p>
                            <button class="cta-button">Chat</button>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-house-heart-fill icon-bg"></i>
                            <h3>Family Wall</h3>
                            <p>Share with Mom and Dad.</p>
                            <button class="cta-button">Visit</button>
                        </div>
                    </div>
                </section>

                <!-- 5. Personal Space -->
                <section id="personal" class="content-section">
                    <h2 class="section-title"><i class="bi bi-box2-heart-fill"></i> My Personal Space</h2>
                    <div class="card-deck">
                        <div class="item-card">
                            <i class="bi bi-image-alt icon-bg"></i>
                            <h3>My Artworks</h3>
                            <p>Your gallery of creations.</p>
                            <button class="cta-button">Open</button>
                        </div>
                        <div class="item-card">
                             <i class="bi bi-award-fill icon-bg"></i>
                            <h3>My Badges</h3>
                            <p>See all the awards you've won.</p>
                            <button class="cta-button">View</button>
                        </div>
                        <div class="item-card">
                            <i class="bi bi-journals icon-bg"></i>
                            <h3>My Stories</h3>
                            <p>Read your saved adventures.</p>
                            <button class="cta-button">Read</button>
                        </div>
                    </div>
                </section>
            </div>
        </main>
    </div>

    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/kid/js/main.js"></script>
</body>
</html> 