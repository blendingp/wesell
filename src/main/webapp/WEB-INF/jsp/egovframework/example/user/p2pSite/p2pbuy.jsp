<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<jsp:include page="../../p2pSiteFrame/header.jsp"></jsp:include>
</head>
<body class="body">
	<div class="frame">
		<jsp:include page="../../p2pSiteFrame/top.jsp"></jsp:include>

		<div class="general_section wf-section">
			<div class="banner" style="background-image:url('/global/webflow/p2pImages/header_bg.png')">
				<div class="banner_warp">
					<div class="m_head_box">
						<h1 class="m_head">테더 USDT 구매</h1>
						<h2 class="m_head _3"> 글로벌 거래소 비트오션 공식 파트인<br> </h2>
						<h4 class="m_head _2">
							Easy Exchange에서 별도의 회원가입 없이 바로 거래가가능합니다.<br>거래 시 비트오션의 UID,
							전화번호, 성함을 입력하시면 구매 즉시 비트오션 계좌로 <br>테더가 입금됩니다.
						</h4>
					</div>
					<img src="/global/webflow/p2pImages/header_art2.png" loading="lazy"
						srcset="/global/webflow/p2pImages/header_art2-p-500.png 500w, /global/webflow/p2pImages/header_art2.png 616w"
						sizes="(max-width: 479px) 100vw, 300px" alt="" class="banner_img">
				</div>
			</div>
			<div class="general_block">
				<div class="deco"></div>
				<h1 class="general_title">테더(USDT) 구매</h1>
				<!-- <div class="search_block">
					<div class="option_block">
					</div>
					<div class="form-block w-form">
						<div class="search">
							<input type="text" class="search_input w-input" maxlength="256" placeholder="Example Text" id="field-3" required="">
							<a href="#" class="search_btn w-button">검색</a>
						</div>
					</div>
				</div> -->
				<div class="scroll_warp">
					<div class="list_block">
						<div class="list_top">
							<div class="list t">Advertiser</div>
							<div class="list _2 t">Price</div>
							<div class="list t">Schedule/Limit</div>
							<div class="list _2 t">Action</div>
						</div>
						<c:forEach var="item" items="${p2pList}">
							<input type="hidden" id="name${item.idx}" value="${item.name}">
							<input type="hidden" id="orders${item.idx}" value="${item.orders}">
							<input type="hidden" id="aveTime${item.idx}" value="${item.aveTime}">
							<input type="hidden" id="price${item.idx}" value="${item.price}">
							<input type="hidden" id="qty${item.idx}" value="${item.qty}">
							<input type="hidden" id="lowLimit${item.idx}" value="${item.lowLimit}">
							<input type="hidden" id="maxLimit${item.idx}" value="${item.maxLimit}">
							<div class="list_warp">
								<div class="list">
									<div class="user_icon">
										<div>T</div>
									</div>
									<div class="profile">
										<div class="user_name">${item.name}</div>
										<div>${item.orders} Orders | Average time ${item.aveTime}min</div>
									</div>
								</div>
								<div class="list _2">
									<div><fmt:formatNumber value="${item.price}" pattern="#,###"/> KRW</div>
								</div>
								<div class="list">
									<div>
										<fmt:formatNumber value="${item.qty}" pattern="#,###.########"/> USDT / Limit 
										<fmt:formatNumber value="${item.lowLimit}" pattern="#,###.########"/>~
										<fmt:formatNumber value="${item.maxLimit}" pattern="#,###.########"/> 
									</div>
								</div>
								<div class="list _2">
									<a href="javascript:p2pPop(${item.idx})" class="p2p_btn w-button">즉시 구매</a>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
				<div class="list_bottom">
					<div class="page_warp">
						<ui:pagination paginationInfo="${pi}" type="P2PPageUser" jsFunction="fn_egov_link_page" />
					</div>
				</div>
				<form action="/global/easy/p2pbuy.do" name="listform" id="listform">
					<input type="hidden" name="pageIndex" id="pageIndex"/>
				</form>
			</div>
		</div>
		<jsp:include page="../../p2pSiteFrame/footer.jsp"></jsp:include>
		<div class="popup" id="popup" style="display: none;">
			<div class="purchase_pop">
				<div class="purchase_box">
					<div class="p_box1">
						<div class="p_profileblock">
							<div class="p_profile">
								<div class="user_icon">
									<div>T</div>
								</div>
								<div class="profile">
									<div class="user_name"><span id="popName"></span></div>
									<div><span id="popOrders"></span> Orders | Average time <span id="popAveTime">0</span>min</div>
								</div>
							</div>
							<div class="p_intro_txt"></div>
<!-- 							<div class="p_profile2"> -->
<!-- 								<img src="/global/webflow/p2pImages/icon_2.svg" loading="lazy" alt="" -->
<!-- 									class="p_icon"> -->
<!-- 								<div>user12345</div> -->
<!-- 							</div> -->
<!-- 							<div class="p_profile2"> -->
<!-- 								<img src="/global/webflow/p2pImages/icon_3.svg" loading="lazy" alt="" -->
<!-- 									class="p_icon"> -->
<!-- 								<div>82+010-0000-0000</div> -->
<!-- 							</div> -->
<!-- 							<div class="p_profile2"> -->
<!-- 								<img src="/global/webflow/p2pImages/icon_5.svg" loading="lazy" alt="" -->
<!-- 									class="p_icon"> -->
<!-- 								<div>SampleEmail@gmail.com</div> -->
<!-- 							</div> -->
						</div>
						<div class="p_info">
							<div class="p_title">Price</div>
							<div><span id="popPrice">0</span> KRW</div>
						</div>
						<div class="p_info">
							<div class="p_title">Limit</div>
							<div><span id="popLimit"></span> KRW</div>
						</div>
						<div class="p_info">
							<div class="p_title">Qty</div>
							<div><span id="popQty"></span> USDT</div>
						</div>
					</div>
					<div class="p_box2">
						<div class="form-block w-form">
							<form id="email-form" name="email-form" data-name="Email Form"
								method="get" aria-label="Email Form">
								<h4 class="p_p_title">얼마나 구매하시겠습니까?</h4>
								<div class="div-block">
									<div class="p_p_warp">
										<div class="p_title">결제 금액</div>
										<div class="p_p_box">
											<div class="m_c_block">
												<input type="text" class="text-field w-input" maxlength="10" id="popInput" onkeyup="setNum(this)"> 
												<div class="p_unit">KRW</div>
											</div>
										</div>
										<div class="p_warn">
											<img src="/global/webflow/p2pImages/icon_6.svg" loading="lazy" alt="" class="p_icon">
											<div>거래를 시작하시려면 금액을 입력해주십시오.</div>
										</div>
									</div>
									<div class="p_p_warp">
										<div class="p_title">수령 금액</div>
										<div>
											<div class="m_c_block">
												<input type="text" class="text-field w-input" maxlength="256" id="popGet" style="background-color:transparent;" readonly>
												<div class="p_unit">USDT</div>
											</div>
										</div>
									</div>
								</div>
							</form>
						</div>
						<a href="javascript:submit()" class="p_btn w-button">즉시 구매</a>
						<div class="pop_exist" onclick="popClose()" style="cursor:pointer;">
							<img src="/global/webflow/p2pImages/wx.png" loading="lazy" srcset="/global/webflow/p2pImages/wx-p-800.png 800w, /global/webflow/p2pImages/wx-p-1080.png 1080w, /global/webflow/p2pImages/wx.png 1600w" sizes="(max-width: 767px) 4vw, 22px" alt="" class="image-38">
						</div>
<!-- 						<div class="p_warn"> -->
<!-- 							<div>안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 -->
<!-- 								안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 안내사항 -->
<!-- 								안내사항 안내사항</div> -->
<!-- 						</div> -->
					</div>
				</div>
			</div>
		</div>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6180a71858466749aa0b95bc" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="../js/webflow.js" type="text/javascript"></script>
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		function fn_egov_link_page(page){
			$("#pageIndex").val(page);
			$("#listform").submit();
		}
		var selectPrice=0;
		var selectLLimit=0;
		var selectMLimit=0;
		var selectTrader=-1;
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
				alert("선택 금액이 최소 금액보다 작습니다.");
				return false;
			}else if(inputVal > selectMLimit){
				alert("선택 금액이 최대 금액보다 많습니다.");
				return false;
			}else if(getUSDT > Number($("#popQty").text())){
				alert("구매하고자 하는 수량이 판매 수량보다 많습니다.");
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
// 				alert("<spring:message code='newwave.wallet.warn_msg1' />");
				alert("문자는 입력하실 수 없습니다.");
				return;
			}
			
			var allData = {"depositMoney":depositMoney, "tidx":selectTrader};
			jQuery.ajax({
				type : "POST",
				data : allData,
				url : "/global/easy/depositProcessP2P.do",
				dataType : "json",
				success : function(data) {
					if (data.result == "suc") {
						location.href = "/global/easy/p2pDetail.do?midx="+data.insertIdx;
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