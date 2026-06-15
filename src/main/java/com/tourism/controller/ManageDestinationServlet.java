package com.tourism.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.tourism.dao.DestinationDAO;
import com.tourism.model.Destination;

@WebServlet("/ManageDestinationServlet")
public class ManageDestinationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DestinationDAO destinationDAO = new DestinationDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String stateCountry = request.getParameter("stateCountry");
        String description = request.getParameter("description");

        Destination dest = new Destination(name, stateCountry, description);
        boolean isSaved = destinationDAO.addDestination(dest);

        if (isSaved) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-destinations.jsp?status=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-destinations.jsp?status=error");
        }
    }
}