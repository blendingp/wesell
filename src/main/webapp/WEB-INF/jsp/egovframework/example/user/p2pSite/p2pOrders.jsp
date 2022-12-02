<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html data-wf-page="6183888cbdade398fdbed019"
	data-wf-site="6180a71858466749aa0b95bc">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>transactional information</title>
<meta content="transactional information" property="og:title">
<meta content="transactional information" property="twitter:title">
<jsp:include page="../../p2pSiteFrame/header.jsp"></jsp:include>
<script>
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
</script>
</head>
<body class="body">
	<div class="frame">
		<jsp:include page="../../p2pSiteFrame/top.jsp"></jsp:include>
		<div class="general_section wf-section" style="background-image: url(/global/webflow/p2p/global/webflow/p2pImages/backbox00.png);">
			<div class="banner" style="background-image:url('/global/webflow/p2pImages/header_bg.png');">
				<div class="banner_warp">
					<div class="m_head_box">
						<h1 class="m_head">My Page</h1>
						<h4 class="m_head _2">P2P 거래 내역을 한 눈에 확인하실 수 있습니다.</h4>
					</div>
					<img src="/global/webflow/p2pImages/mypage_hicon.png" loading="lazy"
						srcset="/global/webflow/p2pImages/mypage_hicon-p-500.png 500w, /global/webflow/p2pImages/mypage_hicon.png 506w"
						sizes="(max-width: 479px) 100vw, 300px" alt="" class="banner_img">
				</div>
			</div>
			<div class="general_block">
				<div class="deco"></div>
				<h1 class="general_title">거래내역</h1>
				<div class="search_block">
					<div class="option_block">
						<div class="form-block w-form">
							<form action="/global/easy/p2pOrders.do" name="listform" id="listform">
								<input type="hidden" name="pageIndex" id="pageIndex"/>
								<div class="option_warp">
									<div class="op_warp">
										<div class="option_title">구분</div>
										<select id="op" name="op" onchange="tabChange(this.value)" class="select-field w-select">
											<option value="all"><spring:message code="newwave.wallet.all" /></option>
											<option value="Deposit"
												<c:if test="${op eq 'Deposit'}">selected</c:if>>구매</option>
											<option value="Withdrawl"
												<c:if test="${op eq 'Withdrawl'}">selected</c:if>>판매</option>
										</select>
									</div>
									<div class="op_warp">
										<div class="option_title">시작날짜</div>
										<input type="text" class="date_input w-input" name="sDate" value="${sDate}" autocomplete="off" onchange="changeList(this.value)" id="sDate">
									</div>
									<div class="op_warp">
										<div class="option_title">종료날짜</div>
										<input type="text" class="date_input w-input" name="eDate" value="${eDate}" autocomplete="off" onchange="changeList(this.value)" id="eDate">
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
				<div class="scroll_warp">
					<div class="list_block history">
						<div class="list_top">
							<div class="list _3 t">시간</div>
							<div class="list t">거래자</div>
							<div class="list _3 t">구분</div>
							<div class="list _2 t">단일가격</div>
							<div class="list _2 t">수량</div>
							<div class="list _3 t">상태</div>
							<div class="list _2 t">상세</div>
						</div>
						
						<c:forEach var="item" items="${list}">
							<div class="list_warp">
								<div class="list _3">
									<fmt:formatDate value="${item.mdate}" pattern="yyyy-MM-dd HH:mm" />
								</div>
								<div class="list">
									<div class="user_icon">
										<div>T</div>
									</div>
									<div class="profile">
										<div class="user_name">${item.name}</div>
										<div>${item.orders} Orders | Average time ${item.aveTime}min</div>
									</div>
								</div>
								<div class="list _3">
									<c:if test="${item.kind eq '+'}">
										구매
									</c:if>
									<c:if test="${item.kind eq '-'}">
										판매
									</c:if>
								</div>
								<div class="list _2">
									<div><fmt:formatNumber value="${item.exchangeRate}" pattern="#,###"/>  KRW</div>
								</div>
								<div class="list _2">
									<fmt:formatNumber value="${item.exchangeValue}" pattern="#,###.##"/> USDT
								</div>
								<div class="list _3">
									<c:if test="${item.stat == -1}">
										<div class="state">대기중</div>
									</c:if>
									<c:if test="${item.stat == 0}">
										<div class="state">결제 완료</div>
									</c:if>
									<c:if test="${item.stat == 1}">
										<div class="state ok">결제 완료</div>
									</c:if>
									<c:if test="${item.stat == 2}">
										<div class="state cancle">거절</div>
									</c:if>
									<c:if test="${item.stat == 3}">
										<div class="state">취소</div>
									</c:if>
								</div>
								<div class="list _2">
									<div class="detail_warp">
<!-- 										<div class="new_circle">N</div> -->
										<a href="/global/easy/p2pDetail.do?midx=${item.idx}" class="p2p_btn w-button">상세내역</a>
									</div>
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
			</div>
		</div>
		<jsp:include page="../../p2pSiteFrame/footer.jsp"></jsp:include>
	</div>
	<script
		src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93"
		type="text/javascript"
		integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
		crossorigin="anonymous"></script>
	<script src="/global/webflow/js/webflow.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
	<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		var tempStartDate = "${date}";
		var tempEndDate = "${edate}";

		function fn_egov_link_page(page) {
			document.listform.pageIndex.value = page;
			document.listform.submit();
		}

		function tabChange(deposit) {
			// 		$(".titlebotton").removeClass("click");
			// 		$("#"+deposit+"Bar").addClass("click");
			$("#op").val(deposit);
			if (deposit == 'deposit') {
				$("#label").val("+");
			} else if (deposit == 'withdraw') {
				$("#label").val("-");
			}
			$("#listform").submit();
		}
		function nonLabel() {
			if ($("#label").val() == null || $("#label").val() == "")
				$("#label").val('+');
			console.log($("#label").val());
		}
		//nonLabel();

		$(function() {
			$("#sDate").datepicker({
				dateFormat : 'yy-mm-dd',
				beforeShow : function(input) {
					$(input).css({
						"position" : "relative",
						"z-index" : 3
					});
				},
				onSelect : function(dateText, inst) {
					if (dateComparison()) {
						$("#sDate").val(dateText);
						$("#listform").submit();
					}
				}
			});
			$("#eDate").datepicker({
				dateFormat : 'yy-mm-dd',
				beforeShow : function(input) {
					$(input).css({
						"position" : "relative",
						"z-index" : 3
					});
				},
				onSelect : function(dateText, inst) {
					if (dateComparison()) {
						$("#eDate").val(dateText);
						$("#listform").submit();
					}
				}
			});
		});

		function dateComparison() {
			var startDate = $('#sDate').val();
			var endDate = $('#eDate').val();

			//-을 구분자로 연,월,일로 잘라내어 배열로 반환
			var startArray = startDate.split('-');
			var endArray = endDate.split('-');
			//배열에 담겨있는 연,월,일을 사용해서 Date 객체 생성
			var start_date = new Date(startArray[0], startArray[1],
					startArray[2]);
			var end_date = new Date(endArray[0], endArray[1], endArray[2]);
			//날짜를 숫자형태의 날짜 정보로 변환하여 비교한다.
			if (start_date.getTime() > end_date.getTime()) {
				$('#dateText').val(tempStartDate);
				$('#endDateText').val(tempEndDate);
				alert("종료날짜보다 시작날짜가 작아야합니다.");
				return false;
			}
			return true;
		}
		datePickerLangSet();
	</script>
</body>
</html>