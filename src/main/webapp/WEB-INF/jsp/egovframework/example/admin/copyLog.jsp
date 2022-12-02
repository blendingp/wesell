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
					<h1 class="h3 mb-2 text-gray-800">카피트레이드 트레이딩 로그</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">copytrade trading log</h6>
						</div>
						<div class="card-body">
							<form action="/global/0nI0lMy6jAzAFRVe0DqLOw/trader/copytradeLog.do" name="listForm" id="listForm">
								<input type="hidden" name="fileDown" id="fileDown" value="0" />
								<input type="hidden" name="pageIndex" value="1" /> 
								<input type="hidden" name="order" id="order" value="${order}" /> 
								<input type="hidden" name="orderAD" id="orderAD" value="${orderAD}" />
								<input type="hidden" name="symbol" id="symbol" value="${symbol}" />
								<div class="row">
									<div class="col-lg-3">
										<div class="form-group">
											<label>기간 검색</label>
											<div>
												<input type="date" name="sdate" id="sdate" value="${sdate}" class="form-control" style="width: 45%; display: inline-block;" autocomplete="off"> ~ 
												<input type="date" name="edate" id="edate" value="${edate}" class="form-control" style="width: 45%; display: inline-block;" autocomplete="off">
											</div>
										</div>
									</div>
									<div class="col-lg-2">
										<label>종류</label> <select class="form-control" name="kind">
											<option <c:if test="${kind eq ''}">selected</c:if> value="">전체</option>
											<option <c:if test="${kind eq '0'}">selected</c:if> value="0">트레이더 진입</option>
											<option <c:if test="${kind eq '1'}">selected</c:if> value="1">트레이더 청산</option>
											<option <c:if test="${kind eq '2'}">selected</c:if> value="2">손절</option>
											<option <c:if test="${kind eq '3'}">selected</c:if> value="3">익절</option>
											<option <c:if test="${kind eq '4'}">selected</c:if> value="4">강제 청산</option>
										</select>
									</div>
									<div class="col-lg-3">
										<label>검색어</label>
										<div class="form-group input-group">
											<input type="text" name="search" class="form-control" value="${search}" placeholder="팔로워 이름 / 트레이더 이름 / 심볼 ">
											<span class="input-group-btn">
												<button class="btn btn-default" onclick="checkForm(0)" type="button">
													<i class="fa fa-search"></i>
												</button>
											</span>
										</div>
									</div>
									<div class="col-lg-3">
										<label>종목</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-light btn-icon-split"
													onclick="setSymbol('')" type="button">전체</button> <c:forEach
													var="coin" items="${useCoin}" varStatus="i">
													<button class="btn btn-light btn-icon-split" style="padding: 6px 7px;" onclick="setSymbol('${coin}USDT')" type="button">${coin}</button>
												</c:forEach>
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
											<th>팔로워</th>
											<th>트레이더</th>
											<th>심볼</th>
											<th>레버리지 팔로우</th>
											<th>레버리지</th>
											<th>포지션</th>
											<th>진입가</th>
											<th>수량</th>
											<th>증거금</th>
											<th>수익(USDT)</th>
											<th>수익률</th>
											<th>일자</th>
											<th>경위</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr style="background-color:${item.color}">
												<td>${item.userIdx}</td>
												<td onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.userIdx}'"
													style="cursor: pointer;">${item.uname}</td>
												<td onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.tidx}'"
													style="cursor: pointer;">${item.tname}</td>
												<td>${item.symbol}</td>
												<td><c:if test="${item.levFollow eq 0}">지정</c:if> <c:if
														test="${item.levFollow eq 1}">팔로우</c:if></td>
												<td>${item.leverage}</td>
												<td>${item.position}</td>
												<td><fmt:formatNumber value="${item.entryPrice}"
														pattern="####.######"></fmt:formatNumber> USDT</td>

												<c:set var="coinLength" value="${fn:length(item.symbol) }" />
												<td><fmt:formatNumber value="${item.buyQuantity}"
														pattern="####.######"></fmt:formatNumber>
													${fn:substring(item.symbol,0,coinLength-4)}</td>
												<td><fmt:formatNumber value="${item.margin}"
														pattern="####.######"></fmt:formatNumber> USDT</td>
												<c:if test="${item.result eq null}">
													<td>-</td>
													<td>-</td>
												</c:if>
												<c:if test="${item.result ne null}">
													<td><fmt:formatNumber value="${item.result}"
															pattern="####.######"></fmt:formatNumber> USDT</td>
													<td><fmt:formatNumber
															value="${(item.result / item.margin) * 100}"
															pattern="##.##"></fmt:formatNumber>%</td>
												</c:if>
												<td><fmt:formatDate value="${item.date}"
														pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></td>
												<td><c:choose>
														<c:when test="${item.kind eq '0' }">트레이더 진입</c:when>
														<c:when test="${item.kind eq '1' }">트레이더 청산</c:when>
														<c:when test="${item.kind eq '2' }">손절</c:when>
														<c:when test="${item.kind eq '3' }">익절</c:when>
														<c:when test="${item.kind eq '4' }">강제 청산</c:when>
														<c:otherwise>${item.kind}</c:otherwise>
													</c:choose></td>
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
console.log("A2SD22");
var pi = "${pi}";

function setOrder(val){
	var order = $("#order").val();
	var orderAD = $("#orderAD").val();
	if(order==val){
		if(orderAD=="asc"){
			$("#orderAD").val("desc");
		}
		else{
			$("#orderAD").val("asc");
		}
	}
	else{
		$("#orderAD").val("desc");
	}
	
	$("#order").val(val);
	checkForm(0);
}

function setSymbol(val){
	$("#symbol").val(val);
	checkForm(0);
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