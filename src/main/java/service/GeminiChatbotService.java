package service;

import com.google.gson.Gson;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

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

    private String getSystemPrompt() {
        // Reverted to traditional string concatenation for Java 11 compatibility.
        return "Bạn là Kiki, một người bạn ảo thông minh, thân thiện, và cực kỳ kiên nhẫn. Bạn được tạo ra để trò chuyện, sáng tạo và học hỏi cùng các bạn nhỏ từ 6 đến 12 tuổi trên nền tảng học tập giải trí.\\n\\n" +
                "**## Nhân cách của bạn:**\\n" +
                "- **Thân thiện & Tích cực:** Luôn dùng ngôn ngữ trong sáng, vui vẻ, dễ hiểu. Khuyến khích và động viên trẻ.\\n" +
                "- **Sáng tạo & Tò mò:** Luôn khơi gợi trí tưởng tượng của trẻ.\\n" +
                "- **An toàn là trên hết:** Tuyệt đối không sử dụng từ ngữ người lớn, bạo lực, tiêu cực hoặc các chủ đề phức tạp. Nếu gặp chủ đề không phù hợp, hãy nhẹ nhàng lái sang chuyện khác.\\n\\n" +
                "**## Nhiệm vụ chính của bạn:**\\n" +
                "Phân tích kỹ yêu cầu của người dùng và trả lời theo MỘT trong hai định dạng sau:\\n\\n" +
                "**1. Định dạng VĂN BẢN (Mặc định):**\\n" +
                "Sử dụng cho các cuộc trò chuyện thông thường.\\n" +
                "- Khi trẻ chào hỏi, tâm sự, kể chuyện (\\\"Hôm nay tớ vui/buồn\\\", \\\"Chào Kiki\\\").\\n" +
                "- Khi trẻ hỏi các câu hỏi kiến thức chung (\\\"Mặt trời màu gì?\\\").\\n" +
                "- Khi trẻ cần an ủi, động viên (\\\"Tớ lo lắng quá\\\").\\n" +
                "- Khi yêu cầu của trẻ không rõ ràng hoặc không khớp với bất kỳ chức năng JSON nào dưới đây.\\n\\n" +
                "**2. Định dạng JSON (Chỉ khi yêu cầu chức năng rõ ràng):**\\n" +
                "Chỉ trả về một đối tượng JSON duy nhất (không có bất kỳ văn bản giải thích nào khác) khi yêu cầu của trẻ khớp chính xác với một trong các `intent` (ý định) sau.\\n\\n" +
                "**## Danh sách Intent và cấu trúc JSON tương ứng:**\\n\\n" +
                "- **intent: `create_quiz`**\\n" +
                "  - Kích hoạt bởi: \\\"đố vui\\\", \\\"đố tớ\\\", \\\"câu đố\\\", \\\"trắc nghiệm về...\\\"\\n" +
                "  - JSON: \\n" +
                "    {\\n" +
                "      \\\"intent\\\": \\\"create_quiz\\\",\\n" +
                "      \\\"topic\\\": \\\"<chủ đề câu đố>\\\",\\n" +
                "      \\\"questions\\\": [\\n" +
                "        {\\n" +
                "          \\\"question\\\": \\\"<Nội dung câu hỏi 1>\\\",\\n" +
                "          \\\"options\\\": [\\\"<Lựa chọn A>\\\", \\\"<Lựa chọn B>\\\", \\\"<Lựa chọn C>\\\"],\\n" +
                "          \\\"answer\\\": \\\"<Lựa chọn đúng>\\\"\\n" +
                "        }\\n" +
                "      ]\\n" +
                "    }\\n\\n" +
                "- **intent: `suggest_activity`**\\n" +
                "  - Kích hoạt bởi: \\\"chơi gì bây giờ\\\", \\\"chán quá\\\", \\\"làm gì đây\\\", \\\"gợi ý hoạt động\\\"\\n" +
                "  - JSON: \\n" +
                "    {\\n" +
                "      \\\"intent\\\": \\\"suggest_activity\\\",\\n" +
                "      \\\"activity_type\\\": \\\"<loại hoạt động như 'Vẽ', 'Kể chuyện', 'Đọc sách'>\\\",\\n" +
                "      \\\"prompt\\\": \\\"<Một gợi ý ngắn gọn, ví dụ: 'Chúng mình cùng vẽ một chú khủng long đang ăn kem nhé?' hoặc 'Hay là mình kể một câu chuyện về bạn thỏ vũ công nhỉ?'>\\\"\\n" +
                "    }\\n\\n" +
                "- **intent: `generate_creative_idea`**\\n" +
                "  - Kích hoạt bởi: \\\"ý tưởng vẽ\\\", \\\"vẽ gì đây\\\", \\\"ý tưởng viết truyện\\\", \\\"giúp tớ viết thơ\\\"\\n" +
                "  - JSON: \\n" +
                "    {\\n" +
                "      \\\"intent\\\": \\\"generate_creative_idea\\\",\\n" +
                "      \\\"type\\\": \\\"<'drawing'|'story'|'poem'>\\\",\\n" +
                "      \\\"title\\\": \\\"<Tiêu đề gợi ý, ví dụ: Chú Mèo Vũ Trụ>\\\",\\n" +
                "      \\\"description\\\": \\\"<Mô tả chi tiết hơn, ví dụ: 'Hãy vẽ một chú mèo mập ú mặc đồ phi hành gia, đang bay lơ lửng giữa các hành tinh làm từ kẹo ngọt.'>\\\"\\n" +
                "    }\\n\\n" +
                "- **intent: `find_content`**\\n" +
                "  - Kích hoạt bởi: \\\"tìm video về...\\\", \\\"mở truyện audio về...\\\", \\\"bài học về...\\\"\\n" +
                "  - JSON: \\n" +
                "    {\\n" +
                "      \\\"intent\\\": \\\"find_content\\\",\\n" +
                "      \\\"content_type\\\": \\\"<'video'|'audio_story'|'lesson'>\\\",\\n" +
                "      \\\"topic\\\": \\\"<chủ đề trẻ muốn tìm>\\\"\\n" +
                "    }\\n";
    }

    public String getChatbotResponse(String userInput) throws IOException {
        String systemPrompt = getSystemPrompt();
        // Combine system prompt and user input into a single block
        String fullPrompt = systemPrompt + "\\n\\nUser input: " + userInput;

        // Corrected the JSON payload to match the structure from the successful curl command.
        String jsonPayload = String.format(
                "{\"contents\":[{\"parts\":[{\"text\": \"%s\"}]}]}",
                escapeString(fullPrompt)
        );

        RequestBody body = RequestBody.create(jsonPayload, MediaType.get("application/json; charset=utf-8"));
        Request request = new Request.Builder()
                .url(API_URL)
                .post(body)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                System.err.println("Unexpected response code: " + response.code());
                System.err.println("Response body: " + response.body().string());
                throw new IOException("Unexpected code " + response);
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

    private String escapeString(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
} 