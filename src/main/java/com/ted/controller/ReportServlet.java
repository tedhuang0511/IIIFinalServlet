package com.ted.controller;

import com.ted.model.MembersService;
import com.ted.model.viewTables.ProductSalesService;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ReportServlet", value = "/ReportServlet")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SimpleDateFormat sFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private ProductSalesService productSalesService;

    @Override
    public void init() {
        ServletContext application = this.getServletContext();
        ApplicationContext context = (ApplicationContext) application.getAttribute(
                WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
        productSalesService = context.getBean("productSalesService", ProductSalesService.class);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setHeader("Content-type", "text/html;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setCharacterEncoding("UTF-8");
        var out = response.getWriter();

        String temp0 = request.getParameter("startDate");
        String temp1 = request.getParameter("endDate");

        System.out.println("start: " + temp0 + " end: " + temp1);

        Date startDate = null;
        Date endDate = null;
        try {
            if (temp0 != null && temp0.length() != 0) {
                startDate = sFormat.parse(temp0);
            }

            if (temp1 != null && temp1.length() != 0) {
                endDate = sFormat.parse(temp1);
            }
        } catch (Exception e) {
            System.out.println(e);
        }

        JSONArray jarr = new JSONArray();
        List<Object[]> list = productSalesService.select(startDate, endDate);
        for (var bean : list) {
            Map<Object,Object> res = new HashMap<>();
            res.put(bean[0],bean[1]);
            jarr.put(new JSONObject(res));
        }
        out.print(jarr);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
