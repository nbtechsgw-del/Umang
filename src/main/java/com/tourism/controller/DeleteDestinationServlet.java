package com.tourism.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.tourism.dao.DestinationDAO;

@WebServlet("/DeleteDestinationServlet")
public class DeleteDestinationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DestinationDAO destinationDAO = new DestinationDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                boolean isDeleted = destinationDAO.deleteDestination(id);
                
                if (isDeleted) {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-destinations.jsp?status=delete_success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-destinations.jsp?status=delete_error");
                }
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-destinations.jsp?status=delete_error");
    }
}