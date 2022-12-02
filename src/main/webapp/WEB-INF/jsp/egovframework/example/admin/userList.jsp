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
<style>
	td a {
		text-shadow: -1px 0 #fff, 0 1px #fff, 1px 0 #fff, 0 -1px #fff;
	}
</style>
</head>
<script>
function page(pageNo){
	document.listForm.pageIndex.value = pageNo;
   	checkForm(0);
}
</script>
<body id="page-top">
	<div id="wrapper">
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
        <div id="content-wrapper">
        	<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
        		<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">
	                	<c:if test="${ban eq 'ban'}"> <span style="color:red">[차단]</span> </c:if>
	                	<c:if test="${out eq 'out'}"> <span style="color:red">[삭제]</span> </c:if>
	                	<c:if test="${level eq '' or level eq null}"> 전체 회원 목록 </c:if>
	                	<c:if test="${level eq 'user'}"> 일반 회원 목록 </c:if>
	                	<c:if test="${level eq 'chong'}"> 총판 목록 </c:if>
					</h1>
		            <button type="button" class="btn btn-info" onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/createTestUser.do'" style="margin-bottom:10px;">테스트 유저/총판 생성</button>
		            <button type="button" class="btn btn-primary" onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/createChong.do'" style="margin-bottom:10px;">일반 총판 생성</button>
		            <div class="card shadow mb-4">
		                <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">member</h6>
                        </div>		                        
						<div class="card-body">
						   <form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userList.do" name="listForm" id="listForm">
						   		<input type="hidden" name="fileDown" id="fileDown" value="0" />
								<input type="hidden" name="pageIndex" value="1"/>
								<input type="hidden" name="level" id="level" value="${level}"/>
								<input type="hidden" name="partnerLevel" id="partnerLevel" value="${partnerLevel}"/>
								<input type="hidden" name="order" id="order" value="${order}"/>
								<input type="hidden" name="orderAD" id="orderAD" value="${orderAD}"/>
								<input type="hidden" name="test" id="test" value="${test}"/>
								<input type="hidden" name="out" id="out" value="${out}"/>
								<input type="hidden" name="ban" id="ban" value="${ban}"/>
								<div class="row">
									<div class="col-lg-4">										
										<label>검색</label>
										<div class="form-group input-group">
											<select id="searchSelect" name="searchSelect" class="form-control ">
												<option value="name"<c:if test="${searchSelect eq 'name'}">selected</c:if>>회원명</option>
												<option value="email"<c:if test="${searchSelect eq 'email'}">selected</c:if>>이메일</option>
												<option value="inviteCode"<c:if test="${searchSelect eq 'inviteCode'}">selected</c:if>>InviteCode</option>
												<c:if test="${level ne 'user'}">
													<option value="inviteMem"<c:if test="${searchSelect eq 'inviteMem'}">selected</c:if>>InviteCode 직속하위</option>
													<option value="inviteMemAll"<c:if test="${searchSelect eq 'inviteMemAll'}">selected</c:if>>InviteCode 하위(전체)</option>
												</c:if>
												<option value="idx"<c:if test="${searchSelect eq 'idx'}">selected</c:if>>UID</option>
												<option value="phone"<c:if test="${searchSelect eq 'phone'}">selected</c:if>>전화번호</option>
												<option value="destinationTag"<c:if test="${searchSelect eq 'destinationTag'}">selected</c:if>>리플 태그번호</option>
											</select>
											<input type="text" name="search" class="form-control" value="${search}" > 
											<button class="btn btn-default" style="padding: 6px 12px;" type="submit"> <i class="fa fa-search"></i> </button>
										</div>
									</div>						
									<div class="col-lg-2">
										<label>색상검색</label>
											<div class="form-group input-group">
												<select id="searchColor" name="searchColor" class="form-control" onchange="changeColor()">
													<option value="">전체</option>
													<c:forEach var="item" items="${colorList}">
														<option value="${item.color}" style="background:${item.color}" <c:if test="${searchColor eq item.color}">selected</c:if>>&nbsp;</option>
													</c:forEach>
													<option value="-1" <c:if test="${searchColor eq '-1'}">selected</c:if>>지정색없음</option>
												</select>
											</div>
									</div>
									<div class="col-lg-2">
										<label>테스트계정</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-danger btn-sm" style="padding: 6px 7px;" onclick="setTest('test')" type="button">미포함</button>
												<button class="btn btn-info btn-sm" style="padding: 6px 7px;" onclick="setTest('')" type="button">포함</button>
											</span>
										</div>
									</div>
									<div class="col-lg-2">
										<label>정렬</label>
										<div class="form-group input-group">
											<span class="input-group-btn">
												<button class="btn btn-info btn-sm" style="padding: 6px 7px;" onclick="setOrder('joinDate')" type="button">가입날짜</button>
												<button class="btn btn-success btn-sm" style="padding: 6px 7px;" onclick="setOrder('wallet')" type="button">포인트</button>
											</span>
										</div>
									</div>
									<div class="col-lg-1">
										<label>엑셀</label>
										<div class="form-group input-group">
											<div>
												<button type="button" onclick="checkForm(1)" class="btn btn-outline btn-success btn-sm">EXCEL</button>
											</div>
										</div>
									</div>
								</div>
							</form>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
									<thead>
										<tr>
											<th>UID</th>
											<th>이름 (부모)</th>
											<th>휴대폰</th>
											<th>이메일</th>
											<th>등급</th>
											<th>포인트</th>
											<th>가입날짜</th>
											<c:if test="${project.kyc eq true}">
												<th>KYC인증</th>
											</c:if>
											<c:if test="${project.kyc eq false}">
												<th>가입상태</th>
											</c:if>
										</tr>
									</thead>
									<jsp:useBean id="now" class="java.util.Date" />
									<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today" />
									<tbody>
										<c:forEach var="item" items="${list}" varStatus="i">
											<tr onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx=${item.idx}'" style="cursor:pointer; background-color:${item.color}">
												<td>${item.idx}&nbsp;</td>
												<td>${item.name}&nbsp;
													<c:if test="${item.parent ne null && item.parent ne ''}">
														( <a onclick="popParent('${item.parentCode}');event.cancelBubble = true;">${item.parent}</a> ) 
													</c:if>
													<c:if test="${item.istest eq 1}"> <span style="color: red">테스트 계정</span> </c:if>
													<c:if test="${item.danger == 1}"> <span style="color: red;">*주의회원*</span> </c:if>
													<fmt:formatDate value="${item.joinDate}" pattern="yyyy-MM-dd" var="joinD" />
													<c:if test="${today == joinD}"> <span style="background-color: yellow">[New]</span> </c:if>
												</td>
<%-- 												<c:if test="${project.subAdminPower eq true or adminLevel eq 1}"> --%>
												<td>
													<c:if test="${!empty item.phone}">
														<span class="hidephone">
															<c:set var="string1" value="${item.phone}" />
															<c:set var="length" value="${fn:length(string1)}" />
															<c:set var="string2" value="${fn:substring(string1, length -4, length)}" />
															${fn:substring(string1, 0, 3)}****${string2}
														</span>
													</c:if>
												</td>
<%-- 												</c:if> --%>
												<td><c:if test="${!empty item.email}">${item.email}</c:if></td>
												<td>${item.level}</td>
												<td><fmt:formatNumber value="${item.wallet}" pattern="#,###.####" /></td>
												<td><fmt:formatDate value="${item.joinDate}" pattern="yyyy-MM-dd HH:mm" /></td>
												<td>
													<c:if test="${project.kyc eq true}">
														<c:if test="${item.confirm eq true}">
															승인
														</c:if>
														<c:if test="${item.confirm ne true}">
															미승인
														</c:if>
														<c:if test="${item.fkey eq null}">
															(미등록)
														</c:if>
														<c:if test="${item.fkey ne null}">
															(등록)
															<button type="button" onclick="location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/kycInfo.do?idx=${item.idx}'" class="btn btn-info btn-sm pEventSkip">확인</button>
														</c:if>
														<button type="button" class="btn btn-primary btn-sm pEventSkip" onclick="kycConfirm(${item.idx} , true)">승인</button>
	                                            		<button type="button" class="btn btn-danger btn-sm pEventSkip" onclick="kycConfirm(${item.idx} , false)">미승인</button>
	                                            		<button type="button" class="btn btn-warning btn-sm pEventSkip" onclick="kycConfirm(${item.idx} , 2)">미승인(메세지)</button>
													</c:if>
													<c:if test="${project.kyc eq false}">
		                                            	<c:if test="${item.jstat == 0}">
		                                            		승인대기중
		                                            		<button type="button" class="btn btn-info btn-sm pEventSkip" onclick="changeJstat(${item.idx} , 1)">가입승인</button>
		                                            		<button type="button" class="btn btn-danger btn-sm pEventSkip" onclick="changeJstat(${item.idx} , 2)">가입취소</button>
		                                            	</c:if>
		                                            	<c:if test="${item.jstat == 1}">
		                                            		승인
		                                            		<button type="button" class="btn btn-warning btn-sm pEventSkip" onclick="changeJstat(${item.idx} , 0)">가입대기</button>
		                                            		<button type="button" class="btn btn-danger btn-sm pEventSkip" onclick="changeJstat(${item.idx} , 2)">가입취소</button>
		                                            	</c:if>
		                                            	<c:if test="${item.jstat == 2}">
		                                            		취소
		                                            		<button type="button" class="btn btn-warning btn-sm pEventSkip" onclick="changeJstat(${item.idx} , 0)">가입대기</button>
		                                            		<button type="button" class="btn btn-info btn-sm pEventSkip" onclick="changeJstat(${item.idx} , 1)">가입승인</button>
		                                            	</c:if>
													</c:if>
	                                            </td>
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
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
	<script>
	function popParent(parentCode){
		var width = window.screen.width/2;
		var height = window.screen.height;
		window.open('/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userList.do?searchSelect=inviteMem&search='+parentCode,'','width='+width+',height='+height+',left='+width+',location=no,status=no,scrollbars=yes');
	}
	function changeColor(){
		checkForm(0);
	}
	function setOrder(val){
		var order = $("#order").val();
		var orderAD = $("#orderAD").val();
		if(order==val){
			if(orderAD=="asc"){
				$("#orderAD").val("desc");
			}
			else{
				$("#orderAD").val("asc");
			}
		}
		else{
			$("#orderAD").val("desc");
		}
		
		$("#order").val(val);
		checkForm(0);
	}
	function setTest(val){
		$("#test").val(val);
		checkForm(0);
	}
	function setLevel(val){
		$("#level").val(val);
		checkForm(0);
	}
	function changeJstat(idx , kind){
		if(confirm("변경하시겠습니까?")){
			$.ajax({
				type : 'get',
				url : '/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/changeJstat.do?idx='+idx+'&jstat='+kind,
				success:function(data){
					alert(data.msg);
					location.reload();
				}
			})
		}
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
			url : '/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/kycConfirm.do?idx='+idx+'&confirm='+cf+"&text="+text,
			success:function(data){
				alert(data.msg);
				location.reload();
			}
		})
	}
	$('.pEventSkip').on('click', function(e){
	    e.stopPropagation();
	});
	
	function checkForm(file){
		$("#fileDown").val(file);
		$("#listForm").submit();
	}
	</script>
</body>
</html>