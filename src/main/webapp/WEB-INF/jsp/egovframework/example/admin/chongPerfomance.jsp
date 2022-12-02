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
					<h1 class="h3 mb-2 text-gray-800">총판 입출금 취합</h1>
					<div class="row">
						<div class="col-lg-12">
							<div class="card shadow mb-4">
								<div class="card-header py-3">
									<h6 class="m-0 font-weight-bold text-primary">총판별 직속하위의
										입출금내역 취합
									</h6>
								</div>
								<div class="card-body">
									<form action="/global/0nI0lMy6jAzAFRVe0DqLOw/chongPerfomance.do" name="listForm" id="listForm">
										<div class="row">
											<input type="hidden" name="pageIndex" value="1" /> <input
												type="hidden" name="test" id="test" value="${test}" />
											<div class="col-lg-3">
												<label>기간 검색</label>
												<div class="form-group input-group">
													<div>
														<input type="date" name="sdate" id="sdate"
															value="${sdate}" class="form-control"
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
														class="form-control input-sm">
														<option value="name"
															<c:if test="${searchSelect eq 'name'}">selected</c:if>>회원명</option>
														<%-- 											<option value="email"<c:if test="${searchSelect eq 'email'}">selected</c:if>>이메일</option> --%>
														<%-- 											<option value="inviteCode"<c:if test="${searchSelect eq 'inviteCode'}">selected</c:if>>InviteCode</option> --%>
														<option value="idx"
															<c:if test="${searchSelect eq 'idx'}">selected</c:if>>UID</option>
													</select> <input type="text" name="search" class="form-control"
														value="${search}">
													<button class="btn btn-default" onclick="checkForm()"
														type="button">
														<i class="fa fa-search"></i>
													</button>
												</div>
											</div>
											<div class="col-lg-1">
												<label>테스트계정</label>
												<div class="form-group input-group">
													<span class="input-group-btn">
														<button class="btn btn-danger btn-sm" onclick="setTest('test')" type="button">미포함</button>
														<button class="btn btn-info btn-sm" onclick="setTest('')" type="button">포함</button>
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
													<th style="width: 15%;">총판</th>
													<th style="width: 16%;">코인</th>
													<th style="width: 23%;">입금</th>
													<th style="width: 23%;">출금</th>
													<th style="width: 23%;">입금-출금</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="item" items="${list}" varStatus="i">
													<tr
														style="background-color:${item.color}; border-top:double;">
														<td
															onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.idx}'"
															style="cursor: pointer;">${item.name}<c:if
																test="${item.istest eq 1 }">
																<span style="color: red"> (테스트 계정)</span>
															</c:if></td>
														<td>BTC</td>
														<td><fmt:formatNumber value="${item.btcDeposit}"
																pattern="#,###.########" /> BTC</td>
														<td><fmt:formatNumber value="${item.btcWithdraw}"
																pattern="#,###.########" /> BTC</td>
														<td><fmt:formatNumber
																value="${item.btcDeposit - item.btcWithdraw}"
																pattern="#,###.########" /> BTC</td>
													</tr>
													<tr style="background-color:${item.color}">
														<td></td>
														<td>USDT</td>
														<td><fmt:formatNumber value="${item.usdtDeposit}"
																pattern="#,###.########" /> USDT</td>
														<td><fmt:formatNumber value="${item.usdtWithdraw}"
																pattern="#,###.########" /> USDT</td>
														<td><fmt:formatNumber
																value="${item.usdtDeposit - item.usdtWithdraw}"
																pattern="#,###.########" /> USDT</td>
													</tr>
													<tr style="background-color:${item.color}">
														<td></td>
														<td>ETH</td>
														<td><fmt:formatNumber value="${item.ethDeposit}"
																pattern="#,###.########" /> ETH</td>
														<td><fmt:formatNumber value="${item.ethWithdraw}"
																pattern="#,###.########" /> ETH</td>
														<td><fmt:formatNumber
																value="${item.ethDeposit - item.ethWithdraw}"
																pattern="#,###.########" /> ETH</td>
													</tr>
													<tr style="background-color:${item.color}">
														<td></td>
														<td>XRP</td>
														<td><fmt:formatNumber value="${item.xrpDeposit}"
																pattern="#,###.########" /> XRP</td>
														<td><fmt:formatNumber value="${item.xrpWithdraw}"
																pattern="#,###.########" /> XRP</td>
														<td><fmt:formatNumber
																value="${item.xrpDeposit - item.xrpWithdraw}"
																pattern="#,###.########" /> XRP</td>
													</tr>
													<tr
														style="background-color:${item.color}; border-bottom:double;">
														<td></td>
														<td>TRX</td>
														<td><fmt:formatNumber value="${item.trxDeposit}"
																pattern="#,###.########" /> TRX</td>
														<td><fmt:formatNumber value="${item.trxWithdraw}"
																pattern="#,###.########" /> TRX</td>
														<td><fmt:formatNumber
																value="${item.trxDeposit - item.trxWithdraw}"
																pattern="#,###.########" /> TRX</td>
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
		</div>
	</div>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
function setTest(val){
	$("#test").val(val);
	checkForm();
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