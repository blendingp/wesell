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
					<h1 class="h3 mb-2 text-gray-800">팔로우 신청 리스트</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">follower</h6>
						</div>
						<div class="card-body">
							<form action="/global/0nI0lMy6jAzAFRVe0DqLOw/trader/copyRequestList.do" name="listForm" id="listForm">
								<input type="hidden" name="pageIndex" value="1" /> 
								<input type="hidden" name="order" id="order" value="${order}" /> 
								<input type="hidden" name="orderAD" id="orderAD" value="${orderAD}" />
								<input type="hidden" name="symbol" id="symbol" value="${symbol}" />
								<div class="row">
									<div class="col-lg-3">
										<div class="form-group">
											<label>기간 검색</label>
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
												value="${search}" placeholder="팔로워 이름 / 트레이더 이름 / 심볼 ">
											<span class="input-group-btn">
												<button class="btn btn-default" onclick="checkForm()"
													type="button">
													<i class="fa fa-search"></i>
												</button>
											</span>
										</div>
									</div>
									<div class="col-lg-3">
										<label>종목</label>
										<div class="form-group input-group">
											<span class="input-group-btn" style="white-space: normal;">
												<button class="btn btn-light btn-icon-split"
													style="padding: 6px 7px;" onclick="setSymbol('')"
													type="button">전체</button> <c:forEach var="coin"
													items="${useCoin}" varStatus="i">
													<button class="btn btn-light btn-icon-split"
														style="padding: 6px 7px;"
														onclick="setSymbol('${coin}USDT')" type="button">${coin}</button>
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
											<th>팔로워</th>
											<th>트레이더</th>
											<th>심볼</th>
											<th>레버리지</th>
											<th>구매량</th>
											<th>손절율</th>
											<th>익절율</th>
											<th>최대 포지션 USDT</th>
											<th>신청일</th>
											<th></th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr style="background-color:${item.color}">
												<td
													onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.uidx}'"
													style="cursor: pointer;">${item.uname}</td>
												<td
													onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.tidx}'"
													style="cursor: pointer;">${item.tname}</td>
												<td>${item.symbol}</td>
												<td><c:if test="${item.fixLeverage eq null}">트레이더</c:if>
													<c:if test="${item.fixLeverage ne null}">${item.fixLeverage}</c:if>
												</td>
												<td><c:if test="${item.isQtyRate eq false}">${item.fixQty} USDT</c:if>
													<c:if test="${item.isQtyRate eq true}">${item.fixQty}%</c:if>
												</td>
												<td><c:if test="${item.lossCutRate eq null}">없음</c:if>
													<c:if test="${item.lossCutRate ne null}">${item.lossCutRate}%</c:if>
												</td>
												<td><c:if test="${item.profitCutRate eq null}">없음</c:if>
													<c:if test="${item.profitCutRate ne null}">${item.profitCutRate}%</c:if>
												</td>
												<td><c:if test="${item.maxPositionQty eq null}">없음</c:if>
													<c:if test="${item.maxPositionQty ne null}">${item.maxPositionQty}</c:if>
												</td>
												<td><fmt:formatDate value="${item.sdate}"
														pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></td>
												<td><c:choose>
														<c:when test="${item.state eq '0' }">실행중</c:when>
														<c:when test="${item.state eq '1' }">중지(직접 중지)</c:when>
														<c:when test="${item.state eq '4' }">중지(잔액 부족)</c:when>
														<c:when test="${item.state eq '5' }">중지(트레이더 자격상실)</c:when>
														<c:when test="${item.state eq '6' }">중지(거래쌍 중지)</c:when>
														<c:when test="${item.state eq '7' }">신청중</c:when>
														<c:otherwise>${item.state}</c:otherwise>
													</c:choose></td>
												<td>
													<button class="btn btn-primary btn-xs"
														style="padding: 6px 7px;"
														onclick="requestConfirm('${item.uidx}','${item.symbol}')"
														type="button">승인</button>
													<button class="btn btn-danger btn-xs"
														style="padding: 6px 7px;"
														onclick="requestDeny('${item.uidx}','${item.symbol}')"
														type="button">거절</button>
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
	checkForm();
}

function setSymbol(val){
	$("#symbol").val(val);
	checkForm();
}

function requestDeny(uidx, symbol){
	$.ajax({
		type:'get',
		data:{"useridx" : uidx, "symbol" : symbol},
		url:'/global/0nI0lMy6jAzAFRVe0DqLOw/trader/requestDeny.do',
		success:function(data){
			alert(data.msg);
			if(data.result=="suc")
				location.reload();
		},
		error:function(e){
			console.log('ajax Error ' + JSON.stringify(e));
		}
	})
}

function requestConfirm(uidx, symbol){
	$.ajax({
		type:'get',
		data:{"useridx" : uidx, "symbol" : symbol},
		url:'/global/0nI0lMy6jAzAFRVe0DqLOw/trader/requestConfirm.do',
		success:function(data){
			alert(data.msg);
			if(data.result=="suc")
				location.reload();
		},
		error:function(e){
			console.log('ajax Error ' + JSON.stringify(e));
		}
	})
}

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