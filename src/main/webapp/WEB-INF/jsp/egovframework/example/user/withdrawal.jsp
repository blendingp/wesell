<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>wallet withdrawal</title>
<meta content="wallet withdrawal" property="og:title">
<meta content="wallet withdrawal" property="twitter:title">
<jsp:include page="../userFrame/header.jsp"></jsp:include>
<style type="text/css">
@CHARSET "UTF-8";

[contenteditable=true]:empty:before {
	content: attr(placeholder);
	display: block; /* For Firefox */
}

div[contenteditable=true] {
	border: 1px solid #ddd;
	color: #333;
	font-size: 12px;
	padding: 5px;
}
</style>
</head>
<body>
	<div class="all">
		<jsp:include page="../userFrame/top.jsp"></jsp:include>
		<div class="body3">
			<div class="refer1">
				<div class="refermenu">
					<div class="rewardmtitle">
						<img src="/global/webflow/louisImage/Person_icon.png" loading="lazy" alt="" class="rewardmenuicon">
						<div class="rewardmlisttext"><spring:message code="wallet.spotWallet"/></div>
					</div>
					<div class="rewardmlist" onclick="location.href='/global/user/wallet.do'" style="cursor: pointer;">
						<div class="rewardmlisttext"><spring:message code="wallet.deposit"/></div>
					</div>
					<div class="rewardmlist click" onclick="location.href='/global/user/withdrawal.do'" style="cursor: pointer;">
						<div class="rewardmlisttext"><spring:message code="wallet.withdrawal"/></div>
					</div>
					<div class="rewardmtitle">
						<img src="/global/webflow/louisImage/Exchange_icon.png" loading="lazy" alt="" class="rewardmenuicon">
						<div class="rewardmlisttext"><spring:message code="wallet.spotExchange"/></div>
					</div>
					<div class="rewardmlist" onclick="location.href='/global/user/exchange.do'" style="cursor: pointer;">
						<div class="rewardmlisttext">BTC</div>
						<img src="/global/webflow/louisImage/arrow_icon.png" loading="lazy" alt="" class="image-9">
						<div class="rewardmlisttext">USDT</div>
					</div>
					<div class="rewardmtitle">
						<img src="/global/webflow/louisImage/Transfer_icon.png" loading="lazy" alt="" class="rewardmenuicon">
						<div class="rewardmlisttext"><spring:message code="wallet.transfer"/></div>
					</div>
					<div class="rewardmlist" onclick="location.href='/global/user/transfer.do'" style="cursor: pointer;">
						<div class="rewardmlisttext">Spot</div>
						<img src="/global/webflow/louisImage/arrow_icon.png" loading="lazy" alt="" class="image-9">
						<div class="rewardmlisttext">Futures</div>
					</div>
					<div class="form-block-6 w-form">
						<form id="email-form" name="email-form" data-name="Email Form">
							<select id="field-2" name="field-2" data-name="Field 2" class="select-field-2 w-select">
								<option value="">BTCUSDT</option>
								<option value="First">First Choice</option>
								<option value="Second">Second Choice</option>
								<option value="Third">Third Choice</option>
							</select>
						</form>
						<div class="w-form-done">
							<div>Thank you! Your submission has been received!</div>
						</div>
						<div class="w-form-fail">
							<div>Oops! Something went wrong while submitting the form.</div>
						</div>
					</div>
				</div>
			</div>
			<div class="refer2">
				<div class="notiin1-copy">
					<div class="momenutitle">
						<div class="momenutext">Menu</div>
						<a href="#" onclick="$('.notimenu').slideToggle();$('.momeup , .momedown ').toggle()" class="momelink w-inline-block">
							<img src="/global/webflow/louisImage/check.png" loading="lazy" sizes="100vw" srcset="/global/webflow/louisImage/check-p-500.png 500w, /global/webflow/louisImage/check-p-800.png 800w, /global/webflow/louisImage/check.png 1200w" alt="" class="momedown">
							<img src="/global/webflow/louisImage/check_1.png" loading="lazy" sizes="(max-width: 767px) 15px, 100vw" srcset="/global/webflow/louisImage/check_1-p-500.png 500w, /global/webflow/louisImage/check_1-p-800.png 800w, /global/webflow/louisImage/check_1.png 1200w" alt="" class="momeup">
						</a>
					</div>
					<div class="notimenu">
						<div class="rewardmlist-copy">
							<div class="rewardmlisttext"><spring:message code="wallet.spotWallet"/></div>
							<img src="/global/webflow/louisImage/right_icon.png" loading="lazy" alt="" class="cusarrow">
						</div>
						<div class="rewardmlist"
							onclick="location.href='/global/user/wallet.do'">
							<div class="rewardmlisttext"><spring:message code="wallet.deposit"/></div>
							<img src="/global/webflow/louisImage/right_icon.png" loading="lazy" alt="" class="cusarrow">
						</div>
						<div class="rewardmlist click"
							onclick="location.href='/global/user/withdrawal.do'">
							<div class="rewardmlisttext"><spring:message code="wallet.withdrawal"/></div>
							<img src="/global/webflow/louisImage/right_icon.png" loading="lazy" alt="" class="cusarrow">
						</div>
						<div class="rewardmlist-copy">
							<div class="rewardmlisttext"><spring:message code="wallet.spotExchange"/></div>
							<img src="/global/webflow/louisImage/right_icon.png" loading="lazy" alt="" class="cusarrow">
						</div>
						<div class="rewardmlist" onclick="location.href='/global/user/exchange.do'">
							<div class="rewardmlisttext">BTC ↔ USDT</div>
							<img src="/global/webflow/louisImage/right_icon.png" loading="lazy" alt="" class="cusarrow">
						</div>
						<div class="rewardmlist" onclick="location.href='/global/user/transfer.do'">
							<div class="rewardmlisttext">Spot ↔ Futures</div>
							<img src="/global/webflow/louisImage/right_icon.png" loading="lazy" alt="" class="cusarrow">
						</div>
					</div>
				</div>
				<div class="walletbox">
					<div class="wcoin">
						<img src="/global/webflow/louisImage/BTC_icon_1.png" loading="lazy"
							alt="" class="wcoinimg">
						<div class="wallettitle">WithDraw BTC</div>
					</div>
					<div class="winbox">
						<div class="winbox1">
							<div class="balance"><spring:message code="wallet.withdrawBTC"/></div>
							<div class="balancewbox">
								<div class="balancew">${user.btcWallet}</div>
								<div class="balancecoin">BTC</div>
							</div>
							<div class="tips">
								Tips:<br><spring:message code="wallet.withdrawTip"/>
							</div>
							<div class="tips-copy">
								Fee : 0.0005<br>Min Withdraw : 0.001
							</div>
						</div>
						<div class="winbox2">
							<div class="coinaddresstitle">WithDraw BTC Address</div>
							<div class="addtext" contenteditable="true" style="color: white;"
								placeholder="Wallet Address" id="btcAddress"></div>
							<div class="ambox">
								<div class="amtext">Amount</div>
								<a href="javascript:btcmax();" id="btcmaxbtn" class="maxbtn w-button">MAX</a>
							</div>
							<div class="addtext2" id="btcAmount" contenteditable="true"
								style="color: white;" placeholder="0"></div>
							<div class="coinaddresstitle2"><spring:message code="wallet.code"/></div>
							<div class="ambox">
								<div class="form-block-18 w-form">
									<form id="email-form-3" name="email-form-3"
										data-name="Email Form 3">
										<input type="text" class="text-field-5 w-input"
											maxlength="256" placeholder="" id="code1" required="">
									</form>
									<div class="w-form-done">
										<div>Thank you! Your submission has been received!</div>
									</div>
									<div class="w-form-fail">
										<div>Oops! Something went wrong while submitting the
											form.</div>
									</div>
								</div>
								<a href="javascript:sendRequest()" class="maxbtn2 w-button">
									<spring:message code="wallet.requestCode"/>
								</a>
							</div>
							<a href="#" class="wbtn w-button" onclick="alert('준비중입니다');return false;"><spring:message code="wallet.applicationWithdraw"/></a>
						</div>
					</div>
					<div class="wcoin">
						<img src="/global/webflow/louisImage/USDT_icon.png" loading="lazy"
							alt="" class="wcoinimg">
						<div class="wallettitle">WithDraw USDT</div>
					</div>
					<div class="winbox">
						<div class="winbox1">
							<div class="balance"><spring:message code="wallet.withdrawUSDT"/></div>
							<div class="balancewbox">
								<div class="balancew">${user.ercWallet}</div>
								<div class="balancecoin">USDT</div>
							</div>
							<div class="tips">
								Tips:<br><spring:message code="wallet.withdrawTip"/>
							</div>
							<div class="tips-copy">
								Fee : 0.0005<br>Min Withdraw : 0.001
							</div>
						</div>
						<div class="winbox2">
							<div class="coinaddresstitle">USDT Address</div>
							<div class="addtext" id="usdtAddress" contenteditable="true"
								style="color: white;" placeholder="Wallet Address"></div>
							<div class="ambox">
								<div class="amtext">Amount</div>
								<a href="javascript:usdtmax();" id="usdtmaxbtn" class="maxbtn w-button">MAX</a>
							</div>
							<div class="addtext2" id="usdtAmount" contenteditable="true"
								style="color: white;" placeholder="0"></div>
							<div class="coinaddresstitle2">Network</div>
							<div class="ercbox-copy">
								<div class="erc click">
									<div class="erctext">ERC20</div>
								</div>
								<!--                 <div class="erc">
                  <div class="erctext">ERC20</div>
                </div>
                <div class="erc">
                  <div class="erctext">ERC20</div>
                </div> -->
							</div>
							<div class="coinaddresstitle2"><spring:message code="wallet.code"/></div>
							<div class="ambox">
								<div class="form-block-18 w-form">
									<form id="email-form-3" name="email-form-3"
										data-name="Email Form 3">
										<input type="text" class="text-field-5 w-input"
											maxlength="256" name="email-3" data-name="Email 3"
											placeholder="" id="code2" required="">
									</form>
									<div class="w-form-done">
										<div>Thank you! Your submission has been received!</div>
									</div>
									<div class="w-form-fail">
										<div>Oops! Something went wrong while submitting the
											form.</div>
									</div>
								</div>
								<a href="javascript:sendRequest()" class="maxbtn2 w-button"><spring:message code="wallet.requestCode"/></a>
							</div>
							<a href="#" class="wbtn w-button" onclick="alert('준비중입니다');return false;"><spring:message code="wallet.applicationWithdraw"/></a>
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../userFrame/footer.jsp"></jsp:include>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		var usdt = ${user.ercWallet};
		var btc = ${user.btcWallet};
		var userIdx = "${userIdx}";
		var fee1 = 0.005;
		var fee2 = 0.005;
		var from = "${user.ercAddress}";
		
		var btcWif = "${user.btcWif}";
		var btcWalletId = ${user.btcWalletId};
		var checkPhone = false;
		var btcmax = function() {
			document.getElementById('btcAmount').textContent = btc;
		}
		var usdtmax = function() {
			document.getElementById('usdtAmount').textContent = usdt;
		}
		
		function isAddress(asValue) {
			if (asValue.length != 42) {
				return false;
			}
			let regExp = /0[xX][0-9a-fA-F]+/;
			return regExp.test(asValue); // 형식에 맞는 경우 true 리턴	
		}
		function isBtcAddress(asValue) {
			if (asValue.length != 34) {
				return false;
			}
			let regExp = /[a-zA-Z0-9]/;
			return regExp.test(asValue); // 형식에 맞는 경우 true 리턴	
		}
		function isAmount(asValue) {
			let regExp = /^\d+(?:[.]?[\d]?[\d]?[\d])?$/;
			return regExp.test(asValue); // 형식에 맞는 경우 true 리턴	
		}
		/*
		if(!checkPhone){
			alert("휴대폰 인증이 필요합니다.")
			return false;
			
		} */
		function sendRequest(){
			alert("휴대폰 인증이 필요합니다.")
			/* 로그인을 위해 잠시 주석처리
			$.ajax({
				type:'post',
				data: {'phone': $("#phone").val() , 'country' : $("#country").val()},
				dataType : 'json',
				url:'/global/verificationPhone.do',
				success:function(data){
					alert(data.msg);
					checkPhone = true;
				},
				error:function(e){
					console.log('ajax error ' + JSON.stringify(e));
				}
			}) */
		}
		function sendUSDT() {
			var amount = parseFloat(document.getElementById('usdtAmount').textContent);
			var address = "" + document.getElementById('usdtAddress').textContent;
			var code = document.getElementById('code2').value; // 인증 코드
			if (code == null || code == "" || code != "1234") {
				alert("verification code is not matched. please try again.");
				$("#code2").focus();
				return false;
			}
			if (address == null || address == '') {
				alert("주소를 입력해주세요");
				$("#usdtAddress").focus();
				return false;
			}
			if (!isAddress(address)) {
				alert("주소를 제대로 입력해주세요.")
				$("#usdtAddress").focus();
				return false;
			}
			if (amount == null || amount == '') {
				alert("송금 금액을 입력해주세요");
				$("#usdtAmount").focus();
				return false;
			}
			if (amount < 0.001) {
				alert("송금 최소값은 0.001입니다.")
				$("#usdtAmount").focus();
				return false;
			}
			if (!isAmount(amount)) {
				alert("송금 금액을 제대로 입력해주세요.")
				$("#usdtAmount").focus();
				return false;
			}
			if (amount > usdt + fee1) {
				alert("입력값이 보유한 금액보다 많습니다.")
				$("#usdtAmount").focus();
				return false;
			}
			var data = {
				'address' : from,
				'to' : address,
				'private_key' : pkey,
				'amount' : amount,
				'gas_limit' : 65000,
				//'gwei' : 40
			};
/* 			$.ajax({
				type : 'get',
				data : data,
				dataType : 'json',
				url : 'http://localhost:5000/eth/send_erc',
				success : function(dat) { */
					var balance = usdt - amount - fee1;
					var usdtData = {
						'ercWallet' : balance,
						'btcWallet' : btc
					};
					//console.log("data:::",dat);
					var url = "/global/user/updateWalletBalance.do";
 					$.ajax({
						type : 'post',
						url : url,
						data : usdtData,
						success : function(data) {
							if (data.result == 'success') {
								alert('송금이 완료되었습니다.');
							} else if (data.result == 'fail') {
								console.log(data);
								alert('오류가 발생했습니다. 다시 시도해주세요.');
							}
						},
						error : function(e) {
							alert('ajax Error' + e);
						}
					})
					 var trsData = {
						'coin' : 'USDT',
						'amount' : amount,
						'tx' : 'example',
						'status' : 0,
						'label' : '-'
						/* 'time' : event.timeStamp,
						'userIdx': userIdx */
					};
					$.ajax({
						type : 'post',
						url : "/global/user/transaction.do",
						data : trsData,
						success : function(data) {
							if (data.result == 'success') {
								console.log('기록이 완료되었습니다.');
							} else if (data.result == 'fail') {
								console.log(data);
								alert('기록 오류가 발생했습니다. 다시 시도해주세요.');
							}
						},
						error : function(e) {
							alert('ajax Error' + e);
						}
					}) /*
					alert(data.msg);
				},
 				error : function(e) {
					alert("USDT 전송 실패" + JSON.stringify(e));
				}
			}) */
		}
		function sendBTC() {
			var amount = parseFloat(document.getElementById('btcAmount').textContent);
			var address = "" + document.getElementById('btcAddress').textContent;
			var code = document.getElementById('code1').value; // 인증 코드
			if (code == null || code == "" || code != "1234") {
				alert("verification code is not matched. please try again.");
				$("#code1").focus();
				return false;
			}
			if (address == null || address == '') {
				alert("주소를 입력해주세요");
				$("#btcAddress").focus();
				return false;
			}
			if (!isBtcAddress(address)) {
				alert("주소를 제대로 입력해주세요.")
				$("#btcAddress").focus();
				return false;
			}
			if (amount == null || amount == '') {
				alert("송금 금액을 입력해주세요");
				$("#btcAmount").focus();
				return false;
			}
			if (amount < 0.001) {
				alert("송금 최소값은 0.001입니다.")
				$("#btcAmount").focus();
				return false;
			}
			if (!isAmount(amount)) {
				alert("송금 금액을 제대로 입력해주세요.")
				$("#btcAmount").focus();
				return false;
			}
			if (amount > btc + fee2) {
				alert("입력값이 보유한 금액보다 많습니다.")
				$("#btcAmount").focus();
				return false;
			}
			var data = {
				'wallet_id' : btcWalletId,
				'wif' : btcWif,
				'address' : address,
				'amount' : amount,
				'kbfee' : 0.0001
			};
/* 			$.ajax({
				type : 'get',
				data : data,
				dataType : 'json',
				url : 'http://localhost:5000/btc/send_btc',
				success : function(data) { */
					var balance = btc - amount - fee2;
					var btcData = {
						'ercWallet' : usdt,
						'btcWallet' : balance
					};
					var url = "/global/user/updateWalletBalance.do";
					$.ajax({
						type : 'post',
						url : url,
						data : btcData,
						success : function(data) {
							if (data.result == 'success') {
								alert('송금이 완료되었습니다.');
								location.href = "/global/user/wallet.do";
							} else if (data.result == 'fail') {
								console.log(data);
								alert('오류가 발생했습니다. 다시 시도해주세요.');
							}
						},
						error : function(e) {
							alert('ajax Error' + e);
						}
					})
					alert(data.msg);
/* 				},
				error : function(e) {
					alert("BTC 전송 실패" + JSON.stringify(e));
				}
			})// */
		}
	</script>
</body>
</html> --%>