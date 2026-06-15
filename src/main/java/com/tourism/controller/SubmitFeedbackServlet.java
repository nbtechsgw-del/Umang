package com.tourism.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tourism.dao.FeedbackDAO;
import com.tourism.model.Feedback;
import com.tourism.model.User;

@WebServlet("/SubmitFeedbackServlet")
public class SubmitFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FeedbackDAO feedbackDAO;

    public void init() {
        feedbackDAO = new FeedbackDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=session_expired");
            return;
        }

        // Extract and scrub parameters
        String category = request.getParameter("category");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        String ratingStr = request.getParameter("rating");
        String hotelIdStr = request.getParameter("hotelId");
        String packageIdStr = request.getParameter("packageId");

        int rating = 0;
        int hotelId = 0;
        int packageId = 0;

        // Parse with sanity fallbacks
        try {
            if (ratingStr != null && !ratingStr.trim().isEmpty()) rating = Integer.parseInt(ratingStr.trim());
            if (hotelIdStr != null && !hotelIdStr.trim().isEmpty()) hotelId = Integer.parseInt(hotelIdStr.trim());
            if (packageIdStr != null && !packageIdStr.trim().isEmpty()) packageId = Integer.parseInt(packageIdStr.trim());
            
            Feedback f = new Feedback();
            f.setUserId(loggedInUser.getId());
            f.setUserName(loggedInUser.getFullName());
            f.setCategory(category != null ? category.trim() : "REVIEW");
            f.setRating(rating);
            f.setHotelId(hotelId);
            f.setPackageId(packageId);
            f.setSubject(subject != null ? subject.trim() : "");
            f.setMessage(message != null ? message.trim() : "");

            boolean isSaved = feedbackDAO.submitFeedback(f);

            if (isSaved) {
                response.sendRedirect(request.getContextPath() + "/user/profile.jsp?feedbackStatus=feedback_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/profile.jsp?feedbackStatus=feedback_error");
            }
            
        } catch (Exception e) {
            System.err.println("Fatal lifecycle runtime error within SubmitFeedbackServlet processing handling");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp?feedbackStatus=feedback_error");
        }
    }
}