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
.infoblock{
	background-color:lightsteelblue;
}
.infoInput{
	width:95px;
}
.btn{
	word-break:keep-all;
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
		<div id="wrapper">
			<div class="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">트레이더 신청 회원 목록</h6>
						</div>
						<div class="card-body">
							<form
								action="/wesell/admin/trader/traderList.do"
								name="listForm" id="listForm">
								<div class="row">
									<input type="hidden" name="pageIndex" value="1" />
									<div class="col-lg-3">
										<label>검색</label>
										<div class="form-group input-group">
											<select id="tstat" name="tstat" class="form-control">
												<option value="">전체</option>
												<option value="0" <c:if test="${tstat == 0}">selected</c:if>>미승인</option>
												<option value="1" <c:if test="${tstat == 1}">selected</c:if>>승인</option>
											</select>
										</div>
									</div>
									<div class="col-lg-2">
										<label></label>
										<div class="form-group input-group">
											<input type="text" name="search" class="form-control"
												value="${search}"> <span class="input-group-btn">
												<button class="btn btn-warning" type="submit">
													<i class="fa fa-search"></i>
												</button>
											</span>
										</div>
									</div>
								</div>
							</form>
							<div class="card-body">
								<div class="table-responsive">
									<table class="table table-striped table-hover">
										<thead>
											<tr>
												<th>팔로워 목록</th>
												<th>회원 이름</th>
												<th>total</th>
												<th>승인여부</th>
												<th>팔로워 작성</th>
												<th class="infoInput">팔로워</th>
												<th class="infoInput">누적 팔로워</th>
												<th>정보 작성</th>
												<th class="infoInput">수익률</th>
												<th class="infoInput">거래 수량</th>
												<th class="infoInput">수익</th>
												<th class="infoInput">이익</th>
												<th class="infoInput">손실</th>
												<th class="infoInput">승률</th>
												<th class="infoInput">적용</th>
											</tr>
										</thead>
										<c:forEach var="item" items="${traderList}" varStatus="i">
											<tbody>
												<td>
													<button type="button" onclick="location.href='/wesell/admin/trader/followerList.do?tidx=${item.tuseridx}'" class="btn btn-primary">목록</button>
												</td>
											
												<td style="cursor: pointer;"
													onclick="location.href='/wesell/admin/user/userDetail.do?idx=${item.tuseridx}'">${item.name}&nbsp;</td>
												<td>
													<input type="text"  id="total${item.tuseridx}" value="${item.total}">
													<button type="button" onclick="changeTotal(${item.tidx}, ${item.tuseridx})" class="btn btn-warning btn-sm">변경</button>
												</td>
												<td>
													<c:if test="${item.tstat == 0}"> 
														미승인&nbsp;
		                                            	<button type="button" onclick="changeTstat(${item.tidx}, ${item.tuseridx} , 1,1)" class="btn btn-warning btn-sm">승인</button>
														<button type="button" onclick="traderDelete(${item.tidx}, ${item.tuseridx})" class="btn btn-warning btn-sm">삭제</button>
													</c:if> 
													<c:if test="${item.tstat == 1}"> 
														승인&nbsp;
		                                            	<button type="button" onclick="changeTstat(${item.tidx}, ${item.tuseridx}, 0,0)" class="btn btn-warning btn-sm">미승인</button>
													</c:if>
												</td>
												<form name="infoForm${item.tuseridx}" id="infoForm${item.tuseridx}" method="post">
													<input type="hidden" name="useridx" value="${item.tuseridx}" />
													<td class="infoblock">
														<c:if test="${item.infoidx eq null or item.useFollow eq false}">미사용 
															<button type="button" onclick="traderinfoUse(${item.tuseridx},1,0)" class="btn btn-warning btn-sm">사용</button>
														</c:if> 
														<c:if test="${item.useFollow eq true}">
															사용 <button type="button" onclick="traderinfoUse(${item.tuseridx},0,0)" class="btn btn-warning btn-sm">미사용</button>
														</c:if>
													</td>
													<td class="infoblock">
														<c:if test="${item.follow eq null or item.useFollow eq false}">-</c:if>
														<c:if test="${item.useFollow eq true}">
															<input class="infoInput" type="text" name="follow" value="${item.follow}">
														</c:if>
													</td>
													<td class="infoblock">
														<c:if test="${item.fAccum eq null or item.useFollow eq false}">-</c:if>
														<c:if test="${item.useFollow eq true}">
															<input class="infoInput" type="text" name="fAccum" value="${item.fAccum}">
														</c:if>
													</td>
													<td class="infoblock">
														<c:if test="${item.infoidx eq null or item.useOtherInfo eq false}">
															미사용 <button type="button" onclick="traderinfoUse(${item.tuseridx},1,1)" class="btn btn-warning btn-sm">사용</button>
														</c:if> 
														<c:if test="${item.useOtherInfo eq true}">
															사용 <button type="button" onclick="traderinfoUse(${item.tuseridx},0,1)" class="btn btn-warning btn-sm">미사용</button>
														</c:if>
													</td>
													<td class="infoblock">
														<c:if test="${item.infoidx eq null or item.useOtherInfo eq false}">-</c:if>
														<c:if test="${item.useOtherInfo eq true}">
															<input class="infoInput" type="text" name="profitRate" value="${item.profitRate}">
														</c:if>
													</td>
													<td class="infoblock">
														<c:if test="${item.infoidx eq null or item.useOtherInfo eq false}">-</c:if>
														<c:if test="${item.useOtherInfo eq true}">
															<input class="infoInput" type="text" name="tradeCount" value="${item.tradeCount}">
														</c:if>
													</td>
													<td class="infoblock">
														<c:if test="${item.infoidx eq null or item.useOtherInfo eq false}">-</c:if>
														<c:if test="${item.useOtherInfo eq true}">
															<input class="infoInput" type="text" name="revenue" value="${item.revenue}">
														</c:if>
													</td>
													<td class="infoblock">
														<c:if test="${item.infoidx eq null or item.useOtherInfo eq false}">-</c:if>
														<c:if test="${item.useOtherInfo eq true}">
															<input class="infoInput" type="text" name="avail" value="${item.avail}">
														</c:if>
													</td>
													<td class="infoblock">
														<c:if test="${item.infoidx eq null or item.useOtherInfo eq false}">-</c:if>
														<c:if test="${item.useOtherInfo eq true}">
															<input class="infoInput" type="text" name="loss" value="${item.loss}">
														</c:if>
													</td>
													<td class="infoblock">
														<c:if test="${item.infoidx eq null or item.useOtherInfo eq false}">-</c:if>
														<c:if test="${item.useOtherInfo eq true}">
															<input class="infoInput" type="text" name="winRate" value="${item.winRate}">
														</c:if>
													</td>
													<td class="infoblock">
														<c:if test="${item.useOtherInfo eq false and item.useFollow eq false}">-</c:if>
														<c:if test="${item.useOtherInfo eq true or item.useFollow eq true}">
															<button type="button" onclick="traderinfoWrite(${item.tuseridx})" class="btn btn-warning btn-sm">변경</button>
														</c:if>
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
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
</body>
<script>
function checkForm(level){
	$("#listForm").submit();
}
function changeTstat(idx , useridx, tstat ,istrader){
	if(confirm("변경하시겠습니까?")){
		$.ajax({
			type:'get',
			url:'/wesell/admin/trader/tstat.do?idx='+idx+'&useridx='+useridx+'&tstat='+tstat+'&istrader='+istrader,
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
function changeTotal(idx, useridx){
	let total = $("#total"+useridx).val();
	if(confirm("변경하시겠습니까?")){
		$.ajax({
			type:'get',
			url:'/wesell/admin/trader/total.do?idx='+idx+'&total='+total+'&useridx='+useridx,
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
function traderDelete(idx,useridx){
	if(confirm("삭제하시겠습니까? 복구하실수없습니다.")){
		$.ajax({
			type:'get',
			url:'/wesell/admin/trader/traderDelete.do?idx='+idx+'&useridx='+useridx,
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
function traderinfoUse(useridx,use,type){
	$.ajax({
		type:'get',
		url:'/wesell/admin/trader/traderinfoUse.do?useridx='+useridx+'&use='+use+'&type='+type,
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
function traderinfoWrite(useridx){
	
	var data = $("#infoForm"+useridx).serialize();
	$.ajax({
		type :'post',
		data : data,
		url:'/wesell/admin/trader/traderinfoWrite.do',
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