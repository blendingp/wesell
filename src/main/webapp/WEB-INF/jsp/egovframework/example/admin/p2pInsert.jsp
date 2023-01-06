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
<body id="page-top">
	<div id="wrapper">
		<c:import url="/admin/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">P2P 등록</h1>
					<div class="col-lg-12">
						<div class="card shadow mb-4">
							<div class="card-body">
								<form name="insertForm" id="insertForm" method="post">
									<div class="row">
										<div class="col-lg-6">
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>종류</label> <label class="radio-inline"> <input
															type="radio" name="p2pType" value="0" checked="">구매
														</label> <label class="radio-inline"> <input type="radio"
															name="p2pType" value="1">판매
														</label>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>이름</label> <input class="form-control"
															placeholder="이름" name="name" id="name" maxlength="20">
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>주문 수</label> <input class="form-control"
															placeholder="숫자로 입력" name="orders" id="orders"
															maxlength="10">
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>가격(KRW)</label> <input class="form-control"
															placeholder="숫자로 입력" name="price" id="price"
															maxlength="10">
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>판매 수량(USDT)</label> <input class="form-control"
															placeholder="숫자로 입력" name="qty" id="qty" maxlength="10">
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>최소 금액(KRW)</label> <input class="form-control"
															placeholder="숫자로 입력" name="lowLimit" id="lowLimit"
															maxlength="10">
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>최대 금액(KRW)</label> <input class="form-control"
															placeholder="숫자로 입력" name="maxLimit" id="maxLimit"
															maxlength="10">
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>평균 시간(분)</label> <input class="form-control"
															placeholder="숫자로 입력" name="aveTime" id="aveTime"
															maxlength="10">
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>은행</label> <input class="form-control"
															placeholder="은행" name="bank" id="bank" maxlength="20">
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>계좌번호</label> <input class="form-control"
															placeholder="계좌번호" name="banknum" id="banknum"
															maxlength="20">
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>예금주</label> <input class="form-control"
															placeholder="예금주" name="bankname" id="bankname"
															maxlength="20">
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-lg-12">
													<div class="form-group">
														<label>메세지</label> <input class="form-control"
															placeholder="메세지" name="msg" id="msg" maxlength="50">
													</div>
												</div>
											</div>
										</div>
									</div>
								</form>
							</div>							
						</div>	
						<button type="button" onclick="javascript:insertProcess()"
							class="btn btn btn-secondary">등록
						</button>					
					</div>					
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
	function insertProcess() {
		var data = $("#insertForm").serialize();
		var url = "/wesell/admin/p2p/p2pInsertProcess.do";
		$.ajax({
			type : 'post',
			url : url,
			data : data,
			success : function(data) {
				if (data.result == 'success') {
					alert("P2P 등록이 완료되었습니다.");
					location.reload();
				} else {
					alert(data.msg);
				}
			},
			error : function(e) {
				console.log('ajaxError' + e);
			}
		});
	}
</script>
</body>
</html>