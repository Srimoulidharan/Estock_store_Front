<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*" %>
<%
    String orderId = (String) session.getAttribute("order_id");
    Integer amount = (Integer) session.getAttribute("amount");
    String razorpayKey = (String) session.getAttribute("razorpay_key");

    if (orderId == null || amount == null || amount == 0 || razorpayKey == null) {
        response.sendRedirect("cart.jsp?error=Invalid+Order");
        return;
    }
%>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
    var options = {
        "key": "<%= razorpayKey %>",
        "amount": "<%= amount %>",
        "currency": "INR",
        "name": "E-Stock",
        "description": "Order Payment",
        "order_id": "<%= orderId %>",
        "handler": function (response) {
            window.location.href = "PaymentVerifyServlet?payment_id=" + response.razorpay_payment_id + "&order_id=<%= orderId %>";
        },
        "prefill": {
            "name": "Srimoulidharan",
            "email": "srimoulidharan154@gmail.com"
        },
        "theme": {
            "color": "#3399cc"
        }
    };
    
    var rzp1 = new Razorpay(options);
    rzp1.open();
</script>
