package model;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONObject;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CheckoutServlet.class.getName());
    
    private static final String RAZORPAY_KEY = System.getenv("RAZORPAY_KEY");
    private static final String RAZORPAY_SECRET = System.getenv("RAZORPAY_SECRET");

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            // Validate and parse amount
            String amountStr = request.getParameter("amount");
            if (amountStr == null || amountStr.isEmpty()) {
                throw new IllegalArgumentException("Invalid amount provided");
            }
            int amount = (int) (Double.parseDouble(amountStr) * 100); // Convert to paise
            
            // Initialize Razorpay client
            RazorpayClient razorpay = new RazorpayClient(RAZORPAY_KEY, RAZORPAY_SECRET);
            
            // Generate unique receipt ID
            String receiptId = "txn_" + System.currentTimeMillis();
            
            // Create JSON object for order
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amount);
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", receiptId);
            orderRequest.put("payment_capture", 1);
            
            // Create order
            Order order = razorpay.orders.create(orderRequest);
            
            // Store order details in session
            session.setAttribute("order_id", order.get("id"));
            session.setAttribute("amount", amount);
            
            // Redirect to checkout page
            response.sendRedirect("checkout.jsp");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Payment processing failed", e);
            response.sendRedirect("cart.jsp?error=Payment%20Failed");
        }
    }
}
