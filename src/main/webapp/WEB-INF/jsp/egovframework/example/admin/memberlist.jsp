<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<body>

	<c:forEach var="item" items="${members}" varStatus="i">
		<div>
			유저:${item.userIdx }  지갑:${item.wallet } USDT:${item.walletUSDT } 비트:${item.walletBTC } 이더:${item.walletETH } 리플:${item.walletXRP } 트론:${item.walletTRX }
			 <br>${item.info } 			
		</div>
		<br> 
	</c:forEach>
<script>
function check(url){
	if (confirm('정말 지울건가요?')) {
		location.href=url;
	} 
}
</script>
</body>
</html>