<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>JAVA42-生活倉庫Q</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
            crossorigin="anonymous"></script>
    <%--    <link rel="stylesheet" type="text/css" href="css/mycss.css">--%>
</head>
<body>
<div id="order01" class="d-block">
    <div class="pt-3 pb-2 mb-3">
        <div class="fw-bold fs-3">訂單管理</div>
        <div>
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button id="orderQueryTab" class="active nav-link">搜尋條件</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button id="orderEditTab" class="nav-link ">編輯頁</button>
                </li>
            </ul>
        </div>
    </div>

    <div id="orderContent">
        <!--訂單管理搜尋區域控制 START-->
        <div class="tab-pane fade show active" id="query" role="tabpanel" aria-labelledby="query-tab">
            <div style="margin-top: -18px; margin-bottom: -8px">
                <button class="button-54 order-query"><img src=".././images/search.png" style="width: 20px"
                                                           alt="">查詢
                </button>
            </div>
            <table class="table table-hover">
                <thead>
                <tr>
                    <th scope="col" colspan="4">

                    </th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td scope="row" style="text-align: end"><label for="queryOrderId">訂單編號</label></td>
                    <td><input type="text" id="queryOrderId" value=""></td>
                    <td scope="row" style="text-align: end"><label for="queryOrderStatus">訂單狀態</label></td>
                    <td><input type="text" id="queryOrderStatus" value=""></td>
                </tr>
                <tr>
                    <td scope="row" style="text-align: end">付款方式</td>
                    <td>
                        <input type="text" name="queryOrderPayMethod" list="queryOrderPayMethod"
                               class="queryOrderPayMethod"
                               value="">
                        <datalist id="queryOrderPayMethod">
                            <option value="貨到付款">
                            <option value="線上刷卡">
                            <option value="LinePay">
                        </datalist>
                    </td>
                    <td scope="row" style="text-align: end"><label for="queryMemberId">會員編號</label></td>
                    <td><input type="text" id="queryMemberId" value=""></td>
                </tr>
                <tr>
                    <td scope="row" style="text-align: end"><label for="queryCreateDateFrom">訂單建立起始日</label></td>
                    <td><input type="datetime-local" id="queryCreateDateFrom" value=""></td>
                    <td scope="row" style="text-align: end"><label for="queryCreateDateTO">訂單建立迄日</label></td>
                    <td><input type="datetime-local" id="queryCreateDateTO" value=""></td>
                </tr>
                </tbody>
            </table>
        </div>
        <div id="orderList" class="d-none">
            <h6>Select Order Table Result : <b></b></h6>
            <table class="table table-success table-hover table-striped w-100">
                <thead>
                <tr>
                    <th scope="col">訂單編號</th>
                    <th scope="col">編輯</th>
                    <th scope="col">會員ID</th>
                    <th scope="col">付款方式</th>
                    <th scope="col">訂單狀態</th>
                    <th scope="col">訂單建立日</th>
                    <th scope="col">出貨日期</th>
                    <th scope="col">到貨超商</th>
                    <th scope="col">宅配地址</th>
                    <th scope="col">商品交付日</th>
                </tr>
                </thead>
                <tbody id="orderContent2">
                </tbody>
            </table>
            <div class="container" style="margin-left: -25px">
                <div class="row" id="orderContent1">
                </div>
                <nav aria-label="Page navigation example">
                    <ul class="pagination" id="orderpageid">
                    </ul>
                </nav>
            </div>
        </div>
    </div> <!--訂單管理搜尋區域控制 END-->
    <!--訂單管理 編輯 區域控制 START-->
    <div id="orderEdit" class="d-none">
        <div class="tab-pane fade show active " role="tabpanel"
             aria-labelledby="orderEdit-tab">
            <div style="margin-top: -18px; margin-bottom: -8px">
                <button class="button-54 orderActionButtons" data-id="" onclick="return orderActionConfirm(`Deliver`)"><img
                        src="images/search.png" style="width: 20px"
                        alt="">訂單已出貨
                </button>
                <button class="button-54" onclick="return orderActionConfirm(`Receive`)"><img
                        src="images/search.png" style="width: 20px"
                        alt="">確認已取貨按鈕
                </button>
                <button class="button-54" onclick="return orderActionConfirm(`UpdateDetail`)"><img
                        src="images/search.png" style="width: 20px"
                        alt="">更新訂單明細
                </button>
                <button class="button-54" onclick="return orderActionConfirm(`CancelOrder`)"><img
                        src="images/search.png" style="width: 20px"
                        alt="">取消訂單
                </button>

                <div class="border border-2 border-info" style="margin-top: 10px; margin-bottom: 10px">
                    <h3>訂購產品清單</h3>
                    <table class="table table-success table-hover table-striped w-100">
                        <thead>
                        <tr>
                            <th scope="col">產品名稱</th>
                            <th scope="col">產品價格</th>
                            <th scope="col">產品照片</th>
                            <th scope="col">購買數量</th>
                            <th scope="col">單項總計</th>
                        </tr>
                        </thead>
                        <tbody id="orderdataillist00">
                            <tr>
                                <td>aaa</td>
                                <td>3c</td>
                                <td>666</td>
                                <td>aaa.jpg</td>
                                <td>aaa.jpg</td>
                            </tr>
                        </tbody>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td>訂單總計：<b id="ordertotalprice"></b></td>
                        </tr>
                    </table>
                </div>
                <div id="memberData" class="border border-2 border-info">
                        <h3>訂購人資料</h3>
                        會員姓名:Brad Chao<br>
                        會員Email:Brad@gmail.com<br>
                        會員電話:0910101010<br>
                        會員地址:台中市南屯區公益路51號18樓-3<br>
                </div>

                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th scope="col" colspan="4">

                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td style="text-align: end"><label for="editOrderId">訂單編號</label></td>
                        <td><input type="text" id="editOrderId" value=""></td>
                        <td style="text-align: end"><label for="editOrderStatus">訂單狀態</label></td>
                        <td><input type="text" id="editOrderStatus" value=""></td>
                    </tr>
                    <tr>
                        <td style="text-align: end">付款方式</td>
                        <td>
                            <input type="text" name="editOrderPayMethod" list="editOrderPayMethod"
                                   class="editOrderPayMethod"
                                   value="">
                            <datalist id="editOrderPayMethod">
                                <option value="超商取貨付款">
                                <option value="線上刷卡宅配">
                            </datalist>
                        </td>
                        <td style="text-align: end"><label for="editMemberId">會員編號</label></td>
                        <td><input type="text" id="editMemberId" value=""></td>
                    </tr>
                    <tr>
                        <td style="text-align: end"><label for="editCreateDate">訂單成立日</label></td>
                        <td><input type="text" id="editCreateDate" readonly></td>
                        <td style="text-align: end"><label for="editDeliverDate">訂單出貨日</label></td>
                        <td><input type="text" id="editDeliverDate" value=""></td>
                    </tr>
                    <tr>
                        <td style="text-align: end"><label for="editReceivedDate">完成訂單日</label></td>
                        <td><input type="text" id="editReceivedDate" value=""></td>
                        <td style="text-align: end"><label for="editCvs">取貨超商</label></td>
                        <td><input type="text" id="editCvs" value=""></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div><!--訂單管理 編輯 區域控制 END-->
</div>

<script>
    //把所有order列出並且加上分頁功能
    var orderJsonData = {};
    $('.order-query').click(
        function () {
            $.ajax({
                url: "OrderServlet",
                method: "get",
                data: {
                    odaction: "Select",
                    orderId: $('#queryOrderId').val(),
                    status: $('#queryOrderStatus').val(),
                    memberId: $('#queryMemberId').val()
                },
                success: function (responseText) {
                    if (responseText === "") {
                        $('#orderContent2').empty();
                        alert("找不到任何商品!!!")
                    } else {
                        orderJsonData = JSON.parse(responseText);
                        console.log(orderJsonData);
                        orderPagination(orderJsonData, 1);
                    }
                }
            });
        }
    );

    function orderPagination(orderJsonData, nowPage) {
        console.log(nowPage);
        let currentPage = nowPage;
        // 取得資料長度
        const dataTotal = Object.keys(orderJsonData).length;
        $('#orderList b').html(dataTotal);
        // 要顯示在畫面上的資料數量，預設每一頁只顯示10筆資料。
        const perpage = 10;
        //總頁數
        const pageTotal = Math.ceil(dataTotal / perpage);
        // 當"當前頁數"比"總頁數"大的時候，"當前頁數"就等於"總頁數"
        if (currentPage > pageTotal) {
            currentPage = pageTotal;
        }
        var minData = (currentPage * perpage) - perpage + 1;
        var maxData = (currentPage * perpage);
        console.log("全部資料:" + dataTotal + "每一頁顯示:" + perpage + "總頁數: " + pageTotal);

        const data = [];
        orderJsonData.forEach((item, index) => {
            // 獲取陣列索引，但因為索引是從 0 開始所以要 +1。
            const num = index + 1;

            // 當 num 比 minData 大且又小於 maxData 就push進去新陣列。
            if (num >= minData && num <= maxData) {
                data.push(item);
            }
        })

        var page = {
            pageTotal,
            currentPage,
            hasPage: currentPage > 1,
            hasNext: currentPage < dataTotal,
        }
        orderDisplayData(data);
        orderPageBtn(page);
    }

    function orderDisplayData(data) {
        let str = '';
        console.log("--display--");
        console.log(data);
        console.log(`--disp${data}lay--`);
        data.forEach(function (element) {
            var orderid = element.訂單編號;
            var memberid = element.會員編號;
            var paymethod = element.付款方式;
            var status = element.狀態;
            var createDate = element.訂單建立日期;
            var deliverDate = element.出貨日期;
            var cvs = element.到貨超商;
            var address = element.宅配地址;
            var receivedDate = element.已交付日期;
            str = str +
                `<tr>
                        <td>` + orderid + `</td>
                        <td><img class="edit" src="images/edit.png" alt=""
                                 onclick="editOrderIcon(` + orderid + `)">
                        </td>
                        <td>` + memberid + `</td>
                        <td>` + paymethod + `</td>
                        <td>` + status + `</td>
                        <td>` + createDate + `</td>
                        <td>` + deliverDate + `</td>
                        <td>` + cvs + `</td>
                        <td>` + address + `</td>
                        <td>` + receivedDate + `</td>
                </tr>`
        });
        $('#orderContent2').html(str);
    }

    function orderPageBtn(page) {
        let str = '';
        const total = page.pageTotal;

        if (page.hasPage) {
            str += `<li class="page-item"><a class="page-link" href="#" data-page="` + (Number(page.currentPage) - 1) + `">Previous</a></li>`;
        } else {
            str += `<li class="page-item disabled"><span class="page-link">Previous</span></li>`;
        }


        for (let i = 1; i <= total; i++) {
            if (Number(page.currentPage) === i) {
                str += `<li class="page-item active"><a class="page-link" href="#" data-page="` + i + `">` + i + `</a></li>`;
            } else {
                str += `<li class="page-item"><a class="page-link" href="#" data-page="` + i + `">` + i + `</a></li>`;
            }
        }

        if (page.hasNext) {
            str += `<li class="page-item"><a class="page-link" href="#" data-page="` + (Number(page.currentPage) + 1) + `">Next</a></li>`;
        } else {
            str += `<li class="page-item disabled"><span class="page-link">Next</span></li>`;
        }

        $('#orderpageid').html(str);
    }

    function OrderSwitchPage(e) {
        e.preventDefault();
        if (e.target.nodeName !== 'A') return;
        const page = e.target.dataset.page;
        orderPagination(orderJsonData, page);
    }

    $('#orderpageid').on('click', OrderSwitchPage)
</script>

<script>
    //TODO 訂單編輯頁面上方四顆按鈕的處理
    function orderActionConfirm(action){
        const isDel = confirm("確定執行?");
        if (isDel === true) {
            doOrderAction(action);
        }
    }

    function doOrderAction(action){
        $.ajax({
            url: "OrderServlet",
            method: "post",
            data: {
                odaction: action,
                updateDate: getNowFormatDate(),
                orderId: $('#editOrderId').val()
            },
            success: function (res) {
                alert(res);
            },
            error: function () {
                alert("unexpect error");
            }
        });
    }

    //產品清單的編輯按鈕被點擊時觸發
    function editOrderIcon(orderid) {
        var settings = {
            "url": "http://localhost:8080/IIIFinalServlet_war_exploded/OrderServlet?odaction=Select&orderId=" + orderid,
            "method": "GET",
            "timeout": 0,
            "headers": {
                "Cookie": "JSESSIONID=9456E36BD1F5E383BC4944B9D78F5940"
            }
        };
        $.ajax(settings).done(function (response) {
            let orderliststr = '';
            let ordertotalprice = 0;
            var res = JSON.parse(response)
            $('#editOrderId').prop('value', res[0].訂單編號)  //當使用者點下編輯icon把訂單資訊傳到編輯頁面
            $('#editOrderStatus').prop('value', res[0].狀態)
            $('.editOrderPayMethod').prop('value', res[0].付款方式)
            $('#editMemberId').prop('value', res[0].會員編號)
            $('#editCreateDate').prop('value', res[0].訂單建立日期)
            $('#editDeliverDate').prop('value', res[0].出貨日期)
            $('#editReceivedDate').prop('value', res[0].已交付日期)
            $('#editCvs').prop('value', res[0].到貨超商)
            res[0].訂單明細.forEach(function (item) {
                var productId = item.productId;
                var settings2 = {
                    "url": "http://localhost:8080/IIIFinalServlet_war_exploded/ProductServlet?pdaction=Select1&editProductId=" + productId,
                    "method": "POST",
                    "timeout": 0,
                    "headers": {
                        "Cookie": "JSESSIONID=F66ADC03731A8FA7B65582FE2F15E2E0"
                    },
                };
                $.ajax(settings2).done(function (response) {
                    var jsondata = JSON.parse(response)
                    ordertotalprice = ordertotalprice + (parseInt(item.quantity) * parseInt(item.unitPrice));
                    orderliststr = orderliststr +
                        `<tr>
                            <td>` + jsondata[0].productName +  `</td>
                            <td>` + jsondata[0].productPrice + `</td>
                            <td><img src="` + jsondata[0].productImg1 + `" width="120px" /></td>
                            <td>` + item.quantity + `</td>
                            <td>` + item.quantity * item.unitPrice + `</td>
                        </tr>`
                    $('#orderdataillist00').html(orderliststr);
                    $('#ordertotalprice').text(ordertotalprice)
                });
            })
        });
        $('#orderQueryTab').removeClass("active").addClass('nav-link')
        $('#orderEditTab').prop('class', 'nav-link active')
        $('#orderContent').prop('class', 'd-none')
        $('#orderEdit').prop('class', 'd-block')
    }

    $('.order-query').on('click', function () {
        $('#orderList').removeClass('d-none')
    })

    $('#orderEditTab').on('click', function () {
        $('#orderQueryTab').removeClass("active").addClass('nav-link')
        $('#orderEditTab').prop('class', 'nav-link active')
        $('#orderContent').prop('class', 'd-none')
        $('#orderEdit').prop('class', 'd-block')
    })

    $('#orderQueryTab').on('click', function () {
        $('#orderEditTab').removeClass("active").addClass('nav-link')
        $('#orderQueryTab').prop('class', 'nav-link active')
        $('#orderContent').prop('class', 'd-block')
        $('#orderEdit').prop('class', 'd-none')
    })
</script>
</body>
</html>
