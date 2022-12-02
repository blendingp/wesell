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
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>		
        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                	<h1 class="page-header">관리자 비밀번호 설정</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
						<div class="panel-heading">관리자 비밀번호 설정</div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>id</th>
                                            <th>password</th>
                                            <th>적용</th>                                            
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:forEach var="item" items="${list}" varStatus="i">
                                        <tr>
                                            <td>${item.idx}</td>
                                            <td>${item.id}</td>
                                            <td>
                                            	<input type="text" id="pw" value=""/>
                                            </td>
                                            <td>
                                            	<button type="button" onclick="setPassword(this,${item.idx})" class="btn btn-primary">변경</button>
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

function setPassword(node,idx){
	var password = $(node).parent().prev().children("#pw").val();
	if(password == ""){
		alert("변경할 패스워드를 입력해주세요.");
		return;
	}
    jQuery.ajax({
        type:"POST",
        url :"/global/0nI0lMy6jAzAFRVe0DqLOw/setPassword.do?idx="+idx+"&pw="+password,
        dataType:"json",
        success : function(data) {
			alert(data.msg);
			location.reload();
        },
        complete : function(data) { },
        error : function(xhr, status , error){console.log("ajax ERROR!!! : " );}

      });	
}
</script>
</body>
</html>