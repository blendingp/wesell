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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<body id="page-top">
	<div id="wrapper">
		<c:import url="/admin/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">contact Detail</h1>
					<div class="card shadow mb-4">						
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">give referral
								contact answer form</h6>
						</div>
						<div class="col-lg-12">
							<div class="card-body">
								<form name="updateForm" id="updateForm" method="post">
									<input type="hidden" name="idx" value="${info.idx}" /> <input
										type="hidden" name="email" value="${info.mail}" /> <input
										type="hidden" name="phone" value="${info.uphone}" /> <input
										type="hidden" name="country" value="${info.country}" />
									<div class="row">
										<div class="col-lg-6">
											<div class="form-group">
												<label>문의 제목</label>
												<pre>${info.title}</pre>
											</div>
										</div>
										<div class="col-lg-6">
											<div class="form-group">
												<label>문의 날짜</label>
												<pre><fmt:formatDate value="${info.cdate}" pattern="yyyy-MM-dd HH:mm" /></pre>
											</div>
										</div>
										<div class="col-lg-6">
											<div class="form-group">
												<label>문의자 (직속상위)</label>
												<pre><a href="/wesell/admin/user/userDetail.do?idx=${info.uidx}">${info.name}</a>(<c:if test="${info.pname eq null}">없음</c:if>${info.pname})</pre>
											</div>
										</div>
										<div class="col-lg-3">
											<div class="form-group">
												<label>문의자 휴대폰</label>
												<pre>${info.uphone}</pre>
											</div>
										</div>
										<div class="col-lg-3">		
											<div class="form-group">																			
												<label>문의자 이메일</label>
												<pre>${info.mail}</pre>
											</div>
										</div>
										<div class="col-lg-12">
											<div class="form-group">
												<label>문의 내용</label>
												<pre>${info.content}</pre>
											</div>
										</div>
										<c:if test="${fn:length(fileList) > 0}">
											<div class="col-lg-12">
												<div class="form-group">
													<label>첨부 파일 </label>
													<c:forEach var="item" items="${fileList}">
														<pre><a href="/filePath/wesell/photo/${item.saveNm}" download>${item.originNm}</a></pre>
													</c:forEach>
												</div>
											</div>
										</c:if>
										<c:if test="${info.answerYn == 'Y'}">
											<div class="col-lg-12">
												<div class="form-group">
													<label>이전 답변 내용</label>
													<pre>${info.answer}</pre>
												</div>
											</div>
										</c:if>
										<c:if test="${info.confirm != '1'}">
											<div class="col-lg-12">
												<div class="form-group">
													<label>답변 내용 작성</label>
													<c:forEach var="result" items="${systemlist}">
														<button type="button"
															onClick="javascript:getAnser(${result.bidx})"
															class="btn btn-primary btn-xs">${result.btitle}
														</button>
													</c:forEach>
													<textarea class="form-control" rows="20" name="answer" id="answer"></textarea>
												</div>
											</div>
										</c:if>
									</div>
								</form>
								<button type="button" onclick="location.href='/wesell/admin/contact/contactDelete.do?idxs=${info.idx}'" class="btn btn-danger">
									문의 삭제
								</button>
								<c:if test="${info.confirm != '1'}">
									<button type="button" onclick="javascript:sendAnswer('normal')"
										class="btn btn btn-secondary">문의저장</button>
									<button type="button" onclick="javascript:sendAnswer('mail')"
										class="btn btn btn-secondary">메일 발송</button>
									<button type="button" onclick="javascript:sendAnswerSms()"
										class="btn btn btn-secondary">문자 발송</button>
								</c:if>
							</div>													
						</div>						
					</div>				
				</div>
			</div>
			
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>	
	<div style="width:0px;height:0px; overflow:hidden;">
		<c:forEach var="result" items="${systemlist}">
			<div id="answer${result.bidx }" >${result.bcontent}</div>
		</c:forEach>		
	</div>
	<script>
	function getAnser(bidx){
		document.getElementById("answer"+bidx).innerText = document.getElementById("answer"+bidx).innerText.replaceAll(/\n\n/gi , '\n');
		$("#answer").val(document.getElementById("answer"+bidx).innerText);
	}
	function sendAnswer(type){
		var data = $("#updateForm").serialize();
		var url = "/wesell/admin/contact/contactAnswer.do";
		if(type=="mail")
			url = "/wesell/admin/contact/contactMailAnswer.do";
		console.log(url);
		$.ajax({
			type:'post',
			url : url,
			data: data,
			success:function(data){
				console.log('ajax success');
				if(data.result == 'success'){
					alert("답변  완료되었습니다.");
					location.href = '/wesell/admin/contact/contactList.do';
				}else{
					alert(data.msg);
					location.reload();
				}
			
			},
			error:function(e){
				console.log('ajax Error'+ JSON.stringify(e));
			}
		})
	}
	function sendAnswerSms(){
		var data = $("#updateForm").serialize();
		var url = "/wesell/admin/contact/contactAnswerSms.do";
		console.log(url);
		$.ajax({
			type:'post',
			url : url,
			data: data,
			success:function(data){
				console.log('ajax success');
				if(data.result == 'success'){
					alert("답변 문자 발송 완료되었습니다.");
					location.href = '/wesell/admin/contact/contactList.do';
				}else{
					alert(data.msg);
				}
			
			},
			error:function(e){
				console.log('ajax Error'+ JSON.stringify(e));
			}
		})
	}
	</script>	
</body>
</html>