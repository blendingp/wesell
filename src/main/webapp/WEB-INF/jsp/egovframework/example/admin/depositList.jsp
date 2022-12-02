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
					<h1 class="h3 mb-2 text-gray-800">입금신청 목록</h1>
					<!-- 
						<a href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/realBalance.do?coinname=BTC&type=1">보유코인 많은순 BTC</a>
						<a href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/realBalance.do?coinname=XRP&type=1">XRP</a>
						<a href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/realBalance.do?coinname=TRX&type=1">TRX</a>
						<a href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/realBalance.do?coinname=ETH&type=1">ETH</a> -->
					<div class="card shadow mb-4">
						<div class="card-body">
							<form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/depositList.do"
								name="listForm" id="listForm">
								<input type="hidden" name="pageIndex" value="1" /> <input
									type="hidden" name="username" id="username" value="${username}" />
								<input type="hidden" name="searchIdx" id="searchIdx"
									value="${searchIdx}" /> <input type="hidden" name="order"
									id="order" value="${order}" /> <input type="hidden"
									name="orderAD" id="orderAD" value="${orderAD}" /> <input
									type="hidden" name="test" id="test" value="${test}" />
								<div class="row">
									<div class="col-lg-3">
										<label>기간 검색</label>
										<div class="form-group input-group">
											<div>
												<input type="date" name="sdate" id="sdate" value="${sdate}"
													class="form-control"
													style="width: 45%; display: inline-block;"
													autocomplete="off"> ~ <input type="date"
													name="edate" id="edate" value="${edate}"
													class="form-control"
													style="width: 45%; display: inline-block;"
													autocomplete="off">
											</div>
										</div>
									</div>
	
									<div class="col-lg-1">
										<label>코인</label> <select onchange="checkForm()" id="coin"
											name="coin" class="form-control input-sm"
											style="height: 34px; padding: 2px;">
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
									<div class="col-lg-3">
										<label>검색</label>
										<div class="form-group input-group">
											<select id="searchSelect" name="searchSelect"
												class="form-control input-sm">
												<option value="name"
													<c:if test="${searchSelect eq 'name'}">selected</c:if>>회원명</option>
												<%-- <option value="email"<c:if test="${searchSelect eq 'email'}">selected</c:if>>이메일</option>
												<option value="inviteCode"<c:if test="${searchSelect eq 'inviteCode'}">selected</c:if>>InviteCode</option> --%>
												<option value="idx"
													<c:if test="${searchSelect eq 'idx'}">selected</c:if>>UID</option>
											</select> <input type="text" name="search" class="form-control"
												value="${search}">
											<button class="btn btn-default btn-sm" onclick="checkForm()"
												type="button">
												<i class="fa fa-search"></i>
											</button>
										</div>
									</div>
									<%-- <div class="col-lg-4">
										<label>승인여부</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<input type="hidden"  name="status" id="status" value="${status}"/>
												<button class="btn btn-default btn-sm" style="padding: 6px 7px;" onclick="checkForm(4)" type="button">전체</button>
												<button class="btn btn-success btn-sm" style="padding: 6px 7px;" onclick="checkForm(0)" type="button">입금 대기</button>
												<button class="btn btn-danger btn-sm" style="padding: 6px 7px;" onclick="checkForm(2)" type="button">입금 미승인</button>
											</span>
										</div>
									</div> --%>
									<div class="col-lg-2">
										<label>테스트계정</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-danger btn-sm" onclick="setTest('test')"
													type="button">미포함</button>
												<button class="btn btn-info btn-sm" onclick="setTest('')"
													type="button">포함</button>
											</span>
										</div>
									</div>
									<div class="col-lg-1">
										<label>정렬</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-info btn-sm"
													onclick="setOrder('completionTime')" type="button">시간</button>
												<button class="btn btn-success btn-sm" onclick="setOrder('amount')"
													type="button">수량</button>
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
											<th>시간</th>
											<th>회원명</th>
											<th>소속</th>
											<th>코인명</th>
											<th>수량</th>
											<th>TX</th>
											<th>상태</th>
											<th>액션</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr style="background-color:${item.color}">
												<td><fmt:formatDate value="${item.completionTime}"
														pattern="yyyy-MM-dd HH:mm" /></td>
												<c:if test="${item.fromname ne null }">
													<td
														onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.from}'"
														style="cursor: pointer;">${item.fromname}</td>
												</c:if>
												<c:if test="${item.fromname eq null }">
													<td>확인불가</td>
												</c:if>
												<td><c:if test="${item.parents eq ''}">없음</c:if>${item.parents}</td>
												<td>${item.coin}</td>
												<td><fmt:formatNumber value="${item.amount}"
														pattern="#,###.########" /></td>
												<td>
													<span id="c${item.idx}" class="txtext">${item.tx}</span>
													&nbsp;&nbsp; <c:if test="${item.dtag ne null }">(D Tag:${item.dtag})</c:if>
													<button class="btn btn-success btn-sm" onclick="copyboard(${item.idx}, '${item.coin}')" type="button">트랜잭션조회</button>
												</td>
												<td>
													<div class="statText" widx="${item.widx}">
														<c:if test="${item.status eq '0'}">
		                                            		대기
		                                            	</c:if>
														<c:if test="${item.status eq '2'}">
		                                            		미승인
		                                            	</c:if>
													</div>
												</td>
												<td><c:if test="${item.status eq '0'}">
														<button class="btn btn-primary statBtn ${item.idx}"
															idx="${item.idx}" type="button"
															onclick="checkRequest('${item.idx}','1')">입금 승인</button>
														<button class="btn btn-danger statBtn ${item.idx}"
															idx="${item.idx}" type="button"
															onclick="checkRequest('${item.idx}','2')">입금 미승인</button>
	
														<c:if test="${item.alarm eq '1'}">
															<button class="btn btn-warning statBtn ${item.idx}"
																idx="${item.idx}" type="button"
																onclick="changeAlarm('${item.idx}','0')">알림 끄기</button>
														</c:if>
														<c:if test="${item.alarm eq '0'}">
															<button class="btn btn-success statBtn ${item.idx}"
																idx="${item.idx}" type="button"
																onclick="changeAlarm('${item.idx}','1')">알림 켜기</button>
														</c:if>
													</c:if> <c:if test="${item.status eq '2'}">
														<button class="btn btn-default statBtn ${item.idx}"
															idx="${item.idx}" type="button"
															onclick="checkRequest('${item.idx}','0')">대기</button>
													</c:if></td>
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
function copyboard(idx, coin){
	tx = $("#c"+idx).html();
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
function checkForm(wstat){
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
	if(wstat != null || wstat != ""){
		if(wstat == 4){
			$("#status").val(null);
		}else{
			$("#status").val(wstat);
		}
	}
	$("#username").val(null);
	$("#searchIdx").val(null);
	$("#listForm").submit();
}

var requesting = false;
function checkRequest(widx, stat){
	console.log(requesting);
	
	if(requesting) return;
	requesting = true;
	
	if(widx == null || widx == "") {
		return;	
	}
    jQuery.ajax({                                
        type:"POST", 
        url : "/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/depositProcess.do?widx="+widx+"&stat="+stat,
        dataType:"json",
        date:{widx:widx, stat:stat},
        success : function(data) {              	
           if(data.result == "fail")
        	   alert("요청을 실패했습니다.");
           
           if(data.result == "error")
        	   alert("error : 요청을 실패했습니다.");
           
           if(data.result == "ok"){
        	   location.href ="/depositList.do";
        	   $(".statBtn[widx="+data.widx+"]").hide();
        	   
        	   if(data.stat == 1){
        	   	  $(".statText[widx="+data.widx+"]").html("승인");
        	   }else if(data.stat == 2){
        	   	  $(".statText[widx="+data.widx+"]").html("미승인");
        	   }
           }
           location.reload();
        	   
        },
         complete : function(data) { }, 
         error : function(xhr, status , error) {console.log("ajax ERROR!!! : " );}
     });
    requesting = false;
}

function changeAlarm(idx, alarm){
	$.ajax({
		type :"post",
		dataType : "json" ,
		url : "/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/changeAlarm.do?idx="+idx+"&alarm="+alarm+"&kind=d",
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
</script>
</body>
</html>