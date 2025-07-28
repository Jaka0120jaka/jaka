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
import jakarta.servlet.http.HttpSession;

import model.User;

@WebServlet("/update-user-servlet")
public class UpdateUserServlet extends HttpServlet {
    /**
     *
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String u_id = request.getParameter("u_id");

        String u_name = request.getParameter("u_name");
        String u_pw = request.getParameter("u_pw");
        String u_email = request.getParameter("u_email");
        String u_phone = request.getParameter("u_phone");
        String u_addr = request.getParameter("u_addr");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

            String sql = "UPDATE user SET U_NAME=?, U_PW=?, U_EMAIL=?, U_PHONE=?, U_ADDR=? WHERE U_ID=? AND U_DELETEUN='Y'";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, u_name);
            pstmt.setString(2, u_pw);
            pstmt.setString(3, u_email);
            pstmt.setString(4, u_phone);
            pstmt.setString(5, u_addr);
            pstmt.setString(6, u_id);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                // sessionの情報もアップデート　
                User user = (User) session.getAttribute("user");

                if (user != null) {
                    user.setU_name(u_name);
                    user.setU_pw(u_pw);
                    user.setU_email(u_email);
                    user.setU_phone(u_phone);
                    user.setU_addr(u_addr);
                    session.setAttribute("user", user);
                }

                // 修正成功だとmy_page.jspに
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('修正に成功しました。'); location.href='my_page.jsp';</script>");
                response.getWriter().flush();
                return;
               
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('修正に失敗しました。'); location.href='select.jsp';</script>");
            response.getWriter().flush();
            return;
            
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
