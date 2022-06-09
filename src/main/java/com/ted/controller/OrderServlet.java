package com.ted.controller;

import com.ted.model.*;
import com.ted.utils.JavaMail;
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
    private MembersService membersService;

    public void init() {
        ServletContext application = this.getServletContext();
        ApplicationContext context = (ApplicationContext) application.getAttribute(
                WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
        orderService = context.getBean("orderService", OrderService.class);
        membersService = context.getBean("membersService", MembersService.class);
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
        var updateDate0 = request.getParameter("updateDate");
        var productList = request.getParameter("productList");
        System.out.println(odaction + " from orderservelet " + orderId0 + " : " + memberId0 + " : " + payMethod + " : " + cvs0 + " : " + address0 + " : " + createDate0 + " : " +updateDate0);
        System.out.println("XXXXX"+productList+"XXXXXXXXX");

        Map<String, String> errors = new HashMap<>();
        request.setAttribute("errors", errors);

        MemberOrderBean bean = new MemberOrderBean();
        MembersBean mbean = new MembersBean();
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
            java.util.Date updateDate = null;
            if(updateDate0!=null && updateDate0.length()!=0) {
                try {
                    updateDate = sFormat.parse(updateDate0);
                } catch (ParseException e) {
                    e.printStackTrace();
                    errors.put("createDate", "Make must be a date of YYYY-MM-DD");
                }
            }

            //呼叫Model
            mbean.setMemberId(memberId);
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
            bean.setUpdateDate(updateDate);

            if(productList!=null){
                JSONArray jsonarr = new JSONArray(productList); //把前端json字串轉乘json array
                for(int i=0; i<jsonarr.length(); i++) {
                    System.out.println("-----------start----------------");
                    System.out.println(jsonarr.get(i).toString());
                    OrderDetailBean odbean = new OrderDetailBean();
                    JSONObject jobj = new JSONObject(jsonarr.get(i).toString()); //把json array裡面的json物件字串轉成json object
                    System.out.println(jobj.get("productName"));
                    odbean.setOrderId(orderId);
                    odbean.setProductId((Integer) jobj.get("productId")); //放入json object裡面 名為productId的key 的value
                    odbean.setQuantity((Integer) jobj.get("qty"));
                    odbean.setUnitPrice((Integer) jobj.get("productPrice")); //放入json object裡面 名為producPrice的key 的value
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
                System.out.println("XXXXXXXXXXXX  " + result1.getCreateDate() + "  XXXXXXXXXXXXX");
                if(result1!=null){
                    //重構字串,把memberorderbean JSON裡面多加一個key(訂單明細),value放orderdetailbean的陣列裡面包json物件
                    var str = "[{" +
                            "\"訂單編號\" : " + '\"' + result1.getOrderId() + '\"' +
                            ", \"會員編號\" : " + '\"'+ result1.getMemberId() + '\"' +
                            ", \"付款方式\" : " + '\"'+ result1.getPayMethod() + '\"' +
                            ", \"狀態\" : " + '\"'+ result1.getStatus() + '\"' +
                            ", \"訂單建立日期\" : " + '\"'+ result1.getCreateDate().toString() + '\"' +
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
                if(payMethod.equals("貨到付款")){
                    bean.setStatus("01");
                }else{
                    bean.setStatus("02");
                }
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
                //把session購物車清空
                request.getSession().removeAttribute("cart");
            }catch (Exception e){
                out.print(e);
            }finally {
                out.close();
            }
            //發送訂單明細到member的email
            var member = membersService.select(mbean).get(0);
            System.out.println(member.getMemberEmail());
            JavaMail javaMail = new JavaMail(member.getMemberEmail(),member.getMemberLastname()+" "+member.getMemberFirstname());
            String res = javaMail.sendMail(javaMail.createText(productList));
            System.out.println(res);
            //發送訂單明細到member的email
        } else if (odaction != null && odaction.equals("Deliver")) {
            System.out.println("come in update statement at OrderServlet");
            Boolean result = orderService.deliver(bean);
            if (!result) {
                out.println("更新失敗 update failed!");
            } else {
                out.println("更新完成!");
            }
        } else if (odaction != null && odaction.equals("Receive")) {
            boolean result = orderService.receive(bean);
            if(!result) {
                out.println("更新失敗 update failed!");
            } else {
                out.println("更新完成!");
            }
        } else if (odaction != null && odaction.equals("CancelOrder")) {
            System.out.println("CancelOrder in orderservlet");
            boolean result = orderService.cancelOrder(bean);
            if(!result) {
                out.println("訂單取消失敗 cancel failed!");
            } else {
                out.println("訂單取消完成!");
            }
        }
    }
}
