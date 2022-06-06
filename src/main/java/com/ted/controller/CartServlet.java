package com.ted.controller;

import com.ted.model.ProductBean;
import com.ted.model.ProductService;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CartServlet", value = "/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductService productService;

    public void init() {
        ServletContext application = this.getServletContext();
        ApplicationContext context = (ApplicationContext) application.getAttribute(
                WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
        productService = context.getBean("productService", ProductService.class);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        //接收參數
        request.setCharacterEncoding("UTF-8");
        response.setHeader("Content-type", "text/html;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin","*");
        response.setCharacterEncoding("UTF-8");
        var pid0 = request.getParameter("editProductId");
        var pdaction = request.getParameter("pdaction");
        System.out.println(pdaction + " from cartServlet " + pid0);

        //驗證資料
        Map<String, String> errors = new HashMap<>();
        request.setAttribute("errors", errors);

        int pid = 0; //如果抓不到id就給預設id為0
        if (pid0 != null && pid0.length() != 0) {
            try {
                pid = Integer.parseInt(pid0);
            } catch (NumberFormatException e) {
                e.printStackTrace();
                errors.put("id", "Id must be an integer");
            }
        }
        ProductBean bean = new ProductBean();
        bean.setProductId(pid);

        var out = response.getWriter();
        int totalQTYinCart = 0;
        //判斷增刪修查
        if (pdaction != null && pdaction.equals("addToCart")) {
            System.out.println("come in select statement at CartServlet");
            List<ProductBean> result = productService.select(bean);
            if(request.getSession().getAttribute("cart")!=null){  //如果購物車session已存在
                List<ProductBean> temp = (List<ProductBean>) request.getSession().getAttribute("cart"); //把session放的list拿出來
                temp.add(result.get(0)); //把這次抓到的bean存進去
                request.getSession().removeAttribute("cart"); //把舊有的購物車session移除
                request.getSession().setAttribute("cart",temp); //把新的list存回購物車session
                totalQTYinCart = temp.size();
            }else{
                request.getSession().setAttribute("cart", result); //如果購物車session不存在 就直接new一個session把list存進去
                totalQTYinCart = result.size();
            }
            out.print("購物車新增成功"+totalQTYinCart);
            out.close();
        } else if(pdaction != null && pdaction.equals("removeProductFromCart")){
            List<ProductBean> result = productService.select(bean);
            List<ProductBean> temp = (List<ProductBean>) request.getSession().getAttribute("cart"); //把session放的list拿出來
            System.out.println(temp.size()+": temp數量");
            for(int i=0; i<temp.size();i++){
                if(temp.get(i).getProductName().equals(result.get(0).getProductName())){
                    temp.remove(i);
                }
            }
            System.out.println("result: "+ result.get(0).getProductName());
            request.getSession().removeAttribute("cart"); //把舊有的購物車session移除
            request.getSession().setAttribute("cart",temp); //把新的list存回購物車session
            out.print("產品移除成功");
            out.close();
        }else if (pdaction != null && pdaction.equals("cartCheckOut")) {
            //把購物車清單從session cart抓出來
            List<ProductBean> result = (List<ProductBean>) request.getSession().getAttribute("cart");
            //把會員ID從session memberId抓出來
            Integer memberId = (Integer) request.getSession().getAttribute("memberId");
            if(result!=null){
                //list forward結帳頁面
                request.setAttribute("cart", result);
                //memberId forward到結帳頁面
                request.setAttribute("memberId",memberId);
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
            }else{
                out.print("CharIsEmpty");
                out.close();
            }
        }
    }
}
