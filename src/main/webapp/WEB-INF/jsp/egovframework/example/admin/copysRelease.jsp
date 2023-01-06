<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../adminFrame/header.jsp"></jsp:include>
</head>
<body>
	<div id="wrapper">
		<jsp:include page="../adminFrame/top.jsp"></jsp:include>
		<c:import url="/admin/left.do"/>
		<div id="page-wrapper">
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-heading">카피트레이드 일괄 해제</div>
						<div class="panel-body">
							<form id="listForm">
								<div class="row">
									<div class="col-lg-3">
										<label>트레이더 시작</label> 
										<input type="text" name="tidx">
									</div>
								</div>
								<div class="row">
									<div class="col-lg-3">
										<label>count</label> 
										<input type="text" name="count">
									</div>
								</div>
							</form>
							<button onclick="release();">팔로워 해제</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
</body>
<script>
function checkForm(level){
	$("#listForm").submit();
}
function release(){
	if(confirm("하위 팔로워를 해제하시겠습니까?")){
		var data = $("#listForm").serialize();
		console.log(data);
		$.ajax({
			type:'post',
			data: data ,
			url:'/wesell/admin/copysReleaseProcess.do',
			success:function(data){
				alert(data.msg);
				if(data.result == "suc")
					location.reload();
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
}
</script>
</html>