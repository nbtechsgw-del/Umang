package com.tourism.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.tourism.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/BookHotelServlet")
public class BookHotelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
            response.sendRedirect("login.jsp?error=session_expired");
            return;
        }

        // FIX: Changed "admin" to "ADMIN" to match your exact structural role assignment
        if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())) { 
            response.sendRedirect(request.getContextPath() + "/hotels.jsp?error=admin_restriction");
            return;
        }

        String hotelIdStr = request.getParameter("hotelId");
        String roomType = request.getParameter("roomType");
        String checkInStr = request.getParameter("checkInDate");
        String checkOutStr = request.getParameter("checkOutDate");

        try {
            int hotelId = Integer.parseInt(hotelIdStr);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date parsedIn = sdf.parse(checkInStr);
            java.util.Date parsedOut = sdf.parse(checkOutStr);

            long diff = parsedOut.getTime() - parsedIn.getTime();
            long totalNights = diff / (1000 * 60 * 60 * 24);
            if (totalNights <= 0) totalNights = 1;

            BigDecimal ratePerNight = new BigDecimal("120.00"); 
            if("DELUXE".equalsIgnoreCase(roomType)) ratePerNight = new BigDecimal("170.00");
            if("LUXURY".equalsIgnoreCase(roomType)) ratePerNight = new BigDecimal("240.00");
            
            BigDecimal estimatedTotalCost = ratePerNight.multiply(new BigDecimal(totalNights));

            String sql = "INSERT INTO hotel_bookings (hotel_id, user_id, check_in_date, check_out_date, room_type, total_price, booking_status) VALUES (?, ?, ?, ?, ?, ?, 'CONFIRMED')";
            
            try (Connection conn = com.tourism.util.DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                ps.setInt(1, hotelId);
                ps.setInt(2, loggedInUser.getId());
                ps.setDate(3, new java.sql.Date(parsedIn.getTime()));
                ps.setDate(4, new java.sql.Date(parsedOut.getTime()));
                ps.setString(5, roomType);
                ps.setBigDecimal(6, estimatedTotalCost);
                
                ps.executeUpdate();
            }

            response.sendRedirect("hotels.jsp?status=booking_success");
            
        } catch (Exception e) {
            System.err.println("Runtime error processing customer transaction booking workflow sequence");
            e.printStackTrace();
            response.sendRedirect("hotels.jsp?status=error");
        }
    }
}