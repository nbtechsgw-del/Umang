package com.tourism.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.tourism.model.TourPackage;
import com.tourism.util.DBConnection;

public class PackageDAO {

    public List<TourPackage> getAllAvailablePackages() {
        List<TourPackage> packageList = new ArrayList<>();
        String sql = "SELECT * FROM tour_packages WHERE status = 'AVAILABLE' ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TourPackage pkg = new TourPackage();
                pkg.setId(rs.getInt("id"));
                pkg.setPackageName(rs.getString("package_name"));
                pkg.setDestination(rs.getString("destination"));
                pkg.setCategory(rs.getString("category"));
                pkg.setPrice(rs.getBigDecimal("price"));
                pkg.setDuration(rs.getString("duration"));
                pkg.setItinerary(rs.getString("itinerary"));
                pkg.setImageUrl(rs.getString("image_url"));
                pkg.setStatus(rs.getString("status"));
                pkg.setCreatedAt(rs.getTimestamp("created_at"));
            
                packageList.add(pkg);
            }
        } catch (SQLException e) {
            System.err.println("Error executing getAllAvailablePackages in PackageDAO");
            e.printStackTrace();
        }
        return packageList;
    }

    public List<TourPackage> getFilteredPackages(String keyword, String category, String maxPriceStr) {
        List<TourPackage> packageList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM tour_packages WHERE status = 'AVAILABLE'");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (package_name LIKE ? OR destination LIKE ?)");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }

        if (category != null && !category.trim().isEmpty() && !"ALL".equals(category)) {
            sql.append(" AND category = ?");
            params.add(category.trim());
        }

        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try {
                double maxPrice = Double.parseDouble(maxPriceStr);
                if (maxPrice > 0) {
                    sql.append(" AND price <= ?");
                    params.add(new java.math.BigDecimal(maxPrice));
                }
            } catch (NumberFormatException e) {
                // Ignore malformed price inputs safely
            }
        }

        sql.append(" ORDER BY created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TourPackage pkg = new TourPackage();
                    pkg.setId(rs.getInt("id"));
                    pkg.setPackageName(rs.getString("package_name"));
                    pkg.setDestination(rs.getString("destination"));
                    pkg.setCategory(rs.getString("category"));
                    pkg.setPrice(rs.getBigDecimal("price"));
                    pkg.setDuration(rs.getString("duration"));
                    pkg.setItinerary(rs.getString("itinerary"));
                    pkg.setImageUrl(rs.getString("image_url"));
                    pkg.setStatus(rs.getString("status"));
                    pkg.setCreatedAt(rs.getTimestamp("created_at"));
                    packageList.add(pkg);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error executing getFilteredPackages in PackageDAO");
            e.printStackTrace();
        }
        return packageList;
    }

    public TourPackage getPackageById(int id) {
        TourPackage pkg = null;
        String sql = "SELECT * FROM tour_packages WHERE id = ?";
    
        java.sql.Connection conn = null;
        java.sql.PreparedStatement ps = null;
        java.sql.ResultSet rs = null;
    
        try {
            conn = com.tourism.util.DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
        
            if (rs.next()) {
                pkg = new TourPackage();
                pkg.setId(rs.getInt("id"));
                pkg.setPackageName(rs.getString("package_name"));
                pkg.setDestination(rs.getString("destination"));
                pkg.setCategory(rs.getString("category"));
                pkg.setPrice(rs.getBigDecimal("price"));
                pkg.setDuration(rs.getString("duration"));
                pkg.setItinerary(rs.getString("itinerary"));
                pkg.setImageUrl(rs.getString("image_url"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return pkg;
    }

    public List<Map<String, Object>> getDestinationSummary() {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT destination, COUNT(*) as package_count FROM packages GROUP BY destination";
    
        java.sql.Connection conn = null;
        java.sql.PreparedStatement ps = null;
        java.sql.ResultSet rs = null;
    
        try {
            conn = com.tourism.util.DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
        
            while (rs.next()) {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("name", rs.getString("destination"));
                map.put("count", rs.getInt("package_count"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return list;
    }

    public boolean updatePackage(TourPackage pkg) {
        String sql = "UPDATE tour_packages SET package_name=?, destination=?, category=?, price=?, duration=?, itinerary=?, image_url=? WHERE id=?";
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pkg.getPackageName());
            ps.setString(2, pkg.getDestination());
            ps.setString(3, pkg.getCategory());
            ps.setBigDecimal(4, pkg.getPrice());
            ps.setString(5, pkg.getDuration());
            ps.setString(6, pkg.getItinerary());
            ps.setString(7, pkg.getImageUrl());
            ps.setInt(8, pkg.getId());
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            }
        return success;
    }

    public boolean addPackage(String name, String category, double price, String duration, String itinerary, int destinationId) {
        String destinationTextName = "Unknown";
        String fetchDestSql = "SELECT name FROM destinations WHERE id = ?";
    
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement psDest = conn.prepareStatement(fetchDestSql)) {
            psDest.setInt(1, destinationId);
            try (ResultSet rs = psDest.executeQuery()) {
                if (rs.next()) {
                    destinationTextName = rs.getString("name");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String sql = "INSERT INTO tour_packages (package_name, destination, category, price, duration, itinerary, destination_id, status) VALUES (?, ?, ?, ?, ?, ?, ?, 'AVAILABLE')";
    
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        
            ps.setString(1, name);
            ps.setString(2, destinationTextName); // Clears the Null = NO constraint on 'destination' column
            ps.setString(3, category);
            ps.setBigDecimal(4, java.math.BigDecimal.valueOf(price));
            ps.setString(5, duration);
            ps.setString(6, itinerary);
        
            if (destinationId > 0) {
                ps.setInt(7, destinationId);
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
        
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Database execution crash trace:");
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletePackage(int id) {
        String sql = "UPDATE tour_packages SET status = 'DELETED' WHERE id = ?";
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            }
        return success;
    }
}