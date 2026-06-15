<%@ page import="com.tourism.dao.UserDAO" %>
<%@ page import="com.tourism.model.User" %>
<%@ page import="com.tourism.util.BCryptUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
    User admin = new User();
    admin.setFullName("System Admin");
    admin.setEmail("admin@tourism.com");
    admin.setPassword("admin123"); 
    admin.setPhone("9876543210");

    UserDAO dao = new UserDAO();
    boolean success = dao.registerUser(admin);
    
    if (success) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = com.tourism.util.DBConnection.getConnection();
            ps = conn.prepareStatement("UPDATE users SET role='ADMIN' WHERE email='admin@tourism.com'");
            ps.executeUpdate();
            out.println("<h3>Admin Account Bootstrap Successful! Delete this file and try logging in.</h3>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3>Role update failed: " + e.getMessage() + "</h3>");
        } finally {
            // Manually close resources to support older Java source compliance levels
            if (ps != null) { try { ps.close(); } catch (Exception e) {} }
            if (conn != null) { try { conn.close(); } catch (Exception e) {} }
        }
    } else {
        out.println("<h3>Bootstrap Failed. The email might already exist. Clear the table rows first!</h3>");
    }
%>