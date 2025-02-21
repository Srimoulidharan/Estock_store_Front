<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Products</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link href="assets/css/styles.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
        }
        .card:hover {
            transform: translateY(-10px);
        }
        .btn-primary {
            box-shadow: 0 4px 10px rgba(0, 123, 255, 0.5);
            transition: box-shadow 0.3s ease;
        }
        .btn-primary:hover {
            box-shadow: 0 6px 15px rgba(0, 123, 255, 0.75);
        }
    </style>
</head>
<body>

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

<div class="container my-5">
    <h2 class="text-center mb-4">Featured Products</h2>
    <div class="row">
    
    <%-- Database Connection and Product Fetching --%>
    <% 
        List<Map<String, String>> products = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, String> product = new HashMap<>();
                product.put("id", rs.getString("id"));
                product.put("name", rs.getString("name"));
                product.put("price", rs.getString("price"));
                product.put("image", "assets/images/" + rs.getString("image"));
                products.add(product);
            }
            request.setAttribute("products", products);
        } catch (Exception e) {
            out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
        }
    %>
    
 
    <%-- Static Products as a Fallback --%>
    <div class="col-md-4">
        <div class="card">
            <img src="assets/images/shopping.jpg" class="card-img-top" alt="Product 1">
            <div class="card-body text-center">
                <h5 class="card-title">THRUSTMASTER T300RS Racing Wheel</h5>
                <p class="card-text">₹1,14,450.00</p>
                <a href="product-details.jsp?id=1" class="btn btn-primary">View Details</a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card">
            <img src="assets/images/shopping1.jpg" class="card-img-top" alt="Product 2">
            <div class="card-body text-center">
                <h5 class="card-title">Taylor 114ce Grand Auditorium Guitar</h5>
                <p class="card-text">₹1,60,871.00</p>
                <a href="product-details.jsp?id=2" class="btn btn-primary">View Details</a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card">
            <img src="assets/images/shopping3.jpg" class="card-img-top" alt="Product 3">
            <div class="card-body text-center">
                <h5 class="card-title">Tekton Star Socket Set</h5>
                <p class="card-text">₹8,441.00</p>
                <a href="product-details.jsp?id=3" class="btn btn-primary">View Details</a>
            </div>
        </div>
    </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
