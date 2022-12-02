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
	document.listForm.fileDown.value = "0";
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
					<h1 class="h3 mb-2 text-gray-800">레퍼럴 지급</h1>
					<div class="col-lg-12">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">give referral
								*테스트계정 미포함
							</h6>
						</div>
						<div class="card-body">
							<form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/referral/giveReferral.do"
								name="listForm" id="listForm">
								<input type="hidden" name="fileDown" id="fileDown" value="0" />
								<input type="hidden" name="pageIndex" value="1" />
								<div class="row">
									<div class="col-lg-3"> 
										<label>검색</label> 
											<select id="searchSelect"
												name="searchSelect" class="form-control input-sm"
												style="height: 34px;">
												<option value="name"
													<c:if test="${searchSelect eq 'name'}">selected</c:if>>회원명</option>
												<option value="phone"
													<c:if test="${searchSelect eq 'phone'}">selected</c:if>>전화번호</option>
												<option value="idx"
													<c:if test="${searchSelect eq 'idx'}">selected</c:if>>UID</option>
												<option value="inviteCode"
													<c:if test="${searchSelect eq 'inviteCode'}">selected</c:if>>InviteCode</option>
											</select>
									</div>
									<div class="col-lg-3">
										<label> </label>
										<div class="form-group input-group">
											<input type="text" name="search" class="form-control"
												value="${search}"> <span class="input-group-btn">
												<button class="btn btn-default" 
													onclick="checkForm()" type="button">
													<i class="fa fa-search"></i>
												</button>
											</span>
										</div>
									</div>
									<c:set var="accumt" value="" />
									<c:set var="reft" value="" />
									<c:set var="accum" value="0" />
									<c:set var="ref" value="0" />
									<c:if test="${project.feeAccum eq true}">
										<c:set var="accum" value="${frSum.resultSum }" />
										<c:set var="accumt" value=" 정산 " />
									</c:if>
									<c:if test="${project.feeReferral eq true}">
										<c:set var="ref" value="${frSum.feeSum}" />
										<c:set var="reft" value=" 수수료 " />
									</c:if>
									<div class="col-lg-5">
										<label> 발생된 총${accumt}${reft}- 지급해야하는 레퍼럴 누적액 = 거래소${accumt}${reft}수익금 ( 지급 전 )</label>
										 <pre><fmt:formatNumber value="${accum+ref}" pattern="#,###.####"/> - <fmt:formatNumber value="${accumSum}" pattern="#,###.####"/> = <fmt:formatNumber value="${accum+ref-accumSum}" pattern="#,###.####"/> USDT</pre>
									</div>
									<div class="col-lg-1">
										<label>엑셀</label>
										<div class="form-group input-group">
											<div>
												<button type="button" onclick="checkForm(1)"
													class="btn btn-outline btn-success btn-sm">EXCEL</button>
											</div>
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
											<th>회원</th>
											<th>누적액</th>
											<th>받은 금액</th>
											<th>마지막 지급일자</th>
											<th>레퍼럴 내역</th>
											<th>지급</th>
										</tr>
									</thead>
									<tbody>
										<c:set var="beginDt" value="2001.01.01" />
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr style="background-color:${item.color}">
												<td
													onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.uidx}'"
													style="cursor: pointer;">${item.name }</td>
												<td><fmt:formatNumber value="${item.accum}"
														pattern="#,###.########" /></td>
												<td><fmt:formatNumber value="${item.receive}"
														pattern="#,###.########" /></td>
												<td><c:if test="${item.givedate < beginDt}">지급 기록 없음</c:if>
													<c:if test="${item.givedate > beginDt}">
														<fmt:formatDate value="${item.givedate}"
															pattern="yyyy-MM-dd HH:mm:ss" />
													</c:if></td>
												<td><button class="btn-xs btn-default"
														onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/referral/accumTradeLog.do?uidx=${item.uidx}&username=${item.name}'">내역
														보기</button></td>
												<td><button class="btn-xs btn-primary"
														onclick="gift(${item.uidx})">지급</button></td>
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
function checkForm(file){
	$("#fileDown").val(file);
	$("#listForm").submit();
}

function gift(uidx){
	if(confirm("지급하시겠습니까?")){
		$.ajax({
			type :'post',
			data : {"uidx" : uidx},
			url : '/wesell/0nI0lMy6jAzAFRVe0DqLOw/referral/accumReferralGift.do',
			success:function(data){
				alert(data.msg);
				if(data.result == "suc"){
					location.href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/referral/giveReferral.do";
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