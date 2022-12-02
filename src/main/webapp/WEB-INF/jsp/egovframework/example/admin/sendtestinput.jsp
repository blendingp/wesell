<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="/global/sendtest.do" method="post" >
		<div>코인종류<select name="kind">
			<option>BTC</option>
			<option>USDT</option>
			<option>TRX</option>
			<option>XRP</option>
			<option>ETH</option>
		</select>
		</div>
		<div>보내는주소<input name="from"></div>
		<div>받는주소<input name="to"></div>
		<div>보낼 수량<input name="value"></div>
		<div>privatekey<input name="pkey"></div>
		<div>tag<input name="tag"></div>
		<div><input type="submit"></div>
	</form>
</body>
</html>