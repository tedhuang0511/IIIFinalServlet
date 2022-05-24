package com.ted.controller;

import com.ted.utils.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "ProductDataInsert", value = "/ProductDataInsert")
public class ProductDataInsert extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //接收參數
        request.setCharacterEncoding("UTF-8");
        var username = (String)request.getSession().getAttribute("login");
        System.out.println(username);
        var pid = request.getParameter("editProductId");
        var pdName = request.getParameter("pdname");
        var pdType = request.getParameter("pdtypeselect");
        var pdPrice = request.getParameter("pdprice");
        var pDesc = request.getParameter("pdesc");

        try(var conn = DBConnection.connectDB();){ //拿到db連線,自動關閉連線
            var sql = "SELECT * FROM PRODUCTS WHERE PRODUCT_ID = ?";
            var pstmt = conn.prepareStatement(sql);
            pstmt.setString(1,pid);
            var rs = pstmt.executeQuery();
            if(rs.next()){ //如果true就表示產品存在 >> 進行 update
                var sql2 = "UPDATE products SET product_name = ?, product_catalog =? ," +
                        "product_price=? ,product_desc=? ,update_user=? , update_date=now()" +
                        "WHERE product_id=?";
                var pstmt2 = conn.prepareStatement(sql2);
                pstmt2.setString(1,pdName);
                pstmt2.setString(2,pdType);
                pstmt2.setString(3,pdPrice);
                pstmt2.setString(4,pDesc);
                pstmt2.setString(5,username);
                pstmt2.setString(6,pid);
                pstmt2.executeUpdate();
                response.sendRedirect("home.jsp");
            }else{ //false表示產品不存在 >> 進行insert
                var sql3 = "INSERT into products(product_name,product_catalog," +
                        "product_price,product_desc,create_user," +
                        "create_date,update_user,update_date) VALUES (?,?,?,?,?,now(),?,now())";
                var pstmt3 = conn.prepareStatement(sql3);
                pstmt3.setString(1,pdName);
                pstmt3.setString(2,pdType);
                pstmt3.setString(3,pdPrice);
                pstmt3.setString(4,pDesc);
                pstmt3.setString(5,username);
                pstmt3.setString(6,username);
                pstmt3.executeUpdate();
                response.sendRedirect("home.jsp");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
