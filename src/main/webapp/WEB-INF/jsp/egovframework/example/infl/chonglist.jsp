<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html data-wf-page="618c69624aa9dc39e369f45f" data-wf-site="6180a71858466749aa0b95bc">
<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원관리</title>
<jsp:include page="../userFrame/header.jsp"></jsp:include>
</head>
<style>
.mylist{
	background-color:lemonchiffon;
}
</style>
<body class="influ_body">
	<div class="influ_frame">
		<div class="influ_block">
			<div class="mobbackdark" style="display:none;"></div>
			<jsp:include page="../userFrame/inflLeft.jsp"></jsp:include>
			<div class="influ_block1">
				<jsp:include page="../userFrame/infltop.jsp"></jsp:include>
				<div class="influ_mainblock">
					<div class="influ_mainblock1">
						<div class="influ_title1">총판 관리</div>
						<div class="form-block-9 w-form">
							<form id="listForm" name="listForm" class="form-9" action = "/global/infl/chonglist.do">
								<input type="hidden" name="pageIndex" id="pageIndex"/>
								<div class="influ_date_warp">
									<div class="text-block-18">UID</div>
									<input type="text" class="text-field-16 w-input" maxlength="10" value="${uid}" name="uid" placeholder="UID 입력" id="uid">
								</div>
								<div class="influ_date_warp">
									<div class="text-block-18">전화번호</div>
									<input type="text" class="text-field-16 w-input" maxlength="15" value="${searchPhone}" name="searchPhone" placeholder="전화번호 검색" id="phone">
								</div>
								<div class="influ_date_warp">
									<div class="text-block-18">회원가입 기간 검색</div>
									<input class="text-field-16 w-input" type="date" id="sdate" name="sdate" value="${sdate}" autocomplete="off">
								</div>
								<div class="text-block-20">~</div>
								<div class="influ_date_warp">
									<div class="text-block-18"></div>
									<input class="text-field-16 w-input"  type="date" id="edate" name="edate" value="${edate}" autocomplete="off">
								</div>
								
								<div class="influ_date_warp">
									<div class="text-block-18">정산액 기간 검색</div>
									<input class="text-field-16 w-input" type="date" id="asdate" name="asdate" value="${asdate}" autocomplete="off">
								</div>
								<div class="text-block-20">~</div>
								<div class="influ_date_warp">
									<div class="text-block-18"></div>
									<input class="text-field-16 w-input"  type="date" id="aedate" name="aedate" value="${aedate}" autocomplete="off">
								</div>
								
								<div class="influ_searchbtnwarp">
									<img src="/global/webflow/images/search_1search.png" loading="lazy" alt="" class="image-48"> 
									<a href="javascript:checkForm();" class="button-24 w-button">찾기</a>
								</div>
							</form>
						</div>
					</div>
					<div class="influ_mainblock2">
						<div>
							<div class="influ_tabletop">
								<div class="influ_tablelist right">
									<div class="influ_titletext">UID</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">이름</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">직속 상위</div>
								</div>
								<div class="influ_tablelist list3">
									<div class="influ_titletext">전화번호</div>
								</div>
								<div class="influ_tablelist list4">
									<div class="influ_titletext">회원가입 날짜<br></div>
								</div>
								<div class="influ_tablelist list4">
									<div class="influ_titletext">수수료</div>
								</div>
								<div class="influ_tablelist list4">
									<div class="influ_titletext">미정산</div>
								</div>
								<div class="influ_tablelist list4">
									<div class="influ_titletext">정산 완료</div>
								</div>
								<div class="influ_tablelist list4">
									<div class="influ_titletext">총 실적</div>
								</div>
							</div>
							<c:forEach var="item" items="${list}">
								<div class="influ_tablelcontent <c:if test="${item.idx eq userIdx}">mylist</c:if>">
									<div class="influ_tablelist right">
										<div>${item.idx}</div>
									</div>
									<div class="influ_tablelist list3">
										<div style="cursor:pointer; color:blue;" onclick="location.href='/global/infl/memberDetail.do?idx=${item.idx}'">${item.name}</div>
									</div>
									<div class="influ_tablelist list3">
										<div>
											<c:if test="${item.pName ne null}">${item.pName }</c:if>
											<c:if test="${item.pName eq null}">없음(최상위)</c:if>
										</div>
									</div>
									<div class="influ_tablelist list3">
										<div>${item.phone}</div>
									</div>
									<div class="influ_tablelist list4">
										<div><fmt:formatDate value="${item.joinDate}" pattern="yyyy-MM-dd HH:mm"/></div>
									</div>
									<div class="influ_tablelist list4">
										<div>
											<c:if test="${item.pName ne null}">${item.commissionRate} %</c:if>
										</div>
									</div>
									<div class="influ_tablelist list4">
										<div>
											<c:if test="${item.accum ne null}"><fmt:formatNumber value="${item.accum}" pattern="#,###.########"/></c:if>
											<c:if test="${item.accum eq null}">0.0</c:if> USDT
										 </div>
									</div>
									<div class="influ_tablelist list4">
										<div>
											<c:if test="${item.receive ne null}"><fmt:formatNumber value="${item.receive}" pattern="#,###.########"/></c:if>
											<c:if test="${item.receive eq null}">0.0</c:if> USDT
										</div>
									</div>
									<div class="influ_tablelist list4">
										<div style="color:blue; cursor:pointer;" onclick="location.href='/global/infl/accum.do?searchSelect=phone&search=${item.phone}&sdate=${asdate}&edate=${aedate}'">
											<fmt:formatNumber value="${item.accum + item.receive}" pattern="#,###.########"/> USDT
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
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		function fn_egov_link_page(page) {
			document.listForm.pageIndex.value = page;
			document.listForm.submit();
		}
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
			
			var asdate = $("#asdate").val();
			var aedate = $("#aedate").val();
			if ((asdate == '' && aedate != '') || (asdate != '' && aedate == '')) {
				alert("조회시작기간과 조회종료기간을 설정해주세요.");
				return;
			}
			if (aedate < asdate) {
				alert("조회종료기간이 조회시작기간보다 작을 수 없습니다.");
				return;
			}
			var fm = document.getElementById('listForm');
			fm.submit();
		}
	</script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
</body>
</html>