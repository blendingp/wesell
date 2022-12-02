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
	document.listForm.fileDown.value = "0";
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
					<h1 class="h3 mb-2 text-gray-800">balance 실행내역</h1>
					<div class="card shadow mb-4">
						<div class="card-body">
							<form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/log/manipullog.do" name="listForm" id="listForm">
								<input type="hidden" name="fileDown" id="fileDown" value="0" />
								<input type="hidden" name="pageIndex" value="1" /> 
								<input type="hidden" name="coin" id="coin" value="${coin}" />
								<div class="row">
									<div class="col-lg-4">
										<label>기간 검색</label>
										<div class="form-group input-group">
											<input type="date" name="sdate" id="sdate" value="${sdate}" class="form-control" style="width: 45%; display: inline-block;" autocomplete="off">
												 ~ 
											<input type="date" name="edate" id="edate" value="${edate}" class="form-control" style="width: 45%; display: inline-block;" autocomplete="off">
											<button class="btn btn-default" style="padding: 6px 12px;" type="submit"> <i class="fa fa-search"></i> </button>
										</div>
									</div>
									<div class="col-lg-2">
										<label>종목</label>
										<div class="form-group input-group">
											<span class="input-group-btn" style="white-space: normal;">
												<button class="btn btn-light btn-icon-split" onclick="setSymbol('')" type="button">전체</button>
												<c:forEach var="c" items="${useCoin}" varStatus="i">
													<button class="btn btn-light btn-icon-split" onclick="setSymbol('${c}')" type="button">${c}</button>
												</c:forEach>
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
											<th>번호</th>
											<th>admin</th>
											<th>코인</th>
											<th>발동시 시세</th>
											<th>발동가</th>
											<c:if test="${project.name ne 'byflow'}">
												<th>변동가</th>
											</c:if>
											<th>발동 시간</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr style="background-color:${item.color}">
												<td>${item.idx}</td>
												<td><c:if test="${empty item.id}">정보없음</c:if>${item.id}</td>
												<td>${item.coin}</td>
												<td><c:if test="${empty item.nowPrice}">정보없음</c:if><fmt:formatNumber value="${item.nowPrice}" pattern="#,###.#####"/></td>
												<td><fmt:formatNumber value="${item.price}" pattern="#,###.#####"/></td>
												<c:if test="${project.name ne 'byflow'}">
													<td><fmt:formatNumber value="${item.gap}" pattern="#,###.#####"/></td>
												</c:if>
												<td><fmt:formatDate value="${item.rtime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
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
function setSymbol(val){
	$("#coin").val(val);
	checkForm();
}

function checkForm(file){
	$("#fileDown").val(0);
	
	if(file != null && file != ""){
		if(file == 1)
			$("#fileDown").val(1);
	}
	
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