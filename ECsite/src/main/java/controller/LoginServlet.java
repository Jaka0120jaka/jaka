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

import model.Operation;

@WebServlet("/login-servlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		String userId = request.getParameter("userId");
		String password = request.getParameter("password");

		// Login hiih uildel duudah
		HttpSession session = request.getSession();
		Operation op = new Operation();
		boolean result = op.loginProc(userId, password, session);

		// Shiljuuleh gazraa songoh
		String url = "select.jsp";

		if (!result) {
			// login失敗処理
			request.setAttribute("errorMsg", "ユーザID または パスワードに誤りがあります。");
			url = "login.jsp";

		} else {
			// login成功の場合、会員なのか確認　U_DELETEUN＝Yであること　로그인 성공한 경우, 탈퇴 여부 확인
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection(
				    "jdbc:mysql://localhost:3306/ec_site", "root", "password");

				String sql = "SELECT U_DELETEUN FROM user WHERE U_ID = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);
				rs = pstmt.executeQuery();

				if (rs.next()) {
					String delFlag = rs.getString("U_DELETEUN");

					if (!"Y".equals(delFlag)) {
						// 脱退した会員の場合、sessionを初期化しlogin失敗に処理する　탈퇴한 회원이면 세션 초기화하고 로그인 실패 처리
						session.invalidate();
						request.setAttribute("errorMsg", "ユーザID または パスワードに誤りがあります。");
						url = "login.jsp";
					}
				}
			} catch (Exception e) {
				e.printStackTrace(); // エラーデバッグ用　에러 디버깅용
				url = "login.jsp";
			} finally {
				try { if (rs != null) rs.close(); } catch (Exception e) {}
				try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
				try { if (conn != null) conn.close(); } catch (Exception e) {}
			}
		}

		// forward 処理　처리
		request.getRequestDispatcher(url).forward(request, response);
	}
}