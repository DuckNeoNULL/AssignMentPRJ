package dao;

import model.AudioStory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AudioStoryDAO {

    public List<AudioStory> getAllStories() throws SQLException {
        List<AudioStory> stories = new ArrayList<>();
        String sql = "SELECT * FROM AudioStories ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AudioStory story = new AudioStory();
                story.setStoryId(rs.getInt("story_id"));
                story.setTitle(rs.getString("title"));
                story.setDescription(rs.getString("description"));
                story.setAudioPath(rs.getString("audio_path"));
                story.setThumbnailPath(rs.getString("thumbnail_path"));
                story.setDurationSeconds(rs.getInt("duration_seconds"));
                story.setCreatedAt(rs.getTimestamp("created_at"));
                stories.add(story);
            }
        }
        // Let the SQLException be thrown to be caught by the servlet
        return stories;
    }

    public AudioStory getStoryById(int storyId) throws SQLException {
        AudioStory story = null;
        String sql = "SELECT * FROM AudioStories WHERE story_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, storyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    story = new AudioStory();
                    story.setStoryId(rs.getInt("story_id"));
                    story.setTitle(rs.getString("title"));
                    story.setDescription(rs.getString("description"));
                    story.setAudioPath(rs.getString("audio_path"));
                    story.setThumbnailPath(rs.getString("thumbnail_path"));
                    story.setDurationSeconds(rs.getInt("duration_seconds"));
                    story.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        }
        return story;
    }
} 