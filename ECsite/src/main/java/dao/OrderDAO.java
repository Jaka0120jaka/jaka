package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import model.Cart;
import model.CartItem;
import model.Product;

public class OrderDAO {

    private final String JDBC_URL = "jdbc:mysql://localhost:3306/ec_site";
    private final String DB_USER = "root";
    private final String DB_PASS = "password";

    public void insertOrder(Cart cart) throws Exception {
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) return;

        Connection conn = null;
        PreparedStatement itemStmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
            conn.setAutoCommit(false);  // トランザクション開始

            String sql = "INSERT INTO orders (id, name, price, quantity, totalPrice, img, IDs) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?) " +
                    "ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity), totalPrice = totalPrice + VALUES(totalPrice)";

            itemStmt = conn.prepareStatement(sql);

            for (CartItem item : cart.getItems()) {
                Product prod = item.getProduct();
                int quantity = item.getQuantity();
                int price = prod.getPrice();
                int totalPrice = price * quantity;

                itemStmt.setInt(1, prod.getId());
                itemStmt.setString(2, prod.getName());
                itemStmt.setInt(3, price);
                itemStmt.setInt(4, quantity);
                itemStmt.setInt(5, totalPrice);
                itemStmt.setString(6, prod.getImg());

                // userId が null の場合の安全対処
                String userId = cart.getUserId();
                if (userId == null) {
                    userId = (String) cart.getUserId();  // JSP側でログインしてたらセッションから取るのもOK
                }
                itemStmt.setString(7, userId != null ? userId : "guest");

                itemStmt.addBatch();
            }

            itemStmt.executeBatch();
            conn.commit();

        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (itemStmt != null) itemStmt.close();
            if (conn != null) conn.close();
        }
    }
}
