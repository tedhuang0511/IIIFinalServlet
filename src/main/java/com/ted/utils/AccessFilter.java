package com.ted.utils;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebFilter;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebFilter(
        urlPatterns = {
                "/home.jsp",
                "/logout"
        },
        initParams = {
                @WebInitParam(name = "LOGIN_PATH", value = "index.html")
        }
)
public class AccessFilter extends HttpFilter {
    private String LOGIN_PATH;

    public void init() throws ServletException {
        LOGIN_PATH = getInitParameter("LOGIN_PATH");
    }

    public void doFilter(HttpServletRequest request,
                         HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if(request.getSession().getAttribute("login") == null) {
            response.sendRedirect(LOGIN_PATH);   //如果抓不到login屬性的session就把人送回登入頁面
        }
        else {
            chain.doFilter(request, response);   //如果抓到就讓request過來&response回去
        }
    }
}