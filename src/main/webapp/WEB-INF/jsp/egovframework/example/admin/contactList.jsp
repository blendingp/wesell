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
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">
						문의 게시판
					</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">contact</h6>
						</div>
						<div class="card-body">
							<form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/contact/contactList.do" name="listForm" id="listForm">
								<div class="col-lg-3">
									<label>검색</label>
									<div class="form-group input-group">
										<input type="hidden" name="isp2p" id="isp2p" value="${isp2p}" /> 
										<input type="hidden" name="pageIndex" value="1" /> 
										<select id="searchSelect" name="searchSelect" class="form-control">
											<option value="m.name"
												<c:if test="${searchSelect eq 'm.name'}">selected</c:if>>회원명</option>
											<option value="m.email"
												<c:if test="${searchSelect eq 'm.email'}">selected</c:if>>이메일</option>
											<option value="m.inviteCode"
												<c:if test="${searchSelect eq 'm.inviteCode'}">selected</c:if>>InviteCode</option>
											<option value="m.phone"
												<c:if test="${searchSelect eq 'm.phone'}">selected</c:if>>전화번호</option>
										</select> 
										<input type="text" name="search" class="form-control" value="${search}">
										<button class="btn btn-default" type="submit">
											<i class="fa fa-search"></i>
										</button>									
									</div>
								</div>
									
								<c:if test="${project.name eq 'wesell'}">
									<div class="col-lg-2">
										<label>구분 설정</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-info btn-sm" onclick="setP2P('')" type="button">전체</button>
												<button class="btn btn-success btn-sm" onclick="setP2P(0)" type="button">거래소</button>
												<button class="btn btn-primary btn-sm" onclick="setP2P(1)" type="button">P2P</button>
											</span>
										</div>
									</div>
								</c:if>
							</form>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-striped table-hover">
									<thead>
										<tr>
											<th class="check title" style="display: none;">삭제</th>
											<th>유저 (직속상위)</th>
											<th>휴대폰</th>
											<th>제목</th>
											<th>문의날짜</th>
											<th>읽음여부</th>
											<th>답변여부</th>
											<th>답변날짜</th>
											<th>처리</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr class="check tr"
												onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/contact/contactDetail.do?idx=${item.idx}'"
												style="cursor:pointer; background-color:${item.color}">
												<td class="check box" style="display: none;"><input
													type="checkbox" name="is_check" class="check"
													value="${item.idx}"></td>
												<td
													onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.uidx}'">${item.mname}
													(<c:if test="${item.pname eq null}">없음</c:if>${item.pname})</td>
												<td>${item.mphone}</td>
												<td style="width: 50%; word-break: break-all;">
													<c:if test="${item.isp2p eq true}"><span style="color:blue">(P2P)&ensp;</span></c:if>${item.title}
												</td>
												<td><fmt:formatDate value="${item.cdate}"
														pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></td>
												<td>${item.readYn}</td>
												<td>${item.answerYn}</td>
												<td><fmt:formatDate value="${item.adate}"
														pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></td>
												<c:if test="${item.confirm eq 0}">
													<td><button type="button"
															onclick="confirm(${item.idx})"
															class="btn btn-danger confirm">처리</button></td>
												</c:if>
												<c:if test="${item.confirm eq 1}">
													<td>처리완료</td>
												</c:if>
											</tr>
										</c:forEach>
									</tbody>
								</table>															
							</div>
							<div class="row">
								<div class="col-sm-12" style="text-align: center;">
									<ul class="pagination">
										<ui:pagination paginationInfo="${pi}" type="customPage"
											jsFunction="page" />
									</ul>
								</div>
							</div>	
							<button type="button" onclick="deleteMode()" id="deleteBtn"
								class="btn btn-danger">삭제
							</button>
							<button type="button" onclick="deleteRelease()"
								style="display: none;" id="deleteRelease"
								class="btn btn-primary">해제
							</button>
							<button type="button" onclick="allSelect()"
								style="display: none;" id="allSelectBtn"
								class="btn btn-default">전체선택
							</button>
							<button type="button" onclick="deleteSubmit()"
								style="display: none;" id="deleteSubmit" class="btn btn-danger">삭제
								적용
							</button>
						</div>
					</div>
				</div>
			</div>
			<br />
		</div>
		<br /> <br />
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
function setP2P(val){
	$("#isp2p").val(val);
	$("#listForm").submit();
}
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
function deleteRelease(){
	location.reload();
}
function deleteSubmit(){
	let checkedVal = "";
	$("input:checkbox[name=is_check]").each(function() {
		if($(this).is(":checked") == true)
			checkedVal += $(this).val()+":";
	});
	location.href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/contact/contactDelete.do?idxs="+checkedVal;
}
function allSelect(){
	$("input:checkbox[name=is_check]").each(function() {
		 this.checked = true;
	});
}
function confirm(idx){
	console.log("idx");
	$.ajax({
		type:'post',
		data:{"idx" : idx},
		url:'/wesell/0nI0lMy6jAzAFRVe0DqLOw/contact/contactConfirm.do?',
		
		success:function(data){
			location.reload();
		},
		error:function(e){
			console.log('ajax Error ' + JSON.stringify(e));
		}
	})		
}

$(".confirm").click(function(e) {
	e.stopImmediatePropagation()
});
</script>
</body>
</html>