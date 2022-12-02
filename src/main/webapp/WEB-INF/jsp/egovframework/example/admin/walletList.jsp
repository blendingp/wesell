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
<script>
function page(pageNo){
	document.listForm.pageIndex.value = pageNo;
   	document.listForm.submit();
}
</script>
<body>
	<div id="wrapper">
		<jsp:include page="../adminFrame/top.jsp"></jsp:include>
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                	<h1 class="page-header">회원 지갑주소 관리</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
						<div class="panel-heading">member</div>
                        <div class="panel-body">
							<div class="row">
							   <form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/walletList.do" name="listForm" id="listForm">
									<input type="hidden" name="pageIndex" value="1"/>
									<input type="hidden" name="test" id="test" value="${test}"/>
									<input type="hidden" name="level" id="level" value="${level}"/>
									<div class="col-lg-4">
										<label>검색</label>
										<div class="form-group input-group">
											<select id="searchSelect" name="searchSelect" class="form-control input-sm" style="width:fit-content;height:34px;">
												<option value="name"<c:if test="${searchSelect eq 'name'}">selected</c:if>>회원명</option>
												<option value="email"<c:if test="${searchSelect eq 'email'}">selected</c:if>>이메일</option>
												<option value="inviteCode"<c:if test="${searchSelect eq 'inviteCode'}">selected</c:if>>InviteCode</option>
												<option value="inviteMem"<c:if test="${searchSelect eq 'inviteMem'}">selected</c:if>>InviteCode 직속하위</option>
												<option value="inviteMemAll"<c:if test="${searchSelect eq 'inviteMemAll'}">selected</c:if>>InviteCode 하위(전체)</option>
												<option value="idx"<c:if test="${searchSelect eq 'idx'}">selected</c:if>>UID</option>
												<option value="phone"<c:if test="${searchSelect eq 'phone'}">selected</c:if>>전화번호</option>
												<option value="destinationTag"<c:if test="${searchSelect eq 'destinationTag'}">selected</c:if>>리플 태그번호</option>
											</select>
											<input type="text" name="search" class="form-control" value="${search}" style="width:auto;"> 
											<button class="btn btn-default" style="padding: 6px 12px;" type="submit"> <i class="fa fa-search"></i> </button>
										</div>
									</div>
									<div class="col-lg-1">
										<label>테스트계정</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-danger btn-xs" style="padding: 6px 7px;" onclick="setTest('test')" type="button">미포함</button>
												<button class="btn btn-info btn-xs" style="padding: 6px 7px;" onclick="setTest('')" type="button">포함</button>
											</span>
										</div>
									</div>
									<div class="col-lg-1">
										<label>구분</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-default btn-xs" style="padding: 6px 7px;" onclick="setLevel('')" type="button">전체</button>
												<button class="btn btn-info btn-xs" style="padding: 6px 7px;" onclick="setLevel('user')" type="button">유저</button>
												<button class="btn btn-success btn-xs" style="padding: 6px 7px;" onclick="setLevel('chong')" type="button">총판</button>
											</span>
										</div>
									</div>
								</form>
							</div>
							<table width="100%" class="table table-striped table-hover" id="memberTable">
								<thead>
									<tr>
										<th>UID</th>
										<th>이름 (부모)</th>
										<th>USDT 지갑 주소</th>
										<th>BTC 지갑 주소</th>
										<th>TRX 지갑 주소</th>
									</tr>
								</thead>
								<jsp:useBean id="now" class="java.util.Date" />
								<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today" />
								<tbody>
									<c:forEach var="item" items="${list}" varStatus="i">
										<tr style="background-color:${item.color}">
											<td>00${item.idx}&nbsp;</td>
											<td onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.idx}'" style="cursor:pointer;">${item.name}&nbsp;
												<c:if test="${item.parent ne null && item.parent ne ''}"> ( ${item.parent} ) </c:if>
												<c:if test="${item.istest eq 1}"> <span style="color: red">테스트 계정</span> </c:if>
												<c:if test="${item.danger == 1}"> <span style="color: red;">*주의회원*</span> </c:if>
												<fmt:formatDate value="${item.joinDate}" pattern="yyyy-MM-dd" var="joinD" />
												<c:if test="${today == joinD}"> <span style="background-color: yellow">[New]</span> </c:if>
											</td>
											<form name="updateForm${item.idx}" id="updateForm${item.idx}">
												<input type="hidden" name="idx" value="${item.idx}"/>
												<input type="hidden" name="kind" id="kind${item.idx}">
												<td onclick="event.cancelBubble = true;">
													<div class="form-group input-group">
														<input type="text" name="ercAddress" id="ercAddress${item.idx}" class="form-control" value="${item.ercAddress}"> 
														<span class="input-group-btn">
															<button onclick="updateInfo('${item.idx}', 'ercAddress')" class="btn btn-default" style="padding: 6px 12px;">변경</button>
														</span>
													</div>
												</td>
												<td onclick="event.cancelBubble = true;">
													<div class="form-group input-group">
														<input type="text" name="btcAddress" id="btcAddress${item.idx}" class="form-control" value="${item.btcAddress}"> 
														<span class="input-group-btn">
															<button onclick="updateInfo('${item.idx}', 'btcAddress')" class="btn btn-default" style="padding: 6px 12px;">변경</button>
														</span>
													</div>
												</td>
												<td onclick="event.cancelBubble = true;">
													<div class="form-group input-group">
														<input type="text" name="trxAddress" id="trxAddress${item.idx}" class="form-control" value="${item.trxAddress}"> 
														<span class="input-group-btn">
															<button onclick="updateInfo('${item.idx}', 'trxAddress')" class="btn btn-default" style="padding: 6px 12px;">변경</button>
														</span>
													</div>
												</td>
											</form>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="row">
							<div class="col-sm-12" style="text-align:center;">
								<ul class="pagination">
									<ui:pagination paginationInfo="${pi}" type="customPage" jsFunction="page"/>
								</ul>
							</div>
						</div>
                    </div>
                </div>
            </div>
        </div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
	<script>
	function setTest(val){
		$("#test").val(val);
		$("#listForm").submit();
	}
	function setLevel(val){
		$("#level").val(val);
		$("#listForm").submit();
	}
	function updateInfo(idx, kind){
		if( $("#"+kind+idx).val() == "" || $("#"+kind+idx).val() == null){
			alert("변경할 값을 입력하세요.");
			return;
		}
		$("#kind"+idx).val(kind);
		
		var data = $("#updateForm"+idx).serialize();
		$.ajax({
			type :'post',
			data : data,
			url : '/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/updateInfo.do',
			success:function(data){
				alert(data.msg);
				location.reload();
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
	</script>
</body>
</html>