package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
        
        // Read the request body to get the user's message
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        
        String requestBody = sb.toString();
        JsonObject jsonRequest = gson.fromJson(requestBody, JsonObject.class);
        String userInput = jsonRequest.get("message").getAsString();

        // Get the response from the chatbot service
        String botResponse;
        try {
            botResponse = chatbotService.getChatbotResponse(userInput);
        } catch (IOException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            botResponse = "{\"intent\": \"error\", \"message\": \"Xin lỗi, có lỗi xảy ra phía máy chủ. Bạn thử lại sau nhé!\"}";
        }

        // Send the response back to the client
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(botResponse);
    }
} 