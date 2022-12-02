<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../adminFrame/header.jsp"></jsp:include>
</head>
<body id="page-top">
	<div id="wrapper">
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">user Detail</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3"></div>
						<div class="card-body">
							<c:if test="${info.color eq null}">
								<div class="panel-heading">
								</div>
							</c:if>
							<c:if test="${info.color ne null}">
								<div class="panel-heading"
									style="background-color:${info.color}">
								</div>
							</c:if>
							<div class="card-body">
								<form name="updateForm" id="updateForm" method="post">
									<input type="hidden" name="idx" value="${info.idx}" /> <input
										type="hidden" id="kind" name="kind" /> <input type="hidden"
										id="changeParent" name="changeParent"
										value="${info.parentsIdx}" />
									<div style="margin-bottom: 10px;">
										<button type="button"
											onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/trade/orderList.do?searchSelect=idx&search=${info.idx}'"
											class="btn btn-primary">주문내역</button>
										<button type="button"
											onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/trade/tradeList.do?searchSelect=idx&search=${info.idx}'"
											class="btn btn-primary">거래내역</button>
										<button type="button"
											onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/trade/liqList.do?searchSelect=idx&search=${info.idx}'"
											class="btn btn-primary">청산내역</button>
										<c:if test="${adminLevel eq 1}">
											<button type="button"
												onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/trade/positionList.do?search=${info.name}'"
												class="btn btn-primary">포지션내역</button>
										</c:if>
										<c:if test="${project.coinDeposit eq true}">
											<button type="button"
												onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?pageIndex=1&searchSelect=idx&search=${info.idx}&label=%2B'"
												class="btn btn-primary">입금내역</button>
											<button type="button"
												onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?pageIndex=1&searchSelect=idx&search=${info.idx}&label=-'"
												class="btn btn-primary">출금내역</button>
										</c:if>
										<c:if test="${project.krwDeposit eq true}">
											<button type="button"
												onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/trade/kWithdrawalList.do?pageIndex=1&kind=d&stat=0<c:if test="${info.istest eq 1}">&test=test</c:if>&searchSelect=idx&search=${info.idx}'"
												class="btn btn-primary">입금내역(한화)</button>
											<button type="button"
												onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/trade/kWithdrawalList.do?pageIndex=1&kind=w&stat=0<c:if test="${info.istest eq 1}">&test=test</c:if>&searchSelect=idx&search=${info.idx}'"
												class="btn btn-primary">출금내역(한화)</button>
										</c:if>
										<button type="button"
											onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/contact/contactList.do?searchSelect=m.phone&search=${info.phone}'"
											class="btn btn-primary">문의내역</button>
									</div>
									<div class="row">
										<div class="col-lg-4">
											<div class="form-group">
												<label>이름</label>
												<div class="form-group input-group">
													<input type="text" value="${info.name}" name="name"
														class="form-control" id="name"> <span
														class="input-group-btn">
														<button type="button"
															onclick="javascript:updateInfo('name')"
															class="btn btn-primary">변경</button>
													</span>
												</div>
											</div>
										</div>
										<div class="col-lg-2">
											<div class="form-group">
												<label>고유 초대 코드</label>
												<div class="form-group input-group">
													<input type="text" value="${info.inviteCode}"
														name="inviteCode" class="form-control" id="inviteCode">
													<span class="input-group-btn">
														<button type="button"
															onclick="javascript:updateInfo('inviteCode')"
															class="btn btn-primary">변경</button>
													</span>
												</div>
											</div>
										</div>
										<div class="col-lg-2">											
											<div class="form-group">
												<label>가입 날짜</label>												
												<pre>&nbsp;<fmt:formatDate value="${info.joinDate}" pattern="yyyy-MM-dd HH:mm" /></pre>
											</div>
										</div>
										<c:if test="${project.kyc eq true}">
											<div class="col-lg-4">
												<div class="form-group">
													<label>상태</label>
													<div class="form-group input-group">
														<c:if test="${info.confirm eq true}"> <c:set var="kycValue" value="승인"/> </c:if>
														<c:if test="${info.confirm ne true}"> <c:set var="kycValue" value="미승인"/> </c:if> 
														<c:if test="${info.fkey eq null}"> <c:set var="kycConfirm" value="(미등록)"/> </c:if>
														<c:if test="${info.fkey ne null}"> <c:set var="kycConfirm" value="(등록)"/> </c:if>
														<input class="form-control" value="${kycValue}${kycConfirm}" readonly />
														<c:if test="${info.fkey ne null}">
															<span class="input-group-btn">
																<button type="button" onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/kycInfo.do?idx=${info.idx}'" class="btn btn-info">확인</button>
															</span>
														</c:if>
														<span class="input-group-btn">
															<button type="button" class="btn btn-primary" onclick="kycConfirm(${info.idx} , true)">승인</button>
														</span>
														<span class="input-group-btn">
		                                            		<button type="button" class="btn btn-danger" onclick="kycConfirm(${info.idx} , false)">미승인</button>
														</span>
														<span class="input-group-btn">
		                                            		<button type="button" class="btn btn-warning" onclick="kycConfirm(${info.idx} , 2)">미승인(메세지)</button>
														</span>
													</div>
												</div>
											</div>
										</c:if>
										<c:if test="${project.kyc eq false}">
											<div class="col-lg-4">
												<div class="form-group">
													<label>상태</label>
													<div class="form-group input-group">
														<input class="form-control"
															value="<c:if test="${info.jstat == 0}">가입대기</c:if><c:if test="${info.jstat == 1}">승인</c:if><c:if test="${info.jstat == 2}">취소</c:if>"
															readonly />
														<c:if test="${info.jstat == 0}">
															<span class="input-group-btn">
																<button type="button"
																	onclick="changeJstat(${info.idx} , 1)"
																	class="btn btn-info">승인</button>
															</span>
															<span class="input-group-btn">
																<button type="button"
																	onclick="changeJstat(${info.idx} , 2)"
																	class="btn btn-danger">취소</button>
															</span>
														</c:if>
														<c:if test="${info.jstat == 1}">
															<span class="input-group-btn">
																<button type="button"
																	onclick="changeJstat(${info.idx} , 0)"
																	class="btn btn-warning">대기</button>
															</span>
															<span class="input-group-btn">
																<button type="button"
																	onclick="changeJstat(${info.idx} , 2)"
																	class="btn btn-danger">취소</button>
															</span>
														</c:if>
														<c:if test="${info.jstat == 2}">
															<span class="input-group-btn">
																<button type="button"
																	onclick="changeJstat(${info.idx} , 0)"
																	class="btn btn-warning">대기</button>
															</span>
															<span class="input-group-btn">
																<button type="button"
																	onclick="changeJstat(${info.idx} , 1)"
																	class="btn btn-info">승인</button>
															</span>
														</c:if>
													</div>
												</div>
											</div>
										</c:if>
									</div>
									<div class="row">
										<div class="col-lg-4">
											<div class="form-group">
												<label>연락처</label>
												<c:if
													test="${project.subAdminPower eq true or adminLevel eq 1}">
													<div class="form-group input-group">
														<c:if test="${info.phone eq '-1'}">
													삭제계정
													</c:if>
														<c:if test="${info.phone ne '-1'}">
															<input type="text" value="${info.phone}" name="phone"
																class="form-control" id="phone">
															<span class="input-group-btn">
																<button type="button"
																	onclick="javascript:updateInfo('phone')"
																	class="btn btn-primary">변경</button>
															</span>
														</c:if>
													</div>
												</c:if>
												<c:if
													test="${project.subAdminPower eq false and adminLevel ne 1}">
													<c:set var="string1" value="${info.phone}" />
													<c:set var="length" value="${fn:length(string1)}" />
													<c:set var="string2"
														value="${fn:substring(string1, length -4, length)}" />
													<pre>&nbsp;<span id="phone">010****${string2}</span></pre>
												</c:if>
											</div>
										</div>
										<div class="col-lg-4">
											<div class="form-group">
												<label>아이디</label>
												<div class="form-group input-group">
													<input type="text" value="${info.id}" name="id"
														class="form-control" id="id"> <span
														class="input-group-btn">
														<button type="button"
															onclick="javascript:updateInfo('id')"
															class="btn btn-primary">변경</button>
													</span>
												</div>
											</div>
										</div>
										<div class="col-lg-4">
											<div class="form-group">
												<label>비밀번호</label>
												<div class="form-group input-group">
													<input type="text" value="${info.pw}" name="pw"
														class="form-control" id="pw"> <span
														class="input-group-btn">
														<button type="button"
															onclick="javascript:updateInfo('pw')"
															class="btn btn-primary">변경</button>
													</span>
												</div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-lg-2">											
											<div class="form-group">
												<label>UID</label>												
												<pre>&nbsp;${info.idx}</pre>
											</div>
										</div>
										<div class="col-lg-4">
											<div class="form-group">
												<label>이메일 <c:if test="${info.emailconfirm eq 1}">(인증완료)</c:if>
													<c:if test="${info.emailconfirm ne 1}">(미인증)</c:if>
												</label> <a target="_blank"
													href="/global/0nI0lMy6jAzAFRVe0DqLOw/trade/emailList.do?idx=${info.idx }">변경기록</a>
												<c:if
													test="${project.subAdminPower eq false and adminLevel ne 1}">
													<div class="form-group">
														<input type="text" value="${info.email}" name="email"
															class="form-control" id="email" readonly>
													</div>
												</c:if>
												<c:if
													test="${project.subAdminPower eq true or adminLevel eq 1}">
													<div class="form-group input-group">
														<input type="text" value="${info.email}" name="email"
															class="form-control" id="email"> <span
															class="input-group-btn">
															<button type="button"
																onclick="javascript:updateInfo('email')"
																class="btn btn-primary">변경</button>
														</span>
													</div>
												</c:if>
											</div>
										</div>
										<div class="col-lg-6">
											<label>수수료 비율 변경 ( 0~${project.chongMaxRate}% ) 유저는
												의미없고 총판인 경우만 의미 있음( 하위 총판에게 내려주는 수수료 비율임)</label>
											<div class="form-group input-group">

												<c:if test="${info.level eq 'user'}">
												유저의 수수료 비율 변경 선택 없음, 총판만 변경 가능
												</c:if>
												<c:if test="${info.level eq 'chong'}">
													<input name="commissionRate" id="commissionRate"
														class="form-control" placeholder="숫자만 입력"
														value="${info.commissionRate}" onkeyup="SetNum(this);" />

													<span class="input-group-btn">
														<button type="button"
															onclick="javascript:updateCommissionRate(${info.idx})"
															class="btn btn-danger">수정</button>
													</span>
												</c:if>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-lg-6">
											<div class="form-group">
												<label>보유 포인트</label> <span style="color: red">*포인트
													충전시 20초 후 갱신되니 새로고침 후 확인하세요</span>
												<pre>&nbsp;<fmt:formatNumber value="${info.wallet}" pattern="#,###.########" /></pre>
											</div>
										</div>
										<div class="col-lg-6">
											<c:if
												test="${project.subAdminPower eq true or adminLevel eq 1}">
												<label>포인트 추가 / 회수</label>
												<div class="form-group input-group">
													<span class="input-group-btn">
														<button type="button"
															onclick="javascript:updatePoint(${info.idx},'+')"
															class="btn btn-primary">추가</button>
													</span> <input name="point" class="form-control"
														placeholder="숫자만 입력" id="point" onkeyup="SetNum(this);" />
													<span class="input-group-btn">
														<button type="button"
															onclick="javascript:updatePoint(${info.idx},'-')"
															class="btn btn-danger">회수</button>
													</span>
												</div>
											</c:if>
										</div>
									</div>
									<div class="row">
										<div class="col-lg-6">
											<c:if
												test="${project.krCode eq true and info.parentsIdx eq '-1'}">
												<label>한글 레퍼럴 계정</label>
												<div class="form-group input-group">
													<span class="input-group-btn">
														<button type="button"
															onclick="javascript:setKrCode(${info.idx})"
															class="btn btn-primary">변경</button>
													</span> <input name="point" class="form-control"
														value="${info.isKrCode}" id="krCode" readonly />
												</div>
											</c:if>
										</div>
										<div class="col-lg-6">
											<%--<c:if test="${project.name ne 'graphttok'}"> --%>
											<c:if
												test="${project.subAdminPower eq true or adminLevel eq 1}">
												<label>USDT 입금</label>
												<div class="form-group input-group">
													<span class="input-group-btn">
														<button type="button"
															onclick="javascript:depositUSDT(${info.idx})"
															class="btn btn-primary">입금</button>
													</span> <input name="point" class="form-control"
														placeholder="숫자만 입력" id="depoUSDT" onkeyup="SetNum(this);" />
												</div>
											</c:if>
											<%--</c:if> --%>
										</div>
									</div>

									<div class="row">
										<div class="col-lg-8">
											<div class="form-group">
												<label>회원 메모</label>
												<div class="form-group input-group">
													<input name="memo" class="form-control" placeholder="없음"
														id="memo" value="${info.memo}" /> <span
														class="input-group-btn">
														<button type="button"
															onclick="javascript:updateInfo('memo')"
															class="btn btn-primary">저장</button>
													</span>
												</div>
											</div>
										</div>
										<div class="col-lg-2">
											<div class="form-group">
												<label>색상 지정
													<span style="background-color: yellow; border: solid;" onclick="setColor('#FFFF00')">&ensp;&ensp;</span> 
													<span style="background-color: #FFA200; border: solid;" onclick="setColor('#FFA200')">&ensp;&ensp;</span> 
													<span style="background-color: #D9534F; border: solid;" onclick="setColor('#D9534F')">&ensp;&ensp;</span> 
													<span style="background-color: #cb44f7; border: solid;" onclick="setColor('#cb44f7')">&ensp;&ensp;</span> 
													<span style="background-color: #69a0f3; border: solid;" onclick="setColor('#69a0f3')">&ensp;&ensp;</span>
												</label>
												<div class="form-group input-group">
													<c:if test="${info.color eq null}">
														<input type="color" name="color" value="#ffffff"
															class="form-control" id="color" />
													</c:if>
													<c:if test="${info.color ne null}">
														<input type="color" name="color" value="${info.color}"
															class="form-control" id="color" />
													</c:if>
													<span class="input-group-btn">
														<button type="button"
															onclick="javascript:updateInfo('color')"
															class="btn btn-primary">저장</button>
													</span>
												</div>
											</div>
										</div>
										<div class="col-lg-2">
											<label>테스트계정 여부</label>
											<div class="form-group">
												<input type="hidden" name="test" id="test"
													value="${info.istest}">
												<c:if test="${info.istest eq 0}">
													<input class="form-control" value="정상 계정" readonly />
												</c:if>
												<c:if test="${info.istest eq 1}">
													<input class="form-control" value="테스트 계정" readonly />
												</c:if>
												<!-- <span class="input-group-btn">
													<button type="button" onclick="javascript:updateInfo('test')" class="btn btn-warning">전환</button>
												</span> -->
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-lg-3">
											<div class="form-group">
												<label> 
													<a href="https://etherscan.io/token/${pinfo.ercAddress}" target="_blank"> 상위 총판의 ETH 지갑 주소 </a>
												</label>
												<pre>&nbsp;<c:if test="${pinfo eq null}">상위 총판이 없습니다.</c:if>${pinfo.ercAddress}</pre>
											</div>
										</div>
										<div class="col-lg-3">
											<div class="form-group">
												<label> <a
													href="https://www.blockchain.com/btc/address/${pinfo.btcAddress}"
													target="_blank"> 상위 총판의 BTC 지갑 주소 </a>
												</label>
												<pre>&nbsp;<c:if test="${pinfo eq null}">상위 총판이 없습니다.</c:if>${pinfo.btcAddress}</pre>
											</div>
										</div>
										<div class="col-lg-3">
											<div class="form-group">
												<label> <a
													href="https://xrpscan.com/account/${xrpAccount.xrpAddress}"
													target="_blank"> 상위 총판의 XRP 지갑 주소 </a>
												</label>
												<pre>&nbsp;${xrpAccount.xrpAddress}</pre>
											</div>
										</div>
										<div class="col-lg-3">
											<div class="form-group">
												<label> <a
													href="https://tronscan.org/#/address/${pinfo.trxAddress}"
													target="_blank"> 상위 총판의 TRX 지갑 주소 </a>
												</label>
												<pre>&nbsp;<c:if test="${pinfo eq null}">상위 총판이 없습니다.</c:if>${pinfo.trxAddress}</pre>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-lg-3">
											<div class="form-group">
												<label> <a
													href="https://etherscan.io/token/${info.ercAddress}"
													target="_blank"> 해당 회원의 ETH 지갑 주소 </a>
												</label>
												<c:set var="placeholder" value="" />
												<c:if test="${info.ercAddress eq null}">
													<c:set var="placeholder" value="지갑 주소가 없습니다." />
												</c:if>
												<div class="form-group input-group">
													<input type="text" class="form-control" name="ercAddress"
														id="ercAddress" value="${info.ercAddress}"
														placeholder="${placeholder}"> <span
														class="input-group-btn">
														<button type="button"
															onclick="javascript:updateInfo('ercAddress')"
															class="btn btn-primary">변경</button>
													</span>
												</div>
											</div>
										</div>
										<div class="col-lg-3">
											<div class="form-group">
												<label> <a
													href="https://www.blockchain.com/btc/address/${info.btcAddress}"
													target="_blank"> 해당 회원의 BTC 지갑 주소 </a>
												</label>
												<c:set var="placeholder" value="" />
												<c:if test="${info.btcAddress eq null}">
													<c:set var="placeholder" value="지갑 주소가 없습니다." />
												</c:if>
												<div class="form-group input-group">
													<input type="text" class="form-control" name="btcAddress"
														id="btcAddress" value="${info.btcAddress}"
														placeholder="${placeholder}"> <span
														class="input-group-btn">
														<button type="button"
															onclick="javascript:updateInfo('btcAddress')"
															class="btn btn-primary">변경</button>
													</span>
												</div>
											</div>
										</div>
										<div class="col-lg-3">
											<div class="form-group">
												<label> 
<%-- 													<a href="/global/0nI0lMy6jAzAFRVe0DqLOw/account/realBalanceLog.do?coinname=XRP&kind=1&useridx=${info.idx}" target="_blank"></a> --%>
													해당 회원의 XRP Destination Tag 
												</label>
												<pre>&nbsp;${info.destinationTag}</pre>
											</div>
										</div>
										<div class="col-lg-3">
											<div class="form-group">
												<label> <a
													href="https://tronscan.org/#/address/${info.trxAddress}"
													target="_blank"> 해당 회원의 TRX 지갑 주소 </a>
												</label>
												<c:set var="placeholder" value="" />
												<c:if test="${info.trxAddress eq null}">
													<c:set var="placeholder" value="지갑 주소가 없습니다." />
												</c:if>
												<div class="form-group input-group">
													<input type="text" class="form-control" name="trxAddress"
														id="trxAddress" value="${info.trxAddress}"
														placeholder="${placeholder}"> <span
														class="input-group-btn">
														<button type="button"
															onclick="javascript:updateInfo('trxAddress')"
															class="btn btn-primary">변경</button>
													</span>
												</div>
											</div>
										</div>
									</div>
									<c:if
										test="${project.coinDeposit eq true or project.inverse eq true}">
										<div class="row">
											<c:forEach var="item" items="${coinWallet}"
												varStatus="status">
												<div class="col-lg-2">
													<div class="form-group">
														<label> ${fn:toUpperCase(item.key)} Balance <c:if
																test="${status.index eq 0}">
																<a
																	href="/global/0nI0lMy6jAzAFRVe0DqLOw/account/totalLog.do?userIdx=${info.idx}"
																	target="_blank">Total Log</a>
															</c:if>
														</label>
														<pre>&nbsp;<fmt:formatNumber value="${item.value}" pattern="#,###.########" />${fn:toUpperCase(item.key)}</pre>
													</div>
												</div>
											</c:forEach>
										</div>
									</c:if>
									<div class="row">
										<c:if test="${info.level eq 'user'}">
											<div class="col-lg-2">
												<label>총판 변경</label>
												<div class="form-group">
													<select class="form-control selectpicker bootselectlist" onchange="parentChange(this.value)" data-live-search="true" name="ch_parents" id="ch_parents">
														<c:if test='${info.parentsIdx eq -1}'>
															<option value="-1" selected>없음</option>
														</c:if>
														<c:forEach var="item" items="${chongs}">
															<option value="${item.userIdx}" <c:if test='${info.parentsIdx eq item.userIdx}'>selected</c:if>>${item.name}( ${item.inviteCode } )</option>
														</c:forEach>
													</select>
												</div>
											</div>
										</c:if>
										<div class="col-lg-2">
											<label>등급</label>
											<div class="form-group input-group">
												<input class="form-control"
													value="<c:if test="${info.level ne 'chong'}">user</c:if><c:if test="${info.level eq 'chong'}">총판</c:if>"
													readonly />
												<c:if test="${info.level ne 'chong'}">
													<span class="input-group-btn">
														<button type="button"
															onclick="javascript:updateLevel(${info.idx}, 'chong')"
															class="btn btn-primary">승급처리</button>
													</span>
												</c:if>
											</div>
										</div>
										<c:if test="${info.phone ne '-1'}">
											<div class="col-lg-2">
												<label>유저 삭제</label>
												<div class="form-group input-group">
													<input class="form-control" value="${info.name}" readonly />
													<span class="input-group-btn">
														<button type="button"
															onclick="javascript:memberDelete(${info.idx})"
															class="btn btn-danger">삭제</button>
													</span>
												</div>
											</div>
										</c:if>
										<div class="col-lg-3">
											<label>마지막 접속 IP ${info.lastLogin}</label>
											<c:if test="${info.lastestIp ne null}">
												<div class="form-group input-group">
													<input id="ip" name="ip" class="form-control"
														placeholder="없음" value="${info.lastestIp}" readonly /> <span
														class="input-group-btn"> <c:if
															test="${info.lastestIp eq info.banIp}">
															<button type="button"
																onclick="javascript:releaseBan(${info.idx})"
																class="btn btn-primary">차단 해제</button>
														</c:if> <c:if test="${info.lastestIp ne info.banIp}">
															<button type="button"
																onclick="javascript:ipBan(${info.idx})"
																class="btn btn-danger">차단</button>
														</c:if>
													</span>
												</div>
											</c:if>
											<c:if test="${info.lastestIp eq null}">
												<div class="form-group">
													<input id="ip" name="ip" class="form-control"
														placeholder="없음" value="${info.lastestIp}" readonly />
												</div>
											</c:if>
										</div>
										<div class="col-lg-2">
											<label>유저 차단</label>
											<c:if test="${info.isban ne null}">
												<div class="form-group input-group">
													<input class="form-control" value="차단" readonly /> <span
														class="input-group-btn">
														<button type="button"
															onclick="javascript:releaseUserBan(${info.idx})"
															class="btn btn-primary">차단 해제</button>
													</span>
												</div>
											</c:if>
											<c:if test="${info.isban eq null}">
												<div class="form-group input-group">
													<input class="form-control" value="정상" readonly /> <span
														class="input-group-btn">
														<button type="button"
															onclick="javascript:userBan(${info.idx})"
															class="btn btn-danger">차단</button>
													</span>
												</div>
											</c:if>
										</div>
									</div>
									<div class="row">
										<div class="col-lg-12">
											<div class="row">
												<div class="col-lg-6">
													<div class="form-group">
														<label>상위</label>
														<pre><c:forEach var="item" items="${parents}" varStatus="i"><a href="/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.userIdx}">${item.name}(${item.level})</a><- </c:forEach>${info.name}(${info.level })</pre>
													</div>
												</div>
												<div class="col-lg-2">
													<div class="form-group">
														<label>주의회원 여부</label>
														<c:if test="${info.danger == 0}">
															<pre>일반회원</pre>
														</c:if>
														<c:if test="${info.danger == 1}">
															<pre style="font-weight: 600">주의회원</pre>
														</c:if>
													</div>
												</div>
												<div class="col-lg-4">
													<label>주의회원 금액</label>
													<div class="form-group input-group">
														<input class="form-control" id="dmoney"
															onkeyup="SetNum(this);" value="${info.dmoney}" />
														<c:if test="${info.danger == 0}">
															<span class="input-group-btn">
																<button type="button"
																	onclick="javascript:userDanger(${info.idx} , 1)"
																	class="btn btn-danger">주의회원설정</button>
															</span>
														</c:if>
														<c:if test="${info.danger == 1}">
															<span class="input-group-btn">
																<button type="button"
																	onclick="javascript:userDanger(${info.idx} , 0)"
																	class="btn btn-warning">일반회원설정</button>
															</span>
														</c:if>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-lg-2">
											<label>예금주</label>
											<div class="form-group input-group">
												<input type="text" value="${info.mname}" name="mname"
													class="form-control" id="mname"> <span
													class="input-group-btn">
													<button type="button"
														onclick="javascript:updateInfo('mname')"
														class="btn btn-primary">변경</button>
												</span>
											</div>
										</div>
										<div class="col-lg-4">
											<div class="form-group">
												<label>계좌 정보 : ${info.mbank} / ${info.maccount}</label>
												<div class="form-group input-group">
													<span class="input-group-btn"> <select id="mbank"
														name="mbank" class="form-control" id="mbank"
														style="width: fit-content;">
															<option value="">은행을 선택해주세요</option>
															<option value="경남은행"
																<c:if test="${info.mbank eq '경남은행'}">selected</c:if>>경남은행</option>
															<option value="광주은행"
																<c:if test="${info.mbank eq '광주은행'}">selected</c:if>>광주은행</option>
															<option value="국민은행"
																<c:if test="${info.mbank eq '국민은행'}">selected</c:if>>국민은행</option>
															<option value="기업은행"
																<c:if test="${info.mbank eq '기업은행'}">selected</c:if>>기업은행</option>
															<option value="농협중앙회"
																<c:if test="${info.mbank eq '농협중앙회'}">selected</c:if>>농협중앙회</option>
															<option value="농협회원조합"
																<c:if test="${info.mbank eq '농협회원조합'}">selected</c:if>>농협회원조합</option>
															<option value="대구은행"
																<c:if test="${info.mbank eq '대구은행'}">selected</c:if>>대구은행</option>
															<option value="도이치은행"
																<c:if test="${info.mbank eq '도이치은행'}">selected</c:if>>도이치은행</option>
															<option value="부산은행"
																<c:if test="${info.mbank eq '부산은행'}">selected</c:if>>부산은행</option>
															<option value="산업은행"
																<c:if test="${info.mbank eq '산업은행'}">selected</c:if>>산업은행</option>
															<option value="새마을금고"
																<c:if test="${info.mbank eq '새마을금고'}">selected</c:if>>새마을금고</option>
															<option value="수협중앙회"
																<c:if test="${info.mbank eq '수협중앙회'}">selected</c:if>>수협중앙회</option>
															<option value="신한은행"
																<c:if test="${info.mbank eq '신한은행'}">selected</c:if>>신한은행</option>
															<option value="신협중앙회"
																<c:if test="${info.mbank eq '신협중앙회'}">selected</c:if>>신협중앙회</option>
															<option value="외환은행"
																<c:if test="${info.mbank eq '외환은행'}">selected</c:if>>외환은행</option>
															<option value="우리은행"
																<c:if test="${info.mbank eq '우리은행'}">selected</c:if>>우리은행</option>
															<option value="우체국"
																<c:if test="${info.mbank eq '우체국'}">selected</c:if>>우체국</option>
															<option value="전북은행"
																<c:if test="${info.mbank eq '전북은행'}">selected</c:if>>전북은행</option>
															<option value="제주은행"
																<c:if test="${info.mbank eq '제주은행'}">selected</c:if>>제주은행</option>
															<option value="카카오뱅크"
																<c:if test="${info.mbank eq '카카오뱅크'}">selected</c:if>>카카오뱅크</option>
															<option value="케이뱅크"
																<c:if test="${info.mbank eq '케이뱅크'}">selected</c:if>>케이뱅크</option>
															<option value="하나은행"
																<c:if test="${info.mbank eq '하나은행'}">selected</c:if>>하나은행</option>
															<option value="한국씨티은행"
																<c:if test="${info.mbank eq '한국씨티은행'}">selected</c:if>>한국씨티은행</option>
															<option value="HSBC은행"
																<c:if test="${info.mbank eq 'HSBC은행'}">selected</c:if>>HSBC은행</option>
															<option value="SC제일은행"
																<c:if test="${info.mbank eq 'SC제일은행'}">selected</c:if>>SC제일은행</option>
													</select>
													</span> <input type="text" value="${info.maccount}"
														name="maccount" onkeyup="SetNum(this);"
														class="form-control" id="maccount"> <span
														class="input-group-btn">
														<button type="button"
															onclick="javascript:updateInfo('maccount')"
															class="btn btn-primary">변경</button>
													</span>
												</div>
											</div>
										</div>
										<c:if test="${project.vAccount eq true}">
											<div class="col-lg-6">
												<div class="form-group">
													<label>가상 계좌 정보 : ${info.vBank} / ${info.vAccount}</label>
													
													<div class="form-group input-group">
														<span class="input-group-btn"> 
															<select id="vBank" name="vBank" class="form-control" id="vBank" style="width: fit-content;">
																<option value="">은행을 선택해주세요</option>
																<option value="경남은행"
																	<c:if test="${info.vBank eq '경남은행'}">selected</c:if>>경남은행</option>
																<option value="광주은행"
																	<c:if test="${info.vBank eq '광주은행'}">selected</c:if>>광주은행</option>
																<option value="국민은행"
																	<c:if test="${info.vBank eq '국민은행'}">selected</c:if>>국민은행</option>
																<option value="기업은행"
																	<c:if test="${info.vBank eq '기업은행'}">selected</c:if>>기업은행</option>
																<option value="농협중앙회"
																	<c:if test="${info.vBank eq '농협중앙회'}">selected</c:if>>농협중앙회</option>
																<option value="농협회원조합"
																	<c:if test="${info.vBank eq '농협회원조합'}">selected</c:if>>농협회원조합</option>
																<option value="대구은행"
																	<c:if test="${info.vBank eq '대구은행'}">selected</c:if>>대구은행</option>
																<option value="도이치은행"
																	<c:if test="${info.vBank eq '도이치은행'}">selected</c:if>>도이치은행</option>
																<option value="부산은행"
																	<c:if test="${info.vBank eq '부산은행'}">selected</c:if>>부산은행</option>
																<option value="산업은행"
																	<c:if test="${info.vBank eq '산업은행'}">selected</c:if>>산업은행</option>
																<option value="새마을금고"
																	<c:if test="${info.vBank eq '새마을금고'}">selected</c:if>>새마을금고</option>
																<option value="수협중앙회"
																	<c:if test="${info.vBank eq '수협중앙회'}">selected</c:if>>수협중앙회</option>
																<option value="신한은행"
																	<c:if test="${info.vBank eq '신한은행'}">selected</c:if>>신한은행</option>
																<option value="신협중앙회"
																	<c:if test="${info.vBank eq '신협중앙회'}">selected</c:if>>신협중앙회</option>
																<option value="외환은행"
																	<c:if test="${info.vBank eq '외환은행'}">selected</c:if>>외환은행</option>
																<option value="우리은행"
																	<c:if test="${info.vBank eq '우리은행'}">selected</c:if>>우리은행</option>
																<option value="우체국"
																	<c:if test="${info.vBank eq '우체국'}">selected</c:if>>우체국</option>
																<option value="전북은행"
																	<c:if test="${info.vBank eq '전북은행'}">selected</c:if>>전북은행</option>
																<option value="제주은행"
																	<c:if test="${info.vBank eq '제주은행'}">selected</c:if>>제주은행</option>
																<option value="카카오뱅크"
																	<c:if test="${info.vBank eq '카카오뱅크'}">selected</c:if>>카카오뱅크</option>
																<option value="케이뱅크"
																	<c:if test="${info.vBank eq '케이뱅크'}">selected</c:if>>케이뱅크</option>
																<option value="하나은행"
																	<c:if test="${info.vBank eq '하나은행'}">selected</c:if>>하나은행</option>
																<option value="한국씨티은행"
																	<c:if test="${info.vBank eq '한국씨티은행'}">selected</c:if>>한국씨티은행</option>
																<option value="HSBC은행"
																	<c:if test="${info.vBank eq 'HSBC은행'}">selected</c:if>>HSBC은행</option>
																<option value="SC제일은행"
																	<c:if test="${info.vBank eq 'SC제일은행'}">selected</c:if>>SC제일은행</option>
															</select>
														</span> 
														<input type="text" value="${info.vAccount}" name="vAccount" onkeyup="SetNum(this);" class="form-control" id="vAccount"> 
														<span class="input-group-btn">
															<button type="button" onclick="javascript:updateInfo('vAccount')" class="btn btn-primary">변경</button>
														</span>
													</div>
													
													<c:if test="${info.vConfirm eq true}">
														<div class="form-group input-group">
															<input class="form-control" value="승인" readonly /> 
															<span class="input-group-btn">
																<button type="button" onclick="javascript:vConfirm(${info.idx},0)" class="btn btn-danger">승인 해제</button>
															</span>
														</div>
													</c:if>
													<c:if test="${info.vConfirm eq false}">
														<div class="form-group input-group">
															<input class="form-control" value="미승인" readonly /> 
															<span class="input-group-btn">
																<button type="button" onclick="javascript:vConfirm(${info.idx},1)" class="btn btn-primary">승인</button>
															</span>
														</div>
													</c:if>
												</div>
											</div>
										</c:if>
									</div>
									<div class="row">
										<div class="col-lg-12">
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>수수료 설명</label>
														<textarea class="form-control" style="height: 200px"
															readonly>
	최상위가 아닌 하위 총판은 본인의 rate 아래로만 하위에 분배가 가능.
	하위총판을 둔 총판은 본인의 분배율에서 하위총판에게 내린 분배금을 뺀 액수를 분배.
	
	총1 <- 총2(40%) <- 총3(20%) <- 총4(10%) <- 유저 거래 
	
	이경우 (예시)
	총4 = 본인 10%
	총3 = 본인 20% - 하위총4 분배 10% = 10%
	총2 = 본인 40% - 총3 20% = 20%
	총1 = 본인 60% - 총2 40% = 20%
													
														</textarea>
													</div>
													<div class="col-lg-4">
														<div class="form-group">
															<label>트레이더 문구 변경</label>
															<div class="form-group input-group">
																<input type="text" class="form-control" name="tintro"
																	id="tintro" value="${traderInfo.tintro }"> <span
																	class="input-group-btn">
																	<button type="button"
																		onclick="javascript:updateInfo('tintro')"
																		class="btn btn-primary">변경</button>
																</span>
															</div>
															<c:if test="${traderInfo.timg ne null}">
																<pre><img src="/filePath/global/photo/${traderInfo.timg}" loading="lazy"><br>${traderInfo.timg}</pre>
															</c:if>
															<input type="file" name="timg" id="timg" accept="image/*" />
															<span class="input-group-btn"><button
																	type="button" onclick="javascript:updateInfo('timg')"
																	class="btn btn-primary">변경</button></span>
														</div>
													</div>

												</div>
											</div>
										</div>
								</form>
							</div>
						</div>
					</div>
				</div>
				<button type="button" onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userList.do'" class="btn btn btn-secondary">
					목록
				</button>
				<br /> <br />
			</div>
		</div>
		<br /> <br />
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
	<script>
	function SetNum(obj){
		val=obj.value;
		re=/[^0-9]/gi;
		obj.value=val.replace(re,"");
	}
	function userDanger(idx , danger){
		let txt = '주의회원으로 변경하시겠습니까?';
		if(danger == 0) txt = '일반회원으로 변경하시겠습니까? \n변경 시 금액은 0원으로 같이 변경됩니다.';
		if(confirm(txt)){
			let data = {'idx':idx , 'dmoney' :$("#dmoney").val() , 'danger' : danger};
			$.ajax({
				type :'post',
				url : '/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDanger.do',
				data : data ,
				success:function(data){
					alert(data.msg);
					if(data.result == 'success'){
						location.reload();
					}
				}
			})
		}
	}
	function change(type , kind ,self){
		$.ajax({
			type:'post',
			data:{"type" : type , "kind" :kind , "changeIdx" : self.value},
			url:'/global/0nI0lMy6jAzAFRVe0DqLOw/user/changeLevelOption.do',
			success:function(data){
				let text = '<option value="0">-</option>';
				for(var i=1; i< $("[id*=ch_]").index(self); i++){
					$("[id*=ch_]").eq(i).html(text);
				}
				for(var i=0; i<data.list.length; i++){
					text += '<option value="'+data.list[i].idx+'">'+data.list[i].name+' ('+data.list[i].level+')</option>';
				}
				$("#ch_"+kind).html(text);
				$("[id*=ch_]").selectpicker('refresh');
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
	var prev = "";
	var regexp = /^\d*(\.\d{0,8})?$/;
	function SetNum(obj){
	    if(obj.value.search(regexp)==-1) {
	        obj.value = prev;
	    }else {
	        prev = obj.value;
	    }
	}
	function updateLevel(idx, level){
			$.ajax({
				type:'post',
				data:{"idx" : idx, "level" : level},
				url:'/global/0nI0lMy6jAzAFRVe0DqLOw/user/updateLevel.do',
				dataType:'json',
				success:function(data){
					alert(data.msg);
					if(data.result == 'success'){
						location.reload();
					}
				},
				error:function(e){
					console.log('ajax Error ' + JSON.stringify(e));
				}
			})		
	}
	function updatePoint(idx , kind){
		let point = $("#point").val();
		if(point == ''){
			alert("point를 입력해주세요");
			return false;
		}
		if(point == '0'){
			alert("point를 제대로 입력해주세요");
			return false;
		}
		$.ajax({
			type:'post',
			data:{"idx" : idx , "kind" : kind , "point" : point},
			url:'/global/0nI0lMy6jAzAFRVe0DqLOw/user/updatePoint.do',
			dataType:'json',
			success:function(data){
				alert(data.msg);
				if(data.result == 'success'){
					location.reload();
				}
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
	function depositUSDT(idx){
		let point = $("#depoUSDT").val();
		if(point == ''){
			alert("입금할 USDT를 입력해주세요");
			return false;
		}
		if(point == '0'){
			alert("입금 금액을 제대로 입력해주세요");
			return false;
		}else if(Number(point)<0){
			alert("입금액은 0보다 커야 합니다.");
			return false;
		}
			
		$.ajax({
			type:'post',
			data:{"idx" : idx , "usdt" : point},
			url:'/global/0nI0lMy6jAzAFRVe0DqLOw/user/depositUSDT.do',
			dataType:'json',
			success:function(data){
				alert(data.msg);
				if(data.result == 'success'){
					location.reload();
				}
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
	
	function updateCommissionRate(idx){
		let commissionRate = $("#commissionRate").val();
		if(commissionRate == ''){
			alert("수수료비율을  입력해주세요");
			return false;
		}
	
		$.ajax({
			type:'post',
			data:{"idx" : idx , "commissionRate" : commissionRate},
			url:'/global/0nI0lMy6jAzAFRVe0DqLOw/user/updateCommissionRate.do',
			dataType:'json',
			success:function(data){
				alert(data.msg);
				if(data.result == 'success'){
					location.reload();
				}
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})		
	}
	
	function ipBan(idx){
		let ip = $("#ip").val();
		
		$.ajax({
			type:'post',
			data:{"idx" : idx , "ip" : ip},
			url:'/global/0nI0lMy6jAzAFRVe0DqLOw/user/ipBan.do',
			dataType:'json',
			success:function(data){
				alert(data.msg);
				if(data.result == 'success'){
					location.reload();
				}
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})		
	}
	function releaseBan(idx){
		let ip = $("#ip").val();
		
		$.ajax({
			type:'post',
			data:{"idx" : idx , "ip" : ip},
			url:'/global/0nI0lMy6jAzAFRVe0DqLOw/user/releaseBan.do',
			dataType:'json',
			success:function(data){
				alert(data.msg);
				if(data.result == 'success'){
					location.reload();
				}
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})		
	}
	function userBan(idx){
		$.ajax({
			type:'post',
			data:{"idx" : idx},
			url:'/global/0nI0lMy6jAzAFRVe0DqLOw/user/userBan.do',
			dataType:'json',
			success:function(data){
				alert(data.msg);
				if(data.result == 'success'){
					location.reload();
				}
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})		
	}
	function releaseUserBan(idx){
		$.ajax({
			type:'post',
			data:{"idx" : idx},
			url:'/global/0nI0lMy6jAzAFRVe0DqLOw/user/releaseUserBan.do',
			dataType:'json',
			success:function(data){
				alert(data.msg);
				if(data.result == 'success'){
					location.reload();
				}
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})		
	}
// 	phonehide();
// 	function phonehide(){
// 		$("#phone").html(phoneString($("#phone").html()));
// 	}
// 	function phoneString(str){
// 		return str.substring(0,3)+"****"+str.substring(7,str.length);
// 	}
	
	function listChange(node,kind){
		$(".listbtn").removeClass("btn-primary");
		$(".listbtn").addClass("btn-default");
		$(node).removeClass("btn-default");
		$(node).addClass("btn-primary");
		
		$(".listtable").css("display","none");
		
		if(kind == "deposit"){
			$("#dlist").css("display","flex");
			$("#listlink").attr("href","/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?searchIdx="+"${info.idx}"+"&label=%2B"+"&username="+"${info.name}");
			$("#listlink").html("입금내역 전체보기");
		}
		else if(kind == "withdraw"){
			$("#wlist").css("display","flex");
			$("#listlink").attr("href","/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?searchIdx="+"${info.idx}"+"&label=-"+"&username="+"${info.name}");
			$("#listlink").html("출금내역 전체보기");
		}
		else if(kind == "trade"){
			$("#tlist").css("display","flex");
			$("#listlink").attr("href","/global/0nI0lMy6jAzAFRVe0DqLOw/trade/tradeList.do?searchIdx="+"${info.idx}"+"&username="+"${info.name}");
			$("#listlink").html("거래내역 전체보기");
		}
	}
	
	function updateInfo(kind){ // all - 전체변경, 혹은 하나만 변경
		if( $("#"+kind).val() == "" || $("#"+kind).val() == null){
			alert("변경할 값을 입력하세요.");
			return;
		}
		$("#kind").val(kind);
		console.log($("#kind").val());

		var data = new FormData($("#updateForm")[0]);
		$.ajax({
			type :'post',
			data : data,
			url : '/global/0nI0lMy6jAzAFRVe0DqLOw/user/updateInfo.do?kind='+$("#kind").val(),
			enctype : "multipart/form-data",
			processData : false,
			contentType : false,
			success:function(data){
				alert(data.msg);
				location.reload();
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
	
	function memberDelete(idx){ // all - 전체변경, 혹은 하나만 변경
		if(!confirm("유저가 삭제됩니다.")) return;
	
		$.ajax({
			type:'post',
			data:{"idx" : idx},
			url:'/global/0nI0lMy6jAzAFRVe0DqLOw/user/deleteUser.do',
			dataType:'json',
			success:function(data){
				alert(data.msg);
				if(data.result == 'success'){
					location.reload();
				}
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})	
	}
	
	function parentChange(parentIdx){
		if(!confirm("상위 총판을 변경합니다.")) return;
		var idx = "${info.idx}";
		$.ajax({
			type:'post',
			data:{"parentIdx" : parentIdx, "idx" : idx},
			url:'/global/0nI0lMy6jAzAFRVe0DqLOw/user/parentChange.do',
			dataType:'json',
			success:function(data){
				alert(data.msg);
				if(data.result == 'suc')
					location.reload();
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
	
	function changeJstat(idx , kind){
		if(confirm("변경하시겠습니까?")){
			$.ajax({
				type : 'get',
				url : '/global/0nI0lMy6jAzAFRVe0DqLOw/user/changeJstat.do?idx='+idx+'&jstat='+kind,
				success:function(data){
					alert(data.msg);
					location.reload();
				}
			})
		}
	}
	
	function setKrCode(idx){
		if(confirm("변경하시겠습니까?")){
			$.ajax({
				type : 'get',
				url : '/global/0nI0lMy6jAzAFRVe0DqLOw/user/setKrCode.do?idx='+idx,
				success:function(data){
					alert(data.msg);
					location.reload();
				}
			})
		}
	}
	
	function vConfirm(idx,vcf){
		if(confirm("변경하시겠습니까?")){
			$.ajax({
				type : 'get',
				url : '/global/0nI0lMy6jAzAFRVe0DqLOw/user/setVConfirm.do?idx='+idx+"&vConfirm="+vcf,
				success:function(data){
					alert(data.msg);
					location.reload();
				}
			})
		}
	}
	
	function setColor(color){
		$("#color").val(color);
	}
	
	function kycConfirm(idx , cf){
		let text="";
		if(cf == 2){
			text = prompt("메세지를 입력해 주세요.","Authorization authorization failed");
			if(text == null || text == "")
				return;
		}
		else if(!confirm("변경하시겠습니까?")) return;
		
		$.ajax({
			type : 'get',
			url : '/global/0nI0lMy6jAzAFRVe0DqLOw/user/kycConfirm.do?idx='+idx+'&confirm='+cf+"&text="+text,
			success:function(data){
				alert(data.msg);
				location.reload();
			}
		})
	}
	</script>
</body>
</html>