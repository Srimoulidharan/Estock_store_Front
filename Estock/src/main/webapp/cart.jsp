<%@ page import="java.util.Map" %>
<%@ page import="model.CartItem" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Your Cart</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center">Your Cart</h2>
        <table class="table table-bordered table-striped">
            <thead class="thead-dark">
                <tr>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
                    if (cart == null || cart.isEmpty()) {
                %>
                    <tr>
                        <td colspan="4" class="text-center">Your cart is empty.</td>
                    </tr>
                <%
                    } else {
                        double total = 0;
                        for (CartItem item : cart.values()) {
                            double itemTotal = item.getProductPrice() * item.getQuantity();
                            total += itemTotal;
                %>
                    <tr>
                        <td><%= item.getProductName() %></td>
                        <td><%= item.getProductPrice() %></td>
                        <td><%= item.getQuantity() %></td>
                        <td><%= itemTotal %></td>
                    </tr>
                <%
                        }
                %>
                    <tr class="table-warning">
                        <td colspan="3" class="text-right"><strong>Total:</strong></td>
                        <td><strong><%= total %></strong></td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <a href="index.jsp" class="btn btn-primary">Continue Shopping</a>
        <a href="checkout.jsp" class="btn btn-success">Checkout</a>
    </div>
</body>
</html>
