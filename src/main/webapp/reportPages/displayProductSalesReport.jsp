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
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <link rel="stylesheet" type="text/css" href="css/mycss.css">
</head>

<body>
<div id="productsalesreport01" class="d-block">
    <div class="pt-3 pb-2 mb-3">
        <div class="fw-bold fs-3">產品銷售報表</div>
        <div>
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button id="pdSalesQueryTab" class="active nav-link">搜尋條件</button>
                </li>
            </ul>
        </div>
    </div>

    <div id="productsalesreport">
        <!--使用者維護搜尋條件的區域控制 START-->
        <div class="tab-pane fade show active" id="query" role="tabpanel" aria-labelledby="query-tab">
            <div style="margin-top: -18px; margin-bottom: -8px">
                <button class="button-54 getProductSalesReport"><img src="images/search.png" style="width: 20px"
                                                                     alt="">查詢
                </button>
                <button id="pdSalesExcel" class="button-54">下載為Excel檔案</button>
                <button id="pdSalesPdf" class="button-54">下載為PDF檔案</button>
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
                    <th scope="row" style="text-align: end"><label for="productSalesFrom">請輸入查詢起日:</label></th>
                    <td><input type="datetime-local" id="productSalesFrom" value=""></td>
                    <th scope="row" style="text-align: end"><label for="productSalesEnd">請輸入查詢迄日:</label></th>
                    <td><input type="datetime-local" id="productSalesEnd" value=""></td>
                </tr>
                </tbody>
            </table>
        </div>
        <div id="productSalesReportContent" class="d-none d-flex flex-row">
            <div id="productSalesReportContent1" class="w-25">
                <table class="table table-striped">
                    <tr>
                        <th>產品名稱</th>
                        <th>銷售數量</th>
                    </tr>
                    <tbody id="displayProductReportarea">
                    <!-- 從AJAX取資料 -->
                    </tbody>
                </table>
            </div>
            <div id="chart_div">
                <!-- 呼叫google圖表API並將圖表放入 -->
            </div>
        </div>
    </div>
    <!--使用者維護搜尋條件與結果的區域控制 END-->
</div>

<script>
    $('.getProductSalesReport').on('click', function () {
        $('#productSalesReportContent').removeClass('d-none');

        console.log($('#productSalesFrom').val().toString().replace("T", " ") + ":00")

        $.ajax({
            url: "http://bosian.ddns.net:8080/IIIFinalServlet_war_exploded/ReportServlet",
            method: "get",
            data: {
                startDate: $('#productSalesFrom').val().toString().replace("T", " ") + ":00",
                endDate: $('#productSalesEnd').val().toString().replace("T", " ") + ":00",
                reportType: "product"
            },
            success: function (resp) {
                var Jsonresult = JSON.parse(resp);
                let str = '';
                Jsonresult.forEach(e => {
                    str = str +
                        `<tr>
                        <td>` + Object.keys(e) + `</td>
                        <td>` + Object.values(e) + `</td>
                        </tr>`
                });
                $("#displayProductReportarea").html(str);
                //這邊以下是呼叫google chart API畫出bar chart
                google.charts.load('current', { packages: ['corechart'] });
                google.charts.setOnLoadCallback(drawBasic);

                function drawBasic() {
                    let count = 0;
                    var data = new google.visualization.DataTable();
                    data.addColumn('string', 'Product Name');
                    data.addColumn('number', 'Qty');
                    //取key value分別放入,限制最多顯示十個產品
                    Jsonresult.forEach(e =>{
                        if(count<10){
                            data.addRow([String(Object.keys(e)), Number(Object.values(e))])
                        }
                        count += 1;
                    })

                    var options = {
                        title: "產品銷售排行 Top 10",
                        chartArea: { width: '60%' },
                        width: 800,
                        height: 500,
                        hAxis: {
                            minValue: 0
                        },
                        vAxis: {
                            baseLIine: Number
                        }
                    };

                    var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
                    chart.draw(data, options);
                }

            },
            error: function () {
                alert("Get ProductSalesReport failed");
            }
        });
    })

    //網頁載入會把今天的00:00和23:59分別放入兩個欄位
    $(function () {
        let mydate = new Date();
        let year = mydate.getFullYear();
        let month = mydate.getMonth() + 1;
        if (month < 10) {
            month = "0" + month;
        }
        let date = mydate.getDate().toString();
        if (date < 10) {
            date = "0" + date;
        }
        $('#productSalesFrom').prop('value', year + "-" + month + "-" + date + "T00:00");
        $('#productSalesEnd').prop('value', year + "-" + month + "-" + date + "T23:59");

        let str = $('#productSalesEnd').val().toString().replace("T", " ");

        console.log(str);
    });
</script>
</body>
</html>
