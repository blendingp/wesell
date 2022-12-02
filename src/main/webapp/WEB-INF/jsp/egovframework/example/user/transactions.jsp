<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html data-wf-page="6183888cbdade398fdbed019"
	data-wf-site="6180a71858466749aa0b95bc">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>transactional information</title>
<meta content="transactional information" property="og:title">
<meta content="transactional information" property="twitter:title">
<jsp:include page="../userFrame/header.jsp"></jsp:include>
<script>
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
</script>
</head>
<body class="body2">
	<div class="frame">
		<jsp:include page="../userFrame/top.jsp"></jsp:include>
		<div class="frame2">
			<jsp:include page="../userFrame/walletFrame.jsp"></jsp:include>
			<div class="asset_block">
				<div class="assetbox">
					<div class="assettitle">
						<spring:message code="wallet.property" />
					</div>
					<div class="deposit_warp1">
						<div class="asset_value">
							<div class="assettxt1">
								<spring:message code="wallet.assetValue" />
							</div>
							<div class="assettxt2">
								<span id="totalBTC">0.0000000</span> BTC
							</div>
						</div>
					</div>
					<div class="deposit_warp4">
						<div class="assettitle">
							<spring:message code="wallet.DepAndWithHistory" />
						</div>
						<div class="form-block-4 w-form">
							<form name="listForm" id="listForm"
								action="/global/user/transactions.do" class="form-3">
								<input type="hidden" name="pageIndex" /> <select id="symbol"
									name="coinname" onchange="coinChange(this.value)"
									class="select-field-5 w-select">
									<option value=""
										<c:if test="${coinname eq ''}">selected</c:if>><spring:message
											code="wallet.all" /></option>
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
									<input type="text" class="text-field-5 w-input" name="date"
										value="${date}" autocomplete="off" id="dateText">
									<div class="text2">
										<spring:message code="th.end" />
										<spring:message code="th.date" />
									</div>
									<input type="text" class="text-field-5 w-input" name="edate"
										value="${edate}" autocomplete="off" id="endDateText">
								</div>
							</form>
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
									<spring:message code="wallet.DepAndWithclass" />
								</div>
								<div class="listtext3">
									<spring:message code="th.qty" />
								</div>
								<div class="listtext2">
									<spring:message code="th.tx" />
								</div>
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
												<fmt:formatDate value="${item.completionTime}"
													pattern="yyyy-MM-dd HH:mm" />
											</div>
											<div class="listtext1">${item.coin}</div>
											<div class="listtext3">
												<c:if test="${item.label eq '+'}">
													<spring:message code="wallet.deposit" />
												</c:if>
												<c:if test="${item.label eq '-'}">
													<spring:message code="wallet.withdrawal" />
												</c:if>
											</div>
											<div class="listtext3">
												<script>document.write(parseFloat('${item.amount}'));</script>
											</div>
											<div class="listtext2" style="word-break: break-all">${item.tx}&nbsp;&nbsp;
												<c:if test="${item.dtag ne null }">
													<span style="color: gray">(D Tag:${item.dtag})</span>
												</c:if>
											</div>
											<c:if test="${item.status == -1 }">
												<div class="listtext1">
													<spring:message code="th.pending" />
												</div>
											</c:if>
											<c:if test="${item.status == 0}">
												<div class="listtext1">
													<spring:message code="th.pending_1" />
												</div>
											</c:if>
											<c:if test="${item.status == 1}">
												<div class="listtext1 ok">
													<spring:message code="th.complete" />
												</div>
											</c:if>
											<c:if test="${item.status == 2}">
												<div class="listtext1 cancle">
													<spring:message code="th.unapproved_1" />
												</div>
											</c:if>
											<c:if test="${item.status == 3}">
												<div class="listtext1 progress">
													<spring:message code="wallet.cancel" />
												</div>
											</c:if>
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
		</div>
		<jsp:include page="../userFrame/footer.jsp"></jsp:include>
	</div>
	<script
		src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93"
		type="text/javascript"
		integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
		crossorigin="anonymous"></script>
	<script src="/global/webflow/js/webflow.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
	<link rel="stylesheet"
		href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		var tempStartDate = "${date}";
		var tempEndDate = "${edate}";

		function fn_egov_link_page(page) {
			document.listForm.pageIndex.value = page;
			document.listForm.submit();
		}

		function tabChange(deposit) {
			// 		$(".titlebotton").removeClass("click");
			// 		$("#"+deposit+"Bar").addClass("click");

			if (deposit == 'deposit') {
				$("#label").val("+");
			} else if (deposit == 'withdraw') {
				$("#label").val("-");
			}
			$("#listForm").submit();
		}
		function nonLabel() {
			if ($("#label").val() == null || $("#label").val() == "")
				$("#label").val('+');
			console.log($("#label").val());
		}
		//nonLabel();

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
			if (i == 0) {
				wsAPIUri += coinArr[i].toLowerCase() + '@kline_1m';
			} else {
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
			let
			jdata = JSON.parse(evt.data);
			let
			stream = jdata.stream;

			if (stream.slice(-9) === '@kline_1m') {
				try {
					fPrice[jdata.data.s] = jdata.data.k['c'];
					let
					arr = new Array(5);
					let
					coin = [ 'BTC', 'ETH', 'XRP', 'TRX', 'DOGE' ];
					for (i = 0; i < coin.length; i++) {
						let
						sym = coin[i];
						let
						type;
						sym === 'BTC' ? type = 0 : sym === 'ETH' ? type = 1
								: sym === 'XRP' ? type = 2
										: sym === 'TRX' ? type = 3
												: sym === 'DOGE' ? type = 4
														: '';
						for (key in fPrice) {
							if (key === sym + 'USDT') {
								arr[type] = fPrice[key];
							}
						}
					}
					for (var k = 0; k < 5; k++) {
						longSise[k] = arr[k];
					}
				} catch (e) {
					console.log(stream, " kline err", e);
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

			$("#totalBTC").html(
					toFixedDown((btc + usdt + xrp + trx + future), 6));
		}

		window.addEventListener("load", initAPI, false);
	</script>
</body>
</html>