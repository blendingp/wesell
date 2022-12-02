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
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                	<h1 class="page-header">수익로그</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
						<div class="panel-heading">
							profit log 
						</div>
						<!-- (하루 : 영국 00시 기준 - 대한민국 8시 기준) -->
                        <div class="panel-body">
							<div class="row">
							   <form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/log/profitLog.do" name="listForm" id="listForm">
									<div class="col-lg-3">
										<label>연도</label>
										<jsp:useBean id="now" class="java.util.Date" />
										<fmt:formatDate value="${now}" pattern="yyyy" var="yearStart"/>
										<div class="form-group">
											<select class="form-control">
												<c:forEach begin="0" end="${yearStart - 2020}" var="result" step="1">
												    <option value="${yearStart-result}" <c:if test="${yearStart-result == year}">selected</c:if> >${yearStart-result}년</option>
												</c:forEach>											
                                            </select> 
										</div>
									</div>
									<div class="col-lg-3">
										<label>월</label>
										<div class="form-group input-group">
											<select class="form-control" name="month">
												<c:forEach begin = "1" end="12" var="i">
													<option value="${i}" <c:if test="${i eq month}">selected</c:if>>${i}월</option>
												</c:forEach>
                                            </select> 
                                            <span class="input-group-btn">
												<button class="btn btn-default" style="padding: 6px 12px;" onclick="checkForm()" type="button">
													<i class="fa fa-search"></i>
												</button>
											</span>
										</div>
									</div>
								</form>
							</div>
							<div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>날짜</th>
                                            <th>거래 수익</th>
                                            <th>레퍼럴</th>
                                            <th>펀딩 수수료</th>
                                            <th>순수익</th>
                                        </tr>
                                    </thead>
                                    <c:set var="totP" value="0"/>
                                    <c:set var="totF" value="0"/>
                                    <c:set var="totFund" value="0"/>
                                    <c:set var="totN" value="0"/>
                                    <tbody id="postionList">
                                    	<c:forEach var="item" items="${list}">
											<tr>
												<td>${item.selectedDate}</td>
												<td><fmt:formatNumber value="${item.profitSum}" pattern="#,###.########"/></td>
												<td><fmt:formatNumber value="${item.feeSum}" pattern="#,###.########"/></td>
												<td><fmt:formatNumber value="${item.fundingSum}" pattern="#,###.########"/></td>
												<td><fmt:formatNumber value="${item.netProfit}" pattern="#,###.########"/></td>
											</tr>
											<c:set var="totP" value="${totP + item.profitSum}"/>                                    	
											<c:set var="totF" value="${totF + item.feeSum}"/>                                    	
											<c:set var="totFund" value="${totFund + item.feeSum}"/>                                    	
											<c:set var="totN" value="${totN + item.netProfit}"/>                                    	
                                    	</c:forEach>
										<tr style="background:lavender;">
											<th>총 합계</th>
											<td><fmt:formatNumber value="${totP}" pattern="#,###.########"/></td>
											<td><fmt:formatNumber value="${totF}" pattern="#,###.########"/></td>
											<td><fmt:formatNumber value="${totFund}" pattern="#,###.########"/></td>
											<td><fmt:formatNumber value="${totN}" pattern="#,###.########"/></td>
										</tr>                                    	
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
<script>
	function checkForm(){
		$("#listForm").submit();
	}
</script>
</body>
</html>