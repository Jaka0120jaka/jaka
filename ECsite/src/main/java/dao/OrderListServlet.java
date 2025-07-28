package dao;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.Product;

@WebServlet("/order-history")
public class OrderListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	String userId = (String) request.getSession().getAttribute("userId");

        try {
            OrderGetDao dao = new OrderGetDao();
            List<Product> orderList = dao.findByIDs(userId);// 全件取得のため引数は使わない

            request.setAttribute("orderList", orderList);
            request.getRequestDispatcher("rekishi.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "データの取得に失敗しました");
            request.getRequestDispatcher("rekishi.jsp").forward(request, response);
        }
    }
}
