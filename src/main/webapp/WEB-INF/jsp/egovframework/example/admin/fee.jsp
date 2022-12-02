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
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
        <div id="content-wrapper">        	
        	<div id="content">	        
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>	           
	            <div class="container-fluid">
                	<h1 class="h3 mb-2 text-gray-800">${coinname} 출금 수수료 변경</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">${coinname} 출금 수수료 변경</h6>
						</div>
						<div class="card-body">
							<form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/updateFee.do" name="updateForm" id="updateForm" method="post">
								<input type="hidden" name="coinname" value="${item.ftype}"/>
								<div class="row">									
									<div class="col-lg-6">
										<div class="form-group">
											<label>변경</label> * 수수료 설정은 소수점 8자리까지
											<input name="fee" id="feev" class="form-control" value="${item.fee}" >
										</div>
									</div>
								</div>							
							</form>							
						</div>						
					</div>
					<button type="button" onClick="javascript:formsubmit();" class="btn btn btn-secondary">변경</button>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
function formsubmit(){
	var fee = $("#feev").val();
	if(fee.indexOf('.') != -1){		
		var leng = (fee.substring( fee.indexOf('.')+1 )).length;		
		if( leng > 8){
			alert("소수점 8자리까지 가능합니다");
			return;
		}
	}
	
	var fm = document.getElementById('updateForm');
	fm.submit();
}
</script>
</body>
</html>