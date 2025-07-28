<!-- payment.jsp -->
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>支払方法の選択</title>
</head>
<body>

<%@ include file="header-navi.jsp" %>

<h2>支払方法を選んでください</h2>

<form action="pay-servlet" method="post">
    <label><input type="radio" name="paymentMethod" value="クレジットカード" required> クレジットカード</label><br>
    <label><input type="radio" name="paymentMethod" value="代金引換"> 代金引換</label><br>
    <label><input type="radio" name="paymentMethod" value="銀行振込"> 銀行振込</label><br>

    <br>
    <input type="submit" value="計算して確認">
</form>

</body>
</html>
