package com.tourism.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.tourism.model.Hotel;
import com.tourism.model.HotelBooking;
import com.tourism.util.DBConnection;

public class HotelDAO {

    public List<Hotel> getAllAvailableHotels() {
    List<Hotel> hotelList = new ArrayList<>();
    String sql = "SELECT * FROM hotels ORDER BY id DESC"; // Kept filterless for testing
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        int recordCounter = 0;
        while (rs.next()) {
            recordCounter++;
            Hotel h = new Hotel();
            h.setId(rs.getInt("id"));
            h.setHotelName(rs.getString("hotel_name"));
            h.setDestination(rs.getString("destination"));
            h.setStars(rs.getInt("stars"));
            h.setPricePerNight(rs.getBigDecimal("price_per_night"));
            h.setStatus(rs.getString("status"));
            hotelList.add(h);
        }
        
        System.out.println("--- HotelDAO Log: Found " + recordCounter + " total rows in database table ---");
        
    } catch (SQLException e) {
        System.err.println("CRITICAL: SQL Extraction crashed!");
        e.printStackTrace();
    }
    return hotelList;
}


    public List<Hotel> getHotelsByDestination(String destination) {
        List<Hotel> hotelList = new ArrayList<>();
        String sql = "SELECT * FROM hotels WHERE status = 'AVAILABLE' AND destination LIKE ? ORDER BY stars DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + destination.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Hotel h = new Hotel();
                    h.setId(rs.getInt("id"));
                    h.setHotelName(rs.getString("hotel_name"));
                    h.setDestination(rs.getString("destination"));
                    h.setStars(rs.getInt("stars"));
                    h.setPricePerNight(rs.getBigDecimal("price_per_night"));
                    h.setStatus(rs.getString("status"));
                    hotelList.add(h);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotelList;
    }

    public boolean addHotel(Hotel h) {
        String sql = "INSERT INTO hotels (hotel_name, destination, stars, price_per_night, status) VALUES (?, ?, ?, ?, 'AVAILABLE')";
        boolean rowInserted = false;
        try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, h.getHotelName());
            ps.setString(2, h.getDestination());
        
            ps.setInt(3, h.getStars()); 
            ps.setBigDecimal(4, h.getPricePerNight());
        
            rowInserted = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowInserted;
    }

    public List<HotelBooking> getAllHotelBookings() {
    List<HotelBooking> reservationList = new ArrayList<>();
    // Note: Verify if your column name is 'status' or 'booking_status' in MySQL. 
    // If it is 'status', change hb.booking_status to hb.status below:
    String sql = "SELECT hb.id, hb.hotel_id, hb.user_id, hb.check_in_date, hb.check_out_date, " +
                 "hb.room_type, hb.total_price, hb.booking_status, h.hotel_name, u.full_name " +
                 "FROM hotel_bookings hb " +
                 "JOIN hotels h ON hb.hotel_id = h.id " +
                 "JOIN users u ON hb.user_id = u.id ORDER BY hb.id DESC";

    try (Connection conn = com.tourism.util.DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
    
        while (rs.next()) {
            HotelBooking res = new HotelBooking();
            res.setId(rs.getInt("id"));
            res.setHotelId(rs.getInt("hotel_id"));
            res.setUserId(rs.getInt("user_id"));
            res.setHotelName(rs.getString("hotel_name"));
            res.setCustomerName(rs.getString("full_name"));
            res.setCheckInDate(rs.getDate("check_in_date"));
            res.setCheckOutDate(rs.getDate("check_out_date"));
            res.setRoomType(rs.getString("room_type"));
            res.setTotalPrice(rs.getBigDecimal("total_price"));
            
            res.setBookingStatus(rs.getString("booking_status")); 
            
            reservationList.add(res);
        }
    } catch (Exception e) {
        System.err.println("Exception inside HotelDAO.getAllHotelBookings");
        e.printStackTrace();
    }
    return reservationList;
}

    public boolean updateReservationStatus(int bookingId, String targetStatus) {
        String sql = "UPDATE hotel_bookings SET booking_status = ? WHERE id = ?";
        boolean executed = false;
    
        try (Connection conn = com.tourism.util.DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        
            ps.setString(1, targetStatus);
            ps.setInt(2, bookingId);
            executed = ps.executeUpdate() > 0;
        
        } catch (Exception e) {
            System.err.println("Exception processing status update sequence in HotelDAO");
            e.printStackTrace();
        }
        return executed;
    }
}