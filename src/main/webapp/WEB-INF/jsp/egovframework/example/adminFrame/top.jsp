<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<!-- 	<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0"> -->
<!-- 	</nav> -->
	<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
        <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
            <i class="fa fa-bars"></i>
        </button>

		<ul class="nav navbar-top-links navbar-right">
			<li class="dropdown"> <span style="font-weight:bold;">총 포지션 증거금 :</span> <span id="position"></span>&ensp;/&ensp;</li>		
			<li class="dropdown"> <span style="font-weight:bold;">수익금(유저 손실액):</span> <span id="profit"></span>&ensp;/&ensp;</li>
			<li class="dropdown"> <span style="font-weight:bold;">순수익(수익금 + 거래수수료 - 펀딩 - 총판 분배금):</span> <span id="netP"></span> </li>
		</ul>
        <ul class="navbar-nav ml-auto">

            <li class="nav-item dropdown no-arrow">
                <a class="nav-link" href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/logout.do">
                    <span class="mr-2 d-none d-lg-inline text-gray-600 small">Logout</span>
                </a>
            </li>
        </ul>
    </nav>
<script>
	getMoneySum();
	function getMoneySum(){
		$.ajax({
			type:'post',
			url:'/wesell/0nI0lMy6jAzAFRVe0DqLOw/getMoneySum.do',
			success:function(data){
				console.log(data);
				$("#position").text(data.margin);
				$("#profit").text(data.profit);
// 				$("#netP").text(data.netProfit);
				$("#netP").text(data.profit+" + "+data.fee+" - "+data.funding+" - "+(data.fee-data.adminProfit)+" = "+data.netProfit);
			}
		})
	}
</script>
</body>
</html>