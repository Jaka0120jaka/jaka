<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Product" %>
<%@ page import="java.io.IOException" %>

<%

    String pidParam = request.getParameter("pid");
    if (pidParam == null || pidParam.trim().isEmpty()) {
%>
    <p>商品のIDが届いていないです。</p>
<%
        return;
    }

    int pid = 0;
    try {
        pid = Integer.parseInt(pidParam);
    } catch (NumberFormatException e) {
%>
    <p>間違えた商品のIDです。</p>
<%
        return;
    }

    Product prod = null;
    try {
        prod = Product.getProductById(pid);
    } catch (Exception e) {
        out.println("<p>商品の情報を呼び出す途中エラーが発生しました。</p>");
        
        e.printStackTrace();
        return;
    }

    if (prod == null) {
%>
    <p>商品が存在しません。</p>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品詳細情報</title>
    <style>
    </style>
</head>
<body>
	<%@ include file="header-navi.jsp" %>
	
	<h2><%= prod.getName() %></h2>
	
	<form onsubmit="addToCart(<%= prod.getId() %>, this); return false;">
	    <ul class="select-list">
	        
	        <a href="product-detail.jsp?pid=<%= pid %>">
						<img src="<%= request.getContextPath() + "/images/" + prod.getImg() %>" width="350" height="350">
					  </a>
	        <li><strong>値段:</strong> <%= prod.getPriceString() %></li>
	        <li><strong>説明:</strong> <%= prod.getDesc() %></li>
	        <li>
	            <div class="quantity-control">
	                <button type="button" onclick="changeQuantity(this, -1)">－</button>
	                <input type="text" name="quantity" min="1" value="1" class="naka" required>
	                <button type="button" onclick="changeQuantity(this, 1)">＋</button>
	            </div>
	            <input type="submit" value="カートに追加">
	        </li>
	    </ul>
	</form>
	
	<%
	    String productId = String.valueOf(prod.getId());
	    String sellerUserNo = prod.getU_no();
	    String loginUserNo = (String) session.getAttribute("userNo");
	    Product product = new Product();
	
	    if (loginUserNo == null) {
	%>
	    <p><a href="login.jsp">ログインをしてください。</a></p>
	<%
	    } else if (!loginUserNo.equals(sellerUserNo)) {
	%>
	    <form action="StartChatServlet" method="post">
		    <input type="hidden" name="productId" value="<%= productId %>">
		    <input type="hidden" name="sellerUserNo" value="<%= sellerUserNo %>">
		    <input type="hidden" name="userNo" value="<%= loginUserNo %>">
		    <button type="submit">채팅하기</button>
		</form>





	<%
	    } else {
	%>
	    <p>私の商品</p>
	<%
	    }
	%>
	
	<button type="button" onclick="history.back();">戻る</button>
	
	<script>
	    function changeQuantity(button, delta) {
	        const input = button.parentElement.querySelector('input[name="quantity"]');
	        let value = parseInt(input.value) || 1;
	        value += delta;
	        if (value < 1) value = 1;
	        input.value = value;
	    }
	
	    function addToCart(productId, form) {
	        const quantity = form.quantity.value;
	
	        fetch('add-prod-servlet', {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/x-www-form-urlencoded'
	            },
	            body: 'productId=' + encodeURIComponent(productId) + '&quantity=' + encodeURIComponent(quantity)
	        })
	        .then(response => response.json())
	        .then(data => {
	            alert("カートに追加されました。");
	            document.getElementById("cart-count").innerText = data.count;
	        })
	        .catch(error => console.error('カート追加失敗:', error));
	    }
	</script>

</body>
</html>
