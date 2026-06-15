package com.tourism.dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.tourism.model.Booking;
import com.tourism.util.DBConnection;

public class BookingDAO {

    public List<Map<String, Object>> getAllBookingsWithDetails() {
        List<Map<String, Object>> bookingList = new ArrayList<>();
        String sql = "SELECT b.id, u.full_name, p.package_name, b.travel_date, b.total_amount, b.status " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.id " +
                     "JOIN tour_packages p ON b.package_id = p.id " +
                     "ORDER BY b.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("customerName", rs.getString("full_name"));
                map.put("packageName", rs.getString("package_name"));
                map.put("travelDate", rs.getDate("travel_date"));
                map.put("totalAmount", rs.getBigDecimal("total_amount"));
                map.put("status", rs.getString("status"));
            
                bookingList.add(map);
            }
        } catch (SQLException e) {
            System.err.println("Error executing getAllBookingsWithDetails in BookingDAO");
            e.printStackTrace();
        }
        return bookingList;
    }

    public List<Map<String, Object>> getBookingsByUserId(int userId) {
        List<Map<String, Object>> userBookings = new ArrayList<>();
        String sql = "SELECT b.id, p.package_name, p.destination, b.travel_date, b.total_amount, b.status " +
                 "FROM bookings b " +
                 "JOIN tour_packages p ON b.package_id = p.id " +
                 "WHERE b.user_id = ? " +
                 "ORDER BY b.id DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        java.sql.ResultSet resultSet = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            resultSet = ps.executeQuery();
        
            while (resultSet.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", resultSet.getInt("id"));
                map.put("packageName", resultSet.getString("package_name"));
                map.put("destination", resultSet.getString("destination"));
                map.put("travelDate", resultSet.getDate("travel_date"));
                map.put("totalAmount", resultSet.getBigDecimal("total_amount"));
                map.put("status", resultSet.getString("status"));
            
                userBookings.add(map);
            }
        } catch (SQLException e) {
            System.err.println("Error executing getBookingsByUserId in BookingDAO");
            e.printStackTrace();
        } finally {
            try { if (resultSet != null) resultSet.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return userBookings;
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        try (java.sql.Connection conn = DBConnection.getConnection();
            java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
         
            ps.setString(1, status);
            ps.setInt(2, bookingId);
        
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (java.sql.SQLException e) {
            System.err.println("Error running updateBookingStatus in BookingDAO");
            e.printStackTrace();
            return false;
        }
    }

    public boolean saveBooking(Booking booking) {
        String sql = "INSERT INTO bookings (user_id, package_id, hotel_id, travel_date, status, total_amount) VALUES (?, ?, ?, ?, 'PENDING', ?)";
        boolean rowInserted = false;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, booking.getUserId());
            ps.setInt(2, booking.getPackageId());
            ps.setInt(3, booking.getHotelId());
            ps.setDate(4, booking.getTravelDate());
            ps.setBigDecimal(5, booking.getTotalAmount());

            rowInserted = ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error executing saveBooking statement inside BookingDAO");
            e.printStackTrace();
        }
        return rowInserted;
    }
}