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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<body id="page-top">
	<div id="wrapper">
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">사이트 점검</h1>
					<!-- /.col-lg-12 -->
					<!-- /.row -->
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">
								<c:if test="${fixstat eq 0}">운영중</c:if>
								<c:if test="${fixstat eq 1}">점검중</c:if>
							</h6>
						</div>
						<div class="card-body">
							<div>
								<c:if test="${fixstat eq 0}">
									<button type="button"
										onClick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/statchange.do?stat=1'"
										class="btn btn-primary">점검상태로 변동</button>
								</c:if>
								<c:if test="${fixstat eq 1}">
									<button type="button"
										onClick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/statchange.do?stat=0'"
										class="btn btn-primary">운영상태로 변동</button>
								</c:if>
							</div>
							<!-- /.panel-body -->
							<div class="panel-body">
								<div class="table-responsive"></div>
								<!-- /.table-responsive -->
							</div>
						</div>
					</div>
					<!-- /.panel -->
					<!-- /.col-lg-6 -->

				</div>
				<!-- /.row -->
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
</body>
</html>