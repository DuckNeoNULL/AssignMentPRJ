package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.ChatMessage;
import service.GeminiChatbotService;

import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {

    private final GeminiChatbotService chatbotService = new GeminiChatbotService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 1. Get conversation history from session, or create a new one
        @SuppressWarnings("unchecked")
        List<ChatMessage> conversationHistory = (List<ChatMessage>) session.getAttribute("conversationHistory");
        if (conversationHistory == null) {
            conversationHistory = new ArrayList<>();
        }

        // 2. Read user input from the request
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        
        String requestBody = sb.toString();
        JsonObject jsonRequest = gson.fromJson(requestBody, JsonObject.class);
        String userInput = jsonRequest.get("message").getAsString();

        // Add user's message to history
        conversationHistory.add(new ChatMessage("user", userInput));

        // 3. Get the response from the chatbot service, now passing the whole history
        String botResponseJson;
        try {
            botResponseJson = chatbotService.getChatbotResponse(conversationHistory);
            
            // 4. Add bot's response to history
            // We need to parse the JSON to get the text content for history
            JsonObject botJsonResponse = gson.fromJson(botResponseJson, JsonObject.class);
            String botTextResponse = extractTextFromBotResponse(botJsonResponse);
            conversationHistory.add(new ChatMessage("model", botTextResponse));

        } catch (IOException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            botResponseJson = "{\"intent\": \"error\", \"message\": \"Xin lỗi, có lỗi xảy ra phía máy chủ. Bạn thử lại sau nhé!\"}";
        }
        
        // 5. Save updated history back to session
        session.setAttribute("conversationHistory", conversationHistory);

        // Send the full JSON response back to the client
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(botResponseJson);
    }

    private String extractTextFromBotResponse(JsonObject botResponse) {
        // This is a helper to get the "displayable" text from the bot's rich response
        // It might be a simple text response, or part of a complex JSON object
        if (botResponse.has("text")) {
            return botResponse.get("text").getAsString();
        }
        if (botResponse.has("intent")) {
            String intent = botResponse.get("intent").getAsString();
            if(intent.equals("create_quiz") && botResponse.has("topic")) {
                return "Đây là câu đố về " + botResponse.get("topic").getAsString() + " nhé!";
            }
             if(intent.equals("suggest_activity") && botResponse.has("prompt")) {
                return botResponse.get("prompt").getAsString();
            }
        }
        // Fallback for other JSON structures
        return "Ok, hãy thực hiện điều đó!";
    }
} 