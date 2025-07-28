<%@ page import="java.sql.*, model.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId"); // ログインしたUserのID 로그인된 사용자 ID

    if (userId == null) {
        response.sendRedirect("login.jsp"); // ログインしてないならログインページに　로그인 안 되어 있으면 로그인 페이지로
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    User user = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

        String sql = "SELECT * FROM user WHERE U_ID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            user = new User();
            user.setU_no(rs.getString("U_NO"));
            user.setU_name(rs.getString("U_NAME"));
            user.setU_id(rs.getString("U_ID"));
            user.setU_pw(rs.getString("U_PW"));
            user.setU_birth(rs.getString("U_BIRTH"));
            user.setU_email(rs.getString("U_EMAIL"));
            user.setU_phone(rs.getString("U_PHONE"));
            user.setU_addr(rs.getString("U_ADDR"));
        }
    } catch (Exception e) {
        e.printStackTrace();
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
    <title>会員情報修正</title>
</head>
<body>
	<%@ include file="header-navi.jsp" %>
	
    <h2>会員情報修正</h2>

    <%
        if (user == null) {
    %>
        <p>ユーザー情報を取得できませんでした。</p>
    <%
        } else {
    %>
        <form action="update-user-servlet" method="post">
            <p><strong>会員番号:</strong> <%= user.getU_no() %></p>
            <p>Name: <input type="text" name="u_name" value="<%= user.getU_name() %>" required></p>
            <p>Password: <input type="text" name="u_pw" value="<%= user.getU_pw() %>" required></p>
            <p><strong>ID:</strong> <%= user.getU_id() %></p>
            <p><strong>生年月日:</strong> <%= user.getU_birth() %></p>
            <p>Email: <input type="email" name="u_email" value="<%= user.getU_email() %>" required></p>
            <p>電話番号: <input type="text" name="u_phone" value="<%= user.getU_phone() %>" required></p>
            <p>住所: <input type="text" name="u_addr" value="<%= user.getU_addr() %>" required></p>

            <!-- 修正できない部分も隠して一緒に送る　수정할 수 없는 값은 숨겨서 함께 전달 -->
            <input type="hidden" name="u_id" value="<%= user.getU_id() %>">
            <input type="hidden" name="u_no" value="<%= user.getU_no() %>">

            <button type="submit">修正完了</button>
        </form>
    <%
        }
    %>
</body>
</html>

