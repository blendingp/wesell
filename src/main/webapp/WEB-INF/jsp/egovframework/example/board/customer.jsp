<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html data-wf-page="62b179abd825db854e47e9e4" data-wf-site="62b1125ac4d4d60ab9c62f81">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta content="detail" property="og:title">
<meta content="detail" property="twitter:title">
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
<title>customer service</title>
</head>
<style>
.opentext {
	overflow: hidden;
	text-overflow: ellipsis;
	display: -webkit-box;
	-webkit-line-clamp: 5;
	-webkit-box-orient: vertical;
	line-height: 167%;
	height: 8.6em;
}
</style>
<body class="body1">
	<div class="frame">
		<div class="form-block w-form">
			<form id="email-form" name="email-form" data-name="Email Form" class="form">
				<jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
				<div class="frame5">
					<jsp:include page="../userFrame/customerBanner.jsp"></jsp:include>
					<div class="custermermain_warp">
						<div data-w-id="bb40effc-63fb-5600-70b0-10de2ef83830" class="custermermain_box">
							<div class="custermermain_warp1">
								<div data-w-id="bb40effc-63fb-5600-70b0-10de2ef83832" class="custermer_iconbtn" onClick="location.href='/wesell/notice.do'">
									<img src="/wesell/webflow/images2/telescope.png" loading="lazy" alt="" class="image-51">
									<div><spring:message code="support.notice" /> </div>
								</div>
								<div data-w-id="bb40effc-63fb-5600-70b0-10de2ef83836" class="custermer_iconbtn" onClick="location.href='/wesell/faq.do'">
									<img src="/wesell/webflow/images2/magnifyingglass.png" loading="lazy" alt="" class="image-51">
									<div><spring:message code="menu.faq"/></div>
								</div>
								<div data-w-id="bb40effc-63fb-5600-70b0-10de2ef8383a" class="custermer_iconbtn" onClick="location.href='/wesell/user/helpCenter.do'">
									<img src="/wesell/webflow/images2/bag.png" loading="lazy"alt="" class="image-51" >
									<div><spring:message code="submitRequest"/></div>
								</div>
							</div>
							<div class="custermermain_warp2">
								<div class="custermermain_box2">
									<div class="custermermain_title">
										<spring:message code="support.notice" />
									</div>
									    
									<c:forEach var="item" items="${noticeList}" varStatus="i">
										<div class="custermermain_textblock" onclick="checkdetail(${item.bidx}, 'notice')">
											<c:choose>
												<c:when test="${fn:length(item.btitle) > 18}">
												${fn:substring(item.btitle,0,18)}...
											</c:when>
												<c:otherwise>${item.btitle }</c:otherwise>
											</c:choose>
										</div>
									</c:forEach>
								</div>
								<div class="custermermain_box2">
									<div class="custermermain_title"><spring:message code="menu.faq"/></div>
									<c:forEach var="item" items="${faqList}" varStatus="i">
										<div class="custermermain_textblock" onclick="checkdetail(${item.bidx}, 'faq')">
											<c:choose>
												<c:when test="${fn:length(item.btitle) > 18}">
												${fn:substring(item.btitle,0,18)}...
											</c:when>
												<c:otherwise>${item.btitle }</c:otherwise>
											</c:choose>
										</div>
									</c:forEach>
								</div>
							</div>
						</div>
					</div>
				</div>
				<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
			</form>
		</div>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=615fe8348801178bd89ede05" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script>
		function checkdetail(bidx, type) {
			$.ajax({
					type : 'post',
					data : {
						bidx : bidx,
						type : type,
					},
					dataType : 'json',
					url : '/wesell/checkdetail.do',
					success : function(data) {
						if (data.result == 'success') {
							location.href = "/wesell/detail.do?bidx="+bidx+"&type="+type;
						} else {
							console.log(data.msg);
							alert(data.msg);
						}
					},
					error : function(e) {
						console.log('ajax error ' + JSON.stringify(e));
					}
				})
		}
	</script>
</body>
</html>