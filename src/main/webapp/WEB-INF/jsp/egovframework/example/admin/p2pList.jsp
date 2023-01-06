<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../adminFrame/header.jsp"></jsp:include>
</head>
<style>
.infoInput{
	width:130px;
}
</style>
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
					<div class="row">
						<div class="col-lg-12">
							<div class="card shadow mb-4">
								<div class="card-header py-3">
									<h6 class="m-0 font-weight-bold text-primary">P2P 목록</h6>
								</div>
								<div class="card-body">
									<form action="/wesell/admin/p2p/p2pList.do"
										name="listForm" id="listForm">
										<div class="row">
											<input type="hidden" name="pageIndex" value="1" />
											<div class="col-lg-3">
												<label>검색</label> 
												<select id="type" name="type"
													class="form-control input-sm">
													<option value="">전체</option>
													<option value="0" <c:if test="${type == 0}">selected</c:if>>판매자</option>
													<option value="1" <c:if test="${type == 1}">selected</c:if>>구매자</option>
												</select>
											</div>
											<div class="col-lg-4">
												<label> </label>
												<div class="form-group input-group">
													<input type="text" name="search"
														class="form-control input-sm" value="${search}"
														placeholder="이름"> 
														<span class="input-group-btn">
														<button class="btn btn-default" type="submit">
															<i class="fa fa-search"></i>
														</button>
													</span>
												</div>
											</div>
										</div>
									</form>
								</div>
								<div class="card-body">
									<div class="table-responsive">
										<table class="table table-striped table-hover">
											<thead>
												<tr>
													<th>번호</th>
													<th>타입</th>
													<th>이름</th>
													<th>주문 수</th>
													<th>가격</th>
													<th>판매 수량</th>
													<th>최소 수량</th>
													<th>최대 수량</th>
													<th>평균 시간(분)</th>
													<th>은행</th>
													<th>계좌번호</th>
													<th>예금주</th>
													<th>메세지</th>
												</tr>
											</thead>
											<c:forEach var="item" items="${p2pList}" varStatus="i">
												<c:set var="kind" value="d" />
												<tbody>
													<td>${item.idx}</td>
													<td class="infoInput"><c:if test="${item.type == 0}">
															<c:set var="kind" value="d" /> 구매&nbsp;</c:if> <c:if
															test="${item.type == 1}">
															<c:set var="kind" value="w" /> 판매&nbsp;</c:if></td>
													<form name="infoForm${item.idx}" id="infoForm${item.idx}"
														method="post">
														<input type="hidden" name="idx" value="${item.idx}" />
														<td><input class="infoInput" type="text" name="name"
															value="${item.name}">&nbsp;</td>
														<td><input class="infoInput" type="text"
															name="orders" value="${item.orders}">&nbsp;</td>
														<td><input class="infoInput" type="text" name="price"
															value="${item.price}">&nbsp;</td>
														<td><input class="infoInput" type="text" name="qty"
															value="${item.qty}">&nbsp;</td>
														<td><input class="infoInput" type="text"
															name="lowLimit" value="${item.lowLimit}">&nbsp;</td>
														<td><input class="infoInput" type="text"
															name="maxLimit" value="${item.maxLimit}">&nbsp;</td>
														<td><input class="infoInput" type="text"
															name="aveTime" value="${item.aveTime}">&nbsp;</td>
														<td><input class="infoInput" type="text" name="bank"
															value="${item.bank}">&nbsp;</td>
														<td><input class="infoInput" type="text"
															name="banknum" value="${item.banknum}">&nbsp;</td>
														<td><input class="infoInput" type="text"
															name="bankname" value="${item.bankname}">&nbsp;</td>
														<td><input class="infoInput" type="text" name="msg"
															value="${item.msg}">&nbsp;</td>
														<td>
															<button type="button" onclick="infoUpdate(${item.idx})"
																class="btn btn btn-secondary">변경</button>
														</td>
														<td class="infoblock">
															<button type="button"
																onclick="location.href='/wesell/admin/p2p/p2pLog.do?kind=${kind}&tidx=${item.idx}&tname=${item.name}'"
																class="btn btn-primary btn-xs">내역</button>
														</td>
														<td class="infoblock">
															<button type="button" onclick="p2pDelete(${item.idx})"
																class="btn btn-danger btn-xs">삭제</button>
														</td>
													</form>
												</tbody>
											</c:forEach>
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
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
</body>
<script>
function checkForm(level){
	$("#listForm").submit();
}
function p2pDelete(idx){
	if(confirm("삭제하시겠습니까? 복구하실수없습니다.")){
		$.ajax({
			type:'get',
			url:'/wesell/admin/p2p/p2pDelete.do?idx='+idx,
			success:function(data){
				alert(data.msg);
				location.reload();
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
}
function infoUpdate(useridx){
	
	var data = $("#infoForm"+useridx).serialize();
	$.ajax({
		type :'post',
		data : data,
		url:'/wesell/admin/p2p/p2pUpdate.do',
		success:function(data){
			alert(data.msg);
			if(data.result=="suc")
				location.reload();
		},
		error:function(e){
			console.log('ajax Error ' + JSON.stringify(e));
		}
	})
}
</script>
</html>