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
<body>
	<div id="wrapper">
		<jsp:include page="../adminFrame/top.jsp"></jsp:include>
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                	<h1 class="page-header"> ${coin} 레퍼럴</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
						<div class="panel-heading">referral</div>
                        <div class="panel-body">
							<div class="row">
							   <form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/referral/referralList.do" name="listForm" id="listForm">
									<input type="hidden" name="pageIndex" value="1"/>
									<input type="hidden" name="ad" value="${ad}"/>
									<input type="hidden" name="coin" id="coin" value="${coin}"/>
									<div class="col-lg-4">
										<div class="form-group">
											<label>기간 검색</label>
											<div>
												<input type="date" name="sdate" id="sdate" value="${sdate}" class="form-control" style="width: 43%; display: inline-block;" autocomplete="off">
												 ~ 
												<input type="date" name="edate" id="edate" value="${edate}" class="form-control" style="width: 43%; display: inline-block;" autocomplete="off">
											</div>
										</div>
									</div>
									<div class="col-lg-4" style="width:150px;">
										<label>검색<c:if test="${ad eq 1}"> (발생 회원)</c:if><c:if test="${ad ne 1}"> (받은 회원)</c:if></label>
										<c:if test="${ad eq 1}">
											<select id="searchSelect" name="searchSelect" class="form-control input-sm" style="height:34px;">
												<option value="u.name"<c:if test="${searchSelect eq 'u.name'}">selected</c:if>>회원명</option>
												<option value="u.phone"<c:if test="${searchSelect eq 'u.phone'}">selected</c:if>>전화번호</option>
												<option value="u.idx"<c:if test="${searchSelect eq 'u.idx'}">selected</c:if>>UID</option>
												<option value="u.inviteCode"<c:if test="${searchSelect eq 'u.inviteCode'}">selected</c:if>>InviteCode</option>
											</select>
										</c:if>
										<c:if test="${ad ne 1}">
											<select id="searchSelect" name="searchSelect" class="form-control input-sm" style="height:34px;">
												<option value="g.name"<c:if test="${searchSelect eq 'g.name'}">selected</c:if>>회원명</option>
												<option value="g.phone"<c:if test="${searchSelect eq 'g.phone'}">selected</c:if>>전화번호</option>
												<option value="getIdx"<c:if test="${searchSelect eq 'getIdx'}">selected</c:if>>UID</option>
												<option value="g.inviteCode"<c:if test="${searchSelect eq 'g.inviteCode'}">selected</c:if>>InviteCode</option>
											</select>
										</c:if>
									</div>
									<div class="col-lg-4">
										<label>　</label>
										<div class="form-group input-group">
											<input type="text" name="search" class="form-control" value="${search}"> 
											<span class="input-group-btn">
												<button class="btn btn-default" style="padding: 6px 12px;"  onclick="checkForm()" type="button">
													<i class="fa fa-search"></i>
												</button>
											</span>
										</div>
									</div>
								</form>
							</div>
							<div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                    	<c:if test="${ad eq 1}">
	                                        <tr>
	                                            <th>날짜</th>
	                                            <th>회원</th>
	                                            <th>거래량 USDT</th>
	                                            <th>수수료 ${coin}</th>
	                                            <th>수수료 보상 ${coin}</th>
	                                            <th>받은 회원</th>
	                                            <th>구분</th>
	                                        </tr>
                                    	</c:if>
                                        <c:if test="${ad ne 1}">
	                                        <tr>
	                                            <th>날짜</th>
	                                            <th>받은 회원</th>
	                                            <th>거래량 USDT</th>
	                                            <th>수수료 ${coin}</th>
	                                            <th>수수료 보상 ${coin}</th>
	                                            <th>회원</th>
	                                            <th>구분</th>
	                                        </tr>
                                    	</c:if>
                                    </thead>
                                    <tbody>
                                    	<c:if test="${ad eq 1}">
	                                    	<c:forEach var="item" items="${list}" varStatus="i">
		                                        <tr style="background-color:${item.color}">
		                                            <td>${item.time}</td>
		                                            <td onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.userIdx}'" style="cursor:pointer;">${item.name }</td>
		                                            <td><fmt:formatNumber value="${item.volume}" pattern="#,###.####"/></td>
		                                            <td><fmt:formatNumber value="${item.fee}" pattern="#,###.####"/></td>
		                                            <td><fmt:formatNumber value="${item.commission}" pattern="#,###.####"/></td>
		                                            <td>${item.gname}</td>
		                                            <td>${item.getLevel}</td>
		                                        </tr>
	                                        </c:forEach>
                                    	</c:if>
                                    	<c:if test="${ad ne 1}">
	                                    	<c:forEach var="item" items="${list}" varStatus="i">
		                                        <tr style="background-color:${item.color}">
		                                            <td>${item.time}</td>
		                                            <td onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.idx}'" style="cursor:pointer;">${item.gname}</td>
		                                            <td><fmt:formatNumber value="${item.volume}" pattern="#,###.####"/></td>
		                                            <td><fmt:formatNumber value="${item.fee}" pattern="#,###.####"/></td>
		                                            <td><fmt:formatNumber value="${item.commission}" pattern="#,###.####"/></td>
		                                            <td>${item.name }</td>
		                                            <td>${item.getLevel}</td>
		                                        </tr>
	                                        </c:forEach>
                                    	</c:if>
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