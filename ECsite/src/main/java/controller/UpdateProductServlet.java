package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/update-product-servlet")
public class UpdateProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        double price = 0;
        int stock = 0;
        int type = 0;

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String priceParam = request.getParameter("price");
        String stockParam = request.getParameter("stock");
        String desc = request.getParameter("desc");
        String img = request.getParameter("img");
        String typeParam = request.getParameter("type");
        String u_no = request.getParameter("u_no");  // 추가

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {

            price = Double.parseDouble(priceParam);
            stock = Integer.parseInt(stockParam);
            type = Integer.parseInt(typeParam);

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

            String sql = "UPDATE products SET name=?, price=?, stock=?, description=?, img=?, type=? WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setDouble(2, price);  // price는 double로 처리
            pstmt.setInt(3, stock);      // stock은 int
            pstmt.setString(4, desc);
            pstmt.setString(5, img);
            pstmt.setInt(6, type);       // type도 int
            pstmt.setInt(7, Integer.parseInt(id));

            int rows = pstmt.executeUpdate();

            PrintWriter out = response.getWriter();
            out.println("<script>");
            if (rows > 0) {
                out.println("alert('商品情報の修正が完了しました。');");
                // u_no를 쿼리스트링에 붙여서 my_search.jsp로 이동
                out.println("location.href='my_search.jsp?u_no=" + u_no + "';");
            } else {
                out.println("alert('修正に失敗しました。');");
                out.println("location.href='my_search.jsp?u_no=" + u_no + "';");
            }
            out.println("</script>");

        } catch (Exception e) {
            e.printStackTrace();
            PrintWriter out = response.getWriter();
            out.println("<script>");
            out.println("alert('エラーが発生しました。');");
            out.println("location.href='my_search.jsp?u_no=" + u_no + "';");
            out.println("</script>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
}

