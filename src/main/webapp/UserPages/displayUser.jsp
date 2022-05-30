<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<div id="user01" class="d-block">
    <div class="pt-3 pb-2 mb-3">
        <div class="fw-bold fs-3">使用者維護</div>
        <div>
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button id="userQueryTab" class="active nav-link">搜尋條件</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button id="userEditTab" class="nav-link ">編輯頁</button>
                </li>
            </ul>
        </div>
    </div>

    <div id="userContent">
        <!--使用者維護搜尋條件的區域控制 START-->
        <div class="tab-pane fade show active" id="query" role="tabpanel" aria-labelledby="query-tab">
            <div style="margin-top: -18px; margin-bottom: -8px">
                <button class="button-54 user-query"><img src="images/search.png" style="width: 20px"
                                                          alt="">查詢
                </button>
                <button class="button-54 user-add"><img src="images/add.png" style="width: 20px" alt="">新增
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
                    <th scope="row" style="text-align: end"><label for="userQuertAccount">使用者帳號</label></th>
                    <td><input type="text" id="userQuertAccount" value=""></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <th scope="row" style="text-align: end">使用者角色</th>
                    <td>
                        <input type="text" name="userQueryRole" list="userQueryRole" class="userQueryRole"
                               value="">
                        <datalist id="userQueryRole">
                            <option value="ADMIN">
                            <option value="MANAGER">
                            <option value="CS">
                            <option value="VIEWER">
                        </datalist>
                    </td>
                    <%--                    <td><input type="text" id ="pdquerycatalog"></td>--%>
                    <td scope="row" style="text-align: end;font-weight: bold">使用者信箱</td>
                    <td><input type="email" id="userQueryEmail"></td>
                </tr>
                </tbody>
            </table>
        </div>
        <div id="userList" class="d-none">
            <div id="userList1">
                <%--從AJAX取得DB select result--%>
            </div>
        </div>
    </div> <!--使用者維護搜尋條件與結果的區域控制 END-->
    <!--使用者 編輯 區域控制 START-->
    <div id="userEdit" class="d-none">
        <div class="tab-pane fade show active " role="tabpanel"
             aria-labelledby="userEdit-tab">
            <div style="margin-top: -18px; margin-bottom: -8px">
                <input type="hidden" id="editUserId" name="editUserId" value="">
                <button class="button-54" onclick="return saveOrModifyConfirm(`Insert`)"><img
                        src="images/add.png" style="width: 20px"
                        alt="">新增USER
                </button>
                <button class="button-54" onclick="return saveOrModifyConfirm(`Update`)"><img
                        src="images/edit.png" style="width: 20px"
                        alt="">更新USER
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
                        <th scope="row" style="text-align: end">使用者帳號</th>
                        <td><input type="text" name="userAccount" id="userAccount" class="userQuery" value=""></td>
                        <td style="text-align: end; font-weight: bold"><label for="bbb">使用者密碼</label></td>
                        <td><input type="password" id="bbb"></td>
                    </tr>
                    <tr>
                        <th scope="row" style="text-align: end">使用者角色</th>
                        <td>
                            <input type="text" name="userRole" list="userRole" class="userRole" value="">
                            <datalist id="userRole">
                                <option value="ADMIN">
                                <option value="MANAGER">
                                <option value="CS">
                                <option value="VIEWER">
                            </datalist>
                        </td>
                        <td scope="row" style="text-align: end;font-weight: bold">使用者信箱</td>
                        <td><input type="email"></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div><!--使用者 編輯 區域控制 END-->
</div>

<script>
    $('.user-query').on('click', function () {
        $('#userList').removeClass('d-none')
    })

    $('#userEditTab').on('click', function () {
        $('#userQueryTab').removeClass("active").addClass('nav-link')
        $('#userEditTab').prop('class', 'nav-link active')
        $('#userContent').prop('class', 'd-none')
        $('#userEdit').prop('class', 'd-block')
    })

    $('#userQueryTab').on('click', function () {
        $('#userEditTab').removeClass("active").addClass('nav-link')
        $('#userQueryTab').prop('class', 'nav-link active')
        $('#userContent').prop('class', 'd-block')
        $('#userEdit').prop('class', 'd-none')
    })

    $('.user-query').click(
        function () {
            $.ajax({
                url: "UserPages/selectUser.jsp",
                method: "post",
                data: {
                    userAction: "Select",
                    userAccount: $('#userQuertAccount').val(), //從搜尋欄位取值送去selectProduct.jsp
                    userRole: $('.userQueryRole').val(),
                    userMail: $('#userQueryEmail').val()
                },
                success: function (responseText) {
                    $('#userList1').html(responseText);
                }
            });
        }
    );
</script>
</body>
</html>
