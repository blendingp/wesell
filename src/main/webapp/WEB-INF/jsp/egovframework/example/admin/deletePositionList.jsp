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
<div>포지션 갯수:${count }</div>
<div>logTime : ${logTime }</div>
<div>logNum : ${logNum }</div>
<div>reInit : ${reInit }</div>
<div>orderIdxTmp : ${orderIdxTmp }</div>

<div>bidtmp 매수 현시세 : ${bidtmp }</div>
<div>asktmp 매도 현시세 : ${asktmp }</div>

<div>bidHtmp 매수 최고가시세 : ${bidHtmp }</div>
<div>bidLtmp 매수 최저가시세 : ${bidLtmp }</div>

<div>askHtmp 매수 최고가시세 : ${askHtmp }</div>
<div>askLtmp 매도 최저가시세 : ${askLtmp }</div>

<div>triggerPriceTmp : ${triggerPriceTmp }</div>
<div>symboltmp : ${symboltmp }</div>
<div>result : ${result }</div>
	<c:forEach var="item" items="${trade}" varStatus="i">
		<div>
			<a href="javascript:check('/wesell/deletePositionListProcess.do?useridx=${item.userIdx}&symbol=${item.symbol}')">${item}</a>
		</div>
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