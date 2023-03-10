<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html data-wf-page="617677d96662339ac646c3b2" data-wf-site="615fe8348801178bd89ede05">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>transactional information</title>
<meta content="transactional information" property="og:title">
<meta content="transactional information" property="twitter:title">

<script>
	if ("${msg}" != "") {
		switch ("${msg}") {
		case "-1":
			alert("<spring:message code = 'pop.wrongAccess'/>");
			break;
		case "0":
			alert("<spring:message code = 'pop.confirmed'/>");
			break;
		case "1":
			alert("<spring:message code = 'pop.alreadyConfirmed'/>");
			break;
		}
	}
</script>

<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
</head>
<body class="body">
	<div class="frame">
		<jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
		<div class="frame2">
			<jsp:include page="../userFrame/walletFrame.jsp"></jsp:include>
			<div class="asset_block">
				<div class="assetbox">
					<div class="assettitle"><spring:message code="wallet.property" /></div>
					<div class="deposit_warp1">
						<div class="asset_value">
							<div class="assettxt1"><spring:message code="wallet.assetValue" /></div>
							<div class="assettxt2"><span id="totalBTC">0.0000000</span> BTC</div>
						</div>
					</div>
					<div class="deposit_warp4">
						<div class="assettitle"><spring:message code="wallet.WithdrawalList" /></div>
						<div class="form-block-4 w-form">
							<form id="listForm" name="listForm" action="/wesell/user/requestList.do" class="form-3">
								<input type="hidden" name="pageIndex" /> 
								<select onchange="coinChange(this.value)" name="coinname" class="select-field-5 w-select">
									<option value="" <c:if test="${coinname eq ''}">selected</c:if>>
										<spring:message code="wallet.all" />
									</option>
									<option value="BTC"
										<c:if test="${coinname eq 'BTC'}">selected</c:if>>BTC</option>
									<option value="USDT"
										<c:if test="${coinname eq 'USDT'}">selected</c:if>>USDT</option>
									<option value="ETH"
										<c:if test="${coinname eq 'ETH'}">selected</c:if>>ETH</option>
									<option value="TRX"
										<c:if test="${coinname eq 'TRX'}">selected</c:if>>TRX</option>
									<option value="XRP"
										<c:if test="${coinname eq 'XRP'}">selected</c:if>>XRP</option>
								</select>
								<div class="date_warp">
									<div class="text2">
										<spring:message code="th.start" />
										<spring:message code="th.date" />
									</div>
									<input type="text" class="text-field-5 w-input" name="date" value="${date}" autocomplete="off" id="dateText">
									<div class="text2">
										<spring:message code="th.end" />
										<spring:message code="th.date" />
									</div>
									<input type="text" class="text-field-5 w-input" name="edate" value="${edate}" autocomplete="off" id="endDateText">
								</div>
							</form>
						</div>
					</div>
					<div class="table_warp">
						<div class="asset_tabletop">
							<div class="listtext1">
								<spring:message code="th.time" />
							</div>
							<div class="listtext1">
								<spring:message code="th.coin" />
							</div>
							<div class="listtext3">
								<spring:message code="th.qty" />
							</div>
							<div class="listtext3">
								<spring:message code="wallet.fee" />
							</div>
							<div class="listtext2">
								<spring:message code="wallet.address" />
							</div>
							<div class="listtext3"><spring:message code="trade.action" /></div>
							<div class="listtext1">
								<spring:message code="th.state" />
							</div>
						</div>
						<div class="assetwarp">
							<div class="no_data" style=" <c:if test="${fn:length(list) == 0}">display:flex;</c:if>">
								<spring:message code="trader.nodata" />
							</div>
							<div class="asset_table">
								<c:forEach var="item" items="${list}">
									<div class="asset_tablelist">
										<div class="listtext1">
											<fmt:formatDate value="${item.wdate}" pattern="yyyy-MM-dd HH:mm"/>
										</div>
										<div class="listtext1">${item.wcoinname}</div>
										<div class="listtext3">${item.wamount}</div>
										<div class="listtext3">${item.wfee}</div>
										<div class="listtext2" style="word-break: break-all;">${item.waddress}&nbsp;&nbsp; <c:if test="${item.xrptag ne null }"><span style="color:gray">(D Tag:${item.xrptag})</span></c:if></div>
										<div class="listtext3">
											<c:if test="${item.wstat eq -1 }">
												<div class="withrawlbtnblock">
													<a href="javascript:mailSend(${item.widx})" class="button-22 w-button"><spring:message code="wallet.reSend"/></a>
												</div>
<!-- 												<div class="withrawl_cancle1"> -->
<%-- 													<a href="javascript:cancel(${item.widx})" class="button-9 w-button"><spring:message code="wallet.cancel" /></a> --%>
<!-- 												</div> -->
											</c:if>
<%-- 											<c:if test="${item.wstat eq 0 }"> --%>
<!-- 												<div class="withrawl_cancle1"> -->
<%-- 													<a href="javascript:cancel(${item.widx})" class="button-9 w-button"><spring:message code="wallet.cancel" /></a> --%>
<!-- 												</div> -->
<%-- 											</c:if> --%>
											<c:if test="${item.wstat == 1 || item.wstat == 2 }"></c:if>
										</div>
											<c:if test="${item.wstat == -1 }">
												<div class="listtext1"><spring:message code="th.pending" /></div>
											</c:if>
											<c:if test="${item.wstat == 0}">
												<div class="listtext1"><spring:message code="th.pending_1" /></div>
											</c:if>
											<c:if test="${item.wstat == 1}">
												<div class="listtext1 ok"><spring:message code="th.approved" /></div>
											</c:if>
											<c:if test="${item.wstat == 2}">
												<div class="listtext1 cancle"><spring:message code="th.unapproved_1" /></div>
											</c:if>
											<c:if test="${item.wstat == 3}">
												<div class="listtext1 progress"><spring:message code="wallet.cancel" /></div>
											</c:if>
									</div>
								</c:forEach>
							</div>
						</div>
						<div class="listpage_warp">
							<ui:pagination paginationInfo="${pi}" type="customPageUser" jsFunction="fn_egov_link_page" />
						</div>
					</div>
				</div>
				<div class="withrawlpop" id="popwallet" style="display:none">
					<div class="withrawlblock">
						<div class="pop_exist" style="display: flex;">
							<img src="/wesell/webflow/images2/wx.png" onclick="javascript:closePop()" loading="lazy" alt="" class="image-38">
						</div>
						<div class="title6">
							<spring:message code="wallet.withdrawal" />
							<spring:message code="join.code" />
						</div>
						<div class="form-block-14 w-form">
							<div class="pop_input">
								<input type="text" class="text-field-18 w-input" maxlength="6" id="codeInput" onkeyup="SetNum(this)">
								<a href="javascript:emailConfirm()" class="button-32 w-button">
									<spring:message	code="affiliate.check" /></a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
	</div>

	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="/wesell/webflow/js/webflow2.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
	<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		var tempStartDate = "${date}";
		var tempEndDate = "${edate}";
		var widx = 0;

		function fn_egov_link_page(page) {
			document.listForm.pageIndex.value = page;
			document.listForm.submit();
		}

		var canceling = false;
// 		function cancel(widx) {
// 			if (canceling)
// 				return;
// 			canceling = true;

// 			$.ajax({
// 				type : 'post',
// 				dataType : 'json',
// 				data : {
// 					'widx' : widx
// 				},
// 				url : '/wesell/user/withdrawCancel.do',
// 				success : function(data) {
// 					alert(data.msg);
// 					location.reload();
// 				},
// 				error : function(e) {
// 					console.log('ajax error ' + JSON.stringify(e));
// 				}
// 			})
// 			canceling = false;
// 		}

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

		function coinChange(val) {
			$("#listForm").submit();
		}

		var sending = false;
		function mailSend(idx) {
			if (sending)
				return;
			sending = true;

			$.ajax({
				type : 'post',
				data : {
					'idx' : idx,
				},
				dataType : 'json',
				url : '/wesell/user/withdrawRePhone.do',
				success : function(data) {
					sending = false;
					alert(data.msg);
					if (data.result = "success") {
						codePop();
						widx = data.widx;
					}
				},

				error : function(e) {
					sending = false;
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}
		function codePop() {
			$("#popwallet").css("display", "flex");
		}
		function closePop() {
			$("#popwallet").css("display", "none");
			$("#codeInput").val("");
		}
		function SetNum(obj) {
			val = obj.value;
			re = /[^0-9]/gi;
			obj.value = val.replace(re, "");
		}
		function emailConfirm() {
			var code = $("#codeInput").val();
			$.ajax({
				type : 'post',
				data : {
					'widx' : widx,
					'code' : code
				},
				dataType : 'json',
				url : '/wesell/user/requestListConfirm.do',
				success : function(data) {
					alert(data.msg);
					if (data.result == "success") {
						closePop();
						location.reload();
					}
				},

				error : function(e) {
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}
		datePickerLangSet();
		
	var coinArr = new Array('BTCUSDT', 'ETHUSDT', 'XRPUSDT', 'TRXUSDT'); // 코인 변수명 
	var fPrice = new Object;
	var longSise = new Array(0, 0, 0, 0, 0); // 코인별 매수 시세 
	var walletBTC = "${walletBTC}";
	var walletUSDT = "${walletUSDT}";
	var walletXRP = "${walletXRP}";
	var walletTRX = "${walletTRX}";
	var walletETH = "${walletETH}";

		var wsAPIUri = "wss://fstream.binance.com/stream?streams=";
		for (i = 0; i < coinArr.length; i++) {
			if(i==0){
				wsAPIUri += coinArr[i].toLowerCase() + '@kline_1m';
			}else{
				wsAPIUri += '/' + coinArr[i].toLowerCase() + '@kline_1m';
			}
		}

		var websocket2;

		function initAPI() {
			websocket2 = new WebSocket(wsAPIUri);
			websocket2.onopen = function(evt) {
				console.log("connect OK");
				onAPIOpen(evt);
			};
			websocket2.onmessage = function(evt) {
				onAPIMessage(evt);
			};
			websocket2.onerror = function(evt) {
				onAPIError(evt);
			};
			websocket2.onclose = function(evt) {
				console.log("API 재접속");
				setTimeout("initAPI()", 1000);
			};
		}
		function onAPIOpen(evt) {
			console.log('APIOPEN---------------')
		}
		function onAPIMessage(evt) {
			let jdata = JSON.parse(evt.data);
			let stream = jdata.stream;

			if (stream.slice(-9) === '@kline_1m') {
				try{
					fPrice[jdata.data.s] = jdata.data.k['c'];
					let arr = new Array(5);
					let coin = ['BTC','ETH','XRP','TRX','DOGE'];
					for(i=0; i<coin.length; i++) {
					  let sym = coin[i];
					  let type;
					  sym === 'BTC' ? type = 0 : sym === 'ETH' ? type = 1 : sym === 'XRP' ? type = 2 : sym === 'TRX' ? type = 3 : sym === 'DOGE' ? type = 4 : '';
					  for (key in fPrice) {
					    if (key === sym+'USDT') {
					      arr[type] = fPrice[key];
					    }
					  }
					}
					for(var k =0 ; k<5; k++){
						longSise[k] = arr[k];
					}
				}catch(e) {
					console.log(stream, " kline err",e);
				}
				updateTotalBTC();
			}
		}

		function updateTotalBTC() {

			var btc = Number(walletBTC);
			var usdt = Number(walletUSDT) / longSise[0];
			var xrp = Number(walletXRP * longSise[2]) / longSise[0];
			var trx = Number(walletTRX * longSise[3]) / longSise[0];
			var future = Number("${user.wallet}") / longSise[0];

			$("#totalBTC").html(toFixedDown((btc + usdt + xrp + trx + future), 6));
		}

		window.addEventListener("load", initAPI, false);
	</script>
</body>
</html>