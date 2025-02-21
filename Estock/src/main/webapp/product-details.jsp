<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details - eStock Storefront</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="index.jsp">eStock Storefront</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link active" href="product.jsp">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="cart.jsp">Cart</a></li>
                <li class="nav-item"><a class="nav-link" href="profile.jsp">Profile</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Product Details Section -->
<div class="container my-5">
    <%
        String productId = request.getParameter("id");
        int id = -1;

        if (productId != null) {
            try {
                id = Integer.parseInt(productId);
            } catch (NumberFormatException e) {
                out.println("<div class='alert alert-danger'>Invalid Product ID format.</div>");
                return;
            }
        } else {
            out.println("<div class='alert alert-danger'>No product ID provided.</div>");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement("SELECT id, name, description, price, image, stock FROM products WHERE id = ?");
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String image = (rs.getString("image") != null && !rs.getString("image").isEmpty()) ? rs.getString("image") : "default.jpg";
    %>

    <div class="row">
        <div class="col-md-6">
            <img src="assets/images/<%= image %>" alt="<%= rs.getString("name") %>" class="product-image">
        </div>
        <div class="col-md-6">
            <h3><%= rs.getString("name") %></h3>
            <p><strong>Price:</strong> ₹<%= rs.getDouble("price") %></p>
            <p><strong>Description:</strong> <%= rs.getString("description") %></p>

            <!-- Add to Cart Form -->
            <form action="CartServlet" method="post">
                <input type="hidden" name="productId" value="<%= rs.getInt("id") %>">
                <input type="hidden" name="productName" value="<%= rs.getString("name") %>">
                <input type="hidden" name="productPrice" value="<%= rs.getDouble("price") %>">
                
                <div class="mb-3">
                    <label for="quantity" class="form-label"><strong>Quantity:</strong></label>
                    <input type="number" name="quantity" id="quantity" class="form-control" value="1" min="1" max="<%= rs.getInt("stock") %>" required>
                </div>

                <button type="submit" class="btn btn-primary">Add to Cart</button>
            </form>

            <a href="product.jsp" class="btn btn-secondary mt-3">Back to Product List</a>
        </div>
    </div>

    <%
            } else {
                out.println("<div class='alert alert-warning'>Product not found.</div>");
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error fetching product details: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
