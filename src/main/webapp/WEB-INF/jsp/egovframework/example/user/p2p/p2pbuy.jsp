<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html data-wf-page="62b265b778ed4a23a65ce9d5" data-wf-site="62b1125ac4d4d60ab9c62f81">
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
					<div class="deposit_warp4">
						<div class="assettitle">
							<span class="wallet_sub"> USDT <spring:message code="wallet.p2p.buy"/></span>
						</div>
						<div class="buy_list_btnwarp">
							<a href="/global/user/p2pbuy.do" class="buysellbtn buy w-button"><spring:message code="wallet.p2p.buy"/></a> 
							<a href="/global/user/p2psell.do" class="buysellbtn w-button"><spring:message code="wallet.p2p.sell"/></a>
						</div>
						<div class="table_warp">
							<div class="table_scroll">
								<div class="asset_tabletop">
									<div class="list_block1"><spring:message code="wallet.p2p.seller"/></div>
									<div class="listtext1"><spring:message code="wallet.p2p.price"/></div>
									<div class="list_block1">
										<div><spring:message code="wallet.p2p.schedule"/> / <spring:message code="wallet.p2p.limit"/></div>
									</div>
									<div class="list_block2"><spring:message code="wallet.p2p.action"/></div>
								</div>
								<div class="assetwarp">
									<div class="no_data" style=" <c:if test="${fn:length(p2pList) == 0}">display:flex;</c:if>">
										<spring:message code="trader.nodata" />
									</div>
									<c:forEach var="item" items="${p2pList}">
										<input type="hidden" id="name${item.idx}" value="${item.name}">
										<input type="hidden" id="orders${item.idx}" value="${item.orders}">
										<input type="hidden" id="aveTime${item.idx}" value="${item.aveTime}">
										<input type="hidden" id="price${item.idx}" value="${item.price}">
										<input type="hidden" id="qty${item.idx}" value="${item.qty}">
										<input type="hidden" id="lowLimit${item.idx}" value="${item.lowLimit}">
										<input type="hidden" id="maxLimit${item.idx}" value="${item.maxLimit}">
										<div class="asset_table">
											<div class="asset_tablelist">
												<div class="list_block1">
													<div class="list_profilecircle">T</div>
													<div class="list_profilewarp">
														<div class="list_profile_name">${item.name}</div>
														<div>${item.orders}<spring:message code="wallet.p2p.orders"/> | <spring:message code="wallet.p2p.averTime"/> ${item.aveTime}<spring:message code="wallet.p2p.min"/></div>
													</div>
												</div>
												<div class="listtext1"><fmt:formatNumber value="${item.price}" pattern="#,###.########"/> <spring:message code="wallet.p2p.krw"/></div>
												<div class="list_block1">
													<div class="list_txtwarp">
														<div>
															<span class="list_warp_title"><spring:message code="wallet.p2p.qty"/></span> 
															<fmt:formatNumber value="${item.qty}" pattern="#,###.########"/> USDT
														</div>
														<div>
															<span class="list_warp_title"><spring:message code="wallet.p2p.limit"/></span>
															<fmt:formatNumber value="${item.lowLimit}" pattern="#,###.########"/>~
															<fmt:formatNumber value="${item.maxLimit}" pattern="#,###.########"/> 
															<spring:message code="wallet.p2p.krw"/>
														</div>
													</div>
												</div>
												<div class="list_block2">
													<a href="javascript:p2pPop(${item.idx})" class="buysellbtn buy w-button"><spring:message code="wallet.p2p.buy"/></a>
												</div>
											</div>
										</div>
									</c:forEach>
								</div>
							</div>
						</div>
						<div class="listpage_warp">
							<ui:pagination paginationInfo="${pi}" type="customPageUser" jsFunction="fn_egov_link_page" />
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
								<input type="text" class="text-field-27 w-input" maxlength="10" id="popInput" onkeyup="setNum(this)"> 
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
		var selectPrice=0;
		var selectLLimit=0;
		var selectMLimit=0;
		var selectTrader=-1;
		function regist(){
			alert("<spring:message code='wallet.p2p.inquiry'/>");
			location.href="/global/user/helpCenter.do";
		}
		function p2pPop(tidx){
			selectTrader = tidx;
			selectPrice=$("#price"+tidx).val();
			selectLLimit = $("#lowLimit"+tidx).val();
			selectMLimit = $("#maxLimit"+tidx).val();

			$("#popName").text($("#name"+tidx).val());
			$("#popOrders").text($("#orders"+tidx).val());
			$("#popAveTime").text($("#aveTime"+tidx).val());
			$("#popPrice").text(selectPrice);
			$("#popLimit").text(selectLLimit+" ~ "+selectMLimit);
			$("#popQty").text($("#qty"+tidx).val());
			$("#popInput").text("");
			$("#popInput").trigger("input");
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
			var inputVal = Number($("#popInput").val());
			var getUSDT = $("#popGet").val();
			if(isNaN(inputVal)) return false;
// 			else if(inputVal >= 1000000000){
// 				alert("<spring:message code='wallet.p2p.maxinput'/>");
// 				return;
// 			}
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
		});
		
		
		function submit(){
			if(!buyCheck()) return;
			
			var depositMoney = $("#popInput").val();
			
			if(isFinite(depositMoney) == false){
				alert("<spring:message code='newwave.wallet.warn_msg1' />");
				return;
			}
			
			var allData = {"depositMoney":depositMoney, "tidx":selectTrader};
			jQuery.ajax({
				type : "POST",
				data : allData,
				url : "/global/user/depositProcessP2P.do",
				dataType : "json",
				success : function(data) {
					if (data.result == "suc") {
						location.href = "/global/user/p2pDetail.do?midx="+data.insertIdx;
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
	</script>
</body>
</html>