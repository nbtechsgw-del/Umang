package com.tourism.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.tourism.model.User;
import com.tourism.util.DBConnection;
import com.tourism.util.BCryptUtil;

public class UserDAO {

    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (full_name, email, password, phone, role) VALUES (?, ?, ?, ?, 'CUSTOMER')";
        boolean rowInserted = false;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            String securedHash = BCryptUtil.hashPassword(user.getPassword());
            ps.setString(3, securedHash);
            ps.setString(4, user.getPhone());

            rowInserted = ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error during user registration in UserDAO");
            e.printStackTrace();
        }
        return rowInserted;
    }

    public List<User> getAllRegisteredUsers() {
        List<User> userList = new java.util.ArrayList<>();
        String sql = "SELECT id, full_name, email, phone, role FROM users WHERE UPPER(role) = 'CUSTOMER' ORDER BY id DESC";
    
        java.sql.Connection conn = null;
        java.sql.PreparedStatement ps = null;
        java.sql.ResultSet rs = null;
    
        try {
            conn = com.tourism.util.DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
        
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                userList.add(user);
            }
        } catch (Exception e) {
            System.err.println("Error running getAllRegisteredUsers in UserDAO");
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (java.sql.SQLException e) {}
            try { if (ps != null) ps.close(); } catch (java.sql.SQLException e) {}
            try { if (conn != null) conn.close(); } catch (java.sql.SQLException e) {}
        }
        return userList;
    }

    public User validateUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        User user = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error during user validation in UserDAO");
            e.printStackTrace();
        }
        return user;
    }
}