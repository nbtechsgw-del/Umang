package com.tourism.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.tourism.dao.HotelDAO;
import com.tourism.model.Hotel;

@WebServlet("/AddHotelServlet")
public class AddHotelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private HotelDAO hotelDAO;

    public void init() {
        hotelDAO = new HotelDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    // 1. These must match the exact 'name' attributes in your HTML form inputs!
    String name = request.getParameter("hotelName");
    String destination = request.getParameter("destination");
    String priceStr = request.getParameter("pricePerNight");

    try {
        Hotel h = new Hotel();
        h.setHotelName(name);
        h.setDestination(destination);
        
        int starsValue = Integer.parseInt(request.getParameter("rating"));
        h.setStars(starsValue); 
        h.setPricePerNight(new java.math.BigDecimal(priceStr));

        boolean success = hotelDAO.addHotel(h);

        if (success) {
            System.out.println("LOG: Hotel saved successfully to database!");
            response.sendRedirect("admin/dashboard.jsp?status=success");
        } else {
            System.out.println("LOG: Database rejected the hotel insertion.");
            response.sendRedirect("admin/add-hotel.jsp?status=fail");
        }
    } catch (Exception e) {
        System.err.println("LOG: Servlet crashed processing numbers or strings!");
        e.printStackTrace();
        response.sendRedirect("admin/add-hotel.jsp?status=error");
    }
}
}