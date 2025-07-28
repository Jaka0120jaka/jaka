<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登録した商品</title>
</head>
<body>

	<%
	    request.setCharacterEncoding("UTF-8");
	    String u_no = request.getParameter("u_no");
	%>
	
	<%@include file = "header-navi.jsp"%>
	
	<!-- 상품 추가 버튼 -->
	
	
	<!-- 상품 목록 -->
	<%
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    boolean hasResults = false;
	
	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");
	
	        String sql = "SELECT * FROM products WHERE U_NO = ? AND DELETEUN = 'Y'";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, u_no);
	        rs = pstmt.executeQuery();
	
	        while (rs.next()) {
	            hasResults = true;
	            int productId = rs.getInt("id");
	%>
	            <div style="border: 1px solid #ccc; margin: 10px; padding: 10px;">
	                <strong><%= rs.getString("name") %></strong><br>
	                <img src="<%= rs.getString("img") %>" width="100" height="100"><br>
	                価格：<%= rs.getInt("price") %>円<br>
	                在庫：<%= rs.getInt("stock") %><br>
	                説明：<%= rs.getString("description") %><br><br>
	
	                <!-- 수정 버튼 -->
	                <form action="edit_product.jsp" method="get" style="display:inline;">
	                    <input type="hidden" name="id" value="<%= productId %>">
	                    <input type="hidden" name="u_no" value="<%= u_no %>">
	                    <button type="submit">✏ 商品修正</button>
	                </form>
	
	                <!-- 삭제 버튼 -->
	                <form action="delete-product-servlet" method="post" style="display:inline;" onsubmit="return confirm('この商品を削除しますか？');">
	                    <input type="hidden" name="deleteIds" value="<%= productId %>">
	                    <button type="submit">🗑 商品削除</button>
	                </form>
	            </div>
	            
	<%
	        }			
				conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");
				sql = "SELECT * FROM products WHERE U_NO = ? AND DELETEUN = 'N'";
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, u_no);
			    rs = pstmt.executeQuery();
			
			    while (rs.next()) {
			        hasResults = true;
			        int productId = rs.getInt("id");
	%>
			        <div style="border: 1px solid #ccc; margin: 10px; padding: 10px;">
			            <strong><%= rs.getString("name") %></strong><br>
			            <img src="<%= rs.getString("img") %>" width="100" height="100"><br>
			            価格：<%= rs.getInt("price") %>円<br>
			            在庫：<%= rs.getInt("stock") %><br>
			            説明：<%= rs.getString("description") %><br><br>
			            削除済み
			        </div>
	<%
	        	}
	
		        if (!hasResults) {
		%>
		            <p>登録された商品はありません。</p>
		<%
		        }
	
	    } catch (Exception e) {
	        out.println("エラー: " + e.getMessage());
	    } finally {
	        if (rs != null) try { rs.close(); } catch (Exception e) {}
	        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
	        if (conn != null) try { conn.close(); } catch (Exception e) {}
	    }
	%>

</body>
</html>
