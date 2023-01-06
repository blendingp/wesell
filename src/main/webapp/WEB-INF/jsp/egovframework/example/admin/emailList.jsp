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
<body id="page-top">
	<div id="wrapper">
		<c:import url="/admin/left.do"/>
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">	
	                <h1 class="h3 mb-2 text-gray-800">이메일 변경 로그</h1>               		
					<div class="card shadow mb-4"> 
						<div class="card-header py-3">
             		         <h6 class="m-0 font-weight-bold text-primary">${info.name}님, 현재 이메일 ${info.email}</h6>
						</div>
						<div class="card-body">
							<form action="/wesell/admin/trade/emailList.do" name="listForm" id="listForm">
								<input type="hidden" name="pageIndex" value="1"/>									
							</form>
							<div class="table-responsive">
                               <table class="table table-striped table-hover">
                                   <thead>
                                       <tr>
                                           <th>이메일</th>
                                           <th>시간</th>
                                       </tr>
                                   </thead>
                                   <tbody>
                                   	<c:forEach var="item" items="${list}" varStatus="i">
                                       <tr>
                                           <td>${item.eEmail}</td>                                            
                                           <td>${item.edate}</td>                                            
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

</script>
</body>
</html>