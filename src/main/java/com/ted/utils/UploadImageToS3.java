package com.ted.utils;

import java.io.File;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/UploadImageToS3")
@MultipartConfig(
        location = "D:\\Program Files\\IIIFinalServlet\\src\\main\\webapp\\upload"
)
public class UploadImageToS3 extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String columnName = request.getParameter("pdImageColumn");
        String productName = request.getParameter("pdImageName");

        Part part = request.getPart("files");
        String filename = createNewFilename();
        String path = "D:\\Program Files\\IIIFinalServlet\\src\\main\\webapp\\upload\\"+filename;
        part.write(filename);
        File file = new File(path);
        String s3Url = AwsS3Util.uploadToS3(file,filename);
        String imgUrl = s3Url.substring(0,s3Url.indexOf("?"));

        try(var conn = DBConnection.connectDB();){ //拿到db連線,自動關閉連線
            var presql = "UPDATE PRODUCTS SET " + columnName;
            var sql = presql + " = ? WHERE PRODUCT_NAME = ?";
            PreparedStatement pstmt;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, imgUrl);
            pstmt.setString(2, productName);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            cleanUploadFolder(file);
        }
    }
    //把本地端暫存資料刪除
    private void cleanUploadFolder(File file) {
        file.delete();
    }

    private String createNewFilename() {
        SimpleDateFormat sd = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss_SSS");
        String fname = sd.format(new Date()) + ".jpg";
        return fname;
    }

}
