<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Store" %>
<%@ page import="model.Product" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CAL_EC site</title>
<link rel="stylesheet" href="style/select.css">
</head>
<style>
</style>
<body>

	
	<%@include file = "header-navi.jsp"%>
		  <form action="search.jsp" method="get">
		    <input type="text" name="keyword" placeholder="検索する商品の名前を入力してください。" />
		    <button type="submit">検索</button>
		  </form>
	<%
    // 수정 모드 파라미터
    String editModeParam = request.getParameter("editMode");
    boolean isEditMode = "true".equals(editModeParam);	
    %>
    <div class="products-type">
	   <!-- 商品のカテゴリー -->
	   <a href="product_type.jsp?type=1">パソコン（本体）</a>｜
	   <a href="product_type.jsp?type=2">周辺機器</a>｜
	   <a href="product_type.jsp?type=3">部品</a>｜
	   <a href="product_type.jsp?type=4">その他</a>
	  
	  </div>
	<%	
	
		List<Product> listProd;
		Store store = (Store) session.getAttribute("store");
		
		 List<Product> updatedList = store.loadProductsFromDB();
	        store.setListProd(updatedList);
	        session.setAttribute("store", store);
		
		if (store == null) {
			listProd = new ArrayList<Product>();
		} else {
			listProd = store.getListProd();
		}
		if (listProd.size() > 0) {
			
			
	%>

		<h2>Products</h2>

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
		}
	%>
	
	
	<script>

			function addToCart(idx) {
			    fetch('add-prod-servlet', {
			        method: 'POST',
			        headers: {
			            'Content-Type': 'application/x-www-form-urlencoded'
			        },
			        body: 'idx=' + idx
			    })
			    .then(response => response.json())
			    .then(data => {
			        document.getElementById("cart-count").innerText = data.count;
			    })
			    .catch(error => console.error('カート追加失敗:', error));
			}




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