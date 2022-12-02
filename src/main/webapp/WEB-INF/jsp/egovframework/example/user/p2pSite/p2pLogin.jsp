<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html data-wf-page="618388aa32debe327ad0f06c"
	data-wf-site="6180a71858466749aa0b95bc">
<head>
<meta charset="utf-8">
<jsp:include page="../../p2pSiteFrame/header.jsp"></jsp:include>
</head>
<body class="body">
	<div class="frame">
		<jsp:include page="../../p2pSiteFrame/top.jsp"></jsp:include>
		<div class="general_section wf-section"
			style="background-image: url(/global/webflow/p2pImages/backbox00.png);">
			<div class="container">
				<div class="login_block">
					<div class="loginblock">
						<img src="/global/webflow/p2pImages/LOGO_green2.svg" loading="lazy" data-w-id="043b0287-c101-a9b1-42dd-9b25d97e9d8a" alt="" class="login_logo">
						<div class="title4">로그인</div>
						<div class="w-form form-5">
							<label class="title5">UID</label>
							<input type="text" class="text-field-10 w-input" maxlength="10" placeholder="UID를 입력하세요" id="uid" name="uid">
							<label class="title5">비밀번호</label>
							<input type="text" class="text-field-10 w-input" maxlength="20" placeholder="비밀번호를 입력하세요" id="pw" name="pw">
<!-- 								<div class="login_pwtxt"> -->
<!-- 									<a href="#" class="login_pwbtn">아이디 찾기</a> / <a href="#" class="login_pwbtn">비밀번호 찾기</a> -->
<!-- 								</div> -->
							<button class="submit-button-2 w-button" onclick="login()">로그인</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../../p2pSiteFrame/footer.jsp"></jsp:include>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6180a71858466749aa0b95bc" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script>
	function login() {
		let uid = $("#uid").val();
		let pw = $("#pw").val();
		
		console.log("uid = "+uid+" / pw = "+pw);
		$.ajax({
			type : 'post',
			data : {"uid":uid,"pw":pw},
			url : '/global/easy/loginProcess.do',
			success : function(data) {
				if (data.result == 'suc') {
					location.href = "/global/easy/p2pmain.do";
				} else {
					console.log(data.msg);
					alert("회원 정보를 찾을 수 없습니다.");
				}
			}
		})
	}
	</script>
</body>
</html>