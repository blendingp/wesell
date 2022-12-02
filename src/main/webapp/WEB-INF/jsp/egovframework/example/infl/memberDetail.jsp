<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html data-wf-page="618c69624aa9dc39e369f45f" data-wf-site="6180a71858466749aa0b95bc">
<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원관리</title>
<jsp:include page="../userFrame/header.jsp"></jsp:include>
</head>
<body class="influ_body">
	<div class="influ_frame">
		<div class="influ_block">
			<div class="mobbackdark" style="display:none;"></div>
			<jsp:include page="../userFrame/inflLeft.jsp"></jsp:include>
			<div class="influ_block1">
				<jsp:include page="../userFrame/infltop.jsp"></jsp:include>
				<div class="influ_mainblock">
					<div class="influ_mainblock1" style="height:70px;">
						<div class="influ_title1">${info.name} 상세</div>
					</div>
					<div class="influ_mainblock2" style="min-height:auto;">
						<div class="influ_title1">코인 정보</div>
						<div>
							<div class="influ_tabletop">
								<div class="influ_tablelist list3">
									<div class="influ_titletext">Futures</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">BTC</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">USDT</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">XRP</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">ETH</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">TRX</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">거래 수</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">수익률</div>
								</div>
							</div>
							<div class="influ_tablelcontent">
								<div class="influ_tablelist list3">
									<div><fmt:formatNumber value="${info.futures}" pattern="#,###.#####"/> Futures</div>
								</div>
								<div class="influ_tablelist list3">
									<div><fmt:formatNumber value="${info.btc}" pattern="#,###.#####"/> BTC</div>
								</div>
								<div class="influ_tablelist list3">
									<div><fmt:formatNumber value="${info.usdt}" pattern="#,###.#####"/> USDT</div>
								</div>
								<div class="influ_tablelist list3">
									<div><fmt:formatNumber value="${info.xrp}" pattern="#,###.#"/> XRP</div>
								</div>
								<div class="influ_tablelist list3">
									<div><fmt:formatNumber value="${info.eth}" pattern="#,###.####"/> ETH</div>
								</div>
								<div class="influ_tablelist list3">
									<div><fmt:formatNumber value="${info.trx}" pattern="#,###"/> TRX</div>
								</div>
								<div class="influ_tablelist list3">
									<div><fmt:formatNumber value="${info.tradeCount}" pattern="#,###"/></div>
								</div>
								<div class="influ_tablelist list3">
									<div><fmt:formatNumber value="${info.roi}" pattern="#,###.##"/>%</div>
								</div>
							</div>
						</div>
					</div>
					
					<div class="influ_mainblock2" style="min-height:auto;">
						<div class="influ_title1">입출금 정보</div>
						<div>
							<div class="influ_tabletop">
								<div class="influ_tablelist list3">
									<div class="influ_titletext">코인</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div class="influ_titletext">입금</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div class="influ_titletext">출금</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div class="influ_titletext">입금-출금</div>
								</div>
							</div>
							<div class="influ_tablelcontent">
								<div class="influ_tablelist list3">
									<div>BTC</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.btcDeposit}" pattern="#,###.########"/> BTC</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.btcWithdraw}" pattern="#,###.########"/> BTC</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.btcDeposit - dwInfo.btcWithdraw}" pattern="#,###.########"/> BTC</div>
								</div>
							</div>
							<div class="influ_tablelcontent">
								<div class="influ_tablelist list3">
									<div>USDT</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.usdtDeposit}" pattern="#,###.########"/> USDT</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.usdtWithdraw}" pattern="#,###.########"/> USDT</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.usdtDeposit - dwInfo.usdtWithdraw}" pattern="#,###.########"/> USDT</div>
								</div>
							</div>
							<div class="influ_tablelcontent">
								<div class="influ_tablelist list3">
									<div>ETH</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.ethDeposit}" pattern="#,###.########"/> ETH</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.ethWithdraw}" pattern="#,###.########"/> ETH</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.ethDeposit - dwInfo.ethWithdraw}" pattern="#,###.########"/> ETH</div>
								</div>
							</div>
							<div class="influ_tablelcontent">
								<div class="influ_tablelist list3">
									<div>XRP</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.xrpDeposit}" pattern="#,###.########"/> XRP</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.xrpWithdraw}" pattern="#,###.########"/> XRP</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.xrpDeposit - dwInfo.xrpWithdraw}" pattern="#,###.########"/> XRP</div>
								</div>
							</div>
							<div class="influ_tablelcontent">
								<div class="influ_tablelist list3">
									<div>TRX</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.trxDeposit}" pattern="#,###.########"/> TRX</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.trxWithdraw}" pattern="#,###.########"/> TRX</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.trxDeposit - dwInfo.trxWithdraw}" pattern="#,###.########"/> TRX</div>
								</div>
							</div>
							<div class="influ_tablelcontent">
								<div class="influ_tablelist list3">
									<div>KRW</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.krwDeposit}" pattern="#,###.########"/> KRW</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.krwWithdraw}" pattern="#,###.########"/> KRW</div>
								</div>
								<div class="influ_tablelist list3" style="width:30%;">
									<div><fmt:formatNumber value="${dwInfo.krwDeposit - dwInfo.krwWithdraw}" pattern="#,###.########"/> KRW</div>
								</div>
							</div>
						</div>
					</div>
					
					<form id="listForm" name="listForm" action = "/global/infl/memberDetail.do">
						<input type="hidden" name="kpageIndex" id="kpageIndex"/>
						<input type="hidden" name="pageIndex" id="pageIndex"/>
						<input type="hidden" name="idx" id="userIdx" value="${info.idx}"/>
					
					
						<div class="influ_mainblock2" style="min-height:auto;">
							<div class="influ_title1">입출금 내역</div>
							<div class="form-block-9 w-form" style="margin-bottom:20px;">
								<div class="form-9">
									<div class="influ_date_warp">
										<div class="text-block-18">시작날짜</div>
										<input class="text-field-16 w-input" type="date" id="sdate" name="sdate" value="${sdate}" autocomplete="off">
									</div>
									<div class="text-block-20">~</div>
									<div class="influ_date_warp">
										<div class="text-block-18">종료날짜</div>
										<input class="text-field-16 w-input"  type="date" id="edate" name="edate" value="${edate}" autocomplete="off">
									</div>
									<div class="influ_searchbtnwarp">
										<img src="/global/webflow/images/search_1search.png" loading="lazy" alt="" class="image-48"> 
										<a href="javascript:checkForm(1);" class="button-24 w-button">찾기</a>
									</div>
								</div>
							</div>
							<div>
								<div class="influ_tabletop">
									<div class="influ_tablelist list3">
										<div class="influ_titletext">구분</div>
									</div>
									<div class="influ_tablelist list3">
										<div class="influ_titletext">코인</div>
									</div>
									<div class="influ_tablelist list3">
										<div class="influ_titletext">수량</div>
									</div>
									<div class="influ_tablelist list3" style="width:40%;">
										<div class="influ_titletext">tx</div>
									</div>
									<div class="influ_tablelist list3">
										<div class="influ_titletext">시간</div>
									</div>
								</div>
								<c:forEach var="item" items="${list}">
									<div class="influ_tablelcontent">
										<div class="influ_tablelist list3">
											<div>
												<c:if test="${item.label eq '+'}">입금</c:if>
	                                        	<c:if test="${item.label eq '-'}">출금</c:if>
	                                       	</div>
										</div>
										<div class="influ_tablelist list3">
											<div>${item.coin}</div>
										</div>
										<div class="influ_tablelist list3">
											<div><fmt:formatNumber value="${item.amount}" pattern="#,###.########"/> ${item.coin}</div>
										</div>
										<div class="influ_tablelist list3" style="width:40%;">
											<div>${item.tx}</div>
										</div>
										<div class="influ_tablelist list3">
											<div><fmt:formatDate value="${item.completionTime}" pattern="yyyy-MM-dd HH:mm"/></div>
										</div>
									</div>
								</c:forEach>
							</div>
							<div class="influ_pagigng">
								<ui:pagination paginationInfo="${pi}" type="customPageInfl" jsFunction="fn_egov_link_page"/>
							</div>
						</div>
					
						<%-- <div class="influ_mainblock2" style="min-height:auto;">
							<div class="influ_title1">입출금 내역 (P2P)</div>
							<div class="form-block-9 w-form" style="margin-bottom:20px;">
								<div class="form-9">
									<div class="influ_date_warp">
										<div class="text-block-18">시작날짜</div>
										<input class="text-field-16 w-input" type="date" id="ksdate" name="ksdate" value="${ksdate}" autocomplete="off">
									</div>
									<div class="text-block-20">~</div>
									<div class="influ_date_warp">
										<div class="text-block-18">종료날짜</div>
										<input class="text-field-16 w-input"  type="date" id="kedate" name="kedate" value="${kedate}" autocomplete="off">
									</div>
									<div class="influ_searchbtnwarp">
										<img src="/global/webflow/images/search_1search.png" loading="lazy" alt="" class="image-48"> 
										<a href="javascript:checkForm(2);" class="button-24 w-button">찾기</a>
									</div>
								</div>
							</div>
							<div>
								<div class="influ_tabletop">
									<div class="influ_tablelist list3">
										<div class="influ_titletext">구분</div>
									</div>
									<div class="influ_tablelist list4">
										<div class="influ_titletext">금액</div>
									</div>
									<div class="influ_tablelist list4">
										<div class="influ_titletext">환산 USDT</div>
									</div>
									<div class="influ_tablelist list4">
										<div class="influ_titletext">처리시간</div>
									</div>
									<div class="influ_tablelist list3">
										<div class="influ_titletext">상태</div>
									</div>
								</div>
								<c:forEach var="item" items="${klist}">
									<div class="influ_tablelcontent">
										<div class="influ_tablelist list3">
											<div>
												<c:if test="${item.kind eq '+'}">입금</c:if>
	                                        	<c:if test="${item.kind eq '-'}">출금</c:if>
	                                       	</div>
										</div>
										<div class="influ_tablelist list4">
											<div><fmt:formatNumber value="${item.money}" pattern="#,###.########"/> KRW</div>
										</div>
										<div class="influ_tablelist list4">
											<div><fmt:formatNumber value="${item.exchangeValue}" pattern="#,###.########"/> USDT</div>
										</div>
										<div class="influ_tablelist list4">
											<div><fmt:formatDate value="${item.date2}" pattern="yyyy-MM-dd HH:mm"/></div>
										</div>
										<div class="influ_tablelist list3">
											<div>완료</div>
										</div>
									</div>
								</c:forEach>
							</div>
							<div class="influ_pagigng">
								<ui:pagination paginationInfo="${kpi}" type="customPageInfl" jsFunction="fn_egov_link_page_k"/>
							</div>
						</div> --%>
					</form>
					
					<div class="influ_mainblock2" style="min-height:auto;">
						<div class="influ_title1">실시간 포지션</div>
						<div class="influ_tabletop">
							<div class="influ_tablelist list3">
								<div class="influ_titletext">심볼</div>
							</div>
							<div class="influ_tablelist list3">
								<div class="influ_titletext">포지션</div>
							</div>
							<div class="influ_tablelist list3">
								<div class="influ_titletext">레버리지</div>
							</div>
							<div class="influ_tablelist list3">
								<div class="influ_titletext">증거금</div>
							</div>
							<div class="influ_tablelist list3">
								<div class="influ_titletext">규모 USDT</div>
							</div>
							<div class="influ_tablelist list3">
								<div class="influ_titletext">진입가격</div>
							</div>
							<div class="influ_tablelist list3">
								<div class="influ_titletext">계약수량</div>
							</div>
							<div class="influ_tablelist list3">
								<div class="influ_titletext">청산가격</div>
							</div>
							<div class="influ_tablelist list3">
								<div class="influ_titletext">예상 수익</div>
							</div>
							<div class="influ_tablelist list3">
								<div class="influ_titletext">예상 수익률</div>
							</div>
						</div>
						<div id="pList">
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
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
	function fn_egov_link_page(page) {
		document.listForm.pageIndex.value = page;
		document.listForm.submit();
	}
	function fn_egov_link_page_k(page) {
		document.listForm.kpageIndex.value = page;
		document.listForm.submit();
	}
	function checkForm(type){
		if(type == 1){
			var sdate = $("#sdate").val();
			var edate = $("#edate").val();
			if((sdate == '' && edate != '') || (sdate != '' && edate == '')){
				alert("조회시작기간과 조회종료기간을 설정해주세요.");
				return;
			}
			if(edate < sdate){
				alert("조회종료기간이 조회시작기간보다 작을 수 없습니다.");
				return;
			}
			$("#listForm").submit();
		}else if(type == 2){
			var sdate = $("#ksdate").val();
			var edate = $("#kedate").val();
			if((sdate == '' && edate != '') || (sdate != '' && edate == '')){
				alert("조회시작기간과 조회종료기간을 설정해주세요.");
				return;
			}
			if(edate < sdate){
				alert("조회종료기간이 조회시작기간보다 작을 수 없습니다.");
				return;
			}
			$("#listForm").submit();
		}
	}
	function getUserPositionData(){
		var uidx = $("#userIdx").val();
		$.ajax({
			type :'post',
			data : {'userIdx' : uidx},
			url : '/global/infl/getUserPositionData.do',
			success:function(data){
				appendPositionList(data.plist);
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
	
	function appendPositionList(plist){
		if(plist == null) return;

		var $id = $("#pList");
		$id.empty();
		var length = plist.length;
		
		for(var i = 0; i < length; i++){
			var cnum = getCoinNum(plist.symbol);
				
			let betCoin = "USDT";
			if(isInverse(plist[i].symbol))
				betCoin = getCoinName(plist[i].symbol);
			
			$id.append(
				"<div class='influ_tablelcontent'><div class='influ_tablelist list3'>"+plist[i].symbol+"</div>"+
				"<div class='influ_tablelist list3'>"+plist[i].position.toUpperCase()+"</div>"+
				"<div class='influ_tablelist list3'>"+plist[i].leverage+"</div>"+
				"<div class='influ_tablelist list3'>"+parseFloat(plist[i].fee).toFixed(5)+" "+betCoin+"</div>"+
				"<div class='influ_tablelist list3'>"+plist[i].contractVolume+" USDT</div>"+
				"<div class='influ_tablelist list3'>"+plist[i].entryPrice+" USDT</div>"+
				"<div class='influ_tablelist list3'>"+plist[i].buyQuantity+" "+getCoinName(plist[i].symbol)+"</div>"+
				"<div class='influ_tablelist list3'>"+parseFloat(plist[i].liquidationPrice).toFixed(5)+" USDT</div>"+
				"<div class='influ_tablelist list3'>"+parseFloat(plist[i].profit).toFixed(5)+" "+betCoin+"</div>"+
				"<div class='influ_tablelist list3'>"+parseFloat(plist[i].profitRate).toFixed(2)+"%</div></div>");
		}
	}
	
	function getCoinNum(symbol) {
		switch (symbol) {
		case "BTCUSDT": case "BTC": case "BTCUSD":
			return 0;
		case "ETHUSDT": case "ETH": case "ETHUSD":
			return 1;
		case "XRPUSDT": case "XRP": case "XRPUSD":
			return 2;
		case "TRXUSDT": case "TRX": case "TRXUSD":
			return 3;
		case "DOGEUSDT": case "DOGE": case "DOGEUSD":
			return 4;
		case "LTCUSDT": case "LTC": case "LTCUSD":
			return 5;
		case "SANDUSDT": case "SAND": case "SANDUSD":
			return 6;
		case "ADAUSDT": case "ADA": case "ADAUSD":
			return 7;
		case "GMTUSDT": case "GMT": case "GMTUSD":
			return 8;
		case "APEUSDT": case "APE": case "APEUSD":
			return 9;
		case "GALAUSDT": case "GALA": case "GALAUSD":
			return 10;
		case "ROSEUSDT": case "ROSE": case "ROSEUSD":
			return 11;
		case "KSMUSDT": case "KSM": case "KSMUSD":
			return 12;
		case "DYDXUSDT": case "DYDX": case "DYDXUSD":
			return 13;
		default:
			break;
		}
	} 
	
	function getCoinName(symbol) {
		return symbol.split("USD")[0];
	} 
	
	function isInverse(symbol){
		let sym = String(symbol);
		if(sym.charAt(sym.length-1) == 'D')
			return true;
		return false;
	}
	getUserPositionData();
	setInterval(getUserPositionData,5000);
	
	</script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
</body>
</html>