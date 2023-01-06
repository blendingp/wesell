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
	            <h1 class="h3 mb-2 text-gray-800">관리자 알림 휴대폰</h1>
	                    <div class="card shadow mb-4">
							<div class="card-header py-3">
								<h6 class="m-0 font-weight-bold text-primary">관리자 알림 휴대폰</h6>
							</div>
	                        <div class="card-body">	        									
								<form action="/wesell/admin/user/ipBanList.do" name="listForm" id="listForm">
									<div class="row">
											<input type="hidden" name="pageIndex" value="1"/>
											<div class="col-lg-4">
												<label>휴대폰 등록</label>
												<div class="form-group input-group">
													<input type="text" id="phonenum" maxlength="11" oninput="setNum(this)" class="form-control" value=""> 
													<span class="input-group-btn">
														<button class=" btn btn btn-secondary" style="padding: 6px 12px;" onclick="insertProcess()" type="button">
															등록
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
				                                            <th>idx</th>
				                                            <th>휴대폰번호</th>
				                                            <th>삭제</th>
				                                        </tr>
				                                    </thead>
				                                    <tbody>
				                                    	<c:forEach var="item" items="${list}" varStatus="i">
					                                        <tr>
					                                            <td>
					                                            	${item.idx}
					                                            </td>
					                                            <td>
					                                            	${item.phonenum}
					                                            </td>
					                                            <td>
						                                            <button type="button" onclick="deletePhone('${item.idx}')" class="btn btn-danger">삭제</button>
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
	function setNum(obj){
		val=obj.value;
	    re=/[^0-9]/gi;
	    obj.value=val.replace(re,"");
	}
	function insertProcess() {
		var url = "/wesell/admin/wdPhoneInsert.do";
		var phonenum=$("#phonenum").val();
		
		if(isNaN(phonenum)){
			alert("숫자만 입력해 주세요.");
			return;
		}
		
		$.ajax({
			type : 'post',
			url : url,
			data : {"phonenum":phonenum},
			success : function(data) {
				if (data.result == 'suc') {
					alert("번호 등록 완료되었습니다.");
					location.reload();
				} else {
					alert("err!");
				}
			},
			error : function(e) {
				console.log('ajaxError' + e);
			}
		});
	}
	function deletePhone(idx) {
		var url = "/wesell/admin/wdPhoneDelete.do";
		
		$.ajax({
			type : 'post',
			url : url,
			data : {"idx":idx},
			success : function(data) {
				if (data.result == 'suc') {
					alert("삭제되었습니다.");
					location.reload();
				} else {
					alert("err!");
				}
			},
			error : function(e) {
				console.log('ajaxError' + e);
			}
		});
	}
</script>
</body>
</html>