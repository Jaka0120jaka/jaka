package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/delete-user-servlet")
public class DeleteUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

			HttpSession session = request.getSession();
			String userId = (String) session.getAttribute("userId");

			if (userId == null) {
				response.sendRedirect("login.jsp");
				return;
			}

			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

				// 1. U_GRADEの確認　管理者なのか一般会員なのか
				String checkSql = "SELECT U_GRADE FROM user WHERE U_ID = ?";
				pstmt = conn.prepareStatement(checkSql);
				pstmt.setString(1, userId);
				rs = pstmt.executeQuery();

				if (rs.next()) {
					int grade = rs.getInt("U_GRADE");

					if (grade == 1) {
						// U_GRADE=1 管理者の場合、削除できないように
						response.setContentType("text/html; charset=UTF-8");
						response.getWriter().println("<script>alert('管理者アカウントは削除できません。'); "
								+ "location.href='my_page.jsp';</script>");
						return;
					}
				}

				// 2. 削除処理 U_DELETEUNを'N'に修正
				rs.close();
				pstmt.close();

				String deleteSql = "UPDATE user SET U_DELETEUN = 'N' WHERE U_ID = ?";
				pstmt = conn.prepareStatement(deleteSql);
				pstmt.setString(1, userId);
				pstmt.executeUpdate();

				// session削除後login.jspに
				session.invalidate();
				response.setContentType("text/html; charset=UTF-8");
				response.getWriter().println("<script>alert('ご利用ありがとうございました。'); location.href='login.jsp';</script>");

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try { if (rs != null) rs.close(); } catch (Exception e) {}
				try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
				try { if (conn != null) conn.close(); } catch (Exception e) {}
			}
		}
	}
