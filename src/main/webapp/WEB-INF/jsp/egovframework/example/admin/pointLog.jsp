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
					<h1 class="h3 mb-2 text-gray-800">USDT(FUTURES) 로그</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">point log</h6>
						</div>
						<div class="card-body">
							<form action="/wesell/admin/log/pointLog.do" name="listForm" id="listForm">
								<input type="hidden" name="fileDown" id="fileDown" value="0" />
								<div class="row">
									<input type="hidden" name="pageIndex" value="1" />
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
									<div class="col-lg-2">
										<label>종류</label> <select class="form-control input-group"
											name="ltype">
											<option <c:if test="${ltype eq ''}">selected</c:if> value="">전체</option>
											<option <c:if test="${ltype eq 'trade'}">selected</c:if>
												value="trade">거래 관련</option>
											<option <c:if test="${ltype eq 'deposit'}">selected</c:if>
												value="deposit">입출금, 교환</option>
											<option <c:if test="${ltype eq 'funding'}">selected</c:if>
												value="funding">펀딩</option>
											<option <c:if test="${ltype eq 'accumRef'}">selected</c:if>
												value="accumRef">레퍼럴</option>
											<%--                                             <option <c:if test="${ltype eq 'commission'}">selected</c:if> value="commission">레퍼럴</option> --%>
										</select>
									</div>
									<div class="col-lg-4">
										<label>검색어</label>
										<div class="form-group input-group">
											<input type="text" name="search" class="form-control"
												value="${search}" placeholder="이름 / 등급 / 변경Futures / 심볼 ">
											<span class="input-group-btn">
												<button class="btn btn-default" style="padding: 6px 12px;"
													onclick="checkForm(0)" type="button">
													<i class="fa fa-search"></i>
												</button>
											</span>
										</div>
									</div>
									<div class="col-lg-1">
										<label>엑셀</label>
										<div class="form-group input-group">
											<button type="button" onclick="checkForm(1)" class="btn btn-outline btn-success btn-sm"> EXCEL </button>
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
											<th>UID</th>
											<th>이름</th>
											<th>등급</th>
											<th>보유Futures</th>
											<th>변경 전 Futures</th>
											<th>변경 Futures</th>
											<th>변경 후 Futures</th>
											<th>Symbol</th>
											<th>기타</th>
											<th>날짜</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr style="background-color:${item.color}">
												<td>${item.midx}</td>
												<td onclick="location.href='/wesell/admin/user/userDetail.do?idx=${item.midx}'" style="cursor: pointer;">${item.name}</td>
												<td>${item.level}</td>
												<td><fmt:formatNumber value="${item.wallet}"
														pattern="#,###.########" /></td>
												<td><fmt:formatNumber value="${item.bfPoint}"
														pattern="#,###.########" /></td>
												<td><fmt:formatNumber value="${item.point}"
														pattern="#,###.########" /></td>
												<td><fmt:formatNumber value="${item.afPoint}"
														pattern="#,###.########" /></td>
												<td>${item.coinType}</td>
												<td><c:choose>
														<c:when test="${item.kind eq 'adDeposit' }">Admin 입금 </c:when>
														<c:when test="${item.kind eq 'adWithdrawal' }">Admin 출금 </c:when>
														<c:otherwise>${item.kind}</c:otherwise>
													</c:choose></td>
												<td><fmt:formatDate value="${item.pdate}"
														pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
							<div class="row">
								<div class="col-sm-12" style="text-align:center;">
									<ul class="pagination">
										<ui:pagination paginationInfo="${pi}" type="customPage" jsFunction="page"/>
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