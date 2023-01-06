<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../adminFrame/header.jsp"></jsp:include>
</head>
<body id="page-top">
	<div id="wrapper">
		<c:import url="/admin/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">하위관리자 생성</h1>
					<div class="row">
						<div class="col-lg-12">
							<div class="card shadow mb-4">
								<div class="card-header py-3">
									<h6 class="m-0 font-weight-bold text-primary">하위관리자 생성</h6>
								</div>
								<div class="card-body">
									<form name="insertForm" id="insertForm" method="post">
										<c:if test="${project.name eq 'wesell'}">
											<div class="form-group">
												<label>분류 </label> 
												<label class="radio-inline"> <input type="radio" name="level" value="2" checked="">권한 2</label>
												<label class="radio-inline"> <input type="radio" name="level" value="3">권한 3</label>
											</div>
										</c:if>
										<div class="row">
											<div class="col-lg-6">
												<div class="row">
													<div class="col-lg-12">
														<div class="form-group">
															<label>아이디</label> <input class="form-control"
																placeholder="ID" name="id" id="id" maxlength="20">
														</div>
													</div>
												</div>
												<div class="row">
													<div class="col-lg-12">
														<div class="form-group">
															<label>비밀번호</label> <input type="password"
																class="form-control" placeholder="Password" name="pw"
																id="pw" maxlength="50">
														</div>
													</div>
												</div>
												<div class="row">
													<div class="col-lg-12">
														<div class="form-group">
															<label>인증키</label> *미입력 시 로그인 불가 <input type="password"
																class="form-control" placeholder="Password"
																name="authkey" id="authkey" maxlength="50">
														</div>
													</div>
												</div>
											</div>
										</div>
									</form>
								</div>
							</div>
							<button type="button" onclick="javascript:insertProcess()"
								class="btn btn btn-secondary">하위관리자 생성</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
	function insertProcess() {
		var data = $("#insertForm").serialize();
		var url = "/wesell/admin/subAdminInsert.do";
		$.ajax({
			type : 'post',
			url : url,
			data : data,
			success : function(data) {
				if (data.result == 'success') {
					alert("하위관리자 생성이 완료되었습니다.");
					location.reload();
				} else {
					alert(data.msg);
				}
			},
			error : function(e) {
				console.log('ajaxError' + e);
			}
		});
	}
</script>
</body>
</html>