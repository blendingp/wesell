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
<body id="page-top">
	<div id="wrapper">
		<c:import url="/admin/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">뉴스</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">news</h6>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-striped table-hover">
									<thead>
										<tr>
											<th>삭제</th>
											<!-- <th>이미지</th> -->
											<th>제목</th>
											<th>날짜</th>
											<th>링크</th>
										</tr>
									</thead>
									<tbody>
										<form name="insertForm" id="insertForm" method="post" enctype="multipart/form-data">
											<tr>
												<td><div onclick="insertProcess()" class="btn btn-primary">등록</div></td>
												<!-- <td><input type="file" name="img" id="img"></td> -->
												<td><input name="title"></td>
												<td><input type="date" name="ndate"></td>
												<td><input name="link"></td>
											</tr>
										</form>
										<c:forEach var="item" items="${list}" varStatus="i">
											<form id="insertForm${item.idx}" method="post" enctype="multipart/form-data">
												<input type="hidden" name="idx" value="${item.idx}">
												<tr>
													<td>
														<div onclick="deleteProcess('${item.idx}')" class="btn btn-danger">삭제</div>
														<div onclick="updateProcess('${item.idx}')" class="btn btn-primary">수정</div>
													</td>
													<%-- <td><img src="/filePath/wesell/news/${item.img}" loading="lazy" style="max-width:100px"></td> --%>
													<td>${item.title}<br><input name="title"></td>
													<td>${item.ndate}<br><input type="date" name="ndate"></td>
													<td>${item.link}<br><input name="link"></td>
												</tr>
											</form>
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
	function insertProcess(){
		var formData = new FormData($("#insertForm")[0]);
		$.ajax({
			type :"post",
			enctype : "multipart/form-data",
			processData: false,
			contentType: false,
			data : formData ,
			dataType : "json" ,
			url : "/wesell/admin/newsInsert.do",
			success:function(data){
				if(data.result == "success"){
					location.reload();
				}
				else{
					alert(data.msg);
					return;
				}
			},
			error:function(e){ console.log("ajax error"); }
		});
	}
	
	function updateProcess(idx){
		if(confirm("수정하시겠습니까?")){
			var formData = new FormData($("#insertForm"+idx)[0]);
			$.ajax({
				type :"post",
				enctype : "multipart/form-data",
				processData: false,
				contentType: false,
				data : formData ,
				dataType : "json" ,
				url : "/wesell/admin/newsUpdate.do",
				success:function(data){
					if(data.result == "success"){
						location.reload();
					}
					else{
						alert(data.msg);
						return;
					}
				},
				error:function(e){ console.log("ajax error"); }
			});
		}
	}
	
	function deleteProcess(idx){
		if(confirm("삭제하시겠습니까?")){
			var data = {"idx" : idx};
			$.ajax({
				type :"post",
				data : data ,
				dataType : "json" ,
				url : "/wesell/admin/newsDelete.do",
				success:function(data){
					if(data.result == "success"){
						location.reload();
					}
					else{
						alert(data.msg);
						return;
					}
				},
				error:function(e){ console.log("ajax error"); }
			});
		}
	}
	</script>
</body>
</html>