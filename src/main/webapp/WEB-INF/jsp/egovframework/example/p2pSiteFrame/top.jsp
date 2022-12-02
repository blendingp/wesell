<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<div class="top">
	<div class="top_block">
		<a href="/global/easy/p2pmain.do" class="logo_link w-inline-block"><img src="/global/webflow/p2pImages/LOGO_green2.svg" loading="lazy" alt="" class="logo"></a>
		<c:if test="${empty p2pUserIdx}">
			<a href="/global/easy/login.do" class="login_btn w-button">로그인</a>
		</c:if>
		<c:if test="${!empty p2pUserIdx}">
			<a href="javascript:logout()" class="login_btn w-button">로그아웃</a>
			<a href="/global/easy/p2pOrders.do" class="login_btn _2 w-button">마이페이지</a>
		</c:if>
		<div class="top_btn_warp">
<!-- 			<div class="top_btn3"> -->
<!-- 				<img src="/global/webflow/p2pImages/er_icon.svg" loading="lazy" alt="" -->
<!-- 					class="top_menu_icon"> -->
<!-- 			</div> -->
<!-- 			<div class="top_drop"> -->
<!-- 				<a href="#" class="lang_btn w-button">EN</a>  -->
<!-- 				<a href="#" class="lang_btn w-button">KR</a> -->
<!-- 			</div> -->
		</div>
	</div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript">
// 	var lang = "${lang}";
	
	function logout() {
		$.ajax({
			type : 'post',
			url : '/global/easy/logoutProcess.do',
			success : function(data) {
				if (data.result == 'suc') {
					location.href = "/global/easy/login.do";
				}
			}
		})
	}
	
// 	function changeLang2(lang) {
// 		if(lang == "null")
// 			lang = "EN";
		
// 		$.ajax({
// 			type : 'post',
// 			url : '/global/changeLanguage.do?lang=' + lang,
// 			success : function(data) {
// 				location.reload(true);
// 			}
// 		});
// 	}
	
	function toFixedDown(val,fix){
		if(isNaN(val)) return 0;
		
		var minus = false;
		if(val < 0)
			minus = true;
		
		var num = 1;
		for(var i = 0; i < parseFloat(fix); i++){
			num *= 10;
		}
		const temp1 = (Number(val) + Number.EPSILON) * num; 
		const temp2 = Math.floor(Math.abs(temp1));
		var result = temp2 / num;
		
		if( result < 1 / num)
			result = 0;
		if(minus)
			result *= -1;
		return result.toFixed(fix);
	}
	
	function datePickerLangSet(){
		$.datepicker.setDefaults({
	        dateFormat: 'yymmdd',
	        prevText: '이전 달',
	        nextText: '다음 달',
	        monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	        monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	        dayNames: ['일', '월', '화', '수', '목', '금', '토'],
	        dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
	        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
	        showMonthAfterYear: true,
	        yearSuffix: '년'
	    });
		$(function() {
		    $('.ui-datepicker').addClass('notranslate');
		});
	}
	
	function fmtNum(num) {
		if (num == null)
			return 0;
		num = String(num);
		if (num.length <= 3)
			return num;

		let decimalv = "";

		if (num.indexOf(".") != -1) {
			let numarr = num.split(".");
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
	function SetNum(obj) {
		val = obj.value;
		re = /[^0-9]/gi;
		obj.value = val.replace(re, "");
	}
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
</script>
</html>