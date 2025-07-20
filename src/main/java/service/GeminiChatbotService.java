package service;

import com.google.gson.Gson;
import java.util.stream.Collectors;
import model.ChatMessage;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

import java.io.IOException;
import java.io.InputStream;
import java.text.BreakIterator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.regex.Pattern;
import org.json.JSONArray;
import org.json.JSONObject;

public class GeminiChatbotService {

    private static final String API_KEY;
    private static final String API_URL;
    private static final OkHttpClient client = new OkHttpClient();
    private static final Gson gson = new Gson();

    static {
        Properties props = new Properties();
        String apiKeyTemp = null;
        try (InputStream input = GeminiChatbotService.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                System.err.println("Sorry, unable to find config.properties");
                // Handle error appropriately, maybe throw a runtime exception
            } else {
                props.load(input);
                apiKeyTemp = props.getProperty("gemini.api.key");
            }
        } catch (IOException ex) {
            ex.printStackTrace();
            // Handle error appropriately
        }
        API_KEY = apiKeyTemp;
        // Corrected the model name to match the one from the successful curl command.
        API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + API_KEY;
    }

    // Helper classes for JSON serialization with Gson
    private static class GeminiRequest {
        List<Content> contents;
        SystemInstruction system_instruction;

        GeminiRequest(List<Content> contents, SystemInstruction systemInstruction) {
            this.contents = contents;
            this.system_instruction = systemInstruction;
        }
    }

    private static class Content {
        String role;
        List<Part> parts;

        Content(String role, String text) {
            this.role = role;
            this.parts = Collections.singletonList(new Part(text));
        }
    }

    private static class Part {
        String text;

        Part(String text) {
            this.text = text;
        }
    }
    
    private static class SystemInstruction {
        List<Part> parts;
        SystemInstruction(String text) {
            this.parts = Collections.singletonList(new Part(text));
        }
    }


    private String getSystemPrompt() {
        // Reverted to traditional string concatenation for Java 11 compatibility.
        return "Bạn là Kiki, một người bạn ảo thông minh, thân thiện... (phần đầu giữ nguyên)" +
                "**## Nhân cách của bạn:**\\n" +
                "- **Thân thiện & Tích cực:** Luôn dùng ngôn ngữ trong sáng, vui vẻ, dễ hiểu. Khuyến khích và động viên trẻ.\\n" +
                "- **Sáng tạo & Tò mò:** Luôn khơi gợi trí tưởng tượng của trẻ.\\n" +
                "- **An toàn là trên hết:** Tuyệt đối không sử dụng từ ngữ người lớn, bạo lực, tiêu cực hoặc các chủ đề phức tạp. Nếu gặp chủ đề không phù hợp, hãy nhẹ nhàng lái sang chuyện khác.\\n\\n" +
                "**## Nhiệm vụ chính của bạn:**\n" +
                "Phân tích kỹ yêu cầu của người dùng và LUÔN LUÔN trả về một đối tượng JSON duy nhất. KHÔNG bao giờ trả về văn bản thuần túy.\n\n" +
                "**## Cấu trúc JSON trả về:**\n" +
                "{\n" +
                "  \"displayText\": \"<Nội dung văn bản chính để hiển thị cho người dùng>\",\n" +
                "  \"intent\": \"<intent được xác định, ví dụ: 'navigate', 'create_quiz', 'simple_chat'>\",\n" +
                "  \"data\": { <Đối tượng chứa dữ liệu chi tiết cho intent, ví dụ: {\"destination\": \"home\"}> },\n" +
                "  \"suggestions\": [\n" +
                "    { \"label\": \"<Nhãn nút 1>\", \"value\": \"<Giá trị gửi đi khi nhấn nút 1>\" },\n" +
                "    { \"label\": \"<Nhãn nút 2>\", \"value\": \"<Giá trị gửi đi khi nhấn nút 2>\" }\n" +
                "  ]\n" +
                "}\n\n" +
                "**## Giải thích các trường:**\n" +
                "- `displayText`: Luôn luôn có. Đây là câu trả lời chính của bạn.\n" +
                "- `intent`: Phân loại ý định của người dùng. Nếu chỉ là trò chuyện thông thường, hãy dùng `simple_chat`.\n" +
                "- `data`: Đối tượng chứa thông tin cần thiết cho intent. Ví dụ, với intent `navigate`, data sẽ chứa `{\"destination\": \"create_post\"}`.\n" +
                "- `suggestions`: (Tùy chọn) Một mảng các nút bấm gợi ý hành động tiếp theo. Hãy chủ động gợi ý các chức năng thú vị!\n\n" +
                "**## Danh sách Intent và cấu trúc `data` tương ứng:**\n\n" +
                "- **intent: `simple_chat`**: Khi người dùng chỉ chào hỏi, tâm sự.\n" +
                "  - `data`: {}\n\n" +
                "- **intent: `navigate`**: Khi người dùng muốn đi đến trang khác.\n" +
                "  - `data`: `{\"destination\": \"<'home'|'create_post'|...|'manage_account'>\"}`\n\n" +
                "- **intent: `start_post_creation`**: Khi người dùng muốn tạo bài đăng.\n" +
                "  - `data`: `{\"content\": \"<Nội dung ban đầu>\"}`\n\n" +
                "- **intent: `manage_account`**: Khi người dùng muốn quản lý tài khoản.\n" +
                "  - `data`: `{\"action\": \"<'update_info'|'change_password'>\"}`\n\n" +
                "- **intent: `interactive_quiz`**: Khi người dùng yêu cầu một câu đố.\n" +
                "  - Kích hoạt bởi: \"đố vui\", \"câu đố\", \"kiểm tra kiến thức\"\n" +
                "  - `data`: {\n" +
                "      \"topic\": \"<chủ đề câu đố>\",\n" +
                "      \"question\": \"<Nội dung câu hỏi>\",\n" +
                "      \"options\": [\"<Lựa chọn A>\", \"<Lựa chọn B>\", \"<Lựa chọn C>\"],\n" +
                "      \"answer\": \"<Lựa chọn đúng>\"\n" +
                "    }\n" +
                "\n" +
                "- **intent: `submit_quiz_answer`**: (Chỉ do frontend gửi lên, không phải do người dùng gõ) Khi người dùng trả lời một câu đố.\n" +
                "  - `data`: {\n" +
                "      \"question\": \"<Câu hỏi đã được hỏi>\",\n" +
                "      \"answer\": \"<Câu trả lời của người dùng>\",\n" +
                "      \"correct_answer\": \"<Đáp án đúng>\"\n" +
                "    }\n" +
                "  - **Logic của bạn:** So sánh `answer` và `correct_answer`. Trả về một `displayText` chúc mừng hoặc giải thích đáp án đúng. Sau đó, gợi ý các hành động tiếp theo như \"Tiếp tục câu đố mới\" hoặc \"Dừng lại\".\n" +
                "\n" +
                "**VÍ DỤ:**\n" +
                "User: \"Chán quá Kiki ơi\"\n" +
                "Kiki (JSON response):\n" +
                "{\n" +
                "  \"displayText\": \"Oh, chán à? Đừng lo, Kiki có nhiều trò vui lắm! Bạn muốn thử gì nào?\",\n" +
                "  \"intent\": \"suggest_activity\",\n" +
                "  \"data\": {},\n" +
                "  \"suggestions\": [\n" +
                "    { \"label\": \"Kể chuyện\", \"value\": \"Kể cho tớ một câu chuyện\" },\n" +
                "    { \"label\": \"Vẽ tranh\", \"value\": \"Mở trang vẽ\" },\n" +
                "    { \"label\": \"Đố vui\", \"value\": \"Cho tớ một câu đố về động vật\" }\n" +
                "  ]\n" +
                "}\n";
    }

    public String getChatbotResponse(List<ChatMessage> conversationHistory) throws IOException {
        String systemPrompt = getSystemPrompt();

        // Convert List<ChatMessage> to List<Content>
        List<Content> contents = conversationHistory.stream()
                .map(msg -> new Content(msg.getRole(), msg.getText()))
                .collect(Collectors.toList());

        // Create the request payload object
        GeminiRequest payload = new GeminiRequest(contents, new SystemInstruction(systemPrompt));

        // Serialize the payload to JSON
        String jsonPayload = gson.toJson(payload);

        RequestBody body = RequestBody.create(jsonPayload, MediaType.get("application/json; charset=utf-8"));
        Request request = new Request.Builder()
                .url(API_URL)
                .post(body)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                System.err.println("Unexpected response code: " + response.code());
                String responseBody = response.body() != null ? response.body().string() : "null";
                System.err.println("Response body: " + responseBody);
                throw new IOException("Unexpected code " + response + " Body: " + responseBody);
            }

            String responseBody = response.body().string();
            return extractTextFromGeminiResponse(responseBody);
        }
    }

    private String extractTextFromGeminiResponse(String jsonResponse) {
        try {
            java.util.Map<String, Object> responseMap = gson.fromJson(jsonResponse, java.util.Map.class);
            java.util.List<Object> candidates = (java.util.List<Object>) responseMap.get("candidates");
            if (candidates == null || candidates.isEmpty()) {
                 return "{\"intent\": \"error\", \"message\": \"Xin lỗi, Kiki không thể nghĩ ra câu trả lời ngay bây giờ. Bạn thử lại sau nhé!\"}";
            }
            java.util.Map<String, Object> firstCandidate = (java.util.Map<String, Object>) candidates.get(0);
            java.util.Map<String, Object> content = (java.util.Map<String, Object>) firstCandidate.get("content");
            java.util.List<Object> parts = (java.util.List<Object>) content.get("parts");
            java.util.Map<String, Object> firstPart = (java.util.Map<String, Object>) parts.get(0);
            return (String) firstPart.get("text");
        } catch (Exception e) {
            System.err.println("Error parsing Gemini response: " + e.getMessage());
            return "{\"intent\": \"error\", \"message\": \"Xin lỗi, Kiki đang bị ốm một chút, bạn thử lại sau nhé!\"}";
        }
    }
    
 public JSONObject checkContentSafety(String content) throws IOException {
    // Tạo prompt kiểm duyệt
    String safetyPrompt = "Bạn là hệ thống kiểm duyệt nội dung cho trẻ em (6-12 tuổi).\n" +
        "Phân tích văn bản tiếng Việt sau theo các tiêu chí:\n" +
        "1. Ngôn ngữ không phù hợp\n" +
        "2. Bạo lực/gây hấn\n" +
        "3. Nội dung người lớn\n" +
        "4. Thông tin sai lệch nguy hiểm\n\n" +
        "Trả về JSON với cấu trúc:\n" +
        "{\n" +
        "  \"is_appropriate\": boolean,\n" +
        "  \"risk_level\": 0-5,\n" +
        "  \"flagged_words\": [],\n" +
        "  \"reasons\": []\n" +
        "}\n\n" +
        "Văn bản cần kiểm duyệt: \"" + escapeString(content) + "\"";

    // Tạo nội dung request
    Content userContent = new Content("user", safetyPrompt);
    SystemInstruction systemInstruction = new SystemInstruction("Bạn là hệ thống kiểm duyệt nội dung chuyên nghiệp. Chỉ trả về JSON, không giải thích thêm.");
    
    GeminiRequest payload = new GeminiRequest(
        Collections.singletonList(userContent),
        systemInstruction
    );

    // Gửi request đến Gemini API
    String jsonPayload = gson.toJson(payload);
    RequestBody body = RequestBody.create(jsonPayload, MediaType.get("application/json; charset=utf-8"));
    Request request = new Request.Builder()
        .url(API_URL)
        .post(body)
        .build();

    try (Response response = client.newCall(request).execute()) {
        if (!response.isSuccessful()) {
            throw new IOException("Unexpected code " + response);
        }

        String responseBody = response.body().string();
        return parseSafetyCheckResponse(responseBody);
    }
}

private JSONObject parseSafetyCheckResponse(String jsonResponse) throws IOException {
    try {
        // Parse response từ Gemini
        String geminiTextResponse = extractTextFromGeminiResponse(jsonResponse);
        
        // Gemini trả về JSON dạng string nằm trong text response
        // Nên cần extract đoạn JSON từ response
        String jsonPart = geminiTextResponse.substring(
            geminiTextResponse.indexOf("{"),
            geminiTextResponse.lastIndexOf("}") + 1
        );
        
        return new JSONObject(jsonPart);
    } catch (Exception e) {
        // Fallback nếu có lỗi
        JSONObject fallbackResponse = new JSONObject();
        fallbackResponse.put("is_appropriate", false);
        fallbackResponse.put("risk_level", 3);
        fallbackResponse.put("flagged_words", new JSONArray());
        fallbackResponse.put("reasons", new JSONArray().put("Lỗi hệ thống kiểm duyệt"));
        return fallbackResponse;
    }
}
    private String escapeString(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
} 