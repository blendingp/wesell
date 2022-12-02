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
	document.listForm.fileDown.value = "0";
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
						${tname}
						<c:if test="${kind eq 'd'}"> P2P 입금신청 목록 </c:if>
						<c:if test="${kind eq 'w'}"> P2P 출금신청 목록 </c:if>
					</h1>
					<div class="row">
						<div class="col-lg-12">
							<div class="card shadow mb-4">
								<c:if test="${adminLevel ne 3}">
									<div class="card-header py-3">
										<h6 class="m-0 font-weight-bold text-primary">
											<button type="button" class="btn btn-primary btn-sm">
												총입금액:
												<fmt:formatNumber type="number" value="${alloutmoneys.sums}" />
											</button>
											<button type="button" class="btn btn-primary btn-sm">
												총출금액:
												<fmt:formatNumber type="number" value="${allinmoneys.sums}" />
											</button>
											*테스트 계정 미포함 금액 표기
										</h6>
									</div>
								</c:if>
								<!-- 
									<a href="/global/0nI0lMy6jAzAFRVe0DqLOw/account/realBalance.do?coinname=BTC&type=1">보유코인 많은순 BTC</a>
									<a href="/global/0nI0lMy6jAzAFRVe0DqLOw/account/realBalance.do?coinname=XRP&type=1">XRP</a>
									<a href="/global/0nI0lMy6jAzAFRVe0DqLOw/account/realBalance.do?coinname=TRX&type=1">TRX</a>
									<a href="/global/0nI0lMy6jAzAFRVe0DqLOw/account/realBalance.do?coinname=ETH&type=1">ETH</a> -->

								<div class="card-body">
									<form action="/global/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pLog.do"
										name="listForm" id="listForm">
										<input type="hidden" name="fileDown" id="fileDown" value="0" />
										<input type="hidden" name="pageIndex" value="1" /> <input
											type="hidden" name="kind" id="kind" value="${kind}" /> <input
											type="hidden" name="test" id="test" value="${test}" /> <input
											type="hidden" name="tidx" id="tidx" value="${tidx}" /> <input
											type="hidden" name="tname" id="tname" value="${tname}" />
										<c:if test="${except ne 0}">
											<input type="hidden" name="stat" value="${stat}" />
										</c:if>
										<div class="row">
											<%-- <input type="hidden"  name="stat" id="stat" value="${stat}"/> --%>
											<div class="col-lg-3">
												<label>기간 검색</label>
												<div class="form-group input-group">
													<div>
														<input type="date" name="sdate" id="sdate"
															value="${sdate}" class="form-control"
															style="width: 45%; display: inline-block;"
															autocomplete="off"> ~ <input type="date"
															name="edate" id="edate" value="${edate}"
															class="form-control"
															style="width: 45%; display: inline-block;"
															autocomplete="off">
													</div>
												</div>
											</div>
											<div class="col-lg-3">
												<label>검색</label>
												<div class="form-group input-group">
													<select id="searchSelect" name="searchSelect"
														class="form-control form-sm">
														<option value="name"
															<c:if test="${searchSelect eq 'name'}">selected</c:if>>회원명</option>
														<option value="email"
															<c:if test="${searchSelect eq 'email'}">selected</c:if>>이메일</option>
														<option value="inviteCode"
															<c:if test="${searchSelect eq 'inviteCode'}">selected</c:if>>InviteCode</option>
														<option value="idx"
															<c:if test="${searchSelect eq 'idx'}">selected</c:if>>UID</option>
													</select> <input type="text" name="search" class="form-control"
														value="${search}"
														onkeypress="if(event.keyCode==13) {javascript:checkForm(0); return false;}"
														style="width: auto;">
													<button class="btn btn-default" onclick="checkForm(0)"
														type="button">
														<i class="fa fa-search"></i>
													</button>
												</div>
											</div>
											<c:if test="${except eq '0'}">
												<input type="hidden" name="except" id="except"
													value="${except}" />
												<div class="col-lg-2">
													<label>상태</label>
													<div class="form-group input-group">
														<select name="kind2" class="form-control input-sm"
															style="width: fit-content; height: 34px; margin-right: 10px;"
															onchange="changeSelect()">
															<option value=""
																<c:if test="${kind2 eq ''}">selected</c:if>>전체</option>
															<option value="+"
																<c:if test="${kind2 eq '+'}">selected</c:if>>입금처리내역</option>
															<option value="-"
																<c:if test="${kind2 eq '-'}">selected</c:if>>출금처리내역</option>
														</select> <select name="stat" class="form-control input-sm"
															style="width: fit-content; height: 34px;"
															onchange="changeSelect()">
															<option value=""
																<c:if test="${stat eq ''}">selected</c:if>>처리상태</option>
															<option value="2"
																<c:if test="${stat eq '2'}">selected</c:if>>미승인</option>
															<option value="1"
																<c:if test="${stat eq '1'}">selected</c:if>>승인완료</option>
														</select>
													</div>
												</div>
											</c:if>
											<div class="col-lg-1">
												<label>계정 분류</label>
												<div class="form-group input-group">
													<span class="input-group-btn">
														<button class="btn btn-info btn-sm"
															style="padding: 6px 7px;" onclick="setTest('')"
															type="button">일반</button>
														<button class="btn btn-danger btn-sm"
															style="padding: 6px 7px;" onclick="setTest('test')"
															type="button">테스트</button>
													</span>
												</div>
											</div>
											<div class="col-lg-1">
												<label>엑셀</label>
												<div class="form-group input-group">
													<div>
														<button type="button" onclick="checkForm(1)"
															class="btn btn-outline btn-success btn-sm">
															EXCEL</button>
													</div>
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
													<th>신청시간</th>
													<th>UID</th>
													<th>회원명</th>
													<th>P2P 트레이더</th>
													<th>구분</th>
													<th>은행</th>
													<th>계좌번호</th>
													<th>금액</th>
													<th>상태</th>
													<th>채팅</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="item" items="${list}" varStatus="i">
													<tr style="background-color:${item.color}">
														<td><fmt:formatDate value="${item.mdate}" pattern="yyyy-MM-dd HH:mm" /></td>
			                                            <td>${item.useridx}</td>
														<c:if test="${item.istest eq '1'}">
															<c:if test="${adminLevel ne 3}">
																<td onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.useridx}'"
																	style="cursor: pointer;">${item.name}<span
																	style="color: red">(테스트 계정)</span> (${item.pname})
																</td>
															</c:if>
															<c:if test="${adminLevel eq 3}">
																<td>${item.name}<span style="color: red">(테스트 계정)</span> (${item.pname})</td>
																<td>${item.name}<span style="color: red">(테스트 계정)</span> (${item.pname})</td>
															</c:if>
														</c:if>
														<c:if test="${item.istest ne '1'}">
															<c:if test="${adminLevel ne 3}">
																<td onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.useridx}'" style="cursor: pointer;">
																	${item.name}(${item.pname})
																</td>
															</c:if>
															<c:if test="${adminLevel eq 3}">
																<td>${item.name}(${item.pname})</td>
															</c:if>
														</c:if>
														<td onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pList.do?search=${item.tname}'" style="cursor: pointer;">
															${item.tname}
														</td>
														<td>
															<c:if test="${item.kind eq '+'}"> 입금 </c:if> 
				                                            <c:if test="${item.kind eq '-'}"> 출금 </c:if>
			                                            </td>
														<td>${item.mbank}</td>
														<td>${item.maccount}</td>
														<td><fmt:formatNumber value="${item.money}"  pattern="#,###.####" /></td>
														<td>
															<div class="statText" widx="${item.idx}">
																<c:if test="${item.stat eq '-1'}">
				                                            		결제 대기
				                                            		<c:if test="${item.kind eq '-'}">
																		<c:if test="${item.send eq false}">(송금 대기중)</c:if>
																		<c:if test="${item.send eq true}">(송금 완료)</c:if>
																	</c:if>
																	<c:if test="${item.kind eq '-'}">
																		<c:if test="${project.name ne 'graphttok' and item.send eq false}">
																			<button class="btn btn-warning btn-sm" widx="${item.idx}" type="button" onclick="moneySend('${item.idx}')">강제 회수</button>
																		</c:if>
																	</c:if>
																	<button class="btn btn-primary btn-sm" widx="${item.idx}" type="button" onclick="payConfirm('${item.idx}')">결제 완료</button>
																</c:if>
																<c:if test="${item.stat eq '0'}">
				                                            		결제 완료
				                                            		<c:if test="${item.kind eq '+'}">
																		<button class="btn btn-primary btn-sm statBtn" widx="${item.idx}" type="button" onclick="checkRequest('${item.idx}', '1')">입금 승인</button>
																		<button class="btn btn-danger btn-sm statBtn" widx="${item.idx}" type="button" onclick="checkRequest('${item.idx}', '2')">입금 미승인</button>
																	</c:if>
																	<c:if test="${item.kind eq '-'}">
																		<button class="btn btn-primary btn-sm statBtn" widx="${item.idx}" type="button" onclick="checkRequest('${item.idx}', '1')">출금 승인</button>
																		<button class="btn btn-danger btn-sm statBtn" widx="${item.idx}" type="button" onclick="checkRequest('${item.idx}', '2')">출금 미승인</button>
																	</c:if>
																</c:if>
																<c:if test="${item.stat eq '1'}">
				                                            		완료
				                                            		<c:if test="${item.kind eq '+'}">
				                                            			&nbsp;<button class="btn btn-warning btn-sm" type="button" onclick="depositCancel('${item.idx}' , ${item.useridx})">입금취소</button>
																	</c:if>
																</c:if>
																<c:if test="${item.stat eq '2'}">
				                                            		미승인
				                                            	</c:if>
																<c:if test="${item.stat eq '3'}">
				                                            		신청 취소
				                                            	</c:if>
															</div>
														</td>
														<td><c:if test="${item.unread != 0}">
																<button class="btn btn-danger btn-sm" type="button"
																	onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pChat.do?midx=${item.idx}'">+${item.unread}</button>
															</c:if>
															<button class="btn btn-primary btn-sm statBtn"
																type="button"
																onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pChat.do?midx=${item.idx}'">채팅</button>
														</td>
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
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>

function changeSelect(){
	$("#listForm").submit();
}

function setTest(val){
	$("#test").val(val);
	checkForm();
}

function depositCancel(idx , midx){
	if(confirm("입금취소하시겠습니까?")){
		$.ajax({
			type :'get',
			url : '/global/0nI0lMy6jAzAFRVe0DqLOw/p2p/cancelDeposit.do?idx='+idx+'&midx='+midx,
			success:function(data){
				alert(data.msg);
				location.reload();
			}
		})
	}
}
function checkForm(file){
	var sdate = $("#sdate").val();
	var edate = $("#edate").val();
	var wstat = $("#stat").val();
	if((sdate == '' && edate != '') || (sdate != '' && edate == '')){
		alert("조회시작기간과 조회종료기간을 설정해주세요.");
		return;
	}
	if(edate < sdate){
		alert("조회종료기간이 조회시작기간보다 작을 수 없습니다.");
		return;
	}
	if(wstat != null || wstat != ""){
		if(wstat == 4){
			$("#stat").val(null);
		}else{
			$("#stat").val(wstat);
		}
	}
	 if(file == 0 || file == '0'){
		 document.listForm.pageIndex.value = 1;
	 }
	 
	$("#fileDown").val(file);
	$("#listForm").submit();
}
            
var requesting = false;
function checkRequest(widx,stat){
	console.log(requesting);
	if(requesting) return;
	requesting = true;
    jQuery.ajax({                                
        type:"POST", 
        url : "/global/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pWithdrawalProcess.do?widx="+widx+"&stat="+stat,
        dataType:"json",
        date:{widx:widx, stat:stat},
        success : function(data) {              	
           if(data.result == "fail")
        	   alert("금액이 부족합니다.");
           
           if(data.result == "error")
        	   alert("요청을 실패했습니다.");
           
           if(data.result == "ok"){
        	   $(".statBtn[widx="+data.idx+"]").hide();
        	   if(data.stat == 1){
        	   	  $(".statText[widx="+data.idx+"]").html("승인");
        	   }else if(data.stat == 2){
        	   	  $(".statText[widx="+data.idx+"]").html("미승인");
        	   }
           }
           location.reload();
        	   
        },
         complete : function(data) { }, 
         error : function(xhr, status , error) {console.log("ajax ERROR!!! : " );}
     });
    requesting = false;
}

function changeAlarm(idx, alarm, pkind){
	$.ajax({
		type :"post",
		dataType : "json" ,
		url : "/global/0nI0lMy6jAzAFRVe0DqLOw/trade/changeAlarm.do?idx="+idx+"&alarm="+alarm+"&kind=k"+pkind,
		success:function(data){
			if(data.result == "suc"){
				location.reload();
			}
			else{
				return;
			}
		},
		error:function(e){ console.log("ajax error"); }
	});
}

function payConfirm(widx){
    jQuery.ajax({                                
        type:"POST", 
        url : "/global/0nI0lMy6jAzAFRVe0DqLOw/p2p/payConfirm.do?widx="+widx,
        dataType:"json",
        date:{widx:widx},
        success : function(data) {              	
           if(data.result == "error")
        	   alert("요청을 실패했습니다.");
           
           location.reload();
        },
         complete : function(data) { }, 
         error : function(xhr, status , error) {console.log("ajax ERROR!!! : " );}
     });
}

function moneySend(midx){
	jQuery.ajax({
		type : "POST",
		data : {"midx" : midx},
		url : "/global/0nI0lMy6jAzAFRVe0DqLOw/p2p/moneySend.do",
		dataType : "json",
		success : function(data) {
			if (data.result != "suc") {
				alert(data.msg);
			}
			location.reload();
		},
		complete : function(data) { },
		error : function(xhr, status, error) { console.log("ajax ERROR!!! : "); }
	});
}

</script>
</body>
</html>