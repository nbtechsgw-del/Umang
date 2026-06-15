package com.tourism.controller;

import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.tourism.dao.PackageDAO;
import com.tourism.model.TourPackage;

@WebServlet("/EditPackageServlet")
public class EditPackageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PackageDAO packageDAO;

    public void init() {
        packageDAO = new PackageDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String packageName = request.getParameter("packageName");
        String destination = request.getParameter("destination");
        String category = request.getParameter("category");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        String duration = request.getParameter("duration");
        String itinerary = request.getParameter("itinerary");
        String imageUrl = request.getParameter("imageUrl");

        TourPackage pkg = new TourPackage();
        pkg.setId(id);
        pkg.setPackageName(packageName);
        pkg.setDestination(destination);
        pkg.setCategory(category);
        pkg.setPrice(price);
        pkg.setDuration(duration);
        pkg.setItinerary(itinerary);
        pkg.setImageUrl(imageUrl);

        boolean success = packageDAO.updatePackage(pkg);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?status=package_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?status=update_failed");
        }
    }
}