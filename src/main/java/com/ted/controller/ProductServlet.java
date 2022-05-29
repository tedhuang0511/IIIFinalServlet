package com.ted.controller;

import com.ted.model.ProductBean;
import com.ted.model.ProductService;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ProductServlet", value = "/ProductServlet")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ProductService productService;

    public void init() throws ServletException {
        ServletContext application = this.getServletContext();
        ApplicationContext context = (ApplicationContext) application.getAttribute(
                WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
        productService = context.getBean("productService", ProductService.class);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        //接收參數
        request.setCharacterEncoding("UTF-8");
        var username = (String) request.getSession().getAttribute("login");
        var pid = request.getParameter("editProductId");
        pid = pid.length()==0 ? String.valueOf(7788) : pid; //如果抓不到id就給預設id為7788
        var pdName = request.getParameter("pdname");
        var pdType = request.getParameter("pdtypeselect");
        var pdPrice = request.getParameter("pdprice");
        var pDesc = request.getParameter("pdesc");
        var pdaction = request.getParameter("pdaction");
        var imgIndex1 = request.getParameter("imgIndex");
        System.out.println(pdaction + " from productservelet" + pid);

        //驗證資料
        Map<String, String> errors = new HashMap<>();
        request.setAttribute("errors", errors);

        //轉換資料 //TODO 把資料轉一轉 imgIndex用字串就好
        int imgIndex = 0;
        if(imgIndex1!=null && imgIndex1.length()!=0) {
            try {
                imgIndex = Integer.parseInt(imgIndex1);
            } catch (NumberFormatException e) {
                e.printStackTrace();
                errors.put("id", "Id must be an integer");
            }
        }

        if (pdaction != null) {
            if (pdaction.equals("Insert") || pdaction.equals("Update") || pdaction.equals("Delete")) {
                if (pid == null || pid.length() == 0) {
                    errors.put("id", "Please enter Id for " + pdaction);
                }
            }
        }

        //呼叫Model
        ProductBean bean = new ProductBean();
        try{
            bean.setProductId(Integer.valueOf(pid));
            bean.setProductName(pdName);
            bean.setProductCatalog(pdType);
            bean.setProductPrice(Integer.parseInt(pdPrice));
            bean.setProductDesc(pDesc);
            bean.setUpdateUser(username);
        }catch (Exception e){
            System.out.println(e);
        }


        if (pdaction != null && pdaction.equals("Select")) {
//            List<ProductBean> result = productService.select(bean);
//            request.setAttribute("select", result);
//            request.getRequestDispatcher(
//                    "/pages/display.jsp").forward(request, response);
        } else if (pdaction != null && pdaction.equals("Insert")) {
            System.out.println("come in insert statement at ProductServlet");
            ProductBean result = productService.insert(bean);
            if (result == null) {
                errors.put("action", "Insert fail");
                //TODO 如果新增失敗要把失敗訊息丟回ajax
            } else {
//                request.setAttribute("insert", result);
            }
//            request.getRequestDispatcher(
//                    "/pages/product.jsp").forward(request, response);
        } else if (pdaction != null && pdaction.equals("Update")) {
            System.out.println("come in update statement at ProductServlet");
            ProductBean result = productService.update(bean);
            if (result == null) {
                errors.put("action", "Update fail");
            } else {
//                request.setAttribute("update", result);
            }
//            request.getRequestDispatcher(
//                    "/pages/product.jsp").forward(request, response);
        } else if (pdaction != null && pdaction.equals("Delete")) {
            System.out.println("send delete to product service");
            boolean result = productService.delete(bean);
            System.out.println(result);
//            if(!result) {
//                request.setAttribute("delete", 0);
//            } else {
//                request.setAttribute("delete", 1);
//            }
//            request.getRequestDispatcher(
//                    "/pages/product.jsp").forward(request, response);
        }else if (pdaction != null && pdaction.equals("DeleteImg")) {
            System.out.println("send img delete to ps");
            ProductBean result = productService.deleteImg(bean, imgIndex);
        } else {
            errors.put("action", "Unknown Action:" + pdaction);
//            request.getRequestDispatcher(
//                    "/pages/product.jsp").forward(request, response);
        }
    }
}
