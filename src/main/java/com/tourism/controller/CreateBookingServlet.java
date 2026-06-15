package com.tourism.controller;

import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.tourism.dao.BookingDAO;
import com.tourism.model.Booking;
import com.tourism.model.User;

@WebServlet("/CreateBookingServlet")
public class CreateBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDAO bookingDAO;

    public void init() {
        bookingDAO = new BookingDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            
            String hotelIdStr = request.getParameter("hotelId");
            int hotelId = (hotelIdStr != null && !hotelIdStr.trim().isEmpty()) ? Integer.parseInt(hotelIdStr) : 0;
            
            String travelDateStr = request.getParameter("travelDate"); 
            
            String totalAmountStr = request.getParameter("totalAmount");
            if (totalAmountStr == null || totalAmountStr.trim().isEmpty()) {
                totalAmountStr = request.getParameter("price");
            }
            BigDecimal totalAmount = (totalAmountStr != null) ? new BigDecimal(totalAmountStr) : BigDecimal.ZERO;
        
            java.sql.Date travelDate = java.sql.Date.valueOf(travelDateStr);

            Booking booking = new Booking();
            booking.setUserId(loggedInUser.getId());
            booking.setPackageId(packageId);
            booking.setHotelId(hotelId);
            booking.setTravelDate(travelDate);
            booking.setStatus("PENDING");
            booking.setTotalAmount(totalAmount);

            boolean isSaved = bookingDAO.saveBooking(booking);

            if (isSaved) {
                response.sendRedirect("booking-success.jsp");
            } else {
                response.sendRedirect("booking-details.jsp?packageId=" + packageId + "&error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=invalid_inputs");
        }
    }
}