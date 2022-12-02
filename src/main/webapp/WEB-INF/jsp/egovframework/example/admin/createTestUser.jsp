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
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">테스트 유저/총판 생성</h1>
					<div class="row">
						<div class="col-lg-12">
							<div class="card shadow mb-4">
								<div class="card-header py-3">
									<h6 class="m-0 font-weight-bold text-primary">테스트 유저/총판은
										휴대폰 인증 없이 로그인이 가능합니다.</h6>
								</div>
								<div class="card-body">
									<form name="insertForm" id="insertForm" method="post">
										<div class="row">
											<div class="col-lg-6">
												<div class="form-group">
													<label>계정 분류</label> <label class="radio-inline"> <input
														type="radio" name="isTest" value="1" checked="">테스트
														계정
													</label> <label class="radio-inline"> <input type="radio"
														name="isTest" value="0">실 계정
													</label>
												</div>
												<div class="row">
													<div class="col-lg-3">
														<div class="form-group">
															<label>등급</label> <select name="level"
																class="form-control input-sm">
																<option value="user">유저</option>
																<option value="chong">총판</option>
															</select>
														</div>
													</div>
													<div class="col-lg-9">
														<div class="form-group">
															<label>연락처</label> <input class="form-control"
																placeholder="Phone" name="phone" id="phone"
																maxlength="20">
														</div>
													</div>
												</div>
												<%-- 										<c:if test="${project eq 'newwave'}"> --%>
												<div class="row">
													<div class="col-lg-12">
														<div class="form-group">
															<label>ID</label> <input class="form-control"
																placeholder="ID" name="id" id="id">
														</div>
													</div>
												</div>
												<%-- 										</c:if> --%>
												<div class="row">
													<div class="col-lg-12">
														<div class="form-group">
															<label>이름</label> <input class="form-control"
																placeholder="Name" name="name" id="name">
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
															<label>초대코드</label> <input class="form-control"
																placeholder="Code" name="code" id="code" maxlength="10">
														</div>
													</div>
												</div>
											</div>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
					<button type="button" onclick="javascript:insertProcess()"
						class="btn btn btn-secondary">테스트 유저/총판 생성</button>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
	function insertProcess() {
		var data = $("#insertForm").serialize();
		var url = "/global/0nI0lMy6jAzAFRVe0DqLOw/user/insertTestUser.do";
		$.ajax({
			type : 'post',
			url : url,
			data : data,
			success : function(data) {
				if (data.result == 'success') {
					alert("완료되었습니다.");
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