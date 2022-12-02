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
<jsp:include page="../../userFrame/header.jsp"></jsp:include>
</head>
<body class="body2">
	<div class="frame">
		<jsp:include page="../../userFrame/top.jsp"></jsp:include>
		<div class="frame2">
			<jsp:include page="p2pLeft.jsp"/>
			<div class="asset_block">
				<div class="assetbox">
					<jsp:include page="p2pInfo.jsp"/>
					<input type="hidden" id="midx" value="${detail.idx}">
					<c:if test="${detail.kind eq '+'}">
						<div class="assettitle">
							<c:if test="${detail.stat eq -1}"><spring:message code="wallet.p2p.orderComplete"/></c:if>
							<c:if test="${detail.stat eq 0}"><spring:message code="wallet.p2p.payComplete"/></c:if>
							<c:if test="${detail.stat eq 1}"><spring:message code="wallet.p2p.tradeComplete"/></c:if>
							<c:if test="${detail.stat eq 2}"><spring:message code="wallet.p2p.deny"/></c:if>
							<c:if test="${detail.stat eq 3}"><spring:message code="wallet.p2p.cancelOrder"/></c:if>
						</div>
					</c:if>
					<c:if test="${detail.kind eq '-'}">
						<div class="assettitle">
							<c:if test="${detail.stat eq -1}"><spring:message code="wallet.p2p.payPending"/></c:if>
							<c:if test="${detail.stat eq 0}"><spring:message code="wallet.p2p.payComplete"/></c:if>
							<c:if test="${detail.stat eq 1}"><spring:message code="wallet.p2p.tradeComplete"/></c:if>
							<c:if test="${detail.stat eq 2}"><spring:message code="wallet.p2p.deny"/></c:if>
							<c:if test="${detail.stat eq 3}"><spring:message code="wallet.p2p.cancelOrder"/></c:if>
						</div>
					</c:if>
					<c:set var="uidx" value="${detail.useridx}"/>
                    <c:set var="pidx" value="${detail.idx}"/>
                    <c:set var="userName" value="${detail.userName}"/>
                    <c:set var="tName" value="${detail.name}"/>
					<div class="deposit_warp4">
						<div class="resultpage_warp">
							<div class="resultarea">
								<c:if test="${detail.stat eq -1}">
									<div class="result_price_block">
										<div class="result_price"><fmt:formatNumber value="${detail.money}" pattern="#,###"/> KRW</div>
									</div>
									<div>
										<c:if test="${detail.kind eq '+'}">
											<spring:message code="wallet.p2p.orderTxt_0"/>
										</c:if>
										<c:if test="${detail.kind eq '-'}">
											<spring:message code="wallet.p2p.orderTxt_sell"/>
										</c:if>
									</div>
									<div class="pop_warn">
										<spring:message code="wallet.p2p.orderTxt_5"/>
									</div>
								</c:if>
								<c:if test="${detail.kind eq '-' and detail.stat eq 0}">
									<spring:message code="wallet.p2p.orderTxt_4"/>
								</c:if>
								<div class="result_titletxt"><spring:message code="wallet.p2p.orderInfo"/></div>
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
								<div class="result_box">
									<c:if test="${detail.kind eq '+'}">
										<div class="result_txtbox">
											<spring:message code="wallet.p2p.sellerName"/>:<span class="result_detail">${detail.name}</span>
										</div>
										<div class="result_txtbox">
											<spring:message code="wallet.p2p.price"/>:<span class="result_detail"><fmt:formatNumber value="${detail.price}" pattern="#,###"/> KRW</span>
										</div>
										<div class="result_txtbox">
											<spring:message code="wallet.p2p.qty"/>:<span class="result_detail"><fmt:formatNumber value="${detail.exchangeValue}" pattern="#,###.####"/> USDT</span>
										</div>
										<div class="result_txtbox">
											<spring:message code="wallet.p2p.buy"/>:<span class="result_detail"><fmt:formatNumber value="${detail.money}" pattern="#,###"/> KRW</span>
										</div>
										<div class="result_txtbox">
											<spring:message code="wallet.p2p.orderTime"/>:<span class="result_detail"><fmt:formatDate value="${detail.mdate}" pattern="yyyy-MM-dd HH:mm"/></span>
										</div>
										<div class="result_txtbox">                      
											<spring:message code="join.mname"/>:<span class="result_detail">${detail.bankname}</span>
										</div> 
										<div class="result_txtbox">
											<spring:message code="join.mbank"/>:<span class="result_detail">${detail.bank}</span>
										</div>                                           
										<div class="result_txtbox">                      
											<spring:message code="join.maccount"/>:<span class="result_detail">${detail.banknum}</span>
										</div> 
									</c:if>
									<c:if test="${detail.kind eq '-'}">
										<div class="result_txtbox">
											<spring:message code="wallet.p2p.buyerName"/>:<span class="result_detail">${detail.name}</span>
										</div>
										<div class="result_txtbox">
											<spring:message code="wallet.p2p.price"/>:<span class="result_detail"><fmt:formatNumber value="${detail.price}" pattern="#,###"/> KRW</span>
										</div>
										<div class="result_txtbox">
											<spring:message code="wallet.p2p.qty"/>:<span class="result_detail"><fmt:formatNumber value="${detail.exchangeValue}" pattern="#,###.####"/> USDT</span>
										</div>
										<div class="result_txtbox">
											<spring:message code="wallet.p2p.sell"/>:<span class="result_detail"><fmt:formatNumber value="${detail.money}" pattern="#,###"/> KRW</span>
										</div>
										<div class="result_txtbox">
											<spring:message code="wallet.p2p.orderTime"/>:<span class="result_detail"><fmt:formatDate value="${detail.mdate}" pattern="yyyy-MM-dd HH:mm"/></span>
										</div>
										<div class="result_txtbox">                      
											<spring:message code="join.mname"/>:<span class="result_detail">${accountInto.name}</span>
										</div> 
										<div class="result_txtbox">
											<spring:message code="join.mbank"/>:<span class="result_detail">${accountInto.bank}</span>
										</div>                                           
										<div class="result_txtbox">                      
											<spring:message code="join.maccount"/>:<span class="result_detail">${accountInto.account}</span>
										</div>                                            
									</c:if>
									<div class="result_txtbox" style="word-break:break-all;">                      
										<spring:message code="menu.message"/>:<span class="result_detail">${detail.msg}</span>
									</div>
								</div>
								
								<c:if test="${detail.kind eq '+'}">
									<c:if test="${detail.stat eq -1}">
										<a href="javascript:payComplete()" class="button-57 w-button"><spring:message code="wallet.p2p.payComplete"/></a>
										<a href="javascript:cancel()" class="tpsl_cancle w-button"><spring:message code="wallet.p2p.cancel"/></a>
									</c:if>
									<c:if test="${detail.stat eq 0}">
										<div class="button-57 w-button" style="cursor: default;"><spring:message code="wallet.p2p.sellerCheck"/></div>
										<a href="javascript:cancel()" class="tpsl_cancle w-button"><spring:message code="wallet.p2p.cancel"/></a>
									</c:if>
								</c:if>
								<c:if test="${detail.kind eq '-'}">
									<c:if test="${detail.stat eq -1}">
										<a href="javascript:cancel()" class="button-57 w-button"><spring:message code="wallet.p2p.cancel"/></a>
									</c:if>
									<c:if test="${detail.stat eq 0}">
										<a href="javascript:tradeComplete()" class="button-57 w-button"><spring:message code="wallet.p2p.tradeComplete"/></a>
									</c:if>
								</c:if>
								<c:if test="${detail.stat eq 1 and detail.kind eq '+'}">
									<div class="result_complete_txtbox">
										<img src="/global/webflow/images/check_bitmarket.svg" loading="lazy" alt="" class="image-70">
										<div class="compleete_txt"><spring:message code="wallet.p2p.payTxt"/></div>
									</div>
								</c:if>
								<c:if test="${detail.stat eq 2}">
									<div class="result_complete_txtbox">
										<div class="compleete_txt"><spring:message code="wallet.p2p.denyText"/></div>
									</div>
								</c:if>
								<c:if test="${detail.stat eq 1 or detail.stat eq 2 or detail.stat eq 3}">
									<a href="/global/user/p2pOrders.do" class="button-57 w-button"><spring:message code="wallet.p2p.otherOrder"/></a>
								</c:if>
							</div>
						</div>
					</div>
					<div class="chatting">
						<div class="chat_profile">
							<div class="list_profilecircle">
								<div>T</div>
							</div>
							<div class="list_profilewarp">
								<div class="list_profile_name">${detail.name}</div>
								<div>${detail.orders}<spring:message code="wallet.p2p.orders"/> | <spring:message code="wallet.p2p.averTime"/> ${detail.aveTime}<spring:message code="wallet.p2p.min"/></div>
							</div>
						</div>
						<div class="chattbox">
							<div class="chat_scroll" id="chatBlock">
								<c:forEach var="item" items="${chats}">
                                	<c:if test="${item.isAdmin eq true}">
										<div class="chattong_area _1">
											<div class="list_profilecircle">
												<div>T</div>
											</div>
											<div class="chatting_block">
												<div class="list_profile_name">${tName}</div>
												<div class="chattingbox _2">${item.text}</div>
												<div class="chatting_time _1">${item.time}</div>
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
											<div class="list_profilecircle">
												<div>T</div>
											</div>
										</div>
                                	</c:if>
                               	</c:forEach>
							</div>
						</div>
						<div class="w-form">
							<div class="chatting_inpublock">
								<input type="text" class="text-field-28 w-input" maxlength="100" id="inputTxt" onkeyup="enter(${pidx})">
								<a href="javascript:send(${detail.idx})" class="button-60 w-button"><spring:message code="wallet.p2p.send"/></a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../../userFrame/footer.jsp"></jsp:include>
		<div class="popup" id="popup" style="display: none;">
			<div class="buylist_pop">
				<div class="buylist_popbox">
					<div class="buylist_popsection1">
						<div class="buylistpop_profile">
							<div class="list_profilecircle">
								<div>T</div>
							</div>
							<div class="list_profilewarp">
								<div class="list_profile_name"><span id="popName"></span></div>
								<div><span id="popOrders"></span><spring:message code="wallet.p2p.orders"/> | <spring:message code="wallet.p2p.averTime"/> <span id="popAveTime">0</span><spring:message code="wallet.p2p.min"/></div>
							</div>
						</div>
						<div class="buylist_popwarp">
							<div class="buylist_poptitle"><spring:message code="wallet.p2p.price"/></div>
							<div><span id="popPrice">0</span> KRW</div>
						</div>
						<div class="buylist_popwarp">
							<div class="buylist_poptitle"><spring:message code="wallet.p2p.limit"/></div>
							<div><span id="popLimit"></span> KRW</div>
						</div>
						<div class="buylist_popwarp">
							<div class="buylist_poptitle"><spring:message code="wallet.p2p.qty"/></div>
							<div><span id="popQty"></span> USDT</div>
						</div>
						<div class="pop_warn"><spring:message code="wallet.p2p.buyPop_1"/></div>
					</div>
					<a href="javascript:popClose()" class="pop_exist w-inline-block"></a>
					<div class="pop_exist" style="cursor: pointer;" onclick="popClose()">
						<img src="/global/webflow/images/wx.png" loading="lazy" sizes="100vw" srcset="/global/webflow/images/wx-p-800.png 800w, /global/webflow/images/wx-p-1080.png 1080w, /global/webflow/images/wx.png 1600w" class="image-38">
					</div>
					<div class="buylist_popsection2">
						<div class="form-block-19 w-form">
							<div><spring:message code="wallet.p2p.buyPop_2"/></div>
							<div class="buylist_popinput">
								<input type="text" class="text-field-27 w-input" maxlength="11" id="popInput" onkeyup="setNum(this)"> 
								<a href="javascript:allInput()" class="button-55 w-button"><spring:message code="wallet.p2p.buyAll"/></a>
								<div class="text-block-43">KRW</div>
							</div>
							<div><spring:message code="wallet.p2p.buyPop_3"/></div>
							<div class="buylist_popinput">
								<input type="text" class="text-field-26 w-input" maxlength="256" id="popGet" style="background-color:transparent;" readonly>
								<div class="text-block-43-copy">USDT</div>
							</div>
						</div>
						<a href="javascript:submit()" class="button-56 w-button"><spring:message code="wallet.p2p.buy"/></a>
					</div>
				</div>
			</div>
		</div>
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
		var selectPrice=0;
		var selectLLimit=0;
		var selectMLimit=0;
		var selectTrader=-1;
		function regist(){
			alert("<spring:message code='wallet.p2p.inquiry'/>");
			location.href="/global/user/helpCenter.do";
		}
		function p2pPop(pidx){
			selectTrader = pidx;
			selectPrice=$("#price"+pidx).val();
			selectLLimit = $("#lowLimit"+pidx).val();
			selectMLimit = $("#maxLimit"+pidx).val();

			$("#popName").text($("#name"+pidx).val());
			$("#popOrders").text($("#orders"+pidx).val());
			$("#popAveTime").text($("#aveTime"+pidx).val());
			$("#popPrice").text(selectPrice);
			$("#popLimit").text(selectLLimit+" ~ "+selectMLimit);
			$("#popQty").text($("#qty"+pidx).val());
			$("#popup").css("display","flex");
		}
		function popClose(){
			selectTrader = -1;
			$("#popName").text("");
			$("#popOrders").text("");
			$("#popAveTime").text("");
			selectPrice=0;
			selectLLimit=0;
			selectMLimit=0;
			$("#popPrice").text("");
			$("#popLimit").text("");
			$("#popQty").text("");
			$("#popup").css("display","none");
		}
		function allInput(){
			var tmpMaxPrice = Number($("#popPrice").text()) * Number($("#popQty").text());
			var tmpInput = selectMLimit;
			if(tmpMaxPrice < selectMLimit)
				tmpInput = tmpMaxPrice;
			$("#popInput").val(toFixedDown(tmpInput,0));
			$("#popInput").trigger("input");
		}
		function setNum(obj){
			val=obj.value;
		    re=/[^0-9]/gi;
		    obj.value=val.replace(re,"");
		    $(obj).trigger("input");
		}
		function buyCheck(){
			if(selectTrader == -1){
				alert("페이지 오류. 다시 설정해 주세요.");
				location.reload();
			}
			var inputVal = $("#popInput").val();
			var getUSDT = $("#popGet").val();
			if(isNaN(inputVal)) return false;
			else if(isNaN(getUSDT)) return false;
			else if(inputVal < selectLLimit){
				alert("<spring:message code='wallet.p2p.lLimitErr'/>");
				return false;
			}else if(inputVal > selectMLimit){
				alert("<spring:message code='wallet.p2p.mLimitErr'/>");
				return false;
			}else if(getUSDT > Number($("#popQty").text())){
				alert("<spring:message code='wallet.p2p.overQty'/>");
				return false;
			}
			return true;
		}
		$(function() {
			$("#popInput").on("input", function() { // 주문 수량 입력 체크
				var input = $(this).val();
				$("#popGet").val(fmtNum(toFixedDown(input / selectPrice,4)));
			});
			$("#chatBlock").scrollTop($("#chatBlock")[0].scrollHeight);
			initToWeb();
		});
		
		
		function submit(){
			if(!buyCheck()) return;
			
			var depositMoney = $("#popInput").val();
			
			if(isFinite(depositMoney) == false){
				alert("<spring:message code='newwave.wallet.warn_msg1' />");
				return;
			}
			
			var allData = {"depositMoney":depositMoney, "pidx":selectTrader};
			jQuery.ajax({
				type : "POST",
				data : allData,
				url : "/global/user/depositProcessP2P.do",
				dataType : "json",
				success : function(data) {
					if (data.result == "suc") {
						console.log(data.insertIdx);
// 						location.href = "/global/user/kTransactions.do";
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
		function moneySend(){
			var midx = $("#midx").val();
			jQuery.ajax({
				type : "POST",
				data : {"midx" : midx},
				url : "/global/user/moneySend.do",
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
				url : "/global/user/payComplete.do",
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
				url : "/global/user/p2pCancel.do",
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
				url : "/global/user/tradeComplete.do",
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
		        url : "/global/user/chatSend.do",
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
					text = "<div class='chattong_area _1'> <div class='list_profilecircle'> <div>T</div> </div> <div class='chatting_block'> <div class='list_profile_name'>"
						+tName+"</div> <div class='chattingbox _2'>"
						+obj.text+"</div> <div class='chatting_time _1'>"
						+obj.time+"</div> </div> </div>";
				}else{
					text = "<div class='chattong_area _2'> <div class='chatting_block'> <div class='list_profile_name _2'>"
						+userName+"</div> <div class='chattingbox'>"
						+obj.text+"</div> <div class='chatting_time _2'>"
						+obj.time+"</div> </div> <div class='list_profilecircle'> <div>T</div> </div> </div>";
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