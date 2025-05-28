package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/ConfirmOrderServlet")
public class ConfirmOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Connection getConnection() throws SQLException {
        return util.DBConnection.getConnection(); // Modify if needed
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        double totalAmount = 0.0;
        int orderId = -1;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            // 1. Calculate total amount
            String calcTotalSql = "SELECT ci.product_id, ci.quantity, p.price " +
                                  "FROM cart_items ci JOIN products p ON ci.product_id = p.product_id " +
                                  "WHERE ci.user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(calcTotalSql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    int qty = rs.getInt("quantity");
                    double price = rs.getDouble("price");
                    totalAmount += price * qty;
                }
            }

            // 2. Insert into orders
            String insertOrderSql = "INSERT INTO orders (user_id, total_amount) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setDouble(2, totalAmount);
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1);
                } else {
                    throw new SQLException("Failed to create order.");
                }
            }

            // 3. Insert into order_items
            String fetchCartSql = "SELECT ci.product_id, ci.quantity, p.price " +
                                  "FROM cart_items ci JOIN products p ON ci.product_id = p.product_id " +
                                  "WHERE ci.user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(fetchCartSql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                String insertItemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertItemSql)) {
                    while (rs.next()) {
                        insertStmt.setInt(1, orderId);
                        insertStmt.setInt(2, rs.getInt("product_id"));
                        insertStmt.setInt(3, rs.getInt("quantity"));
                        insertStmt.setDouble(4, rs.getDouble("price"));
                        insertStmt.addBatch();
                    }
                    insertStmt.executeBatch();
                }
            }
//            String clearCartSql = "DELETE FROM cart_items WHERE user_id = ?";
//            try (PreparedStatement ps = conn.prepareStatement(clearCartSql)) {
//                ps.setInt(1, userId);
//                ps.executeUpdate();
//            }

            conn.commit();
            response.sendRedirect("orderConfirmation.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
