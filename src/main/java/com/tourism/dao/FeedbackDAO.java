package com.tourism.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.sql.Types;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tourism.model.Feedback;
import com.tourism.util.DBConnection;

public class FeedbackDAO {

    public boolean submitFeedback(Feedback feedback) {
        // Safe standard query mapped accurately to 8 placeholders
        String sql = "INSERT INTO user_feedbacks (user_id, user_name, category, rating, hotel_id, tour_id, subject, message, admin_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, feedback.getUserId());
            ps.setString(2, feedback.getUserName());
            ps.setString(3, feedback.getCategory());
            
            // Handle conditional values without breaking placeholder positions
            if ("REVIEW".equalsIgnoreCase(feedback.getCategory())) {
                ps.setInt(4, feedback.getRating());
                
                if (feedback.getHotelId() > 0) ps.setInt(5, feedback.getHotelId());
                else ps.setNull(5, Types.INTEGER);
                
                if (feedback.getPackageId() > 0) ps.setInt(6, feedback.getPackageId());
                else ps.setNull(6, Types.INTEGER);
            } else {
                // Non-reviews default to 0 stars and explicit NULL references for relations
                ps.setInt(4, 0);
                ps.setNull(5, Types.INTEGER);
                ps.setNull(6, Types.INTEGER);
            }
            
            // These positions MUST remain absolute 7 and 8
            ps.setString(7, feedback.getSubject());
            ps.setString(8, feedback.getMessage());
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.err.println("Database Exception within FeedbackDAO -> submitFeedback");
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<java.util.Map<String, Object>> getFeedbackByUserId(int userId) {
        java.util.List<java.util.Map<String, Object>> feedbackList = new java.util.ArrayList<>();
        String sql = "SELECT f.*, h.hotel_name, p.package_name " +
                 "FROM user_feedbacks f " +
                 "LEFT JOIN hotels h ON f.hotel_id = h.id " +
                 "LEFT JOIN tour_packages p ON f.tour_id = p.id " +
                 "WHERE f.user_id = ? ORDER BY f.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> map = new java.util.HashMap<>();
                    map.put("id", rs.getInt("id"));
                    map.put("category", rs.getString("category"));
                    map.put("rating", rs.getInt("rating"));
                    map.put("subject", rs.getString("subject"));
                    map.put("message", rs.getString("message"));
                    map.put("adminStatus", rs.getString("admin_status"));
                    map.put("hotelName", rs.getString("hotel_name"));
                    map.put("packageName", rs.getString("package_name"));
                    feedbackList.add(map);
                }
            }
        } catch (Exception e) {
            System.err.println("Error fetching user feedback logs");
            e.printStackTrace();
        }
        return feedbackList;
    }

    public java.util.List<com.tourism.model.Feedback> getReviewsByPackageId(int packageId) {
        java.util.List<com.tourism.model.Feedback> reviews = new java.util.ArrayList<>();
        String sql = "SELECT * FROM user_feedbacks WHERE category = 'REVIEW' AND tour_id = ? ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        
            ps.setInt(1, packageId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.tourism.model.Feedback f = new com.tourism.model.Feedback();
                    f.setId(rs.getInt("id"));
                    f.setUserName(rs.getString("user_name"));
                    f.setRating(rs.getInt("rating"));
                    f.setSubject(rs.getString("subject"));
                    f.setMessage(rs.getString("message"));
                    f.setSubmissionDate(rs.getTimestamp("submission_date"));
                    reviews.add(f);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public java.util.List<com.tourism.model.Feedback> getReviewsByHotelId(int hotelId) {
        java.util.List<com.tourism.model.Feedback> reviews = new java.util.ArrayList<>();
        String sql = "SELECT * FROM user_feedbacks WHERE category = 'REVIEW' AND hotel_id = ? ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        
            ps.setInt(1, hotelId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.tourism.model.Feedback f = new com.tourism.model.Feedback();
                    f.setId(rs.getInt("id"));
                    f.setUserName(rs.getString("user_name"));
                    f.setRating(rs.getInt("rating"));
                    f.setSubject(rs.getString("subject"));
                    f.setMessage(rs.getString("message"));
                    f.setSubmissionDate(rs.getTimestamp("submission_date"));
                    reviews.add(f);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public List<Map<String, Object>> getAllPublicReviews() {
        List<Map<String, Object>> reviewsList = new ArrayList<>();
        String sql = "SELECT f.*, h.hotel_name, p.package_name " +
                     "FROM user_feedbacks f " +
                     "LEFT JOIN hotels h ON f.hotel_id = h.id " +
                     "LEFT JOIN tour_packages p ON f.tour_id = p.id " +
                     "WHERE f.category = 'REVIEW' " +
                     "ORDER BY f.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("userName", rs.getString("user_name"));
                map.put("rating", rs.getInt("rating"));
                map.put("subject", rs.getString("subject"));
                map.put("message", rs.getString("message"));
                map.put("submissionDate", rs.getTimestamp("submission_date"));
                map.put("hotelName", rs.getString("hotel_name"));
                map.put("packageName", rs.getString("package_name"));
                reviewsList.add(map);
            }
        } catch (Exception e) {
            System.err.println("Error fetching global public reviews inside FeedbackDAO");
            e.printStackTrace();
        }
        return reviewsList;
    }

}