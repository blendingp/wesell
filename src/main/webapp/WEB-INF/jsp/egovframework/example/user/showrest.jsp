<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE>
<html data-wf-page="62b178a4f8989b6626cf6851" data-wf-site="62b1125ac4d4d60ab9c62f81">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Futures Trade</title>
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
</head>
<style>
input[type=range]::-webkit-slider-thumb {
	-webkit-appearance: none;
	background: #ffffff;
	cursor: pointer;
	border: 1px solid #000;
	height: 15px;
	width: 15px;
	box-shadow: 0 1px 4px 0 rgb(0 0 0/ 50%);
	border-radius: 10px;
}
</style>
<body class="body1">
	<div class="frame">
	<jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
	<div class="frame6">
		<div class="block">
			<div class="maintananceblock">
				<img src="//webflow/images2/sub_logo1.svg" loading="lazy" alt="" class="image-40">
					<div class="title4">
						<spring:message code="pop.ServiceRest_1" />
						<span class="text-span-16">
							<spring:message	code="pop.ServiceRest_2" /></span>
						<spring:message code="pop.ServiceRest_3" />
					</div>
					<div class="text-block-14">
						<spring:message code="pop.ServiceRest_4" /> 
						<br>
						<spring:message code="pop.ServiceRest_5" />
						<br>
						<spring:message code="pop.ServiceRest_6" />
						<br>
					</div>
					<!-- <div class="text-block-132">점검 시간: 10월 22일 (화) 01:00~16:00(15시간)</div> -->
				</div>
		</div>
	</div>
	<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
</body>
</html>