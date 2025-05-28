<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>eStock Storefront</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body, html {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            height: 100%;
        }
        .nav-link:hover {
            color: #00aaff;
        }
        .jumbotron {
            background-image: url('assets/images/bg.png'); 
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            color: #ffffff;
            padding: 150px 20px;
            text-align: center;
            height: 100vh;
            width: 100%;
            margin: 0;
        }
        .jumbotron h1, .jumbotron p, .jumbotron .btn-primary {
            position: relative;
            z-index: 1;
        }
    </style>    
</head>
<body>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String username = (String) session.getAttribute("username");
%>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="index.jsp">eStock Storefront</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="product.jsp">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="cart.jsp">Cart</a></li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= (userEmail == null) ? "login.jsp" : "profile.jsp" %>">
                        <%= (userEmail != null) ? "Welcome, " + username : "Profile" %>
                    </a>
                </li>          
                <% if (userEmail != null) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet">Logout (<%= username %>)</a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Login</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav> 
<div class="jumbotron">
    <h1>Welcome to eStock Storefront</h1>
    <p>Discover amazing stocks and products at unbeatable prices.</p>
    <a href="product.jsp" class="btn btn-primary">Shop Now</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
