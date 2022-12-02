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
tradetrigger 갯수:${count }
	<c:forEach var="item" items="${trade}" varStatus="i">
		<div>
			<a href="javascript:check('/global/deleteTradeTriggerListProcess.do?useridx=${item.userIdx}&ordernum=${item.orderNum}')">${item}</a>
		</div>
	</c:forEach>
<script>
function check(url){
	if (confirm('정말 지울건가요?')) {
		location.href=url;
	} 
}</script>
</body>
</html>