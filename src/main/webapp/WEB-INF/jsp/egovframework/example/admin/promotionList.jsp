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
                	<h1 class="page-header">승급 신청 리스트</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
						<div class="panel-heading">application for promotion</div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>이름</th>
                                            <th>국가번호</th>
                                            <th>번호</th>
                                            <th>등급</th>
                                            <th>신청날짜</th>
                                            <th>처리여부</th>
                                            <th>처리날짜</th>
                                            <th>처리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:forEach var="item" items="${list}" varStatus="i">
                                        <tr>
                                            <td>${item.name}</td>
                                            <td>+${item.country}</td>
                                            <td>${item.phone}</td>
                                            <td>${item.level}</td>
                                            <td><fmt:formatDate value="${item.pdate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                            <td>
                                            	<c:if test="${item.approval eq 0}">신청 중</c:if>
                                            	<c:if test="${item.approval eq 1}">승인</c:if>
                                            	<c:if test="${item.approval eq 2}">미승인</c:if>
                                            	<c:if test="${item.approval eq 3}">처리완료</c:if>
                                            </td>
                                            <td><fmt:formatDate value="${item.adate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                            <td>
                                            	<c:if test="${item.approval eq 3}">처리완료</c:if>
                                            	<c:if test="${item.approval ne 3}">
	                                            	<button type="button" onclick="changeApproval(${item.idx} , 1)" class="btn btn-info btn-xs">승인</button>
	                                            	<button type="button" onclick="changeApproval(${item.idx} , 2)" class="btn btn-warning btn-xs">미승인</button>
                                            	</c:if>
                                            </td>
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
		   <form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/apply/promotionList.do" name="listForm" id="listForm">
				<input type="hidden" name="pageIndex" value="1"/>
			</form>
        </div>
	</div>
<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
	function changeApproval(idx , approval){
		$.ajax({
			type:'get',
			url:'/wesell/0nI0lMy6jAzAFRVe0DqLOw/apply/promotionApproval.do?idx='+idx+'&approval='+approval,
			success:function(data){
				alert(data.msg);
				location.reload();
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
			
		})
	}
</script>
</body>
</html>