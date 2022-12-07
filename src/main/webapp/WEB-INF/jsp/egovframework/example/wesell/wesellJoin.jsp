<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<!--  This site was created in Webflow. http://www.webflow.com  -->
<!--  Last Published: Thu Oct 21 2021 06:43:44 GMT+0000 (Coordinated Universal Time)  -->
<html data-wf-page="6344e745b7a4c981c4be68a6" data-wf-site="6344e745b7a4c962c3be683c" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
</head>
<body class="body1">
	<form id="joinFrm" class="form-5">
		<div class="frame">
			<jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
			<div class="frame4 regist" >
				<div class="login_block">
					<div class="loginblock" style="display:flex;"><img src="/wesell/webflow/images2/main_logo1.svg" loading="lazy" data-w-id="ea9f9d47-59cb-1533-1095-666329c4628b" alt="" class="login_logo">
						<div class="title4"><spring:message code="menu.register" /></div>
						<div class="w-form">
							<div class="regist_btnwarp">
								<input type="hidden" name="joinKind" id="joinKind" value="setphone"/>
								<a href="javascript:setAuth('setphone')" class="button-65 w-button click setphonebtn"><spring:message code="join.phoneauth" /></a> 
								<a href="javascript:setAuth('setemail')" class="button-65 w-button setemailbtn"><spring:message code="join.emailauth" /></a>
							</div>
							<label class="title5"><spring:message code="join.name" /></label>
							<input type="text" class="text-field-10 w-input" maxlength="30" name="name" placeholder="<spring:message code="join.nameTxt"/>" id="name"> 
							
							<label for="name" class="title5 setphone"> <spring:message code="join.phone" /></label>
							<div class="loginbox setphone">
								<input type="text" onkeyup="SetNum(this)" class="text-field-9 w-input" maxlength="12" name="phone"	placeholder="<spring:message code="join.phoneTxt"/>" id="phone">
								<a href="javascript:sendRequestPhone()" class="button-10 w-button"> <spring:message code="join.request" /></a>
							</div>
							<label class="title5 setemail" style="display:none"><spring:message code="join.email" /></label>
							<div class="loginbox setemail" style="display:none">
								<input type="text" class="text-field-9 w-input" maxlength="30" name="email" id="email" placeholder="<spring:message code="join.emailTxt"/>"> 
								<a href="javascript:sendRequestEmail()" class="button-10 w-button">
									<spring:message code="join.request" />
								</a>
							</div>
							
							<label class="title5"><spring:message code="join.pw" /></label> 
							<input type="password" class="text-field-10 w-input" maxlength="20" name="pw" placeholder="<spring:message code="join.pWrong"/>" id="pw">
							<div class="warn_login"><spring:message code="join.pwTerms"/></div>
							<label class="title5">
							<spring:message code="join.pwConfirm" /></label> 
							<input type="password" class="text-field-10 w-input" maxlength="20" placeholder="<spring:message code="join.pwConfirm"/>" id="pwConfirm">
						</div>
						<div class="title5">
							<spring:message code="join.invite" />
						</div>
						<input type="text" class="text-field-10 w-input" maxlength="10" name="inviteCode" placeholder="<spring:message code="join.inviteTxt"/>" value="${invi}"> 
						
						<%-- <label for="email-4" class="title5">
							<spring:message code="join.maccount"/>(<spring:message code="join.mbank"/>)
						</label>
						<div class="loginbox">
							<input type="email" class="text-field-9 w-input" maxlength="256"
								name="account" data-name="Email 4" placeholder="<spring:message code="join.inputMaccount"/>"
								id="account" required=""><select id="bank" name="bank"
								data-name="Field" class="select-field-7 w-select">
								<option value=""><spring:message code="newwave.support.select"/></option>
								<option value="카카오뱅크">카카오뱅크</option>
								<option value="국민은행">국민은행</option>
								<option value="기업은행">기업은행</option>
								<option value="농협은행">농협은행</option>
								<option value="신한은행">신한은행</option>
								<option value="산업은행">산업은행</option>
								<option value="우리은행">우리은행</option>
								<option value="한국씨티은행">한국시티은행</option>
								<option value="하나은행">하나은행</option>
								<option value="SC제일은행">SC제일은행</option>
								<option value="경남은행">경남은행</option>
								<option value="광주은행">광주은행</option>
								<option value="대구은행">대구은행</option>
								<option value="도이치">도이치</option>
								<option value="뱅크오브아메리카">뱅크오브아메리카</option>
								<option value="부산은행">부산은행</option>
								<option value="산림조합">산림조합</option>
								<option value="저축은행">저축은행</option>
								<option value="새마을금고">새마을금고</option>
								<option value="수협은행">수협은행</option>
								<option value="산협중앙회">산협중앙회</option>
								<option value="우체국">우체국</option>
								<option value="전북은행">전북은행</option>
								<option value="제주은행">제주은행</option>
								<option value="중국건설은행">중국건설은행</option>
								<option value="중국공상은행">중국공상은행</option>
								<option value="중국은행">중국은행</option>
								<option value="BNP파리바">BNP파리바</option>
								<option value="HSBC은행">HSBC은행</option>
								<option value="JP모간">JP모간</option>
								<option value="케이뱅크">케이뱅크</option>
								<option value="토스뱅크">토스뱅크</option>			
							</select>
						</div> --%>
						<label class="w-checkbox privacy_check">
							<input type="checkbox" id="calAgree" class="w-checkbox-input checkbox-5">
							<span class="w-form-label" for="calAgree"><spring:message code="join.calAgree"/></span>
						</label>
						<input onclick="join()" readonly style="padding: 8px 100px;"
							value="<spring:message code="join.apply" />"
							class="submit-button-2 w-button">
					</div>
				</div>
			</div>
		</div>
		<div class="registpop" id="phonePop" style="display: none">
			<div class="registpop_blcok">
				<div class="pop_exist">
					<img onclick="javascript:$('#phonePop').css('display', 'none')"
						src="/wesell/webflow/images2/wx.png" loading="lazy" alt=""
						class="image-38">
				</div>
				<div class="poptitle">
					<div class="title6">
						<spring:message code="join.authenticate" />
					</div>
				</div>
				<div class="w-form">
					<label for="name"><spring:message
							code="join.fillauthenticate" /></label>
					<div class="pop_input">
						<input type="text" class="text-field-18 w-input" maxlength="20"
							name="pCode" id="pCode"
							placeholder="<spring:message code="join.fillcode"/>"> <a
							href="javascript:sendRequestPhone()" class="button-32 w-button"><spring:message code="join.rerequest" /></a>
					</div>
				</div>
				<div class="auth_count"><spring:message code="join.vtime"/> <span id="vtime">03:00</span></div>
				<div class="text-block-24">
					<spring:message code="join.3mincode" />
				</div>
				<div class="pop_btn">
					<a href="javascript:$('#phonePop').css('display', 'none')"
						class="button-15-copy w-button"><spring:message
							code="join.cancelcode" /></a> <a href="javascript:checkCodePhone()"
						class="button-15 w-button" style="text-align: center;"><spring:message
							code="join.comfcode" /></a>
				</div>
			</div>
		</div>
		<div class="registpop" id="emailPop" style="display: none">
			<div class="registpop_blcok">
				<div class="pop_exist">
					<img onclick="javascript:$('#emailPop').css('display', 'none')"
						src="/wesell/webflow/images2/wx.png" loading="lazy" alt=""
						class="image-38">
				</div>
				<div class="poptitle">
					<div class="title6">
						<spring:message code="join.authenticate" />
					</div>
				</div>
				<div class="w-form">
					<%-- 	<div class="text-block-100">
						<spring:message code="join.fillauthenticate" />
					</div> --%>
					<label for="name"><spring:message
							code="join.fillauthenticate" /></label>
					<div class="pop_input">
						<input type="text" class="text-field-18 w-input" maxlength="20"
							name="eCode" id="eCode"
							placeholder="<spring:message code="join.fillcode"/>"> <a
							href="javascript:sendRequestEmail()" class="button-32 w-button"><spring:message
								code="join.rerequest" /></a>
					</div>
				</div>
				<div class="text-block-24">
					<spring:message code="join.3mincode" />
				</div>
				<div class="pop_btn">
					<a href="javascript:$('#emailPop').css('display', 'none')"
						class="button-15-copy w-button"><spring:message
							code="join.cancelcode" /></a> <a href="javascript:checkCodeEmail()"
						class="button-15 w-button" style="text-align: center;"><spring:message
							code="join.comfcode" /></a>
				</div>
				<div class="welcomepop">
					<div class="registpop_blcok">
						<div class="pop_exist">
							<img src="/wesell/webflow/images2/wx.png" loading="lazy" alt=""
								class="image-38">
						</div>
						<div class="poptitle welcome">
							<div class="title6">
								<spring:message code="pop.welcome_1" />
							</div>
							<div>
								<div class="welecomeblock">
									<div class="text-block-26">
										<spring:message code="pop.loui_1" />
										<br>
										<spring:message code="pop.loui_2" />
									</div>
								</div>
							</div>
							<%-- <div class="welcomebtn">
							<a href="#" class="citationbtn3 w-button"><spring:message code="pop.close"/></a>
						</div> --%>
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
	</form>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="	crossorigin="anonymous"></script>
	<script src="/wesell/webflow/js/webflow2.js" type="text/javascript"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script type="text/javascript">
		function SetNum(obj) {
			val = obj.value;
			re = /[^0-9]/gi;
			obj.value = val.replace(re, "");
		}
		function SetText(obj) {
			val = obj.value;
			re = /[^ㄱ-ㅎ|가-힣|a-z|A-Z]/gi;
			//obj.value=val.replace(re,"");
		}
		var checkPhone = false;
		var sendingPhone = false;
		function sendRequestPhone() {
			if (sendingPhone)
				return;
			sendingPhone = true;
			$.ajax({
				type : 'post',
				data : {
					'phone' : $("#phone").val()
				},
				url : '/wesell/verificationPhoneJoin.do',
				success : function(data) {
					sendingPhone = false;
					alert(data.msg);
					if (data.result == 'success') {
						$("#phonePop").css("display", "flex");
						vCountStart(3);
					}
				}
			})
		}
		function checkCodePhone() {
			if(!vstart){
				alert("<spring:message code='join.phoneconfirm'/>");
				return;
			}
			$.ajax({
				type : 'post',
				data : {
					'pCode' : $("#pCode").val()
				},
				url : '/wesell/checkPhoneCode.do',
				success : function(data) {
					alert(data.msg);
					if (data.result == 'success') {
						checkPhone = true;
						$("#phonePop").css("display", "none");
					}
				}
			})
		}
		var sendingEmail = false;
		var checkEmail = false;
		function sendRequestEmail() {
			if (sendingEmail)
				return;
			sendingEmail = true;
			$.ajax({
				type : 'post',
				data : {
					'email' : $("#email").val()
				},
				url : '/wesell/verificationEmailJoin.do',
				success : function(data) {
					sendingEmail = false;
					alert(data.msg);
					if (data.result == 'success') {
						$("#emailPop").css("display", "flex");
					}
				}
			})
		}
		function checkCodeEmail() {
			$.ajax({
				type : 'post',
				data : {
					'eCode' : $("#eCode").val()
				},
				url : '/wesell/checkEmailCode.do',
				success : function(data) {
					alert(data.msg);
					if (data.result == 'success') {
						checkEmail = true;
						$("#emailPop").css("display", "none");
					}
				}
			})
		}
		var joining = false;
		function join() {			
			if (joining)
				return;
			
			if (!checkPhone && !checkEmail) {				
				alert("<spring:message code='join.phoneconfirmOrEmail'/>");
				return false;
			}

			/* if (!checkEmail) {
				alert("<spring:message code='join.emailconfirm'/>");
				return false;
			} */
			if ($("#pw").val() != $("#pwConfirm").val()) {
				alert("<spring:message code='join.jpWrong'/>")
				return false;
			}
			
			if(!chkPW()){
				return false;
			}
			
			if(!$("#calAgree").is(":checked")){
				alert("<spring:message code='join.calAgree_msg'/>")
				return false;
			}
			
			/* if ($("#account").val().length < 1) {
				alert("<spring:message code='join.wrAccount'/>")
				return false;
			}
			if ($("#bank").val().length < 1) {
				alert("<spring:message code='join.inputMbank'/>")
				return false;
			} */
			joining = true;
			var data = $("#joinFrm").serialize();
			
			$.ajax({
				type : 'post',
				data : data,
				url : '/wesell/joinProcess.do',
				success : function(data) {
					joining = false;
					alert(data.msg);
					if (data.result == 'success') {
						location.href = "/wesell/login.do";
					}
				}
			})
		}
		
		function chkPW() {
		    var pw = String($("#pw").val());
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
		
		function setAuth(kind){
			$("#joinKind").val(kind);
			$(".setphone").css("display", "none");
			$(".setemail").css("display", "none");
			$("."+kind).css("display", "flex");
			
			$(".setphonebtn").removeClass("click");
			$(".setemailbtn").removeClass("click");
			$("."+kind+'btn').addClass("click");
		}
	</script>
</body>
</html>