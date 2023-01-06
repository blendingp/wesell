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
<body>
	<div id="wrapper">
		<jsp:include page="../adminFrame/top.jsp"></jsp:include>
		<c:import url="/admin/left.do"/>
        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                	<h1 class="page-header">어드민 접속 기록</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-body">
                        	<div class="row">
							   <form action="/wesell/admin/log/accessLog.do" name="listForm" id="listForm">
									<input type="hidden" id="pass" name="pass" value="${pass}"/>
									<div class="col-lg-1">
										<label>접속여부</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-default btn-xs" style="padding: 6px 7px;" onclick="checkForm(0)" type="button">전체</button>
												<button class="btn btn-primary btn-xs" style="padding: 6px 7px;" onclick="checkForm(1)" type="button">접속</button>
												<button class="btn btn-danger btn-xs" style="padding: 6px 7px;" onclick="checkForm(2)" type="button">접속실패</button>
											</span>
										</div>
									</div>
								</form>
							</div>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>일자</th>
                                            <th>IP</th>
                                            <th>접속시도 ID</th>
                                            <th>접속 유저</th>
                                            <th>접속여부</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:forEach var="item" items="${list}" varStatus="i">
	                                        <tr>
	                                            <td><fmt:formatDate value="${item.date}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></td>
	                                            <td>${item.ip}</td>
	                                            <td>${item.atID}</td>
	                                            <td>${item.loginuser}</td>
	                                            <td>
	                                            	<c:choose>
	                                            		<c:when test="${item.pass eq true}">접속</c:when>
	                                            		<c:when test="${item.pass eq false}">접속 실패</c:when>
	                                            	</c:choose>
	                                            </td>
	                                        </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>
<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
function checkForm(pass){
	switch(pass){
	case 0:$("#pass").val(""); break;
	case 1:$("#pass").val(1); break;
	case 2:$("#pass").val(0); break;
	}
	$("#listForm").submit();
}
</script>
</body>
</html>