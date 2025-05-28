package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Connection getConnection() throws SQLException {
        return util.DBConnection.getConnection();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String action = request.getParameter("action");

        if ("addToCart".equals(action)) {
            try (Connection conn = getConnection()) {
                String selectSql = "SELECT quantity FROM cart_items WHERE user_id = ? AND product_id = ?";
                try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
                    selectStmt.setInt(1, userId);
                    selectStmt.setInt(2, productId);
                    ResultSet rs = selectStmt.executeQuery();

                    if (rs.next()) {
                        int existingQty = rs.getInt("quantity");
                        int newQty = existingQty + quantity;
                        String updateSql = "UPDATE cart_items SET quantity = ? WHERE user_id = ? AND product_id = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setInt(1, newQty);
                            updateStmt.setInt(2, userId);
                            updateStmt.setInt(3, productId);
                            updateStmt.executeUpdate();
                        }
                    } else {
                        String insertSql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                            insertStmt.setInt(1, userId);
                            insertStmt.setInt(2, productId);
                            insertStmt.setInt(3, quantity);
                            insertStmt.executeUpdate();
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            response.sendRedirect("cart.jsp");
        } else if ("buyNow".equals(action)) {
            response.sendRedirect("checkout.jsp?productId=" + productId + "&quantity=" + quantity);
        } else {
            response.sendRedirect("product.jsp");
        }
    }
}
