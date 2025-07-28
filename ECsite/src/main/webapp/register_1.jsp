<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>　

<%@ page import="model.Store" %>
<%@ page import="model.Product" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%
  request.setCharacterEncoding("UTF-8");

  String name = request.getParameter("name");
  String priceParam = request.getParameter("price");
  String desc = request.getParameter("desc");
  String stockParam = request.getParameter("stock");
  String img = request.getParameter("img");  
  String u_no = request.getParameter("u_no");
  //String type = request.getParameter("type");
  String typeParam = request.getParameter("type");

  if (
	  name == null || name.trim().isEmpty() ||
      priceParam == null || priceParam.trim().isEmpty() ||
      desc == null || desc.trim().isEmpty() ||
      stockParam == null || stockParam.trim().isEmpty()||
	  typeParam == null || typeParam.trim().isEmpty())
  {
%>
    <script>
      alert("全ての項目を入力してください。");
      history.back();  
    </script>
<%
    return;
  }

  double price = 0;
  int stock = 0;
  int type = 0;

  try {
      price = Double.parseDouble(priceParam);
      stock = Integer.parseInt(stockParam);
      type = Integer.parseInt(typeParam);
      
  } catch (NumberFormatException e) {
%>
    <script>
      alert("項目を正しくご記入ください。");
      history.back();
    </script>
<%
    return;
  }

  Connection conn = null;
  PreparedStatement pstmt = null;

  try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

      String sql = "INSERT INTO products (name, price, description, stock, img, u_no, type) VALUES (?, ?, ?, ?, ?, ?, ?)";
      pstmt = conn.prepareStatement(sql);

      pstmt.setString(1, name);
      pstmt.setDouble(2, price);
      pstmt.setString(3, desc);
      pstmt.setInt(4, stock);
      pstmt.setString(5, img);
      pstmt.setString(6, u_no);
      pstmt.setInt(7, type);

      int result = pstmt.executeUpdate();

      if (result > 0) {
          response.sendRedirect("register_sucsess.jsp");
      }
      

  } catch (Exception e) {
      out.println("エラー: " + e.getMessage());
  } finally {
      if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
      if (conn != null) try { conn.close(); } catch(Exception e) {}
  }
%>
