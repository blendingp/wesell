<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form id="registForm">
		<div>아이디:<input type="text" name="userId" id="userId"/></div>
		<div>비밀번호:<input type="text" name="userPw" id="userPw"/></div>
		<a href="javascript:login()">로그인</a>		
	</form>
	
	<script>
	//ajax
	function login(){
		let data = $("#registForm").serialize();
		$.ajax({
			type:'post',
			data : data,
			url : '/wesell/loginProcess2.do',
			success:function(data){
				alert("data.msg:"+data.msg);
				if(data.result == "fail"){
					$("#userId").val("");
					$("#userPw").val("");
				}else{
					location.href="/wesell/user/main.do";
				}
			}
		})
	}
	</script>
</body>
</html>
