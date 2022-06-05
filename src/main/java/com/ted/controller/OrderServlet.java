package com.ted.controller;

import com.ted.model.MemberOrderBean;
import com.ted.model.OrderDetailBean;
import com.ted.model.OrderService;
import org.hibernate.criterion.Order;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderServlet", value = "/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SimpleDateFormat sFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private OrderService orderService;

    public void init() {
        ServletContext application = this.getServletContext();
        ApplicationContext context = (ApplicationContext) application.getAttribute(
                WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
        orderService = context.getBean("orderService", OrderService.class);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        //接收參數
        request.setCharacterEncoding("UTF-8");
        response.setHeader("Content-type", "text/html;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin","*");
        response.setCharacterEncoding("UTF-8");
        var username = (String) request.getSession().getAttribute("login");
        var orderId0 = request.getParameter("orderId");
        var memberId0 = request.getParameter("memberId");
        var payMethod = request.getParameter("payMethod");
        var status0 = request.getParameter("status");
        var cvs0 = request.getParameter("cvs");
        var address0 = request.getParameter("address");
        var odaction = request.getParameter("odaction");
        var createDate0 = request.getParameter("createDate");
        var productList = request.getParameter("productList");
        System.out.println(odaction + " from productservelet " + orderId0 + " : " + memberId0 + " : " + payMethod + " : " + cvs0 + " : " + address0 + " : " + createDate0);

        Map<String, String> errors = new HashMap<>();
        request.setAttribute("errors", errors);

        MemberOrderBean bean = new MemberOrderBean();
        List<OrderDetailBean> odbeanlist = new ArrayList<>();
        try {
            //轉換資料

            int seqno = 0; //seqno是 PK+AI 永遠不會讓使用者自行決定所以都給0, DAO發現是0之後就會自己去生成seqno

            String orderId = "XX"; //如果抓不到id就給預設id為"XX"
            if (orderId0 != null && orderId0.length() != 0) {
                try {
                    orderId = orderId0;
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                    errors.put("orderId", "order ID錯誤");
                }
            }
            int memberId = 0;
            if (memberId0 != null && memberId0.length() != 0) {
                try {
                    memberId = Integer.parseInt(memberId0);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                    errors.put("memberId", "memberId有誤");
                }
            }
            String status = "00";
            if (status0 != null && status0.length() != 0) {
                status = status0;
            }
            String cvs = "N/A";
            if (cvs0 != null && cvs0.length() != 0) {
                cvs = cvs0;
            }
            String address = "N/A";
            if (address0 != null && address0.length() != 0) {
                address = address0;
            }
            java.util.Date createDate = null;
            if(createDate0!=null && createDate0.length()!=0) {
                try {
                    createDate = sFormat.parse(createDate0);
                } catch (ParseException e) {
                    e.printStackTrace();
                    errors.put("createDate", "Make must be a date of YYYY-MM-DD");
                }
            }

            //呼叫Model
            bean.setSeqno(seqno);
            bean.setOrderId(orderId);
            bean.setMemberId(memberId);
            bean.setStatus(status);
            bean.setPayMethod(payMethod);
            bean.setDeliverCvs(cvs);
            bean.setDeliverAddr(address);
            bean.setUpdateUser(username);
            bean.setCreateUser(username);
            bean.setCreateDate(createDate);
            bean.setUpdateDate(createDate);

            if(productList!=null){
                JSONArray jsonarr = new JSONArray(productList); //把前端json字串轉乘json array
                for(int i=0; i<jsonarr.length(); i++) {
                    System.out.println("-----------start----------------");
                    System.out.println(jsonarr.get(i).toString());
                    OrderDetailBean odbean = new OrderDetailBean();
                    JSONObject jobj = new JSONObject(jsonarr.get(i).toString()); //把json array裡面的json物件字串轉成json object
                    System.out.println(jobj.get("productName"));
                    odbean.setOrderId(orderId);
                    odbean.setProductId(Integer.parseInt((String) jobj.get("productId"))); //放入json object裡面 名為productId的key 的value
                    odbean.setQuantity(1);  //TODO 如何判斷是否有重複的商品
                    odbean.setUnitPrice(Integer.parseInt((String) jobj.get("productPrice"))); //放入json object裡面 名為producPrice的key 的value
                    odbeanlist.add(odbean);
                    System.out.println("--------------end-------------");
                }
            }

        } catch (Exception e) {
            System.out.println(e);
        }

        var out = response.getWriter();
        //判斷增刪修查
        if (odaction != null && odaction.equals("Select")) {
            System.out.println("come in select statement at OrderServlet");
            List<Object> result = orderService.select(bean);
            if(result.size()==2){ //如果是有order+order detail
                MemberOrderBean result1 = (MemberOrderBean) result.get(0);
                if(result1!=null){
                    //重構字串,把memberorderbean JSON裡面多加一個key(訂單明細),value放orderdetailbean的陣列裡面包json物件
                    var str = "[{" +
                            "\"訂單編號\" : " + '\"' + result1.getOrderId() + '\"' +
                            ", \"會員編號\" : " + '\"'+ result1.getMemberId() + '\"' +
                            ", \"付款方式\" : " + '\"'+ result1.getPayMethod() + '\"' +
                            ", \"狀態\" : " + '\"'+ result1.getStatus() + '\"' +
                            ", \"訂單建立日期\" : " + '\"'+ result1.getCreateDate() + '\"' +
                            ", \"出貨日期\" : " + '\"'+ result1.getDeliveredDate() + '\"' +
                            ", \"到貨超商\" : " + '\"'+ result1.getDeliverCvs() + '\"' +
                            ", \"宅配地址\" : " + '\"'+ result1.getDeliverAddr() + '\"' +
                            ", \"已交付日期\" : " + '\"'+ result1.getReceivedDate() + '\"' +
                            ", \"訂單明細\" : " + result.get(1) +
                            "}]";
                    out.print(str);
                }else{
                    out.print("");
                    out.close();
                }
            }else{//只有orders
                List<MemberOrderBean> result1 = (List<MemberOrderBean>) result.get(0);
                if(result1!=null){
                    var arr = new ArrayList<>();
                    for(var mobean: result1){
                        arr.add(mobean.toString());
                    }
                    out.print(arr);
                }else{
                    out.print("");
                    out.close();
                }
            }
        }else if (odaction != null && odaction.equals("createOrder")) {
            System.out.println("come in insert statement at OrderServlet");
            try {
                orderService.insert(bean);
                System.out.println("odbean數量: " + odbeanlist.size());
                int result = 0;
                for (var odbean : odbeanlist) {
                    var temp = orderService.insert(odbean);
                    if (temp!=0){
                        result++;
                    }
                }
                out.print("訂單新增完成" + "   明細增加 : " + result + " 筆");
            }catch (Exception e){
                out.print(e);
            }finally {
                out.close();
            }
//        } else if (pdaction != null && pdaction.equals("Update")) {
//            System.out.println("come in update statement at ProductServlet");
//            ProductBean result = productService.update(bean);
//            if (result == null) {
//                out.println("更新失敗 update failed!");
//            } else {
//                out.println("更新完成!");
//            }
//        } else if (pdaction != null && pdaction.equals("Delete")) {
//            System.out.println("send delete to product service");
//            boolean result = productService.delete(bean);
//            System.out.println(result);
////            if(!result) {
////                request.setAttribute("delete", 0);
////            } else {
////                request.setAttribute("delete", 1);
////            }
////            request.getRequestDispatcher(
////                    "/pages/product.jsp").forward(request, response);
//        } else if (pdaction != null && pdaction.equals("DeleteImg")) {
//            System.out.println("send img delete to ps");
//            productService.deleteImg(bean, imgIndex);
//        } else {
//            errors.put("action", "Unknown Action:" + pdaction);
////            request.getRequestDispatcher(
////                    "/pages/product.jsp").forward(request, response);
        }
    }
}
