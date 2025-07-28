<%@ page pageEncoding="UTF-8"%>
<%@ page import="model.Cart" %>
<%@ page import="model.Store" %>

<!--userId g deer n gargah-->
	<% 
		Store storeHdr = (Store) session.getAttribute("store");
		Cart cartHdr = (Cart) session.getAttribute("cart");
		if ((storeHdr == null) || cartHdr == null) {
			request.setAttribute("errorMsg", "再ログインをお願いします。");	
			request.getRequestDispatcher("login.jsp").forward(request, response);
		} else {
	%>

				
			<%-- navigation bar --%>
			  <a href="my_page.jsp">MyPage</a>
			  <a href="select.jsp">HOME</a>
			  <a href="order-history">ORDERS</a>
			  <a href="logout-servlet">LOG OUT</a>  
			
			  <div id="cart-icon" style="position:fixed; top:10px; right:10px;">
				   <button onclick="location.href='cart.jsp'">
				        🛒 カート (<span id="cart-count">0</span>)
				   </button>
			  </div>  
			
			<hr>
			
	<%
		}
	%>
<!--	Cartnii iconii too nemeh-->
		<script>
				window.addEventListener("DOMContentLoaded", () => {
				    fetch('cart-count-servlet')
				    .then(response => response.json())
				    .then(data => {
				        document.getElementById("cart-count").innerText = data.count;
				    });
				});
		</script>
		