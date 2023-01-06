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
<script src="/wesell/se2/js/HuskyEZCreator.js" charset="utf-8" ></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<body>
<script>
function insertProcess(){
	
	if($("#useridx").val() == 0){
		var allSend = confirm("전체 발송됩니다.")
		if(!allSend) return;		
	}
	
	oEditors.getById["smartEditor"].exec("UPDATE_CONTENTS_FIELD",[]);
	var data = $("#insertForm").serialize();
	var url = "/wesell/admin/contact/messageInsert.do";
	$.ajax({
		type:'post',
		url : url,
		data: data,
		success:function(data){
			if(data.result == 'success'){
				alert("쪽지를 보냈습니다.");
				location.reload();
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
<body id="page-top">
	<div id="wrapper">
		<c:import url="/admin/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">Message Write</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">message write</h6>
						</div>
						<div class="card-body">
							<form name="insertForm" id="insertForm" method="post">
								<div class="row">
									<div class="col-lg-12">
										<div class="form-group">
											<label>제목</label>
											<input class="form-control"	placeholder="제목" name="title" id="title" maxlength="50">
										</div>
									</div>
									<div class="col-lg-12">
										<div class="form-group">
											<label>대상 </label>
											<select class="form-control selectpicker" data-live-search="true" name="useridx" id="useridx">
												<option value="0" selected>전체</option>
												<c:forEach var="item" items="${userlist}">
													<option value="${item.idx}">${item.name}
														(${item.level})
													</option>
												</c:forEach>
											</select>
										</div>
									</div>
									<div class="col-lg-12">
										<div class="form-group">
											<label>내용</label>
											<textarea class="form-control" rows="20" name="text"
												id="smartEditor"></textarea>
										</div>
									</div>
								</div>
							</form>
						</div>
					</div>
					<div class="card-body">
						<button type="button" onclick="javascript:insertProcess()"
							class="btn btn btn-secondary">쪽지 보내기
						</button>
					</div>
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
		bUseVerticalResizer : true,
		bSkipXssFilter : true,
		bUseModeChanger : true 
		},
	fOnAppLoad : function(){
	   oEditors.getById["smartEditor"].exec("PASTE_HTML", ['${text}']);
	  },		
});


</script>
</body>
</html>