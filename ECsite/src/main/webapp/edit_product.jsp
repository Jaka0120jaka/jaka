<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 체크
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 파라미터 받기 (u_no도 꼭 받아야 함)
    String u_no = request.getParameter("u_no");
    String id = request.getParameter("id");

    // DB에서 상품 정보 조회
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String name = "";
    int price = 0;
    int stock = 0;
    String description = "";
    String img = "";
    String type = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

        String sql = "SELECT * FROM products WHERE id = ? AND u_no = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        pstmt.setString(2, u_no);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            price = rs.getInt("price");
            stock = rs.getInt("stock");
            description = rs.getString("description");
            img = rs.getString("img");
            type = rs.getString("type");  // type도 여기서 받아옴
        } else {
%>
            <p>商品情報が見つかりません。</p>
            <a href="my_page.jsp">戻る</a>
<%
            return;
        }

    } catch (Exception e) {
        out.println("エラー: " + e.getMessage());
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品修正</title>
</head>
<body>
    <h2>商品情報修正フォーム</h2>

    <form action="update-product-servlet" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <input type="hidden" name="u_no" value="<%= u_no %>">

        <p>
            商品名：<br>
            <input type="text" name="name" value="<%= name %>" required>
        </p>

        <p>
            価格：<br>
            <input type="number" name="price" value="<%= price %>" required>
        </p>

        <p>
            在庫数：<br>
            <input type="number" name="stock" value="<%= stock %>" required>
        </p>

        <p>
            商品説明：<br>
            <textarea name="desc" rows="4" cols="50"><%= description %></textarea>
        </p>

        <p>
            画像URL：<br>
            <input type="text" name="img" value="<%= img %>">
        </p>

        <p>
            商品種類：<br>
            <select name="type">
                <option value="1" <%= "1".equals(type) ? "selected" : "" %>>パソコン（本体）</option>
                <option value="2" <%= "2".equals(type) ? "selected" : "" %>>周辺機器（キーボード、マウスなど）</option>
                <option value="3" <%= "3".equals(type) ? "selected" : "" %>>部品</option>
                <option value="4" <%= "4".equals(type) ? "selected" : "" %>>その他</option>
            </select>
        </p>

        <p>
            <button type="submit">修正する</button>
            <a href="my_page.jsp">キャンセル</a>
        </p>
    </form>
</body>
</html>




