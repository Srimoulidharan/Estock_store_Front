<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Checkout - eStock Storefront</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>

<div class="container my-5">
    <%
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        int productId = -1;
        int quantity = 1;

        if (productIdStr != null) {
            try {
                productId = Integer.parseInt(productIdStr);
            } catch (NumberFormatException e) {
                out.println("<div class='alert alert-danger'>Invalid product ID.</div>");
                return;
            }
        } else {
            out.println("<div class='alert alert-danger'>Product ID is missing.</div>");
            return;
        }

        if (quantityStr != null) {
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity < 1) quantity = 1;
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        String productName = "";
        double price = 0.0;
        String image = "default.jpg";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement("SELECT name, price, image FROM products WHERE product_id = ?");
            stmt.setInt(1, productId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                productName = rs.getString("name");
                price = rs.getDouble("price");
                String img = rs.getString("image");
                if (img != null && !img.isEmpty()) {
                    image = img;
                }
            } else {
                out.println("<div class='alert alert-warning'>Product not found.</div>");
                return;
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error fetching product details: " + e.getMessage() + "</div>");
            return;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }

        double totalPrice = price * quantity;
    %>

    <h2>Checkout</h2>
    <div class="row mt-4">
        <div class="col-md-5">
            <img src="assets/images/<%= image %>" alt="<%= productName %>" class="img-fluid" style="max-height:300px; object-fit: contain;" />
        </div>
        <div class="col-md-7">
            <h4><%= productName %></h4>
            <p><strong>Unit Price:</strong> ₹<%= String.format("%.2f", price) %></p>
            <p><strong>Quantity:</strong> <%= quantity %></p>
            <p><strong>Total Price:</strong> ₹<%= String.format("%.2f", totalPrice) %></p>

            <form action="ConfirmOrderServlet" method="post">
                <input type="hidden" name="productId" value="<%= productId %>" />
                <input type="hidden" name="quantity" value="<%= quantity %>" />

                <button type="submit" class="btn btn-success">Confirm Order</button>
                <a href="productDetails.jsp?product_id=<%= productId %>" class="btn btn-secondary ms-2">Cancel</a>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
