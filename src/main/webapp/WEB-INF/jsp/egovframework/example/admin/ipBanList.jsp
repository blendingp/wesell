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
					<h1 class="h3 mb-2 text-gray-800">IP 차단 목록</h1>
					<div class="card shadow mb-4">
						<div class="card-body">
							<form action="/wesell/admin/user/ipBanList.do"
								name="listForm" id="listForm">
								<div class="row">
									<input type="hidden" name="pageIndex" value="1" /> <input
										type="hidden" id="ip" name="ip" />
									<div class="col-lg-3">
										<label>기간 검색</label>
										<div class="form-group input-group">
											<div>
												<input type="date" name="sdate" id="sdate" value="${sdate}"
													class="form-control"
													style="width: 45%; display: inline-block;"
													autocomplete="off"> ~ <input type="date"
													name="edate" id="edate" value="${edate}"
													class="form-control"
													style="width: 45%; display: inline-block;"
													autocomplete="off">
											</div>
										</div>
									</div>
									<div class="col-lg-3">
										<label>회원검색</label>
										<div class="form-group input-group">
											<input type="text" name="search" class="form-control"
												value="${search}"> <span class="input-group-btn">
												<button class="btn btn-default btn-sm" onclick="checkForm()"
													type="button">
													<i class="fa fa-search"></i>
												</button>
											</span>
										</div>
									</div>
								</div>
							</form>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-striped table-hover">
									<thead>
										<tr>
											<th>시간</th>
											<th>회원명</th>
											<th>ip</th>
											<th>해제</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr>
												<td><fmt:formatDate value="${item.bandate}"
														pattern="yyyy-MM-dd HH:mm" /></td>
												<td>${item.name}</td>
												<td>${item.ip}</td>
												<td>
													<button type="button"
														onclick="javascript:releaseBan('${item.ip}')"
														class="btn btn-primary">차단 해제</button>
												</td>
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
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
	function checkForm() {
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		if ((sdate == '' && edate != '') || (sdate != '' && edate == '')) {
			alert("조회시작기간과 조회종료기간을 설정해주세요.");
			return;
		}
		if (edate < sdate) {
			alert("조회종료기간이 조회시작기간보다 작을 수 없습니다.");
			return;
		}
		$("#listForm").submit();
	}

	function releaseBan(ip) {
		$("#ip").val(ip);
		console.log($("#ip").val());

		$.ajax({
			type : 'post',
			data : {
				"ip" : ip
			},
			url : '/wesell/admin/user/releaseBan.do',
			dataType : 'json',
			success : function(data) {
				alert(data.msg);
				if (data.result == 'success') {
					location.reload();
				}
			},
			error : function(e) {
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
</script>
</body>
</html>