<html>
<head>
    <meta charset="UTF-8">
    <title>Linepay付款中</title>
    <script
            src="https://code.jquery.com/jquery-3.6.0.min.js"
            integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
            crossorigin="anonymous"></script>
</head>
<body>
<h3>Linepay付款中...請稍後</h3>
</body>
<script>
    $(function() {
        var url_string = window.location.href; // www.test.com?filename=test
        var url = new URL(url_string);
        var transId = url.searchParams.get("transactionId");
        alert(transId)
        console.log(transId);
        let totalprice = sessionStorage.getItem("totalprice");
        console.log(totalprice);
        var settings = {
            "url": "https://cors-anywhere.herokuapp.com/"+"https://sandbox-api-pay.line.me/v2/payments/"+ transId +"/confirm",
            "method": "POST",
            "timeout": 0,
            "headers": {
                "Content-Type": "application/json",
                "X-LINE-ChannelId": "1657198233",
                "X-LINE-ChannelSecret": "65e7b255439f40f09ddfcf567e1dd996"
            },
            "data": JSON.stringify({
                "amount": totalprice,
                "currency": "TWD"
            }),
        };

        $.ajax(settings).done(function (response) {
            if(response.returnCode==='0000'){
                alert("付款完成!!!!!!!!!");
                console.log(response);
                window.location.href = "home.jsp";
            }
        });
    });
</script>
</html>