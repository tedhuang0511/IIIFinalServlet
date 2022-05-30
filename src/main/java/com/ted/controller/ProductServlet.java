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
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProductServlet", value = "/ProductServlet")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ProductService productService;

    public void init() {
        ServletContext application = this.getServletContext();
        ApplicationContext context = (ApplicationContext) application.getAttribute(
                WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
        productService = context.getBean("productService", ProductService.class);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        //接收參數
        request.setCharacterEncoding("UTF-8");
        var username = (String) request.getSession().getAttribute("login");
        var pid0 = request.getParameter("editProductId");
        var pdName0 = request.getParameter("pdname");
        var pdType0 = request.getParameter("pdtypeselect");
        var pdPrice0 = request.getParameter("pdprice");
        var pDesc = request.getParameter("pdesc");
        var pdaction = request.getParameter("pdaction");
        var imgIndex = request.getParameter("imgIndex");
        System.out.println(pdaction + " from productservelet" + pid0 +" : "+ pdName0+" : "+ pdType0);

        //驗證資料
        Map<String, String> errors = new HashMap<>();
        request.setAttribute("errors", errors);

        //轉換資料
        int pid = 0; //如果抓不到id就給預設id為0
        if(pid0!=null && pid0.length()!=0) {
            try {
                pid = Integer.parseInt(pid0);
            } catch (NumberFormatException e) {
                e.printStackTrace();
                errors.put("id", "Id must be an integer");
            }
        }
        int pdPrice = 0;
        if(pdPrice0!=null && pdPrice0.length()!=0) {
            try {
                pdPrice = Integer.parseInt(pdPrice0);
            } catch (NumberFormatException e) {
                e.printStackTrace();
                errors.put("price", "Price must be an integer");
            }
        }
        String pdName = "XX"; //
        String pdType = "XX"; //
        if(pdName0!=null & pdName0.length()!=0){
            pdName = pdName0;
        }
        if(pdType0!=null & pdType0.length()!=0){
            pdType = pdType0;
        }

        //呼叫Model
        ProductBean bean = new ProductBean();
        try{
            bean.setProductId(pid);
            bean.setProductName(pdName);
            bean.setProductCatalog(pdType);
            bean.setProductPrice(pdPrice);
            bean.setProductDesc(pDesc);
            bean.setUpdateUser(username);
        }catch (Exception e){
            System.out.println(e);
        }

        if (pdaction != null && pdaction.equals("Select")) {
            System.out.println("come in select statement at ProductServlet");
            List<ProductBean> result = productService.select(bean);
            request.setAttribute("select", result);
            request.getRequestDispatcher(
                    "selectProduct.jsp").forward(request, response);
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
