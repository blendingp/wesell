<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<!--  This site was created in Webflow. http://www.webflow.com  -->
<!--  Last Published: Wed Dec 08 2021 02:22:08 GMT+0000 (Coordinated Universal Time)  -->
<html data-wf-page="619ddb62800e4c4da1a341b9"
	data-wf-site="619ddb62800e4c70cba341a2">
<head>
<meta charset="utf-8">
<title>deposit</title>
<meta content="deposit" property="og:title">
<meta content="deposit" property="twitter:title">
<jsp:include page="../wesellFrame/header2.jsp" />
<script>
	var fileurl = '<%=this.getClass().getSimpleName().replaceAll("_", ".").replaceAll(".jsp", "")%>';
</script>
</head>
<body class="body">
	<jsp:include page="../wesellFrame/top2.jsp" />
	<div class="frame-2">
		<div class="frame2-2">
			<div class="asset_block-2">
				<div class="sideblock">
					<div class="text-block-36"><spring:message code="menu.depandwith" /></div>
					<div class="selectmenu select" onclick="location.href ='/wesell/user/kWallet.do'" style="cursor:pointer">
						<div class="text7"							
							style="cursor: pointer;"><spring:message code="wallet.KRW.Deposit" /></div>
					</div>
					<%-- <div class="selectmenu"  onclick="location.href ='/wesell/user/kWalletWithdraw.do'" style="cursor:pointer">
						<div class="text7"><spring:message code="wallet.KRW.Withdrawal" /></div>
					</div> --%>
					<%-- <div class="selectmenu"  onclick="location.href ='/wesell/user/kTransactions.do'" style="cursor:pointer">
						<div class="text7"><spring:message code="wallet.KRW.History" /></div>
					</div> --%>
				</div>
				<div class="assetbox-2">
					<div class="assettitle-2"><spring:message code="menu.depandwith" /></div>
					<div class="deposit_warp1-2" style="height: auto">
						<div class="asset_value-2">
							<div class="assettxt1-2">USDT <spring:message code="newwave.wallet.current" /> <spring:message code="wallet.marketPrice" /></div>
							<div class="assettxt2"></div>
						</div>
					</div>
					<div class="assettitle-2"><spring:message code="wallet.deposit" /></div>
					<div class="w-form">
						<form id="email-form" name="email-form" data-name="Email Form">
							<div class="dwrap-3">
								<div class="div-block-304">
									<div class="mymoney-2">
										<span class="text-span-74">USDT <spring:message code="newwave.wallet.current" /> <spring:message code="wallet.marketPrice" /></span>
									</div>
									<div class="mymoney-2">
										<span class="text-span-74"><spring:message code="newwave.wallet.actual" /> <spring:message code="wallet.menu.exchange" /> USDT</span>0 USDT
									</div>
								</div>
								<div class="tablewrap4-2">
									<div class=dtitle-2><spring:message code="wallet.deposit" /> <spring:message code="wallet.accountInformation" /></div>
									<div class="text-block-183"><spring:message code="newwave.wallet.d_info" /></div>
								</div>
								<div class="tablewrap4-2">
									<div class="dtitle-2"><spring:message code="newwave.wallet.requestedA" /></div>
									<div class="tablewrap-2">
										<input type="text" class="text-field4 w-input" maxlength="256"
											name="depositMoney" data-name="Field 2" placeholder="0"
											id="depositMoney" required="" readonly
											style="background-color: rgba(0, 0, 0, 0.22)">
										<div class="pbtnwrap">
											<a href="#" money="10000" class="moneyck pbtn-2 w-button">1<spring:message code="newwave.wallet.currency" /></a> <a
												href="#" money="100000" class="moneyck pbtn-2 w-button">10<spring:message code="newwave.wallet.currency" /></a> <a
												href="#" money="1000000" class="moneyck pbtn-2 w-button">1<spring:message code="newwave.wallet.currency2" /></a> <a
												href="#" money="5000000" class="moneyck pbtn-2 w-button">5<spring:message code="newwave.wallet.currency2" /></a><a
												href="#" money="10000000" class="moneyck pbtn-2 w-button">1<spring:message code="newwave.wallet.currency3" /></a>
											<a href="#" money="-1" class="moneyck pbtn-2 reset w-button"><spring:message code="newwave.wallet.init" /></a>
										</div>
									</div>
								</div>
								<div class="tablewrap4-2">
									<h5 class="dtitle-2"><spring:message code="join.mname" /></h5> 
									<div class="tablewrap-2">
										<input type="text" class="text-field4-2 w-input" maxlength="256" name="depositName" id="depositName">
									</div>
								</div>
								<div class="tablewrap4-2">
									<h5 class="dtitle-2"><spring:message code="join.maccount" /></h5>
									<div class="tablewrap-2">
										<input type="text" class="text-field4-2 w-input" maxlength="256" name="depositAccount" id="depositAccount">
									</div>
								</div>
								
								<!-- <div class="deposit_warntxt">※ 1회 최대 300입금 무제한 ※</div> -->								
								<div class="div-block-306">
									<div class="dtitle-2" style="color: darkblue;"><spring:message code="newwave.wallet.d_guide" /></div>
									<div class="div-block-305">
										<div class="anotice2-2">
											<span class="text-span-62">○</span> <spring:message code="newwave.wallet.d_guide1" />
										</div>
										<div class="anotice2-2">
											<span class="text-span-62">○</span> <spring:message code="newwave.wallet.d_guide2" />
										</div>
										<div class="anotice2-2">
											<span class="text-span-62">○</span> <spring:message code="newwave.wallet.d_guide3" />
										</div>
										<div class="anotice2-2">
											<span class="text-span-62">○</span> <spring:message code="newwave.wallet.d_guide4" />
										</div>
									</div>
								</div>
								<div class="btnwrap-2">
									<%-- <a href="/wesell/user/contact.do?title=입금 계좌 문의" class="btn-2 w-inline-block">
										<div class="btntxt-2"><spring:message code="newwave.wallet.acc_inq" /></div>
									</a> --%> 
									<a href="javascript:depositSubmit()"
										class="btn2-2 w-inline-block">
										<div class="btntxt-2"><spring:message code="newwave.wallet.d_apply" /></div>
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
		<jsp:include page="../wesellFrame/footer2.jsp" />
	</div>
	<script
		src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=619ddb62800e4c70cba341a2"
		type="text/javascript"
		integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
		crossorigin="anonymous"></script>
	<script src="../js/webflow2.js" type="text/javascript"></script>
	<script>
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	function numberDeleteCommas(x) {
		return x.toString().replace(/\,/g, "");
	}
	
	var start = 0;
	$(".moneyck").click(function(){
		var money = parseInt($(this).attr("money"));
		
		if(money==-1){
			start = 0;
			$("#depositMoney").val("");
			$('.div-block-304 .mymoney-2:eq(1)').html('<span class="text-span-74"><spring:message code="newwave.wallet.actual" /> <spring:message code="wallet.menu.exchange" /> USDT</span>0 USDT');
		}
		else{
			start += money;
			$("#depositMoney").val(numberWithCommas(start));
			if(exRate) {
				$('.div-block-304 .mymoney-2:eq(1)').html('<span class="text-span-74"><spring:message code="newwave.wallet.actual" /> <spring:message code="wallet.menu.exchange" /> USDT</span>'+numberWithCommas((start/exRate).toFixed(2))+' USDT');	
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
		var depositName = $("#depositName").val();
		var depositAccount = $("#depositAccount").val();
		console.log("d:"+depositName+" "+depositAccount);
		var allData = { depositMoney : depositMoney, depositName : depositName, depositAccount : depositAccount};
		
		jQuery.ajax({
			type : "POST",
			data : allData,
			url : "/wesell/notLogDepositProcess.do",
			dataType : "json",
			success : function(data) {
				alert(data.msg);
				if (data.result == "suc") {
					/* location.href = "/wesell/user/kTransactions.do"; */
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
		$('.asset_value-2 .assettxt2').html(numberWithCommas(exRate)+' KRW = 1 USDT');
		$('.div-block-304 .mymoney-2:eq(0)').html('<span class="text-span-74">USDT <spring:message code="newwave.wallet.current" /> <spring:message code="wallet.marketPrice" /></span>'+numberWithCommas(exRate)+' KRW');
		if(start !== 0) {
			$('.div-block-304 .mymoney-2:eq(1)').html('<span class="text-span-74"><spring:message code="newwave.wallet.actual" /> <spring:message code="wallet.menu.exchange" /> USDT</span>'+numberWithCommas((start/exRate).toFixed(2))+' USDT');	
		}
		setTimeout(loadExcRate, 300000);
	}
	</script>
</body>
</html>