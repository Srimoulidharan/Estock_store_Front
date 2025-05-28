package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Handles user login functionality.
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles POST request for user login.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve user credentials from the request
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            // Use correct column names based on your database schema
            String sql = "SELECT user_id, username FROM users WHERE email = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password); // Note: In production, use hashed passwords

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Valid user found, start session
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("user_id"));
                session.setAttribute("userEmail", email);
                session.setAttribute("username", rs.getString("username"));

                // Redirect to homepage after successful login
                response.sendRedirect("index.jsp");
            } else {
                // Invalid credentials
                response.sendRedirect("login.jsp?error=Invalid+email+or+password");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database+error");
        }
    }
}
