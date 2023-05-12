<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html data-wf-page="6344e745b7a4c94a08be6840" data-wf-site="6344e745b7a4c962c3be683c">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>My Info</title>
<meta content="reward" property="og:title">
<meta content="reward" property="twitter:title">
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
</head>
<body class="body">
	<div class="frame">
		<form name="infoForm" id="infoForm" class="form-8">
			<input type="hidden" name="idx" id="idx" value="${info.idx}" /> 
			<input type="hidden" name="changePhone" id="changePhone" value="false" /> 
			<input type="hidden" name="changeEmail" id="changeEmail" value="false" /> 
			<input type="hidden" name="eCode" id="eCode" /> 
			<input type="hidden" id="copyInput" />
			<jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
			<div class="frame2">
				<div class="accountblock">
					<div class="title7"><spring:message code="join.info"/></div>
					<div class="form-block-8 w-form" style="margin-bottom:30px;">
							<%-- <div class="accountwarp">
								<div class="title3"><spring:message code="join.phone"/></div>
								<div class="accountbox2">
									<input type="text" class="text-field-15 w-input w100" maxlength="15" name="phone" onkeyup="check(this)" value="${info.phone}" id="phone"> 
									<a href="javascript:sendRequest()" class="button-20 w-button" style="display:none;" id="phoneBtn"><spring:message code="join.request"/></a>
								</div>
								<div class="accountbox2" id="verification" style="display:none; margin-bottom:0.5vw;">
									<input type="text" class="text-field-15 certification w-input" onkeyup="numCheck(this)"  name="code" id="code">
									<a href="javascript:phoneCodeCheck()" class="button-20 w-button"><spring:message code='affiliate.check'/></a>
								</div>
							</div> --%>
						
						<div class="accountwarp">
							<div class="title3">UID</div>
					 		<div class="warp1">
								<div class="text-block-31 nochange nobtn">14301${info.idx}</div>
							</div>
							
							<c:if test="${info.phone ne ''}">
								<div class="title3"><spring:message code="join.phone"/></div>
						 		<div class="warp1">
									<div class="text-block-31 nochange nobtn">${info.phone}</div>
								</div>
							</c:if>
							<c:if test="${info.phone eq ''}">
								<div class="title3"><spring:message code="join.email"/></div>
						 		<div class="warp1">
									<div class="text-block-31 nochange nobtn">${info.email}</div>
								</div>
							</c:if>
							<%-- <c:if test="${info.level ne 'user'}">
								<div class="title3"><spring:message code="join.invite"/></div>
								<div class="warp1">
									<div class="text-block-31 nochange">${info.inviteCode}</div>
									<a href="javascript:inviteCopy()" class="button-38 w-button">LINK</a>
								</div>
							</c:if>
							<div class="accountwarp">
 								<div class="title3"><spring:message code="join.email"/></div>
								<div class="accountbox2">
 									<input type="text" style="background-color:#2d333a; width:100%;" disabled onkeyup="emailCheck(this)" class="text-field-15 w-input" name="email" value="${info.email}" id="email">
 									<a href="javascript:sendRequestEmail()" <c:if test="${info.emailconfirm eq '1'}">style="display:none;"</c:if> id="emailVerification" class="button-20 w-button"><spring:message code="join.request"/></a>
								</div>
 								<div class="accountbox2" id="inputEmailCode" style="<c:if test="${info.emailconfirm eq '1'}">display:none;</c:if> margin-bottom:0.5vw;">
 								<input type="text" class="text-field-14 certification w-input"  name="emailCode" onkeyup="numCheck(this)" value="<spring:message code="affiliate.verification"/>"  id="emailCode" >
 								</div>
							</div>
							
							<div class="title3"><spring:message code="join.email"/></div>
							<div class="warp1">
								<div class="text-block-31 nochange nobtn">${info.email }</div>
							</div> --%>
							
							<div class="title3"><spring:message code="join.name"/></div>
							<div class="warp1">
								<div class="text-block-31 nochange nobtn">${info.name}</div>
							</div>
							
							<%-- <div class="title3"><spring:message code="join.level"/></div>
							<div class="warp1">
								<c:if test="${info.level eq 'user'}">
									<div class="text-block-31 nochange nobtn">${info.level}</div>
								</c:if>
								<c:if test="${info.level ne 'user'}">
									<div class="text-block-31 nochange">${info.level}</div>
									<a href="/wesell/infl/login.do" target="_blank" class="button-38 w-button">PARTNER</a>
								</c:if>
							</div>
							<div class="title3"><spring:message code="menu.wallet"/></div>
							<div class="warp1">
								<div class="text-block-31 nochange nobtn"><fmt:formatNumber value="${info.wallet}" pattern="#,###.####"/> USDT</div>
							</div> --%>
							
							<div class="title3"><spring:message code="join.date"/></div>
							<div class="warp1">
								<div class="text-block-31 nochange nobtn"><fmt:formatDate value="${info.joinDate}" pattern="yyyy-MM-dd" /></div>
							</div>
							
							<div class="title3"><spring:message code="trade.trade"/> <spring:message code="wallet.fee"/></div>
							<div class="warp1">
								<div class="text-block-31 nochange nobtn"><fmt:formatNumber value="${feeRate * 100}" pattern="#.####" />%</div>
							</div>
					</div>
						
							<div class="accountwarp" id="veriWarp">
								<div class="title3"><spring:message code="join.resetPW"/></div>
								<div class="accountbox2">
									<input type="text" class="text-block-31 nochange" maxlength="15" name="phone" onkeyup="check(this)" value="${info.phone}" readonly="" id="phone">
									<a href="javascript:sendRequest()" class="button-20 w-button" style="display:flex;" id="phoneBtn"><spring:message code="join.request"/></a>
								</div>
								<div class="accountbox2" id="verification" style="display:none; margin-bottom:0.5vw;">
									<input type="text" class="text-field-15 certification w-input" onkeyup="numCheck(this)"  name="code" id="code">
									<a href="javascript:phoneCodeCheck()" class="button-20 w-button"><spring:message code='affiliate.check'/></a>
								</div>
							</div>
								
							<div class="accountwarp" id="passWarp" style="display:none;">
								<div class="title3"><spring:message code="join.resetPW"/></div>
								<input type="password" class="text-field-15 hone w-input" maxlength="30" placeholder="<spring:message code="join.newPW"/>" id="changePw">
								<div class="accountbox2">
									<input type="password" class="text-field-15 certification w-input" maxlength="30" placeholder="<spring:message code="join.checkPW"/>" id="pwCheck">
									<a href="javascript:pwChange()" class="button-20 w-button"><spring:message code='trade.apply'/></a>
								</div>
							</div>
							
							<div class="accountwarp">
								<div class="title3">*<spring:message code="wallet.p2p.bankText"/></div>
								<div class="title3"><spring:message code="join.mbank"/></div>
								<div class="accountbox2">
									<input type="text" class="text-field-15 hone w-input" maxLength="30" value="${info.mbank}" id="bank"> 
									<a href="javascript:updateBankInfo('bank')" class="button-20 w-button" style="display:flex;"><spring:message code="trade.apply"/></a>
								</div>
								<div class="title3"><spring:message code="join.maccount"/></div>
								<div class="accountbox2">
									<input type="text" class="text-field-15 certification w-input" value="${info.maccount}" maxLength="30" onInput="numCheck(this)" id="account">
									<a href="javascript:updateBankInfo('account')" class="button-20 w-button"><spring:message code='trade.apply'/></a>
								</div>
							</div>
<!-- 							<div class="accountwarp"> -->
<%-- 								<div class="title3"><spring:message code="join.telegramLogin"/></div> --%>
<!-- 								<div class="accountbox2"> -->
<%-- 									<a href="#" onclick="$('#telegramPop').css('display','flex');" class="button-20 w-button"><spring:message code="affiliate.verification"/></a> --%>
<!-- 								</div> -->
<!-- 							</div> -->
					</div>
<!-- 					<div class="accountbtn"> -->
<%-- 						<a href="javascript:updateInfo()" class="button-21 w-button"><spring:message code="button.modify"/></a>  --%>
<%-- 						<a href="/wesell/user/myInfo.do" class="button-21-copy w-button"><spring:message code="wallet.cancel"/></a> --%>
<!-- 					</div> -->
					<img src="/wesell/webflow/images2/wallet-icon4.png" loading="lazy" alt="" class="asset_img">
				</div>
			</div>
		</form>
			<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
		
		<div class="registpop" id="telegramPop" style="display: none">
			<div class="registpop_blcok">
				<div class="pop_exist" style="cursor: pointer;">
					<img onclick="javascript:$('#telegramPop').css('display', 'none')" src="/wesell/webflow/images2/wx.png" loading="lazy" alt="" class="image-38">
				</div>
				<div class="poptitle">
					<div class="title6">
						<spring:message code="join.telegramLogin" />
					</div>
				</div>
				<div class="w-form">
					<label for="name"><spring:message code="affiliate.verification" /></label>
					<div class="pop_input">
						<input type="text" class="text-field-18 w-input" id="tCode" readonly style="background-color:transparent;"> 
						<a href="javascript:getTelegramCode()" class="button-32 w-button"><spring:message code="join.code" /></a>
					</div>
				</div>
				<div class="auth_count"><spring:message code="join.vtime"/> <span id="vtime">05:00</span></div>
				<div class="text-block-24">
					<spring:message code="join.3mincode" />
				</div>
			</div>
		</div>
	</div>

	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="/wesell/webflow/js/webflow2.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
	<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		var checkPhone = true;
		var checkEmail = true;
		var changePhone = false;
		var changeEmail = false;
		var originPhone = "${info.phone}";
		var originEmail = "${info.email}";
		var emailconfirm = "${info.emailconfirm}";
		var checkText = "<spring:message code='affiliate.check'/>";
		function numCheck(self) {
			let
			num = $(self);
			let
			re = /[^0-9]/gi;
			num.val(num.val().replace(re, ""));
		}
		function check(self) {
			if ($(self).attr("readonly") == "readonly") {
				return;
			}
			let
			phone = $(self);
			let
			re = /[^0-9]/gi;
			phone.val(phone.val().replace(re, ""));
			if (originPhone != phone.val()) {
				$("#verification").css("display", "flex");
				$("#phoneBtn").css('display', 'flex');
				checkPhone = false;
				changePhone = true;
				$(".emailnoti.phone").css("display", "flex");
				$("#phone").removeClass("w100");
			} else {
				$("#verification").css("display", "none");
				$("#phoneBtn").css('display', 'none');
				checkPhone = true;
				changePhone = false;
				$(".emailnoti.phone").css("display", "none");
				$("#phone").addClass("w100");
			}
		}
		function emailCheck(self) {
			if ($(self).attr("readonly") == "readonly") {
				return;
			}
			let
			email = $(self);
			if (emailconfirm == 0 || email.val() != originEmail) {
				$("#emailVerification").css("display", "flex");
				$(".emailnoti.email").css("display", "flex");
				$("#inputEmailCode").css("display", "flex");
				checkEmail = false;
				changeEmail = true;

			} else {
				$("#emailVerification").css("display", "none");
				$(".emailnoti.email").css("display", "none");
				$("#inputEmailCode").css("display", "none");
				checkEmail = true;
				changeEmail = false;
			}
		}

		function updateBankInfo(id) {
			$.ajax({
				type : 'post',
				data : {
					'kind' : id, 'value' : $("#"+id).val()
				},
				dataType : 'json',
				url : '/wesell/user/updateBankInfo.do',
				success : function(data) {
					alert(data.msg);
					if (data.result == "success") {
						location.reload();
					}
				},
				error : function(e) {
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}
		
		function sendRequest() {
			$.ajax({
				type : 'post',
				data : {
					'phone' : $("#phone").val()
				},
				dataType : 'json',
				url : '/wesell/user/verificationPhone.do',
				success : function(data) {
					alert(data.msg);
					if (data.result == "success") {
						$("#verification").css("display","flex");
						$("#phone").attr("readonly","true");
					}
				},
				error : function(e) {
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}
		function phoneCodeCheck() {
			if (changePhone && $("#code").val() == '') {
				alert("<spring:message code='pop.inputConfirmCode'/>");
				return false;
			}
			$.ajax({
				type : 'post',
				data : {
					'code' : $("#code").val(),
					'changeEmail' : changeEmail
				},
				dataType : 'json',
				url : '/wesell/user/verificationPhoneConfirm.do',
				success : function(data) {
					if (data.result == "success") {
						checkPhone = true;
						$("#veriWarp").css("display","none");
						$("#passWarp").css("display","block");
					}else{
						alert(data.msg);
					}
				},
				error : function(e) {
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}
		function sendRequestEmail() {
			if (!CheckEmail($("#email").val())) {
				alert("<spring:message code='pop.checkEmail'/>");
				return;
			}

			checkEmail = true;
			$.ajax({
				type : 'post',
				data : {
					'email' : $("#email").val()
				},
				dataType : 'json',
				url : '/wesell/user/verificationEmailUpdate.do',
				success : function(data) {
					alert(data.msg);
					// 					$("#email").attr("readonly","true");
					$("#emailVerification").html(checkText);
					$("#emailVerification").attr("href",
							"javascript:emailCodeCheck()")
					//changeEmail = true;
						
				},
				error : function(e) {
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}
		function emailCodeCheck() {
			if (changeEmail && $("#emailCode").val() == '') {
				alert("<spring:message code='pop.inputConfirmCode'/>");
				return false;
			}

			console.log("emailCodeCheck");

			$.ajax({
				type : 'post',
				data : {
					'emailCode' : $("#emailCode").val()
				},
				dataType : 'json',
				url : '/wesell/user/verificationEmailConfirm.do',
				success : function(data) {
					alert(data.msg);
					if (data.result == "success") {
						checkEmail = true;
						$("#email").attr("readonly", "true");
						$("#inputEmailCode").css("display", "none");
						$(".emailnoti.email").css("display", "none");
						$("#emailVerification").css("display", "none");
						//updateInfo();
					}
				},
				error : function(e) {
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}
		function CheckEmail(str) {
			var reg_email = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
			if (!reg_email.test(str)) {
				return false;
			} else {
				return true;
			}
		}
		function updateInfo() {
			if (!checkEmail) {
				alert("<spring:message code='join.emailconfirm'/>")
				return false;
			}
			if (!checkPhone) {
				alert("<spring:message code='join.phoneconfirm'/>")
				return false;
			}
			$("#changePhone").val(changePhone);
			$("#changeEmail").val(changeEmail);
			let
			data = $("#infoForm").serialize();
			$.ajax({
				type : 'post',
				data : data,
				url : '/wesell/user/updateMyInfo.do',
				success : function(data) {
					alert(data.msg);
					if (data.result == 'success') {
						location.reload();
					}
				},
				error : function(e) {
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}
		function inviteCopy() {
			$("#copyInput").attr("type", "text");
			$("#copyInput").val("https://wesell.com/wesell/join.do?invi=${info.inviteCode}");
			$("#copyInput").select();
			document.execCommand('Copy');
			$("#copyInput").attr("type", "hidden");
			alert("<spring:message code='pop.clipboard'/> ");
		}
		function pwChange() {
			let code = $("#code").val();
			let pw = $("#changePw").val();
			let pwCheck = $("#pwCheck").val();
			if(!chkPW()){
				return;
			}else if(pw != pwCheck){
				alert("<spring:message code='join.jpWrong'/>")
				return;
			}
			
			$.ajax({
				type : 'post',
				data : {"code":code, "pw":pw},
				url : '/wesell/user/changePW.do',
				success : function(data) {
					alert(data.msg);
					if (data.result == 'success') {
						location.reload();
					}
				},
				error : function(e) {
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}
		
		function chkPW() {
		    var pw = String($("#changePw").val());
		    var num = pw.search(/[0-9]/g);
		    var eng = pw.search(/[a-z]/ig);
		    var spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
		    if (pw.length < 8) {
		        alert("<spring:message code='join.pwTerms'/>");
		        return false;
		    } else if (pw.search(/\s/) != -1) {
		    	 alert("<spring:message code='join.pwTerms'/>");
		        return false;
		    } else if (num < 0 || eng < 0) {
		    	 alert("<spring:message code='join.pwTerms'/>");
		        return false;
		    } else {
		        return true;
		    }
		}

		let vstart = false;
		function vCountStart(min){
			if(vstart) return;
			vstart = true;
			var timer = min * 60;
			var minutes, seconds;
			var interval = setInterval(function () {
		        minutes = parseInt(timer / 60, 10);
		        seconds = parseInt(timer % 60, 10);

		        minutes = minutes < 10 ? "0" + minutes : minutes;
		        seconds = seconds < 10 ? "0" + seconds : seconds;

		        $("#vtime").text(minutes + ":" + seconds);

		        if (--timer < 0) {
		        	clearInterval(interval)
		        	vstart = false;
		        }
		    }, 1000);
		}
		
		function getTelegramCode(){
			$.ajax({
				type : 'post',
				url : '/wesell/user/getTelegramCode.do',
				success : function(data) {
					if (data.result == "suc") {
						$("#tCode").val(data.code);
						vCountStart(5);
					}
				}
			})
		}
	</script>
</body>
</html>