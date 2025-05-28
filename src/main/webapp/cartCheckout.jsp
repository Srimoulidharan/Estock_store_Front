<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    double totalAmount = 0.0;
    DecimalFormat df = new DecimalFormat("#.00");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Cart Checkout - eStock Storefront</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
<div class="container my-5">
    <h2>Checkout - Your Cart</h2>
    <%
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.product_id, p.name, p.price, c.quantity " +
                         "FROM cart_items c JOIN products p ON c.product_id = p.product_id " +
                         "WHERE c.user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (!rs.isBeforeFirst()) { // no items
    %>
                <div class="alert alert-warning">Your cart is empty.</div>
    <%
            } else {
    %>
                <table class="table table-bordered mt-4">
                    <thead class="table-light">
                        <tr>
                            <th>Product Name</th>
                            <th>Quantity</th>
                            <th>Unit Price (₹)</th>
                            <th>Total Price (₹)</th>
                        </tr>
                    </thead>
                    <tbody>
    <%
                while (rs.next()) {
                    int qty = rs.getInt("quantity");
                    double price = rs.getDouble("price");
                    String name = rs.getString("name");
                    double itemTotal = price * qty;
                    totalAmount += itemTotal;
    %>
                    <tr>
                        <td><%= name %></td>
                        <td><%= qty %></td>
                        <td><%= df.format(price) %></td>
                        <td><%= df.format(itemTotal) %></td>
                    </tr>
    <%
                }
    %>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th colspan="3" class="text-end">Grand Total:</th>
                            <th>₹<%= df.format(totalAmount) %></th>
                        </tr>
                    </tfoot>
                </table>
                <form action="ConfirmOrderServlet" method="post">
                    <button type="submit" class="btn btn-success">Confirm Order</button>
                    <a href="cart.jsp" class="btn btn-secondary ms-2">Cancel</a>
                </form>
    <%
            }
        } catch (Exception e) {
    %>
            <div class="alert alert-danger">Error loading cart: <%= e.getMessage() %></div>
    <%
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
