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
					<h1 class="h3 mb-2 text-gray-800">${username} 하위 누적 거래내역</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">
								trade
								<c:if test="${Project.feeAccum eq true}">정산액 = 유저 누적 + 관리자 누적</c:if>
								<c:if test="${Project.feeReferral eq true}">수수료 = 유저 누적 + 관리자 누적</c:if>
							</h6>
						</div>
						<div class="card-body">
							<form action="/global/0nI0lMy6jAzAFRVe0DqLOw/referral/accumTradeLog.do" name="listForm" id="listForm">
								<div class="row">
									<input type="hidden" name="uidx" value="${uidx}" /> <input
										type="hidden" name="username" value="${username}" /> <input
										type="hidden" name="fileDown" id="fileDown" value="0" /> <input
										type="hidden" name="pageIndex" value="1" />
									<div class="col-lg-3">
										<div class="form-group">
											<c:set var="beginDt" value="2001.01.01" />
											<label>마지막 지급일</label>&nbsp;
											<button type="button" onclick="gift(${uidx})"
												class="btn-xs btn-primary">지급</button>
											<pre>&nbsp;<c:if test="${accumInfo.givedate < beginDt}">지급 기록 없음</c:if><c:if test="${accumInfo.givedate > beginDt}"><fmt:formatDate value="${item.givedate}" pattern="yyyy-MM-dd HH:mm:ss" /><fmt:formatDate value="${accumInfo.givedate}" pattern="yyyy-MM-dd HH:mm:ss" /></c:if></pre>
										</div>
									</div>
									<div class="col-lg-2">
										<label>미지급 총 누적액</label>
										<div class="form-group input-group">
											<pre>&nbsp;<fmt:formatNumber value="${accumInfo.accumSum}" pattern="####.######" /> USDT</pre>
										</div>
									</div>
									
									<div class="col-lg-2">
										<label>지급 완료</label>
										<div class="form-group input-group">
											<pre>&nbsp;<fmt:formatNumber value="${accumInfo.receiveSum}" pattern="####.######" /> USDT</pre>
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
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-striped table-hover" style="font-size:small;">
									<thead>
										<tr>
											<th>시간</th>
											<th>UID</th>
											<th>회원명</th>
											<th>Symbol</th>
											<th>주문번호</th>
											<th>주문타입</th>
											<th>포지션</th>
											<th>가격</th>
											<th>수량</th>
											<th>레버리지</th>
											<th>수수료</th>
											<th>정산액</th>
											<th>유저 누적</th>
											<th>관리자 누적</th>
											<th>지급여부</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr style="background-color:${item.color}">
												<c:set var="coinLength" value="${fn:length(item.symbol)}" />
												<c:set var="coinname" value="USDT" />
												<c:if
													test="${fn:substring(item.symbol,coinLength-1,coinLength) eq 'D'}">
													<c:set var="coinname"
														value="${fn:substring(item.symbol,0,coinLength-3)}" />
												</c:if>

												<td><fmt:formatDate value="${item.buyDatetime}"
														pattern="yyyy-MM-dd HH:mm:ss" /></td>
												<td>${item.userIdx}</td>
												<td onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.userIdx}'" style="cursor: pointer;">${item.name}</td>
												<td>${item.symbol}</td>
												<td>${item.orderNum}</td>
												<td>${item.orderType}</td>
												<td><c:if test="${item.isOpen eq true}">
														<c:if test="${item.position eq 'long'}">LONG</c:if>
														<c:if test="${item.position eq 'short'}">SHORT</c:if>
													</c:if> <c:if test="${item.isOpen ne true}">
														<c:if test="${item.position eq 'long'}">SHORT</c:if>
														<c:if test="${item.position eq 'short'}">LONG</c:if>
													</c:if></td>
												<td>${item.entryPrice}</td>
												<td><fmt:formatNumber value="${item.buyQuantity}"
														pattern="#,###.####" /></td>
												<td>${item.leverage}</td>
												<td><fmt:formatNumber value="${item.fee}"
														pattern="#,###.########" /> ${coinname}</td>
												<td><c:if test="${item.isOpen eq true}">오픈</c:if> <c:if
														test="${item.isOpen ne true}">
														<fmt:formatNumber value="${item.result}"
															pattern="#,###.########" />
													</c:if></td>
												<td><fmt:formatNumber value="${item.allot}"
														pattern="#,###.########" /> USDT</td>
												<td><fmt:formatNumber value="${item.adminProfit}"
														pattern="#,###.########" /> USDT</td>
												<td><c:if test="${item.isGive eq 0 }">미지급</c:if>
													<c:if test="${item.isGive eq 1 }">지급</c:if></td>
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
function setTest(val){
	$("#test").val(val);
	checkForm();
}

function setInverse(val){
	$("#inverse").val(val);
	checkForm(0);
}

function checkForm(file){
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
	 if(file == 0 || file == '0'){
		 document.listForm.pageIndex.value = 1;
	 }
	 
	$("#fileDown").val(file);
	$("#username").val(null);
	$("#searchIdx").val(null);
	$("#listForm").submit();
}

function gift(uidx){
	if(confirm("지급하시겠습니까?")){
		$.ajax({
			type :'post',
			data : {"uidx" : uidx},
			url : '/global/0nI0lMy6jAzAFRVe0DqLOw/referral/accumReferralGift.do',
			success:function(data){
				alert(data.msg);
				if(data.result == "suc"){
					location.href="/global/0nI0lMy6jAzAFRVe0DqLOw/referral/giveReferral.do";
				}
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
}
</script>
</body>
</html>