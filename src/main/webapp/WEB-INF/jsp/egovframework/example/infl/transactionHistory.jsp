<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html data-wf-page="618c69a365cc2b5bcc4beac4" data-wf-site="6180a71858466749aa0b95bc">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>거래내역</title>
<meta content="transactional information" property="og:title">
<meta content="transactional information" property="twitter:title">
<jsp:include page="../userFrame/header.jsp"></jsp:include>
<script>
function numberWithCommas(x) {
	return x;
    //return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function lossProfit(stat,val){
	if(stat == 0){
		if(val > 0){
			return val;
		}else{
			return 0;	
		}
	}
	else{
		if(val < 0){
			return val;
		}else{
			return 0;	
		}
	}
}


</script>
</head>
<body class="influ_body">
	<div class="influ_frame">
		<div class="influ_block">
			<div class="mobbackdark"  style="display:none;"></div>
			<jsp:include page="../userFrame/inflLeft.jsp"></jsp:include>
			<div class="influ_block1">
				<jsp:include page="../userFrame/infltop.jsp"></jsp:include>
				<div class="influ_mainblock">
					<div class="influ_mainblock1">
						<div class="influ_title1">거래 관리</div>
						<div class="form-block-9 w-form">
							<form name="listForm" id="listForm" action="/global/infl/transactionHistory.do" class="form-9">
								<input type="hidden" name="pageIndex" />
								<div class="influ_date_warp">
									<div class="text-block-18">UID</div>
									<input type="text" class="text-field-16 w-input"  maxlength="10" value="${uid}" name="uid" placeholder="UID 입력" id="uid">
								</div>
								<div class="influ_date_warp">
									<div class="text-block-18">전화번호</div>
									<input type="text" class="text-field-16 w-input" maxlength="15" value="${searchPhone}" name="searchPhone" placeholder="전화번호 검색" id="phone">
								</div>
								<div class="influ_date_warp">
									<div class="text-block-18">코인종류</div>
									<select id="symbol" name="symbol" class="select-field-6 w-select">
										<option value="">전체</option>
										<c:forEach var="coin" items="${useCoin}" varStatus="i">
											<c:set var="useSymbol" value="${coin}USDT"/>
											<option value="${useSymbol}"<c:if test="${symbol eq useSymbol}">selected</c:if>>${useSymbol}</option>
										</c:forEach>
									</select>
								</div>
								<div class="influ_searchbtnwarp">
									<img src="/global/webflow/images/search_1search.png" loading="lazy" alt="" class="image-48"> 
									<a href="javascript:checkForm()" class="button-24 w-button">찾기</a>
								</div>
							</form>
						</div>
					</div>
					<div class="influ_mainblock2">
						<div class="influ_tablebox">
							<div class="influ_tabletop">
								<div class="influ_tablelist right">
									<div class="influ_titletext">UID</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">직속 상위</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">전화번호</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">심볼</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">주문타입</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">포지션(보유방향)</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">평단가</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">수량</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">레버리지</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">수익</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">거래일시</div>
								</div>
							</div>
							<c:forEach var="item" items="${list}">
								<div class="influ_tablelcontent">
									<div class="influ_tablelist right">
										<div class="influ_text">${item.userIdx}</div>
									</div>
									<div class="influ_tablelist">
										<div class="influ_text">
											<c:if test="${item.pName eq null}">없음(최상위)</c:if>
											<c:if test="${item.pName ne null}">${item.pName}</c:if>
										</div>
									</div>
									<div class="influ_tablelist">
										<div class="influ_text">${item.phone}</div>
									</div>
									<div class="influ_tablelist">
										<div class="influ_text">${item.symbol}</div>
									</div>
									<div class="influ_tablelist">
										<div class="influ_text">${item.orderType}</div>
									</div>
									<div class="influ_tablelist">
                                       	<c:if test="${item.isOpen eq true}">
                                          	<c:if test="${item.position eq 'long'}"><div class="influ_text long">LONG</div></c:if>
                                          	<c:if test="${item.position eq 'short'}"><div class="influ_text short">SHORT</div></c:if>
										</c:if>
										<c:if test="${item.isOpen ne true}">
                                          	<c:if test="${item.position eq 'long'}"><div class="influ_text short">SHORT</div></c:if>
                                          	<c:if test="${item.position eq 'short'}"><div class="influ_text long">LONG</div></c:if>
										</c:if>
									</div>
									<div class="influ_tablelist">
										<div class="influ_text"><fmt:formatNumber value="${item.entryPrice}" pattern="#,###.####"/></div>
									</div>
									<div class="influ_tablelist">
										<div class="influ_text"><fmt:formatNumber value="${item.buyQuantity}" pattern="#,###.####"/></div>
									</div>
									<div class="influ_tablelist">
										<div class="influ_text">${item.leverage }</div>
									</div>
									<div class="influ_tablelist">
										<div class="influ_text">
											<c:if test="${item.isOpen eq true}">오픈</c:if>
                                           	<c:if test="${item.isOpen ne true}"><fmt:formatNumber value="${item.result}" pattern="#,###.########"/></c:if>
                                       	</div>
									</div>
									<div class="influ_tablelist">
										<div><fmt:formatDate value="${item.buyDatetime}" pattern="MM-dd HH:mm"/></div>
									</div>
								</div>
							</c:forEach>
						</div>
						<div class="influ_pagigng">
							<ui:pagination paginationInfo="${pi}" type="customPageInfl" jsFunction="fn_egov_link_page"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script
		src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93"
		type="text/javascript"
		integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
		crossorigin="anonymous"></script>
	<script src="/global/webflow/js/webflow.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		function checkForm() {			
			$("#listForm").submit();
		}

		function fn_egov_link_page(page) {
			document.listForm.pageIndex.value = page;
			document.listForm.submit();
		}
	</script>
</body>
</html>