package com.tourism.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import com.tourism.util.DBConnection;

public class AdminDAO {

    public Map<String, Integer> getDashboardMetrics() {
        Map<String, Integer> metrics = new HashMap<>();
        metrics.put("totalPackages", 0);
        metrics.put("totalHotels", 0);
        metrics.put("totalBookings", 0);
        metrics.put("totalUsers", 0);
        metrics.put("pendingFeedback", 0);

        String sqlPackages = "SELECT COUNT(*) FROM tour_packages";
        String sqlHotels = "SELECT COUNT(*) FROM hotels";
        String sqlBookings = "SELECT COUNT(*) FROM bookings";
        String sqlUsers = "SELECT COUNT(*) FROM users WHERE role = 'USER'";
        String sqlFeedback = "SELECT COUNT(*) FROM user_feedbacks WHERE admin_status = 'PENDING'";

        try (Connection conn = DBConnection.getConnection()) {
            
            try (PreparedStatement ps = conn.prepareStatement(sqlPackages); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) metrics.put("totalPackages", rs.getInt(1));
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlHotels); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) metrics.put("totalHotels", rs.getInt(1));
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlBookings); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) metrics.put("totalBookings", rs.getInt(1));
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlUsers); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) metrics.put("totalUsers", rs.getInt(1));
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlFeedback); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) metrics.put("pendingFeedback", rs.getInt(1));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return metrics;
    }
}