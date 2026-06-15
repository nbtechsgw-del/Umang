package com.tourism.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.tourism.util.DBConnection;

@WebServlet("/UpdateBookingStatusServlet")
public class UpdateBookingStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        String action = request.getParameter("action");

        if (bookingIdStr != null && action != null) {
            Connection conn = null;
            PreparedStatement ps = null;
            
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                String status;
                if ("APPROVE".equalsIgnoreCase(action) || "APPROVED".equalsIgnoreCase(action)) {
                    status = "APPROVED"; 
                } else {
                    status = "CANCELLED";
                }
                
                String sql = "UPDATE bookings SET status = ? WHERE id = ?";
                
                conn = DBConnection.getConnection();
                ps = conn.prepareStatement(sql);
                ps.setString(1, status);
                ps.setInt(2, bookingId);
                ps.executeUpdate();
                
            } catch (Exception e) {
                System.err.println("Error processing update within UpdateBookingStatusServlet");
                e.printStackTrace();
            } finally {
                // Classic explicit resource teardown safe for Tomcat 7's execution model
                try { if (ps != null) ps.close(); } catch (SQLException e) {}
                try { if (conn != null) conn.close(); } catch (SQLException e) {}
            }
        }
        
        // Redirect seamlessly back to the administrator panel grid view
        response.sendRedirect("admin/dashboard.jsp");
    }
}