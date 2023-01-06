<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ page import="egovframework.example.sample.enums.AdminLog" %>
<%@ page import="egovframework.example.sample.enums.CopytraderInfo" %>
<%@ page import="egovframework.example.sample.enums.MemberInfo" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../adminFrame/header.jsp"></jsp:include>
</head>
<body id="page-top">
	<div id="wrapper">
		<c:import url="/admin/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">관리자 로그</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">관리자 로그</h6>
						</div>
						<div class="card-body">
							<!-- /.panel-heading -->
							<form action="/wesell/admin/log/log.do"
								name="listForm" id="listForm">
								<input type="hidden" name="pageIndex" value="1" />
								<div class="row">
									<div class="col-lg-4">
										<label>구분</label>
										<div class="form-group input-group">
											<select id="kind" name="kind" class="form-control input-sm"
												onchange="changeKind()">
												<option value="" <c:if test='${empty kind}'>selected</c:if>>전체</option>
												<c:forEach var="log" items="${AdminLog.values()}">
													<option value="${log.getValue()}"
														<c:if test="${!empty kind and log.getValue() eq kind}">selected</c:if>>${log.getKind()}</option>
												</c:forEach>
											</select>
										</div>
									</div>
									<div class="col-lg-4">
										<label>회원명검색</label>
										<div class="form-group input-group">
											<input type="text" name="search" class="form-control"
												value="${search}"
												onkeypress="if(event.keyCode==13) {javascript:changeKind(); return false;}">
											<span class="input-group-btn">
												<button class="btn btn-default" type="button"
													onclick="changeKind()">
													<i class="fa fa-search"></i>
												</button>
											</span>
										</div>
									</div>
								</div>
							</form>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
									<thead>
										<tr>
											<th>관리자 아이디</th>
											<th>구분</th>
											<th>회원</th>
											<th>연락처</th>
											<th>행동</th>
											<th>변경값</th>
											<th>결과</th>
											<th>코인구분</th>
											<th>시간</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr>
												<td>${item.id}</td>
												<td><c:forEach var="log" items="${AdminLog.values()}">
														<c:if test="${log.getValue() eq item.kind}">${log.getKind()}</c:if>
													</c:forEach></td>
												<td><c:if test="${item.name ne null}">
														<span style="cursor: pointer;"
															onclick="location.href='/wesell/admin/user/userDetail.do?idx=${item.uidx}'">${item.name}
															(등급 : ${item.level})</span>
													</c:if></td>
												<td><c:if test="${item.name ne null}">${item.phone} </c:if></td>
												<td><c:forEach var="log" items="${AdminLog.values()}">
														<c:if test="${log.getValue() eq item.kind}">
															<c:if test="${log eq AdminLog.UPDATE_USER}">
																<c:forEach var="meminfo" items="${MemberInfo.values()}">
																	<c:if test="${item.etc2 eq meminfo.getValue()}">${meminfo.getKind()}</c:if>
																</c:forEach>
															</c:if>
															<c:if test="${log eq AdminLog.UPDATE_TRADERINFO}">
																<c:forEach var="copyinfo"
																	items="${CopytraderInfo.values()}">
																	<c:if test="${item.etc2 eq copyinfo.getValue()}">${copyinfo.getKind()}</c:if>
																</c:forEach>
															</c:if>
	                                            			${log.getAction(item.etc2)}
	                                            		</c:if>
													</c:forEach></td>
												<td>${item.etc3}</td>
												<td>${item.etc4}</td>
												<td>${item.etc1}</td>
												<td><fmt:formatDate value="${item.adate}"
														pattern="yyyy-MM-dd HH:mm" /></td>
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
						<!-- /.panel-body -->
					</div>
					<!-- /.panel -->
					<%-- <input type="hidden" name="page" id="page" value="${em.page}"/> --%>
				</div>
			</div>
			<!-- /.row -->
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
function changeKind(){
	$("#listForm").submit();
}
function page(pageNo){
	document.listForm.pageIndex.value = pageNo;
   	document.listForm.submit();
}
</script>
</body>
</html>