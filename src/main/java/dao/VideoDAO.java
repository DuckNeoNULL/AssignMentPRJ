package dao;

import model.EducationalVideo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VideoDAO {

    public List<EducationalVideo> getAllVideos() {
        List<EducationalVideo> videoList = new ArrayList<>();
        String sql = "SELECT * FROM EducationalVideos ORDER BY video_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                EducationalVideo video = new EducationalVideo();
                video.setVideoId(rs.getInt("video_id"));
                video.setTitle(rs.getString("title"));
                video.setDescription(rs.getString("description"));
                video.setYoutubeEmbedUrl(rs.getString("youtube_embed_url"));
                video.setThumbnailPath(rs.getString("thumbnail_path"));
                video.setCategory(rs.getString("category"));
                videoList.add(video);
            }
        } catch (SQLException e) {
            System.err.println("VideoDAO - Lỗi khi lấy danh sách video: " + e.getMessage());
            e.printStackTrace();
        }
        return videoList;
    }
} 