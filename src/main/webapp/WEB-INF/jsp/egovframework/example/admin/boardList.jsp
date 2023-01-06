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
		<c:import url="/admin/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">게시판</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">${type}</h6>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-striped table-hover">
									<thead>
										<tr>
											<th><input id="allChk" type="checkbox"
												onclick="allChk(this)" /></th>
											<th>번호</th>
											<th>제목</th>
											<c:if
												test="${type eq 'event' || type eq 'notice' || type eq 'faq'}">
												<th>언어</th>
											</c:if>
											<th>날짜</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr>
												<td><input type="checkbox" name="arrayIdx"
													value="${item.bidx}" /></td>
												<td
													onclick="location.href='/wesell/admin/board/${type}Detail.do?idx=${item.bidx}'"
													style="cursor: pointer">${pi.totalRecordCount - (pi.totalRecordCount - ((pi.currentPageNo-1) * pi.recordCountPerPage + i.index)-1)}</td>
												<td
													onclick="location.href='/wesell/admin/board/${type}Detail.do?idx=${item.bidx}'"
													style="cursor: pointer; width: 60%; word-break: break-all;">${item.btitle}</td>
												<c:if
													test="${type eq 'event' || type eq 'notice' || type eq 'faq'}">
													<td
														onclick="location.href='/wesell/admin/board/${type}Detail.do?idx=${item.bidx}'"
														style="cursor: pointer"><c:if
															test="${item.blang == 0}">KO</c:if> <c:if
															test="${item.blang == 1}">EN</c:if></td>
												</c:if>
												<td
													onclick="location.href='/wesell/admin/board/${type}Detail.do?idx=${item.bidx}'"
													style="cursor: pointer"><fmt:formatDate
														value="${item.bdate}" type="date"></fmt:formatDate></td>
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
						</div>
					</div>
					<form action="/wesell/admin/board/${type}List.do"
						name="listForm" id="listForm">
						<input type="hidden" name="pageIndex" value="1" /> <input
							type="hidden" name="type" value="${type}" />
					</form>
					<button type="button"
						onclick="location.href='/wesell/admin/board/${type}Write.do'"
						class="btn btn btn-secondary">글등록
					</button>
					<button type="button" onclick="listDel('${type}')"
						class="btn btn-outline btn-danger">글삭제
					</button>
				</div>				
			</div>			
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
	function allChk(obj) {
		var chkObj = document.getElementsByName("arrayIdx");
		var rowCnt = chkObj.length - 1;
		var check = obj.checked;
		if (check) {
			for (var i = 0; i <= rowCnt; i++) {
				if (chkObj[i].type == "checkbox")
					chkObj[i].checked = true;
			}
		} else {
			for (var i = 0; i <= rowCnt; i++) {
				if (chkObj[i].type == "checkbox") {
					chkObj[i].checked = false;
				}
			}
		}
	}
	function listDel(type) {
		var idx = "";
		var idxChk = document.getElementsByName("arrayIdx");
		var chked = false;
		var indexid = false;
		for (i = 0; i < idxChk.length; i++) {
			if (idxChk[i].checked) {
				if (indexid) {
					idx = idx + '-';
				}
				idx = idx + idxChk[i].value;
				indexid = true;
			}
		}
		if (!indexid) {
			alert("삭제할 글을 선택해주세요");
			return;
		}
		var param = {
			"delArray" : idx
		};
		if (confirm("삭제하시겠습니까? 복구하실 수 없습니다.")) {
			jQuery.ajax({
				type : 'post',
				data : param,
				url : "/wesell/admin/board/" + type
						+ "Delete.do",
				success : function(data) {
					if (data.result == 'success') {
						alert("삭제되었습니다.");
					} else {
						alert("에러가 발생했습니다. 다시 시도해주세요");
					}
					location.reload();
				},
				errer : function(e) {
					console.log('error' + e);
				}
			});
		} else {
			return;
		}
	}
</script>
</body>
</html>