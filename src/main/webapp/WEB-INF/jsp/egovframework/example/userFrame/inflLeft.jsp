<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<div class="influ_block2">
	<!-- <div class="pop_exist" onclick="$('.influ_block2 , .mobbackdark').css('display' , 'none');">
		<img src="/wesell/webflow/images/close.png" loading="lazy" alt="" class="image-38">
	</div> -->
	<div class="influ_logo">
		<img src="/wesell/webflow/images/sub_logo1.svg" loading="lazy" alt="" class="image-47">
	</div>
	<div class="influ_linkbox">
		<div class="link_boxwarp">
			<img src="/wesell/webflow/images/link_bitocean.svg" loading="lazy" alt="" class="image-49"> 
			<a href="javascript:inviteCodeCopy()" class="link-3">나의 초대 링크</a>
			<input type="hidden" id="invite"/>
		</div>
	</div>
	<div class="influ_sidebtnbox">
		<a href="/wesell/infl/memberlist.do" class="button-25 <c:if test="${refPage == 'memberlist'}">click</c:if> w-button">유저 관리</a>
		<div class="influ_sidebtndeco"></div>
	</div>
	<div class="influ_sidebtnbox">
		<a href="/wesell/infl/chonglist.do" class="button-25 <c:if test="${refPage == 'chonglist'}">click</c:if> w-button">총판 관리</a>
		<div class="influ_sidebtndeco"></div>
	</div>
	<div class="influ_sidebtnbox">
		<a href="/wesell/infl/transactionHistory.do" class="button-25 <c:if test="${refPage == 'transactions'}">click</c:if> w-button">거래 관리</a>
		<div class="influ_sidebtndeco"></div>
	</div>
	<!-- 	<div class="influ_sidebtnbox"> -->
<%-- 		<a href="/wesell/infl/referral.do" class="button-25 <c:if test="${refPage == 'referral'}">click</c:if> w-button">커미션 관리</a> --%>
<!-- 		<div class="influ_sidebtndeco"></div> -->
<!-- 	</div> -->
	<div class="influ_sidebtnbox">
		<a href="/wesell/infl/accum.do" class="button-25 <c:if test="${refPage == 'accum'}">click</c:if> w-button">정산</a>
		<div class="influ_sidebtndeco"></div>
	</div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
window.onresize = function(e){
	if(window.innerWidth > 767){
		$('.mobbackdark').css('display' , 'none');
		$('.influ_block2').css('display' , 'block');
	}else{
		$('.mobbackdark').css('display' , 'none');
		$('.influ_block2').css('display' , 'none');
	}
}
getInviteCode();
function getInviteCode(){
	$.ajax({
		type:'post',
		url:'/wesell/infl/getInviteCode.do',
		success:function(data){
			$("#invite").val("https://bitocean-global.com/wesell/join.do?invi="+data.invite);
		}
	})
}

function inviteCodeCopy(){
	$("#invite").attr("type","text");
	$("#invite").select();
	document.execCommand('Copy');
	$("#invite").attr("type","hidden");
	alert("클립보드에  복사되었습니다 ");
}
</script>
</html>