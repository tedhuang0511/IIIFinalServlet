package tw.com.ispan.cma.controller;


import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.beans.propertyeditors.CustomNumberEditor;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import tw.com.ispan.cma.domain.ProductBean;
import tw.com.ispan.cma.service.ProductService;


import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(path = {"/public/api"})
public class CartController {
    @Autowired
    private ProductService productService;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private ServletContext application;

    @Autowired
    private HttpSession httpSession;

    @InitBinder
    public void init(WebDataBinder webDataBinder){
        //照操的不知道為何要有這項
    }

    @PostMapping (path = {"/callCartController"})
    public @ResponseBody String handlerMethod(Model model, String pdaction, String editProductId,
                                              String quantity, ProductBean bean, BindingResult bindingResult){
        System.out.println("callCartController這功能有被呼叫到");
        System.out.println("pdaction = " + pdaction);
        System.out.println("editProductId = " + editProductId);
        System.out.println("quantity = " + quantity);
//接收資料
//轉換資料
        Map<String, String> errors = new HashMap<String, String>();
        model.addAttribute("errors", errors);

        //暫時這樣解決，不確定正式放這嗎
        //因應cartCheckOut2不需要這兩個參數
        int productId = 0;
        if(editProductId!=null) {
            productId = Integer.parseInt(editProductId);
        }
        int qty = 0;
        if(quantity!=null) {
            qty = Integer.parseInt(quantity);
        }

        if(bindingResult!=null && bindingResult.hasFieldErrors()) {
            if(bindingResult.hasFieldErrors("id")) {
                errors.put("pdaction", "pdaction有問題");
                return "pdaction有問題";
            }
            if(bindingResult.hasFieldErrors("price")) {
                errors.put("productId", "productId有問題");
                return "productId有問題";
            }
            if(bindingResult.hasFieldErrors("make")) {
                errors.put("quantity", "quantity有問題");
                return "quantity有問題";
            }
        }

//驗證資料
        if("addToCart".equals(pdaction) || "removeProductFromCart".equals(pdaction) || "removeSingleProducts".equals(pdaction)||
                "cartCheckOut".equals(pdaction)|| "cartCheckOut2".equals(pdaction)) {
//            if(bean==null || bean.getProductId() ==null) {
//                errors.put("id", "ProductId為空值");
//                return "ProductId為空值";
//            }
            System.out.println("這行理論上都會成立但我還不需要驗證bean");
        }

        if(errors!=null && !errors.isEmpty()) {
            System.out.println("完全沒有錯誤");
        }
//呼叫Model, 根據Model執行結果吐出客戶要的東西

        Integer totalQtyInCart = 0;
        if (pdaction != null && pdaction.equals("addToCart")) {
            //new一個map裡面放 productId跟quantity
            HashMap<Integer, Integer> cartList = new HashMap<>();

            if (httpSession.getAttribute("cart") != null) {  //如果購物車session已存在
                HashMap<Integer, Integer> temp = (HashMap<Integer, Integer>) httpSession.getAttribute("cart"); //把購物車session的map抓出
                if (temp.get(productId) == null) {   //如果map裡面抓不到這個productId的key
                    temp.put(productId, qty); //map新增一個productId,qty
                } else {
                    temp.put(productId, temp.get(productId) + qty);
                }
                httpSession.removeAttribute("cart"); //把舊有的購物車session移除
                httpSession.setAttribute("cart", temp); //把新的list存回購物車session
                totalQtyInCart = totalQTYinCart(temp);
            } else {
                //如果購物車session不存在 就直接new一個session把map存進去
                cartList.put(productId, qty);
                httpSession.setAttribute("cart", cartList);
                totalQtyInCart = totalQTYinCart(cartList);
            }
            return ("購物車新增成功:不分品項商品總數 = "+ totalQtyInCart);  //如果有改動會影響checkout.jsp做substring
        }else if (pdaction != null && pdaction.equals("removeProductFromCart")) {
            HashMap<Integer, Integer> temp = (HashMap<Integer, Integer>) httpSession.getAttribute("cart"); //把session存放的map拿出來
            String output = "購物車內並沒有此商品";
            if (temp.get(productId) != null) {
                //如果此商品數量剩餘1 直接把產品從map移除 ; 商品數量大於1 則 -1
                if (temp.get(productId) == 1) {
                    temp.remove(productId);
                } else {
                    if (qty == 1) {
                        temp.put(productId, temp.get(productId) - 1);
                    } else if (qty > 0 && qty < temp.get(productId)) { //判斷一下前端輸入的值是否在合法範圍
                        temp.put(productId, qty);
                    } else {
                        return ("Unexpect error");
                    }
                    output = "商品已移除，購物車內不分品項商品數量=";
                }
            }
            httpSession.removeAttribute("cart"); //把舊有的購物車session移除
            httpSession.setAttribute("cart", temp); //把新的Map存回購物車session
            totalQtyInCart = totalQTYinCart(temp);
            return (output + totalQtyInCart);
        }else if (pdaction != null && pdaction.equals("removeSingleProducts")) {
            HashMap<Integer, Integer> temp = (HashMap<Integer, Integer>) httpSession.getAttribute("cart"); //把session存放的map拿出來
            String output = "購物車內並沒有此商品";
            if (temp.get(productId) != null) {
                //如果此商品數量大於1 直接把產品從map移除
                if (temp.get(productId) > 0) {
                    temp.remove(productId);
                } else {
                    return "完全移除商品有誤";
                }
                output = "此商品已完全移除，購物車內不分品項商品數量=";
            }
            httpSession.removeAttribute("cart"); //把舊有的購物車session移除
            httpSession.setAttribute("cart", temp); //把新的Map存回購物車session
            totalQtyInCart = totalQTYinCart(temp);
            return (output + totalQtyInCart);
        }else if (pdaction != null && pdaction.equals("cartCheckOut")) {
            //TODO 這段基本上可以刪除 前端按鈕點下去後直接跳轉check out就好 但是memberId的attr傳遞要改寫
            //把購物車清單從session cart抓出來
            HashMap<Integer, Integer> result = (HashMap<Integer, Integer>) httpSession.getAttribute("cart");
            //把會員ID從session memberId抓出來
            Integer memberId = (Integer) httpSession.getAttribute("memberId");
            if (result != null && !result.isEmpty()) {
                //map forward結帳頁面
                httpSession.setAttribute("cart", new JSONObject(result));
                //memberId forward到結帳頁面
                httpSession.setAttribute("memberId", memberId);
//                request.getRequestDispatcher("checkout.jsp").forward(request, response);//這個不知道怎麼改寫
            } else {
                return "CartIsEmpty";
            }
        }else if (pdaction != null && pdaction.equals("cartCheckOut2")) {
            //把購物車清單從session cart抓出來
            HashMap<Integer, Integer> result = (HashMap<Integer, Integer>) httpSession.getAttribute("cart");
            if (result != null && result.size() != 0) {
                //把map轉成json object as response
                JSONArray jarr = new JSONArray();
                for (var k : result.keySet()) {
                    ProductBean temp = new ProductBean();
                    temp.setProductId(k);
                    ProductBean checkOutBean = productService.select(temp).get(0);
                    JSONObject jo2 = new JSONObject();
                    jo2.put("productId", checkOutBean.getProductId());
                    jo2.put("productName", checkOutBean.getProductName());
                    jo2.put("productPrice", checkOutBean.getProductPrice());
                    jo2.put("productImg", checkOutBean.getProductImg1());
                    jo2.put("qty", result.get(k));
                    jo2.put("singleTotal",checkOutBean.getProductPrice()*result.get(k));
                    jarr.put(jo2);
                }
                //原本是 out.print(jarr)這樣應該沒錯
                return jarr.toString();
            } else {
                return "CartIsEmpty";
            }
        }
        return "應該不可能淪落到這行";
    }

    private Integer totalQTYinCart(HashMap<Integer, Integer> map) {
        int totalQtyInCart = 0;
        for (int id : map.keySet()) {
            totalQtyInCart += map.get(id); //算出目前所有產品的數量加總
        }
        return totalQtyInCart;
    }

}
