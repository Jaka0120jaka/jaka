<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    // セッションからログインユーザーのIDを取得
    String userId = (String) session.getAttribute("userId");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>マイページ</title>
</head>
<body>
<%@ include file="header-navi.jsp" %> 	


    <h2>マイページ</h2>

<%
	String u_no = null; 
	
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

        String sql = "SELECT * FROM user WHERE U_ID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
        	
        	u_no = rs.getString("U_NO");
%>
            <p><strong>会員番号:   </strong> <%= rs.getString("U_NO") %></p>
            <p><strong>名前:       </strong> <%= rs.getString("U_NAME") %></p>
            <p><strong>ユーザーID: </strong> <%= rs.getString("U_ID") %></p>
            <p><strong>生年月日:   </strong> <%= rs.getString("U_BIRTH") %></p>
            <p><strong>メール:     </strong> <%= rs.getString("U_EMAIL") %></p>
            <p><strong>電話番号:   </strong> <%= rs.getString("U_PHONE") %></p>
            <p><strong>住所:       </strong> <%= rs.getString("U_ADDR") %></p>
            <p><strong>ランク:     </strong> <%= rs.getInt("U_GRADE") == 1 ? "管理者" : "一般会員" %></p>
            
<%
        } else {
%>
            <p>ユーザー情報が見つかりません。<%= userId %></p>
<%
        }
    } catch (Exception e) {
%>
        <p>エラーが発生しました: <%= e.getMessage() %></p>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
	<%-------------------------------------------------------------------%>
		<div style="margin: 10px 0;">
	    <a href="register_2.jsp?u_no=<%= u_no %>">
	        <button type="button">➕ 商品を追加</button>
	    </a>
	    </div>
		<form action="my_search.jsp" method="get">
		    <input type="hidden" name="u_no" value="<%= u_no %>">
		    <button type="submit">登録した商品</button>
		</form>
			
		<form action="delete-user-servlet" method="post">
		    <input type="submit" value="会員脱退">
		</form>
		
		
		<form action="edit_user.jsp" method="get">
		    <button type="submit">会員情報修正</button>
		</form>
	<%-------------------------------------------------------------------%>
			
</body>
</html>
