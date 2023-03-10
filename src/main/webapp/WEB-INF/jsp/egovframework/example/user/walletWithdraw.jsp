<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html data-wf-page="61838860e4fa168ddefcc791"
	data-wf-site="6180a71858466749aa0b95bc">
<style>
.wcoin_select {
	display: none  
}

@media screen and (max-width: 767px) {
	.depositbtntxt {
		overflow: hidden;
	    white-space: nowrap;
	    text-overflow: ellipsis;
	    display: block;
	}
	
	.asset_warn.xrp {
		margin-top: 14vw;
	}
}
.asset_coininfoblock{
	cursor:pointer;
}
</style>
<head>
<meta charset="utf-8">
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
<script>
	var overMargin = new Array(0, 0, 0, 0, 0);
	var longSise = new Array(0, 0, 0, 0, 0); // 코인별 매수 시세 
	let withdrawW = new Array(0, 0, 0, 0, 0);
	var widx = 0;
	var selectedCoin = "BTC";
	var emailconfirm = "${user.emailconfirm}";
	var feeBTC = "${feeList[0].fee}";
	var feeUSDT = "${feeList[1].fee}";
	var feeXRP = "${feeList[2].fee}";
	var feeTRX = "${feeList[3].fee}";
	var feeETH = "${feeList[4].fee}";
	var minWithdrawBTC = 0.001;
	var minWithdrawUSDT = 20;
	var minWithdrawXRP = 20;
	var minWithdrawTRX = 200;
	var minWithdrawETH = 0.001;
	var exchangeRate = 0;

	var positionObj = JSON.parse('${pobj}');

	var walletBTC = "${walletBTC}";
	var walletUSDT = "${walletUSDT}";
	var walletXRP = "${walletXRP}";
	var walletTRX = "${walletTRX}";
	var walletETH = "${walletETH}";
	var sending = false;

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

	function plusFee(coin, input, fee) {

		var wallet = 0;
		var min = 0;
		var fee = 0;
		switch (coin) {
		case "BTC":
			wallet = walletBTC;
			min = minWithdrawBTC;
			fee = feeBTC;
			break;

		case "USDT":
			wallet = walletUSDT;
			min = minWithdrawUSDT;
			fee = feeUSDT;
			break;

		case "XRP":
			wallet = walletXRP;
			min = minWithdrawXRP;
			fee = feeXRP;
			break;

		case "TRX":
			wallet = walletTRX;
			min = minWithdrawTRX;
			fee = feeTRX;
			break;
		case "ETH":
			wallet = walletETH;
			min = minWithdrawETH;
			fee = feeETH;
			break;
		}
		if (input < min) {
			alert("<spring:message code='pop.transfer.mininumWithdraw_1'/> "
					+ min
					+ " "
					+ coin
					+ " <spring:message code='pop.transfer.mininumExchange_2'/>");
			return -2;
		}

		var val = Number(input) + Number(fee);
		if (val > wallet) {
			alert("<spring:message code='pop.transfer.notBalance'/>");
			return -1;
		}

		return input;
	}
	
	function isNumber(v) {
		var regex = /^\d*\.?\d*$/;
		return regex.test(v);
	}
	
	function isAddress(v) {
		var regExp = /[a-zA-Z0-9]/;
		return regExp.test(v);
	}

	function sendEmail() {
// 		var ema = false;
// 		tmpEmail = "${user.email}";
// 		if (tmpEmail == "") {
// 			alert("<spring:message code='join.emailconfirm'/>");
// 			location.href = "/wesell/user/myInfo.do";
// 		}
		if (sending)
			return;
		
		if(selectedCoin == "USDT"){
			let address = $("#USDTinAddress").val();
			if(address.startsWith("0x")){
				alert("<spring:message code='wallet.checkNetwork'/>(TRC-20)");
				return;
			}
// 			else if(address.startsWith("T")){
// 			}
		}
		
		var xtag = $("#inputXrpTag").val();
		if(selectedCoin === 'XRP') {
			if(xtag !== '' && !isNumber(xtag)) {
				$("#inputXrpTag").focus();
				return;
			}
			if (xtag !== '' &&  ($("#inputXrpTag").val()).length > 20) {
				alert("<spring:message code='wallet.tagOver'/>");
				return;
			}	
		}

		if (($("#" + selectedCoin + "inAddress").val()).length > 100) {
			alert("<spring:message code='wallet.addressOver'/>");
			return;
		}

		if ($("#" + selectedCoin + "inAddress").val() == ""
				|| $("#" + selectedCoin + "inAddress").val() == null) {
			alert("<spring:message code='pop.wallet.inputWalletAddress'/>");
			return;
		}

		if ($("#" + selectedCoin + "inStock").val() == ""
				|| $("#" + selectedCoin + "inStock").val() == null) {
			alert("<spring:message code='wallet.inputStockExchange'/>");
			return;
		}
		
		var add = $("#" + selectedCoin + "inAddress").val();
		if(!isAddress(add)) {
			$("#" + selectedCoin + "inAddress").focus();
			alert("<spring:message code='pop.wallet.inputWalletAddress'/>");
			return;
		}
		
		var amount = plusFee(selectedCoin, $("#" + selectedCoin + "inAmount").val());

		amount = toFixedDown(Number(amount), cfnum);
		
		if ($("#" + selectedCoin + "inAmount").val() == ""
				|| $("#" + selectedCoin + "inAmount").val() == null || parseFloat(amount) <= 0) {
			alert("<spring:message code='pop.wallet.inputQty'/>");
			return;
		}
		
		var am = $("#" + selectedCoin + "inAmount").val();
		if(!isNumber(am)) {
			$("#" + selectedCoin + "inAmount").focus();
			alert("<spring:message code='pop.wallet.inputQty'/>");
			return;
		}
		
		if (!restrictAmount($("#" + selectedCoin + "inAmount").val())) {
 			alert("<spring:message code='pop.wallet.amountError'/>");
 			return;
 		}

		if (selectedCoin == 'XRP' && parseInt($("#inputXrpTag").val()) < 0) {
			$("#inputXrpTag").focus();
			return;
		}
		if (selectedCoin === 'XRP') {
			if ($('#inputXrpTag').val() === '' || $('#inputXrpTag').val() === null) {
				$("#inputXrpTag").focus();
				return;	
			}
		}
		
// 		if (emailconfirm == 0) {
// 			alert("<spring:message code='pop.wallet.emailRequired'/>");
// 			location.href = "/wesell/user/myInfo.do";
// 			return;
// 		}

		$("#withdrawAddress").val($("#" + selectedCoin + "inAddress").val());

		if (amount <= 0) {
			return;
		}

		$("#withdrawAmount").val(amount);
		$("#withCoin").val(selectedCoin);
		sending = true;
// 		var vurl = '/wesell/user/withdrawEmail.do';
		var vurl = '/wesell/user/withdrawPhone.do';
		$.ajax({
			type : 'post',
			data : {
				'email' : "${user.email}",
				'address' : $("#withdrawAddress").val(),
				'amount' : $("#withdrawAmount").val(),
				'coin' : $("#withCoin").val(),
				'xrpTag' : $("#inputXrpTag").val(),
				'stock' : $("#"+selectedCoin+"inStock").val(),
			},
			dataType : 'json',
			url : vurl,
			success : function(data) {
				sending = false;
				alert(data.msg);
				if (data.result != "fail") {
					switch (selectedCoin) {

					case "BTC":
						$(".coinVal").html(
								fmtNum(toFixedDown(
										(walletBTC - data.coinMinus), 2)));
						walletBTC = Number(walletBTC -= data.coinMinus);
						break;
					case "USDT":
						$(".coinVal").html(
								fmtNum(toFixedDown(
										(walletUSDT - data.coinMinus), 2)));
						walletUSDT = Number(walletUSDT -= data.coinMinus);
						break;
					case "XRP":
						$(".coinVal").html(
								fmtNum(toFixedDown(
										(walletXRP - data.coinMinus), 2)));
						walletXRP = Number(walletXRP -= data.coinMinus);
						break;
					case "TRX":
						$(".coinVal").html(
								fmtNum(toFixedDown(
										(walletTRX - data.coinMinus), 2)));
						walletTRX = Number(walletTRX -= data.coinMinus);
						break;
					case "ETH":
						$(".coinVal").html(
								fmtNum(toFixedDown(
										(walletETH - data.coinMinus), 2)));
						walletETH = Number(walletETH -= data.coinMinus);
						break;
					}

					$("#codePop").css("display", "flex");
					widx = data.widx;
				}

			},

			error : function(e) {
				sending = false;
				console.log('ajax error ' + JSON.stringify(e));
			}
		})
	}

	function minusZero(wallet, fee, fix) {
		var val = wallet - fee;
		if (val < 0) {
			val = 0;
		}
		return toFixedDown(val,fix);
	}

	function krwStr(val, coin) {

		var result = "";
		switch (coin) {
		case "BTC":
			result = "≈ "
					+ fmtNum((val * longSise[0] * exchangeRate).toFixed(0))
					+ " KRW";
			break;
		case "USDT":
			result = "≈ " + fmtNum((val * exchangeRate).toFixedDown(0))
					+ " KRW";
			break;
		case "XRP":
			result = "≈ "
					+ fmtNum((val * longSise[2] * exchangeRate).toFixed(0))
					+ " KRW";
			break;
		case "TRX":
			result = "≈ "
					+ fmtNum((val * longSise[3] * exchangeRate).toFixed(0))
					+ " KRW";
			break;
		}
		return result;
	}

	function max() {
		var coinNum = getSymbol(selectedCoin);
		
		switch (selectedCoin) {
		case "BTC":
			$("#" + selectedCoin + "inAmount").val(
					minusZero(withdrawW[coinNum], feeBTC,5));
			break;
		case "USDT":
			$("#" + selectedCoin + "inAmount").val(
					minusZero(withdrawW[coinNum], feeUSDT),5);
			break;
		case "XRP":
			$("#" + selectedCoin + "inAmount").val(
					minusZero(withdrawW[coinNum], feeXRP,1));
			break;
		case "TRX":
			$("#" + selectedCoin + "inAmount").val(
					minusZero(withdrawW[coinNum], feeTRX,0));
			break;
		case "ETH":
			$("#" + selectedCoin + "inAmount").val(
					minusZero(withdrawW[coinNum], feeETH,5));
			break;
		}
	}

	function exchange(num) {
		return num * exchangeRate;
	}
</script>
</head>
<body class="body">
	<form>
		<input type="hidden" name="withdrawAddress" id="withdrawAddress">
		<input type="hidden" name="withdrawAmount" id="withdrawAmount">
		<input type="hidden" name="withCoin" id="withCoin">
	</form>
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
						<div class="asset_coinsub">
							<div class="asset_coinsub_top btc wcoin_select">
								<div class="asset_coinsub_toptxt"> <spring:message code="wallet.available" /> </div>
								<div class="asset_coinsub_toptxt"> <spring:message code="wallet.inUse" /> </div>
								<div class="asset_coinsub_toptxt"> BTC <spring:message code="wallet.evaluationValue" /> </div>
							</div>
							<div class="asset_coininfoblock"
								onclick="coinToggle(this, 'BTC')" slide="on">
								<div class="asset_cointitle">
									<img src="../webflow/images2/BTCicon_img_2BTCicon_img.png" loading="lazy" alt="" class="coinimg1">
									<div class="asset_coinsub_name">BTC</div>
								</div>
								<div class="asset_coininfo">
									<div class="asset_coininfo_txt btcWithdraw">
										<fmt:formatNumber value="${walletBTC}" pattern="#,###.#####" />
									</div>
									<div class="asset_coininfo_txt" id="btcUsing">0</div>
									<div class="asset_coininfo_txt" id="btcBalance">
										<fmt:formatNumber value="${walletBTC}" pattern="#,###.#####" />
									</div>
								</div>
								<div class="depositbtntxt" style="cursor: pointer;">
									<spring:message code="wallet.withdrawal" />
								</div>
							</div>
							<div class="form-block-2 btc wcoin_select">
								<div class="form-2">
									<label class="title2"><spring:message code="wallet.stockExchange" /></label>
									<input type="text" class="text-field-3 w-input" maxlength="100" placeholder="<spring:message code="wallet.inputStockExchange"/>" id="BTCinStock">
									<label for="name" class="title2"><spring:message code="walletWithdraw.address" /></label>
									<input type="text" class="text-field-3 w-input" maxlength="50" placeholder="<spring:message code="walletWithdraw.addresstxt"/>" id="BTCinAddress">
									<label for="email" class="title2"><spring:message code="walletWithdraw.money" /></label>
									<div class="withrawl_qty">
										<input type="text" class="text-field-4 w-input" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" maxlength="20" placeholder="<spring:message code="walletWithdraw.moneytxt"/>" id="BTCinAmount">
										<div class="mawqty">
											<div onClick="max()" style="cursor: pointer">MAX</div>
										</div>
									</div>
									<div class="asset_listbox">
										<div class="text1"> <spring:message code="wallet.available" />:</div>
										<div class="asset_able"> <span class="btcWithdraw">0</span> </div>
										<div class="text1">&nbsp;&nbsp;
											<spring:message code="walletWithdraw.min" />
											: <span id="btcminWithdraw">0.001</span>
										</div>
									</div>
									<div class="asset_listbox">
										<div class="asset_fee">
											<div class="withrawl_feestxt">
												<spring:message code="wallet.fee" />
												: ${feeList[0].fee} BTC
											</div>
										</div>
									</div>
									<input type="button" onclick="sendEmail()" value="<spring:message code='support.submit'/>" data-wait="Please wait..." class="submit-button w-button">
								</div>
							</div>
							<div class="asset_warn btc wcoin_select">
								<div class="asset_warntxt">
									<span class="warn_title"> <spring:message code="walletWithdraw.notice" /><br></span>
									<spring:message code="walletWithdraw.notice2" />
									<br> 
									<span class="warn"><spring:message code="walletWithdraw.notice3" /><br> </span>
									<spring:message code="walletWithdraw.notice4" />
									<br>
									<spring:message code="walletWithdraw.notice5" />
								</div>
							</div>
						</div>
						<div class="asset_coinsub">
							<div class="asset_coinsub_top usdt all wcoin_select">
								<div class="asset_coinsub_toptxt"> <spring:message code="wallet.available" /> </div>
								<div class="asset_coinsub_toptxt"> <spring:message code="wallet.inUse" /> </div>
								<div class="asset_coinsub_toptxt"> USDT <spring:message code="wallet.evaluationValue" /> </div>
							</div>
							<div class="asset_coininfoblock" onclick="coinToggle(this, 'USDT')" slide="off">
								<div class="asset_cointitle">
									<img src="../webflow/images/USDTicon45_1USDTicon45.png" loading="lazy" alt="" class="coinimg1">
									<div class="asset_coinsub_name">USDT</div>
								</div>
								<div class="asset_coininfo">
									<div class="asset_coininfo_txt usdtWithdraw">
										<fmt:formatNumber value="${walletUSDT}" pattern="#,###.#####" />
									</div>
									<div class="asset_coininfo_txt" id="usdtUsing">0.00 USDT</div>
									<div class="asset_coininfo_txt" id="usdtBalance">
										<fmt:formatNumber value="${walletUSDT}" pattern="#,###.#####" />
									</div>
								</div>
								<div class="depositbtntxt" style="cursor: pointer;">
									<spring:message code="wallet.withdrawal"/>
								</div>
							</div>
							<div class="form-block-2 usdt all wcoin_select">
								<div class="form-2">
									<div class="trc_box" style="cursor: pointer;">
										<div class="trc_txt">TRC 20</div>
										<img src="/wesell/webflow/images2/check_icon-2_1check_icon-2.png" loading="lazy" alt="" class="trc_img">
									</div>
									<label class="title2"><spring:message code="wallet.stockExchange" /></label>
									<input type="text" class="text-field-3 w-input" maxlength="100" placeholder="<spring:message code="wallet.inputStockExchange"/>" id="USDTinStock">
									<label for="name-6" class="title2"><spring:message code="walletWithdraw.address" /></label>
									<input type="text" class="text-field-3 w-input" maxlength="100" name="name-6" placeholder="<spring:message code="walletWithdraw.addresstxt"/>" id="USDTinAddress">
									<label for="email-6" class="title2"><spring:message code="walletWithdraw.money"/></label>
									<div class="withrawl_qty">
										<input type="text" class="text-field-4 w-input" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" maxlength="256" name="email-6" placeholder="<spring:message code="walletWithdraw.moneytxt"/>" id="USDTinAmount">
										<div class="mawqty">
											<div onClick="max()" style="cursor: pointer">MAX</div>
										</div>
									</div>
									<div class="assetlistbox2">
										<div class="asset_able" style="line-height:3vh">
											<spring:message code="wallet.available" /> : <span class="usdtWithdraw">${walletUSDT}</span>
											&nbsp;&nbsp;
											<spring:message code="walletWithdraw.min" />
											: <span id="usdtminWithdraw">20</span>
										</div>
									</div>
									<div class="assetlistbox2">
										<div class="asset_fee">
											<div class="text1"><spring:message code="wallet.fee" /> : ${feeList[1].fee} USDT</div>
										</div>
									</div>
									<input type="button" onclick="sendEmail()" value="<spring:message code='support.submit'/>" class="submit-button w-button">
								</div>
							</div>
							<div class="asset_warn usdt all wcoin_select">
								<div class="asset_warntxt">
									<span class="warn_title"> <spring:message code="walletWithdraw.notice" /><br></span>
									<spring:message code="walletWithdraw.notice2" />
									<br> 
									<span class="warn"><spring:message code="walletWithdraw.notice3" /><br> </span>
									<spring:message code="walletWithdraw.notice4" />
									<br>
									<spring:message code="walletWithdraw.notice5" />
								</div>
							</div>
						</div>
						<div class="asset_coinsub">
							<div class="asset_coinsub_top eth all wcoin_select">
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.available" />
								</div>
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.inUse" />
								</div>
								<div class="asset_coinsub_toptxt">
									ETH
									<spring:message code="wallet.evaluationValue" />
								</div>
							</div>
							<div class="asset_coininfoblock" onclick="coinToggle(this, 'ETH')" slide="off">
								<div class="asset_cointitle">
									<img src="../webflow/images/ETHicon_1ETHicon.png" loading="lazy" alt="" class="coinimg1">
									<div class="asset_coinsub_name">ETH</div>
								</div>
								<div class="asset_coininfo">
									<div class="asset_coininfo_txt ethWithdraw">
										<fmt:formatNumber value="${walletETH}" pattern="#,###.#####" />
									</div>
									<div class="asset_coininfo_txt" id="ethUsing">0</div>
									<div class="asset_coininfo_txt" id="ethBalance">
										<fmt:formatNumber value="${walletETH}" pattern="#,###.#####" />
									</div>
								</div>
								<div class="depositbtntxt" style="cursor: pointer;">
									<spring:message code="wallet.withdrawal" />
								</div>
							</div>
							<div class="form-block-2 eth all wcoin_select">
								<div class="form-2">
									<div class="trc_box" style="cursor: pointer;">
										<div class="trc_txt">ERC 20</div>
										<img src="/wesell/webflow/images2/check_icon-2_1check_icon-2.png" loading="lazy" alt="" class="trc_img">
									</div>
									<label class="title2"><spring:message code="wallet.stockExchange" /></label>
									<input type="text" class="text-field-3 w-input" maxlength="100" placeholder="<spring:message code="wallet.inputStockExchange"/>" id="ETHinStock">
									<label for="name-5" class="title2"><spring:message code="walletWithdraw.address" /></label>
									<input type="text" class="text-field-3 w-input" maxlength="50" name="name-5" placeholder="<spring:message code="walletWithdraw.addresstxt"/>" id="ETHinAddress">
									<label for="email-5" class="title2"><spring:message code="walletWithdraw.money"/></label>
									<div class="withrawl_qty">
										<input type="text" class="text-field-4 w-input" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" maxlength="20" name="email-5" placeholder="<spring:message code="walletWithdraw.moneytxt"/>" id="ETHinAmount">
										<div class="mawqty">
											<div onClick="max()" style="cursor: pointer">MAX</div>
										</div>
									</div>
									<div class="assetlistbox2">
										<div class="asset_able" style="line-height:3vh">
										<spring:message code="wallet.available" /> :
											<span class="ethWithdraw">0</span>&nbsp;&nbsp;
											<spring:message code="walletWithdraw.min" />
											: <span id="ethminWithdraw">0.001</span>
										</div>
									</div>
									<div class="assetlistbox2">
										<div class="asset_fee">
											<div class="text1">
												<spring:message code="wallet.fee" />
												: ${feeList[4].fee} ETH
											</div>
										</div>
									</div>
									<input type="button" onclick="sendEmail()" value="<spring:message code='support.submit'/>" data-wait="Please wait..." class="submit-button w-button">
								</div>
							</div>
							<div class="asset_warn eth all wcoin_select">
								<div class="asset_warntxt">
									<span class="warn_title"> <spring:message code="walletWithdraw.notice" /><br></span>
									<spring:message code="walletWithdraw.notice2" />
									<br> 
									<span class="warn"><spring:message code="walletWithdraw.notice3" /><br> </span>
									<spring:message code="walletWithdraw.notice4" />
									<br>
									<spring:message code="walletWithdraw.notice5" />
								</div>
							</div>
						</div>
						<div class="asset_coinsub">
							<div class="asset_coinsub_top trx all wcoin_select">
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.available" />
								</div>
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.inUse" />
								</div>
								<div class="asset_coinsub_toptxt"> TRX <spring:message code="wallet.evaluationValue" /> </div>
							</div>
							<div class="asset_coininfoblock"
								onclick="coinToggle(this, 'TRX')" slide="off">
								<div class="asset_cointitle">
									<img src="../webflow/images/TRXicon_1TRXicon.png" loading="lazy" alt="" class="coinimg1">
									<div class="asset_coinsub_name">TRX</div>
								</div>
								<div class="asset_coininfo">
									<div class="asset_coininfo_txt trxWithdraw">
										<fmt:formatNumber value="${walletTRX}" pattern="#,###.#####" />
									</div>
									<div class="asset_coininfo_txt" id="trxUsing">0</div>
									<div class="asset_coininfo_txt" id="trxBalance">
										<fmt:formatNumber value="${walletTRX}" pattern="#,###.#####" />
									</div>
								</div>
								<div class="depositbtntxt" style="cursor: pointer;">
									<spring:message code="wallet.withdrawal" />
								</div>
							</div>
							<div class="form-block-2 trx aii wcoin_select" style="display:none;">
								<div class="form-2">
									<div class="trc_box" style="cursor: pointer;">
										<div class="trc_txt">TRC 20</div>
										<img src="/wesell/webflow/images2/check_icon-2_1check_icon-2.png"
											loading="lazy" alt="" class="trc_img">
									</div>
									<label class="title2"><spring:message code="wallet.stockExchange" /></label>
									<input type="text" class="text-field-3 w-input" maxlength="100" placeholder="<spring:message code="wallet.inputStockExchange"/>" id="TRXinStock">
									<label for="name-4" class="title2"><spring:message code="walletWithdraw.address" /></label>
									<input type="text" class="text-field-3 w-input" maxlength="256" name="name-4" data-name="Name 4" placeholder="<spring:message code="walletWithdraw.addresstxt"/>" id="TRXinAddress">
									<label for="email-4" class="title2"><spring:message code="walletWithdraw.money" /></label>
									<div class="withrawl_qty">
										<input type="text" class="text-field-4 w-input" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" maxlength="256" name="email-4" placeholder="<spring:message code="walletWithdraw.moneytxt"/>" id="TRXinAmount">
										<div class="mawqty">
											<div onClick="max()" style="cursor: pointer">MAX</div>
										</div>
									</div>
									<div class="assetlistbox2">
										<div class="asset_able" style="line-height:3vh">
											<spring:message code="wallet.available" /> : <span class="trxWithdraw">0</span>&nbsp;&nbsp;
										<spring:message code="walletWithdraw.min" />
											: <span id="trxminWithdraw">200</span>
										</div>
									</div>
									<div class="assetlistbox2">
										<div class="asset_fee">
											<div class="text1"> <spring:message code="wallet.fee" /> : ${feeList[3].fee} TRX </div>
										</div>
									</div>
									<input type="button" onclick="sendEmail()" value="<spring:message code='support.submit'/>" data-wait="Please wait..." class="submit-button w-button">
								</div>
							</div>
							<div class="asset_warn trx all wcoin_select">
								<div class="asset_warntxt">
									<span class="warn_title"> <spring:message code="walletWithdraw.notice" /><br></span>
									<spring:message code="walletWithdraw.notice2" />
									<br> 
									<span class="warn"><spring:message code="walletWithdraw.notice3" /><br> </span>
									<spring:message code="walletWithdraw.notice4" />
									<br>
									<spring:message code="walletWithdraw.notice5" />
								</div>
							</div>
						</div>
						<div class="asset_coinsub">
							<div class="asset_coinsub_top xrp all wcoin_select">
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.available" />
								</div>
								<div class="asset_coinsub_toptxt">
									<spring:message code="wallet.inUse" />
								</div>
								<div class="asset_coinsub_toptxt"> XRP <spring:message code="wallet.evaluationValue" /> </div>
							</div>
							<div class="asset_coininfoblock" onclick="coinToggle(this, 'XRP')" slide="off">
								<div class="asset_cointitle">
									<img src="../webflow/images/XRPicon_1XRPicon.png" loading="lazy" alt="" class="coinimg1">
									<div class="asset_coinsub_name">XRP</div>
								</div>
								<div class="asset_coininfo">
									<div class="asset_coininfo_txt xrpWithdraw">
										<fmt:formatNumber value="${walletXRP}" pattern="#,###.#####" /> XRP
									</div>
									<div class="asset_coininfo_txt" id="xrpUsing">0</div>
									<div class="asset_coininfo_txt" id="xrpBalance">
										<fmt:formatNumber value="${walletXRP}" pattern="#,###.#####" />
									</div>
								</div>
								<div class="depositbtntxt" style="cursor: pointer;">
									<spring:message code="wallet.withdrawal" />
								</div>
							</div>
							<div class="form-block-2 xrp all wcoin_select">
								<div class="form-2">
									<label class="title2"><spring:message code="wallet.stockExchange" /></label>
									<input type="text" class="text-field-3 w-input" maxlength="100" placeholder="<spring:message code="wallet.inputStockExchange"/>" id="XRPinStock">
									<label for="name-7" class="title2">Destination Tag</label>
									<input type="text" class="text-field-3 w-input" maxlength="256" name="name-3" placeholder="<spring:message code="wallet.dtag" />" id="inputXrpTag" onkeyup="setNum(this);">
									<label for="name-3" class="title2"><spring:message code="walletWithdraw.address" /></label>
									<input type="text" class="text-field-3 w-input" maxlength="256" name="name-3" placeholder="<spring:message code="walletWithdraw.addresstxt"/>" id="XRPinAddress">
									<label for="email-3" class="title2"><spring:message code="walletWithdraw.money" /></label>
									<div class="withrawl_qty">
										<input type="text" class="text-field-4 w-input" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" maxlength="100" name="email-3" placeholder="<spring:message code="walletWithdraw.moneytxt"/>" id="XRPinAmount">
										<div class="mawqty">
											<div onclick="max()" style="cursor: pointer">MAX</div>
										</div>
									</div>
									<div class="assetlistbox2">
										<div class="asset_able" style="line-height:3vh">
											<spring:message code="wallet.available" /> : <span class="xrpWithdraw">0</span>&nbsp;&nbsp;
											<spring:message code="walletWithdraw.min" />
											: <span id="xrpminWithdraw">20</span>
										</div>
									</div>
									<div class="assetlistbox2">
										<div class="asset_fee">
											<div class="text1"><spring:message code="wallet.fee" />
												 : ${feeList[2].fee} XRP</div>
										</div>
									</div>
									<input type="button" onclick="sendEmail()" value="<spring:message code='support.submit'/>" data-wait="Please wait..." class="submit-button w-button">
								</div>
							</div>
							<div class="asset_warn xrp all wcoin_select">
								<div class="asset_warntxt xrp">
									<span class="warn_title"> <spring:message code="walletWithdraw.notice" /><br></span>
									<spring:message code="walletWithdraw.notice2" />
									<br> 
									<span class="warn"><spring:message code="walletWithdraw.notice3" /><br> </span>
									<spring:message code="walletWithdraw.notice4" />
									<br>
									<spring:message code="walletWithdraw.notice5" />
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
		<div class="withrawlpop" id="codePop" style="display:none">
				<div class="withrawlblock">
					<div class="pop_exist" onClick="location.reload();" style="cursor:pointer; display:flex">
						<img src="../webflow/images2/wx.png" loading="lazy" alt="" class="image-38">
					</div>
					<div class="title6"><spring:message code="wallet.withdrawal" /> <spring:message code="join.code" /></div>
					<div class="form-block-14 w-form">
						<div class="pop_input">
							<input type="text" class="text-field-18 w-input" maxlength="10" name="email-3" id="codeInput"> 
							<a href="javascript:emailConfirm()" class="button-32 w-button"><spring:message code="affiliate.check" /></a>
						</div>
					</div>
				</div>
			</div>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6180a71858466749aa0b95bc" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script>
		var cfnum = 5;
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
		
		function coinPosUpdate() {
			var futureWallet = "${wallet}";

			var futuresWithdrawWallet = parseFloat(getWithdrawWallet(
					futureWallet, "futures"));
			$("#avaWithdraw").html(fmtNum(toFixedDown(futuresWithdrawWallet, 2))+'<span class="unit">USDT</span>');
			$("#avaUsing").html(fmtNum(toFixedDown(getMargin("futures"), 2))+'<span class="unit">USDT</span>');

			withdrawW[0] = Number(toFixedDown(getWithdrawWallet(walletBTC, "BTCUSD"), cfnum));
			$(".btcWithdraw").html(fmtNum(withdrawW[0]) +'<span class="unit">BTC</span>');
			$("#btcUsing").html(fmtNum(toFixedDown(getMargin("BTCUSD"), cfnum)) +'<span class="unit">BTC</span>');

			withdrawW[1] = Number(toFixedDown(getWithdrawWallet(walletETH, "ETHUSD"), cfnum));
			$(".ethWithdraw").html(fmtNum(withdrawW[1]) +'<span class="unit">ETH</span>');
			$("#ethUsing").html(fmtNum(toFixedDown(getMargin("ETHUSD"), cfnum)) +'<span class="unit">ETH</span>');

			withdrawW[2] = Number(toFixedDown(getWithdrawWallet(walletXRP, "XRPUSD"), 1));
			$(".xrpWithdraw").html(fmtNum(withdrawW[2]) +'<span class="unit">XRP</span>');
			$("#xrpUsing").html(fmtNum(toFixedDown(getMargin("XRPUSD"), 1)) +'<span class="unit">XRP</span>');

			withdrawW[3] = Number(toFixedDown(getWithdrawWallet(walletTRX, "TRXUSD"), 0));
			$(".trxWithdraw").html(fmtNum(withdrawW[3]) +'<span class="unit">TRX</span>');
			$("#trxUsing").html(fmtNum(toFixedDown(getMargin("TRXUSD"), 1)) +'<span class="unit">TRX</span>');
			
			withdrawW[4] = parseFloat(getWithdrawWallet(walletUSDT, "USDT"));
			$(".usdtWithdraw").html(fmtNum(toFixedDown(withdrawW[4], 1)) +'<span class="unit">USDT</span>');
			$("#usdtUsing").html(fmtNum(toFixedDown(getMargin("USDT"), 1)) +'<span class="unit">USDT</span>');
			
			//$("#usdtWithdraw, #usdtBalance").html(fmtNum(toFixedDown(walletUSDT, 2)) +'<span class="unit">USDT</span>');
		}

		function getWithdrawWallet(wallet, coin) {
			var obj = new Object();
			for (var i = 0; i < positionObj.plist.length; i++) {
				if (positionObj.plist[i].symbol == coin) {
					var sise = longSise[getSymbol(positionObj.plist[i].symbol)];
					wallet = wallet - (positionObj.plist[i].fee + positionObj.plist[i].margin);

					var profit = (sise * positionObj.plist[i].buyQuantity) - positionObj.plist[i].contractVolume;
					if (positionObj.plist[i].position == 'short')
						profit = -profit;
					profit = profit / sise;
					if (positionObj.plist[i].marginType == "cross") {
						if (profit < 0 && Math.abs(profit) > positionObj.plist[i].fee) {
							overMargin[i] = profit + Number(positionObj.plist[i].fee);
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
			for (var i = 0; i < positionObj.spotolist.length; i++) {
				if (positionObj.spotolist[i].symbol == coin || coin == "USDT") {
					if(coin == "USDT" && positionObj.spotolist[i].position == "long")
						wallet -= positionObj.spotolist[i].paidVolume;
					else if(coin != "USDT" && positionObj.spotolist[i].position == "short")
						wallet -= positionObj.spotolist[i].buyQuantity;
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
						if(coin == "USDT" && positionObj.spotolist[i].position == "long"){
							//console.log("test:"+positionObj.spotolist[i].paidVolume);
							margin += positionObj.spotolist[i].paidVolume;
						}
						else if(coin != "USDT" && positionObj.spotolist[i].position == "short")
							margin += positionObj.spotolist[i].buyQuantity;
					}
				}
				if(coin == "USDT")
					return margin; 
				else
					margin += Math.abs(overMargin[getSymbol(coin)]);
			}
			return margin;
		}

		function isInverse(symbol) {
			if (symbol.charAt(symbol.length - 1) != 'T')
				return true;
			return false;
		}

		function balanceCheckInput() {
			closePop();
			$.ajax({
				type : 'post',
				dataType : 'json',
				url : '/wesell/user/userBalanceCheck.do',
				success : function(data) {
					alert(data.msg);
				},

				error : function(e) {
					alert("<spring:message code='pop.show.commingSoon'/>");
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}

		function emailConfirm() {
			var code = $("#codeInput").val();
			if(code === '' || !isNumber(code)) {
				alert("<spring:message code='pop.inputConfirmCode'/>")
				document.getElementById('codeInput').value = '';
				$("#codeInput").focus();
				
				return;
			}
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
						$("#codePop").css("display", "none");
						location.reload();
					}
				},

				error : function(e) {
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}

		function coinToggle(obj, s) {
			selectedCoin = s;
			if ($(obj).attr("slide") == "on")
				return;
			$('.wcoin_select').hide();
			$(".asset_coininfoblock").attr("slide", "off");
			$(obj).parent().find('.wcoin_select').slideDown(500);
			$(obj).parent().find('.wcoin_select').css("display", "flex");
			$(obj).attr("slide", "on");
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
		/* 	case "DOGEUSDT":
			case "DOGE":
			case "DOGEUSD":
				return 4; */
			case "USDT":			
				return 4;
			default:
				break;
			}
		}

		var coinArr = new Array('BTCUSDT', 'ETHUSDT', 'XRPUSDT', 'TRXUSDT'); // 코인 변수명 
		var fPrice = new Object;

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
	<script src="../js/webflow2.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
</body>
</html>