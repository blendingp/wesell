<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html data-wf-page="62b1ae939d93854bf256b403" data-wf-site="62b1125ac4d4d60ab9c62f81">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login</title>
<meta content="login" property="og:title">
<meta content="login" property="twitter:title">
<jsp:include page="../userFrame/header.jsp"></jsp:include>
</head>
<body class="influ_body">
	<div class="influ_frame">
		<div class="influ_logintop"></div>
		<div class="influ_loginblock">
			<div class="influ_login">
				<img src="/global/webflow/images/sub_logo1.svg" loading="lazy" alt="" class="image-50">
				<div class="influ_login_block">
					<div class="influ_title2">Login</div>
					<div class="form-block-10 w-form">
						<form id="loginFrm">
							<input type="hidden" name="country" value="82"/>
							<%-- <div class="influ_loginwarp">
								<div class="influ_title3"><spring:message code="join.phone"/></div>
								<div class="warp">
									<input type="text" class="text-field-17-copy w-input" placeholder="<spring:message code="join.phoneTxt"/>" name="phone" id="phone" onkeyup="enterkey();" > 
									<a href="javascript:sendRequest()" class="button-29 w-button"><spring:message code="join.request"/></a>
								</div>
							</div>
							<div class="influ_loginwarp">
								<div class="influ_title3"><spring:message code="join.code"/></div>
								<input type="text" class="text-field-17 w-input" name="code" id="code" onkeyup="enterkey();" placeholder="<spring:message code="join.code"/>">
							</div> --%>
							<div class="influ_loginwarp">
								<div class="influ_title3"><spring:message code="join.phone"/></div>
								<input type="text" class="text-field-17 w-input" placeholder="<spring:message code="join.phoneTxt"/>" name="phone" id="phone" onkeyup="enterkey();" >
							</div>
							<div class="influ_loginwarp">
								<div class="influ_title3"><spring:message code="join.pw" /></div>
								<input type="password" class="text-field-17 w-input" name="pw" id="pw" placeholder="<spring:message code="join.pWrong"/>" onkeyup="enterkey();">
							</div>
						</form>
					</div>
					<a href="javascript:login()" class="button-30 w-button"><spring:message code="menu.login"/></a>
				</div>
			</div>
		</div>
	</div>
	<%-- <div class="frame">
		<div class="form-block w-form">
			<form id="loginFrm" class="form">
				<div class="main_frame_influ">
					<div class="div-block-87">
						<div class="div-block-88">
							<div class="div-block-91">
								<div class="text-block-60">Login</div>
							</div>
							<div class="div-block-93">
								<div class="text-block-63"><spring:message code="join.phone"/></div>
								<div class="div-block-106">
									<input type="text" placeholder="<spring:message code="join.phoneTxt"/>" class="text-field-5-copy w-input" name="phone" id="phone" onkeyup="enterkey();" >
									<select name="country" id="country" class="countryselect2 w-select">
										<option value="82">+82</option>
										<option value="86">+86</option>
										<option value="81">+81</option>
										<option value="1">+1</option>
										<option value="7">+7</option>
										<option value="380">+380</option>
										<option value="49">+49</option>
										<option value="65">+65</option>
										<option value="84">+84</option>
									</select>
								</div>
							</div>
							<div class="div-block-99-copy">
								<a href="javascript:sendRequest()" class="button-13 w-button"><spring:message code="join.request"/></a>
							</div>
							<div class="div-block-95">
								<div class="div-block-94">
									<div class="text-block-61"><spring:message code="join.code"/></div>
								</div>
								<div class="div-block-177">
									<input type="text" class="text-field w-input" name="code" id="code" onkeyup="enterkey();" placeholder="<spring:message code="join.code"/>">
									<div class="div-block-178">
										<a href="#" class="button-25 w-button">확인</a>
									</div>
								</div>
							</div>
							<div class="div-block-96">
								<div class="text-block-62"><spring:message code="join.pw" /></div>
								<input type="password" name="pw" id="pw" class="text-field w-input" placeholder="<spring:message code="join.pWrong"/>">
							</div>
							<div class="div-block-97">
								<a href="javascript:login()" class="button-13 w-button"><spring:message code="menu.login"/></a>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div> --%>
	<script
		src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93"
		type="text/javascript"
		integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
		crossorigin="anonymous"></script>
	<script src="/global/webflow/js/webflow.js" type="text/javascript"></script>
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script type="text/javascript">
		var lang = "${lang}";
		function changeLang() {
			var clang = "KO";
			if(lang == "KO")
				clang = "EN";
			
			$.ajax({
				type : 'post',
				url : '/global/changeLanguage.do?lang=' + clang,
				success : function(data) {
					location.reload(true);
				}
			});
		}

		function login(){
/* 			if(!checkPhone){
				alert("휴대폰 인증이 필요합니다.")
				return false;
				
			} */
			/* var data = $("#loginFrm").serialize(); */
			var formData = new FormData($('#loginFrm')[0]);
			//formData.append("checkPhone" , checkPhone+"");
			$.ajax({
				type :'post',
				data : formData ,
				url : '/global/infl/loginProcess.do',
			 	contentType: false,
			 	processData: false,				
				success:function(data){
					alert(data.msg);
					if(data.result == 'success'){
						//location.href = '/global/infl/home.do';
						location.href = '/global/infl/memberlist.do';
					}
				}
			})
		}
		var checkPhone = false;
		function sendRequest(){
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
			})
		}
		function comingSoon(){
			alert("준비중입니다");
		}
		function enterkey() {
	        if (window.event.keyCode == 13) {
	        	login();
	        }
		}
	</script>
</body>
</html>