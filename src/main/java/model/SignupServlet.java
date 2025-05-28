package model;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.*;
import java.sql.*;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        System.out.println("📌 Servlet Started"); // ✅ Debugging
        out.println("Servlet reached!<br>"); // ✅ Debug response to browser

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("📌 Received Data - Username: " + username + ", Email: " + email);
        out.println("Data received: " + username + ", " + email + "<br>");

        if (username == null || email == null || password == null ||
            username.isEmpty() || email.isEmpty() || password.isEmpty()) {
            System.out.println("❌ Error: Missing form data");
            out.println("Error: Missing form data!<br>");
            response.sendRedirect("signup.jsp");
            return;
        }

        out.println("Processing signup...<br>");

        // Database connection details
        String jdbcURL = "jdbc:mysql://localhost:3306/estock_db";
        String dbUser = "root";  // Change to your MySQL username
        String dbPassword = "977327341426";  // Change to your MySQL password

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ JDBC Driver Loaded");
            out.println("JDBC Driver Loaded!<br>");

            try (Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                 PreparedStatement stmt = conn.prepareStatement("INSERT INTO users (username, email, password) VALUES (?, ?, ?)")) {

                stmt.setString(1, username);
                stmt.setString(2, email);
                stmt.setString(3, password);

                int rowsInserted = stmt.executeUpdate();
                System.out.println("✅ Rows Inserted: " + rowsInserted);
                out.println("Rows Inserted: " + rowsInserted + "<br>");

                if (rowsInserted > 0) {
                    System.out.println("✅ Signup successful! Redirecting to login.jsp...");
                    response.sendRedirect("login.jsp");
                } else {
                    System.out.println("❌ Signup failed");
                    out.println("Signup failed!<br>");
                    response.sendRedirect("signup.jsp");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ Exception: " + e.getMessage());
            out.println("Exception: " + e.getMessage() + "<br>");
        }
    }
}
