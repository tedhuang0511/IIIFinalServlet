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
        String action = request.getParameter("action");
        String pid = request.getParameter("pid"); //刪除產品品項時的product id
        String index = request.getParameter("imgIndex");
        String productId = request.getParameter("pid");//刪除單一產品照片時候的product id
        System.out.println(action);


        try(var conn = DBConnection.connectDB();){ //拿到db連線,自動關閉連線
            if(action!=null && action.equals("deleteImg")){
                var presql = "UPDATE PRODUCTS SET PRODUCT_IMG" + index;
                var sql = presql + " = ? WHERE PRODUCT_ID = ?";
                PreparedStatement pstmt;
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "https://i.imgur.com/7sPQA0H.jpg");
                pstmt.setString(2, productId);
                pstmt.executeUpdate();
            }else if(action!=null && action.equals("deleteProductItem")){
                //DELETE FROM customers WHERE Name='王二';
                var sql  = "DELETE FROM PRODUCTS WHERE PRODUCT_ID = ?";
                PreparedStatement pstmt;
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, pid);
                pstmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
