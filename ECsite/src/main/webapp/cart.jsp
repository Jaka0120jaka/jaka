<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Cart" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.Product" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cart</title>
</head>
<body>
	<%@include file = "header-navi.jsp"%>

	<h2>カート内一覧</h2>

	<%
		List<CartItem> items;
		Cart cart = (Cart) session.getAttribute("cart");
		if (cart == null) {
			items = new ArrayList<CartItem>();
		} else {
			items = cart.getItems();
		}
		if (items.size() > 0) {
	%>
			<table class="cart-list" border="1">
			<tr>
				<th>COUNT</th><th></th><th>PHOTO</th><th>NAME</th><th>PRICE</th><th>DESCRIPTION</th>
			</tr>
	<%
			for (int idx = 0; idx < items.size(); idx++) {
				CartItem item = items.get(idx);
				Product prod = item.getProduct();
	%>
				<tr>
					<td>
						<!-- Zaasan toogoor cartnaas hasah -->
					<form action="remove-prod-servlet" method="POST">
					    <input type="hidden" name="idx" value="<%= idx %>">
					    <input type="number" name="removeQuantity" value="1" min="1" max="<%= item.getQuantity() %>" style="width: 50px;">
					    <input type="submit" value="delete">
					</form>

					</td>
					<td><%= item.getQuantity() %></td>
					<td><a href="product-detail.jsp?idx=<%= prod.getId() - 1 %>">
					<img src="<%= request.getContextPath() + "/images/" + prod.getImg() %>" width="150" height="150">
				    </a></td>
					<td><%= prod.getName() %></td>
					<td><%= prod.getPriceString() %></td>
					<td><%= prod.getDesc() %></td>
				</tr>			
	<%
			}
	%>
			</table>
			<br>
			<form action="payment.jsp" method="post">
				<input type="submit" value="精算"><br>
			</form>
			
			<button type="button" onclick="history.back();">戻る</button>
	<%
		} else {
	%>
			<p>カートの中は空です。</p>
	<%
		}
	%>

</body>
</html>
