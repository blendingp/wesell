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
<body>
	<div id="wrapper">
		<jsp:include page="../adminFrame/top.jsp"></jsp:include>
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
		<div id="page-wrapper">
			<div class="row">
				<div class="col-lg-12">
						<h1 class="page-header">꼬리물기 설정</h1>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-heading">
							꼬리물기 설정
						</div>
						<div class="panel-body">
							<c:forEach var="coin" items="${coinList}">
								<div class="row">									
									<div class="col-lg-4">
										<div class="form-group">
											<label>${coin.coinName} / 변동값 ${coin.tailPrice} / 변동확률 ${coin.tailRate}%</label>
											
											<div class="form-group input-group">
												<input id="tailPrice${coin.coinNum}" class="form-control" value="${coin.tailPrice}" onInput="setDouble(this,4)">
												<span class="input-group-btn">
													<button type="button" onclick="javascript:tailSet(0,'${coin.coinNum}')" class="btn btn-primary">변동값 변경</button>
												</span>
											</div>
											<div class="form-group input-group">
												<input id="tailRate${coin.coinNum}" class="form-control" value="${coin.tailRate}" onInput="setNum(this)">
												<span class="input-group-btn">
													<button type="button" onclick="javascript:tailSet(1,'${coin.coinNum}')" class="btn btn-primary">변동확률 변경</button>
												</span>
											</div>
										</div>
									</div>
								</div>							
							</c:forEach>
						</div>						
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
function setDouble(obj , num){
	let regexp = /^[0-9]+(.[0-9]{0,4})?$/;
	val = obj.value;
	if(num == 1){
		regexp = /^[0-9]+(.[0-9]{0,1})?$/;
	}else if (num == 2){
		regexp = /^[0-9]+(.[0-9]{0,2})?$/;
	}
	if(!regexp.test(val)){
		obj.value = val.slice(0, -1);
	}
}	
function setNum(obj){
	val=obj.value;
    re=/[^0-9]/gi;
    obj.value=val.replace(re,"");
}
function tailSet(type,coinNum){
	let val = "";
	if(type==0){
		val = $("#tailPrice"+coinNum).val();
	}else{
		val = $("#tailRate"+coinNum).val();
		
		if(Number(val) > 100){
			alert("변동확률은 100%를 초과할 수 없습니다.");
			return;
		}
	}
	$.ajax({
		type:'post',
		data:{"coinNum" : coinNum, "type" : type, "val" : val},
		url:'/global/0nI0lMy6jAzAFRVe0DqLOw/trade/tailSet.do',
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

</script>
</body>
</html>