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
<style>
.btn.btn-primary{
	word-break:keep-all;
}
</style>
<body id="page-top">
	<div id="wrapper">
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">하위관리자</h1>
					<button type="button" style="margin-bottom: 10px;"
						onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/createSubAdmin.do'"
						class="btn btn-primary">하위관리자 생성</button>
					<div class="row">
						<div class="col-lg-12">
							<div class="card shadow mb-4">
								<div class="card-header py-3">
									<h6 class="m-0 font-weight-bold text-primary">하위 관리자</h6>
								</div>
								<!-- /.panel-heading -->
								<div class="card-body">
									<div class="table-responsive">
										<table class="table table-striped">
											<thead>
												<tr>
													<th>권한</th>
													<th>아이디</th>
													<th>비밀번호</th>
													<th>인증키</th>
													<th>삭제</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="item" items="${list}" varStatus="i">
													<tr>
														<td>${item.level}</td>
														<td>
															<div style="display: flex">
																<input type="text" class="form-control"
																	placeholder="Password" name="id" id="id${item.idx}"
																	value="${item.id }" maxlength="50">
																<button type="button" onclick="changeId(${item.idx})"
																	class="btn btn-primary">저장</button>
															</div>
														</td>
														<td>
															<div style="display: flex">
																<input type="text" class="form-control"
																	placeholder="Password" name="pw" id="pw${item.idx}"
																	value="${item.pw }" maxlength="50">
																<button type="button" onclick="changePw(${item.idx})"
																	class="btn btn-primary">저장</button>
															</div>
														</td>
														<td>
															<div style="display: flex">
																<input type="text" class="form-control"
																	placeholder="Password" name="authkey"
																	id="authkey${item.idx}" value="${item.authkey }"
																	maxlength="50">
																<button type="button"
																	onclick="changeAuthkey(${item.idx})"
																	class="btn btn-primary">저장</button>
															</div>
														</td>
														<td><button type="button"
																onclick="adminDel(${item.idx})" class="btn btn-danger">삭제</button></td>
													</tr>
												</c:forEach>
											</tbody>
										</table>
									</div>
									<div class="row">
										<div class="col-sm-12" style="text-align: center;">
											<ul class="pagination">
												<ui:pagination paginationInfo="${pi}" type="customPage"
													jsFunction="page" />
											</ul>
										</div>
									</div>
								</div>
								<!-- /.panel-body -->
							</div>
						</div>
						<!-- /.panel -->

						<%-- <input type="hidden" name="page" id="page" value="${em.page}"/> --%>
					</div>
					<!-- /.row -->
					<form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/subAdminList.do"
						name="listForm" id="listForm">
						<input type="hidden" name="pageIndex" value="1" />
					</form>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
function adminDel(idx){
	if(confirm("삭제하시겠습니까? 복구하실수없습니다.")){
		$.ajax({
			type:'get',
			url:'/wesell/0nI0lMy6jAzAFRVe0DqLOw/deleteSubAdmin.do?idx='+idx,
			success:function(data){
				alert(data.msg);
				location.reload();
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
}
function changeId(idx){
	var id = $("#id"+idx).val();
	$.ajax({
		type:'get',
		url:'/wesell/0nI0lMy6jAzAFRVe0DqLOw/setId.do?idx='+idx+"&id="+id,
		success:function(data){
			alert(data.msg);
			location.reload();
		},
		error:function(e){
			console.log('ajax Error ' + JSON.stringify(e));
		}
	})
}
function changePw(idx){
	var pw = $("#pw"+idx).val();
	$.ajax({
		type:'get',
		url:'/wesell/0nI0lMy6jAzAFRVe0DqLOw/setPassword.do?idx='+idx+"&pw="+pw,
		success:function(data){
			alert(data.msg);
			location.reload();
		},
		error:function(e){
			console.log('ajax Error ' + JSON.stringify(e));
		}
	})
}
function changeAuthkey(idx){
	var authkey = $("#authkey"+idx).val();
	$.ajax({
		type:'get',
		url:'/wesell/0nI0lMy6jAzAFRVe0DqLOw/changeAuthkey.do?idx='+idx+"&authkey="+authkey,
		success:function(data){
			alert(data.msg);
			location.reload();
		},
		error:function(e){
			console.log('ajax Error ' + JSON.stringify(e));
		}
	})
}
function page(pageNo){
	document.listForm.pageIndex.value = pageNo;
   	document.listForm.submit();
}
</script>
</body>
</html>