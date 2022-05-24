<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<sql:setDataSource
        driver="com.mysql.cj.jdbc.Driver"
        url="jdbc:mysql://localhost/iii"
        user="root"
        password=""
/>
<c:if test="${!empty param.delid }">
    <sql:update>
        DELETE FROM PRODUCTS WHERE PRODUCT_id = ?
        <sql:param>${param.delid }</sql:param>
    </sql:update>
    <c:redirect url="home.jsp"></c:redirect>
</c:if>

<html>
<head>
    <meta charset="utf-8">
    <title>JAVA42-生活倉庫</title>
    <script src="js/jquery-3.6.0.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
            crossorigin="anonymous"></script>
    <script src="js/myJs.js"></script>
    <link rel="stylesheet" type="text/css" href="css/mycss.css">
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
                    <td><input type="text"></td>
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
                <form id="p-add-form" method="post" action="DBinsert.jsp">
                    <button type="submit" class="button-54 p-save" onclick="return saveConfirm()"><img
                            src="images/search.png" style="width: 20px"
                            alt="">新增/儲存
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
                            <td><textarea form="p-add-form" name="pdesc" id="pdesc" class="productquery" cols="35"
                                          wrap="soft"></textarea></td>
                        </tr>
                        </tbody>
                    </table>
                </form>
                <%--圖片上傳區域,每一個form獨立作業,一次上傳一張--%>
                <table class="table table-hover">
                    <tbody>
                    <tr>
                        <th scope="row" style="text-align: end">產品照片1</th>
                        <td>
                            <form class="p-img-form" method="post" enctype="multipart/form-data" name="fileinfo">
                                <input class="form-control" type="file" name="files">
                                <%--透過兩個hidden column把產品名稱跟第幾個欄位傳給Brad17,其中pdImageName是透過fnc1給值
                                input file name的files對應到request.getPart(:name)--%>
                                <input type="hidden" name="pdImageColumn" value="product_img1">
                                <input type="hidden" class="pdImg" name="pdImageName" value="">
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
                                <input type="hidden" class="pdImg" name="pdImageName" value="">
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
                                <input type="hidden" class="pdImg" name="pdImageName" value="">
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
                                <input type="hidden" class="pdImg" name="pdImageName" value="">
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
                            <td>照片1<span class="delbutspan"><a href="" id="img1"
                                                               onclick="return confirm('確認刪除?');">刪除圖片</a></span></td>
                            <td>照片2<span class="delbutspan"><a href="" id="img2"
                                                               onclick="return confirm('確認刪除?');">刪除圖片</a></span></td>
                        </tr>
                        <tr>
                            <td><img id="prodimg1" src="" alt="Product Image1" width="300px"></td>
                            <td><img id="prodimg2" src="" alt="Product Image2" width="300px"></td>
                        </tr>
                        <tr>
                            <td>照片3<span class="delbutspan"><a href="" id="img3"
                                                               onclick="return confirm('確認刪除?');">刪除圖片</a></span></td>
                            <td>照片4<span class="delbutspan"><a href="" id="img4"
                                                               onclick="return confirm('確認刪除?');">刪除圖片</a></span></td>
                        </tr>
                        <tr>
                            <td><img id="prodimg3" src="" alt="Product Image3" width="300px" onerror=""></td>
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
    function fnc1(pname, ptype, price, pdesc, pimg1, pimg2, pimg3, pimg4) {
        $('#queryTab').removeClass("active").addClass('nav-link')
        $('#editTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-none')
        $('#productEdit').prop('class', 'd-block')
        $('#pdname').prop('value', pname)
        $('#pdprice').prop('value', price)
        $('.pdtypeselect').prop('value', ptype)
        $('#pdesc').prop('value', pdesc)
        $('#productImages').prop('class', 'd-block');
        $('#prodimg1').prop('src', pimg1)
        $('#prodimg2').prop('src', pimg2)
        $('#prodimg3').prop('src', pimg3)
        $('#prodimg4').prop('src', pimg4)
        $('#img1').prop('href', 'deleteProductImage.jsp?pdname=' + pname + '&x=1')
        $('#img2').prop('href', 'deleteProductImage.jsp?pdname=' + pname + '&x=2')
        $('#img3').prop('href', 'deleteProductImage.jsp?pdname=' + pname + '&x=3')
        $('#img4').prop('href', 'deleteProductImage.jsp?pdname=' + pname + '&x=4')
        $('.pdImg').prop('value',pname);
    }

    function delConfirm(pname) {
        return confirm("確定刪除 " + pname + "?");
    }

    function saveConfirm() {
        return confirm("確定新增/修改?");
    }

    function uploadConfirm(index) {
        const isDel = confirm("確定新增圖片?");
        if(isDel===true){
            doUpload(index);
        }
    }

    $('.p-query').on('click', function () {
        $('#productList').removeClass('d-none')
    })

    $('#editTab').on('click', function () {
        console.log("123123")
        $('#queryTab').removeClass("active").addClass('nav-link')
        $('#editTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-none')
        $('#productEdit').prop('class', 'd-block')
    })

    $('#queryTab').on('click', function () {
        console.log("123123")
        $('#editTab').removeClass("active").addClass('nav-link')
        $('#queryTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-block')
        $('#productEdit').prop('class', 'd-none')
    })

    $('.p-add').on('click', function () {
        console.log("p-add")
        $('#queryTab').removeClass("active").addClass('nav-link')
        $('#editTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-none')
        $('#productEdit').prop('class', 'd-block')
        $('.productquery').prop('value', '')  //把欄位清空
        $('#productImages').prop('class', 'd-none');
    })
    //根據搜尋欄位給的資訊使用ajax抓資料
    $('.p-query').click(
        function () {
            $.ajax({
                url: "selectProduct.jsp",
                method: "post",
                data: {
                    pdname: $('#pdqueryname').val() //從搜尋欄位取值送去selectProduct.jsp
                },
                success: function (responseText) {
                    $('#test99').html(responseText);
                }
            });
        }
    );
    //透過ajax把圖片上傳的form傳給servlet處理
    function doUpload(index) {
        var formData = new FormData($( ".p-img-form" )[index]);
        $.ajax({
            url: 'UploadImageToS3',
            type: 'POST',
            data: formData,
            async: false,
            cache: false,
            contentType: false,
            processData: false,
            success: function () {
                alert("新增成功");
            },
            error: function () {
                alert("新增失敗");
            }
        });
    }

</script>
</body>
</html>
