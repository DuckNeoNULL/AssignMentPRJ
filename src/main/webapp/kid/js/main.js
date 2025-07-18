document.addEventListener('DOMContentLoaded', () => {
    // --- Mood Selector ---
    const moodIcons = document.querySelectorAll('.mood-icon');
    moodIcons.forEach(icon => {
        icon.addEventListener('click', () => {
            // Remove active class from all icons
            moodIcons.forEach(i => i.classList.remove('active'));
            // Add active class to the clicked icon
            icon.classList.add('active');
            // Optional: You can send this mood data to the server
            console.log(`Mood updated to: ${icon.dataset.mood}`);
        });
    });

    // --- Auto Logout Timer ---
    const timerDisplay = document.querySelector('#logout-timer strong');
    let timeLeft = 15 * 60; // 15 minutes in seconds

    const logoutInterval = setInterval(() => {
        timeLeft--;
        const minutes = Math.floor(timeLeft / 60);
        const seconds = timeLeft % 60;

        timerDisplay.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

        if (timeLeft <= 0) {
            clearInterval(logoutInterval);
            // Redirect to logout page or show a modal
            alert("Time's up! You've been logged out.");
            window.location.href = '/logout'; // Adjust this URL
        }
    }, 1000);
    
    // --- Smooth Scrolling for Nav Links ---
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
            // Update active state
            navLinks.forEach(l => l.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // --- Chatbot Integration ---
    // This function is called when you receive a response from the chatbot
    function handleChatbotResponse(jsonResponse) {
        try {
            const data = JSON.parse(jsonResponse);
            console.log("Chatbot response received:", data);

            // Always display the chatbot's text response
            displayChatMessage(data, 'bot');

            // Handle the intent
            if (data.intent && data.data) {
                switch (data.intent) {
                    case 'navigate':
                        handleNavigation(data.data);
                        break;
                    case 'start_post_creation':
                        handlePostCreation(data.data);
                        break;
                    case 'manage_account':
                        handleAccountManagement(data.data);
                        break;
                    case 'interactive_quiz':
                        // The display logic is handled by displayChatMessage now
                        break;
                    case 'simple_chat':
                    case 'suggest_activity':
                        // No specific action needed, the text and suggestions are already displayed
                        break;
                    default:
                        console.log(`Unhandled intent: ${data.intent}`);
                        break;
                }
            }
        } catch (error) {
            console.error("Error parsing or handling chatbot response:", error);
            // Display a generic error message in the chat
            displayChatMessage({ displayText: "Oops! Kiki had a little glitch. Please try again." }, 'bot');
        }
    }

    function handleNavigation(data) {
        if (!data.destination) {
            console.error("Navigation intent missing destination.");
            return;
        }

        const baseUrl = "/KidSocialNetwork"; // Adjust if your context path is different
        const pageMap = {
            'home': `${baseUrl}/kid/home.jsp`,
            'create_post': `${baseUrl}/kid/create-post.jsp`,
            'create_story': `${baseUrl}/kid/create-story.jsp`,
            'draw': `${baseUrl}/kid/draw.jsp`,
            // Assuming parent-related pages are accessible from the kid's context for simplicity
            // In a real app, you might need a different base URL or logic
            'add_child': `${baseUrl}/user/add-child.jsp`, 
            'manage_account': `${baseUrl}/user/manage-account.jsp`
        };

        const url = pageMap[data.destination];

        if (url) {
            console.log(`Navigating to: ${url}`);
            window.location.href = url;
        } else {
            console.error(`Unknown navigation destination: ${data.destination}`);
            displayChatMessage(`I don't know how to go to "${data.destination}".`);
        }
    }

    function handlePostCreation(data) {
        const content = data.content || '';
        // Store the content in localStorage to be retrieved by the create-post page
        localStorage.setItem('postContent', content);
        // Navigate to the create post page
        const createPostUrl = "/KidSocialNetwork/kid/create-post.jsp"; // Adjust context path if needed
        window.location.href = createPostUrl;
    }

    function handleAccountManagement(data) {
        if (!data.action) {
            console.error("Account management intent missing action.");
            return;
        }
        // Store the action in localStorage to be retrieved by the manage-account page
        localStorage.setItem('accountAction', data.action);
        // Navigate to the manage account page
        const manageAccountUrl = "/KidSocialNetwork/user/manage-account.jsp"; // Adjust context path if needed
        window.location.href = manageAccountUrl;
    }

    // A more advanced function to display chat messages, including suggestions
    function displayChatMessage(messageData, author) {
        const chatOutput = document.getElementById('chat-output'); // Make sure you have this element
        if (!chatOutput) return;

        const messageContainer = document.createElement('div');
        messageContainer.classList.add('chat-message', `${author}-message`);

        // Add message text
        const textElement = document.createElement('p');
        textElement.textContent = messageData.displayText;
        messageContainer.appendChild(textElement);

        // Handle different intents for rich content display
        if (messageData.intent === 'interactive_quiz' && messageData.data) {
            const quizData = messageData.data;
            const optionsContainer = document.createElement('div');
            optionsContainer.classList.add('quiz-options');
            
            quizData.options.forEach(option => {
                const button = document.createElement('button');
                button.classList.add('suggestion-btn');
                button.textContent = option;
                button.onclick = () => {
                    // When an option is clicked, send a structured response
                    const userAnswer = {
                        intent: "submit_quiz_answer",
                        question: quizData.question,
                        answer: option,
                        correct_answer: quizData.answer
                    };
                    displayChatMessage({ displayText: option }, 'user');
                    sendInputToChatbot(JSON.stringify(userAnswer));
                    
                    // Disable buttons after answering
                    optionsContainer.querySelectorAll('button').forEach(btn => btn.disabled = true);
                };
                optionsContainer.appendChild(button);
            });
            messageContainer.appendChild(optionsContainer);

        } else if (messageData.suggestions && messageData.suggestions.length > 0) {
            const suggestionsContainer = document.createElement('div');
            suggestionsContainer.classList.add('suggestions');

            messageData.suggestions.forEach(suggestion => {
                const button = document.createElement('button');
                button.classList.add('suggestion-btn');
                button.textContent = suggestion.label;
                button.onclick = () => {
                    // When a suggestion is clicked, display it as a user message
                    // and send its value to the chatbot
                    displayChatMessage({ displayText: suggestion.label }, 'user');
                    sendInputToChatbot(suggestion.value);
                };
                suggestionsContainer.appendChild(button);
            });
            messageContainer.appendChild(suggestionsContainer);
        }

        chatOutput.appendChild(messageContainer);
        // Scroll to the bottom of the chat
        chatOutput.scrollTop = chatOutput.scrollHeight;
    }

    // This function will send user input to the servlet
    async function sendInputToChatbot(userInput) {
        if (!userInput.trim()) return;

        try {
            const response = await fetch('/KidSocialNetwork/chatbot', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ message: userInput })
            });
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const responseText = await response.text();
            handleChatbotResponse(responseText);
        } catch (error) {
            console.error('Failed to send message to chatbot:', error);
            handleChatbotResponse('{"displayText": "I seem to be having trouble connecting. Please check your internet and try again.", "intent": "error", "data":{}}');
        }
    }

    // Example of how you might trigger this. 
    // You would replace this with the actual AJAX call in your chat input form.
    const chatForm = document.getElementById('chat-form'); // e.g., <form id="chat-form">
    if (chatForm) {
        chatForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const chatInput = document.getElementById('chat-input'); // e.g., <input id="chat-input">
            const userInput = chatInput.value;
            chatInput.value = ''; // Clear input field

            // Display user's message immediately
            displayChatMessage({ displayText: userInput }, 'user');
            
            // Send to servlet
            await sendInputToChatbot(userInput);
        });
    }
}); 