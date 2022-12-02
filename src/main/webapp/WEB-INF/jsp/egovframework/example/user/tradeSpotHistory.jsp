<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html data-wf-page="618389030331be5203b75d9a" data-wf-site="6180a71858466749aa0b95bc">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Transactional information</title>
<meta content="transactional information" property="og:title">
<meta content="transactional information" property="twitter:title">
<jsp:include page="../userFrame/header.jsp"></jsp:include>
<style>
.settle-complete__box {
	color:white
}
</style>
</head>
<body class="body2">
	<div class="frame">
		<jsp:include page="../userFrame/top.jsp"></jsp:include>
		<div class="frame2">
			<div class="asset_block">
				<div class="assetbox">
					<div class="assettitle"><spring:message code="trade.tradeHistory"/></div>
					<div class="form-block-4 w-form">
						<form id="listForm" name="listForm" action="/global/user/tradeSpotHistory.do" class="form-3">
							<input type="hidden" name="pageIndex" /> 
							<input type="hidden" name="date" id="date" value="${date}" />
							<input type="hidden" name="endDate" id="endDate" value="${endDate}" /> 
							<select id="symbol" name="symbol" onchange="changeVal('symbol', this)" class="select-field-5 w-select">
								<c:forEach var="coin" items="${useCoin}" varStatus="i">
									<c:set var="useSymbol" value="${coin}USDT"/>
									<c:set var="useSymbol_i" value="${coin}USD"/>
									<%-- <option value="${useSymbol}"<c:if test="${symbol eq useSymbol}">selected</c:if>>${useSymbol}</option> --%>
									<option value="${useSymbol_i}"<c:if test="${symbol eq useSymbol_i}">selected</c:if>>${useSymbol_i}</option>
								</c:forEach>
							</select>
							<div class="date_warp">
								<div class="text2"><spring:message code="th.start"/> <spring:message code="th.date"/></div>
	                			<input type="text" class="text-field-5 w-input" name="dateText" value="${date}" autocomplete="off" id="dateText" >
	          				 	<div class="text2"><spring:message code="th.end"/> <spring:message code="th.date"/></div>
	                			<input type="text" class="text-field-5 w-input" name="endDateText" value="${endDate}" autocomplete="off" id="endDateText" >
	                		</div>
						</form>
					</div>
					<div class="table_warp">
						<div class="asset_tabletop">
							<div class="listtext1"><spring:message code="th.time"/></div>
							<div class="listtext3"><spring:message code="th.type"/></div>
							<div class="listtext1"><spring:message code="trade.trade"/></div>
							<div class="listtext2"><spring:message code="th.price"/></div>
							<div class="listtext3"><spring:message code="th.qty"/></div>
<%-- 							<div class="listtext3"><spring:message code="th.fee"/></div> --%>
<%-- 							<div class="listtext3"><spring:message code="trade.profit_1"/></div>					 --%>
						</div>
						<div class="assetwarp mypage">
							<div class="no_data" style=" <c:if test="${fn:length(list) == 0}">display:flex;</c:if>">
								<spring:message code="trader.nodata" />
							</div>
							<div class="asset_table">
							<c:forEach var="item" items="${list}">
								<c:set var="coinname" value="${fn:substringBefore(item.symbol,'USD')}"/>
								<c:set var="priceUnit" value="USDT"/>
								<c:if test="${fn:substringAfter(item.symbol,'USD') ne 'T'}">
									<c:set var="priceUnit" value="${coinname}"/>
								</c:if>
								
								<div class="asset_tablelist">
									<div class="listtext1"><fmt:formatDate value="${item.buyDatetime}" pattern="MM-dd HH:mm"/></div>
									<div class="listtext3">${item.orderType}</div>
									<c:if test="${item.isOpen eq true}">
                                       	<c:if test="${item.position eq 'long'}"><c:set var="position" value="long"/></c:if>
                                       	<c:if test="${item.position eq 'short'}"><c:set var="position" value="short"/></c:if>
									</c:if>
									<c:if test="${item.isOpen ne true}">
                                       	<c:if test="${item.position eq 'long'}"><c:set var="position" value="long"/></c:if>
                                       	<c:if test="${item.position eq 'short'}"><c:set var="position" value="short"/></c:if>
									</c:if>
									<div class="listtext1 ${position}">
										<c:if test="${item.position eq 'long'}">BUY</c:if>
                                       	<c:if test="${item.position eq 'short'}">SELL</c:if>
									</div>
									<div class="listtext2"><fmt:formatNumber value="${item.entryPrice}" pattern="#,###.##"/> USDT</div>
									<div class="listtext3"><fmt:formatNumber value="${item.buyQuantity}" pattern="#,###.####"/> ${coinname}</div>
										<c:if test="${item.position eq 'long'}"><c:set var="cl" value="revenue"/></c:if>
										<c:if test="${item.position eq 'short'}"><c:set var="cl" value="loss"/></c:if>
<%-- 									<div class="listtext3 ${cl}"><fmt:formatNumber value="${item.fee}" pattern="#,###.####"/> ${priceUnit}</div> --%>
<%-- 									<div class="listtext3 ${cl}"> --%>
<%-- 										<c:if test="${item.isOpen eq true}"> --%>
<%-- 											<spring:message code="trade.open"/> --%>
<%-- 										</c:if> --%>
<%-- 										<c:if test="${item.isOpen ne true}"> --%>
<%-- 											<fmt:formatNumber value="${item.result}" pattern="#,###.########"/> ${priceUnit}					 --%>
<%-- 										</c:if> --%>
										<%-- <div>										
											<c:if test="${item.isOpen ne true}">
												<c:if test="${item.liqPrice ne 0}">
													<div class="h_listblock">								
														<a href="javascript:settlePopup(${item.entryPrice},${item.liqPrice},'${item.position}',${item.leverage},${item.buyQuantity},${item.margin},'${item.marginType}')" class="copy_topbtn w-button">Profit</a>
													</div>
												</c:if>													
											</c:if>	
										</div>	 --%>																
<!-- 									</div>						 -->
								</div>
							</c:forEach>
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
		<div class="settle-complete" id="settlePop" style="display: none; z-index: 15; letter-spacing: -0.5px; font-family:'Nanumsquareotf ac', sans-serif;">
			<div class="settle-complete__box">
				<div class="div-block-84">
					<div class="pop_yieldtxt revenue_color up">
						<span id="pop_profit">52.26%</span><span class="text-span-12">Profit Rate</span>
					</div>
					<img src="/global/webflow/images/sub_logo1.svg" loading="lazy" alt="" class="image-68">
				</div>
				<div class="div-block-124">
					<div class="div-block-85">
						<div class="qet">Coin</div>
						<div class="dqr">
							<span id="pop_sym">BTCUSDT</span> <span class="position_color long"><span id="pop_pos">LONG</span></span>
						</div>
					</div>
					<div class="div-block-85">
						<div class="qet">Leverage</div>
						<div class="dqr"><span id="pop_mtype">ISO</span> <span id="pop_lev"></span>x</div>
					</div>
					<div class="div-block-85">
						<div class="qet">Entry Price</div>
						<div class="dqr">
							<span id="pop_entry"></span><span class="wr"> USDT</span>
						</div>
					</div>
					<div class="div-block-85">
						<div class="qet">Liquidation Price</div>
						<div class="dqr">
							<span id="pop_liq"></span><span class="wr"> USDT</span>
						</div>
					</div>
				</div>
				<a href="#" onclick="$('#settlePop').css('display','none');"
					class="popx w-inline-block"><img
					src="/global/webflow/images/wx.png" loading="lazy" sizes="100vw"
					alt="" class="popximg"></a>
			</div>
		</div>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93"type="text/javascript"integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="/global/webflow/js/webflow.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
	<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		var tempStartDate = "${date}";
		var tempEndDate = "${endDate}";

		function fn_egov_link_page(page) {
			document.listForm.pageIndex.value = page;
			document.listForm.submit();
		}
		function changeVal(type, self) {
			if (type == 'symbol') {
				// 			if($(self).val() == 'XRPUSDT' || $(self).val() == 'TRXUSDT'){ //XRP.TRX 추가되면 해제
				// 				ready();
				// 				return;
				// 			}
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
						changeVal('date', dateText);
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
						changeVal('endDate', dateText);
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
		function ready() {
			alert("<spring:message code='pop.ServiceReady_1'/>");
		}
		datePickerLangSet();
		
		//팝업창
		function settlePopup(entry,liq,pos,lev,qty,margin,mtype){
			if(pos=='long')
				pos="short";
			else
				pos="long";
				
			$("#settlePop").css("display","flex");
			$("#pop_entry").text(fmtNum(entry));
			$("#pop_liq").text(fmtNum(liq));
			$("#pop_mtype").text(mtype);
			
			if(pos == 'long'){
				$(".position_color").removeClass("short");
				$(".position_color").addClass("long");
			}else{
				$(".position_color").removeClass("long");
				$(".position_color").addClass("short");				
			}
			$("#pop_pos").text(pos.toUpperCase());
			$("#pop_lev").text(lev);
			
			var volume = Number(entry)*Number(qty);
			var profit = getProfit(pos,liq,qty,volume);
			var rate = getProfitRate(profit,margin);
			
			//rate 계산식 추가해서 적용
			
			if(rate > 0){
				$(".revenue_color").removeClass("down");
				$(".revenue_color").addClass("up");
			}else{
				$(".revenue_color").removeClass("up");
				$(".revenue_color").addClass("down");
			}
			
			$("#pop_profit").text(toFixedDown(rate,2)+"%");
		}
		
		function getProfit(position,sise,qty,volume){
			sise = Number(sise);
			qty = Number(qty);
			volume = Number(volume);
			
			let profit = 0;
			if(position == "long"){
				profit = (sise * qty) - volume;
			}else if(position == "short"){
				profit = volume - (sise * qty);
			}
			return profit;
		}
		function getProfitRate(profit,margin){
			profit = Number(profit);
			margin = Number(margin);
			let rate = profit / margin * 100;
			if(isNaN(rate))
				rate = 0;
			return rate;
		}
	</script>
</body>
</html>