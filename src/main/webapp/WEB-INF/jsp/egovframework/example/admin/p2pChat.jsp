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
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
        <div id="content-wrapper">
        	<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">P2P 채팅</h1>
		            <div class="row">
		                <div class="col-lg-12">
		                    <div class="panel panel-default">
								<div class="panel-heading">
									<div class="table-responsive">
		                            	<label>P2P 등록 정보</label>
										<table class="table table-striped table-hover">
											<thead>
												<tr>
													<th>타입</th>
													<th>이름</th>
													<th>주문 수</th>
													<th>가격</th>
													<th>판매 수량</th>
													<th>최소 수량</th>
													<th>최대 수량</th>
													<th>평균 시간(분)</th>
												</tr>
											</thead>
												<c:set var="kind" value="d"/>
												<tbody>
													<td class="infoInput">
														<c:if test="${data.type == 0}"><c:set var="kind" value="d"/> 구매&nbsp;</c:if> 
														<c:if test="${data.type == 1}"><c:set var="kind" value="w"/> 판매&nbsp;</c:if>
													</td>
													<form name="infoForm${data.idx}" id="infoForm${data.idx}" method="post">
														<input type="hidden" name="idx" value="${data.idx}"/>
														<td>${data.name}
															<c:if test="${data.isDelete eq 1}">
																<span style="color:red">(삭제됨)</span>
															</c:if>
														</td>
														<td>${data.orders}</td>
														<td>${data.price}</td>
														<td><fmt:formatNumber value="${data.qty}" pattern="#,###.####"/></td>
														<td>${data.lowLimit}</td>
														<td>${data.maxLimit}</td>
														<td>${data.aveTime}</td>
													</form>
												</tbody>
										</table>
									</div>
									
									<label>상대 정보</label>
									<div class="table-responsive">
		                                <table class="table table-striped table-hover">
		                                    <thead>
		                                        <tr>
		                                            <th>신청시간</th>
		                                            <th>구분</th>
		                                            <th>회원명</th>
		                                            <th>은행</th>
		                                            <th>계좌번호</th>
		                                            <th>금액</th>
		                                            <th>상태</th>
		                                        </tr>
		                                    </thead>
		                                    <tbody>
		                                        <tr style="background-color:${data.color}">
		                                            <td><fmt:formatDate value="${data.mdate}" pattern="yyyy-MM-dd HH:mm"/></td>
		                                            <td>
		                                            	<c:if test="${data.kind eq '+'}">
			                                            		입금
			                                            </c:if>
			                                            <c:if test="${data.kind eq '-'}">
			                                            		출금
			                                            </c:if>
		                                            </td>
		                                            <c:if test="${data.istest eq '1'}">
		                                            	<td onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${data.useridx}'" style="cursor:pointer;">${data.userName} <span style="color:red">(테스트 계정)</span></td>
		                                            </c:if>
		                                            <c:if test="${data.istest ne '1'}">
		                                            	<td onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${data.useridx}'" style="cursor:pointer;">${data.userName}</td>
		                                            </c:if>
		                                            <td>${data.mbank}</td>
		                                            <td>${data.maccount}</td>
		                                            <td><fmt:formatNumber value="${data.money}" pattern="#,###.####"/></td>
		                                            <td>
		                                           		<c:if test="${data.stat eq '-1'}">
		                                            		결제 대기
		                                            		<c:if test="${data.kind eq '-'}">
		                                            			<c:if test="${data.send eq false}">(송금 대기중)</c:if>
		                                            			<c:if test="${data.send eq true}">(송금 완료)</c:if>
		                                            		</c:if>
		                                            		<button class="btn btn-primary btn-xs" widx="${data.idx}" type="button" onclick="payConfirm('${data.idx}')">결제 완료</button>
		                                            	</c:if>
		                                            	<c:if test="${data.stat eq '0'}">
		                                            		결제 완료
		                                            		<c:if test="${data.kind eq '+'}">
			                                            		<button class="btn btn-primary btn-xs statBtn" widx="${data.idx}" type="button" onclick="checkRequest('${data.idx}', '1')">입금 승인</button>
			                                        			<button class="btn btn-danger btn-xs statBtn" widx="${data.idx}" type="button" onclick="checkRequest('${data.idx}', '2')">입금 미승인</button>
		                                            		</c:if>
		                                            		<c:if test="${data.kind eq '-'}">
			                                            		<button class="btn btn-primary btn-xs statBtn" widx="${data.idx}" type="button" onclick="checkRequest('${data.idx}', '1')">출금 승인</button>
		                                       					<button class="btn btn-danger btn-xs statBtn" widx="${data.idx}" type="button" onclick="checkRequest('${data.idx}', '2')">출금 미승인</button>
		                                            		</c:if>
		                                            	</c:if>
		                                            	<c:if test="${data.stat eq '1'}">
		                                            		완료
		                                            		<c:if test="${data.kind eq '+'}">
		                                            			&nbsp;<button class="btn btn-warning btn-xs" type="button" onclick="depositCancel('${data.idx}' , ${data.useridx})">입금취소</button>
		                                            		</c:if>
		                                            	</c:if>
		                                            	<c:if test="${data.stat eq '2'}">
		                                            		미승인
		                                            	</c:if>
		                                            	<c:if test="${data.stat eq '3'}">
		                                            		신청 취소
		                                            	</c:if>
		                                            </td>
		                                        </tr>
		                                    </tbody>
		                                </table>
		                            </div>
		                            <c:set var="uidx" value="${data.useridx}"/>
		                            <c:set var="pidx" value="${data.idx}"/>
		                            <c:set var="userName" value="${data.userName}"/>
		                            <c:set var="tName" value="${data.name}"/>
		                            <div class="chat-panel panel panel-default">
				                        <div class="panel-heading">
				                            <i class="fa fa-comments fa-fw"></i> ${data.userName} &nbsp;
				                            <button class="btn btn-danger btn-xs" type="button" onclick="deleteChat('${data.idx}' , ${data.useridx})">채팅 내역 삭제</button>
				                        </div>
				                        <!-- /.panel-heading -->
				                        <div class="panel-body">
				                            <ul class="chat" id="chatBlock">
				                                <c:forEach var="item" items="${chats}">
				                                	<c:if test="${item.isAdmin eq true}">
				                                		<li class="left clearfix" style="text-align:right;">
						                                    <div class="chat-body clearfix">
						                                        <div class="header">
						                                            <strong class="primary-font">${data.name}</strong>&ensp;
						                                            <small class="pull-right text-muted">${item.time}</small>
						                                        </div>
						                                        <p>${item.text}</p>
						                                    </div>
						                                </li>
				                                	</c:if>
				                                	<c:if test="${item.isAdmin eq false}">
				                                		<li class="right clearfix"  style="text-align:left;">
						                                    <div class="chat-body clearfix">
						                                        <div class="header">
						                                            <strong class="pull-left primary-font">${data.userName}</strong>&ensp;
						                                            <small class="text-muted">${item.time}</small>
						                                        </div>
						                                        <p>${item.text}</p>
						                                    </div>
						                                </li>
				                                	</c:if>
				                                </c:forEach>
				                            </ul>
				                        </div>
				                        <!-- /.panel-body -->
				                        <div class="panel-footer">
				                            <div class="input-group">
				                                <input type="text" id="inputTxt" class="form-control input-sm" onkeyup="enter(${pidx},${uidx})">
				                                <span class="input-group-btn">
				                                    <button class="btn btn-warning btn-sm" id="btn-chat" onclick="send(${data.idx},${uidx})">전송</button>
				                                </span>
				                            </div>
				                        </div>
				                        <!-- /.panel-footer -->
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
const chatPage = true;
const useridx = Number("${uidx}");
const pidx = Number("${pidx}");
const userName = "${userName}";
const tName = "${tName}";
$("#chatBlock").parent().scrollTop($("#chatBlock")[0].scrollHeight);
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

var sending = false;
function send(pidx,midx){
	if(sending) return;
	var text = $("#inputTxt").val();
	if(text == null || text.length == 0) return;
	
	sending = true;
	
	jQuery.ajax({                                
        type:"POST", 
        url : "/global/0nI0lMy6jAzAFRVe0DqLOw/p2p/chatSend.do",
        dataType:"json",
        data:{"midx":midx,"pidx":pidx,"text":text},
        success : function(data) {              	
           if(data.result != "success")
	       	   alert("요청을 실패했습니다.");
           else
        	   $("#inputTxt").val("");
           sending = false;
        },
         complete : function(data) { }, 
         error : function(xhr, status , error) {console.log("ajax ERROR!!! : " );}
     });
}

function deleteChat(pidx,midx){
	if(!confirm("삭제하시겠습니까? 되돌릴 수 없습니다.")) return;
	
	console.log("삭제");
	jQuery.ajax({                                
        type:"POST", 
        url : "/global/0nI0lMy6jAzAFRVe0DqLOw/p2p/deleteChat.do",
        dataType:"json",
        data:{"midx":midx,"pidx":pidx},
        success : function(data) {              	
           if(data.result != "success")
	       	  location.reload();
        },
         complete : function(data) { }, 
         error : function(xhr, status , error) {console.log("ajax ERROR!!! : " );}
     });
}

function msgAppend(obj){
	if(obj.pidx == pidx && obj.userIdx == useridx){
		let chatBlock = $("#chatBlock");
		let text = "";
		if(obj.isAdmin){
			text = "<li class='left clearfix' style='text-align:right;'> <div class='chat-body clearfix'> <div class='header'> <strong class='primary-font'>"
				+tName +"</strong>&ensp; <small class='pull-right text-muted'><i class='fa fa-clock-o fa-fw'></i>"
				+obj.time+"</small> </div> <p>"
				+obj.text+"</p> </div> </li>";
		}else{
			text = "<li class='right clearfix' style='text-align:left;'> <div class='chat-body clearfix'> <div class='header'> <strong class='pull-left primary-font'>"
				+tName +"</strong>&ensp; <small class='text-muted'><i class='fa fa-clock-o fa-fw'></i>"
				+obj.time+"</small> </div> <p>"
				+obj.text+"</p> </div> </li>";
		}
		chatBlock.append(text);
		chatBlock.parent().scrollTop(chatBlock[0].scrollHeight);
	}
}

function enter(pidx,midx){
	if (window.event.keyCode == 13) {
         send(pidx,midx)
    }
}
</script>
</body>
</html>