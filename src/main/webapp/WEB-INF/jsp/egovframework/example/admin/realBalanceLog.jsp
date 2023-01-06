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
		<c:import url="/admin/left.do"/>
        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                	<h1 class="page-header">
						${coinname }
						<c:if test="${kind eq '1'}">realBalanceLog</c:if>
						<c:if test="${kind eq '0'}">BalanceLog</c:if>
					</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
						<div class="panel-heading">
							${coinname } 
							<c:if test="${kind eq '1'}">realBalanceLog</c:if>
							<c:if test="${kind eq '0'}">BalanceLog</c:if>
						</div>
                        <div class="panel-body">
                        	<div class="row">
							   <form action="/wesell/admin/account/realBalanceLog.do" name="listForm" id="listForm">
									<input type="hidden" name="pageIndex" value="1"/>
									<input type="hidden" name="coinname" value="${coinname}"/>
									<input type="hidden" name="kind" value="${kind}"/>
									<input type="hidden" name="useridx" value="${useridx}"/>									
								</form>
							</div>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>desc</th>
                                            <th>coinname</th>
                                            <th>price</th>
                                            <th>before</th>
                                            <th>after</th>
                                            <th>create date</th>                                                                                    
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:forEach var="item" items="${list}" varStatus="i">
                                        <tr>
                                            <td>${item.desc}</td>
                                            <td>${item.coinname}</td>
                                            <td><fmt:formatNumber value="${item.price}" pattern="#,###.########"/></td>
                                            <td><fmt:formatNumber value="${item.before}" pattern="#,###.########"/></td>
                                            <td><fmt:formatNumber value="${item.after}" pattern="#,###.########"/></td>
                                            <td><fmt:formatDate value="${item.createdate}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></td>                                                                                     
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
        </div>
	</div>
<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
function checkForm(){
	$("#listForm").submit();
}
</script>
</body>
</html>