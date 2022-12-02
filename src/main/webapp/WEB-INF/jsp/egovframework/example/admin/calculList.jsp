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
                	<h1 class="page-header"> 총판 정산</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
						<div class="panel-heading">총판 정산 (본사 수익 = 해당 총판+직속하위)</div>
                        <div class="panel-body">
							   <form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/calculList.do" name="listForm" id="listForm">
								<div class="row">
									<input type="hidden" name="pageIndex" value="1"/>
									<input type="hidden" name="test" id="test" value="${test}"/>
									<div class="col-lg-3">
										<label>총판 검색</label>
										<div class="form-group input-group">
											<select id="searchSelect" name="searchSelect" class="form-control input-sm" style="width:fit-content;height:34px;">
												<option value="name"<c:if test="${searchSelect eq 'name'}">selected</c:if>>회원명</option>
												<option value="phone"<c:if test="${searchSelect eq 'phone'}">selected</c:if>>전화번호</option>
												<option value="id"<c:if test="${searchSelect eq 'id'}">selected</c:if>>ID</option>
												<option value="idx"<c:if test="${searchSelect eq 'idx'}">selected</c:if>>UID</option>
											</select>
											<input type="text" name="search" class="form-control" value="${search}" style="width:auto;"> 
											<button class="btn btn-default" style="padding: 6px 12px;" onclick="checkForm()" type="button"> <i class="fa fa-search"></i> </button>
										</div>
									</div>
									<div class="col-lg-1">
										<label>테스트계정</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-danger btn-xs" style="padding: 6px 7px;" onclick="setTest('test')" type="button">미포함</button>
												<button class="btn btn-info btn-xs" style="padding: 6px 7px;" onclick="setTest('')" type="button">포함</button>
											</span>
										</div>
									</div>
								</div>
							</form>
							<div class="table-responsive">
                                <table class="table table-striped table-hover">
                                  	<c:forEach var="item" items="${list}" varStatus="i">
	                                    <thead>
	                                        <tr style="background-color:${item.color}; border-top:double;">
	                                            <th onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.idx}'" style="cursor:pointer;">${item.name}<c:if test="${item.istest eq 1 }"><span style="color:red"> (테스트 계정)</span></c:if>
	                                            	( 직속상위 - 
	                                            	<c:if test="${item.parentsIdx ne '-1'}"><span onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.parentsIdx}'" style="cursor:pointer;">${item.pname}</span></c:if>
	                                            	<c:if test="${item.parentsIdx eq '-1'}"><span>${item.pname}</span></c:if>
	                                            	)
	                                            </th>
	                                        </tr>
	                                    </thead>
	                                    <tbody>
		                                        <tr>
		                                            <td>누적액 : <fmt:formatNumber value="${item.accum}" pattern="#,###.#####"/></td>
		                                            <td>받은 금액 : <fmt:formatNumber value="${item.receive}" pattern="#,###.#####"/></td>
		                                            <td>총판 수익 : <fmt:formatNumber value="${item.accum+item.receive}" pattern="#,###.#####"/></td>
		                                            <td>본사 수익 : <fmt:formatNumber value="${item.adminProfit}" pattern="#,###.#####"/></td>
		                                        </tr>
	                                    </tbody>
                                    </c:forEach>
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
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