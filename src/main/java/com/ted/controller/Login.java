package com.ted.controller;

import com.ted.model.UserService;

import java.io.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(
        urlPatterns={"/login"},
        initParams={
                @WebInitParam(name = "SUCCESS_PATH", value = "home.jsp"),
                @WebInitParam(name = "ERROR_PATH", value = "index.html")
        }
)
public class Login extends HttpServlet {
    private String SUCCESS_PATH;
    private String ERROR_PATH;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        SUCCESS_PATH = getInitParameter("SUCCESS_PATH");
        ERROR_PATH = getInitParameter("ERROR_PATH");
//        userService =
//                (UserService) getServletContext().getAttribute("userService");
    }

    protected void doPost(
            HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        var username = request.getParameter("username");
        var password = request.getParameter("password");
        userService = new UserService(username);

        String page;
        if(isInputted(username,password)&&userService.login(username,password)){
            if(request.getSession(false)!=null){
                request.changeSessionId(); //新增session
            }
            request.getSession().setAttribute("login",username);//為session設定屬性("login"),值=username
            page= SUCCESS_PATH;
        }else{
            page= ERROR_PATH;
        }
        response.sendRedirect(page);
    }

    private boolean isInputted(String username, String password){
        return username!=null && password!=null && username.trim().length()!=0 && password.trim().length()!=0;
    }
}