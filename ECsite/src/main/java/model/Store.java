package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


public class Store {
	private String name;  /* Delguuriin ner */
	private List<Product> listProd; /* Baraanii list */
 
	
	public Store(String name, List<Product> listProd) {
		this.name = name;
		this.listProd = listProd;
	}

	
	public List<Product> getListProd() {
		return listProd;
	}

	
	public String getName() {
		return name;
	}

	
	public void add(Product prod) {
		listProd.add(prod);
	}

//	songoson baraag ustgah
	public void remove(int index) {
		listProd.remove(index);
	}
	
//	buh baraag ustgah
	public void clear() {
		listProd.clear();
	}
	
//	endees nemsen
	public void setListProd(List<Product> listProd) {
	    this.listProd = listProd;
	}
	
	public List<Product> loadProductsFromDB() {
	    List<Product> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

	        String sql = "SELECT * FROM products WHERE DELETEUN = 'Y'";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            Product p = new Product();
	            p.setId(rs.getInt("id"));
	            p.setName(rs.getString("name"));
	            p.setPrice(rs.getInt("price"));
	            p.setDesc(rs.getString("description"));
	            p.setStock(rs.getInt("stock"));
	            p.setImg(rs.getString("img"));
	            p.setDeleteun(rs.getString("DELETEUN"));
	            list.add(p);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (Exception e) {}
	        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
	        try { if (conn != null) conn.close(); } catch (Exception e) {}
	    }

	    return list;
	}
	
//	endees
	public Store() {
        // 必要なら初期化処理を書く
    }
	// Store.java
	public List<Product> loadProductsFromDB(int type) {
	    List<Product> productList = new ArrayList<>();

	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

	        String sql = "SELECT * FROM products WHERE type = ? AND DELETEUN = 'Y'";
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, type);
	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {
	            Product prod = new Product();
	            prod.setId(rs.getInt("id"));
	            prod.setName(rs.getString("name"));
	            prod.setDesc(rs.getString("description"));
	            prod.setPrice(rs.getInt("price"));
	            prod.setStock(rs.getInt("stock"));
	            prod.setImg(rs.getString("img"));
	            prod.setType(rs.getInt("type"));
	            productList.add(prod);
	        }

	        rs.close();
	        pstmt.close();
	        conn.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return productList;
	}


}
