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
td{
	padding:8px;
}
.rank0{
	background-color:#f34840;
	color:white !important;
}
.rank1{
	background-color:#acf1fc;
}
.rank2{
	background-color:#e9b202;
}
.rank3{
	background-color:#cccccc;
}
.rank4{
	background-color:#d68c46;
}
.pEventSkip{
	cursor:pointer;
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
					<h1 class="h3 mb-2 text-gray-800">총판 관리</h1>
		            <div class="card shadow mb-4">
						<div class="card-body">
						   <form action="/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/chongList.do" name="listForm" id="listForm">
						   		<input type="hidden" name="fileDown" id="fileDown" value="0" />
								<input type="hidden" name="pageIndex" value="1"/>
								<div class="row">
									<div class="col-lg-1">
										<label>구분</label>
										<div class="form-group input-group">
											<select name="gChongs" class="form-control" onchange="uidSearch(this.value)">
												<option value="">전체</option>
												<c:forEach var="gChong" items="${gChongs}">
													<option value="${gChong.idx}" <c:if test="${not empty selectChong and selectChong eq gChong.idx}">selected</c:if>>${gChong.name}</option>
												</c:forEach>
											</select>
										</div>
									</div>
									<div class="col-lg-4">
										<div class="form-group">
											<label>기간 검색</label>
											<div>
												<input type="date" name="sdate" id="sdate" value="${sdate}" class="form-control" style="width: 40%; display: inline-block;" autocomplete="off">
												 ~ 
												<input type="date" name="edate" id="edate" value="${edate}" class="form-control" style="width: 40%; display: inline-block;" autocomplete="off">
											</div>
										</div>
									</div>
									<div class="col-lg-5">
										<label>검색</label>
										<div class="form-group input-group">
											<select id="searchSelect" name="searchSelect" class="form-control">
												<option value="m.name"<c:if test="${searchSelect eq 'm.name'}">selected</c:if>>회원명</option>
	 											<option value="m.email"<c:if test="${searchSelect eq 'm.email'}">selected</c:if>>이메일</option>
	 											<option value="m.phone"<c:if test="${searchSelect eq 'm.phone'}">selected</c:if>>휴대폰</option>
												<option value="m.inviteCode"<c:if test="${searchSelect eq 'm.inviteCode'}">selected</c:if>>InviteCode</option>
 												<option value="m.idx"<c:if test="${searchSelect eq 'm.idx'}">selected</c:if>>UID</option> 
											</select>
 											<input type="text" id="search" name="search" class="form-control" value="${search}" style="width:auto;"> 
											<button class="btn btn-default" style="padding: 6px 12px;" onclick="checkForm(0)" type="button"> <i class="fa fa-search"></i> </button>
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
						<div class="card shadow mb-4">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th style="width:10%;">&ensp;&ensp;UID</th>
                                        <th>총판</th>
                                        <th>직속 상위</th>
                                        <th>최상위</th>
										<th>총 유저</th>
										<th>KYC 인증완료 유저</th>
										<th>현재자산 여부</th>
										<th>레퍼럴 누적액</th>
                                    </tr>
                                </thead>
                                <tbody class="childblock" id="pidx-1" pidx="-1">
                                </tbody>
                            </table>
                        </div>
	                </div>
	            </div> 
			</div>
		</div>
	</div>
	
	
	<input type="hidden" id="modalBtn" data-toggle="modal" data-target="#myModal"/>
	<!-- Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content" style="height:800px; width:1000px; margin-top:100px; overflow: scroll;">
				<div class="modal-header">
					<h4 class="modal-title" id="myModalLabel"><span id="modal-username"></span> 직속 유저</h4>
					<div class="col-lg-3">
						<div class="form-group input-group">
							<select class="form-control" onchange="modalSortChange(this.value)" value="0" id="modal_sort">
								<option value="0" selected>이름</option>
								<option value="2">KYC 인증</option>
								<option value="3">현재 자산 여부</option>
								<option value="1">레퍼럴 누적액</option>
							</select>
						</div>
					</div>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				
									
				<div class="modal-body">
					<div class="card-body">
						<div class="table-responsive">
							<table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
								<thead>
									<tr>
										<th>UID</th>
										<th>총 유저</th>
										<th>KYC 인증</th>
										<th>현재 자산 여부</th>
										<th>레퍼럴 누적액</th>
									</tr>
								</thead>
								<tbody id="modaltable">
									
								</tbody>
							</table>								
						</div>								
                    </div>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
	<script>
	const userIdx = -1;
	let child = '${child}';
	if(child != ''){
		child = JSON.parse(child)
	}

	function listSort(){
		child.array.sort(function(a,b) {
			let alev = 0;
			if(a.level=="chong")
				alev = 1;
			let blev = 0;
			if(b.level=="chong")
				blev = 1;
			return alev - blev;
		});
	}

	function checkForm(file){
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		if((sdate == '' && edate != '') || (sdate != '' && edate == '')){
			alert("조회시작기간과 조회종료기간을 설정해주세요.");
			return;
		}
		if(edate < sdate){
			alert("조회종료기간이 조회시작기간보다 작을 수 없습니다.");
			return;
		}
		
		$("#fileDown").val(file);
		$("#listForm").submit();
	}
	
	function parentsSpread(uid){
		
		$(".influ_tablelcontent.pidx"+uid).css("background-color","green");
		$(".influ_tablelcontent.pidx"+uid).css("color","white");
		
		var loop = true;
		while(loop){
			var parentsIdx = getParents(uid);
			if(parentsIdx == null)
				loop = false;
			else{
				$(".influ_tablelcontent.pidx"+parentsIdx).trigger("click");
				uid = parentsIdx;
			}
		}
	}
	
	function getParents(userIdx){
		userIdx = Number(userIdx);
		for(var i = 0; i < child.array.length; i++){
			if(userIdx == Number(child.array[i].idx)){
				if(child.array[i].parentsIdx == "-1"){
					return null;
				}else{
					return child.array[i].parentsIdx;
				}
			}
		}
	}
	
	$(function() {
		listSort();
		appendChild(-1);
		
		$(".influ_tablelcontent").on("click", function() {
			var uidx = Number($(this).attr("uidx"));
			if($("#pidx"+uidx).css("display") == "none"){
				$("#pidx"+uidx).css("display","contents");
				$(".tArrow"+uidx).text("▲");			
			}else{
				$("#pidx"+uidx).css("display","none");
				$(".tArrow"+uidx).text("▼");			
			}
		});
		$(".linkname").on("click", function() {
			var uidx = Number($(this).parent().attr("uidx"));
			location.href="/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx="+uidx;
		});
		
		$.each($(".childblock"), function(index, item){
			var idx = $(item).attr("pidx");
			var pblock=$(".influ_tablelcontent.pidx"+idx);
			
			rank = getRank(idx);
			if(rank>=0){
				pblock.addClass("rank"+rank);
				pblock.children(".linkname").addClass("rank"+rank);			
			}
		});
		
		$('.pEventSkip').on('click', function(e){
		    e.stopPropagation();
		});
		
		if("${searchSelect}" == "m.idx"){
			parentsSpread("${search}");
		}
	});
	function appendChild(parentsIdx){
		parentsIdx = Number(parentsIdx);
		for(var i = 0; i < child.array.length; i++){
			if(Number(child.array[i].parentsIdx)==parentsIdx){
				var result = "원";
				var toggle="";
				var color="";
				if(child.array[i].level=="chong"){
					toggle = "<span class='tArrow"+child.array[i].idx+"'>▼</span>&ensp;";
				}
				
				var name=child.array[i].name;
				var phone=child.array[i].phone;
				
				var pname = child.array[i].pName;
				if(pname == ""){
					pname = "없음";
				}
				var space = "";
				if(parentsIdx != -1){
					space = " ";
				}
				var pRank = Number(getRank(parentsIdx))+1;
				for(var j = 0; j < pRank; j++){
					space+=" ";
				}
				if(child.array[i].phone=='-1'){
					color="color:red;";
					name=name+"<br>탈퇴회원";
					phone="-";
				}
				
				var divtext = "<tr class='influ_tablelcontent pidx"+child.array[i].idx+"' uidx='"+
					child.array[i].idx+"'> <td>"+
					space+toggle+child.array[i].idx+"</td> <td class='linkname pEventSkip' style='background-color:transparent; "+
					color+";'>"+
					name+"</td> <td>"+
					pname+"</td> <td>"+
					getGParents(child.array[i].idx).name+"</td><td class='pEventSkip' onclick=\"popChildUserList('"+child.array[i].name+"',"+child.array[i].idx+")\">"+
					child.array[i].childCnt+"</td><td>"+
					child.array[i].kycCnt+"</td><td>"+
					child.array[i].walletCnt+"</td><td class='pEventSkip' onclick=\"location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/referral/giveReferralList.do?searchSelect=m.idx&search="+
					child.array[i].idx+"'\">"+
					fmtNum(Number(child.array[i].accumSum).toFixed(4))+"</td></tr>";
					
				$("#pidx"+parentsIdx).append(divtext);
				
				if(child.array[i].level=="chong"){
					var newblock="<div class='childblock' id='pidx"+child.array[i].idx+"' pidx='"+child.array[i].idx+"' style='display:none;'></div>";
					$("#pidx"+parentsIdx).append(newblock);
					appendChild(child.array[i].idx);
				}
			}
		}
	}
	function timeFormat(date){
		let month = date.getMonth() + 1;
	    let day = date.getDate();
	    let hour = date.getHours();
	    let minute = date.getMinutes();
	    let second = date.getSeconds();
	    
	 	month = month >= 10 ? month : '0' + month;
	    day = day >= 10 ? day : '0' + day;
	    hour = hour >= 10 ? hour : '0' + hour;
	    minute = minute >= 10 ? minute : '0' + minute;
	    second = second >= 10 ? second : '0' + second;
	    return date.getFullYear() + '-' + month + '-' + day + ' ' + hour + ':' + minute;
	}
	function getRank(idx){
		let rank = 0;
		let obj = $("#pidx"+idx);
		if(obj.length == 0 || !obj.hasClass("childblock")) return -1;
		while(obj.parent().hasClass("childblock") && Number(obj.parent().attr("pidx")) != -1 ){
			rank++;
			obj = obj.parent();
		}
		return rank;
	}
	function getGParents(userIdx){
		userIdx = Number(userIdx);
		for(var i = 0; i < child.array.length; i++){
			if(userIdx == Number(child.array[i].idx)){
				if(child.array[i].parentsIdx == "-1"){
					return child.array[i];
				}else{
					return getGParents(child.array[i].parentsIdx);
				}
			}
		}
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

	function popChildUserList(name,uidx){
		$.ajax({
			type :'post',
			data : {"uidx" : uidx},
			url : '/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/getChildList.do',
			success:function(data){
				thisArray = data.array;
				modalSortChange();
				$("#modal-username").text(name);
				$("#modalBtn").trigger("click")
			},
			error:function(e){
				console.log('ajax Error ' + JSON.stringify(e));
			}
		})
	}

	function uidSearch(uidx){
		console.log("uidx = "+uidx);
		$("#searchSelect").val("m.idx");
		$("#search").val(uidx);
		checkForm(0);
	}
	
	let thisArray;
	function modalData(){
		let tableHTML = "";
		for(var i = 0; i < thisArray.length; i++){
			tableHTML += tr(td(thisArray[i].idx)+
					"<td style='cursor:pointer;' onclick=\"location.href='/wesell/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx="+thisArray[i].idx+"'\">"+thisArray[i].name+"</td>"+
							td(thisArray[i].isKyc != 0 ? "Y" : "N")+
							td(thisArray[i].wallet != 0 ? "Y" : "N")+
							td(thisArray[i].accumSum));
		}
		$("#modaltable").html(tableHTML);
	}
	function tr(text){
		return "<tr>"+text+"</tr>";
	}
	function td(text){
		return "<td>"+text+"</td>";
	}
	
	function modalSortChange(){
		console.log($("#modal_sort").val());
		switch($("#modal_sort").val()){
		case "0":
			thisArray.sort(function(a, b) {
				return ( a.name < b.name ) ? -1 : ( a.name == b.name ) ? 0 : 1;
			});
			break;
		case "1":
			thisArray.sort(function(a, b) {
				let aAccum = parseFloat(a.accumSum);
				let bAccum = parseFloat(b.accumSum);
				return bAccum - aAccum;
			});
			break;
		case "2":
			thisArray.sort(function(a, b) {
				let aIsKyc = parseFloat(a.isKyc);
				let bIsKyc = parseFloat(b.isKyc);
				return bIsKyc - aIsKyc;
			});
			break;
		case "3":
			thisArray.sort(function(a, b) {
				let aWallet = parseFloat(a.wallet);
				let bWallet = parseFloat(b.wallet);
				return bWallet - aWallet;
			});
			break;
		}
		modalData();
	}
	
	</script>
</body>
</html>