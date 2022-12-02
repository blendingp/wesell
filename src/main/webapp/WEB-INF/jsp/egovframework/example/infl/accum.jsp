<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html data-wf-page="618c69908e7b44b6aeb26fc8" data-wf-site="6180a71858466749aa0b95bc">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>정산</title>
<jsp:include page="../userFrame/header.jsp"></jsp:include>  
</head>
<body class="influ_body">
	<div class="influ_frame">
		<div class="influ_block">
			<div class="mobbackdark"></div>
			<jsp:include page="../userFrame/inflLeft.jsp"></jsp:include>
			<div class="influ_block1">
				<jsp:include page="../userFrame/infltop.jsp"></jsp:include>
				<div class="influ_mainblock">
					<div class="influ_mainblock1">
						<div class="influ_title1">하위 누적 거래내역</div>
						<div class="form-block-9 w-form">
							<form name="listForm" id="listForm" action="/global/infl/accum.do" class="form-9">
								<input type="hidden" name="pageIndex" />
								<div class="influ_date_warp">
									<div class="text-block-18">코인종류</div>
									<select id="symbol" name="symbol" class="select-field-6 w-select">
										<option value="">전체</option>
										<option value="BTCUSDT"<c:if test="${symbol eq 'BTCUSDT'}">selected</c:if>>BTC</option>
										<option value="ETHUSDT"<c:if test="${symbol eq 'ETHUSDT'}">selected</c:if>>ETH</option>
										<option value="XRPUSDT" <c:if test="${symbol eq 'XRPUSDT' }">selected</c:if>>XRP</option>
										<option value="TRXUSDT" <c:if test="${symbol eq 'TRXUSDT' }">selected</c:if>>TRX</option>
									</select>
								</div>
								<div class="influ_date_warp">
									<div class="text-block-18">정산 시작시간</div>
									<input class="text-field-16 w-input"  type="date" id="sdate" name="sdate" value="${sdate}" autocomplete="off">
								</div>
								<div class="text-block-20">~</div>
								<div class="influ_date_warp">
									<div class="text-block-18">정산 종료시간</div>
									<input class="text-field-16 w-input"  type="date" id="edate" name="edate" value="${edate}" autocomplete="off">
								</div>
								<div class="influ_date_warp" style="width:100px;">
									<div class="text-block-18">검색</div>
									<select id="symbol" name="searchSelect" class="select-field-6 w-select">
										<option value="name"<c:if test="${searchSelect eq 'name'}">selected</c:if>>회원명</option>
										<option value="phone"<c:if test="${searchSelect eq 'phone'}">selected</c:if>>휴대폰</option>
										<option value="id"<c:if test="${searchSelect eq 'id'}">selected</c:if>>아이디</option>
									</select>
								</div>
								<div class="influ_date_warp">
									<div class="text-block-18"></div>
									<input type="text" class="text-field-16 w-input"  maxlength="30" value="${search}" name="search" placeholder="검색어 입력" id="search">
								</div>
								<div class="influ_searchbtnwarp">
									<img src="/global/webflow/images/search_1search.png" loading="lazy" alt="" class="image-48"> 
									<a href="javascript:checkForm()" class="button-24 w-button">찾기</a>
								</div>
							</form>
						</div>
					</div>
					<div class="influ_mainblock3">
						<div class="text-block-18">
							<c:if test="${accumInfo eq null}">누적 기록 없음</c:if>
							<c:if test="${accumInfo ne null}">
								현재 총 누적 커미션: <fmt:formatNumber value="${accumInfo.accum}" pattern="####.######"/> USDT    / 현재 커미션 비율: ${accumInfo.myrate} %
							</c:if>
						</div>
					</div>
					<div class="influ_mainblock2">
						<div>
							<div class="influ_tabletop">
								<div class="influ_tablelist right">
									<div class="influ_titletext">날짜</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">회원명</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">직속 상위</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">코인종류</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">주문타입</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">포지션</div>
								</div>
								<div class="influ_tablelist">
									<div class="influ_titletext">레버리지</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">가격</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">수량</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">총 정산액</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">실누적액</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">정산 여부</div>
								</div>
							</div>
							<c:forEach var="item" items="${list}">
								<div class="influ_tablelcontent">
									<div class="influ_tablelist right">
										<div><fmt:formatDate value="${item.buyDatetime}" pattern="YY-MM-dd HH:mm"/></div>
									</div>
									<div class="influ_tablelist">
										<div>${item.name}</div>
									</div>
									<div class="influ_tablelist">
										<c:if test="${item.pName eq null}">없음(최상위)</c:if>
										<c:if test="${item.pName ne null}">${item.pName}</c:if>
									</div>
									<div class="influ_tablelist">
										<div>${item.symbol}</div>
									</div>
									<div class="influ_tablelist">
										<div>${item.orderType}</div>
									</div>
									<div class="influ_tablelist">
										<div>
											<c:if test="${item.isOpen eq true}">
                                            	<c:if test="${item.position eq 'long'}">LONG</c:if>
                                            	<c:if test="${item.position eq 'short'}">SHORT</c:if>
											</c:if>
											<c:if test="${item.isOpen ne true}">
                                            	<c:if test="${item.position eq 'long'}">SHORT</c:if>
                                            	<c:if test="${item.position eq 'short'}">LONG</c:if>
											</c:if>
										</div>
									</div>
									<div class="influ_tablelist">
										<div>${item.leverage}</div>
									</div>
									<div class="influ_tablelist list3">
										<div><fmt:formatNumber value="${item.entryPrice}" pattern="####.######"/>  USDT</div>
									</div>
									<div class="influ_tablelist list3">
										<c:set var="coinLength" value="${fn:length(item.symbol)}" />
										<div><fmt:formatNumber value="${item.buyQuantity}" pattern="####.########"/> ${fn:substring(item.symbol,0,coinLength-4)}</div>
									</div>
									<div class="influ_tablelist list3">
										<div>
											<c:if test="${item.isOpen eq true}">오픈</c:if>
                                           	<c:if test="${item.isOpen ne true}"><fmt:formatNumber value="${item.result}" pattern="#,###.########"/> USDT</c:if>
                                      	</div>
									</div>
									<div class="influ_tablelist list3">
										<div>
											<fmt:formatNumber value="${item.allot}" pattern="#,###.########"/> USDT
                                      	</div>
									</div>
									<div class="influ_tablelist list3">
										<div>
											<c:if test="${item.isGive eq '0'}">미지급</c:if>
                                           	<c:if test="${item.isGive eq '1'}">지급완료</c:if>
                                      	</div>
									</div>
								</div>
							</c:forEach>
						</div>
						<div class="influ_pagigng">
							<ui:pagination paginationInfo="${pi}" type="customPageInfl" jsFunction="fn_egov_link_page"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script
		src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93"
		type="text/javascript"
		integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
		crossorigin="anonymous"></script>
	<script src="/global/webflow/js/webflow.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		function checkForm() {
			var sdate = $("#sdate").val();
			var edate = $("#edate").val();
			if ((sdate == '' && edate != '') || (sdate != '' && edate == '')) {
				alert("조회시작기간과 조회종료기간을 설정해주세요.");
				return;
			}
			if (edate < sdate) {
				alert("조회종료기간이 조회시작기간보다 작을 수 없습니다.");
				return;
			}
			$("#listForm").submit();
		}

		function fn_egov_link_page(page) {
			document.listForm.pageIndex.value = page;
			document.listForm.submit();
		}

	</script>
</body>
</html>