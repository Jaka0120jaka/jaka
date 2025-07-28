<%@ page language="java" contentType="text/html; charset=UTF-8"%> 
<%@include file = "header-navi.jsp"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // セッションからログインユーザーのIDを取得
    String userId = (String) session.getAttribute("userId");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>

<html>
<head>
  <title>商品登録</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <h1>商品登録</h1>
  
  <%
  
  	  String u_no = "";	
  
	  Class.forName("com.mysql.cj.jdbc.Driver");
	  conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");
	
	  String sql = "SELECT * FROM user WHERE U_ID = ?";
	  pstmt = conn.prepareStatement(sql);
	  pstmt.setString(1, userId);
	  rs = pstmt.executeQuery();
	  
	  if (rs.next()) {
		    u_no = rs.getString("U_NO");
		    System.out.println("조회된 회원번호(u_no): " + u_no);
		} else {
		    System.out.println("해당 userId로 찾은 회원이 없습니다.");
		}
  %>
	<form action="register_1.jsp" method="post">

	    商品名: <input type="text" name="name"><br>
	    price : <input type="text" name="price"><br>
	    description: <input type="text" name="desc"><br>
	    stock: <input type="number" name="stock"><br>
	    img: <input type="text" name="img"><br>
	    
	    <select name="type">
	        <option value="1"> パソコン（本体）
	        <option value="2" > 周辺機器（キーボード、マウスなど）
	        <option value="3"> 部品
	        <option value="4"> その他 
		</select>
    
		<input type="hidden" name="u_no" value="<%= u_no %>">
		<button type="submit">登録</button>
	</form>
 
    <a href="select.jsp">HOME</a>
  </form>
</body>
</html>