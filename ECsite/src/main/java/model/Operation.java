package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.HttpSession;


public class Operation {
	public boolean loginProc(String userId, String password, HttpSession session) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    boolean result = false;

	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        conn = DriverManager.getConnection(
	            "jdbc:mysql://localhost:3306/ec_site", "root", "password");

	        String sql = "SELECT * FROM user WHERE U_ID = ? AND U_PW = ? AND U_DELETEUN = 'Y'";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userId);
	        pstmt.setString(2, password);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            result = true;
	            
	            String userName = rs.getString("U_NAME");
	            session.setAttribute("loginUserName", userName);
	            
	            Store store = makeStore();
	            session.setAttribute("store", store);
	            
	            Cart cart = loadCartFromDB(userId);
	            session.setAttribute("cart", cart);
	   
	            session.setAttribute("userId", userId);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (Exception e) {}
	        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
	        try { if (conn != null) conn.close(); } catch (Exception e) {}
	    }

	    return result;
	}
	
//	Hamgiin ehnii main page deerh baraanuud
	private Store makeStore() {

		// delguuriin ner bolon list
		Store store = new Store("CAL EC_site", new ArrayList<Product>());
		
		// Connecting database
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
		            store.add(p);
		        }
	        } catch (Exception e) {
		            e.printStackTrace();
		        } finally {
		            try {
		                if(conn != null) conn.close();
		                if(pstmt != null) pstmt.close();
		                if(rs != null) rs.close();
		            } catch (Exception e) {
		                e.printStackTrace();
		            }
		        }
		
		return store;
	}
	
// log out hiih uildel
	public void logoutProc(HttpSession session) {
		Cart cart = (Cart) session.getAttribute("cart");
		if (cart != null) {
		    saveCartToDB(cart);
		}


		session.invalidate();
		
	}
	
//	cart items DB hiih
	public void saveCartToDB(Cart cart) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

	        String deleteSql = "DELETE FROM cart_items WHERE user_id = ?";
	        pstmt = conn.prepareStatement(deleteSql);
	        pstmt.setString(1, cart.getUserId());
	        pstmt.executeUpdate();
	        pstmt.close();

	        // shine cart hadgalah
	        String insertSql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";
	        pstmt = conn.prepareStatement(insertSql);

	        for (CartItem item : cart.getItems()) {
	            pstmt.setString(1, cart.getUserId());
	            pstmt.setInt(2, item.getProduct().getId());
	            pstmt.setInt(3, item.getQuantity());
	            pstmt.addBatch();
	        }
	        pstmt.executeBatch();

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
	        try { if (conn != null) conn.close(); } catch (Exception e) {}
	    }
	}
	
	// cartnii medeelliig product.java gaas zooj awah
	
	public Cart loadCartFromDB(String userId) {
	    Cart cart = new Cart(userId);
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

	        String sql = "SELECT c.quantity, p.* FROM cart_items c " +
	                     "JOIN products p ON c.product_id = p.id " +
	                     "WHERE c.user_id = ? AND p.DELETEUN = 'Y'";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userId);
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
	            p.setType(rs.getInt("type"));

	            int quantity = rs.getInt("quantity");
	            cart.add(p, quantity);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (Exception e) {}
	        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
	        try { if (conn != null) conn.close(); } catch (Exception e) {}
	    }

	    return cart;
	}
	
	// pay hiih uyd cartnii dotorhiig ustgah
	public void clearCartInDB(String userId) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ec_site", "root", "password");

	        String sql = "DELETE FROM cart_items WHERE user_id = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userId);
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
	        try { if (conn != null) conn.close(); } catch (Exception e) {}
	    }
	}




//	cartnd baraa nemeh
	public void addProd(int idx, HttpSession session) {
		
		Store store = (Store) session.getAttribute("store");
		Cart cart = (Cart) session.getAttribute("cart");

		if (store != null && cart != null) {
			Product product = store.getListProd().get(idx);

			cart.add(product, 1);

			session.setAttribute("cart", cart);
		}

	}

// cart nd bga buh baraag ustgah
	public void removeProd(int idx, HttpSession session) {
		
		Cart cart = (Cart) session.getAttribute("cart");
	
		if (cart != null) {
			// Cartnaas baraa hasah
			cart.remove(idx);

			session.setAttribute("cart", cart);
		}
			
	}

	
	public void decreaseProdQuantity(int idx, int removeQuantity, HttpSession session) {
	    Cart cart = (Cart) session.getAttribute("cart");
	    if (cart != null) {
	        List<CartItem> items = cart.getItems();
	        if (idx >= 0 && idx < items.size()) {
	            CartItem item = items.get(idx);
	            int currentQty = item.getQuantity();
	            if (removeQuantity >= currentQty) {
	                // oruulsan toonoos baraanii too baga baival baraag ter chigt n cartnaas hasah
	                items.remove(idx);
	            } else {
	                // zaasan toogoor bagasgah
	                item.setQuantity(currentQty - removeQuantity);
	            }
	            session.setAttribute("cart", cart);
	        }
	    }
	}

	
	public void pay(HttpSession session) {
		Cart cart = (Cart) session.getAttribute("cart");

		if (cart != null) {
			session.setAttribute("pay", cart);
			clearCartInDB(cart.getUserId());


			Cart newCart = new Cart(cart.getUserId());
			session.setAttribute("cart", newCart);
		}
	}
	
	public void addProd(int idx, int quantity, HttpSession session) {
		Store store = (Store) session.getAttribute("store");
		Cart cart = (Cart) session.getAttribute("cart");

		if (store != null && cart != null) {
			Product product = store.getListProd().get(idx);
			cart.add(product, quantity);
		}
	}

}
