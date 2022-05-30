package com.ted.model;

import com.ted.utils.DBConnection;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;

public class UserService {
    private final String USERS;

    public UserService(String USERS) {
        this.USERS = USERS;
    }

    public boolean login(String username, String password) {
        try(var conn = DBConnection.connectDB()) {  //拿到DB連線,自動關閉連線
            var sql = "select * from user where user_account = ?";
            var pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                var res = pstmt.executeQuery();
                if(res.next()){
                    String name = res.getString("user_account");
                    String pw = res.getString("user_password");
                    System.out.printf(name + ":" + pw);
                    return username.equals(name) && password.equals(pw);
                }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean isCorrectPassword(String password, Path userhome) throws IOException {
        var profile = userhome.resolve("profile");
        try (var reader = Files.newBufferedReader(profile)) {
            var data = reader.readLine().split("\t");
            var encrypt = Integer.parseInt(data[1]);
            var salt = Integer.parseInt(data[2]);
            return password.hashCode() + salt == encrypt;
        }
    }
}