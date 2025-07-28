package controller;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Operation;


@WebServlet("/remove-prod-servlet")
public class RemoveProdServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    request.setCharacterEncoding("UTF-8");

	    int idx = Integer.parseInt(request.getParameter("idx"));
	    HttpSession session = request.getSession();
	    Operation op = new Operation();

	    String rq = request.getParameter("removeQuantity");

	    if (rq != null) {
	        // tohiruulsan toogoor hasah
	        int removeQuantity = 1;
	        try {
	            removeQuantity = Integer.parseInt(rq);
	            if (removeQuantity < 1) removeQuantity = 1;
	        } catch (NumberFormatException e) {
	            removeQuantity = 1;
	        }
	        op.decreaseProdQuantity(idx, removeQuantity, session);
	    } else {
	        // Bugdii n ustgah
	        op.removeProd(idx, session);
	    }

	    // shiljuuleh
	    RequestDispatcher rd = request.getRequestDispatcher("cart.jsp");
	    rd.forward(request, response);
	}


}
