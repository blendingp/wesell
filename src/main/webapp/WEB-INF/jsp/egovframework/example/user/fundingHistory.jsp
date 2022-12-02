<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html >
<html data-wf-page="62b19eeb0a51b18031a46110" data-wf-site="62b1125ac4d4d60ab9c62f81">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>funding history</title>
<meta content="funding history" property="og:title">
<meta content="funding history" property="twitter:title">
<jsp:include page="../userFrame/header.jsp"></jsp:include>
</head>
<body class="body2">
	<div class="frame">
		<jsp:include page="../userFrame/top.jsp"></jsp:include>
		<div class="frame2">
			<div class="asset_block">
				<div class="assetbox">
					<div class="assettitle"><spring:message code="menu.fundingHistory"/></div>
					<div class="asset_warp">
						<div class="form-block-4 w-form">
							<form id="listForm" name="listForm" action="/global/user/fundingHistory.do" class="form-3">
								<input type="hidden" name="pageIndex" />
								<input type="hidden" name="date" id="date" value="${date}" />
								<input type="hidden" name="edate" id="edate" value="${edate}" />
								<select id="symbol" name="symbol" onchange="changeVal('symbol', this)" class="select-field-5 w-select">
									<c:forEach var="coin" items="${useCoin}" varStatus="i">
										<c:set var="useSymbol_i" value="${coin}USD"/>
										<c:set var="useSymbol" value="${coin}USDT"/>
										<option value="${useSymbol}"<c:if test="${symbol eq useSymbol}">selected</c:if>>${useSymbol}</option>
										<option value="${useSymbol_i}"<c:if test="${symbol eq useSymbol_i}">selected</c:if>>${useSymbol_i}</option>
									</c:forEach>
								</select>
								<div class="date_warp">
									<div class="text2"><spring:message code="th.start"/> <spring:message code="th.date"/></div>
									<input type="text" class="text-field-5 w-input" name="dateText" value="${date}" autocomplete="off" id="dateText" >
	                				<div class="text2"><spring:message code="th.end"/> <spring:message code="th.date"/></div>
	                				<input type="text" class="text-field-5 w-input" name="endDateText" value="${edate}" autocomplete="off" id="endDateText" >
								</div>
							</form>
						</div>
						<div class="table_warp funding">
							<div class="asset_tabletop funding">
								<div class="listtext3"><spring:message code="referral.date"/></div>
								<div class="listtext3"><spring:message code="trade.symbol"/></div>
								<div class="listtext2"><spring:message code="referral.position"/></div>
								<div class="listtext2"><spring:message code="referral.funding"/></div>
							</div>
							<div class="assetwarp mypage">
								<div class="no_data" style=" <c:if test="${fn:length(list) == 0}">display:flex;</c:if>">
									<spring:message code="trader.nodata" />
								</div>
								<div class="asset_table funding">
								<c:forEach var ="item" items="${list}">
									<div class="asset_tablelist">
										<div class="listtext3"><fmt:formatDate value="${item.fundDatetime}" pattern="yyyy-MM-dd HH:mm"/></div>
										<div class="listtext3">${item.symbol}</div>
										<div class="listtext2">${item.position}</div>
										<div class="listtext2"><fmt:formatNumber value="${item.fundingFee}" pattern="#,###.####"/></div>
									</div>
								</c:forEach>
								</div>
							</div>
						</div>
					</div>
					<div class="listpage_warp">
						<ui:pagination paginationInfo="${pi}" type="customPageUser" jsFunction="fn_egov_link_page" />
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../userFrame/footer.jsp"></jsp:include>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="/global/webflow/js/webflow.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
	<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		var tempStartDate = "${date}";
		var tempEndDate = "${edate}";

		function fn_egov_link_page(page) {
			document.listForm.pageIndex.value = page;
			document.listForm.submit();
		}
		function changeVal(type, self) {
			if (type == 'symbol') {
				$("#symbol").val($(self).val());
			} else if (type == 'date') {
				$("#date").val(self);
				tempStartDate = $("#date").val();
			} else {
				$("#endDate").val(self);
				tempEndDate = $("#endDate").val();
			}
			$("#listForm").submit();
		}
		$(function() {
			$("#dateText").datepicker({
				dateFormat : 'yy-mm-dd',
				beforeShow : function(input) {
					$(input).css({
						"position" : "relative",
						"z-index" : 3
					});
				},
				onSelect : function(dateText, inst) {
					if (dateComparison()) {
						$("#date").val(dateText);
						$("#listForm").submit();
					}
				}
			});
			$("#endDateText").datepicker({
				dateFormat : 'yy-mm-dd',
				beforeShow : function(input) {
					$(input).css({
						"position" : "relative",
						"z-index" : 3
					});
				},
				onSelect : function(dateText, inst) {
					if (dateComparison()) {
						$("#edate").val(dateText);
						$("#listForm").submit();
					}
				}
			});
		});

		function dateComparison() {
			var startDate = $('#dateText').val();
			var endDate = $('#endDateText').val();

			//-을 구분자로 연,월,일로 잘라내어 배열로 반환
			var startArray = startDate.split('-');
			var endArray = endDate.split('-');
			//배열에 담겨있는 연,월,일을 사용해서 Date 객체 생성
			var start_date = new Date(startArray[0], startArray[1],
					startArray[2]);
			var end_date = new Date(endArray[0], endArray[1], endArray[2]);
			//날짜를 숫자형태의 날짜 정보로 변환하여 비교한다.
			if (start_date.getTime() > end_date.getTime()) {
				$('#dateText').val(tempStartDate);
				$('#endDateText').val(tempEndDate);
				alert("<spring:message code='pop.lessthenDate'/>");
				return false;
			}
			return true;
		}
		datePickerLangSet();
	</script>
</body>

</html>