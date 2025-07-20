package model;

import java.io.Serializable;

public class EducationalVideo implements Serializable {

    private static final long serialVersionUID = 1L;

    private int videoId;
    private String title;
    private String description;
    private String youtubeEmbedUrl;
    private String thumbnailPath;
    private String category;

    public EducationalVideo() {
    }

    public EducationalVideo(int videoId, String title, String description, String youtubeEmbedUrl, String thumbnailPath, String category) {
        this.videoId = videoId;
        this.title = title;
        this.description = description;
        this.youtubeEmbedUrl = youtubeEmbedUrl;
        this.thumbnailPath = thumbnailPath;
        this.category = category;
    }

    // Getters and Setters
    public int getVideoId() {
        return videoId;
    }

    public void setVideoId(int videoId) {
        this.videoId = videoId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getYoutubeEmbedUrl() {
        return youtubeEmbedUrl;
    }

    public void setYoutubeEmbedUrl(String youtubeEmbedUrl) {
        this.youtubeEmbedUrl = youtubeEmbedUrl;
    }

    public String getThumbnailPath() {
        return thumbnailPath;
    }

    public void setThumbnailPath(String thumbnailPath) {
        this.thumbnailPath = thumbnailPath;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    /**
     * Converts various YouTube URL formats (e.g., watch?v=, youtu.be/) 
     * into a standard, robust embeddable URL required for iframes.
     * This handles standard links, shortened links, and links with extra parameters.
     * @return A URL safe for embedding in an iframe.
     */
    public String getEmbeddableUrl() {
        if (youtubeEmbedUrl == null || youtubeEmbedUrl.trim().isEmpty()) {
            return "";
        }

        String videoId = null;

        if (youtubeEmbedUrl.contains("youtu.be/")) {
            // Handles URLs like: https://youtu.be/VIDEO_ID
            videoId = youtubeEmbedUrl.substring(youtubeEmbedUrl.lastIndexOf("/") + 1);
        } else if (youtubeEmbedUrl.contains("watch?v=")) {
            // Handles URLs like: https://www.youtube.com/watch?v=VIDEO_ID&t=...
            int startIndex = youtubeEmbedUrl.indexOf("v=") + 2;
            int endIndex = youtubeEmbedUrl.indexOf('&', startIndex);
            if (endIndex == -1) {
                // If there are no other parameters, take the rest of the string
                endIndex = youtubeEmbedUrl.length();
            }
            videoId = youtubeEmbedUrl.substring(startIndex, endIndex);
        } else if (youtubeEmbedUrl.contains("/embed/")) {
            // The URL is already in the correct embed format, so no changes needed.
            return youtubeEmbedUrl;
        }

        if (videoId != null) {
            // Clean up potential query parameters in the videoId itself
            int queryPos = videoId.indexOf('?');
            if (queryPos > -1) {
                videoId = videoId.substring(0, queryPos);
            }
            return "https://www.youtube.com/embed/" + videoId;
        }

        // If the format is not recognized, return the original URL
        return youtubeEmbedUrl;
    }

    @Override
    public String toString() {
        return "EducationalVideo{" +
                "videoId=" + videoId +
                ", title='" + title + '\'' +
                ", category='" + category + '\'' +
                '}';
    }
} 