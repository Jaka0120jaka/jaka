package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CheckIdServlet")
public class CheckIdServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        String id = request.getParameter("id");
        PrintWriter out = response.getWriter();

        // 形式チェック（空やnull、パターン不一致）
        if (id == null || !id.matches("^[a-zA-Z0-9]{4,20}$")) {
            out.print("INVALID");
            return;
        }

        try {
            // ★ JDBCドライバの読み込み（重要）
            Class.forName("com.mysql.cj.jdbc.Driver");

            // DB接続
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ec_site?useSSL=false&serverTimezone=UTC",
                "root", "password"
            );

            // SQL実行
            String sql = "SELECT * FROM user WHERE U_ID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                out.print("EXISTS"); // 既に使用中
            } else {
                out.print("OK");     // 使用可能
            }

            // クローズ処理
            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace(); // ← Tomcatのログを確認して原因を特定
            out.print("ERROR");
        }
    }
}
