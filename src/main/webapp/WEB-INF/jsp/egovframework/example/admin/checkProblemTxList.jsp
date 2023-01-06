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
<body>
	<div id="wrapper">
		<jsp:include page="../adminFrame/top.jsp"></jsp:include>
		<c:import url="/admin/left.do"/>
        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                	<h1 class="page-header">위험도 순위 목록</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
						<div class="panel-heading">t_ </div>
                        <div class="panel-body">
							<div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>시간</th>
                                            <th>회원번호</th>
                                            <th>코인명</th>
                                            <th>트랜잭션</th>
                                            <th>중복숫자</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:forEach var="item" items="${plist}" varStatus="i">
                                        <tr>
                                            <td><fmt:formatDate value="${item.completionTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                            <td>${item.notadmin}</td>
                                            <td>${item.coin}</td>
                                            <td>
                                            	<c:if test="${item.coin eq 'BTC'}"><a href="https://www.blockchain.com/btc/tx/${item.tx}">${item.tx}</a></c:if>
												<c:if test="${item.coin eq 'USDT'}"><a href="https://etherscan.io/tx/${item.tx}">${item.tx}</a></c:if>
												<c:if test="${item.coin eq 'TRX'}"><a href="https://tronscan.org/#/transaction/${item.tx}">${item.tx}</a></c:if>
												<c:if test="${item.coin eq 'XRP'}"><a href="https://xrpscan.com/tx/${item.tx}">${item.tx}</a></c:if>
                                            </td>
                                            <td>${item.txct}</td>
                                        </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>
<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
</body>
</html>