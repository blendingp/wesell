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
					<h1 class="h3 mb-2 text-gray-800">${username}입출금 목록</h1>
					<div class="row">
						<div class="col-lg-12">
							<div class="card shadow mb-4">
								<div class="card-body">
									<form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/transactions.do"
										name="listForm" id="listForm">
										<input type="hidden" name="fileDown" id="fileDown" value="0" />
										<input type="hidden" name="pageIndex" value="1" /> <input
											type="hidden" name="username" id="username"
											value="${username}" /> <input type="hidden" name="searchIdx"
											id="searchIdx" value="${searchIdx}" /> <input type="hidden"
											name="order" id="order" value="${order}" /> <input
											type="hidden" name="orderAD" id="orderAD" value="${orderAD}" />
										<input type="hidden" name="test" id="test" value="${test}" />
										<div class="row">
											<div class="col-lg-3">
												<label>기간 검색</label>
												<div class="form-group input-group">
													<div>
														<input type="date" name="sdate" id="sdate"
															value="${sdate}" class="form-control form-sm"
															style="width: 45%; display: inline-block;"
															autocomplete="off"> ~ <input type="date"
															name="edate" id="edate" value="${edate}"
															class="form-control form-sm"
															style="width: 45%; display: inline-block;"
															autocomplete="off">
													</div>
												</div>
											</div>
											<div class="col-lg-1">
												<label>코인</label> <select onchange="checkForm()" id="coin"
													name="coin" class="form-control input-sm">
													<option value="" <c:if test="${coin eq ''}">selected</c:if>>전체</option>
													<option value="BTC"
														<c:if test="${coin eq 'BTC'}">selected</c:if>>BTC</option>
													<option value="USDT"
														<c:if test="${coin eq 'USDT'}">selected</c:if>>USDT</option>
													<option value="ETH"
														<c:if test="${coin eq 'ETH'}">selected</c:if>>ETH</option>
													<option value="XRP"
														<c:if test="${coin eq 'XRP'}">selected</c:if>>XRP</option>
													<option value="TRX"
														<c:if test="${coin eq 'TRX'}">selected</c:if>>TRX</option>
												</select>
											</div>
											<div class="col-lg-5">
												<label>검색</label>
												<div class="form-group input-group">
													<select id="searchSelect" name="searchSelect"
														class="form-control form-sm">
														<option value="name"
															<c:if test="${searchSelect eq 'name'}">selected</c:if>>회원명</option>
														<%--<option value="email"<c:if test="${searchSelect eq 'email'}">selected</c:if>>이메일</option> --%>
														<%--<option value="inviteCode"<c:if test="${searchSelect eq 'inviteCode'}">selected</c:if>>InviteCode</option> --%>
														<option value="idx" <c:if test="${searchSelect eq 'idx'}">selected</c:if>>UID</option>
													</select> <input type="text" name="search"
														class="form-control form-sm" value="${search}"
														style="width: auto;">
													<button class="btn btn-default btn-sm"
														onclick="checkForm(2)" type="button">
														<i class="fa fa-search"></i>
													</button>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-lg-2">
												<label>상태</label>
												<div class="form-group input-group">
													<span class="input-group-btn btn-sm"> <input
														type="hidden" name="wstat" id="wstat" value="${wstat}" />
														<button class="btn btn-light btn-icon-split"
															onclick="checkForm(2)" type="button">전체</button>
														<button class="btn btn-info btn-sm" onclick="checkForm(0)"
															type="button">대기</button>
														<button class="btn btn-success btn-sm"
															onclick="checkForm(1)" type="button">완료</button>
													</span>
												</div>
											</div>
											<div class="col-lg-2">
												<label>입/출금</label>
												<div class="form-group input-group">
													<span class="input-group-btn"> <input type="hidden"
														name="label" id="label" value="${label}" />
														<button class="btn btn-default btn-sm"
															onclick="checkForm(2,0)" type="button">전체</button>
														<button class="btn btn-info btn-sm"
															onclick="checkForm(2,'+')" type="button">입금</button>
														<button class="btn btn-primary btn-sm"
															onclick="checkForm(2,'-')" type="button">출금</button>
													</span>
												</div>
											</div>
											<div class="col-lg-2">
												<label>테스트계정</label>
												<div class="form-group input-group">
													<span class="input-group-btn">
														<button class="btn btn-danger btn-sm"
															onclick="setTest('test')" type="button">미포함</button>
														<button class="btn btn-info btn-sm" onclick="setTest('')"
															type="button">포함</button>
													</span>
												</div>
											</div>
											<div class="col-lg-2">
												<label>정렬</label>
												<div class="form-group input-group">
													<span class="input-group-btn">
														<button class="btn btn-info btn-sm"
															onclick="setOrder('completionTime')" type="button">송금시간</button>
														<button class="btn btn-success btn-sm"
															onclick="setOrder('amount')" type="button">수량</button>
													</span>
												</div>
											</div>
											<div class="col-lg-1">
												<label>엑셀</label>
												<div class="form-group">													
													<div>
														<button type="button" onclick="checkForm(4)" class="btn btn-outline btn-success btn-sm">
															EXCEL
														</button>
													</div>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-lg-12">
												<div class="form-group">
													<b style="color: red"> ※ 총액 계산시 대기 또는 미승인 건 및 테스트 계정의
														내역 제외</b><br>
													<c:if test="${label ne '-'}">
														입금 총액 <c:if test="${dlist eq null}"> : 없음 </c:if>
														<c:forEach var="item" items="${dlist}" varStatus="i">
															<c:if test="${item.coinname eq 'BTC'}">BTC : <fmt:formatNumber
																	value="${item.sumamount}" pattern="#,###.########" />
															</c:if>
															<c:if test="${item.coinname eq 'USDT'}">USDT : <fmt:formatNumber
																	value="${item.sumamount}" pattern="#,###.########" />
															</c:if>
															<c:if test="${item.coinname eq 'XRP'}">XRP : <fmt:formatNumber
																	value="${item.sumamount}" pattern="#,###.########" />
															</c:if>
															<c:if test="${item.coinname eq 'TRX'}">TRX : <fmt:formatNumber
																	value="${item.sumamount}" pattern="#,###.########" />
															</c:if>
															<c:if test="${item.coinname eq 'ETH'}">ETH : <fmt:formatNumber
																	value="${item.sumamount}" pattern="#,###.########" />
															</c:if>
														</c:forEach>
														<br>
													</c:if>
													<c:if test="${label ne '+'}">
														출금 총액 <c:if test="${wlist eq null}"> : 없음 </c:if>
														<c:forEach var="item" items="${wlist}" varStatus="i">
															<c:if test="${item.coinname eq 'BTC'}">BTC : <fmt:formatNumber
																	value="${item.sumamount}" pattern="#,###.########" />
															</c:if>
															<c:if test="${item.coinname eq 'USDT'}">USDT : <fmt:formatNumber
																	value="${item.sumamount}" pattern="#,###.########" />
															</c:if>
															<c:if test="${item.coinname eq 'XRP'}">XRP : <fmt:formatNumber
																	value="${item.sumamount}" pattern="#,###.########" />
															</c:if>
															<c:if test="${item.coinname eq 'TRX'}">TRX : <fmt:formatNumber
																	value="${item.sumamount}" pattern="#,###.########" />
															</c:if>
															<c:if test="${item.coinname eq 'ETH'}">ETH : <fmt:formatNumber
																	value="${item.sumamount}" pattern="#,###.########" />
															</c:if>
														</c:forEach>
													</c:if>
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
													<th>송금시간</th>
													<th>UID</th>
													<th>회원명</th>
													<th>보낸 회원</th>
													<th>받은 회원</th>
													<th>코인명</th>
													<th>수량</th>
													<th>tx</th>
													<th>상태</th>
													<th>입/출금</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="item" items="${list}" varStatus="i">
													<tr style="background-color:${item.color}">
														<td><fmt:formatDate value="${item.completionTime}"
																pattern="yyyy-MM-dd HH:mm" /></td>
														<td>${item.userIdx}</td>
														<c:if test="${item.userIdx eq null }">
															<td>확인불가</td>
														</c:if>
														<c:if test="${item.userIdx ne null }">
															<td onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.userIdx}'" style="cursor: pointer;">
																<c:if test="${item.label eq '+' }">${item.fromname}</c:if>
																<c:if test="${item.label eq '-' }">${item.toname}</c:if> 
																<c:if test="${item.istest eq 1 }">
																	<span style="color: red"> (테스트 계정)</span>
																</c:if>
															</td>
														</c:if>
														<c:if test="${item.from eq 1 }">
															<td>없음</td>
														</c:if>
														<c:if test="${item.from ne 1 }">
															<td onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.from}'" style="cursor: pointer;">${item.fromname}</td>
														</c:if>
														<td onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.to}'" style="cursor: pointer;">${item.toname}</td>
														<td>${item.coin}</td>
														<td><fmt:formatNumber value="${item.amount}" pattern="#,###.########" /></td>
														<td>
															<c:if test="${item.coin eq 'XRP' and item.dtag ne null }">(D Tag:${item.dtag}) &nbsp;&nbsp;</c:if>
															<c:if test="${not empty item.tx}">
																<span class="txtext">${item.tx}</span>
																<button class="btn btn-success btn-sm" onclick="copyboard('${item.tx}', '${item.coin}')" type="button">트랜잭션조회</button>
															</c:if>
														</td>
														<td>
															<div class="statText" widx="${item.widx}">
																<c:if test="${item.status eq '0'}">
			                                            		pending	
			                                            		<!-- pending -->
																</c:if>
																<c:if test="${item.status eq '1'}">
			                                            		complete 
			                                            		<c:if test="${item.label eq '+'}">
			                                            			&nbsp;
			                                            			<button class="btn btn-warning btn-sm" type="button"
																			onclick="depositCancel('${item.idx}' , ${item.userIdx})">입금취소</button>
																</c:if>
																</c:if>
																<c:if test="${item.status eq '2'}">
			                                            		unapproved
			                                            		</c:if>
															</div>
														</td>
														<td>
															<c:if test="${item.label eq '+'}">
		                                        				입금
		                                        			</c:if>
		                                        			<c:if test="${item.label eq '-'}">
		                                        				출금
		                                        			</c:if>
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
$(function(){
	$.each($(".txtext"), function(index, item){
		let tx = $(item).text();
		if(tx.includes("https://etherscan.io/tx/")){
			tx = tx.split("https://etherscan.io/tx/")[1];
		}else if(tx.includes("https://bithomp.com/explorer/")){
			tx = tx.split("https://bithomp.com/explorer/")[1];
		}
		
		if(tx.startsWith("0x")){
			$(item).text("(ERC-20) "+$(item).text());
		}else if(tx.startsWith("T")){
			$(item).text("(TRC-20) "+$(item).text());
		}
	});
});
function copyboard(tx, coin){
	content = ""
	if(coin == 'BTC')
		content="https://www.blockchain.com/btc/tx/"+tx;
	else if(coin == 'XRP')
		content="https://xrpscan.com/tx/"+tx;
	else if(coin == 'USDT' || coin == 'ETH')
		content="https://etherscan.io/tx/"+tx;
	else if(coin == 'TRX')
		content="https://tronscan.org/#/transaction/"+tx;
	content = content.replace(/ /g,"")
	alert(content);
	window.open(content);
}
function setOrder(val){
	var order = $("#order").val();
	var orderAD = $("#orderAD").val();
	if(order==val){
		if(orderAD=="asc"){
			$("#orderAD").val("desc");
		}
		else{
			$("#orderAD").val("asc");
		}
	}
	else{
		$("#orderAD").val("desc");
	}
	
	$("#order").val(val);
	checkForm();
}

function setTest(val){
	$("#test").val(val);
	checkForm();
}

function depositCancel(idx , midx){
	if(confirm("입금취소하시겠습니까?")){
		$.ajax({
			type :'get',
			url : '/wesell/0nI0lMy6jAzAFRVe0DqLOw/cancelDeposit.do?idx='+idx+'&midx='+midx,
			success:function(data){
				alert(data.msg);
				location.reload();
			}
		})
	}
}

function checkForm(wstat, label){
	$("#fileDown").val(0);
	var sdate = $("#sdate").val();
	var edate = $("#edate").val();
	if((sdate == '' && edate != '') || (sdate != '' && edate == '')){
		alert("조회시작기간과 조회종료기간을 설정해주세요.");
		return;
	}
	if(edate < sdate){
		alert("조회종료기간이 조회시작기간보다 작을 수 없습니다.");
		return;
	}
	if(wstat != null && wstat != ""){
		if(wstat == 4){
			$("#fileDown").val(1);			
		}else{
			if(wstat == 2){
				$("#wstat").val(null);
			}else{
				$("#wstat").val(wstat);
			}
		}
	}
	if(label != null){
		if(label == 0){
			$("#label").val("");
		}else{
			$("#label").val(label);
		}
	}
	
	$("#username").val(null);
	$("#searchIdx").val(null);
	$("#listForm").submit();
}
            
function checkRequest(widx,stat){	      
    jQuery.ajax({                                
        type:"POST", 
        url : "/wesell/trade/withdrawalProcess.do?widx="+widx+"&stat="+stat,
        dataType:"json",
        date:{widx:widx, stat:stat},
        success : function(data) {              	
           if(data.result == "fail")
        	   alert("금액이 부족합니다");
           
           if(data.result == "ok"){
        	   $(".statBtn[widx="+data.widx+"]").hide();
        	   
        	   if(data.stat == 1){
        	   	  $(".statText[widx="+data.widx+"]").html("승인");
        	   }else if(data.stat == 2){
        	   	  $(".statText[widx="+data.widx+"]").html("미승인");
        	   }
           }
        	   
        },
         complete : function(data) { }, 
         error : function(xhr, status , error) {console.log("ajax ERROR!!! : " );}
     });      
}
</script>
</body>
</html>