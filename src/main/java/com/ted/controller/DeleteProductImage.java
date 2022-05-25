package com.ted.controller;

import com.ted.utils.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/DeleteProductImage")

public class DeleteProductImage extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String index = request.getParameter("imgIndex");
        String productId = request.getParameter("pid");

        try(var conn = DBConnection.connectDB();){ //拿到db連線,自動關閉連線
            var presql = "UPDATE PRODUCTS SET PRODUCT_IMG" + index;
            var sql = presql + " = ? WHERE PRODUCT_ID = ?";
            PreparedStatement pstmt;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "https://i.imgur.com/7sPQA0H.jpg");
            pstmt.setString(2, productId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
