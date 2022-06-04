<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <meta charset="utf-8">
    <script
            src="https://code.jquery.com/jquery-3.6.0.min.js"
            integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
            crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
            crossorigin="anonymous"></script>
</head>
<body>
<h1>Select Product Table Result : ${fn:length(cart)} row(s) selected</h1>
<c:if test="${not empty cart}">
    <div class="border border-2 border-info">
        <table class="table table-success table-hover table-striped w-100">
            <thead>
            <tr>
                <th scope="col">產品名稱</th>
                <th scope="col">產品類別</th>
                <th scope="col">產品價格</th>
                <th scope="col"></th>
                <th scope="col"></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="row" items="${cart}">
                <tr>
                    <td>${row.productName }</td>
                    <td>${row.productCatalog }</td>
                    <td>${row.productPrice }</td>
                    <td><img src="${row.productImg1 }" alt="" style="width: 120px"></td>
                    <td>
                        <button onclick="removeProductFromCart(${row.productId})">移除</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</c:if>
<br>
<div id="memberData" class="border border-2 border-info">
    <h3>訂購人資料</h3>
    會員姓名:Brad Chao<br>
    會員Email:Brad@gmail.com<br>
    會員電話:0910101010<br>
    會員地址:台中市南屯區公益路51號18樓-3<br>
</div>
<br>
<div class="border border-2 border-info">
    <input type="hidden" name="orderId" value="">
    <h3>請選擇付款方式:</h3>
    <input type="radio" id="chooseCVS" name="payMethod" value="超商取貨付款">
    <label for="chooseCVS">超商取貨付款</label><br>
    <div class="d-none" id="test001">
        請選擇您要取貨的超商:
        <input type="text" name="cvs" list="cvs" class="cvs" value="">
        <datalist id="cvs">
            <option value="全家 台中公益路大進店">
            <option value="全家 台中精誠店">
            <option value="7-ELEVEN 三中門市">
            <option value="7-ELEVEN 明義門市">
        </datalist>
    </div>
    <input type="radio" id="onlineCreditCard" name="payMethod" value="線上刷卡宅配">
    <label for="onlineCreditCard">線上刷卡宅配</label><br>
    <div class="d-none" id="test002">
        信用卡號: <input type="text">
    </div>
    <br>
    <div>
        <h3>收件⼈資料：</h3>
        <input type="checkbox" checked>同訂購⼈ <input type="checkbox">修改收件⼈資料<br>
        姓名：Brad Chao<br>
        ⼿機號碼：0910101010<br>
    </div>
    <button onclick="submitOrder()">確認提交訂單</button>
</div>
<button onclick="test987()">test</button>

<script>
    var productList = '${cart}';

    function test987(){
        console.log(productList);
    }

    var payMethod = $("input[name=payMethod]");

    //建立訂單的API
    function submitOrder() {
        $.ajax({
            url: "OrderServlet",
            method: "post",
            data: {
                orderId: createOrderId(),  //前端處裡(檔名組成=YYYYMMDDhhmmSS)
                memberId: 1, //應該要抓session的會員資訊,但目前前台網頁還沒整合到project無法做session控管所以寫死
                payMethod: payMethod.filter(":checked").val(), //抓前端表格內容
                status: "01", //如果他是超商取貨付款就01,線上刷卡就02 //01成立-02已付款-03已出貨-031未付款已出貨-04取消-05完成交付-06退貨
                cvs: $('.cvs').val(), //抓前端表格內容(下拉式選單的超商名稱)
                address: "台中市西屯區水源路123號3樓", //如果使用者選擇宅配有輸入地址的話
                odaction: "createOrder",
                createDate: getNowFormatDate(), //前端傳送
                productList: productList //購物產品清單的json格式"字串"
            },
            success: function (resp) {
                alert(resp);
            },
            error: function () {
                alert("建立訂單失敗");
            }
        });
    }

    $('#chooseCVS').on('click', function () {
        $('#test001').removeClass("d-none");
        $('#test002').addClass("d-none");
    })

    $('#onlineCreditCard').on('click', function () {
        $('#test002').removeClass("d-none");
        $('#test001').addClass("d-none");
    })

    function removeProductFromCart(pid) {
        $.ajax({
            url: "CartServlet",
            method: "post",
            data: {
                pdaction: "removeProductFromCart",
                editProductId: pid
            },
            success: function (response) {
                alert(response);
                window.location.reload();
            },
            error: function () {
                alert("cart remove error");
            }
        });
    }

    function getNowFormatDate() {
        var date = new Date();
        var seperator1 = "-";
        var seperator2 = ":";
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        return date.getFullYear() + seperator1 + addZero(month) + seperator1 + addZero(strDate)
            + " " + date.getHours() + seperator2 + date.getMinutes()
            + seperator2 + date.getSeconds();
    }
    function createOrderId() {
        var date = new Date();
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        return date.getFullYear() + addZero(month) + addZero(strDate) + addZero(date.getHours()) + addZero(date.getMinutes()) + addZero(date.getSeconds());
    }
    function addZero(i) {
        if (i < 10) {i = "0" + i}
        return i;
    }
</script>
</body>
</html>
