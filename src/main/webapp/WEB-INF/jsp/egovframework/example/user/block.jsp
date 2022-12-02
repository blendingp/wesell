<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE>
<html data-wf-page="6073d35203881b27b97cdb95"
	data-wf-site="6073d35203881b197a7cdb93">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Futures Trade</title>
<jsp:include page="../userFrame/header.jsp"></jsp:include>
</head>
<style>
input[type=range]::-webkit-slider-thumb { 
	-webkit-appearance: none; 
	background: #ffffff; 
	cursor: pointer; 
	border: 1px solid #000;
	height: 15px; 
	width: 15px; 
	box-shadow: 0 1px 4px 0 rgb(0 0 0 / 50%);
	border-radius: 10px; 
}
</style>
<body>
  <div class="all-n">
    <jsp:include page="../userFrame/top.jsp"></jsp:include>
        
    <div class="downstime" style="display:flex;"><img src="/global/webflow/louisImage/attention-warning.svg" loading="lazy" alt="" class="downstimeimg">
      <div class="downstimetext"><spring:message code="pop.userBlock_1"/></div>
      <div class="downstimetext2"><spring:message code="pop.userBlock_2"/></div>
    </div>
   
    <jsp:include page="../userFrame/footer.jsp"></jsp:include>
	</div>    
  <!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
</body>
</html>