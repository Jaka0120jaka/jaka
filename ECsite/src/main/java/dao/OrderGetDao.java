package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Product;

public class OrderGetDao {
    private final String JDBC_URL = "jdbc:mysql://localhost:3306/ec_site";
    private final String DB_USER = "root";
    private final String DB_PASS = "password";

    public List<Product> findByIDs(String ids) throws Exception {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);

            String sql;
                sql = "SELECT * FROM orders WHERE IDs = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, ids);

            rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getInt("price"));
                p.setQuantity(rs.getInt("quantity"));
                p.setTotalPrice(rs.getInt("totalPrice"));
                p.setImg(rs.getString("img"));
                list.add(p);
            }
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        return list;
    }

}
