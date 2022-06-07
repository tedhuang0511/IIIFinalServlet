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
    <style>
        body {
            margin-left: 100px;
            margin-right: 300px;
        }
    </style>
</head>
<body>
<h1>Select Product Table Result : <b></b> row(s) selected</h1>
<div class="border border-2 border-info">
    <table class="table table-success table-hover table-striped w-100" style="margin-bottom: 0">
        <thead>
        <tr>
            <th scope="col">產品名稱</th>
            <th scope="col">產品圖片</th>
            <th scope="col">產品單價</th>
            <th scope="col">數量</th>
            <th scope="col">單項總額</th>
            <th scope="col"></th>
        </tr>
        </thead>
        <tbody id="test0608">
        </tbody>
        <tfoot>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td>訂單總額= $ <b id="totalpricehtml"></b></td>
        <td></td>
        </tfoot>
    </table>
</div>

<br>
<div id="memberData" class="border border-2 border-info">
    <%--    從下方ajax取得資料放入--%>
</div>
<br>
<div class="border border-2 border-info">
    <input type="hidden" name="orderId" value="">
    <h3>請選擇付款方式:</h3>
    <input type="radio" id="LinePay" name="payMethod" value="LinePay">
    <label for="LinePay">LinePay(提交訂單後會自動跳轉)</label><br>
    <input type="radio" id="payLater" name="payMethod" value="貨到付款">
    <label for="payLater">貨到付款</label><br>
    <input type="radio" id="onlineCreditCard" name="payMethod" value="線上刷卡">
    <label for="onlineCreditCard">線上刷卡</label><br>
    <div class="d-none" id="test002">
        信用卡號: <br>
        <input name="credit-number" class="cc-number" type="tel" maxlength="16" size="20" placeholder="Card Number"><br>
        <input name="credit-expires" class="cc-expires" type="tel" maxlength="7" placeholder="MM / YY"><br>
        <input name="credit-cvc" class="cc-cvc" type="tel" maxlength="4" placeholder="CVC"><br>
    </div>
    <br>
    <h3>配送方式:</h3>
    <input type="radio" id="deliver01" name="deliverWay">
    <label for="deliver01">超商取貨</label><br>
        <div class="d-none" id="test001">
            <input type="text" name="cvs" list="cvs" class="cvs" value="">
            <datalist id="cvs">
                <option value="全家 台中公益路大進店">
                <option value="全家 台中精誠店">
                <option value="7-ELEVEN 三中門市">
                <option value="7-ELEVEN 明義門市">
            </datalist>
        </div>
    <input type="radio" id="deliver02" name="deliverWay">
    <label for="deliver02">宅配</label><br>
        <div id="test006" class="d-none">
            宅配地址: <input type="text" id="test003" size="50">
        </div>
    <br>
    <div>
        <h3>收件⼈資料：</h3>
        <input type="radio" id="receiverOption1" name="receiverOption" value="同訂購人" checked><label
            for="receiverOption1">同訂購人</label>
        <input type="radio" id="receiverOption2" name="receiverOption" value="修改收件人資訊"><label for="receiverOption2">修改收件人資訊</label>
        <br>
        姓名：<input type="text" id="test004"><br>
        ⼿機號碼：<input type="text" id="test005"><br>
    </div>
    <button onclick="submitOrder()">確認提交訂單</button>
</div>
<button onclick="test987()">test</button>

<script>
    var productList;
    let jsonproductList = "XX";
    const memberId = '${memberId}';

    function test987() {
        console.log(payMethod.filter(":checked").val());
        console.log(typeof payMethod.filter(":checked").val())
    }

    //API取得session內購物車產品清單
    $(function () {
        $.ajax({
            url: "CartServlet",
            method: "get",
            data: {
                pdaction: "cartCheckOut2"
            },
            success: function (resp) {
                jsonproductList = resp;
                productList = JSON.parse(resp);
                let str = '';
                let totalprice = 0;
                // $('#test005').prop('value', memberdata[0].memberTel);
                productList.forEach(function (e) {
                    totalprice = totalprice + e.單項總額
                    str = str +
                        `<tr>
                        <td>` + e.productName + `</td>
                        <td><img src="` + e.productImg + `" width="120" /></td>
                        <td>` + e.productPrice + `</td>
                        <td>` + `<button onclick="return addProductToCart(`
                              + e.productId + `);">+</button>`
                              + e.qty + `<button onclick="return addProductToCart(`
                              + e.productId + `);">-</button>` + `</td>
                        <td>` + e.單項總額 + `</td>
                        <td><button onclick="return deleteProductItemConfirm(` + e.productId + `);">刪除品項</button></td>
                        </tr>`
                })
                $('#test0608').html(str);
                $('#totalpricehtml').text(totalprice);
            },
            error: function (resp) {
                console.log(resp);
            }
        })
    })

    //API取得該會員資料放入html
    $(function () {
        $.ajax({
            url: "http://bosian.ddns.net:8080/IIIFinalServlet_war_exploded/MemberServlet?memberAction=SelectAll&memberId=4",
            method: "get",
            data: {
                memberAction: "SelectAll",
                memberId: memberId
            },
            success: function (resp) {
                var memberdata = JSON.parse(resp);
                $('#test004').prop('value', memberdata[0].memberLastname + memberdata[0].memberFirstname);
                $('#test005').prop('value', memberdata[0].memberTel);
                let str = '';
                str = str + `<h3>訂購人資料</h3>
                        會員姓名:` + memberdata[0].memberLastname + memberdata[0].memberFirstname + `<br>
                        會員Email:` + memberdata[0].memberEmail + `<br>
                        會員電話:` + memberdata[0].memberTel + `<br>
                        會員地址:` + memberdata[0].memberAddr + `<br>`
                $('#memberData').html(str);
            },
            error: function (resp) {
                console.log(resp);
            }
        })
    })

    var payMethod = $("input[name=payMethod]");

    //建立訂單的API
    function submitOrder() {
        if ($("input[name=payMethod]").filter(":checked").val()=="LinePay"){
            console.log("WQEEEEEEEEEEEEEEASDASDASXXXXXXXXXXX")
        }
        $.ajax({
            url: "OrderServlet",
            method: "post",
            data: {
                orderId: createOrderId(),  //前端處裡(檔名組成=YYYYMMDDhhmmSS)
                memberId: 4, //應該要抓session的會員資訊,但目前前台網頁還沒整合到project無法做session控管所以寫死
                payMethod: payMethod.filter(":checked").val(), //抓前端表格內容
                cvs: $('.cvs').val(), //抓前端表格內容(下拉式選單的超商名稱)
                address: $('#test003').val(), //如果使用者選擇宅配有輸入地址的話
                odaction: "createOrder",
                createDate: getNowFormatDate(), //前端傳送
                productList: jsonproductList //購物產品清單的json格式"字串"
            },
            success: function (resp) {
                alert(resp);
                window.location.href = "home.jsp";
            },
            error: function () {
                alert("建立訂單失敗");
            }
        });
    }

    $('#LinePay').on('click', function () {
        $('#test002').addClass("d-none");
    })
    $('#payLater').on('click', function () {
        $('#test002').addClass("d-none");
    })
    $('#onlineCreditCard').on('click', function () {
        $('#test002').removeClass("d-none");
    })
    $('#deliver02').on('click',function(){
        $('#test001').addClass("d-none");
        $('#test006').removeClass("d-none");
        $('#test003').prop('value', "台中市南屯區公益路51號18樓-3");
        $('.cvs').prop('value',"");
    })
    $('#deliver01').on('click',function(){
        $('#test001').removeClass("d-none");
        $('#test006').addClass("d-none");
        $('#test003').prop('value', "");
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
        if (i < 10) {
            i = "0" + i
        }
        return i;
    }
</script>
</body>
</html>
