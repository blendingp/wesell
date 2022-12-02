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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.min.css">
</head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/i18n/defaults-*.min.js"></script>
<style>
.kycImage{
	max-width:100%;
	max-height:450px;
}
</style>
<body id="page-top">
	<div id="wrapper">
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
		<div id="content-wrapper">
        	<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
        		<div class="container-fluid">
        			<h1 class="h3 mb-2 text-gray-800">KYC Info</h1>
					<div class="row">
						<c:if test="${fn:length(fileList) > 0}">
							<div class="col-lg-12">
								<div class="form-group">
									<label>첨부 파일 </label>
									<c:forEach var="item" items="${fileList}">
										<div><a href="/filePath/global/photo/${item.saveNm}" download>${item.originNm}</a></div>
										<div><img class="kycImage" src="/filePath/global/photo/${item.saveNm}"></div><br>
									</c:forEach> 
								</div>
							</div>
						</c:if>
					</div>
					<button type="button" onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userList.do'" class="btn btn-default">목록</button>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
	<script>
	</script>
</body>
</html>