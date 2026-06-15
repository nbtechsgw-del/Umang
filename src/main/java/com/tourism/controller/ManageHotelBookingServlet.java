package com.tourism.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.tourism.dao.HotelDAO;
import com.tourism.model.HotelBooking;

@WebServlet("/ManageHotelBookingServlet")
public class ManageHotelBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HotelDAO dao = new HotelDAO();
        String idStr = request.getParameter("id");
        String action = request.getParameter("action"); 
        
        // 1. Process Updates if Admin triggered an Action
        if (idStr != null && action != null) {
            try {
                int bookingId = Integer.parseInt(idStr);
                String systemState = "CONFIRMED";
                
                if ("CHECK_IN".equalsIgnoreCase(action)) {
                    systemState = "CHECKED_IN";
                } else if ("CHECK_OUT".equalsIgnoreCase(action)) {
                    systemState = "CHECKED_OUT";
                } else if ("CANCEL".equalsIgnoreCase(action)) {
                    systemState = "CANCELLED";
                }
                
                dao.updateReservationStatus(bookingId, systemState);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // 2. Fetch fresh rows and forward directly to page
        List<HotelBooking> hotelBookingsList = dao.getAllHotelBookings();
        request.setAttribute("hotelBookingsList", hotelBookingsList);
        request.getRequestDispatcher("admin/hotel-bookings.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}