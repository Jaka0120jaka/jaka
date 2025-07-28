package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Product;
import model.Store;

@WebServlet("/delete-product-servlet")
public class DeleteProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String[] deleteIds = request.getParameterValues("deleteIds");
        HttpSession session = request.getSession();
        Store store = (Store) session.getAttribute("store");

        if (store != null && deleteIds != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

                // ❌ 실제 삭제 금지
                // String sql = "DELETE FROM product WHERE id = ?";

                // ✅ 대신 soft delete 처리
                String sql = "UPDATE products SET DELETEUN = 'N' WHERE id = ?";
                pstmt = conn.prepareStatement(sql);

                for (String idStr : deleteIds) {
                    int id = Integer.parseInt(idStr);
                    pstmt.setInt(1, id);
                    pstmt.executeUpdate();
                }

                // 상품 목록 다시 불러오기
                List<Product> updatedList = store.loadProductsFromDB();
                store.setListProd(updatedList);
                session.setAttribute("store", store);

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }

        response.sendRedirect("my_search.jsp");
    }
}


