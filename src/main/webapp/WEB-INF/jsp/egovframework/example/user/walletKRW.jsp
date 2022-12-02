<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html><!--  This site was created in Webflow. http://www.webflow.com  -->
<!--  Last Published: Mon Mar 14 2022 08:21:34 GMT+0000 (Coordinated Universal Time)  -->
<html data-wf-page="621f09891b27a047c66f3f0c" data-wf-site="6180a71858466749aa0b95bc">
<head>
  <jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
 <style>
input[type="number"]::-webkit-outer-spin-button,
input[type="number"]::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}
.title2 {
	width: 23%;
}
 </style>
</head>
<body class="body2">
  <div class="frame">
    <jsp:include page="../wesellFrame/top2.jsp" />
    <div class="frame2">
		<jsp:include page="../userFrame/walletFrameKRW.jsp" />
		<div class="asset_block">
        <div class="assetbox">
          <div class="assettitle"><spring:message code="wallet.property" /></div>
          <div class="deposit_warp1">
            <div class="asset_value">
              <div class="assettxt1"><spring:message code="wallet.assetValue" /></div>
              <div class="assettxt2"><span id="totalBTC"></span></div>
            </div>
          </div>
          <div class="deposit_warp3">
            <div class="w-form">
              <form id="email-form" name="email-form" data-name="Email Form" method="get">
                <div class="dwrap-2">
                  <div class="div-block-12">
                    <div class="wallettxt">
                      <div class="mymoney"><span class="text-span-54">USDT <spring:message code="newwave.wallet.current" /> <spring:message code="newwave.wallet.marketPrice" /></span><br></div>
                    </div>
                    <div class="wallettxt">
                      <div class="mymoney"><span class="text-span-54"><spring:message code="newwave.wallet.actual" /> <spring:message code="newwave.wallet.menu.exchange" /> USDT</span>0 USDT<br></div>
                      <!-- <div class="wallet_krwtxt">　</div> -->
                    </div>
                  </div>
                 <%--  <div class="tablewrap4">
                    <div class="dtitle"><spring:message code="newwave.wallet.deposit" /></div>
                    <div class="text-block-38"><spring:message code="newwave.wallet.d_info" /></div>
                  </div> --%>
                  <div class="tablewrap4">
                    <div class="dtitle"><spring:message code="newwave.wallet.requestedA" /></div>
                    <div class="tablewrap"><input type="text" id="depositMoney" class="text-field4 w-input" maxlength="256" name="field-2" data-name="Field 2" placeholder="0" id="field-2" required="" readonly style="background-color: rgba(0, 0, 0, 0.22)">
                      <div class="pbtnwrap">
                        <a href="#" money="10000" class="pbtn w-button">1<spring:message code="newwave.wallet.currency" /></a> 
                        <a href="#" money="100000" class="pbtn w-button">10<spring:message code="newwave.wallet.currency" /></a>
                        <a href="#" money="1000000" class="pbtn w-button">1<spring:message code="newwave.wallet.currency2" /></a> 
						<a href="#" money="5000000" class="pbtn w-button">5<spring:message code="newwave.wallet.currency2" /></a>
						<a href="#" money="10000000" class="pbtn w-button">1<spring:message code="newwave.wallet.currency3" /></a>
						<a href="#" money="-1" class="pbtn reset w-button"><spring:message code="newwave.wallet.init" /></a>
                      </div>
                    </div>
                  </div>
                  <!-- <div class="deposit_warntxt">※ 1회 최대 300입금 ※</div> -->
                  <div class="div-block-4">
                    <div class="anotice"><spring:message code="newwave.wallet.d_guide" /></div>
                    <div class="div-block-76">
                      <div class="anotice2"><span class="text-span-53">○</span><spring:message code="newwave.wallet.d_guide_1" /></div>
                      <div class="anotice2"><span class="text-span-53">○</span><spring:message code="newwave.wallet.d_guide2" /></div>
                      <div class="anotice2"><span class="text-span-53">○</span><spring:message code="newwave.wallet.d_guide3" /></div>
                      <div class="anotice2"><span class="text-span-53">○</span><spring:message code="newwave.wallet.d_guide4" /></div>
                    </div>
                  </div>
                  <div class="btnwrap">
                    <a href="/wesell/user/helpCenter.do?title=입금계좌문의" class="btn w-inline-block">
                      <div class="btntxt"><spring:message code="newwave.wallet.acc_inq" /></div>
                    </a>
                    <a href="#" class="btn2 w-inline-block">
                      <div class="btntxt" onclick="javascript:depositSubmit()"><spring:message code="newwave.wallet.d_apply" /></div>
                    </a>
                  </div>
                </div>
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
      </div>
    </div>
    <jsp:include page="../wesellFrame/footer2.jsp" />
    <div class="popup" style="display:none;">
      <div class="deposit_pop">
        <div class="depositpop_box">
          <div class="pop_exist"><img src="../webflow/images2/wx.png" loading="lazy" alt="" class="image-38"></div>
          <div class="poptitle"><spring:message code="newwave.wallet.account" /></div>
          <div class="div-block-105">
            <div class="form-block-17 w-form">
                <div class="div-block-106">
                  <div class="title2"><spring:message code="newwave.join.mbank" />ㅤㅤ</div>
                  <!-- <input type="text" class="text-field-23 w-input" maxlength="256" name="mbank" data-name="Field" placeholder="" id="mbank" required=""> -->
                  <select id="mbank" name="mbank" class="select-field-2 w-select">
									<option value="경남은행">경남은행</option>
                                    <option value="광주은행">광주은행</option>
                                    <option value="국민은행">국민은행</option>
                                    <option value="기업은행">기업은행</option>
                                    <option value="농협중앙회">농협중앙회</option>
                                    <option value="농협회원조합">농협회원조합</option>
                                    <option value="대구은행">대구은행</option>
                                    <option value="도이치은행">도이치은행</option>
                                    <option value="부산은행">부산은행</option>
                                    <option value="산업은행">산업은행</option>
                                    <option value="새마을금고">새마을금고</option>
                                    <option value="수협중앙회">수협중앙회</option>
                                    <option value="신한은행">신한은행</option>
                                    <option value="신협중앙회">신협중앙회</option>
                                    <option value="외환은행">외환은행</option>
                                    <option value="우리은행">우리은행</option>
                                    <option value="우체국">우체국</option>
                                    <option value="전북은행">전북은행</option>
                                    <option value="제주은행">제주은행</option>
                                    <option value="카카오뱅크">카카오뱅크</option>
                                    <option value="케이뱅크">케이뱅크</option>
                                    <option value="하나은행">하나은행</option>
                                    <option value="한국씨티은행">한국씨티은행</option>
                                    <option value="HSBC은행">HSBC은행</option>
                                    <option value="SC제일은행">SC제일은행</option>
								</select>
                </div>
                <div class="div-block-106">
                  <div class="title2"><spring:message code="newwave.join.maccount" /></div><input type="number" class="text-field-23 w-input" maxlength="256" name="maccount" data-name="Field 2" placeholder="" id="maccount" required="">
                </div>
                <div class="div-block-106">
                  <div class="title2"><spring:message code="newwave.join.mname" /></div><input type="text" class="text-field-23 w-input" maxlength="256" name="mname" data-name="Field" placeholder="" id="mname" required="">
                </div>
            </div>
            <div class="pop_btn">
              <a href="#" onclick="closePop()" class="depositbottom1 w-button"><spring:message code="wallet.cancel" /></a>
              <a href="#" onclick="epayProcess()" class="depositbottom2 w-button"><spring:message code="wallet.confirm"/></a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6180a71858466749aa0b95bc" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
  <script src="../js/webflow2.js" type="text/javascript"></script>
  <!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
  	<script>
	var walletBTC = "${walletBTC}";
	var walletUSDT = "${walletUSDT}";
	var walletXRP = "${walletXRP}";
	var walletTRX = "${walletTRX}";
	var walletETH = "${walletETH}";
	
		function numberWithCommas(x) {
			return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		function numberDeleteCommas(x) {
			return x.toString().replace(/\,/g, "");
		}
		
		var start = 0;
		$(".pbtn").click(function(){
			var money = parseInt($(this).attr("money"));
			
			if(money==-1){
				start = 0;
				$("#depositMoney").val("");
				$('.div-block-12 .mymoney:eq(1)').html('<span class="text-span-54"><spring:message code="newwave.wallet.actual" /> <spring:message code="newwave.wallet.menu.exchange" /> USDT</span>0 USDT');
				//$('.wallet_krwtxt').html('0￦');
			}
			else{
				/* if(start+money>3000000){
					alert("1회 최대 300입금입니다.");
					return
				} */
				start += money;
				$("#depositMoney").val(numberWithCommas(start));
				if(exRate) {
					$('.div-block-12 .mymoney:eq(1)').html('<span class="text-span-54"><spring:message code="newwave.wallet.actual" /> <spring:message code="newwave.wallet.menu.exchange" /> USDT</span>'+numberWithCommas((start/exRate).toFixed(2))+' USDT');
					//$('.wallet_krwtxt').html(numberWithCommas(parseInt(start/exRate*start))+'￦');
				}
			}
		});
		
		function depositSubmit(){
			var money = $("#depositMoney").val();
			
			var depositMoney = numberDeleteCommas(money);
			
			/* if(depositMoney>3000000){
				alert("1회 최대 300입금입니다.");
				return
			} */
			if(isFinite(depositMoney) == false){
				alert("<spring:message code='newwave.wallet.warn_msg1' />");
				$("#depositMoney").val("");
				return;
			}
			
			var allData = { depositMoney : depositMoney };
			jQuery.ajax({
				type : "POST",
				data : allData,
				url : "/wesell/user/depositProcess.do",
				dataType : "json",
				success : function(data) {
					alert(data.msg);
					if (data.result == "suc") {
						location.href = "/wesell/user/kTransactions.do";
					}
					else{
						location.reload();
					}
				},
				complete : function(data) { },
				error : function(xhr, status, error) { console.log("ajax ERROR!!! : "); }
			});
		}
		
		loadExcRate();
		function loadExcRate() {
			$('.asset_value .assettxt2').html(numberWithCommas(exRate)+' KRW = 1 USDT');
  			$('.div-block-12 .mymoney:eq(0)').html('<span class="text-span-54">USDT <spring:message code="newwave.wallet.current" /> <spring:message code="newwave.wallet.marketPrice" /></span>'+numberWithCommas(exRate)+' KRW');
  			if(start !== 0) {
  				$('.div-block-12 .mymoney:eq(1)').html('<span class="text-span-54"><spring:message code="newwave.wallet.actual" /> <spring:message code="newwave.wallet.menu.exchange" /> USDT</span>'+numberWithCommas((start/exRate).toFixed(2))+' USDT');
  				//$('.wallet_krwtxt').html(numberWithCommas(parseInt(start/exRate*start))+'￦');
  			}
			setTimeout(loadExcRate, 300000);
		}

		function updateTotalBTC() {

			var btc = Number(walletBTC);
			var usdt = Number(walletUSDT) / longSise[0];
			var xrp = Number(walletXRP * longSise[2]) / longSise[0];
			var trx = Number(walletTRX * longSise[3]) / longSise[0];
			var future = Number("${wallet}") / longSise[0];

			$("#totalBTC").html(
					toFixedDown((btc + usdt + xrp + trx + future), 6));
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
				//updateTotalBTC();
			}
		}
		window.addEventListener("load", initAPI, false);
		
		function epayProcess(){
			if($('#mname').val()=='') {
				alert('<spring:message code="newwave.join.wrMname" />');
				return;
			}else if ($('#maccount').val()=='') {
				alert('<spring:message code="newwave.join.wrAccount" />');
				return;
			}
			var edata = $('#eform').serialize();
			$('.popup').css('display','none');
			jQuery.ajax({
				type : "POST",
				url : "/wesell/epayProcess.do",
				data : edata,
				dataType : "json",
				success : function(data) {
					if (data.result == "success") {
						window.open(data.uri);
					}
					else{
						alert("request failed");
					}
				},
				complete : function(data) { },
				error : function(xhr, status, error) { console.log("ajax ERROR!!! : "); }
			});
		}
		
		function openPop() {
			$('.popup').show();
		}
		
		function closePop() {
			$('.popup').hide();
		}
	</script>
</body>
</html>