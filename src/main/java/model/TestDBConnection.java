package model;

import java.sql.Connection;
import java.sql.DriverManager;

public class TestDBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/estock";
    private static final String USER = "root";
    private static final String PASSWORD = "977327341426";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
