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
                	<h1 class="page-header">등급 변경 로그</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
						<div class="panel-heading">level log</div>
                        <div class="panel-body">
                        	<div class="row">
							   <form action="/wesell/admin/log/levelLog.do" name="listForm" id="listForm">
									<input type="hidden" name="pageIndex" value="1"/>
									<div class="col-lg-4">
										<div class="form-group">
											<label>기간 검색</label>
											<div>
												<input type="date" name="sdate" id="sdate" value="${sdate}" class="form-control" style="width: 45%; display: inline-block;" autocomplete="off">
												 ~ 
												<input type="date" name="edate" id="edate" value="${edate}" class="form-control" style="width: 45%; display: inline-block;" autocomplete="off">
											</div>
										</div>
									</div>
									<div class="col-lg-4" style="width:150px;">
										<label>검색</label>
										<select id="searchSelect" name="searchSelect" class="form-control input-sm" style="height:34px;">
											<option value="m.name"<c:if test="${searchSelect eq 'm.name'}">selected</c:if>>회원명</option>
											<option value="p.userIdx"<c:if test="${searchSelect eq 'p.userIdx'}">selected</c:if>>UID</option>
										</select>
									</div>
									<div class="col-lg-4" style="width:350px;">
										<label>　</label>
										<div class="form-group input-group">
											<input type="text" name="search" class="form-control" value="${search}"> 
											<span class="input-group-btn">
												<button class="btn btn-default" style="padding: 6px 12px;" type="submit">
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
                                        <tr>
                                            <th>UID</th>
                                            <th>이름</th>
                                            <th>변경전</th>
                                            <th>변경후</th>
                                            <th>변경부분</th>
                                            <th>변경자</th>
                                            <th>날짜</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:forEach var="item" items="${list}" varStatus="i">
                                        <tr>
                                            <td>00${item.userIdx}</td>
                                            <td>${item.name}</td>
                                            <td>${item.bf}</td>
                                            <td>${item.af}</td>
                                            <td>
                                            	<c:if test="${item.kind eq 0}">등급변경</c:if>
                                            	<c:if test="${item.kind eq 1}">부모회원 변경</c:if>
                                            	<c:if test="${item.kind eq 2}">상위회원들 변경</c:if>
                                            </td>
                                            <td>${item.admin}</td>
                                            <td><fmt:formatDate value="${item.ldate}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></td>
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