package com.tourism.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.tourism.dao.UserDAO;
import com.tourism.model.User;
import com.tourism.util.BCryptUtil;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        if (password != null) {
            password = password.trim();
        }
        String secureHashedPassword = BCryptUtil.hashPassword(password);

        System.out.println("--- LOGIN DEBUGGER ---");   
        System.out.println("Raw Input Typed: " + password);
        System.out.println("Generated Hash:  " + secureHashedPassword);
        System.out.println("----------------------");

        User validatedUser = userDAO.validateUser(email, secureHashedPassword);

        if (validatedUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", validatedUser);

        if ("ADMIN".equals(validatedUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid_credentials");
        }
    }
}