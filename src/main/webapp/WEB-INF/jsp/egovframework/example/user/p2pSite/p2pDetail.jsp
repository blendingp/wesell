<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html data-wf-page="618388aa32debe327ad0f06c"
	data-wf-site="6180a71858466749aa0b95bc">
<head>
<meta charset="utf-8">
<jsp:include page="../../p2pSiteFrame/header.jsp"></jsp:include>
</head>
<body class="body">
	<div class="frame">
		<jsp:include page="../../p2pSiteFrame/top.jsp"></jsp:include>
		<div class="general_section wf-section" style="background-image:url('/global/webflow/p2pImages/backbox00.png')">
			<div class="banner" style="background-image:url('/global/webflow/p2pImages/header_bg.png')">
				<div class="banner_warp">
					<div class="m_head_box">
						<h1 class="m_head">
							<c:if test="${detail.kind eq '+'}">테더 USDT 구매</c:if>
							<c:if test="${detail.kind eq '-'}">테더 USDT 판매</c:if>
						</h1>
						<h2 class="m_head _3"> 글로벌 거래소 비트오션 공식 파트인<br> </h2>
						<h4 class="m_head _2">
							<c:if test="${detail.kind eq '+'}">
								Easy Exchange에서 별도의 회원가입 없이 바로 거래가가능합니다.<br>거래 시 비트오션의 UID,
								전화번호, 성함을 입력하시면 구매 즉시 비트오션 계좌로 <br>테더가 입금됩니다.
							</c:if>
							<c:if test="${detail.kind eq '-'}">
								Easy Exchange에서 별도의 회원가입 없이 바로 거래가가능합니다.<br>거래 시 비트오션의 UID,
								전화번호, 성함을 입력하시면 판매 즉시 비트오션 계좌에서 <br>테더가 출금됩니다.
							</c:if>
							
						</h4>
						<input type="hidden" id="midx" value="${detail.idx}">
						<c:set var="uidx" value="${detail.useridx}"/>
		                <c:set var="pidx" value="${detail.idx}"/>
		                <c:set var="userName" value="${detail.userName}"/>
		                <c:set var="tName" value="${detail.name}"/>
					</div>
					<img src="/global/webflow/p2pImages/header_art2.png" loading="lazy" srcset="/global/webflow/p2pImages/header_art2-p-500.png 500w, /global/webflow/p2pImages/header_art2.png 616w" sizes="(max-width: 479px) 100vw, 300px" alt="" class="banner_img">
				</div>
			</div>
			<div class="general_block">
				<div class="deco"></div>
				<h1 class="general_title">주문 상세 정보</h1>
				<div class="purchase_warp">
					<div class="resultarea">
						<div class="result_titletxt">
							<c:if test="${detail.kind eq '+'}">
								<c:if test="${detail.stat eq -1}">주문 완료</c:if>
								<c:if test="${detail.stat eq 0}">결제 완료</c:if>
								<c:if test="${detail.stat eq 1}">거래 완료</c:if>
								<c:if test="${detail.stat eq 2}">거절됨</c:if>
								<c:if test="${detail.stat eq 3}">취소된 주문</c:if>
							</c:if>
							<c:if test="${detail.kind eq '-'}">
								<c:if test="${detail.stat eq -1}">결제 대기</c:if>
								<c:if test="${detail.stat eq 0}">결제 완료</c:if>
								<c:if test="${detail.stat eq 1}">거래 완료</c:if>
								<c:if test="${detail.stat eq 2}">거절됨</c:if>
								<c:if test="${detail.stat eq 3}">취소된 주문</c:if>
							</c:if>
						</div>
						<div class="wallet_adrs_block">
							<div class="wallet_adrs">
								입금자 계좌 (입금자 명):
								<span class="wallet">
									<c:if test="${detail.kind eq '+'}"><span id="copyAccount">${detail.banknum}</span> ${detail.bank}(${detail.bankname})</c:if>
									<c:if test="${detail.kind eq '-'}"><span id="copyAccount">${accountInto.account}</span> ${accountInto.bank}(${accountInto.name})</c:if>
								</span>
							</div>
							<img src="/global/webflow/p2pImages/content_copy_black_24dp_1content_copy_black_24dp.png" loading="lazy" style="cursor:pointer;" class="copy_img">
						</div>
						<c:if test="${detail.stat eq -1}">
							<div class="result_price_block">
								<div class="result_price"><fmt:formatNumber value="${detail.money}" pattern="#,###"/> KRW</div>
							</div>
						</c:if>
						<div class="result_txtbox">
							주문 상태:
							<c:if test="${detail.stat eq -1}">
								<span class="result_detail">대기중</span>
							</c:if>
							<c:if test="${detail.stat eq 0}">
								<span class="result_detail ok">결재완료</span>
							</c:if>
							<c:if test="${detail.stat eq 1}">
								<span class="result_detail ok">거래완료</span>
							</c:if>
							<c:if test="${detail.stat eq 2}">
								<span class="result_detail cancle">취소(거절됨)</span>
							</c:if>
							<c:if test="${detail.stat eq 3}">
								<span class="result_detail cancle">취소</span>
							</c:if>
						</div>
						<div>
<!-- 							판매자에게 <span class="result_time end">14:15 </span>분 이내에 결제하고 '결제 완료'로 표시하세요 -->
							<c:if test="${detail.stat eq -1}">
								<c:if test="${detail.kind eq '+'}">
									판매자에게 결제하고 '결제 완료'로 표시하세요
								</c:if>
								<c:if test="${detail.kind eq '-'}">
									구매자 결제 대기중입니다.
								</c:if>
							</c:if>
							<c:if test="${detail.kind eq '-' and detail.stat eq 0}">
								입금이 확인된 뒤에 '거래 완료'로 표시하세요
							</c:if>
						</div>
						<div class="p2p_warn">본인 명의의 계좌로만 판매가 가능 합니다. 본인 명의가 아닐시 판매자가 환불을 요청하거나 주문을 취소 할 수 있습니다.</div>
						
						<c:if test="${detail.kind eq '-' and (detail.stat eq 1 or detail.stat eq -1)}">
							<div class="wallet_adrs_block">
			                  <div class="wallet_adrs"><spring:message code="wallet.p2p.depositcheck"/></div>
			                  <%-- <div class="wallet_adrs"><spring:message code="wallet.p2p.address"/> : <span class="wallet">0xF0012A8B115C49173F26fCE7EF${info.idx }880dd3eB8</span></div>
			                   --%>
			                   <c:if test="${detail.send eq false}">
				                  <a href="javascript:moneySend()" class="button-61 w-button"><spring:message code="wallet.p2p.send3"/></a>
			                  </c:if>
			                  <c:if test="${detail.send eq true}">
				                  <a href="#" class="button-61 w-button"><spring:message code="wallet.p2p.sendComplete"/></a>
			                  </c:if>
			                </div>
		                </c:if>
						
						<div class="result_titletxt">주문 세부 정보</div>
						
						<div class="result_box">
							<c:if test="${detail.kind eq '+'}">
								<div class="result_txtbox">
									판매자 이름:<span class="result_detail">${detail.name}</span>
								</div>
								<div class="result_txtbox">
									단일 가격:<span class="result_detail"><fmt:formatNumber value="${detail.price}" pattern="#,###"/> KRW</span>
								</div>
								<div class="result_txtbox">
									수량:<span class="result_detail"><fmt:formatNumber value="${detail.exchangeValue}" pattern="#,###.####"/> USDT</span>
								</div>
								<div class="result_txtbox">
									구매:<span class="result_detail"><fmt:formatNumber value="${detail.money}" pattern="#,###"/> KRW</span>
								</div>
								<div class="result_txtbox">
									주문 시간:<span class="result_detail"><fmt:formatDate value="${detail.mdate}" pattern="yyyy-MM-dd HH:mm"/></span>
								</div>
								<div class="result_txtbox">                      
									예금주:<span class="result_detail">${detail.bankname}</span>
								</div> 
								<div class="result_txtbox">
									은행:<span class="result_detail">${detail.bank}</span>
								</div>                                           
								<div class="result_txtbox">                      
									계좌번호:<span class="result_detail">${detail.banknum}</span>
								</div> 
							</c:if>
							<c:if test="${detail.kind eq '-'}">
								<div class="result_txtbox">
									구매자 이름:<span class="result_detail">${detail.name}</span>
								</div>
								<div class="result_txtbox">
									단일 가격:<span class="result_detail"><fmt:formatNumber value="${detail.price}" pattern="#,###"/> KRW</span>
								</div>
								<div class="result_txtbox">
									수량:<span class="result_detail"><fmt:formatNumber value="${detail.exchangeValue}" pattern="#,###.####"/> USDT</span>
								</div>
								<div class="result_txtbox">
									판메:<span class="result_detail"><fmt:formatNumber value="${detail.money}" pattern="#,###"/> KRW</span>
								</div>
								<div class="result_txtbox">
									주문 시간:<span class="result_detail"><fmt:formatDate value="${detail.mdate}" pattern="yyyy-MM-dd HH:mm"/></span>
								</div>
								<div class="result_txtbox">                      
									예금주:<span class="result_detail">${accountInto.name}</span>
								</div> 
								<div class="result_txtbox">
									은행:<span class="result_detail">${accountInto.bank}</span>
								</div>                                           
								<div class="result_txtbox">                      
									계좌번호:<span class="result_detail">${accountInto.account}</span>
								</div>                                            
							</c:if>
							<div class="result_txtbox" style="word-break:break-all;">                      
								<spring:message code="menu.message"/>:<span class="result_detail">${detail.msg}</span>
							</div>
						</div>
						<c:if test="${detail.kind eq '+'}">
							<c:if test="${detail.stat eq -1}">
								<a href="javascript:payComplete()" class="purchase_btn w-button">결제 완료</a>
								<a href="javascript:cancel()" class="purchase_btn _2 w-button">취소</a>
							</c:if>
							<c:if test="${detail.stat eq 0}">
								<div class="purchase_btn w-button" style="cursor: default;">결제 확인 중</div>
								<a href="javascript:cancel()" class="purchase_btn _2 w-button">취소</a>
							</c:if>
						</c:if>
						<c:if test="${detail.kind eq '-'}">
							<c:if test="${detail.stat eq -1}">
								<a href="javascript:cancel()" class="purchase_btn _2 w-button">취소</a>
							</c:if>
							<c:if test="${detail.stat eq 0}">
								<a href="javascript:tradeComplete()" class="purchase_btn w-button">거래 완료</a>
							</c:if>
						</c:if>
						<c:if test="${detail.stat eq 1 and detail.kind eq '+'}">
							<div class="result_complete_txtbox">
								<div class="compleete_txt">주문이 완료되었습니다.</div>
							</div>
						</c:if>
						<c:if test="${detail.stat eq 2}">
							<div class="result_complete_txtbox">
								<div class="compleete_txt">주문이 거절되었습니다. 관리자에게 문의해 주세요.</div>
							</div>
						</c:if>
						<c:if test="${detail.stat eq 1 or detail.stat eq 2 or detail.stat eq 3}">
							<a href="/global/easy/p2pOrders.do" class="purchase_btn _2 w-button">다른 주문</a>
						</c:if>
					</div>
					<div class="chatting">
						<div class="chat_profile">
							<div class="user_icon">
								<div>T</div>
							</div>
							<div class="list_profilewarp">
								<div class="list_profile_name">${detail.name}</div>
								<div>${detail.orders}회 주문 | 평균 시간 ${detail.aveTime}분</div>
							</div>
						</div>
						<div class="chattbox">
							<div class="chat_scroll" id="chatBlock">
								<c:forEach var="item" items="${chats}">
									<div>
										<c:if test="${item.isAdmin eq true}">
											<div class="chattong_area _1">
												<div class="chatting_block">
													<div class="list_profile_name">${tName}</div>
													<div class="chattingbox _2">${item.text}</div>
													<div class="chatting_time">${item.time}</div>
												</div>
											</div>
										</c:if>
										<c:if test="${item.isAdmin eq false}">
											<div class="chattong_area _2">
												<div class="chatting_block">
													<div class="list_profile_name _2">${userName}</div>
													<div class="chattingbox">${item.text}</div>
													<div class="chatting_time _2">${item.time}</div>
												</div>
											</div>
										</c:if>
									</div>
								</c:forEach>
							</div>
						</div>
						<div class="w-form">
							<div class="chatting_inpublock">
								<input type="text" class="text-field-28 w-input" maxlength="100" id="inputTxt" onkeyup="enter(${pidx})">
								<a href="javascript:send(${detail.idx})" class="chat_inputbtn w-button">전송</a>
								
							</div>
						</div>
					</div>
				</div>
				<div class="bottom_btn _2">
					<a href="/global/easy/p2pOrders.do" class="btn w-button">뒤로가기</a>
				</div>
			</div>
		</div>
		<jsp:include page="../../p2pSiteFrame/footer.jsp"></jsp:include>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6180a71858466749aa0b95bc" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="../js/webflow.js" type="text/javascript"></script>
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		const chatPage = true;
		const useridx = Number("${uidx}");
		const pidx = Number("${pidx}");
		const userName = "${userName}";
		const tName = "${tName}";
		function regist(){
			alert("관리자에게 문의해 주세요.");
			location.href="/global/easy/helpCenter.do";
		}
		function setNum(obj){
			val=obj.value;
		    re=/[^0-9]/gi;
		    obj.value=val.replace(re,"");
		    $(obj).trigger("input");
		}
		$(function() {
			$("#chatBlock").scrollTop($("#chatBlock")[0].scrollHeight);
			initToWeb();
		});
		
		function moneySend(){
			var midx = $("#midx").val();
			jQuery.ajax({
				type : "POST",
				data : {"midx" : midx},
				url : "/global/easy/moneySend.do",
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
		function payComplete(){
			var midx = $("#midx").val();
			jQuery.ajax({
				type : "POST",
				data : {"midx" : midx},
				url : "/global/easy/payComplete.do",
				dataType : "json",
				success : function(data) {
					if (data.result == "suc") {
						location.reload();
					}
					else{
						alert(data.msg);
						location.reload();
					}
				},
				complete : function(data) { },
				error : function(xhr, status, error) { console.log("ajax ERROR!!! : "); }
			});
		}
		function cancel(){
			var midx = $("#midx").val();
			jQuery.ajax({
				type : "POST",
				data : {"midx" : midx},
				url : "/global/easy/p2pCancel.do",
				dataType : "json",
				success : function(data) {
					if (data.result == "suc") {
						location.reload();
					}
					else{
						alert(data.msg);
						location.reload();
					}
				},
				complete : function(data) { },
				error : function(xhr, status, error) { console.log("ajax ERROR!!! : "); }
			});
		}
		
		function tradeComplete(){
			var midx = $("#midx").val();
			jQuery.ajax({
				type : "POST",
				data : {"midx" : midx},
				url : "/global/easy/tradeComplete.do",
				dataType : "json",
				success : function(data) {
					if (data.result == "suc") {
						location.reload();
					}
					else{
						alert(data.msg);
						location.reload();
					}
				},
				complete : function(data) { },
				error : function(xhr, status, error) { console.log("ajax ERROR!!! : "); }
			});
		}
		
		var sending = false;
		function send(pidx){
			if(sending) return;
			var text = $("#inputTxt").val();
			if(text == null || text.length == 0) return;
			
			sending = true;
			
			jQuery.ajax({                                
		        type:"POST", 
		        url : "/global/easy/chatSend.do",
		        dataType:"json",
		        data:{"userIdx":useridx,"pidx":pidx,"text":text},
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
		
		function msgAppend(obj){
			if(obj.pidx == pidx && obj.userIdx == useridx){
				let chatBlock = $("#chatBlock");
				let text = "";
				if(obj.isAdmin){
					text = "<div class='chattong_area _1'> <div class='chatting_block'> <div class='list_profile_name'>"
						+tName+"</div> <div class='chattingbox _2'>"
						+obj.text+"</div> <div class='chatting_time _1'>"
						+obj.time+"</div> </div> </div>";
				}else{
					text = "<div class='chattong_area _2'> <div class='chatting_block'> <div class='list_profile_name _2'>"
						+userName+"</div> <div class='chattingbox'>"
						+obj.text+"</div> <div class='chatting_time _2'>"
						+obj.time+"</div> </div> </div>";
				}
				chatBlock.append(text);
				chatBlock.scrollTop(chatBlock[0].scrollHeight);
			}
		}
		
		function enter(pidx){
			if (window.event.keyCode == 13) {
	             send(pidx)
	        }
		}
		
		////////////////////socket
		const serverport = '<%=request.getServerPort()%>';
		let servername = '<%=request.getServerName()%>';
		let wsUriToWeb = "wss://"+servername+":"+serverport+"/global/websocket/echo.do"; //주소 확인!!
		if(servername == "localhost")
			wsUriToWeb = "ws://"+servername+":"+serverport+"/global/websocket/echo.do";
		let websocketToWeb = null;
		function initToWeb() {
			websocketToWeb = new WebSocket(wsUriToWeb);
			websocketToWeb.onopen = function(evt) {
				onOpenToWeb(evt);
			};

			websocketToWeb.onmessage = function(evt) {
				onMessageToWeb(evt);
			};

			websocketToWeb.onerror = function(evt) {
				onErrorToWeb(evt);
			};

			websocketToWeb.onclose = function(evt) {
				console.log("재접속");
				initToWeb();
			};
		}
		function onOpenToWeb(evt) {
			console.log("webserver open :" + useridx);
		}
		function onErrorToWeb(evt) {
			console.log("onErrorToWEb");
		}
		function onMessageToWeb(evt) { // 받은 메세지를 보여준다
			let wpro = "none";
			try {
				let obj = JSON.parse(evt.data);
				wpro = obj.protocol;
				if (obj.protocol == "doLogin") {
					if (useridx != null && useridx != 'null' && useridx != '') {
						let obj = new Object;
						obj.protocol = "login";
						obj.userIdx = useridx;
						doSendToWeb(JSON.stringify(obj));
					}
				}
				else if(obj.protocol == 'chatMsg'){
					if(typeof msgAppend == 'function'){
						msgAppend(obj);
					}
				}
				else if(obj.protocol == 'p2pReload'){
					if(typeof chatPage != 'undefined'){
						location.reload();
					}
				}
			} catch (err) {
				console.log("[protocol]" + wpro + " " + err.message);
			}
		}
		function doSendToWeb(message) {
			websocketToWeb.send(message);
		}
	</script>
</body>
</html>