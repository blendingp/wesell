<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<!--  Last Published: Tue Jun 29 2021 05:48:49 GMT+0000 (Coordinated Universal Time)  -->
<html data-wf-page="62b17ff46a9af400cd700ed4" data-wf-site="62b1125ac4d4d60ab9c62f81">
<head>
<meta charset="utf-8">
<title>FAQ</title>
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
</head>
<body class="body">
	<div class="frame">
		<div class="form-block w-form">
			<form name="listForm" id="listForm" action="/wesell/faq.do">
				<input type="hidden" name="pageIndex" />
				<jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
				<div class="frame5">
					<jsp:include page="../userFrame/customerBanner.jsp"></jsp:include>
					<div class="custermer_listblock">
						<div class="custermer_titlewarp" style="padding:0;">
							<div class="title6"><spring:message code="menu.faq"/></div>
						</div>
						<div class="custermer_listblocktop">
							<div class="custermer_listtxt1"><spring:message code="detail.idx" /></div>
							<div class="custermer_listtxt4"><spring:message code="support.subject" /></div>
							<div class="custermer_listtxt3"><spring:message code="detail.writer" /></div>
							<div class="custermer_listtxt2"><spring:message code="detail.date" /></div>
							<!-- <div class="custermer_listtxt3">조회수</div> -->
						</div>
						<div class="custermer_warp1">
							<c:set var="number" value="${pi.totalRecordCount -pi.recordCountPerPage*(pi.currentPageNo-1) }" />
							<c:forEach var="result" items="${faqList}">
								<div class="custermer_liet" style="cursor: pointer;" onClick="checkdetail(${result.bidx})">
									<div class="custermer_listtxt1">${number} <c:set var="number" value="${number-1}" /></div>
									<div class="custermer_listtxt4">
										<c:choose>
											<c:when test="${fn:length(result.btitle) > 25}">
												${fn:substring(result.btitle,0,20)}...
											</c:when>
											<c:otherwise>${result.btitle }</c:otherwise>
										</c:choose>
									</div>
									<div class="custermer_listtxt3"><spring:message code="root.project"/></div>
									<div class="custermer_listtxt2">${result.bdate}</div>
									<!-- <div class="custermer_listtxt3">1</div> -->
								</div>
							</c:forEach>
							<div class="no_data" style=" <c:if test="${fn:length(faqList) == 0}">display:flex;</c:if>">
								<spring:message code="trader.nodata" />
							</div>
						</div>
						<div class="custermer_warp2">
							<div class="paging">
								<ui:pagination paginationInfo="${pi}" type="customPageUser" jsFunction="fn_egov_link_page" />
							</div>
						</div>
					</div>
				</div>
			</form>
			<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
		</div>
	</div>

	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=615fe8348801178bd89ede05" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
	<script>
		function fn_egov_link_page(page) {
			document.listForm.pageIndex.value = page;
			document.listForm.submit();
		}
		
		var type = "faq";
		
		function checkdetail(bidx) {
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