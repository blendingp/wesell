<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html data-wf-page="618388a220ec744250bdd558"
	data-wf-site="6180a71858466749aa0b95bc">
<head>
<meta charset="utf-8">
<jsp:include page="../userFrame/header.jsp"></jsp:include>
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
							<div class="assettxt1"><spring:message code="wallet.assetValue" /></div>
							<div class="assettxt2"><span id="totalBTC">0.00000000</span> BTC</div>
						</div>
					</div>
					<div class="deposit_warp4">
						<div class="assettitle">
							<spring:message code="wallet.menu.exchange" />
						</div>
						<div class="assetwarp">
							<div class="form-block-13 w-form">
								<div class="asset_block2">
									<div class="assetbox2">
										<div class="title2">
											<spring:message code="wallet.coinExchange" />
										</div>
										<div class="exchangeinfo">
											<div class="coin_selectwrap">
												<select onchange="change()" id="coin1" name="coin"
													required="" data-name="coin"
													class="select-field-2 w-select">
													<option class="notUSDT" value="BTC" selected>BTC</option>
													<option class="notUSDT" value="XRP">XRP</option>
													<option class="notUSDT" value="TRX">TRX</option>
													<option class="notUSDT" value="ETH">ETH</option>
												</select>
												<div class="text3" id="balance1" style="width:auto;"><spring:message code="wallet.available_1" />: 0.000000 BTC</div>
											</div>
											<div class="exchangebtn" click" onclick="changeType()">
												<img src="../webflow/images/exchange_white.svg" loading="lazy" alt=""
													class="exchangebtn_img">
											</div>
											<div class="coin_selectwrap">
												<select onchange="change()" id="coin2" name="coin"
													required="" data-name="coin"
													class="select-field-2 w-select">
													<option class="notUSDT" value="USDT" selected>
														<spring:message code="wallet.spotWalletUSDT" />
													</option>
												</select>
												<div class="text3" id="balance2">0 USD</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="form-block-3 w-form">
								<div class="asset_block2">
									<div class="assetbox2">
										<div class="title2">
											<spring:message code="wallet.conversion" />
										</div>
										<div class="assetbox3">
											<form id="exchangeform">
												<input type="hidden" id="direction" name="direction"
													value="1" /> <input type="text"
													class="text-field-8 select w-input" maxlength="256"
													name="conversion" data-name="Field" placeholder="BTC"
													id="conversion" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" />
											</form>
											<a href="javascript:max();" class="button-6 w-button">MAX</a>
										</div>
									</div>
									<div class="asset_quote">
										<div class="exchange_quote1">
											<div class="text4" id="coinMarketPrice">
												BTC
												<spring:message code="wallet.marketPrice" />
											</div>
										</div>
										<div class="exchange_quote2">
											<div class="text4" id="marketprice">0.00000000</div>
										</div>
										<div class="exchange_quote3">
											<div class="text4" id="mar">USD</div>
										</div>
									</div>
								</div>
							</div>
							<div class="result_warp">
								<div class="title2">
									<spring:message code="wallet.estimated" />
								</div>
								<div class="assetbox5">
									<div class="exchange_result">
										<div class="exchange_result1">
											<div class="result_txt">
												<span id="estimatedTxt">0</span>
												<input type="hidden" id="estimated" />
												<span class="estCoin">BTC</span>
											</div>
											<!--  <div class="exchange_result1-copy">
                    	<div class="text-block-110 estCoin">BTC</div>
                    </div> -->
										</div>
									<div class="exchange_result2">
				                    	<!--<div class="text-block-110"  id="estimatedTxt">0</div>
				                        <input type="hidden" id="estimated"/> -->
				                    </div>
				                    <div class="exchange_result1-copy"><!--
				                    	<div class="text-block-110 estCoin">USD</div> -->
				                    </div>
									</div>
									<a href="#" class="result_btn click w-button"
									onClick="sendBTCtoUSDT();"><spring:message
										code="wallet.transfer" /></a>
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
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		var overMargin = new Array(0, 0, 0, 0, 0);
		var usdt = ${walletUSDT};
		var btc = ${walletBTC};
		var xrp = ${walletXRP};
		var trx = ${walletTRX};
		var eth = ${walletETH};
		var direction = 1;
		var positionObj = JSON.parse('${pobj}');
		var exchangeUSDT = true; // USDT로 교환
		var withdraw = 0;
		var cfnum = 5;

		function hideEpop() {
			$("#exchangePop").css("display", "none");
		}
		function changeType() {
			exchangeUSDT = !exchangeUSDT;
			var tempCoin = $("#coin1").val();
			var tempCoin2 = $("#coin2").val();
			var opNU = '<option class="isUSDT" value="BTC">BTC</option> <option class="isUSDT" value="XRP">XRP</option> <option class="isUSDT" value="TRX">TRX</option> <option class="isUSDT" value="ETH">ETH</option>';
			var opU = '<option class="notUSDT" value="USDT"> <spring:message code="wallet.spotWalletUSDT" /> </option>';
			if (exchangeUSDT) {
				$("#coin1").html(opNU);
				$("#coin2").html(opU);
			} else { // USDT를 다른 코인으로 교환
				$("#coin2").html(opNU);
				$("#coin1").html(opU);
			}
			$('#coin1').val(tempCoin2);
			$('#coin2').val(tempCoin);
			change();
		}

		function change() { //다이렉션 삽입 // 중간버튼 누르면 서로 교환
			var cfusdt = toFixedDown(usdt, cfnum);
			switch ($("#coin1").val()) {
			case 'BTC':
				$("#balance1").html(btc + " BTC");
				$("#balance2").html(cfusdt + " USD");
				setDirection(1);
				break;

			case 'XRP':
				$("#balance1").html(xrp + " XRP");
				$("#balance2").html(cfusdt + " USD");
				setDirection(3);
				break;

			case 'TRX':
				$("#balance1").html(trx + " TRX");
				$("#balance2").html(cfusdt + " USD");
				setDirection(5);
				break;
			case 'ETH':
				$("#balance1").html(eth + " ETH");
				$("#balance2").html(cfusdt + " USD");
				setDirection(7);
				break;

			case 'USDT':
				$("#balance1").html(cfusdt + " USD");

				var coinBalance = 0;
				switch ($("#coin2").val()) {
				case 'BTC':
					coinBalance = btc;
					setDirection(0);
					break;
				case 'XRP':
					coinBalance = xrp;
					setDirection(2);
					break;
				case 'TRX':
					coinBalance = trx;
					setDirection(4);
					break;
				case 'ETH':
					coinBalance = eth;
					setDirection(6);
					break;
				}
				$("#balance2").html(
						toFixedDown(coinBalance, cfnum) + " " + $("#coin2").val());
				break;
			}
			$("#conCoin").html($("#coin1").val());
			$(".estCoin").html($("#coin2").val());
			$("#conversion").attr("placeholder", $("#coin1").val());

			$("#coinMarketPrice").html(
					coinCheck() + " "
							+ "<spring:message code='wallet.marketPrice'/>");
			document.getElementById('conversion').value = null;
			document.getElementById('estimated').value = 0;
			$('#estimatedTxt').html(0);

		}
		function setDirection(num) {
			direction = num;
			$("#direction").val(num);
		}

		function max() {
			if (exchangeUSDT)
				$("#conversion").val(withdraw);
			else
				$("#conversion").val(usdt);
			calculate((document.getElementById('conversion').value).toString());
		}
		change();

		function numCheck(self) {
			let
			num = $(self);
			let
			re = /[^0-9]/gi;
			num.val(num.val().replace(re, ""));
		}

		function isNumber(v) {
			var regex = /^\d*\.?\d*$/;
			return regex.test(v);
		}

		var calculate = function(v) {
			if (v === '') {
				document.getElementById('estimated').textContent = 0;
				$('#estimatedTxt').html(0);
				return;
			}
			if (!isNumber(v)) {
				alert("<spring:message code='pop.transfer.inputCurrentExchange'/>");
				document.getElementById('conversion').value = '';
				document.getElementById('estimated').textContent = 0;
				$('#estimatedTxt').html(0);
				$("#conversion").focus();
				return;
			}
			var mprice = document.getElementById('marketprice').textContent;
			var calc = 0;

			switch ($("#coin1").val()) {
			case 'BTC':
			case 'ETH':
			case 'XRP':
			case 'TRX':
				calc = parseFloat(toFixedDown((v * mprice), cfnum));
				break;
			case 'USDT':
				calc = parseFloat(toFixedDown((v / mprice), cfnum));
				break;
			}
			document.getElementById('estimated').textContent = calc;
			$('#estimatedTxt').html(toFixedDown(calc, cfnum));
		}
		var cv = document.getElementById("conversion");
		cv.addEventListener("keyup", calculate(cv.value), false);

		function coinCheck() {
			if ($("#coin1").val() == 'BTC' || $("#coin2").val() == 'BTC') {
				return 'BTC';
			} else if ($("#coin1").val() == 'XRP' || $("#coin2").val() == 'XRP') {
				return 'XRP';
			} else if ($("#coin1").val() == 'TRX' || $("#coin2").val() == 'TRX') {
				return 'TRX';
			} else if ($("#coin1").val() == 'ETH' || $("#coin2").val() == 'ETH') {
				return 'ETH';
			}
		}

		function isAmount(asValue) {
			var regExp = /^[0-9]+(.[0-9]+)?$/;
			return regExp.test(asValue); // 형식에 맞는 경우 true 리턴	
		}
		function sendBTCtoUSDT() {
			var conversion = parseFloat(toFixedDown(document.getElementById('conversion').value, cfnum));
			var amount = parseFloat(document.getElementById('estimated').textContent);
			var coin = document.getElementById('coin1').textContent;
			if (conversion == null || conversion == '') {
				alert("<spring:message code='pop.transfer.inputExchange'/>");
				$("#conversion").focus();
				return false;
			}
			var minExchange = 0.001;
			if (coinCheck() == 'BTC') {
				minExchange = 0.00001;
			}
			if (conversion < minExchange) {
				alert("<spring:message code='pop.transfer.mininumExchange_1'/> "
						+ minExchange
						+ "<spring:message code='pop.transfer.mininumExchange_2'/>")
				$("#conversion").focus();
				return false;
			}
			if (!isAmount(conversion)) {
				alert("<spring:message code='pop.transfer.inputCurrentExchange'/>")
				$("#conversion").focus();
				return false;
			}
			if (!restrictAmount($('#conversion').val())) {
	 			alert("<spring:message code='pop.wallet.amountError'/>");
	 			return;
	 		}
			if (conversion > $("#balance1").html().split(' ')[2]) {
				alert("<spring:message code='wallet.morethen'/>")
				$("#conversion").focus();
				return false;
			}

			if (exchangeUSDT && conversion > parseFloat(withdraw)) {
				alert("<spring:message code='wallet.morethen'/>")
				$("#conversion").focus();
				return false;
			}

			//var data = $("#exchangeform").serialize();
			var data = {direction :$('#direction').val(), conversion:conversion};
			$.ajax({
				type : 'post',
				data : data,
				url : '/global/user/exchangeProcess.do',
				success : function(data) {
					alert(data.msg);
					if (data.result == "success") {
						usdt = data.walletUSDT;
						btc = data.walletBTC;
						xrp = data.walletXRP;
						trx = data.walletTRX;
						eth = data.walletETH;
						change();
						$("#exchangePop").css("display", "flex");
					}
				}
			})
		}

		function getWithdrawWallet2(wallet, coin, tmpvol) {
			var obj = new Object();
			for (var i = 0; i < positionObj.plist.length; i++) {
				if (positionObj.plist[i].symbol == coin) {
					var sise = longSise[getSymbol(positionObj.plist[i].symbol)];
					wallet = wallet
							- (positionObj.plist[i].fee + positionObj.plist[i].margin);

					var profit = (sise * positionObj.plist[i].buyQuantity)
							- tmpvol;
					if (positionObj.plist[i].position == 'short')
						profit = -profit;
					profit = profit / sise;

					if (positionObj.plist[i].marginType == "cross") {
						if (profit < 0
								&& Math.abs(profit) > positionObj.plist[i].fee) {
							overMargin[i] = profit + positionObj.plist[i].fee;
							wallet += overMargin[i];
						}
					}
				}
			}
			for (var i = 0; i < positionObj.olist.length; i++) {
				if (positionObj.olist[i].symbol == coin) {
					wallet -= positionObj.olist[i].paidVolume;
				}
			}
			if (wallet < 0)
				wallet = 0;
			return wallet;
		}

		function getWithdrawWallet(wallet, coin) {
			var obj = new Object();
			for (var i = 0; i < positionObj.plist.length; i++) {
				if (positionObj.plist[i].symbol == coin) {
					var sise = longSise[getSymbol(positionObj.plist[i].symbol)];
					wallet = wallet
							- (positionObj.plist[i].fee + positionObj.plist[i].margin);

					var profit = (sise * positionObj.plist[i].buyQuantity)
							- positionObj.plist[i].contractVolume;
					if (positionObj.plist[i].position == 'short')
						profit = -profit;
					profit = profit / sise;

					if (positionObj.plist[i].marginType == "cross") {
						if (profit < 0
								&& Math.abs(profit) > positionObj.plist[i].fee) {
							overMargin[i] = profit + positionObj.plist[i].fee;
							wallet += overMargin[i];
						}
					}
				}
			}
			for (var i = 0; i < positionObj.olist.length; i++) {
				if (positionObj.olist[i].symbol == coin) {
					wallet -= positionObj.olist[i].paidVolume;
				}
			}
			if (wallet < 0)
				wallet = 0;
			return wallet;
		}

		var coinArr = new Array('BTCUSDT', 'ETHUSDT', 'XRPUSDT', 'TRXUSDT'); // 코인 변수명 
		var fPrice = new Object;
		var longSise = new Array(0, 0, 0, 0, 0); // 코인별 매수 시세 

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
				calculateSise();
			}
		}

		function getSymbol(symbol) {
			switch (symbol) {
			case "BTCUSDT":
			case "BTC":
			case "BTCUSD":
				return 0;
			case "ETHUSDT":
			case "ETH":
			case "ETHUSD":
				return 1;
			case "XRPUSDT":
			case "XRP":
			case "XRPUSD":
				return 2;
			case "TRXUSDT":
			case "TRX":
			case "TRXUSD":
				return 3;
			case "DOGEUSDT":
			case "DOGE":
			case "DOGEUSD":
				return 4;
			default:
				break;
			}
		}

		function calculateSise() {
			var nowCoin = coinCheck();
			var wallet = 0;
			switch (nowCoin) {
			case 'BTC':
				wallet = btc;
				$("#marketprice").html(longSise[0]);
				break;
			case 'ETH':
				wallet = eth;
				$("#marketprice").html(longSise[1]);
				break;
			case 'XRP':
				wallet = xrp;
				$("#marketprice").html(longSise[2]);
				break;
			case 'TRX':
				wallet = trx;
				$("#marketprice").html(longSise[3]);
				break;
			}

			if (exchangeUSDT) {
				withdraw = toFixedDown(getWithdrawWallet(wallet, nowCoin
						+ "USD"), cfnum);
				$("#balance1").html("<spring:message code="wallet.available_1" />: " + withdraw + " " + nowCoin);
			}

			if ($("#conversion").val() != null && longSise[nowCoin] != 0) {
				calculate($("#conversion").val())
			}
			
			var tbtc = Number(btc);
			var tusdt = Number(usdt) / longSise[0];
			var txrp = Number(xrp) * longSise[2] / longSise[0];
			var ttrx = Number(trx) * longSise[3] / longSise[0];
			var future = Number("${user.wallet}") / longSise[0];

			$("#totalBTC").html(toFixedDown((tbtc + tusdt + txrp + ttrx + future), 6));
		}
		window.addEventListener("load", initAPI, false);
	</script>
	<script src="../js/webflow.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
</body>
</html>