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
<style>
.mlong{
	color:blue;
}
.mshort{
	color:red;
}
details {
	display: flex;
    border-bottom: 1px solid #efefef;
    color: #666;
    padding: 15px;
}
details[open] summary {
    font-weight: 800;
}
details > summary {
    color: #333;
    font-size: 24px;
    padding: 15px 0;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
var mlist = "${mList}";
function infoChange(value){
	$(".info").css("display","none");
	$(".info."+value).css("display","flex");
}
</script>
<body id="page-top">
	<div id="wrapper">		
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
       	<div id="content-wrapper">        	
	        	<div id="content">	        
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>           
		             <div class="container-fluid">
		             <h1 class="h3 mb-2 text-gray-800">Balance</h1>
		                <div class="card shadow mb-4">
				             <div class="card-header py-3">
		                        <h6 class="m-0 font-weight-bold text-primary">
			                    	<b>※ 동일 종목에 대해 조작이 진행 중일 때 중복 실행이 불가능합니다.</b>  <input type="button" value="새로고침" onclick="location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/trade/manipulation.do'">
			                    	<br><b>※목표가는 현재가와 차이가 많이 나게 설정하면 진행 시간이 오래 걸리므로 현재 시간 또는 이전 분봉의 최저가보다 낮거나 최고가보다 높게 잡는 것을 권장합니다.</b>
			                    	<br>-차트 초기화 : 조작으로 왜곡이 심해진 차트의 초기화가 필요한 경우 실행합니다(거래 페이지에서 새로고침시 초기화된 차트 확인 가능) 동시에 시세(모듈)의 조작 기능 중단을 요청합니다.
			                    	<br>-조작 종목 초기화 : 시세만 재실행할 경우 등에 한해서 부득이하게 서버의 조작 중인 종목을 초기화 해야 할 때 사용하는 기능입니다.
			                    	<details>
			                    		<summary style="display: list-item;">목표가와 변동가 설정에 대한 설명</summary>
										예를 들자면 현재 시세가 40000인데 목표가를 41000, 변동가를 5로 잡는다면 41000에 도달할 때까지 5씩 더해 주다가 41000을 넘어서면 다시 원래 시세로 돌아가는데 이때 5씩 빼주게 됩니다.<br>
										(현 시세보다 더 낮은 값, 40000→39000으로 설정한 경우에는 반대로 5씩 감소하다가 5씩 증가됨)<br>
										따라서 현재가와 차이가 심하게 목표가를 설정해 두거나 변동값을 작게 설정해 두면 목표가 도달하는 데에 다소 시간이 소요되므로 테스트 전에 현재가를 확인하시고 소수점 자릿수에 맞게 적정가를 입력하여 실행해 주시면 되겠습니다.
										<br><br>
										시세를 약 0.25-0.3초에 한 번씩 받음 ⇒ 변동가 0.3 입력 ⇒ 초당 0.3*4=1.2씩 변동을 감안
										<br><br>
										시세 설정 예시<br>
										BTC ⇒ 현재:40000 목표:40050 변동:0.3<br>
										ETH ⇒ 현재:3000 목표:3010 변동:0.01<br>
										XRP ⇒ 현재:0.7100 목표:0.7200 변동:0.00005<br>
										TRX ⇒ 현재:0.06000 목표:0.06050 변동:0.000005<br>
										DOGE (목표:0.06120 변동:0.000005)<br>
										LTC (목표:54.50 변동:0.005)<br>
										SAND (목표:0.9040 변동:0.00005)<br>
										ADA (목표:0.4800 변동:0.00004)
										<br><br>
										조작 중일 때에는 해당 코인에 대한 중복 조작이 불가능합니다. 실행 버튼을 누르면 현재 조작 중인 종목에 추가되며, 조작이 끝나면 현재 조작 중인 종목에서 빠지게 됩니다.<br>
										(이때 수동으로 새로고침을 해야 조작 중 종목에서 사라진 걸 확인할 수 있고, 만일 조작이 종료되고도 새로고침이 되지 않았다 싶으면 조작 종목 초기화 버튼을 누르면 됨)
										<br><br>
										진행 중인 시세 조작을 중단하기를 원한다면 차트 초기화, 조작 종목 초기화 버튼을 연달아 눌러 주면 됩니다.<br>
									</details>
			                    	<b>현재 조작 중인 종목 : <span>${mList}</span></b><br>	                    	
			                    	<input type="button" style="float:right" value="차트 초기화" onclick="resetC()">
			                    	<input type="button" style="float:right" value="조작 종목 초기화" onclick="resetM()">
			                    	<br>
		                   		</h6>
		                       </div>
		                    <div class="col-lg-12">
			                    <c:forEach var="item" items="${useCoins}">
				                    <div style="margin-top:30px;padding-left:30px; float:left; width:25%;">
				                    	<form id="${fn:toLowerCase(item)}form" method="post">
					                    	<p>${item}USDT</p>
					                    	<input type="hidden" name="symbol" value="${item}"/>
					                    	<p>목표가 <input type="text" id="${fn:toLowerCase(item)}price" name="price"></p>
					                    	<p>변동가 <input type="text" id="${fn:toLowerCase(item)}gap" name="gap" placeholder="최대 0.3까지 입력 가능"></p>
					                       <input type="button" value="실행" onclick="setM('${fn:toLowerCase(item)}')">
				                       </form>
				         			</div>
			                    </c:forEach>
		                    </div>
		                     <div class="card-body">
		                    	<div class="table-responsive balanceform" style="width:100%;">
		                            <table class="table table-striped table-hover" style="text-align:center;">
		                                <thead>
		                                    <tr>
		                                    	<th style="width:10%;">&ensp;</th>
		                                    	<c:forEach var="item" items="${useCoins}">
			                                    	<th style="text-align:center;">${item}</th>
		                                    	</c:forEach>
		                                    </tr>
		                                </thead>
										<tbody>
											<tr id="trRate">
												<th>비율( Long : Short )</th>
											</tr>
											<tr id="trMargin">
												<th>증거금 합 (USDT)</th>
											</tr>
											<tr id="trVolume">
												<th>규모 합 (USDT)</th>
											</tr>
											<tr id="trMarginSum">
												<th>증거금 총합 (USDT)</th>
											</tr>
											<tr id="trVolumeSum">
												<th>규모 총합 (USDT)</th>
											</tr>
										</tbody>
									</table>
									<div style="color:red; margin-top:5px;">&ensp;*현물 포지션의 증거금은 USDT 진입가에 맞게 환산해서 계산됨</div>
								</div>	                    
		                    <br>
		                    &ensp;
		                    <c:forEach var="item" items="${useCoins}">
			                    <a href="#${fn:toLowerCase(item)}" style="margin-right:20px;">${item} 포지션 리스트</a>
		                    </c:forEach>
		                    <br><br>
		                    <c:forEach var="item" items="${useCoins}">
			                    <a name="${fn:toLowerCase(item)}"><label><br>&ensp;${item}USDT 포지션 리스트</label></a>
			                    <label>&ensp;정렬 옵션</label>
			                    <select onchange="setSort('${item}',this.value)">
			                    	<option value="-1">없음</option>
								    <option value="1">오름차순(증거금)</option>
								    <option value="2">내림차순(증거금)</option>
								    <option value="3">오름차순(규모)</option>
								    <option value="4">내림차순(규모)</option>
			                    </select>
			                    <br>
			                    <div class="table-responsive" style="width:100%;">
		                            <table class="table table-striped table-hover">
		                                <thead>
		                                    <tr>
		                                        <th>회원명</th>
		                                        <th>심볼</th>
		                                        <th>포지션</th>
		                                        <th>증거금</th>
		                                        <th>규모 USDT</th>
		                                        <th>레버리지</th>
		                                        <th>진입가격</th>
		                                        <th>계약수량</th>
		                                        <th>청산가격</th>
		                                        <th>예상 수익</th>
		                                        <th>예상 수익률</th>
		                                    </tr>
		                                </thead>
										<tbody id="${fn:toLowerCase(item)}PList">
										</tbody>
									</table>
		                        </div>
		                        <br><br>
		                    </c:forEach>
						</div>
					</div>
				</div>
		    </div>
    	</div>
   	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
	<script>
		var marginSort = [0,0,0,0]; // 0 = 정렬없음, 1 = 증거금(오름), 2 = 증거금(내림), 3 = 볼륨(오름), 4 = 볼륨(내림)
		function setM(coin){
			let cfnum = symbolFixed[getCoinNum(coin.toUpperCase())];
			var gval = $("#"+coin+"gap").val();
			var pval = $("#"+coin+"price").val();
			if( $("#"+coin+"price").val() == "" || $("#"+coin+"price").val() == null || $("#"+coin+"price").val() == '0' || $("#"+coin+"gap").val() == "" || $("#"+coin+"gap").val() == null || $("#"+coin+"gap").val() == '0'){
				alert("값을 입력하세요.");
				return;
			}
			if(Number(gval) > 0.3){
				alert("변동가 최대 0.3을 넘을 수 없습니다. ");
				return;
			}
			if(parseFloat(parseFloat(gval).toFixed(cfnum)) <= 0) {
				alert("변동가를 잘못 입력했습니다. "+coin+" : 소수점 "+cfnum+"째 자리까지");
				return;
			}
			if(parseFloat(parseFloat(gval).toFixed(cfnum)) >= parseFloat(pval)) {
				alert("변동가는 목표가보다 클 수 없습니다.");
				return;
			}
			if (mlist.includes(coin)) {
				alert('새로고침 버튼을 눌러 현재 실행 중인지 확인 후 다시 시도해 주세요.');
				return;
			}
			$("#"+coin+"gap").val(parseFloat(gval).toFixed(cfnum));
		    var msg = "종목 : "+coin+"\n목표가 : "+$("#"+coin+"price").val()+"\n변동가 : "+$("#"+coin+"gap").val()+"\n\n실행하시겠습니까?";
		    if (confirm(msg)!=0) {
				var data = $("#"+coin+"form").serialize();
				$.ajax({
					type :'post',
					data : data,
					url : '/global/0nI0lMy6jAzAFRVe0DqLOw/trade/manipulProcess.do',
					success:function(data){
						alert(data.msg);
						location.reload();
					},
					error:function(e){
						console.log('ajax Error ' + JSON.stringify(e));
					}
				})
		    }
		}
		
		function setMLimit(coin){
			let cfnum = symbolFixed[getCoinNum(coin.toUpperCase())];
			var gval = $("#"+coin+"gap").val();
			var pval = $("#"+coin+"price").val();
			if( $("#"+coin+"price").val() == "" || $("#"+coin+"price").val() == null || $("#"+coin+"price").val() == '0' || $("#"+coin+"gap").val() == "" || $("#"+coin+"gap").val() == null || $("#"+coin+"gap").val() == '0'){
				alert("값을 입력하세요.");
				return;
			}
			if(parseFloat(parseFloat(gval).toFixed(cfnum)) <= 0) {
				alert("변동가를 잘못 입력했습니다. "+coin+" : 소수점 "+cfnum+"째 자리까지");
				return;
			}
			if(parseFloat(parseFloat(gval).toFixed(cfnum)) >= parseFloat(pval)) {
				alert("변동가는 목표가보다 클 수 없습니다.");
				return;
			}
			if (mlist.includes(coin)) {
				alert('새로고침 버튼을 눌러 현재 실행 중인지 확인 후 다시 시도해 주세요.');
				return;
			}
			$("#"+coin+"gap").val(parseFloat(gval).toFixed(cfnum));
		    var msg = "종목 : "+coin+"\n목표가 : "+$("#"+coin+"price").val()+"\n변동가 : "+$("#"+coin+"gap").val()+"\n\n실행하시겠습니까?";
		    if (confirm(msg)!=0) {
				var data = $("#"+coin+"form").serialize();
				$.ajax({
					type :'post',
					data : data,
					url : '/global/0nI0lMy6jAzAFRVe0DqLOw/trade/manipulProcess.do',
					success:function(data){
						alert(data.msg);
						location.reload();
					},
					error:function(e){
						console.log('ajax Error ' + JSON.stringify(e));
					}
				})
		    }
		}
		
		function appendPositionInfo($trRate, $trMargin, $trVolume, $trMarginSum, $trVolumeSum, coinInfo){
			if(coinInfo == null) return;
			$trRate.append("<td><span class='mlong'>"+coinInfo.lRate+"%</span> : <span class='mshort'>"+coinInfo.sRate+"%</span></td>");
			$trMargin.append("<td><span class='mlong'>"+fmtNum(coinInfo.lfee)+" USDT</span> : <span class='mshort'>"+fmtNum(coinInfo.sfee)+" USDT</span></td>");
			$trVolume.append("<td><span class='mlong'>"+fmtNum(coinInfo.lvolume)+" USDT</span> : <span class='mshort'>"+fmtNum(coinInfo.svolume)+" USDT</span></td>");
			$trMarginSum.append("<td>"+fmtNum(coinInfo.lfee+coinInfo.sfee)+" USDT</td>");
			$trVolumeSum.append("<td>"+fmtNum(parseFloat(coinInfo.lvolume+coinInfo.svolume).toFixed(5))+" USDT</td>");
		}
		
		function getPositionData(){
			$.ajax({
				type :'post',
				url : '/global/0nI0lMy6jAzAFRVe0DqLOw/trade/getPositionData.do',
				success:function(data){
					var $trRate = $("#trRate");
					$trRate.empty();
					$trRate.append("<th>비율( Long : Short )</th>");
					var $trMargin = $("#trMargin");
					$trMargin.empty();
					$trMargin.append("<th>증거금 합 (USDT)</th>");
					var $trVolume = $("#trVolume");
					$trVolume.empty();
					$trVolume.append("<th>규모 합 (USDT)</th>");
					var $trMarginSum = $("#trMarginSum");
					$trMarginSum.empty();
					$trMarginSum.append("<th>증거금 총합 (USDT)</th>");
					var $trVolumeSum = $("#trVolumeSum");
					$trVolumeSum.empty();
					$trVolumeSum.append("<th>규모 총합 (USDT)</th>");
				
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.btcInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.ethInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.trxInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.xrpInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.dogeInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.ltcInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.sandInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.adaInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.gmtInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.apeInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.galaInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.roseInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.ksmInfo);
					appendPositionInfo($trRate,$trMargin,$trVolume,$trMarginSum,$trVolumeSum,data.dydxInfo);
					
					appendPositionList("btc",data.btclist);
					appendPositionList("eth",data.ethlist);
					appendPositionList("xrp",data.xrplist);
					appendPositionList("trx",data.trxlist);
					appendPositionList("doge",data.dogelist);
					appendPositionList("ltc",data.ltclist);
					appendPositionList("sand",data.sandlist);
					appendPositionList("ada",data.adalist);
					appendPositionList("gmt",data.gmtlist);
					appendPositionList("ape",data.apelist);
					appendPositionList("gala",data.galalist);
					appendPositionList("rose",data.roselist);
					appendPositionList("ksm",data.ksmlist);
					appendPositionList("dydx",data.dydxlist);
				},
				error:function(e){
					console.log('ajax Error ' + JSON.stringify(e));
				}
			})
		}
		getPositionData();
		setInterval(getPositionData,5000);

		function appendPositionList(coin,plist){
			if(plist == null) return;
			var cnum = getCoinNum(coin.toUpperCase());
			switch(marginSort[cnum]){
			case 1:
				plist.sort(function(a,b) {
					let afee = parseFloat(a.fee);
					let bfee = parseFloat(b.fee);
					if(isInverse(a.symbol))
						afee *= a.entryPrice;
					if(isInverse(b.symbol))
						bfee *= b.entryPrice;
					return afee - bfee;
				});
				break;
			case 2:
				plist.sort(function(a,b) {
					let afee = parseFloat(a.fee);
					let bfee = parseFloat(b.fee);
					if(isInverse(a.symbol))
						afee *= a.entryPrice;
					if(isInverse(b.symbol))
						bfee *= b.entryPrice;
					return bfee - afee;
				});
				break;
			case 3:
				plist.sort(function(a,b) {
					return parseFloat(a.contractVolume) - parseFloat(b.contractVolume);
				});
				break;
			case 4:
				plist.sort(function(a,b) {
					return parseFloat(b.contractVolume) - parseFloat(a.contractVolume);
				});
				break;
			}

			var $id = $("#"+coin+"PList");
			$id.empty();
			var length = plist.length;
			
			for(var i = 0; i < length; i++){
				let betCoin = "USDT";
				if(isInverse(plist[i].symbol))
					betCoin = coin.toUpperCase();
			
				$id.append(
					"<tr><td style='cursor:pointer;' onclick=\"location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx="+plist[i].userIdx+"'\">"+plist[i].name+"</td>" +
					"<td>"+plist[i].symbol+"</td>"+
					"<td>"+plist[i].position.toUpperCase()+"</td>"+
					"<td>"+parseFloat(plist[i].fee).toFixed(5)+" "+betCoin+"</td>"+
					"<td>"+plist[i].contractVolume+" USDT</td>"+
					"<td>"+plist[i].leverage+"</td>"+
					"<td>"+plist[i].entryPrice+" USDT</td>"+
					"<td>"+plist[i].buyQuantity+" "+coin.toUpperCase()+"</td>"+
					"<td>"+parseFloat(plist[i].liquidationPrice).toFixed(5)+" USDT</td>"+
					"<td>"+parseFloat(plist[i].profit).toFixed(5)+" "+betCoin+"</td>"+
					"<td>"+parseFloat(plist[i].profitRate).toFixed(2)+"%</td></tr>");
			}
			
		}
		
		function getCoinNum(symbol) {
			switch (symbol) {
			case "BTCUSDT": case "BTC": case "BTCUSD":
				return 0;
			case "ETHUSDT": case "ETH": case "ETHUSD":
				return 1;
			case "XRPUSDT": case "XRP": case "XRPUSD":
				return 2;
			case "TRXUSDT": case "TRX": case "TRXUSD":
				return 3;
			case "DOGEUSDT": case "DOGE": case "DOGEUSD":
				return 4;
			case "LTCUSDT": case "LTC": case "LTCUSD":
				return 5;
			case "SANDUSDT": case "SAND": case "SANDUSD":
				return 6;
			case "ADAUSDT": case "ADA": case "ADAUSD":
				return 7;
			case "GMTUSDT": case "GMT": case "GMTUSD":
				return 8;
			case "APEUSDT": case "APE": case "APEUSD":
				return 9;
			case "GALAUSDT": case "GALA": case "GALAUSD":
				return 10;
			case "ROSEUSDT": case "ROSE": case "ROSEUSD":
				return 11;
			case "KSMUSDT": case "KSM": case "KSMUSD":
				return 12;
			case "DYDXUSDT": case "DYDX": case "DYDXUSD":
				return 13;
			default:
				break;
			}
		} 
		
		const symbolFixed = new Array(2,2,4,5,6,2,5,5,4,3,5,4,2,3);
		
		function setSort(coin, value){
			var cnum = getCoinNum(coin);
			marginSort[cnum] = Number(value);
			getPositionData();
		}
		
		function fmtNum(num) {
			if (num == null)
				return 0;
			num = String(num);
			if (num.length <= 3)
				return num;

			let decimalv = "";

			if (num.indexOf(".") != -1) {
				let
				numarr = num.split(".");
				num = numarr[0];
				decimalv = "." + numarr[1];
			}

			let len, point, str;
			let min = "";

			num = num + "";
			if (num.charAt(0) == '-') {
				num = num.substr(1);
				min = "-";
			}

			point = num.length % 3;
			str = num.substring(0, point);
			len = num.length;

			while (point < len) {
				if (str != "")
					str += ",";
				str += num.substring(point, point + 3);
				point += 3;
			}
			return min + str + decimalv;
		}
		
	function resetC() {
		$.ajax({
			type :'get',
			url : 'https://'+(servername === 'bmbit-korea.com' ? 'bmbit.org' : "<%=request.getServerName()%>") + ':5927/reset',
			success:function(data){
				if(data === 'ok') {
					$.ajax({
						type :'post',
						url : '/global/0nI0lMy6jAzAFRVe0DqLOw/trade/resetChart.do',
						success:function(data){
							alert(data.result);
						},
						error:function(e){
							console.log('오류가 발생했습니다. 다시 시도해 주세요.');
						}
					})
				} else {
					alert('오류가 발생했습니다. 다시 시도해 주세요.');
				}
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
	
	function resetM() {
		$.ajax({
			type :'post',
			url : '/global/0nI0lMy6jAzAFRVe0DqLOw/trade/resetMStatus.do',
			success:function(data){
				alert(data.msg);
				location.reload();
			},
			error:function(e){
				console.log('오류가 발생했습니다. 다시 시도해 주세요.');
			}
		})
	}
	</script>
</body>
</html>