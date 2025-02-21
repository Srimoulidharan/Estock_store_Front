package model;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve session, or create a new one if it doesn't exist
        HttpSession session = request.getSession(true);

        // Get the cart from session (or create a new one if empty)
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
        }

        // Get product details from the request
        int productId = Integer.parseInt(request.getParameter("productId"));
        String productName = request.getParameter("productName");
        double productPrice = Double.parseDouble(request.getParameter("productPrice"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Check if the product is already in the cart
        if (cart.containsKey(productId)) {
            // If item exists, update the quantity
            CartItem existingItem = cart.get(productId);
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            // Add new item to the cart
            cart.put(productId, new CartItem(productId, productName, productPrice, quantity));
        }

        // Save the cart back to session
        session.setAttribute("cart", cart);

        // Debugging: Print cart to console
        System.out.println("Cart Updated: " + cart);

        // Redirect to cart.jsp to display cart contents
        response.sendRedirect("cart.jsp");
    }
}
