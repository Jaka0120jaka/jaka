<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Cart" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.OrderDAO" %>

<%
    String paymentMethod = request.getParameter("paymentMethod"); // 支払方法を取得

    Cart paidCart = (Cart) session.getAttribute("pay");
    List<CartItem> orderedItems = null;
    String userId = (String) session.getAttribute("userId");

    if (paidCart != null && userId != null) {
        paidCart.setUserId(userId);  // CartにsetUserId()メソッドが必要
        orderedItems = paidCart.getItems();

        try {
            OrderDAO orderDAO = new OrderDAO();
            orderDAO.insertOrder(paidCart);
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>注文情報の保存中にエラーが発生しました。</p>");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ご注文内容</title>
</head>
<body>

<%@ include file="header-navi.jsp" %>

<h2><%= (paidCart != null ? paidCart.getUserId() : "お客様") %> さん、ご注文ありがとうございました！</h2>

<%
    if (paidCart != null && orderedItems != null && !orderedItems.isEmpty()) {
%>
    <h3>注文内容</h3>
    <table border="1">
        <tr>
            <th>PHOTO</th>
            <th>商品名</th>
            <th>価格</th>
            <th>数量</th>
            <th>小計</th>
        </tr>
<%
        for (CartItem item : orderedItems) {
            Product prod = item.getProduct();
            int quantity = item.getQuantity();
            int subtotal = prod.getPrice() * quantity;
%>
        <tr>
            <td><img src="<%= request.getContextPath() + "/images/" + prod.getImg() %>" width="100" height="100"></td>
            <td><%= prod.getName() %></td>
            <td><%= prod.getPriceString() %></td>
            <td><%= quantity %></td>
            <td><%= String.format("%,d円", subtotal) %></td>
        </tr>
<%
        }
%>
    </table>
    <p>合計金額：<strong><%= paidCart.getTotalPriceString() %></strong></p>
    <h3>選択した支払方法: <%= (paymentMethod != null ? paymentMethod : "未選択") %></h3>
<%
    } else if (paidCart != null) {
%>
    <p>注文された商品が見つかりません。</p>
<%
    } else {
%>
    <p>注文情報が見つかりません。</p>
<%
    }
%>

</body>
</html>
