package com.ted.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection connectDB(){

        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
        }catch (ClassNotFoundException e){
            System.out.println(e);
        }

        Connection conn = null;
        try {
//            var prop = new Properties();
//            var in = new FileInputStream("src/main/resources/properties");
//            prop.load(in);
//            in.close();
            String connectionURL = "jdbc:mysql://localhost/iii";
            String username = "root";
            String password = "";

            conn = DriverManager.getConnection(
                    connectionURL, username, password);
        }catch (Exception e){
            System.out.println(e);
        }
        return conn;
    }
}
