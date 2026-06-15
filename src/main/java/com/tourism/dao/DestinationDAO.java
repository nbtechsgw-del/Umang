
package com.tourism.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.tourism.model.Destination;
import com.tourism.util.DBConnection;

public class DestinationDAO {
    
    // Add a new destination
    public boolean addDestination(Destination dest) {
        String sql = "INSERT INTO destinations (name, state_country, description) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, dest.getName());
            ps.setString(2, dest.getStateCountry());
            ps.setString(3, dest.getDescription());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Retrieve all destinations to display in a table
    public List<Destination> getAllDestinations() {
        List<Destination> list = new ArrayList<>();
        String sql = "SELECT * FROM destinations ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Destination d = new Destination();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setStateCountry(rs.getString("state_country"));
                d.setDescription(rs.getString("description"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteDestination(int id) {
        String sql = "DELETE FROM destinations WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}