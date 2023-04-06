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
function updateProcess(type){
	oEditors.getById["smartEditor"].exec("UPDATE_CONTENTS_FIELD",[]);
	var data = $("#updateForm").serialize();
	var url = "/wesell/admin/board/"+type+"Update.do";
	$.ajax({
		type:'post',
		url : url,
		data: data,
		success:function(data){
			if(data.result == 'success'){
				alert("글 수정이 완료되었습니다.");
				location.href="/wesell/admin/board/"+type+"List.do";
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
		<c:import url="/admin/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">${fn:toUpperCase(fn:substring(type, 0, 1))}${fn:substring(type, 1, fn:length(type))}Write</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">${type} update form</h6>
						</div>
						<div class="card-body">
							<form name="updateForm" id="updateForm" method="post">
								<input type="hidden" name="idx" value="${info.bidx}"/>
								<div class="row">
									<div class="col-lg-12">
										<div class="form-group">
											<label>제목</label> 
											<input class="form-control" value="${info.btitle}" name="title" id="title" maxlength="100">
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>날짜</label> 
											<input type="date" class="form-control" value="${info.bdate}" name="bdate" id="bdate" maxlength="100">
										</div>
									</div>
									<div class="col-lg-12">
										<div class="form-group">
											<label>내용</label>
											<c:if test="${type eq 'notice' || type eq 'event' || type eq 'faq'}">
												<select name="blang">
													<option value="0" <c:if test="${info.blang eq 0}">selected</c:if>>KO(한국어)</option>
													<option value="1" <c:if test="${info.blang eq 1}">selected</c:if>>EN(영어)</option>
													<option value="3" <c:if test="${info.blang eq 3}">selected</c:if>>CH(중국어)</option>
												</select>
											</c:if>
											<c:if test="${type eq 'faq'}">
												<c:if test="${project.name eq 'BITWIN'}">
													<label style="margin-left:20px;">구분</label>
													<select name="bwhere">
														<c:forEach var="type" items="${faqType.values()}">
															<option value="${type.getValue()}" <c:if test="${info.bwhere eq type.getValue()}">selected</c:if>>${type.getName()}</option>
														</c:forEach>
													</select>
												</c:if>
											</c:if>
											<textarea class="form-control" rows="20" name="text" id="smartEditor">${info.bcontent}</textarea>
										</div>
									</div>
								</div>
							</form>
						</div>
					</div>
					<button type="button" onclick="javascript:updateProcess('${type}')" class="btn btn btn-secondary">글 수정</button>
					<button type="button" onclick="javascript:delProcess('${type}' , ${info.bidx})" class="btn btn-danger">글 삭제</button>	
				</div>
			</div>			
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
var oEditors = []; 
nhn.husky.EZCreator.createInIFrame({ 
	oAppRef : oEditors, 
	elPlaceHolder : "smartEditor",  
	sSkinURI : "${pageContext.request.contextPath}/se2/SmartEditor2Skin.html",  
	fCreator : "createSEditor2", 
	htParams : {  
		bUseToolbar : true,  
		bUseVerticalResizer : false,
		//bSkipXssFilter : true,
		bUseModeChanger : false 
		},
});
function delProcess(type , idx){
	var param = {"delArray" : idx};
	if(confirm("삭제하시겠습니까? 복구하실 수 없습니다.")){
		jQuery.ajax({
			type:'post',
			data:param,
			url:"/wesell/admin/board/"+type+"Delete.do",
			success:function(data){
				if(data.result == 'success'){
					alert("삭제되었습니다.");
					location.href= "/wesell/admin/board/"+type+"List.do";
				}else{
					alert("에러가 발생했습니다. 다시 시도해주세요");
					location.reload();
				}
			},
			errer:function(e){
				console.log('error' + e);
			}
		});
	}else{
		return;
	}
}
</script>
</body>
</html>