<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="utf-8">
    <title>JAVA42-生活倉庫Q</title>
    <script src="../js/jquery-3.6.0.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" type="text/css" href="../css/mycss.css">
</head>
<body>
<div id="product01" class="d-block">
    <div class="pt-3 pb-2 mb-3">
        <div class="fw-bold fs-3">產品維護</div>
        <div>
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button id="queryTab" class="active nav-link">搜尋條件</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button id="editTab" class="nav-link ">編輯頁</button>
                </li>
            </ul>
        </div>
    </div>

    <div id="productContent">
        <!--產品維護搜尋條件的區域控制 START-->
        <div class="tab-pane fade show active" id="query" role="tabpanel" aria-labelledby="query-tab">
            <div style="margin-top: -18px; margin-bottom: -8px">
                <button class="button-54 p-query"><img src="images/search.png" style="width: 20px"
                                                       alt="">查詢
                </button>
                <button class="button-54 p-add"><img src="images/add.png" style="width: 20px" alt="">新增
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
                    <th scope="row" style="text-align: end"><label for="pdqueryname">產品名稱</label></th>
                    <td><input type="text" id="pdqueryname"></td>
                    <td style="text-align: end; font-weight: bold"><label for="aaa">產品編號</label></td>
                    <td>
                        <input type="text" id="aaa">
                    </td>
                </tr>
                <tr>
                    <th scope="row" style="text-align: end">產品類別</th>
                    <td>
                    <input type="text" name="pdquerycatalog" list="pdquerycatalog" class="pdquerycatalog" value="">
                    <datalist id="pdquerycatalog">
                        <option value="3C">
                        <option value="家電">
                        <option value="服飾">
                        <option value="配件">
                    </datalist>
                    </td>
<%--                    <td><input type="text" id ="pdquerycatalog"></td>--%>
                    <td scope="row" style="text-align: end;font-weight: bold">產品價格</td>
                    <td><input type="text"></td>
                </tr>
                </tbody>
            </table>
        </div>
        <div id="productList" class="d-none">
            <div id="test99">
                <%--從AJAX取得DB select result--%>
            </div>
        </div>
    </div> <!--產品維護搜尋條件與結果的區域控制 END-->
    <!--產品編輯的區域控制 START-->
    <div id="productEdit" class="d-none">
        <div class="tab-pane fade show active " role="tabpanel"
             aria-labelledby="productEdit-tab">
            <div style="margin-top: -18px; margin-bottom: -8px">
                <input type="hidden" id="editProductId" name="editProductId" value="">
                <button class="button-54" onclick="return saveOrModifyConfirm(`Insert`)"><img
                        src="images/add.png" style="width: 20px"
                        alt="">新增品項insert
                </button>
                <button class="button-54" onclick="return saveOrModifyConfirm(`Update`)"><img
                        src="images/edit.png" style="width: 20px"
                        alt="">更新品項update
                </button>
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th scope="col" colspan="4">

                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <th scope="row" style="text-align: end">產品名稱</th>
                        <td><input type="text" name="pdname" id="pdname" class="productquery" value=""></td>
                        <td style="text-align: end; font-weight: bold">產品類別</td>
                        <td>
                            <input type="text" name="pdtypeselect" class="pdtypeselect productquery"
                                   list="pdtypeselect"
                                   value="">
                            <datalist id="pdtypeselect">
                                <option value="3C">
                                <option value="家電">
                                <option value="服飾">
                                <option value="配件">
                            </datalist>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" style="text-align: end">產品價格</th>
                        <td><input type="number" name="pdprice" id="pdprice" class="productquery" value=""></td>
                        <td scope="row" style="text-align: end;font-weight: bold">產品描述</td>
                        <td><textarea name="pdesc" id="pdesc" class="productquery" cols="35"
                                      wrap="soft"></textarea></td>
                    </tr>
                    </tbody>
                </table>
                <%--圖片上傳區域,每一個form獨立作業,一次上傳一張--%>
                <table class="table table-hover">
                    <tbody>
                    <tr>
                        <th scope="row" style="text-align: end">產品照片1</th>
                        <td>
                            <form class="p-img-form" method="post" enctype="multipart/form-data" name="fileinfo">
                                <input class="form-control" type="file" name="files">
                                <%--透過兩個hidden column把產品名稱跟第幾個欄位傳給UploadImageToS3,其中pdImageName是透過fnc1給值
                                input file name的files對應到request.getPart(:name)--%>
                                <input type="hidden" name="pdImageColumn" value="product_img1">
                                <input type="hidden" class="imgPdId" name="imgPdId" value="">
                                <button type="button" value="上傳" onclick="return uploadConfirm(0)">上傳圖片1</button>
                            </form>
                        </td>
                    </tr>
                    <tr>
                        <td scope="row" style="text-align: end;font-weight: bold">產品照片2</td>
                        <td>
                            <form class="p-img-form" method="post" enctype="multipart/form-data" name="fileinfo">
                                <input class="form-control" type="file" name="files">
                                <input type="hidden" name="pdImageColumn" value="product_img2">
                                <input type="hidden" class="imgPdId" name="imgPdId" value="">
                                <button type="button" value="上傳" onclick="return uploadConfirm(1)">上傳圖片2</button>
                            </form>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" style="text-align: end">產品照片3</th>
                        <td>
                            <form class="p-img-form" method="post" enctype="multipart/form-data" name="fileinfo">
                                <input class="form-control" type="file" name="files">
                                <input type="hidden" name="pdImageColumn" value="product_img3">
                                <input type="hidden" class="imgPdId" name="imgPdId" value="">
                                <button type="button" value="上傳" onclick="return uploadConfirm(2)">上傳圖片3</button>
                            </form>
                        </td>
                    </tr>
                    <tr>
                        <td scope="row" style="text-align: end;font-weight: bold">產品照片4</td>
                        <td>
                            <form class="p-img-form" method="post" enctype="multipart/form-data" name="fileinfo">
                                <input class="form-control" type="file" name="files">
                                <input type="hidden" name="pdImageColumn" value="product_img4">
                                <input type="hidden" class="imgPdId" name="imgPdId" value="">
                                <button type="button" value="上傳" onclick="return uploadConfirm(3)">上傳圖片4</button>
                            </form>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <%--圖片上傳區域,每一個form獨立作業,一次上傳一張--%>
                <%--產品照片區--%>
                <div id="productImages" class="d-none">
                    <table>
                        <tr>
                            <td>照片1<button onclick="return deleteImgConfirm(`1`);">刪除圖片</button></td>
                            <td>照片2<button onclick="return deleteImgConfirm(`2`);">刪除圖片</button></td>
                        </tr>
                        <tr>
                            <td><img id="prodimg1" src="" alt="Product Image1" width="300px"></td>
                            <td><img id="prodimg2" src="" alt="Product Image2" width="300px"></td>
                        </tr>
                        <tr>
                            <td>照片3<button onclick="return deleteImgConfirm(`3`);">刪除圖片</button></td>
                            <td>照片4<button onclick="return deleteImgConfirm(`4`);">刪除圖片</button></td>
                        </tr>
                        <tr>
                            <td><img id="prodimg3" src="" alt="Product Image3" width="300px"></td>
                            <td><img id="prodimg4" src="" alt="Product Image4" width="300px"></td>
                        </tr>
                    </table>
                </div>
                <%--產品照片區END--%>
            </div>
        </div>
    </div>
</div><!--產品編輯的區域控制 END-->

<script>
    //產品清單的編輯按鈕被點擊時觸發fnc1
    function fnc1(pid, pname, ptype, price, pdesc, pimg1, pimg2, pimg3, pimg4) {
        $('#queryTab').removeClass("active").addClass('nav-link')
        $('#editTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-none')
        $('#productEdit').prop('class', 'd-block')
        $('#pdname').prop('value', pname)  //當使用者點下編輯icon把產品資訊傳到編輯頁面
        $('#pdprice').prop('value', price)
        $('.pdtypeselect').prop('value', ptype)
        $('#pdesc').prop('value', pdesc)
        $('#editProductId').prop('value', pid)  //把產品id帶到編輯頁面
        $('#productImages').prop('class', 'd-block');
        $('#prodimg1').prop('src', pimg1) //既有產品的圖片從DB把url撈出來填上去
        $('#prodimg2').prop('src', pimg2)
        $('#prodimg3').prop('src', pimg3)
        $('#prodimg4').prop('src', pimg4)
        $('.imgPdId').prop('value', pid); //把產品id帶到新增圖片的隱藏欄位
    }

    function saveOrModifyConfirm(action) {
        const isSave = confirm("確定新增/修改?");
        if (isSave === true) {
            doSaveOrModify(action);
        }
    }

    function uploadConfirm(index) {
        const isDel = confirm("確定新增圖片?");
        if (isDel === true) {
            doUpload(index);
        }
    }

    function deleteImgConfirm(index){
        const isDel = confirm("確定刪除圖片?");
        if(isDel===true){
            doDeleteImg(index);
        }
    }

    function deleteProductItemConfirm(pid){
        const isDel = confirm("確定刪除品項?");
        if(isDel===true){
            doDeleteProduct(pid);
        }
    }

    $('.p-query').on('click', function () {
        $('#productList').removeClass('d-none')
    })

    $('#editTab').on('click', function () {
        $('#queryTab').removeClass("active").addClass('nav-link')
        $('#editTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-none')
        $('#productEdit').prop('class', 'd-block')
    })

    $('#queryTab').on('click', function () {
        $('#editTab').removeClass("active").addClass('nav-link')
        $('#queryTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-block')
        $('#productEdit').prop('class', 'd-none')
    })

    $('.p-add').on('click', function () {
        $('#queryTab').removeClass("active").addClass('nav-link')
        $('#editTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-none')
        $('#productEdit').prop('class', 'd-block')
        $('.productquery').prop('value', '')  //把欄位清空
        $('#productImages').prop('class', 'd-none');
        $('#editProductId').prop('value',''); //如果使用者點新增品項按鈕,可能之前有先編輯過某產品,所以要把此id欄位清空
    })
    //根據搜尋欄位給的資訊使用ajax抓資料
    $('.p-query').click(
        function () {
            $.ajax({
                url: "ProductServlet",
                method: "post",
                data: {
                    pdaction: "Select",
                    pdname: $('#pdqueryname').val(), //從搜尋欄位取值送去selectProduct.jsp
                    pdtypeselect: $('.pdquerycatalog').val()
                },
                success: function (responseText) {
                    $('#test99').html(responseText);
                }
            });
        }
    );

    //透過ajax把圖片上傳的form傳給servlet處理
    function doUpload(index) {
        var formData = new FormData($(".p-img-form")[index]);
        $.ajax({
            url: 'UploadImageToS3',
            type: 'POST',
            data: formData,
            async: false,
            cache: false,
            contentType: false,
            processData: false,
            beforeSend: function(){
                console.log("start upload...");
            },
            complete: function(){
                console.log("finish upload...");
            },
            success: function () {
                alert("新增成功");
            }
        });
    }

    //新增儲存的按鈕按下去之後用Ajax送去servlet處裡
    function doSaveOrModify(action) {
        $.ajax({
            url: "ProductServlet",
            method: "post",
            data: {
                editProductId: $("#editProductId").val(),
                pdname: $('#pdname').val(),
                pdtypeselect: $('.pdtypeselect').val(),
                pdprice: $('#pdprice').val(),
                pdesc: $('#pdesc').val(),
                pdaction: action,
                datetime: getNowFormatDate()
            },
            success: function (e) {
                console.log(e);
                alert("新增/修改成功");
            },
            error: function () {
                alert("新增/修改失敗");
            }
        });
    }

    //確認刪除後執行>>刪除產品圖片servlet
    function doDeleteImg(index) {
        $.ajax({
            url: "ProductServlet",
            method: "post",
            data: {
                pdaction : "DeleteImg",
                imgIndex : index,
                editProductId : $("#editProductId").val()
            },
            success: function () {
                alert("移除圖片成功");
            },
            error: function () {
                alert("移除圖片失敗");
            }
        });
    }

    //確認刪除後執行>>刪除產品單一產品品項
    function doDeleteProduct(pid) {
        $.ajax({
            url: "ProductServlet",
            method: "post",
            data: {
                pdaction : "Delete",
                editProductId : pid
            },
            success: function () {
                alert("刪除品項成功");
            },
            error: function(){
                alert("刪除失敗");
            }
        });
    }

    function getNowFormatDate() {
        var date = new Date();
        var seperator1 = "-";
        var seperator2 = ":";
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + date.getMinutes()
            + seperator2 + date.getSeconds();
        return currentdate;
    }

</script>
</body>
</html>
