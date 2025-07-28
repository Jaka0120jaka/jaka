<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, model.Product, model.Store" %>
<%@ page import="model.Store" %>
<%@ page import="model.Product" %>

<%@include file = "header-navi.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");

    String keyword = request.getParameter("keyword");

    if (keyword == null || keyword.trim().isEmpty()) {
        out.println("<p>検索キーワードを入力してください。</p>");
    } else {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

            String sql = "SELECT * FROM products WHERE name LIKE ? AND DELETEUN = 'Y'";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");

            rs = pstmt.executeQuery();
%>
            <h2>検索結果：</h2>
            <%
    while (rs.next()) {
        int idx = rs.getInt("id");
        String name = rs.getString("name");
        String img = rs.getString("img");
        int price = rs.getInt("price");
        int stock = rs.getInt("stock");
        String description = rs.getString("description");
%>
    <div>
        <a href="product-detail.jsp?idx=<%= idx - 1 %>">
            <img src="<%= request.getContextPath() + "/images/" + img %>" width="150" height="150">
        </a><br>
        <strong><%= name %></strong><br>
        価格：<%= price %>円<br>
        在庫：<%= stock %><br>
        説明：<%= description %><br>
        <hr>
    </div>
<%
    }
%>
<% 
        } catch (Exception e) {
            out.println("エラー: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
%>
<button type="button" onclick="history.back();">戻る</button>

		