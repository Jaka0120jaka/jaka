package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/order-clear-servlet")
public class OrderClearServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final String JDBC_URL = "jdbc:mysql://localhost:3306/ec_site";
    private final String DB_USER = "root";
    private final String DB_PASS = "password";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userId = (String) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            String sql = "DELETE FROM orders WHERE IDs = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("order-history");
    }
}
