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
</style>
<script>
function page(pageNo){
	document.listForm.fileDown.value = "0";
	document.listForm.pageIndex.value = pageNo;
   	document.listForm.submit();
}
</script>
<body id="page-top">
	<div id="wrapper">
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
		<div id="content-wrapper">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
		        <div class="container-fluid">
		            <h1 class="h3 mb-2 text-gray-800">P2P 입출금 정산</h1>
		            <div class="row">
		                <div class="col-lg-12">
		                    <div class="panel panel-default">
		                        <div class="panel-body">
								   	<form action="/global/0nI0lMy6jAzAFRVe0DqLOw/p2p/dwCalculate.do" name="listForm" id="listForm">
										<div class="row">
											<input type="hidden" name="test" id="test" value="${test}"/>
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
<!-- 												<div class="form-group input-group"> -->
<!-- 													<select id="searchSelect" name="searchSelect" class="form-control "> -->
<!-- 														<option value="name" selected="">회원명</option> -->
<!-- 														<option value="email">이메일</option> -->
<!-- 														<option value="inviteCode">InviteCode</option> -->
														
<!-- 															<option value="inviteMem">InviteCode 직속하위</option> -->
<!-- 															<option value="inviteMemAll">InviteCode 하위(전체)</option> -->
														
<!-- 														<option value="idx">UID</option> -->
<!-- 														<option value="phone">전화번호</option> -->
<!-- 														<option value="destinationTag">리플 태그번호</option> -->
<!-- 													</select> -->
<!-- 													<input type="text" name="search" class="form-control" value="">  -->
<!-- 													<button class="btn btn-default" style="padding: 6px 12px;" type="submit"> <i class="fa fa-search"></i> </button> -->
<!-- 												</div> -->
												<div class="form-group input-group">
													<select id="searchSelect" name="searchSelect" class="form-control">
														<option value="m.name"<c:if test="${searchSelect eq 'm.name'}">selected</c:if>>회원명</option>
			 											<option value="m.email"<c:if test="${searchSelect eq 'm.email'}">selected</c:if>>이메일</option>
			 											<option value="m.phone"<c:if test="${searchSelect eq 'm.phone'}">selected</c:if>>휴대폰</option>
														<option value="m.inviteCode"<c:if test="${searchSelect eq 'm.inviteCode'}">selected</c:if>>InviteCode</option>
		 												<option value="m.idx"<c:if test="${searchSelect eq 'm.idx'}">selected</c:if>>UID</option> 
													</select>
		 											<input type="text" name="search" class="form-control" value="${search}" style="width:auto;"> 
													<button class="btn btn-default" style="padding: 6px 12px;" onclick="checkForm()" type="button"> <i class="fa fa-search"></i> </button>
												</div>
											</div>
											<div class="col-lg-2">
												<label>테스트계정</label>
												<div class="form-group input-group">
													<span class="input-group-btn">
														<button class="btn btn-danger btn-xs" style="padding: 6px 7px;" onclick="setTest('test')" type="button">미포함</button>
														<button class="btn btn-info btn-xs" style="padding: 6px 7px;" onclick="setTest('')" type="button">포함</button>
													</span>
												</div>
											</div>
										</div>
									</form>
									<div class="card shadow mb-4">
		                                <table class="table">
		                                    <thead>
		                                        <tr>
		                                            <th style="width:10%;">&ensp;&ensp;UID</th>
		                                            <th>분류</th>
		                                            <th>이름</th>
		                                            <th>직속 상위</th>
		                                            <th>전화번호</th>
		                                            <th>회원가입 날짜</th>
		                                            <th>총 입금</th>
		                                            <th>총 출금</th>
		                                            <th>차액</th>
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
	        </div>
        </div>
	</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
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

function setTest(val){
	$("#test").val(val);
	checkForm();
}

function checkForm(position, file){
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
	$("#listForm").submit();
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
		location.href="/global/0nI0lMy6jAzAFRVe0DqLOw/user/userDetail.do?idx="+uidx;
	});
	
	$.each($(".childblock"), function(index, item){
		var idx = $(item).attr("pidx");
		var dSum = 0;
		var wSum = 0;
		
		$.each($(item).children(".influ_tablelcontent").find(".dSum"), function(index, j){
			dSum += Number($(j).text());
		});
		$.each($(item).children(".influ_tablelcontent").find(".wSum"), function(index, j){
			wSum += Number($(j).text());
		});
		
		var pblock=$(".influ_tablelcontent.pidx"+idx);
		var rate = pblock.find(".resultblock").attr("rate");
		var pdSum = Number(pblock.find(".dSum").text());
		var pwSum = Number(pblock.find(".wSum").text());
		
		pblock.find(".dSum").text(dSum+pdSum);
		pblock.find(".wSum").text(wSum+pwSum);
		pblock.find(".resultblock").text((dSum+pdSum)-(wSum+pwSum));
		
		rank = getRank(idx);
		if(rank>=0){
			pblock.addClass("rank"+rank);
			pblock.children(".linkname").addClass("rank"+rank);			
		}
	});
	
	if("${searchSelect}" == "m.idx"){
		parentsSpread("${search}");
	}
});
function appendChild(parentsIdx){
	parentsIdx = Number(parentsIdx);
	for(var i = 0; i < child.array.length; i++){
		if(Number(child.array[i].parentsIdx)==parentsIdx){
			var level = "유저";
			var result = "원";
			var toggle="";
			var color="";
			if(child.array[i].level=="chong"){
				level = "총판"
				toggle = "<span class='tArrow"+child.array[i].idx+"'>▼</span>&ensp;";
			}
			
			var name=child.array[i].name;
			var phone=child.array[i].phone;
			
			let date = new Date(child.array[i].joinDate);
			date = timeFormat(date);
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
				space+toggle+child.array[i].idx+"</td> <td>"+
				level+"</td> <td class='linkname' style='background-color:transparent;"+
				color+";cursor:pointer;'>"+
				name+"</td> <td>"+
				pname+"</td> <td>"+
				phone+"</td> <td>"+
				date+"</td> <td><span class='dSum'>"+
				child.array[i].dSum+"</span>원</td> <td><span class='wSum'>"+
				child.array[i].wSum+"</span>원 </td> <td><span class='resultblock'>"+
				(Number(child.array[i].dSum)-Number(child.array[i].wSum))+"</span>"+
				result+"</td> </tr>";
				
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
</script>
</body>
</html>