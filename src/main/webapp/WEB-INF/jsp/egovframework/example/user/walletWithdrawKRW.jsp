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
<html data-wf-page="621f09ab6891ea2e761f009d" data-wf-site="6180a71858466749aa0b95bc">
<head>
  <jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
</head>
<body class="body">
  <div class="frame">
    <jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
    <div class="frame2">
		<jsp:include page="../userFrame/walletFrameKRW.jsp"></jsp:include>
		<div class="asset_block">
        <div class="assetbox">
          <div class="assettitle"><spring:message code="wallet.property" /></div>
          <div class="deposit_warp1">
            <div class="asset_value">
              <div class="assettxt1"><spring:message code="wallet.assetValue" /></div>
              <div class="assettxt2"></div>
            </div>
          </div>
          <div class="deposit_warp3">
          <div class="w-form">
            <form id="email-form" name="email-form" data-name="Email Form" method="get">
              <div class="dwrap-2">
                <div class="div-block-12">
                  <div class="wallettxt">
                    <div class="mymoney my"><span class="text-span-54"><spring:message code="newwave.wallet.t_holding" /> USDT </span><fmt:formatNumber type="number" maxFractionDigits="2"
											value="${user.wallet}" /> USDT</div>
                    <div class="wallet_krwtxt">　</div>
                  </div>
                  <div class="wallettxt">
                    <div class="mymoney"><span class="text-span-54"><spring:message code="newwave.trade.availWithdraw" /> USDT </span><fmt:formatNumber type="number" maxFractionDigits="2"
											value="${withdrawWallet}" /> USDT</div>
                    <!-- <div class="wallet_krwtxt">　</div> -->
                  </div>
                  <div class="arrow horizon">→</div>
                  <div class="arrow vertical">↓</div>
                  <div class="wallettxt">
                    <div class="mymoney"><span class="text-span-54"><spring:message code="newwave.trade.availWithdraw" /> <spring:message code="newwave.wallet.cash" /> USDT <spring:message code="newwave.wallet.marketPrice" /></span></div>
                    <!-- <div class="wallet_krwtxt"></div> -->
                  </div>
                </div>
                <div class="tablewrap4">
                  <div class="dtitle"><spring:message code="newwave.wallet.withdrawal" /> <spring:message code="newwave.wallet.account" /></div>
                  <div class="useraccount">${user.mbank}&nbsp;${user.maccount}</div>
                </div>
                <div class="tablewrap4">
                  <div class="dtitle"><spring:message code="newwave.wallet.requestedA" /></div>
                  <div class="tablewrap"><input type="text" class="text-field4 w-input" maxlength="256" name="field-2" data-name="Field 2" placeholder="0" onKeyup="withdrawck(this)" id="withdrawMoney" readonly style="background-color: rgba(0, 0, 0, 0.22)">
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
                <div class="tablewrap4">
                  <div class="dtitle"><spring:message code="newwave.wallet.application" /> USDT</div>
                  <div class="withdraw_sizebox">
                    <div class="text-block-13">0 USDT</div>
                    <div class="wallet_krwtxt"></div>
                  </div>
                </div>
                <div class="div-block-4">
                  <div class="anotice"><spring:message code="newwave.wallet.w_guide" /></div>
                  <div class="div-block-76">
                    <div class="anotice2"><span class="text-span-53">○</span><spring:message code="newwave.wallet.w_guide1" /></div>
                    <div class="anotice2"><span class="text-span-53">○</span><spring:message code="newwave.wallet.w_guide2" /></div>
                    <div class="anotice2"><span class="text-span-53">○</span><spring:message code="newwave.wallet.w_guide3" /></div>
                  </div>
                </div>
                <div class="btnwrap">
                  <a href="#" onclick="javascript:withdrawSubmit()" class="btn w-inline-block">
                    <div class="btntxt"><spring:message code="newwave.wallet.w_apply" /></div>
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
    <div class="popup" style="display:none;">
      <div class="withrawlpop">
        <div class="withrawlblock">
          <div class="pop_exist">
            <a href="#" class="w-inline-block"><img src="../images2/close.png" loading="lazy" alt="" class="image-38"></a>
          </div>
          <div class="title6">출금 인증 코드</div>
          <div class="form-block-14 w-form">
            <form id="email-form-2" name="email-form-2" data-name="Email Form 2" method="get">
              <div class="pop_input"><input type="email" class="text-field-18 w-input" maxlength="256" name="email-3" data-name="Email 3" placeholder="인증번호를 입력하세요" id="email-3" required="">
                <a href="#" class="button-32 w-button">인증코드 요청</a>
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
    <jsp:include page="../wesellFrame/footer2.jsp" />
  </div>
  <script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6180a71858466749aa0b95bc" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
  <script src="../js/webflow2.js" type="text/javascript"></script>
  <!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
  <script>
	window.addEventListener("load", loadExcRate, false);

	var myWallet = "${user.wallet}";
	var ausdt = ${withdrawWallet};
	function loadExcRate() {
		$('.asset_value .assettxt2').html(
				numberWithCommas(exRate) + ' KRW = 1 USDT');
		$('.div-block-12 .wallettxt:eq(0) .wallet_krwtxt').html(numberWithCommas(parseInt(myWallet*exRate))+"￦");
		$('.div-block-12 .wallettxt:eq(1) .mymoney')
				.html(
						'<span class="text-span-54"><spring:message code="newwave.trade.availWithdraw" /> USDT</span>'
								+ numberWithCommas((parseFloat(ausdt))
										.toFixed(2)) + ' USDT');
		$('.div-block-12 .wallettxt:eq(2) .mymoney').html('<span class="text-span-54"><spring:message code="newwave.trade.availWithdraw" /> <spring:message code="newwave.wallet.cash" /> USDT <spring:message code="newwave.wallet.marketPrice" /></span>'+numberWithCommas(parseInt(parseFloat(ausdt) * exRate))+" KRW");
		if (start !== 0) {
			$('.text-block-13').html(
					numberWithCommas((start / exRate).toFixed(2))
							+ ' USDT');
		}
		setTimeout(loadExcRate, 300000);
	}
	
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	function numberDeleteCommas(x) {
		return x.toString().replace(/\,/g, "");
	}

	var start = 0;
	var userMoney = '${user.wallet}';
	$(".pbtn").click(function() {
		
		var money = parseInt($(this).attr("money"));
		console.log("pbtn~~~~~~~~~~~~~"+money);
		//var fee = parseInt($(this).attr("money"))/100;

		if (money == -1) {
			start = 0;
			$("#withdrawMoney").val("");
			$('.text-block-13').html("0 USDT");
			//$("#withdrawFee").html("0");
		} else {
			console.log("ausdt:"+ausdt+" exRate:"+exRate+" start:"+start);
			if (ausdt * exRate >= start + money) {
				//if(userMoney-fee>=start+money){
				start += money;
				//fee = start/100;
				console.log("start:"+start);
				$("#withdrawMoney").val(numberWithCommas(start));
				$('.text-block-13').html(
						numberWithCommas((start / exRate).toFixed(2))
								+ ' USDT');
				//$("#withdrawFee").html(numberWithCommas(fee));
			}
		}
	});

	function withdrawck(obj) {
		var withdrawMoney = obj.value;
		if (withdrawMoney.length == 0) {
			$("#withdrawMoney").val("");
			//$("#withdrawFee").html("0");
			return false;
		}
		withdrawMoney = numberDeleteCommas(withdrawMoney);

		if (isFinite(withdrawMoney) == false) {
			alert("<spring:message code='newwave.wallet.warn_msg1' />");
			$("#withdrawMoney").val("");
			//$("#withdrawFee").html("0");
			return false;
		}

		if (ausdt * exRate < parseInt(withdrawMoney)) {
			alert("<spring:message code='newwave.wallet.warn_msg3' />");
			withdrawMoney = ausdt * exRate
					- (ausdt * exRate % 10000);
		}
		$("#withdrawMoney").val(numberWithCommas(parseInt(withdrawMoney)));
		//$("#withdrawFee").html(numberWithCommas(parseInt(withdrawMoney/100)));
	}
	
	function withdrawReq() {
		
	}

	function withdrawSubmit() {
		var money = $("#withdrawMoney").val();
		var withdrawMoney = numberDeleteCommas(money);

		if (isFinite(withdrawMoney) == false) {
			alert("<spring:message code='newwave.wallet.warn_msg1' />");
			$("#withdrawMoney").val("");
			//$("#withdrawFee").html("0");
			return;
		}

		if (withdrawMoney % 10000 > 0) {
			alert("<spring:message code='newwave.wallet.warn_msg2' />");
			withdrawMoney = withdrawMoney - (withdrawMoney % 10000);
			$("#withdrawMoney").val(
					numberWithCommas(parseInt(withdrawMoney)));
			//$("#withdrawFee").html(numberWithCommas(parseInt(withdrawMoney/100)));
			return;
		}

		var allData = {
			withdrawMoney : withdrawMoney
		};
		jQuery.ajax({
			type : "POST",
			data : allData,
			url : "/wesell/user/kWithdrawProcess.do",
			dataType : "json",
			success : function(data) {
				alert(data.msg);
				if (data.result == "suc") {
					location.href = "/wesell/user/kTransactions.do";
				} else {
					location.reload();
				}
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
				console.log("ajax ERROR!!! : ");
			}
		});
	}
  </script>
</body>
</html>