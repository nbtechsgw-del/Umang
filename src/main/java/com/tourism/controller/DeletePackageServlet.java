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

@WebServlet("/DeletePackageServlet")
public class DeletePackageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Session Access Security Guard Layer
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendRedirect("login.jsp?error=access_denied");
            return;
        }

        try {
            // 2. Extract the Package ID to be deleted
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect("admin/dashboard.jsp?error=missing_id");
                return;
            }
            int packageId = Integer.parseInt(idParam);

            // 3. Fire Database Deletion Transaction
            PackageDAO packageDAO = new PackageDAO();
            boolean success = packageDAO.deletePackage(packageId);

            if (success) {
                // Redirect back to dashboard to trigger your 'package_deleted' alert message
                response.sendRedirect("admin/dashboard.jsp?status=package_deleted");
            } else {
                response.sendRedirect("admin/dashboard.jsp?error=delete_failed");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("admin/dashboard.jsp?error=invalid_id_format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/dashboard.jsp?error=system_fault");
        }
    }
}