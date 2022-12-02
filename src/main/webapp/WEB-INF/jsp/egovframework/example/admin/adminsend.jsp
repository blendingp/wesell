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
                	<h1 class="page-header">전송</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
						<div class="panel-heading">전송</div>
                        <div class="panel-body">
                        	<div class="form-group input-group">
								<form action="/wesell/sendtest.do" method="post" >
									<div>코인종류<select name="kind" onChange="onChange()">
										<option>선택</option>
										<option>BTC</option>
										<option>USDT</option>
										<option>ETH</option>
										<option>TRX</option>
										<option>XRP</option>
									</select>
									</div>
									<div>보내는주소<input name="from" size="50"></div>
									<div>받는주소<input name="to" size="50"></div>
									<div>보낼 수량<input name="value"></div>
									<div>privatekey<input name="pkey"></div>
									<div>tag<input name="tag"></div>
									<div><input type="submit"></div>
								</form>
							</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>
<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
var btcadd = "${btcAddress}";
var ercadd = "${ercAddress}";
var xrpadd = "${xrpAddress}";
var trxadd = "${trxAddress}";
function onChange(){
	var sel = $("[name=kind]").val();
	console.log(sel ) ;
	if(sel=="BTC" ) $("[name=from]").val(btcadd);
	if(sel=="USDT" ) $("[name=from]").val(ercadd);
	if(sel=="ETH" ) $("[name=from]").val(ercadd);
	if(sel=="TRX" ) $("[name=from]").val(trxadd);
	if(sel=="XRP" ) $("[name=from]").val(xrpadd);
}
</script>
</body>
</html>