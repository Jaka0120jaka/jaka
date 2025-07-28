package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Cart;
import model.Operation;

@WebServlet("/add-prod-servlet")
public class AddProdServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		int idx = Integer.parseInt(request.getParameter("idx"));
		int quantity = Integer.parseInt(request.getParameter("quantity")); // shirhegeer nemeh

		HttpSession session = request.getSession();

		// Baraag toogoor nemeh
		Operation op = new Operation();
		op.addProd(idx, quantity, session);

		Cart cart = (Cart) session.getAttribute("cart");
		int count = cart != null ? cart.getTotalCount() : 0;

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write("{\"count\":" + count + "}");
	}
}
