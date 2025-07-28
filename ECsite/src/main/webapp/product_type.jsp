<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Product" %>
<%@ page import="model.Store" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>商品一覧</title>
<link rel="stylesheet" href="style/select.css">
<style>
.quantity-control {
  display: inline-flex;
  align-items: center;
  gap: 5px;
}
.quantity-control button {
  width: 30px;
  height: 30px;
  font-size: 18px;
  font-weight: bold;
  cursor: pointer;
}
.naka {
  width: 40px;
}
</style>
</head>
<body>

<%@include file="header-navi.jsp" %>


<div class="products-type">
	   <!-- 商品のカテゴリー -->
	   <a href="product_type.jsp?type=1">パソコン（本体）</a>｜
	   <a href="product_type.jsp?type=2">周辺機器</a>｜
	   <a href="product_type.jsp?type=3">部品</a>｜
	   <a href="product_type.jsp?type=4">その他</a>
	  
	  </div>

<%
    String typeParam = request.getParameter("type");
    int type = 0;

    if (typeParam != null) {
        try {
            type = Integer.parseInt(typeParam);
        } catch (Exception e) {
            out.println("<p>不正なタイプです。</p>");
            return;
        }
    } else {
        out.println("<p>タイプが指定されていません。</p>");
        return;
    }

    Store store = (Store) session.getAttribute("store");
    if (store == null) {
        store = new Store();
    }

    List<Product> listProd = store.loadProductsFromDB(type);
    store.setListProd(listProd);
    session.setAttribute("store", store);

    if (listProd.size() > 0) {
%>

  <div class="products-ul">
    <% for (int idx = 0; idx < listProd.size(); idx++) {
         Product prod = listProd.get(idx);
    %>
		<form onsubmit="addToCart(<%= idx %>, this); return false;">
			<ul class="select-list">
				<li>
				  <a href="product-detail.jsp?idx=<%= idx %>">
					<img src="<%= request.getContextPath() + "/images/" + prod.getImg() %>" width="150" height="150">
				  </a>
				</li>
				<li><%= prod.getName() %></li>
				<li><%= prod.getPriceString() %></li>
				<li><%= prod.getDesc() %></li>
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
    <% } %>
  </div>

<%
    } else {
        out.println("<p>該当する商品がありません。</p>");
    }
%>

<script>
    function changeQuantity(button, delta) {
        const input = button.parentElement.querySelector('input[name="quantity"]');
        let value = parseInt(input.value) || 1;
        value += delta;
        if (value < 1) value = 1;
        input.value = value;
    }

    function addToCart(idx, form) {
        const quantity = form.quantity.value;

        fetch('add-prod-servlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'idx=' + encodeURIComponent(idx) + '&quantity=' + encodeURIComponent(quantity)
        })
        .then(response => response.json())
        .then(data => {
            document.getElementById("cart-count").innerText = data.count;
        })
        .catch(error => console.error('カート追加失敗:', error));
    }
</script>

</body>
</html>
