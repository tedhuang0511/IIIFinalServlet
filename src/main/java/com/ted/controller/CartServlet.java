package com.ted.controller;

import com.ted.model.ProductBean;
import com.ted.model.ProductService;
import org.json.JSONArray;
import org.json.JSONObject;
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
        doPost(req, resp);
    }

    //計算目前購物車總共有多少數量
    private Integer totalQTYinCart(HashMap<Integer, Integer> map) {
        int totalQtyInCart = 0;
        for (int id : map.keySet()) {
            totalQtyInCart += map.get(id); //算出目前所有產品的數量加總
        }
        return totalQtyInCart;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        //接收參數
        request.setCharacterEncoding("UTF-8");
        response.setHeader("Content-type", "text/html;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setCharacterEncoding("UTF-8");
        var productId0 = request.getParameter("editProductId");
        var quantity0 = request.getParameter("quantity");
        var pdaction = request.getParameter("pdaction");

        //轉換資料
        var quantity = 1; //如果沒給quantity參數預設給1
        if (quantity0 != null && quantity0.length() != 0) {
            quantity = Integer.parseInt(quantity0);
        }
        //轉換資料
        var productId = 0;
        if (productId0 != null && productId0.length() != 0) {
            productId = Integer.parseInt(productId0);
        }

        var out = response.getWriter();
        Integer totalQtyInCart = 0;
        if (pdaction != null && pdaction.equals("addToCart")) {
            //new一個map裡面放 productId跟quantity
            HashMap<Integer, Integer> cartList = new HashMap<>();

            if (request.getSession().getAttribute("cart") != null) {  //如果購物車session已存在
                HashMap<Integer, Integer> temp = (HashMap<Integer, Integer>) request.getSession().getAttribute("cart"); //把購物車session的map抓出
                if (temp.get(productId) == null) {   //如果map裡面抓不到這個productId的key
                    temp.put(productId, quantity); //map新增一個productId,qty
                } else {
                    temp.put(productId, temp.get(productId) + quantity);
                }
                request.getSession().removeAttribute("cart"); //把舊有的購物車session移除
                request.getSession().setAttribute("cart", temp); //把新的list存回購物車session
                totalQtyInCart = totalQTYinCart(temp);
            } else {
                //如果購物車session不存在 就直接new一個session把map存進去
                cartList.put(productId, quantity);
                request.getSession().setAttribute("cart", cartList);
                totalQtyInCart = totalQTYinCart(cartList);
            }
            out.print("購物車新增成功" + totalQtyInCart); //如果有改動會影響checkout.jsp做substring
            out.close();
        } else if (pdaction != null && pdaction.equals("removeProductFromCart")) {
            HashMap<Integer, Integer> temp = (HashMap<Integer, Integer>) request.getSession().getAttribute("cart"); //把session存放的map拿出來
            String output = "購物車內並沒有此商品";
            if (temp.get(productId) != null) {
                //如果此商品數量剩餘1 直接把產品從map移除 ; 商品數量大於1 則 -1
                if (temp.get(productId) == 1) {
                    temp.remove(productId);
                } else {
                    if (quantity == 1) {
                        temp.put(productId, temp.get(productId) - 1);
                    } else if (quantity > 0 && quantity < temp.get(productId)) { //判斷一下前端輸入的值是否在合法範圍
                        temp.put(productId, quantity);
                    } else {
                        out.println("Unexpect error");
                    }
                }
                output = "商品已移除，購物車內目前商品數量=";
            }
            request.getSession().removeAttribute("cart"); //把舊有的購物車session移除
            request.getSession().setAttribute("cart", temp); //把新的Map存回購物車session
            totalQtyInCart = totalQTYinCart(temp);
            out.print(output + totalQtyInCart);
            out.close();
        }else if (pdaction != null && pdaction.equals("removeSingleProducts")) {
            HashMap<Integer, Integer> temp = (HashMap<Integer, Integer>) request.getSession().getAttribute("cart"); //把session存放的map拿出來
            String output = "購物車內並沒有此商品";
            if (temp.get(productId) != null) {
                //如果此商品數量大於1 直接把產品從map移除
                if (temp.get(productId) > 0) {
                    temp.remove(productId);
                } else {
                    out.print("完全移除商品有誤");
                }
                output = "此商品已完全移除，購物車內目前商品數量=";
            }
            request.getSession().removeAttribute("cart"); //把舊有的購物車session移除
            request.getSession().setAttribute("cart", temp); //把新的Map存回購物車session
            totalQtyInCart = totalQTYinCart(temp);
            out.print(output + totalQtyInCart);
            out.close();
        } else if (pdaction != null && pdaction.equals("cartCheckOut")) {
            //TODO 這段基本上可以刪除 前端按鈕點下去後直接跳轉check out就好 但是memberId的attr傳遞要改寫
            //把購物車清單從session cart抓出來
            HashMap<Integer, Integer> result = (HashMap<Integer, Integer>) request.getSession().getAttribute("cart");
            //把會員ID從session memberId抓出來
            Integer memberId = (Integer) request.getSession().getAttribute("memberId");
            if (result != null && !result.isEmpty()) {
                //map forward結帳頁面
                request.setAttribute("cart", new JSONObject(result));
                //memberId forward到結帳頁面
                request.setAttribute("memberId", memberId);
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
            } else {
                out.print("CartIsEmpty");
                out.close();
            }
        } else if (pdaction != null && pdaction.equals("cartCheckOut2")) {
            //把購物車清單從session cart抓出來
            HashMap<Integer, Integer> result = (HashMap<Integer, Integer>) request.getSession().getAttribute("cart");
            if (result != null && result.size() != 0) {
                //把map轉成json object as response
                JSONArray jarr = new JSONArray();
                for (var k : result.keySet()) {
                    ProductBean temp = new ProductBean();
                    temp.setProductId(k);
                    ProductBean bean = productService.select(temp).get(0);
                    JSONObject jo2 = new JSONObject();
                    jo2.put("productId", bean.getProductId());
                    jo2.put("productName", bean.getProductName());
                    jo2.put("productPrice", bean.getProductPrice());
                    jo2.put("productImg", bean.getProductImg1());
                    jo2.put("qty", result.get(k));
                    jo2.put("singleTotal",bean.getProductPrice()*result.get(k));
                    jarr.put(jo2);
                }
                out.print(jarr);
                //out.println(request.getSession().getId());
                out.close();
            } else {
                out.print("CartIsEmpty");
                out.close();
            }
        }
    }
}
