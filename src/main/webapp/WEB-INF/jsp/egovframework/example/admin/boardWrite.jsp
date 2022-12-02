<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ page import="egovframework.example.sample.enums.faqType" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../adminFrame/header.jsp"></jsp:include>
</head>
<script src="/wesell/se2/js/HuskyEZCreator.js" charset="utf-8" ></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<body id="page-top">
<script>
function insertProcess(type){
	oEditors.getById["smartEditor"].exec("UPDATE_CONTENTS_FIELD",[]);
	var data = $("#insertForm").serialize();
	var url = "/wesell/0nI0lMy6jAzAFRVe0DqLOw/board/"+type+"Insert.do";
	$.ajax({
		type:'post',
		url : url,
		data: data,
		success:function(data){
			if(data.result == 'success'){
				alert("글 등록이 완료되었습니다.");
				location.href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/board/"+type+"List.do";
			}else{
				alert(data.msg);
			}
		},
		error:function(e){
			console.log('ajaxError' + e);
		}
	});
}
</script>
	<div id="wrapper">
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">${fn:toUpperCase(fn:substring(type, 0, 1))}${fn:substring(type, 1, fn:length(type))}Write</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">${type}write form
							</h6>
						</div>
						<div class="card-body">
							<form name="insertForm" id="insertForm" method="post">
								<div class="row">
									<div class="col-lg-12">
										<div class="form-group">
											<label>제목</label> <input class="form-control"
												placeholder="제목" name="title" id="title" maxlength="100">
										</div>
									</div>
									<div class="col-lg-12">
										<div class="form-group">
											<label>내용</label>
											<c:if test="${type eq 'notice'}">
												<select name="blang">
													<option value="0" selected>KO(한국어)</option>
													<option value="1">EN(영어)</option>
												</select>
											</c:if>
											<c:if test="${(type eq 'event') or (type eq 'faq')}">
												<select name="blang">
													<option value="0" selected>KO(한국어)</option>
													<option value="1">EN(영어)</option>
												</select>
											</c:if>
											<c:if test="${type eq 'faq'}">
												<c:if test="${project.name eq 'BITWIN'}">
													<label style="margin-left:20px;">구분</label>
													<select name="bwhere">
														<c:forEach var="type" items="${faqType.values()}">
															<option value="${type.getValue()}">${type.getName()}</option>
														</c:forEach>
													</select>
												</c:if>
											</c:if>
											<textarea class="form-control" rows="20" name="text" id="smartEditor"></textarea>
										</div>
									</div>
								</div>
							</form>
						</div>						
					</div>
					<button type="button" onclick="javascript:insertProcess('${type}')" class="btn btn btn-secondary">글 등록</button>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
	var oEditors = [];
	nhn.husky.EZCreator
			.createInIFrame({
				oAppRef : oEditors,
				elPlaceHolder : "smartEditor",
				sSkinURI : "${pageContext.request.contextPath}/se2/SmartEditor2Skin.html",
				fCreator : "createSEditor2",
				htParams : {
					bUseToolbar : true,
					bUseVerticalResizer : true,
					bSkipXssFilter : true,
					bUseModeChanger : true
				},
				fOnAppLoad : function() {
					oEditors.getById["smartEditor"].exec("PASTE_HTML",
							[ '${text}' ]);
				},
			});
</script>
</body>
</html>