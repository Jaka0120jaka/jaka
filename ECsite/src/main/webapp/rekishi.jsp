<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Cart" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.Product" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%@include file = "header-navi.jsp"%>
<%
    List<Product> orderList = (List<Product>) request.getAttribute("orderList");

    if (orderList == null || orderList.isEmpty()) {
%>
    <p>注文リストはありません。</p>
<%
    } else {
%>
    <h2>注文一覧（合計 <%= orderList.size() %> 件）</h2>
    <form action="<%= request.getContextPath() %>/order-clear-servlet" method="post"
          onsubmit="return confirm('注文履歴を全て削除しますか？');">
        <input type="submit" value="注文履歴を全て削除">
    </form>
    <br>
    <table border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>商品名</th>
            <th>単価</th>
            <th>数量</th>
            <th>合計金額</th>
            <th>画像</th>
            <th>操作</th>
        </tr>
    <%
        for (Product p : orderList) {
    %>
        <tr>
            <td><%= p.getName() %></td>
            <td><%= p.getPrice() %> 円</td>
            <td><%= p.getQuantity() %></td>
            <td><%= p.getTotalPrice()*p.getQuantity() %> 円</td>
            <td>
			<a href="product-detail.jsp?idx=<%= p.getId() - 1 %>">
				<img src="<%= request.getContextPath() + "/images/" + p.getImg() %>" width="150" height="150">
			</a>
            </td>
            <td>
                <form action="<%= request.getContextPath() %>/order-delete-servlet" method="post"
                      onsubmit="return confirm('この注文を削除しますか？');">
                    <input type="hidden" name="orderId" value="<%= p.getId() %>">
                    <input type="submit" value="削除">
                </form>
            </td>
        </tr>
    <%
        }
    %>
    </table>
<%
    }
%>
<br><br><button type="button" onclick="history.back();">戻る</button>
