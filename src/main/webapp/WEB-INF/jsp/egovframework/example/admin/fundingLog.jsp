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
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">${coin}펀딩 로그</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">funding log</h6>
						</div>
						<div class="card-body">
							<form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/log/fundingLog.do"
								name="listForm" id="listForm">
								<div class="row">
									<input type="hidden" name="pageIndex" value="1" /> <input
										type="hidden" name="coin" value="${coin}" />
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
										<label>검색어</label>
										<div class="form-group input-group">
											<input type="text" name="search" class="form-control"
												value="${search}" placeholder="이름 / 등급  "> <span
												class="input-group-btn">
												<button class="btn btn-default" style="padding: 6px 12px;"
													onclick="checkForm()" type="button">
													<i class="fa fa-search"></i>
												</button>
											</span>
										</div>
									</div>
									<div class="col-lg-4" style="width: fit-content;">
										<div class="form-group input-group">
											<pre style="margin-top: 20px;">&nbsp; 총 펀딩비 합 : <fmt:formatNumber
													value="${fundingFeeSum}" pattern="#,###.########" /> ${coin}</pre>
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
											<th>이름</th>
											<th>등급</th>
											<th>심볼</th>
											<th>포지션</th>
											<th>펀딩비</th>
											<th>날짜</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr style="background-color:${item.color}">
												<td
													onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.userIdx}'"
													style="cursor: pointer;">${item.name}</td>
												<td>${item.level}</td>
												<td>${item.symbol}</td>
												<td>${item.position}</td>
												<td><fmt:formatNumber value="${item.fundingFee}"
														pattern="#,###.########" /></td>
												<td><fmt:formatDate value="${item.fundDatetime}"
														pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></td>
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
function checkForm(){
	var sdate = $("#sdate").val();
	var edate = $("#edate").val();
	if((sdate == '' && edate != '') || (sdate != '' && edate == '')){
		alert("조회시작기간과 조회종료기간을 설정해주세요.");
		return;
	}
	if(edate < sdate){
		alert("조회종료기간이 조회시작기간보다 작을 수 없습니다.");
		return;
	}
	$("#listForm").submit();
}
</script>
</body>
</html>