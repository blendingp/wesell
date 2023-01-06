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
<script>
function page(pageNo){
	document.listForm.pageIndex.value = pageNo;
   	document.listForm.submit();
}
</script>
<body id="page-top">
	<div id="wrapper">
		<c:import url="/admin/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">관리자 IP 설정</h1>
					<div class="row">
						<div class="col-lg-12">
							<div class="card shadow mb-4">
								<div class="card-header py-3">
									<h6 class="m-0 font-weight-bold text-primary">관리자 IP 설정</h6>
								</div>
								<div class="card-body">
									<label>IP 등록 ( 현재 접속 ip : ${myip} )</label>
									<div class="form-group input-group">
										<input class="form-control" id="ip" /> <span
											class="input-group-btn">
											<button type="button" onclick="javascript:insertIp()"
												class="btn btn-primary">등록</button>
										</span>
									</div>
								</div>
								<div class="card-body">
									<div class="table-responsive">
										<table class="table table-striped table-hover">
											<thead>
												<tr>
													<th>ip</th>
													<th>등록일</th>
													<th>삭제</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="item" items="${list}" varStatus="i">
													<tr>
														<td>${item.ip}</td>
														<td><fmt:formatDate value="${item.date}"
																pattern="yyyy-MM-dd HH:mm" /></td>
														<td>
															<button type="button" onclick="deleteIp(${item.idx})"
																class="btn btn-danger">삭제</button>
														</td>
													</tr>
												</c:forEach>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>

function insertIp(){
	var ip = $("#ip").val();
	console.log(ip);
	jQuery.ajax({
        type:"POST",
        url :"/wesell/admin/insertAdminIp.do?ip="+ip,
        dataType:"json",
        success : function(data) {
			alert(data.msg);
			location.reload();
        },
        complete : function(data) { },
        error : function(xhr, status , error){console.log("ajax ERROR!!! : " );}

      });	
}

function deleteIp(idx){
	if(!confirm("삭제하시겠습니까?")) return;
	
	console.log("ASAS");
	jQuery.ajax({
        type:"POST",
        url :"/wesell/admin/deleteAdminIp.do?idx="+idx,
        dataType:"json",
        success : function(data) {
			alert(data.msg);
			location.reload();
        },
        complete : function(data) { },
        error : function(xhr, status , error){console.log("ajax ERROR!!! : " );}

      });	
}
</script>
</body>
</html>