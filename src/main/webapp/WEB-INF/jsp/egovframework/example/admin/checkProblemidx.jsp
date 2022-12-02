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
                	<h1 class="page-header">위험도 순위 목록</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
						<div class="panel-heading">[위험도수치]가 클수록 오류 위험이 큰 유저 입니다. 여기에 목록에 있다고 해서 꼭 오류인 것은 아닙니다. 다만  문제 가능성이 높은 것을 자동으로 걸러 주는 기능입니다.<br>
							여기 목록에 있는 유저는 오입금 된 목록이 없는지 체크해주세요. </div>
                        <div class="panel-body">
							<div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>시간</th>
                                            <th>회원번호</th>
                                            <th>회원명</th>
                                            <th>전번</th>
                                            <th>코인명</th>
                                            <th>위험도수치</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:forEach var="item" items="${plist}" varStatus="i">
                                        <tr>
                                            <td><fmt:formatDate value="${item.ctime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                            <td>${item.notadmin}</td>
                                            <td onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.notadmin}'" style="cursor:pointer;">[${item.name}]</td>
                                            <td>${item.phone}</td>
                                            <td>${item.coin}</td>
                                            <td>
                                            	<a href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/trade/checkProblemTxList.do?uidx=${item.notadmin}" target="_blank">
                                            		<font color="red">${item.act}</font>
                                            	</a>
                                            </td>
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