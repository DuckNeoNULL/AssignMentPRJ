package model;

public class ChatMessage {
    private String role;
    private String text;

    public ChatMessage(String role, String text) {
        this.role = role;
        this.text = text;
    }

    // Getters and setters
    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
} 