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
					<h1 class="h3 mb-2 text-gray-800">
						카피트레이드 팔로워 리스트 <c:if test="${!empty tinfo}">(${tinfo.name})</c:if>
					</h1>
					<div class="card shadow mb-4">						
						<div class="card-body">
							<form action="/wesell/admin/trader/followerList.do" name="listForm" id="listForm">
								<div class="row">
									<input type="hidden" name="fileDown" id="fileDown" value="0" />
									<input type="hidden" name="pageIndex" value="1" /> 
									<input type="hidden" name="tidx" value="${tinfo.tidx}" /> 
									<input type="hidden" name="order" id="order" value="${order}" /> 
									<input type="hidden" name="orderAD" id="orderAD" value="${orderAD}" />
									<input type="hidden" name="symbol" id="symbol" value="${symbol}" />
									<div class="col-lg-3">
										<div class="form-group">
											<label>기간 검색 시작일</label>
											<input type="radio" value="s" name="dateSelect" <c:if test="${empty dateSelect or dateSelect eq 's'}">checked</c:if> /> 
											<label>종료일</label>
											<input type="radio" value="e" name="dateSelect" <c:if test="${dateSelect eq 'e'}">checked</c:if> />
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
									<div class="col-lg-1">
										<label>종류</label> <select class="form-control" name="state">
											<option <c:if test="${state eq ''}">selected</c:if> value="">전체</option>
											<option <c:if test="${state eq '0'}">selected</c:if>
												value="0">실행중</option>
											<option <c:if test="${state eq '1'}">selected</c:if>
												value="1">직접 중지</option>
											<option <c:if test="${state eq '4'}">selected</c:if>
												value="4">잔액부족</option>
											<option <c:if test="${state eq '5'}">selected</c:if>
												value="5">트레이더 상실</option>
											<option <c:if test="${state eq '6'}">selected</c:if>
												value="6">거래쌍 중지</option>
											<option <c:if test="${state eq '7'}">selected</c:if>
												value="7">신청중</option>
											<option <c:if test="${state eq '8'}">selected</c:if>
												value="8">거절됨</option>
										</select>
									</div>
									<div class="col-lg-3">
										<label>검색어</label>
										<div class="form-group input-group">
											<input type="text" name="search" class="form-control"
												value="${search}" placeholder="팔로워 이름 / 트레이더 이름 / 심볼 ">
											<span class="input-group-btn">
												<button class="btn btn-default" onclick="checkForm(0)"
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
												<button class="btn btn-default btn-xs"
													onclick="setSymbol('')" type="button">전체</button> <c:forEach
													var="coin" items="${useCoin}" varStatus="i">
													<button class="btn btn-default btn-xs"
														onclick="setSymbol('${coin}USDT')" type="button">${coin}</button>
												</c:forEach>
											</span>
										</div>
									</div>
									<div class="col-lg-1">
										<label>정렬</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-info btn-sm"
													onclick="setOrder('sdate')" type="button">시작일</button>
												<button class="btn btn-success btn-sm"
													onclick="setOrder('profit')" type="button">수익</button>
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
							<c:if test="${!empty tinfo}">
								<div class="col-lg-4" style="width: fit-content;">
									<div class="form-group ">
										<pre style="margin-top: 20px;">&nbsp; 실행중 팔로워 수  : ${tinfo.followerCnt}</pre>
									</div>
								</div>
							</c:if>
							
							<div class="table-responsive">
								<table class="table table-striped table-bordered">
									<thead>
										<tr>
											<th>UID</th>
											<th>팔로워</th>
											<th>트레이더</th>
											<th>심볼</th>
											<th>레버리지</th>
											<th>구매량</th>
											<th>손절율</th>
											<th>익절율</th>
											<th>최대 포지션 USDT</th>
											<th>원금(USDT)</th>
											<th>수익(USDT)</th>
											<th>시작일</th>
											<th>종료일</th>
											<th>상태</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr style="background-color:${item.color}">
												<td>${item.uidx}</td>
												<td onclick="location.href='/wesell/admin/user/userDetail.do?idx=${item.uidx}'" style="cursor: pointer;">${item.uname}</td>
												<td onclick="location.href='/wesell/admin/user/userDetail.do?idx=${item.tidx}'" style="cursor: pointer;">${item.tname}</td>
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
												<td><fmt:formatNumber value="${item.followMoney}"
														pattern="#,###.######" /></td>
												<td><fmt:formatNumber value="${item.profit}"
														pattern="#,###.######" /></td>
												<td><fmt:formatDate value="${item.sdate}"
														pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></td>
												<td><fmt:formatDate value="${item.edate}"
														pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></td>
												<td><c:choose>
														<c:when test="${item.state eq '0' }">실행중</c:when>
														<c:when test="${item.state eq '1' }">중지(직접 중지)</c:when>
														<c:when test="${item.state eq '4' }">중지(잔액 부족)</c:when>
														<c:when test="${item.state eq '5' }">중지(트레이더 자격상실)</c:when>
														<c:when test="${item.state eq '6' }">중지(거래쌍 중지)</c:when>
														<c:when test="${item.state eq '7' }">신청중</c:when>
														<c:when test="${item.state eq '8' }">거절됨</c:when>
														<c:otherwise>${item.state}</c:otherwise>
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
	var pi = "${pi}";

	function setOrder(val) {
		var order = $("#order").val();
		var orderAD = $("#orderAD").val();
		if (order == val) {
			if (orderAD == "asc") {
				$("#orderAD").val("desc");
			} else {
				$("#orderAD").val("asc");
			}
		} else {
			$("#orderAD").val("desc");
		}

		$("#order").val(val);
		checkForm(0);
	}

	function setSymbol(val) {
		$("#symbol").val(val);
		checkForm(0);
	}

	function checkForm(file) {
		$("#fileDown").val(0);
		
		if(file != null && file != ""){
			if(file == 1)
				$("#fileDown").val(1);
		}
		
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
</script>
</body>
</html>