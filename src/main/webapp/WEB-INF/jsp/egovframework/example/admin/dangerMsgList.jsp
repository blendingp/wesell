<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ page import="egovframework.example.sample.enums.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../adminFrame/header.jsp"></jsp:include>
</head>
<body id="page-top">
		<div id="wrapper">	
			<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
	        <div id="content-wrapper">	           
        		<div id="content">        		
					<jsp:include page="../adminFrame/top.jsp"></jsp:include>   
	        		  <div class="container-fluid">
			            <div class="row">
			                <div class="col-lg-12">
			                	<h1 class="h3 mb-2 text-gray-800">주의회원 알림 </h1>
			                </div>
			            </div>
			            <div class="row">
			                <div class="col-xl-8 col-lg-7">
			                    <div class="card shadow mb-4">
			                        <div class="card-body">
			                            <div class="table-responsive">
			                                <table class="table table-striped table-hover">
			                                    <thead>
			                                        <tr style="width:50px;">
			                                            <th class="check title" style="display:none;">삭제</th>
			                                            <th>알림</th>
			                                        </tr>
			                                    </thead>
			                                    <tbody>
			                                    	<c:forEach var="item" items="${list}" varStatus="i">
				                                        <tr class="check tr">
				                                        	<td class="check box" style="display:none;"><input type="checkbox" name="is_check" class="check" value="${i.index}"></td>
				                                            <td style="word-break:break-all;">${item}</td>
				                                        </tr>
			                                        </c:forEach>
			                                    </tbody>
			                                </table>
			                            </div>
										<button type="button" onclick="deleteMode()" id="deleteBtn" class="btn btn-danger">삭제</button>
										<button type="button" onclick="deleteRelease()" style="display:none;" id="deleteRelease" class="btn btn-primary">해제</button>
										<button type="button" onclick="allSelect()" style="display:none;" id="allSelectBtn" class="btn btn-default">전체선택</button>
										<button type="button" onclick="deleteSubmit()" style="display:none;" id="deleteSubmit" class="btn btn-danger">삭제 적용</button>
			                        </div>
			                    </div>
			                </div>
			            </div>
						<br/>
					</div>
				</div>
			<br/><br/>
		</div>
	</div>
<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
function deleteMode(){
	$("#deleteSubmit").css("display","inline-block");
	$("#deleteBtn").css("display","none");
	$("#deleteRelease").css("display","inline-block");
	$("#allSelectBtn").css("display","inline-block");
	$(".check.title").css("display","flex");
	$(".check.box").css("display","flex");
	$(".check.tr").attr("onclick","");
}
function deleteRelease(){
	location.reload();
}
function deleteSubmit(){
	let checkedVal = "";
	$("input:checkbox[name=is_check]").each(function() {
		if($(this).is(":checked") == true)
			checkedVal += $(this).val()+":";
	});
	location.href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/dangerDelete.do?idxs="+checkedVal;
}
function allSelect(){
	$("input:checkbox[name=is_check]").each(function() {
		 this.checked = true;
	});
}
</script>
</body>
</html>