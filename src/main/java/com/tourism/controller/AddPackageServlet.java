package com.tourism.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tourism.dao.PackageDAO;
import com.tourism.model.User;

@WebServlet("/AddPackageServlet")
public class AddPackageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendRedirect("login.jsp?error=access_denied");
            return;
        }

        try {
            String packageName = request.getParameter("packageName");
            String category = request.getParameter("category");
            String duration = request.getParameter("duration");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            
            int destinationId = 0;
            String destIdStr = request.getParameter("destinationId");
            if (destIdStr != null && !destIdStr.trim().isEmpty()) {
                destinationId = Integer.parseInt(destIdStr.trim());
            }

            PackageDAO packageDAO = new PackageDAO();
            
            boolean success = packageDAO.addPackage(packageName, category, price, duration, description, destinationId);

            if (success) {
                response.sendRedirect("admin/dashboard.jsp?status=package_added");
            } else {
                response.sendRedirect("admin/add-package.jsp?error=database_failed");
            }

        } catch (NumberFormatException e) {
            System.err.println("PARAMETER CONVERSION BREAK DETECTED:");
            e.printStackTrace();
            response.sendRedirect("admin/add-package.jsp?error=invalid_pricing_format");
        } catch (Exception e) {
            System.err.println("SERVLET FAULT EXCEPTION TRACE:");
            e.printStackTrace();
            response.sendRedirect("admin/add-package.jsp?error=system_fault");
        }
    }
}