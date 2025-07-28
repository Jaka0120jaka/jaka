<%@ page import="java.sql.*" %>
<%@ page contentType="text/plain; charset=UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

        String sql = "SELECT * FROM user WHERE U_ID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            out.print("EXISTS");
        } else {
            out.print("AVAILABLE");
        }

    } catch (Exception e) {
        out.print("ERROR");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>