/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import java.sql.*;

/**
 *
 * @author Huay
 */
public class DBConnection {
    private static final String URL = "jdbc:derby://localhost:1527/gui"; // Change URL according to your database
    private static final String USERNAME = "nbuser";
    private static final String PASSWORD = "nbuser";

    public static Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }
}
