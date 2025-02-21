package model;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/PaymentSuccessServlet")
public class PaymentSuccessServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String paymentId = request.getParameter("payment_id");
        String orderId = (String) request.getSession().getAttribute("order_id");
        int amount = (int) request.getSession().getAttribute("amount");

        try {
            // Connect to database
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/estock", "root", "977327341426");

            // Insert transaction details
            PreparedStatement ps = con.prepareStatement("INSERT INTO payments (order_id, payment_id, amount) VALUES (?, ?, ?)");
            ps.setString(1, orderId);
            ps.setString(2, paymentId);
            ps.setInt(3, amount);
            ps.executeUpdate();
            
            // Redirect to success page
            response.sendRedirect("order-success.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=Payment%20Failed");
        }
    }
}

