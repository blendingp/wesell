<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar" style="font-weight:bold;">
	   <a class="sidebar-brand d-flex align-items-center justify-content-center" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/main.do">
            <div class="sidebar-brand-icon rotate-n-15">
                <i class="fas fa-laugh-wink"></i>
            </div>
            <div class="sidebar-brand-text mx-3">Admin</div>
        </a>
		<c:if test="${adminLevel ne 3}">
			<li class="nav-item">
	        	<a class="nav-link" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/dangerMsgList.do" id="danger">
	                   <i class="fas fa-fw fa-exclamation-circle"></i>
	                   <span>주의회원 알림 <span id="dangerCnt"></span></span></a>
	        	</li>
			<c:if test="${project.wdPhoneMsg eq true}">
				<li class="nav-item">
	               <a class="nav-link" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/wdPhoneList.do">
	                   <i class="fas fa-fw fa-exclamation-circle"></i>
	                   <span>관리자 알림 휴대폰</span></a>
	           	</li>
			</c:if>
	
			<c:set var="collapseCnt" value="1"/>
	        <li class="nav-item">
	           <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
	               <i class="fas fa-fw fa-cog"></i>
	               <span>회원 관리</span>
	           </a>
	           <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
	               <div class="bg-white py-2 collapse-inner rounded">
	                   <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userList.do?test=test">전체 회원 관리</a>
			        <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userList.do?level=chong&test=test">파트너 회원 관리</a>
			        <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userList.do?level=user&test=test">일반 회원 관리</a>
			        <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userList.do?out=out&test=test">삭제 회원 관리</a>
			       	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userList.do?ban=ban&test=test">차단 회원 관리</a>
	               </div>
	           </div>
	        </li>
			
			<c:set var="collapseCnt" value="${collapseCnt+1}"/>
			<c:if test="${adminLevel eq 1}">
	           <li class="nav-item">
	               <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
	                   <i class="fas fa-fw fa-wrench"></i>
	                   <span>관리자</span>
	               </a>
	               <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
	                   <div class="bg-white py-2 collapse-inner rounded">
	                       <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/subAdminList.do">하위 관리자 리스트</a>
	                       <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/createSubAdmin.do">하위 관리자 생성</a>
	                       <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/log/log.do">관리자 로그</a>
	                       <c:if test="${project.adminIp eq true}">
	                       	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/adminIpList.do">관리자 IP 설정</a>
	                       </c:if>
	                   </div>
	               </div>
	           </li>
	           <li class="nav-item">
	              <a class="nav-link" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/fixstat.do">
	                  <i class="fas fa-fw fa-edit"></i>
	                  <span>사이트 점검</span></a>
	           </li>
			</c:if>
				
			<c:set var="collapseCnt" value="${collapseCnt+1}"/>
			<li class="nav-item">
				<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
	                <i class="fas fa-fw fa-cog"></i>
	                <span>거래</span>
	            </a>
	            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
	                <div class="bg-white py-2 collapse-inner rounded">
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/tradeList.do?test=test">거래내역 ${futures}</a>
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/orderList.do?test=test">주문내역 ${futures}</a>
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/liqList.do?test=test">청산내역 ${futures}</a>
	                    <c:if test="${project.inverse eq true}">
	                     <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/tradeList.do?test=test&inverse=inverse">거래내역 (현물)</a>
	                     <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/orderList.do?test=test&inverse=inverse">주문내역 (현물)</a>
	                     <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/liqList.do?test=test&inverse=inverse">청산내역 (현물)</a>
	                    </c:if>
	                    <c:if test="${project.adminIp eq true}">
	                    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/adminIpList.do">관리자 IP 설정</a>
	                    </c:if>
	                    <c:if test="${project.tailUse eq true}">
	                    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/tailmanipul.do">사용안함</a>
	                    </c:if>
	                </div>
	            </div>
	        </li>
			<li class="nav-item">
	            <a class="nav-link" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/positionList.do">
	                <i class="fas fa-fw fa-signal"></i>
	                <span>현재 회원 포지션</span>
	            </a>
	        </li>
	        <c:if test="${project.spotTrade eq true}">
		        <c:set var="collapseCnt" value="${collapseCnt+1}"/>
		        <li class="nav-item">
					<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
		                <i class="fas fa-fw fa-cog"></i>
		                <span>현물거래</span>
		            </a>
		            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
		                <div class="bg-white py-2 collapse-inner rounded">
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/spottrade/tradeList.do?test=test">거래내역</a>
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/spottrade/orderList.do?test=test">주문내역</a>	                    	                    	          
		                </div>
		            </div>
		        </li>
				<li class="nav-item">
		            <a class="nav-link" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/positionList.do">
		                <i class="fas fa-fw fa-signal"></i>
		                <span>현재 회원 포지션</span>
		            </a>
		        </li>
	        </c:if>
	        
	        <c:set var="collapseCnt" value="${collapseCnt+1}"/>
	        <li class="nav-item">
				<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
	                <i class="fas fa-fw fa-folder"></i>
	                <span>카피트레이딩</span>
	            </a>
	            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
	                <div class="bg-white py-2 collapse-inner rounded">
	                    <a class="collapse-item copytrade" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trader/traderList.do">트레이더 <span id="traderRequest"></span></a>
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trader/followerList.do">팔로워</a>
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trader/copytradeLog.do">트레이딩 로그</a>
	                    <c:if test="${project.copyRequest eq true}">
	                    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trader/copyRequestList.do">팔로우 신청 리스트</a>
	                    </c:if>
	                </div>
	            </div>
	        </li>
	        <c:set var="collapseCnt" value="${collapseCnt+1}"/>
	        <c:if test="${project.coinDeposit eq true}">
		        <li class="nav-item">
					<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
		                <i class="fas fa-fw fa-folder"></i>
		                <span>입출금 (코인)</span>
		            </a>
		            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
		                <div class="bg-white py-2 collapse-inner rounded">
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?test=test">입출금 내역</a>
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/chongPerfomance.do">총판별 입출금 취합</a>
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/depositList.do?test=test&order=completionTime&orderAD=desc" id="depositLeft">입금신청 목록<span id="depositLeftButton"></span></a>
	                    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/withdrawalList.do?test=test" id="withdrawLeft">출금신청 목록<span id="withdrawLeftButton"></span></a>
		                </div>
		            </div>
		        </li>
	        </c:if>
	        <c:set var="collapseCnt" value="${collapseCnt+1}"/>
	        <c:if test="${project.krwDeposit eq true}">
		        <li class="nav-item collapsed">
					<a class="nav-link" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
		                <i class="fas fa-fw fa-folder"></i>
		                <span>입출금 (한화)<span  id="k_withdrawLeft" ></span></span>
		            </a>
		            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
		                <div class="bg-white py-2 collapse-inner rounded">
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/kWithdrawalList.do?kind=d&stat=0">입금신청 목록</a>
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/kWithdrawalList.do?kind=w&stat=0">출금신청 목록</a>
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/kWithdrawalList.do?kind=&except=0">입출금 처리내역</a>
	                    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/kWithdrawalList.do?kind=&except=0&test=test">입출금 처리내역(테스트)</a>
		                </div>
		            </div>
		        </li>
	        </c:if>
	        <c:if test="${project.notloginmoney eq true}">
				<li class="nav-item">
		            <a class="nav-link" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/notLoginKWithdrawalList.do?kind=d">
		                <i class="fas fa-fw fa-signal"></i>
		                <span>미로그인입금신청</span>
		            </a>
		        </li>
	        </c:if>
	        <c:set var="collapseCnt" value="${collapseCnt+1}"/>
	        <c:if test="${project.p2p eq true}">
	        	<li class="nav-item">
					<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
		                <i class="fas fa-fw fa-folder"></i>
		                <span>P2P <span id="p2pLeft"></span></span>
		            </a>
		            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
		                <div class="bg-white py-2 collapse-inner rounded">
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pInsert.do">P2P 등록</a>
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pList.do">P2P 리스트</a>
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pLog.do?kind=d">P2P 입금내역</a>
	                    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pLog.do?kind=w">P2P 출금내역</a>
	                    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/p2p/dwCalculate.do">P2P 입출금 정산</a>
		                </div>
		            </div>
		        </li>
	        </c:if>
	        <c:set var="collapseCnt" value="${collapseCnt+1}"/>
	        <c:if test="${(project.feeAccum eq true) or (project.feeReferral eq true)}">
	        	<li class="nav-item">
					<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
		                <i class="fas fa-fw fa-table"></i>
		                <span>레퍼럴</span>
		            </a>
		            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
		                <div class="bg-white py-2 collapse-inner rounded">
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/referral/giveReferral.do">레퍼럴 지급</a>
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/log/pointLog.do?ltype=accumRef">레퍼럴 지급 로그 (Futures)</a>
		                    <c:if test="${project.inverse eq true}">
		                    	<c:forEach var="item" items="${useCoins}">
				                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/log/coinLog.do?ltype=accumRef">레퍼럴 지급 로그 (${item})</a>
		                    	</c:forEach>
		                    </c:if>
		                </div>
		            </div>
		        </li>
	        </c:if>
	        <c:set var="collapseCnt" value="${collapseCnt+1}"/>
	        <c:if test="${project.coinDeposit eq true}">
	        	<li class="nav-item">
					<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
		                <i class="fas fa-fw fa-wrench"></i>
		                <span>가상계좌</span>
		            </a>
		            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
		                <div class="bg-white py-2 collapse-inner rounded">
		                    <c:if test="${project.depositFee eq true}">
					    		<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/showDepositFee.do?coinname=BTC">BTC 입금 수수료 설정</a> 
						    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/showDepositFee.do?coinname=USDT">USDT 입금 수수료 설정</a>
						        <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/showDepositFee.do?coinname=ETH">ETH 입금 수수료 설정</a> 
						    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/showDepositFee.do?coinname=XRP">XRP 입금 수수료 설정</a> 
						    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/showDepositFee.do?coinname=TRX">TRX 입금 수수료 설정</a> 
					    	</c:if>
					    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/showFee.do?coinname=BTC">BTC 출금 수수료 설정</a>
					    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/showFee.do?coinname=USDT">USDT 출금 수수료 설정</a>
					        <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/showFee.do?coinname=ETH">ETH 출금 수수료 설정</a>
					    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/showFee.do?coinname=XRP">XRP 출금 수수료 설정</a>
					    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/account/showFee.do?coinname=TRX">TRX 출금 수수료 설정</a>
		                </div>
		            </div>
		        </li>
	        </c:if>
	        <c:set var="collapseCnt" value="${collapseCnt+1}"/>
	       	<li class="nav-item">
				<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
	                <i class="fas fa-fw fa-table"></i>
	                <span>코인 로그</span>
	            </a>
	            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
	                <div class="bg-white py-2 collapse-inner rounded">
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/log/pointLog.do">USDT(FUTURES)</a>
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/log/coinLog.do?coin=USDT">USDT</a>
	                   	<c:forEach var="item" items="${useCoins}">
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/log/coinLog.do?coin=${item}">${item}</a>
	                   	</c:forEach>
	                </div>
	            </div>
	        </li>
	        <c:set var="collapseCnt" value="${collapseCnt+1}"/>
	        <li class="nav-item">
				<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
	                <i class="fas fa-fw fa-table"></i>
	                <span>펀딩 로그</span>
	            </a>
	            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
	                <div class="bg-white py-2 collapse-inner rounded">
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/log/fundingLog.do?coin=FUTURES">USDT(FUTURES)</a>
	                    <c:if test="${project.inverse eq true}">
		                   	<c:forEach var="item" items="${useCoins}">
			                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/log/fundingLog.do?coin=${item}">${item}</a>
		                   	</c:forEach>
	                   	</c:if>
	                </div>
	            </div>
	        </li>
	        <c:set var="collapseCnt" value="${collapseCnt+1}"/>
	        <li class="nav-item">
				<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
	                <i class="fas fa-fw fa-minus"></i>
	                <span>차단 목록</span>
	            </a>
	            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
	                <div class="bg-white py-2 collapse-inner rounded">
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/ipBanList.do">IP 차단 목록</a>
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userBanList.do">유저 차단 목록</a>
	                </div>
	            </div>
	        </li>
	        <c:set var="collapseCnt" value="${collapseCnt+1}"/>
	        <li class="nav-item">
				<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
	                <i class="fas fa-fw fa-wrench"></i>
	                <span>공지사항 게시판</span>
	            </a>
	            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
	                <div class="bg-white py-2 collapse-inner rounded">
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/board/noticeList.do">공지사항</a>
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/board/eventList.do">팝업 공지사항</a>
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/board/systemList.do">자동댓글 게시판</a>
	                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/board/faqList.do">FAQ</a>
	                </div>
	            </div>
	        </li>
	        <li class="nav-item">
	            <a class="nav-link" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/contact/contactList.do" id="contact">
	                <i class="fas fa-fw fa-comment-o"></i>
	                <span>문의</span>
	            </a>
	        </li>
	        <c:if test="${project.letter eq true}">
	        	<li class="nav-item">
	            <a class="nav-link" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/contact/sendMessage.do">
	                <i class="fas fa-fw fa-envelope-o"></i>
	                <span>쪽지 보내기</span>
	            </a>
	        </li>
	        </c:if>
        </c:if>
        <c:if test="${adminLevel eq 3}">
	        <c:set var="collapseCnt" value="0"/>
	        <c:if test="${project.p2p eq true}">
	        	<li class="nav-item">
					<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapse${collapseCnt}" aria-expanded="true" aria-controls="collapse${collapseCnt}">
		                <i class="fas fa-fw fa-folder"></i>
		                <span>P2P <span id="p2pLeft"></span></span>
		            </a>
		            <div id="collapse${collapseCnt}" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
		                <div class="bg-white py-2 collapse-inner rounded">
		                	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pInsert.do">P2P 등록</a>
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pList.do">P2P 리스트</a>
		                    <a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pLog.do?kind=d">P2P 입금내역</a>
	                    	<a class="collapse-item" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pLog.do?kind=w">P2P 출금내역</a>
		                </div>
		            </div>
		        </li>
	        </c:if>
        </c:if>
                
<!-- 				<li> -->
<!-- 				    <a href="#"><i class="fa fa-list fa-fw"></i> 카피 일괄처리<span class="fa arrow"></span></a> -->
<!-- 				    <ul class="nav nav-second-level collapse"> -->
<!-- 				        <li> <a href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/copysInsert.do">등록</a> </li> -->
<!-- 				        <li> <a href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/copysRelease.do">해제</a> </li> -->
<!-- 				    </ul> -->
<!-- 				</li>			 -->
         <!-- Divider -->
         <hr class="sidebar-divider d-none d-md-block">

         <!-- Sidebar Toggler (Sidebar) -->
         <div class="text-center d-none d-md-inline">
             <button class="rounded-circle border-0" id="sidebarToggle"></button>
         </div>
     </ul>
</body>
<script>
var coinDeposit = '${project.coinDeposit}' ;
var krwDeposit = '${project.krwDeposit}' ;
var p2p = '${project.p2p}' ;

var askSound = new Audio();
askSound.src = "/wesell/sound/tin2.mp3";
var withdrawSound = new Audio();
withdrawSound.src = "/wesell/sound/withdraw.mp3";
var depositSound = new Audio();
depositSound.src = "/wesell/sound/deposit.mp3";

var servername = '<%=request.getServerName()%>';
var wsUriToWeb = "wss://<%=request.getServerName()%>:<%=request.getServerPort()%>/wesell/websocket/echo.do"; //주소 확인!!
if(servername == "localhost")
	wsUriToWeb = "ws://<%=request.getServerName()%>:<%=request.getServerPort()%>/wesell/websocket/echo.do"; //주소 확인!!

function init() {
	websocket = new WebSocket(wsUriToWeb);
	websocket.onopen = function(evt) {
		onOpen(evt);
	};
	websocket.onmessage = function(evt) {
		onMessage(evt);
	};
	websocket.onerror = function(evt) {
		onError(evt);
	};
}
function onOpen(evt) {
	var obj = new Object();
	obj.protocol = "adminLogin";
	doSend(JSON.stringify(obj));
}

function onError(evt) {	
}

function doSend(message) {websocket.send(message);}

function onMessage(evt) {
	var obj = JSON.parse(evt.data);
	if(obj.protocol == 'newMember'){
		askSound.play();
		$("#member").css("background-color","tomato");
	}
	if(obj.protocol == 'submitRequest'){
		askSound.play();
// 		alert("문의가 들어왔습니다.");
		askCheck();
	}
	else if(obj.protocol == 'dangerTrade'){
		askSound.play();
		dangerReadCheck();
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
	else if(obj.protocol == 'copytraderInsert'){
		askSound.play();
		dangerReadCheck();
	}
	else if(obj.protocol == 'apiMoneyResult'){
		if(fileurl == 'money'){
			location.reload();
		}
	}
}
init();
dangerReadCheck();
//setInterval(askCheck, 5000);

function dangerReadCheck(){
	$.ajax({
		type:'post',
		url:'/wesell/0nI0lMy6jAzAFRVe0DqLOw/getDangerRead.do',
		dataType:'json',
		success:function(data){
			if(data.read != 0){
				$("#danger").css("background-color","tomato");
				$("#dangerCnt").html("<button type='button' class='btn btn-info btn-sm'>미확인 : "+data.read+"</button>");
			}
			if(data.copy != 0){
				$(".copytrade").css("background-color","tomato");
				$("#traderRequest").html("<button type='button' class='btn btn-info btn-sm'>신규 : "+data.copy+"</button>");
			}
		},
		error:function(e){
			console.log('ajax Error ' + JSON.stringify(e));
		}
	})
}

function allAlarmChek(){
	$.ajax({
		type :"post",
		dataType : "json" ,
		url : "/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/isAllAlarmCheck.do",
		success:function(data){
			if(data.result == "success"){
				var alarm = 0;
				if(coinDeposit == 'true' && (data.dcnt>0 || data.wcnt>0)){
					alarm = 1;
					if(data.wcnt == 0){
						$("#withdrawLeftButton").html('');
						$("#withdrawLeft").css("background-color","");
					}
					else{
						$("#withdrawLeftButton").html('<button type="button" class="btn btn-info btn-sm">'+data.wcnt+'</button>');
						$("#withdrawLeft").css("background-color","tomato");
					}
					
					if(data.dcnt == 0){
						$("#depositLeftButton").html('');
						$("#depositLeft").css("background-color","");
					}
					else{
						$("#depositLeftButton").html('<button type="button" class="btn btn-info btn-sm">'+data.dcnt+'</button>');
						$("#depositLeft").css("background-color","tomato");
					}
				}
				if(krwDeposit == 'true' && (data.kdcnt>0 || data.kwcnt>0)){
					alarm = 1;
					$("#k_withdrawLeft").html('');
					writeButton($("#k_withdrawLeft"),"입금:"+data.kdcnt);
					writeButton($("#k_withdrawLeft"),"출금:"+data.kwcnt);
				}
				if(p2p == 'true' && (data.p2pdcnt>0 || data.p2pwcnt>0)){
					alarm = 1;
					$("#p2pLeft").html('');
					writeButton($("#p2pLeft"),"입금:"+data.p2pdcnt);
					writeButton($("#p2pLeft"),"출금:"+data.p2pwcnt);
				}
				if(data.askcnt>0){
					alarm = 1;
					$("#contact").css("background-color","tomato");
					$("#contact").html('<button type="button" class="btn btn-info btn-sm">문의:'+data.askcnt+'</button>');
				}
				else{
					$("#contact").css("background-color","");
				}
				
				if(data.newMemCnt>0){
					alarm = 1;
					$("#member").css("background-color","tomato");
					$("#member").html('<i class="fa fa-user fa-fw"></i> 회원관리<button type="button" class="btn btn-info btn-sm">신규:'+data.newMemCnt+'</button><span class="fa arrow"></span>');
				}
				else{
					$("#member").css("background-color","");
					$("#member").html('<i class="fa fa-user fa-fw"></i> 회원관리<span class="fa arrow"></span>');
				}
				
				if(alarm == 1){
					askSound.play();
				}
			}
			else{
				return;
			}
		},
		error:function(e){ console.log("ajax error"); }
	});
}

function writeButton(obj,text){
	$(obj).append('<button type="button" class="btn btn-info btn-sm">'+text+'</button>')
}

function withdrawSoundPlay(){
	withdrawSound.play();
}
function depositSoundPlay(){
	depositSound.play();
}

allAlarmChek();
setInterval(allAlarmChek, 50000);

function updateBalanceCheck(useridx){
	$.ajax({
		type:'post',
		data:{"idx" : useridx},
		url:'/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/balanceCheck.do',
		dataType:'json',
		success:function(data){
			alert(data.msg);
			setTimeout(reload, 50000);
		},
		error:function(e){
			console.log('ajax Error ' + JSON.stringify(e));
		}
	})
}
function reload(){
	location.reload();
}

function isInverse(symbol){
	let sym = String(symbol);
	if(sym.charAt(sym.length-1) == 'D')
		return true;
	return false;
}

</script>
</html>