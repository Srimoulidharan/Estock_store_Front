<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBConnection" %>
<%
    // Get userId from session
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Your Cart - eStock Storefront</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        .btn-custom {
            background-color: #6C7A89;
            color: white;
        }
        .btn-custom:hover {
            background-color: #5a6673;
            color: white;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="index.jsp">eStock Storefront</a>
        <ul class="navbar-nav ms-auto">
            <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
            <li class="nav-item"><a class="nav-link" href="product.jsp">Products</a></li>
            <li class="nav-item"><a class="nav-link active" href="cart.jsp">Cart</a></li>
            <li class="nav-item"><a class="nav-link" href="profile.jsp">Profile</a></li>
        </ul>
    </div>
</nav>

<div class="container my-5">
    <h2>Your Shopping Cart</h2>
    <%
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        double totalPrice = 0.0;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.product_id, p.name, p.price, c.quantity " +
                         "FROM cart_items c JOIN products p ON c.product_id = p.product_id " +
                         "WHERE c.user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (!rs.isBeforeFirst()) { // no rows
    %>
                <div class="alert alert-info">Your cart is empty.</div>
    <%
            } else {
    %>
                <table class="table table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <th>Product</th>
                            <th>Price (₹)</th>
                            <th>Quantity</th>
                            <th>Subtotal (₹)</th>
                        </tr>
                    </thead>
                    <tbody>
    <%
                while (rs.next()) {
                    int qty = rs.getInt("quantity");
                    double price = rs.getDouble("price");
                    double subtotal = price * qty;
                    totalPrice += subtotal;
    %>
                        <tr>
                            <td><%= rs.getString("name") %></td>
                            <td><%= String.format("%.2f", price) %></td>
                            <td><%= qty %></td>
                            <td><%= String.format("%.2f", subtotal) %></td>
                        </tr>
    <%
                }
    %>
                        <tr>
                            <td colspan="3" class="text-end"><strong>Total:</strong></td>
                            <td><strong>₹<%= String.format("%.2f", totalPrice) %></strong></td>
                        </tr>
                    </tbody>
                </table>

                <div class="d-flex justify-content-between">
                    <a href="product.jsp" class="btn btn-secondary">Continue Shopping</a>
                    <a href="cartCheckout.jsp" class="btn btn-custom">Proceed to Checkout</a>
                </div>
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

