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
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do" />
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">현재 회원 포지션</h1>
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">position</h6>
						</div>
						<div class="card-body">
							<div class="row">
								<div class="col-lg-6">
									<label>검색</label>
									<div class="form-group input-group">
										<select id="searchSelect" name="searchSelect"
											class="form-control">
											<option value="name" selected="">회원명</option>
											<option value="inviteCode">inviteCode</option>
											<option value="child">inviteCode 하위</option>
											<option value="allChild">inviteCode 하위(전체)</option>
										</select> <input type="text" id="search" value="${search}"
											class="form-control" style="width: auto;">
										<button class="btn btn-default" onclick="setSearchInfo()"
											type="button">
											<i class="fa fa-search"></i>
										</button>
									</div>
								</div>
								<div class="col-lg-2">
									<label>총 접속자수</label>
									<div class="form-group input-group">
										<pre><span id="online">0</span>명</pre>
									</div>
								</div>
								<div class="col-lg-2">
									<label>총 진행 포지션</label>
									<div class="form-group input-group">
										<pre><span id="positionCnt">0</span>개</pre>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-3">
									<label>증거금 총 합계 (USDT)</label>
									<div class="form-group ">
										<pre><span id="positionMargin">0</span> USDT</pre>
									</div>
								</div>
								<div class="col-md-3">
									<label>예상수익 총 합계 (USDT)</label>
									<div class="form-group input-group">
										<pre><span id="profitSum">0</span> USDT</pre>
									</div>
								</div>
								<c:if test="${project.inverse eq true}">
									<c:forEach var="item" items="${useCoins}">
										<c:if
											test="${item eq 'BTC' or item eq 'ETH' or item eq 'XRP' or item eq 'TRX'}">
											<div class="col-md-3">
												<label>증거금 총 합계 (${item})</label>
												<div class="form-group">
													<pre><span id="positionMargin_${item}">0</span> ${item}</pre>
												</div>
											</div>
											<div class="col-md-3">
												<label>예상수익 총 합계 (${item})</label>
												<div class="form-group">
													<pre><span id="profitSum_${item}">0</span> ${item}</pre>
												</div>
											</div>
										</c:if>
									</c:forEach>
								</c:if>
							</div>
						</div>
						&ensp;
						<div class="card-body">
							<c:forEach var="item" items="${useCoins}">
								<a href="#${fn:toLowerCase(item)}" style="margin-right: 20px;">${item}포지션 리스트</a>
							</c:forEach>
							<br>
							<br>
							<c:forEach var="item" items="${useCoins}">
								<a name="${fn:toLowerCase(item)}"><label><br>&ensp;${item}
										포지션 리스트</label></a>
								<label>&ensp;정렬 옵션</label>
								<select onchange="setSort('${item}',this.value)">
									<option value="-1">없음</option>
									<option value="1">오름차순(증거금)</option>
									<option value="2">내림차순(증거금)</option>
									<option value="3">오름차순(규모)</option>
									<option value="4">내림차순(규모)</option>
								</select>
								<br>
								<div class="table-responsive" style="width: 100%;">
									<table class="table table-striped table-hover" style="font-size:small;">
										<thead>
											<tr>
												<th>UID</th>
												<th>회원명</th>
												<th>소속 총판</th>
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
												<th>접속 여부</th>
											</tr>
										</thead>
										<tbody id="${fn:toLowerCase(item)}PList">
										</tbody>
									</table>
								</div>
								<br>
								<br>
							</c:forEach>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
<script>
	var marginSort = [ 0, 0, 0, 0 ]; // 0 = 정렬없음, 1 = 증거금(오름), 2 = 증거금(내림), 3 = 볼륨(오름), 4 = 볼륨(내림)
	var positionCount = 0;
	var marginSum = 0;
	var profitSum = 0;
	var marginSum_spot = [ 0, 0, 0, 0, 0, 0, 0, 0 ];
	var profitSum_spot = [ 0, 0, 0, 0, 0, 0, 0, 0 ];
	function setSearchInfo() {
		$.ajax({
			type : 'post',
			data : {
				'search' : $("#search").val(),
				'searchSelect' : $("#searchSelect").val()
			},
			url : '/global/0nI0lMy6jAzAFRVe0DqLOw/trade/setSearchInfo.do',
			success : function(data) {
				if (data.result == 'suc') {
					getPositionData();
				}
			},
			error : function(e) {
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
	function getPositionData() {
		$.ajax({
			type : 'post',
			url : '/global/0nI0lMy6jAzAFRVe0DqLOw/trade/getNowPositionData.do',
			success : function(data) {
				positionCount = 0;
				marginSum = parseFloat(0);
				profitSum = parseFloat(0);

				$("#online").text(data.online);

				appendPositionList("btc", data.btclist);
				appendPositionList("eth", data.ethlist);
				appendPositionList("xrp", data.xrplist);
				appendPositionList("trx", data.trxlist);
				appendPositionList("doge", data.dogelist);
				appendPositionList("ltc", data.ltclist);
				appendPositionList("sand", data.sandlist);
				appendPositionList("ada", data.adalist);
				appendPositionList("gmt", data.gmtlist);
				appendPositionList("ape", data.apelist);
				appendPositionList("gala", data.galalist);
				appendPositionList("rose", data.roselist);
				appendPositionList("ksm", data.ksmlist);
				appendPositionList("dydx", data.dydxlist);
				appendPositionList("rvn", data.rvnlist);
				appendPositionList("etc", data.etclist);

				$("#positionCnt").text(positionCount);
				$("#positionMargin").text(marginSum.toFixed(5));
				$("#profitSum").text(profitSum.toFixed(5));

				for (var i = 0; i < 8; i++) {
					var coin = getCoin(i);
					$("#positionMargin_" + coin).text(
							marginSum_spot[i].toFixed(5));
					$("#profitSum_" + coin).text(profitSum_spot[i].toFixed(5));
					marginSum_spot[i] = 0;
					profitSum_spot[i] = 0;
				}
			},
			error : function(e) {
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}
	setSearchInfo();
	setInterval(getPositionData, 5000);

	function appendPositionList(coin, plist) {
		if (plist == null)
			return;
		var cnum = getCoinNum(coin.toUpperCase());
		switch (marginSort[cnum]) {
		case 1:
			plist.sort(function(a, b) {
				let
				afee = parseFloat(a.fee);
				let
				bfee = parseFloat(b.fee);
				if (isInverse(a.symbol))
					afee *= a.entryPrice;
				if (isInverse(b.symbol))
					bfee *= b.entryPrice;
				return afee - bfee;
			});
			break;
		case 2:
			plist.sort(function(a, b) {
				let
				afee = parseFloat(a.fee);
				let
				bfee = parseFloat(b.fee);
				if (isInverse(a.symbol))
					afee *= a.entryPrice;
				if (isInverse(b.symbol))
					bfee *= b.entryPrice;
				return bfee - afee;
			});
			break;
		case 3:
			plist.sort(function(a, b) {
				return parseFloat(a.contractVolume)
						- parseFloat(b.contractVolume);
			});
			break;
		case 4:
			plist.sort(function(a, b) {
				return parseFloat(b.contractVolume)
						- parseFloat(a.contractVolume);
			});
			break;
		}

		var $id = $("#" + coin + "PList");
		$id.empty();
		var length = plist.length;
		positionCount += length;
		for (var i = 0; i < length; i++) {
			let
			testuser = "<span style='color:red;'> 테스트</span>";
			let
			testparent = "";
			if (plist[i].istest != 1) {
				var profit = Number(parseFloat(plist[i].profit).toFixed(5));
				var margin = Number(parseFloat(plist[i].fee).toFixed(5));
				if (isInverse(plist[i].symbol)) {
					var cnum = getCoinNum(plist[i].symbol);
					profitSum_spot[cnum] += profit;
					marginSum_spot[cnum] += margin;
				} else {
					profitSum += profit;
					marginSum += margin;
				}
				testuser = "";
			}
			if (plist[i].ptest == 1)
				testparent = "<span style='color:red;'> 테스트계정</span>";

			let
			parentTdOption = "";
			if (plist[i].pidx != null) {
				parentTdOption = "style='cursor:pointer;' onclick=\"location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx="
						+ plist[i].pidx + "'\"";
			}

			let
			betCoin = "USDT";
			if (isInverse(plist[i].symbol))
				betCoin = coin.toUpperCase();

			$id.append("<tr><td>"
							+ plist[i].userIdx+"</td><td style='cursor:pointer;' onclick=\"location.href='/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx="
							+ plist[i].userIdx
							+ "'\">"
							+ plist[i].name
							+ testuser
							+ "</td>"
							+ "<td "+parentTdOption+">"
							+ plist[i].pname
							+ testparent
							+ "</td>"
							+ "<td>"
							+ plist[i].symbol
							+ "</td>"
							+ "<td>"
							+ plist[i].position.toUpperCase()
							+ "</td>"
							+ "<td>"
							+ parseFloat(plist[i].fee).toFixed(5)
							+ " "
							+ betCoin
							+ "</td>"
							+ "<td>"
							+ plist[i].contractVolume
							+ " USDT</td>"
							+ "<td>"
							+ plist[i].leverage
							+ "</td>"
							+ "<td>"
							+ plist[i].entryPrice
							+ " USDT</td>"
							+ "<td>"
							+ plist[i].buyQuantity
							+ " "
							+ coin.toUpperCase()
							+ "</td>"
							+ "<td>"
							+ parseFloat(plist[i].liquidationPrice).toFixed(5)
							+ " USDT</td>"
							+ "<td>"
							+ parseFloat(plist[i].profit).toFixed(5)
							+ " "
							+ betCoin
							+ "</td>"
							+ "<td>"
							+ parseFloat(plist[i].profitRate).toFixed(2)
							+ "%</td>"
							+ "<td>"
							+ plist[i].online
							+ "</td></tr>");
		}

	}

	function getCoin(cnum) {
		switch (cnum) {
		case 0:
			return "BTC";
		case 1:
			return "ETH";
		case 2:
			return "XRP";
		case 3:
			return "TRX";
		case 4:
			return "DOGE";
		case 5:
			return "LTC";
		case 6:
			return "SAND";
		case 7:
			return "ADA";
		case 8:
			return "GMT";
		case 9:
			return "APE";
		case 10:
			return "GALA";
		case 11:
			return "ROSE";
		case 12:
			return "KSM";
		case 13:
			return "DYDX";
		case 14:
			return "RVN";
		case 15:
			return "ETC";
		default:
			break;
		}
	}

	function getCoinNum(symbol) {
		switch (symbol) {
		case "BTCUSDT":
		case "BTC":
		case "BTCUSD":
			return 0;
		case "ETHUSDT":
		case "ETH":
		case "ETHUSD":
			return 1;
		case "XRPUSDT":
		case "XRP":
		case "XRPUSD":
			return 2;
		case "TRXUSDT":
		case "TRX":
		case "TRXUSD":
			return 3;
		case "DOGEUSDT":
		case "DOGE":
		case "DOGEUSD":
			return 4;
		case "LTCUSDT":
		case "LTC":
		case "LTCUSD":
			return 5;
		case "SANDUSDT":
		case "SAND":
		case "SANDUSD":
			return 6;
		case "ADAUSDT":
		case "ADA":
		case "ADAUSD":
			return 7;
		case "GMTUSDT":
		case "GMT":
		case "GMTUSD":
			return 8;
		case "APEUSDT":
		case "APE":
		case "APEUSD":
			return 9;
		case "GALAUSDT":
		case "GALA":
		case "GALAUSD":
			return 10;
		case "ROSEUSDT":
		case "ROSE":
		case "ROSEUSD":
			return 11;
		case "KSMUSDT":
		case "KSM":
		case "KSMUSD":
			return 12;
		case "DYDXUSDT":
		case "DYDX":
		case "DYDXUSD":
			return 13;
		case "RVNUSDT":
		case "RVN":
		case "RVNUSD":
			return 14;
		case "ETCUSDT":
		case "ETC":
		case "ETCUSD":
			return 15;
		default:
			break;
		}
	}

	function setSort(coin, value) {
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

		let
		decimalv = "";

		if (num.indexOf(".") != -1) {
			let
			numarr = num.split(".");
			num = numarr[0];
			decimalv = "." + numarr[1];
		}

		let
		len, point, str;
		let
		min = "";

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
</script>
</body>
</html>