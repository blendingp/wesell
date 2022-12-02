<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html data-wf-page="618388aa32debe327ad0f06c"
	data-wf-site="6180a71858466749aa0b95bc">
<head>
<meta charset="utf-8">
<jsp:include page="../userFrame/header.jsp"></jsp:include>
<script>
	var result = "${result}";
	if (result == "fail")
		alert("<spring:message code='pop.notBalance'/>");
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
							<spring:message code="wallet.futuresExchange" />
						</div>
						<div class="assetwarp">
							<div class="form-block-12 w-form">
								<form id="email-form-2" name="email-form-2"
									data-name="Email Form 2">
									<div class="asset_block2">
										<div class="asset_listbox">
											<div class="title2">
												<spring:message code="wallet.futuresExchange" />
											</div>
											<div class="exchangeinfo">
												<div class="coin_selectwrap">
													<select id="toTransfer" onchange="change()" name="coin"
														required="" data-name="coin"
														class="select-field-2 w-select">
														<option id="spot" value="spot"><spring:message
																code="wallet.spotWalletUSDT" /></option>
														<option id="futures" value="futures"><spring:message
																code="wallet.futuresUSDT" /></option>
													</select>
													<div class="text3 fromBalance">- USDT</div>
												</div>
												<div class="exchangebtn">
													<img src="../webflow/images/exchange_white.svg" loading="lazy"
														alt="" class="exchangebtn_img" onclick="valChange()">
												</div>
												<div class="coin_selectwrap">
													<select id="exchange" name="coin" required=""
														data-name="coin" class="select-field-2 w-select">
														<option id="from" selected><spring:message
																code="wallet.futuresUSDT" /></option>
													</select>
													<div class="text3 toBalance">- USDT</div>
												</div>
											</div>
										</div>
									</div>
								</form>
							</div>
							<div class="form-block-3 w-form">
								<div class="assetlistbox2">
									<div class="assetbox2">
										<div class="title2">
											<spring:message code="wallet.conversion" />
										</div>
										<div class="assetbox3">
											<form action="/global/user/transferProcess.do" id="sendform" method="POST">
												<input type="hidden" name="direction" id="direction" value="1" /> 
											    <input type="hidden" name="max" id="max" value="0"/>
												<input type="text" class="text-field-8 select w-input" maxlength="30" name="conversion" onInput="setDouble(this,5)" placeholder="0"
													id="conversion" required="" autocomplete="off">
											</form>
											<a href="javascript:max()" class="button-6 w-button">MAX</a>
										</div>
									</div>
									<div class="exchange_quote1">
										<div class="text3">
											<div class="asset_quote" id="available"
												style="margin-bottom: 1vh; width: auto; padding-left: 0; float: left">
												<spring:message code="wallet.available_1" />
												<!-- <div class="exchange_quote1">
                        <div class="text4">BTC 시세 : </div>
                      </div>
                      <div class="exchange_quote2">
                        <div class="text4">0.00000000 </div>
                      </div>
                      <div class="exchange_quote3">
                        <div class="text4">USDT</div>
                      </div> -->
											</div>
										</div>
									</div>
									<div class="assetbox4">
										<a href="#" onClick="transferSpotToFutures()"
											class="result_btn click w-button"><spring:message
												code="wallet.transferEx" /></a>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../userFrame/footer.jsp"></jsp:include>
	</div>
	<script
		src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6180a71858466749aa0b95bc"
		type="text/javascript"
		integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
		crossorigin="anonymous"></script>
	<script src="../js/webflow.js" type="text/javascript"></script>
	<script>
		var usdt = toFixedDown(${walletUSDT},5);
		var fUsdt = toFixedDown(${wallet},5);
		var realfUsdt = toFixedDown(${withdrawWallet},5);
		var realUsdt = toFixedDown(${withdrawUSDT},5);
		var availableText = "<spring:message code='wallet.available_1'/> : ";
		function valChange() {
			if ($("#toTransfer").val() == 'spot') {
				$("#toTransfer").val('futures');
			} else {
				$("#toTransfer").val('spot');
			}
			$("#toTransfer").trigger("change");
		}
		function change() {
			switch ($("#toTransfer").val()) {
			case 'spot':
				$("#from").html($("#futures").html());
				$("#available").html(availableText + realUsdt);
				$(".fromBalance").html(usdt + " USD");
				$(".toBalance").html(fUsdt + " USDT");
				$("#direction").val(1);
				break;
			case 'futures':
				$("#from").html($("#spot").html());
				$("#available").html(availableText + realfUsdt);
				$(".fromBalance").html(fUsdt + " USDT");
				$(".toBalance").html(usdt + " USD");
				$("#direction").val(0);
				break;
			}
			document.getElementById('conversion').value = null;
			futureUpdate();
			posWalletUpdate();
		}
		function max() {
			switch ($("#toTransfer").val()) {
			case 'spot':
				document.getElementById('conversion').value = realUsdt;
				break;
			case 'futures':
				document.getElementById('conversion').value = realfUsdt;
				break;
			}
		}
		function isAmount(asValue) {
			let
			regExp = /^\d+(?:[.]?[\d]?[\d]?[\d])?$/;
			return regExp.test(asValue); // 형식에 맞는 경우 true 리턴	
		}
		function isNumber(v) {
			var regex = /^\d*\.?\d*$/;
			return regex.test(v);
		}
		function transferSpotToFutures() {
			var amount = parseFloat(document.getElementById('conversion').value);
			if (amount == null || amount == ''|| !isNumber(amount)) {
				alert("<spring:message code='pop.transfer.inputExchange'/>");
				$("#conversion").focus();
				return false;
			}
			if (amount < 0.001 || isNaN(amount)) {
				alert("<spring:message code='pop.transfer.mininumExchange_1'/> 0.001<spring:message code='pop.transfer.mininumExchange_2'/>")
				$("#conversion").focus();
				return false;
			}
			if (!restrictAmount($('#conversion').val())) {
	 			alert("<spring:message code='pop.wallet.amountError'/>");
	 			return;
	 		}
			//			if (!isAmount(amount)) {
			//				alert("교환 금액을 제대로 입력해주세요.")
			//				$("#conversion").focus();
			//				return false;
			//			}
			/* 			if (amount > fUsdt + fee) {
			 alert("입력값이 보유한 금액보다 많습니다.")
			 $("#conversion").focus();
			 return false;
			 } */
			if($("#toTransfer").val() == "futures"){
				if($("#conversion").val() == realfUsdt){
					$("#max").val("1");
				}
			}else if($("#toTransfer").val() == "spot") {
				if($("#conversion").val() == realUsdt){
					$("#max").val("1");
				}
			}
			document.getElementById("sendform").submit();
		}
		change();

		setInterval(function() {
			posWalletUpdate()
		}, 5000);

		function posWalletUpdate() {
			$.ajax({
				type : 'post',
				dataType : 'json',
				url : '/global/user/getWithdrawFutures.do',
				success : function(data) {
					realfUsdt = toFixedDown(data.withdrawWallet, 5);
					realUsdt = toFixedDown(data.withdrawUSDT, 5);
					if (realfUsdt < 0)
						realfUsdt = 0;
					if (realUsdt < 0)
						realUsdt = 0;
					futureUpdate();
				},
				error : function(e) {
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}
		function futureUpdate() {
			switch ($("#toTransfer").val()) {
			case 'spot':
				$("#available").html(availableText + realUsdt);
				break;
			case 'futures':
				$("#from").html($("#spot").html());
				$("#available").html(availableText + realfUsdt);
				break;
			}
		}

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
						let sym = coin[i];
						let type;
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
			var future = Number("${wallet}") / longSise[0];

			$("#totalBTC").html(toFixedDown((btc + usdt + xrp + trx + future), 6));
		}

		function setDouble(obj , num){
			let regexp = /^[0-9]+(.[0-9]{0,4})?$/;
			val = obj.value;
			if(num == 1){
				regexp = /^[0-9]+(.[0-9]{0,1})?$/;
			}else if (num == 2){
				regexp = /^[0-9]+(.[0-9]{0,2})?$/;
			}
			if(!regexp.test(val)){
				obj.value = val.slice(0, -1);
			}
		}
		
		window.addEventListener("load", initAPI, false);
	</script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
</body>
</html>