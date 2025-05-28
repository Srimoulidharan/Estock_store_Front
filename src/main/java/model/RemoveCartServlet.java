package model;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/RemoveCartServlet")
public class RemoveCartServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("cart");

        if (cart != null) {
            cart.removeIf(item -> item.getProductId() == productId);
        }

        response.sendRedirect("cart.jsp");
    }
}