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
		<c:import url="/admin/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">${username}거래내역</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">trade</h6>
						</div>
						<div class="card-body">
							<form action="/wesell/admin/spottrade/tradeList.do"
								name="listForm" id="listForm">
								<input type="hidden" name="fileDown" id="fileDown" value="0" />
								<input type="hidden" name="pageIndex" value="1" /> <input
									type="hidden" name="username" id="username" value="${username}" />
								<input type="hidden" name="searchIdx" id="searchIdx"
									value="${searchIdx}" /> <input type="hidden" name="inverse"
									id="inverse" value="${inverse}" /> <input type="hidden"
									name="order" id="order" value="${order}" /> <input
									type="hidden" name="orderAD" id="orderAD" value="${orderAD}" />
								<input type="hidden" name="symbol" id="symbol" value="${symbol}" />
								<input type="hidden" name="test" id="test" value="${test}" />
								<div class="row">
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
										<label>검색</label>
										<div class="form-group input-group">
											<select id="searchSelect" name="searchSelect"
												class="form-control">
												<option value="name"
													<c:if test="${searchSelect eq 'name'}">selected</c:if>>회원명</option>
												<option value="email"
													<c:if test="${searchSelect eq 'email'}">selected</c:if>>이메일</option>
												<option value="inviteCode"
													<c:if test="${searchSelect eq 'inviteCode'}">selected</c:if>>InviteCode</option>
												<option value="idx"
													<c:if test="${searchSelect eq 'idx'}">selected</c:if>>UID</option>
												<option value="symbol"
													<c:if test="${searchSelect eq 'symbol'}">selected</c:if>>Symbol</option>
											</select> <input type="text" name="search" class="form-control"
												value="${search}" style="width: auto;">
											<button class="btn btn-default btn-sm" onclick="checkForm(2)"
												type="button">
												<i class="fa fa-search"></i>
											</button>
										</div>
									</div>
									<div class="col-lg-2">
										<label>종목</label>
										<div class="form-group input-group">
											<span class="input-group-btn" style="white-space: normal;">
												<button class="btn btn-light btn-icon-split"
													onclick="setSymbol('')" type="button">전체</button> <c:forEach
													var="coin" items="${useCoin}" varStatus="i">													
													<button class="btn btn-light btn-icon-split"
														onclick="setSymbol('${coin}USD')" type="button">${coin}</button>
												</c:forEach>
											</span>
										</div>
									</div>
									<div class="col-lg-1">
										<label>테스트계정</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-danger btn-sm"
													onclick="setTest('test')" type="button">미포함</button>
												<button class="btn btn-info btn-sm" onclick="setTest('')"
													type="button">포함</button>
											</span>
										</div>
									</div>
									<div class="col-lg-1">
										<label>정렬</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-info btn-sm"
													onclick="setOrder('buyDatetime')" type="button">시간</button>
												<!-- <button class="btn btn-success btn-sm"
													onclick="setOrder('result')" type="button">정산</button> -->
											</span>
										</div>
									</div>
									<div class="col-lg-1">
										<label>엑셀</label>
										<div class="form-group input-group">
											<button type="button" onclick="checkForm(1)"
												class="btn btn-outline btn-success btn-sm">
												EXCEL
											</button>
										</div>
									</div>
								</div>
							</form>
						</div>
						<div class="row" style="margin-left: 10px;">
							<div class="col-lg-4" style="width: fit-content;">
								<div class="form-group ">
									<pre style="margin-top: 20px;">&nbsp; 총 수수료합  : ${feeResultSum.feeSum} 총 정산합  : ${feeResultSum.resultSum}</pre>
								</div>
							</div>
							<div class="col-lg-4" style="width: fit-content;">
								<div class="form-group ">
									<pre style="margin-top: 20px;">&nbsp; 총 테스트 총수수료합 : ${testFeeResultSum.feeSum} 테스트 총정산합 : ${testFeeResultSum.resultSum}</pre>
								</div>
							</div>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-striped table-hover">
									<thead>
										<tr>
											<th>idx</th>
											<th>시간</th>
											<th>UID</th>
											<th>회원명</th>
											<th>소속 총판</th>
											<th>Symbol</th>
											<th>주문번호</th>
											<th>주문타입</th>
											<th>포지션</th>
											<th>가격</th>
											<th>수량</th>
											<th>수수료</th><!-- 
											<th>정산</th>
											<th>레버리지</th> -->
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr style="background-color:${item.color}">
												<td>${item.idx}</td>
												<td>${item.buyDatetime}</td>
												<td>${item.userIdx}</td>
												<td
													onclick="location.href='/wesell/admin/user/userDetail.do?idx=${item.userIdx}'"
													style="cursor: pointer;">${item.name} <c:if
														test="${item.phone eq '-1'}">
														<span style="color: red;"> 삭제계정
													</c:if>
												</td>
												<c:if test="${item.pname ne null}">
													<td
														onclick="location.href='/wesell/admin/user/userDetail.do?idx=${item.parentsIdx}'"
														style="cursor: pointer;">${item.pname} <c:if
															test="${item.pphone eq '-1'}">
															<span style="color: red;"> 삭제계정
														</c:if>
													</td>
												</c:if>
												<c:if test="${item.pname eq null}">
													<td>없음</td>
												</c:if>
												<td>${item.symbol}</td>
												<td>${item.orderNum}</td>
												<td>${item.orderType}</td>
												<td>
													<c:if test="${item.isOpen eq true}">
														<c:if test="${item.position eq 'long'}">LONG</c:if>
														<c:if test="${item.position eq 'short'}">SHORT</c:if>
													</c:if> <c:if test="${item.isOpen ne true}">
														<c:if test="${item.position eq 'long'}">BUY</c:if>
														<c:if test="${item.position eq 'short'}">SELL</c:if>
													</c:if>
												</td>
												<td>													
													<fmt:formatNumber value="${item.entryPrice}" pattern="#,###.####" />																										
												</td>
												<td><fmt:formatNumber value="${item.buyQuantity}"
														pattern="#,###.####" /></td>
												<td><fmt:formatNumber value="${item.fee}"
														pattern="#,###.########" /></td>
												<%-- <td><c:if test="${item.isOpen eq true}">오픈</c:if> <c:if
														test="${item.isOpen ne true}">
														<fmt:formatNumber value="${item.result}"
															pattern="#,###.########" />
													</c:if></td>
												<td>${item.leverage}</td> --%>
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

function setTest(val){
	$("#test").val(val);
	checkForm();
}

function setInverse(val){
	$("#inverse").val(val);
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
	$("#username").val(null);
	$("#searchIdx").val(null);
	$("#listForm").submit();
}
</script>
</body>
</html>