package controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    request.setCharacterEncoding("UTF-8");
	    response.setContentType("text/html; charset=UTF-8");

	    String id = request.getParameter("id");
	    String pw = request.getParameter("password");
	    String name = request.getParameter("name");
	    String birth = request.getParameter("birth");
	    String email = request.getParameter("email");
	    String phone = request.getParameter("phone");
	    String addr = request.getParameter("addr");
	    String redirect = request.getParameter("redirect");
	    redirect = "login.jsp";

	    if (id == null || !id.matches("[a-zA-Z0-9]{4,20}") || pw == null || pw.length() < 8 ||
	        name == null || birth == null || email == null || phone == null || addr == null) {
	        request.setAttribute("errorMsg", "入力内容に誤りがあります。");
	        request.getRequestDispatcher("u_register.jsp").forward(request, response);
	        return;
	    }

	    try {
	        // JDBCドライバのロード（try-with-resourcesの外）
	        Class.forName("com.mysql.cj.jdbc.Driver");

	        try (Connection conn = DriverManager.getConnection(
	                "jdbc:mysql://localhost:3306/ec_site?useSSL=false&serverTimezone=UTC",
	                "root", "password")) {

	            conn.setAutoCommit(false);

	            try (PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM user WHERE U_ID = ?")) {
	                checkStmt.setString(1, id);
	                try (ResultSet rs = checkStmt.executeQuery()) {
	                    if (rs.next()) {
	                        request.setAttribute("errorMsg", "すでに使用されているIDです。");
	                        request.getRequestDispatcher("u_register.jsp").forward(request, response);
	                        return;
	                    }
	                }
	            }

	            String nextU_NO = "U00001";
	            try (PreparedStatement maxStmt = conn.prepareStatement("SELECT MAX(U_NO) FROM user FOR UPDATE");
	                 ResultSet rs = maxStmt.executeQuery()) {
	                if (rs.next() && rs.getString(1) != null) {
	                    int numberPart = Integer.parseInt(rs.getString(1).substring(1)) + 1;
	                    nextU_NO = String.format("U%05d", numberPart);
	                }
	            }

	            // パスワードハッシュ
	            MessageDigest md = MessageDigest.getInstance("SHA-256");
	            byte[] hashed = md.digest(pw.getBytes(StandardCharsets.UTF_8));
	            String hashedPw = Base64.getEncoder().encodeToString(hashed);

	            String sql = "INSERT INTO user (U_NO, U_ID, U_PW, U_NAME, U_BIRTH, U_EMAIL, U_PHONE, U_ADDR, U_GRADE, U_DELETEUN) " +
	                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

	            try (PreparedStatement insertStmt = conn.prepareStatement(sql)) {
	                insertStmt.setString(1, nextU_NO);
	                insertStmt.setString(2, id);
	                insertStmt.setString(3, hashedPw);
	                insertStmt.setString(4, name);
	                insertStmt.setString(5, birth);
	                insertStmt.setString(6, email);
	                insertStmt.setString(7, phone);
	                insertStmt.setString(8, addr);
	                insertStmt.setInt(9, 2);
	                insertStmt.setString(10, "Y");

	                int result = insertStmt.executeUpdate();
	                if (result > 0) {
	                    conn.commit();
	                    response.sendRedirect(redirect + "?registered=success");
	                } else {
	                    conn.rollback();
	                    request.setAttribute("errorMsg", "登録に失敗しました。");
	                    request.getRequestDispatcher("u_register.jsp").forward(request, response);
	                }
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        request.setAttribute("errorMsg", "サーバーエラーが発生しました。");
	        request.getRequestDispatcher("u_register.jsp").forward(request, response);
	    }
	}

}
