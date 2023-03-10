<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html data-wf-page="62b16a1ad874f735cccc57cd" data-wf-site="62b1125ac4d4d60ab9c62f81">
<head>
<meta charset="utf-8">
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
<style>
.asset_coininfo_txt {
	min-width: 150px;
}
@media screen and (max-width: 767px) {
	.depositbtntxt {
		overflow: hidden;
	    white-space: nowrap;
	    text-overflow: ellipsis;
	    display: block;
	}
	.asset_coininfo_txt {
		min-width: 90px;
	}
}
</style>
<script>

	var widx = 0;
	var positionObj = JSON.parse('${pobj}');

	var walletBTC = "${walletBTC}";
	var walletUSDT = "${walletUSDT}";
	var walletXRP = "${walletXRP}";
	var walletTRX = "${walletTRX}";
	var walletETH = "${walletETH}";

	var exchangeRate = 0; // 환율
	var exchangeWallet = 0;

	function setNum(obj) {
		val = obj.value;
		re = /[^0-9]/gi;
		obj.value = val.replace(re, "");
	}

	function fmtNum(num) {
		if (num == null)
			return 0;
		if (num.length <= 3)
			return num;

		var decimalv = "";

		if (num.indexOf(".") != -1) {
			var numarr = num.split(".");
			num = numarr[0];
			decimalv = "." + numarr[1];
		}

		var len, point, str;
		let
		min = "";

		num = num + "";
		if (num.charAt(0) == '-') {
			num = num.substr(1);
			min = "-";
		}

		point = num.length % 3;
		str = num.substring(0, point);
		len = num.length;

		while (point < len) {
			if (str != "")
				str += ",";
			str += num.substring(point, point + 3);
			point += 3;
		}
		return min + str + decimalv;
	}

	function krwStr(val, coin) {

		var result = "";
		switch (coin) {
		case "BTC":
			result = "≈ "
					+ fmtNum(toFixedDown((val * longSise[0] * exchangeRate), 0))
					+ " KRW";
			break;
		case "USDT":
			result = "≈ " + fmtNum(toFixedDown((val * exchangeRate), 0))
					+ " KRW";
			break;
		case "XRP":
			result = "≈ "
					+ fmtNum(toFixedDown((val * longSise[2] * exchangeRate), 0))
					+ " KRW";
			break;
		case "TRX":
			result = "≈ "
					+ fmtNum(toFixedDown((val * longSise[3] * exchangeRate), 0))
					+ " KRW";
			break;
		}
		return result;
	}

</script>
</head>
<body class="body">
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<div class="frame">
		<jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
		<div class="frame2">
			<jsp:include page="../userFrame/walletFrame.jsp"></jsp:include>
			<div class="asset_block">
				<div class="assetbox">
					<div class="assettitle">
						<spring:message code="wallet.property" />
					</div>
					<div class="deposit_warp1">
						<div class="asset_value" style="width:auto;">
							<div class="assettxt1">
								<spring:message code="wallet.assetValue" />
							</div>
							<div class="assettxt2">
								<span id="totalBTC">0</span> BTC<span class="asset_d" id="totalUSD"> = 0$</span>
							</div>
						</div>
					</div>
					<div class="deposit_warp3">
						<div class="asset_subtitle"><spring:message code="wallet.spotWallet"/></div>
						<div class="asset_top">
							<div class="asset_coinsub_top">
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.available" />
								</div>
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.inUse" />
								</div>
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.evaluationValue" />
								</div>
							</div>
						</div>
						<div class="asset_coinsub">
							<div class="asset_coininfoblock">
								<div class="asset_cointitle">
									<img src="../webflow/images2/BTCicon_img_2BTCicon_img.png"
										loading="lazy" alt="" class="coinimg1">
									<div class="asset_coinsub_name">BTC</div>
								</div>
								<div class="asset_coininfo">
									<div class="asset_coininfo_txt" id="btcWithdraw">
										<fmt:formatNumber value="${walletBTC}" pattern="#,###.#####" />
									</div>
									<div class="asset_coininfo_txt" id="btcUsing">0</div>
									<div class="asset_coininfo_txt" id="btcBalance">
										<fmt:formatNumber value="${walletBTC}" pattern="#,###.#####" />
									</div>
								</div>
							</div>
							
						</div>
						<div class="asset_coinsub">
							<div class="asset_coininfoblock">
								<div class="asset_cointitle">
									<img src="../webflow/images/USDTicon45_1USDTicon45.png" loading="lazy" alt=""
										class="coinimg1">
									<div class="asset_coinsub_name">USDT</div>
								</div>
								<div class="asset_coininfo">
									<div class="asset_coininfo_txt" id="usdtWithdraw">
										<fmt:formatNumber value="${walletUSDT}"
											pattern="#,###.##" />
									</div>
									<div class="asset_coininfo_txt" id="usdtUsing">0.00<span class="unit">USDT</span></div>
									<div class="asset_coininfo_txt" id="usdtBalance">
										<fmt:formatNumber value="${walletUSDT}"
											pattern="#,###.##" />
									</div>
								</div>
							</div>
						</div>
						<div class="asset_coinsub">
							<div class="asset_coininfoblock">
								<div class="asset_cointitle">
									<img src="../webflow/images/ETHicon_1ETHicon.png" loading="lazy" alt=""
										class="coinimg1">
									<div class="asset_coinsub_name">ETH</div>
								</div>
								<div class="asset_coininfo">
									<div class="asset_coininfo_txt" id="ethWithdraw">
										<fmt:formatNumber value="${walletETH}" pattern="#,###.#" />
									</div>
									<div class="asset_coininfo_txt" id="ethUsing">0</div>
									<div class="asset_coininfo_txt" id="ethBalance">
										<fmt:formatNumber value="${walletETH}" pattern="#,###.#" />
									</div>
								</div>
							</div>
						</div>
						<div class="asset_coinsub">
							<div class="asset_coininfoblock">
								<div class="asset_cointitle">
									<img src="../webflow/images/TRXicon_1TRXicon.png" loading="lazy" alt=""
										class="coinimg1">
									<div class="asset_coinsub_name">TRX</div>
								</div>
								<div class="asset_coininfo">
									<div class="asset_coininfo_txt" id="trxWithdraw">
										<fmt:formatNumber value="${walletTRX}" pattern="#,###.#" />
									</div>
									<div class="asset_coininfo_txt" id="trxUsing">0</div>
									<div class="asset_coininfo_txt" id="trxBalance">
										<fmt:formatNumber value="${walletTRX}" pattern="#,###.#" />
									</div>
								</div>
							</div>
						</div>
						<div class="asset_coinsub">
							<div class="asset_coininfoblock">
								<div class="asset_cointitle">
									<img src="../webflow/images/XRPicon_1XRPicon.png" loading="lazy" alt=""
										class="coinimg1">
									<div class="asset_coinsub_name">XRP</div>
								</div>
								<div class="asset_coininfo">
									<div class="asset_coininfo_txt" id="xrpWithdraw">
										<fmt:formatNumber value="${walletXRP}" pattern="#,###.#####" />
									</div>
									<div class="asset_coininfo_txt" id="xrpUsing">0</div>
									<div class="asset_coininfo_txt" id="xrpBalance">
										<fmt:formatNumber value="${walletXRP}" pattern="#,###.#####" />
									</div>
								</div>
							</div>
						</div>
						<div class="asset_subtitle"><spring:message code="wallet.futures"/></div>
						<div class="asset_top">
							<div class="asset_coinsub_top">
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.available" />
								</div>
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.inUse" />
								</div>
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.evaluationValue" />
								</div>
							</div>
						</div>
						<div class="asset_coin">
							<div class="myassetvalue">
								<div class="asset_coinsub_name"><spring:message code="wallet.futuresUSDT"/></div>
								<div class="asset_coininfo">
									<div class="asset_coininfo_txt" id="avaWithdraw">
										<fmt:formatNumber value="${wallet}" pattern="#,###.#####" />
									</div>
									<div class="asset_coininfo_txt" id="avaUsing">0</div>
									<div class="asset_coininfo_txt">
										<fmt:formatNumber value="${wallet}" pattern="#,###.#####" /><span class="unit">USDT</span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
	</div>
	<script
		src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6180a71858466749aa0b95bc"
		type="text/javascript"
		integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
		crossorigin="anonymous"></script>
		<script src="../js/webflow2.js" type="text/javascript"></script>
	<script>
	var cfnum = 5;
	function coinPosUpdate() {
		var futureWallet = "${wallet}";

		var futuresWithdrawWallet = parseFloat(getWithdrawWallet(
				futureWallet, "futures"));
		$("#avaWithdraw").html(fmtNum(toFixedDown(futuresWithdrawWallet, 2))+'<span class="unit">USDT</span>');
		$("#avaUsing").html(fmtNum(toFixedDown(getMargin("futures"), 2))+'<span class="unit">USDT</span>');

		var btcWithdrawWallet = parseFloat(getWithdrawWallet(walletBTC, "BTCUSD"));
		$("#btcWithdraw").html(fmtNum(toFixedDown(btcWithdrawWallet, cfnum)) +'<span class="unit">BTC</span>');
		$("#btcUsing").html(fmtNum(toFixedDown(getMargin("BTCUSD"), cfnum)) +'<span class="unit">BTC</span>');

		var ethWithdrawWallet = parseFloat(getWithdrawWallet(walletETH, "ETHUSD"));
		$("#ethWithdraw").html(fmtNum(toFixedDown(ethWithdrawWallet, cfnum)) +'<span class="unit">ETH</span>');
		$("#ethUsing").html(fmtNum(toFixedDown(getMargin("ETHUSD"), cfnum)) +'<span class="unit">ETH</span>');

		var xrpWithdrawWallet = parseFloat(getWithdrawWallet(walletXRP, "XRPUSD"));
		$("#xrpWithdraw").html(fmtNum(toFixedDown(xrpWithdrawWallet, 1)) +'<span class="unit">XRP</span>');
		$("#xrpUsing").html(fmtNum(toFixedDown(getMargin("XRPUSD"), 1)) +'<span class="unit">XRP</span>');

		var trxWithdrawWallet = parseFloat(getWithdrawWallet(walletTRX, "TRXUSD"));
		$("#trxWithdraw").html(fmtNum(toFixedDown(trxWithdrawWallet, 1)) +'<span class="unit">TRX</span>');
		$("#trxUsing").html(fmtNum(toFixedDown(getMargin("TRXUSD"), 1)) +'<span class="unit">TRX</span>');
		
		var usdtWithdrawWallet = parseFloat(getWithdrawWallet(walletUSDT, "USDT"));
		$("#usdtWithdraw").html(fmtNum(toFixedDown(usdtWithdrawWallet, 1)) +'<span class="unit">USDT</span>');
		$("#usdtUsing").html(fmtNum(toFixedDown(getMargin("USDT"), 1)) +'<span class="unit">USDT</span>');
		
		
	}

	function getWithdrawWallet(wallet, coin) {
		var obj = new Object();
		switch (coin) {
		case "futures":
			for (var i = 0; i < positionObj.plist.length; i++) {
				if (!isInverse(positionObj.plist[i].symbol)) {
					var sise = longSise[getSymbol(positionObj.plist[i].symbol)];
					wallet = wallet
							- (positionObj.plist[i].fee + positionObj.plist[i].margin);

					var profit = (sise * positionObj.plist[i].buyQuantity)
							- positionObj.plist[i].contractVolume;
					if (positionObj.plist[i].position == 'short')
						profit = -profit;
					if (positionObj.plist[i].marginType == "cross") {
						if (profit < 0
								&& Math.abs(profit) > positionObj.plist[i].margin) {
							profit += positionObj.plist[i].margin;
							wallet -= profit;
						}
					}
				}
			}
			for (var i = 0; i < positionObj.olist.length; i++) {
				if (!isInverse(positionObj.olist[i].symbol)) {
					wallet -= positionObj.olist[i].paidVolume;
				}
			}
			break;
		default:
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
								&& Math.abs(profit) > positionObj.plist[i].margin) {
							profit += positionObj.plist[i].margin;
							wallet -= profit;
						}
					}
				}
			}
			for (var i = 0; i < positionObj.olist.length; i++) {
				if (positionObj.olist[i].symbol == coin) {
					wallet -= positionObj.olist[i].paidVolume;
				}
			}
			for (var i = 0; i < positionObj.spotolist.length; i++) {
				if (positionObj.spotolist[i].symbol == coin || coin == "USDT") {
					if(coin == "USDT" && positionObj.spotolist[i].position == "long")
						wallet -= positionObj.spotolist[i].paidVolume;
					else if(coin != "USDT" && positionObj.spotolist[i].position == "short")
						wallet -= positionObj.spotolist[i].buyQuantity;
				}
			} 
		}
		if (wallet < 0)
			wallet = 0;
		return wallet;
	}

	function getMargin(coin) {
		var margin = 0;
		switch (coin) {
		case "futures":
			for (var i = 0; i < positionObj.plist.length; i++) {
				if (!isInverse(positionObj.plist[i].symbol)) {
					margin += positionObj.plist[i].margin;
					margin += positionObj.plist[i].fee;
				}
			}
			break;
		default:
			for (var i = 0; i < positionObj.plist.length; i++) {
				if (positionObj.plist[i].symbol == coin) {
					margin += positionObj.plist[i].margin;
					margin += positionObj.plist[i].fee;
				}
			}
			for (var i = 0; i < positionObj.spotolist.length; i++) {
				if (positionObj.spotolist[i].symbol == coin || coin == "USDT") {
					if(coin == "USDT" && positionObj.spotolist[i].position == "long")
						margin += positionObj.spotolist[i].paidVolume;
					else if(coin != "USDT" && positionObj.spotolist[i].position == "short")
						margin += positionObj.spotolist[i].buyQuantity;
				}
			}
		}
		return margin;
	}

	function isInverse(symbol) {
		if (symbol.charAt(symbol.length - 1) != 'T')
			return true;
		return false;
	}

	function posWalletUpdate() {
		coinPosUpdate();
		updateTotalBTC();
	}

	function updateTotalBTC() {

		var btc = Number(walletBTC);
		var usdt = Number(walletUSDT) / longSise[0];
		var xrp = Number(walletXRP * longSise[2]) / longSise[0];
		var trx = Number(walletTRX * longSise[3]) / longSise[0];
		var future = Number("${wallet}") / longSise[0];
		let total = Number(btc + usdt + xrp + trx + future);
		$("#totalBTC").html(
				toFixedDown(total, 6));
		$("#totalUSD").html(" = "+
				fmtNum(toFixedDown(total*longSise[0], 2))+"$");
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
			posWalletUpdate();
		}
	}
	window.addEventListener("load", initAPI, false);
</script>
</body>
</html>