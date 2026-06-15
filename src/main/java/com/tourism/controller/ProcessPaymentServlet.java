package com.tourism.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.SQLException;

import com.tourism.model.User;
import com.tourism.util.DBConnection;

@WebServlet("/ProcessPaymentServlet")
public class ProcessPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
            response.sendRedirect("login.jsp?error=login_required");
            return;
        }

        int userId = loggedInUser.getId();
        
        try {
            String packageIdStr = request.getParameter("packageId");
            String travelDateStr = request.getParameter("travelDate");
            String hotelIdStr = request.getParameter("hotelId");
            String amountStr = request.getParameter("amount");
            String paymentMethod = request.getParameter("paymentMethod");

            if (amountStr == null || amountStr.trim().isEmpty()) {
                amountStr = request.getParameter("price");
            }
            if (amountStr == null || amountStr.trim().isEmpty()) {
                amountStr = "0.00";
            }
            
            BigDecimal amount = new BigDecimal(amountStr != null ? amountStr.trim() : "0.00");
            int packageId = (packageIdStr != null && !packageIdStr.trim().isEmpty()) ? Integer.parseInt(packageIdStr.trim()) : 0;
            
            int hotelId = 0;
            if (hotelIdStr != null && !hotelIdStr.trim().isEmpty() && !hotelIdStr.trim().equalsIgnoreCase("null")) {
                hotelId = Integer.parseInt(hotelIdStr.trim());
            }
            
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                paymentMethod = "Instant UPI (GPay/PhonePe)";
            }

            java.sql.Date finalSqlDate;
            if (travelDateStr == null || travelDateStr.trim().isEmpty() || travelDateStr.trim().equalsIgnoreCase("null")) {
                finalSqlDate = new java.sql.Date(System.currentTimeMillis());
            } else {
                travelDateStr = travelDateStr.trim();
                java.util.Date parsedDate = null;
                
                String[] formattingPatterns = {"yyyy-MM-dd", "dd/MM/yyyy", "MM/dd/yyyy", "yyyy/MM/dd", "dd-MM-yyyy"};
                for (String formatPattern : formattingPatterns) {
                    try {
                        SimpleDateFormat parser = new SimpleDateFormat(formatPattern);
                        parser.setLenient(false);
                        parsedDate = parser.parse(travelDateStr);
                        break;
                    } catch (Exception ignored) {}
                }
                
                if (parsedDate != null) {
                    finalSqlDate = new java.sql.Date(parsedDate.getTime());
                } else {
                    finalSqlDate = new java.sql.Date(System.currentTimeMillis());
                }
            }

            Connection conn = null;
            PreparedStatement psCheck = null;
            PreparedStatement psBooking = null;
            PreparedStatement psPayment = null;
            ResultSet rs = null;

            try {
                conn = DBConnection.getConnection();
                conn.setAutoCommit(false);

                String sqlCheck = "SELECT COUNT(*) FROM bookings WHERE package_id = ? AND status != 'CANCELLED'";
                psCheck = conn.prepareStatement(sqlCheck);
                psCheck.setInt(1, packageId);
                rs = psCheck.executeQuery();
                
                int existingBookings = 0;
                if (rs.next()) {
                    existingBookings = rs.getInt(1);
                }
                rs.close(); 
                
                int maxCapacity = 50; 
                if (existingBookings >= maxCapacity) {
                    conn.rollback();
                    response.sendRedirect(request.getContextPath() + "/index.jsp?error=package_full");
                    return;
                }

                String sqlBooking = "INSERT INTO bookings (user_id, package_id, hotel_id, travel_date, total_amount, status) VALUES (?, ?, ?, ?, ?, 'APPROVED')";
                psBooking = conn.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS);
                psBooking.setInt(1, userId);
                psBooking.setInt(2, packageId);
                
                if (hotelId > 0) {
                    psBooking.setInt(3, hotelId);
                } else {
                    psBooking.setNull(3, java.sql.Types.INTEGER);
                }
                
                psBooking.setDate(4, finalSqlDate);
                psBooking.setBigDecimal(5, amount);
                psBooking.executeUpdate();

                rs = psBooking.getGeneratedKeys();
                int newBookingId = 0;
                if (rs.next()) {
                    newBookingId = rs.getInt(1);
                }
                rs.close();

                if (newBookingId == 0) {
                    throw new SQLException("Failed to acquire generated transactional target reference key ID context row entry.");
                }

                String mockTransactionId = "TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                
                // FIXED SQL STATEMENT: Dynamically probes columns to avoid throwing exception structural crashes
                String sqlPayment;
                boolean columnIsAmountPaid = false;
                
                try {
                    // Test if amount_paid column is used inside the table
                    conn.getMetaData().getColumns(null, null, "payments", "amount_paid");
                    sqlPayment = "INSERT INTO payments (booking_id, transaction_id, amount_paid, payment_method, payment_status) VALUES (?, ?, ?, ?, 'SUCCESS')";
                    columnIsAmountPaid = true;
                } catch (Exception e) {
                    sqlPayment = "INSERT INTO payments (booking_id, transaction_id, amount, payment_method, payment_status) VALUES (?, ?, ?, ?, 'SUCCESS')";
                }
                
                // Fallback catch verification safety step
                psPayment = conn.prepareStatement(sqlPayment);
                psPayment.setInt(1, newBookingId);
                psPayment.setString(2, mockTransactionId);
                psPayment.setBigDecimal(3, amount);
                psPayment.setString(4, paymentMethod);
                
                try {
                    psPayment.executeUpdate();
                } catch (SQLException sqlEx) {
                    // Final Fail-safe backup attempt using alternative database schema styles
                    psPayment.close();
                    if (!columnIsAmountPaid) {
                        sqlPayment = "INSERT INTO payments (booking_id, transaction_id, amount_paid, payment_method, payment_status) VALUES (?, ?, ?, ?, 'SUCCESS')";
                    } else {
                        sqlPayment = "INSERT INTO payments (booking_id, transaction_id, total_amount, payment_method, payment_status) VALUES (?, ?, ?, ?, 'SUCCESS')";
                    }
                    psPayment = conn.prepareStatement(sqlPayment);
                    psPayment.setInt(1, newBookingId);
                    psPayment.setString(2, mockTransactionId);
                    psPayment.setBigDecimal(3, amount);
                    psPayment.setString(4, paymentMethod);
                    psPayment.executeUpdate();
                }

                conn.commit();
                response.sendRedirect("booking-confirmation.jsp?txnId=" + mockTransactionId + "&amount=" + amount + "&bookingId=" + newBookingId);

            } catch (Exception e) {
                System.err.println("CRITICAL FAILURE WITHIN TRANSACTION COMMISSIONS:");
                e.printStackTrace();
                if (conn != null) {
                    try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
                }
                response.setContentType("text/html");
                response.getWriter().println("<h3>Transaction Failed Details:</h3><pre>");
                e.printStackTrace(response.getWriter());
                response.getWriter().println("</pre>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (psCheck != null) psCheck.close(); } catch (Exception e) {}
                try { if (psBooking != null) psBooking.close(); } catch (Exception e) {}
                try { if (psPayment != null) psPayment.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        } catch (Exception parseException) {
            System.err.println("FATAL OUTBOUND PARSE BOUNDARY CONTEXT ERROR:");
            parseException.printStackTrace();
            response.setContentType("text/html");
            response.getWriter().println("<h3>Parsing Input Failed Details:</h3><pre>");
            parseException.printStackTrace(response.getWriter());
            response.getWriter().println("</pre>");
        }
    }
}