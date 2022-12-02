<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<!--  Last Published: Tue Jun 29 2021 05:48:49 GMT+0000 (Coordinated Universal Time)  -->
<html data-wf-page="62b186c2f7e8877e2d12526e" data-wf-site="62b1125ac4d4d60ab9c62f81">
<head>
<meta charset="utf-8">
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
</head>
<style>
.text7{
	overflow: hidden; 
	text-overflow:ellipsis; 
}
</style>
<body class="body1">
	<div class="frame">
		<form id="kycForm" name="kycForm" method="post" enctype="multipart/form-data" class="form-6">
			<jsp:include page="../wesellFrame/top2.jsp" />
			<div class="frame5">
				<jsp:include page="../userFrame/customerBanner.jsp"></jsp:include>
				<div class="custermer_listblock">
					<div class="custermer_titlewarp">
						<div class="title6"><spring:message code="support.kyc_1st"/></div>
					</div>
					<div class="form-block-6 w-form">
						<div class="title2"><spring:message code="support.kyc_1st"/></div>
						<div class="fileblock">
							<div class="authbtn_area">
								<div class="auth_filetxt">1. <spring:message code="support.id_f"/></div>
								<div class="auth_filetxt">2. <spring:message code="support.id_b"/></div>
								<div class="auth_filetxt">3. <spring:message code="support.selfcamera"/></div>
							</div>
							<input type="file" accept="image/*;" id="files0" style="display: none;" capture="camera"> 
							<input type="file" accept="image/*;" id="files1" style="display: none;" capture="camera"> 
							<input type="file" accept="image/*;" id="files2" style="display: none;" capture="camera"> 
							<div class="authbtn_area">
								<a href="#" onclick="fileClick(0)" class="button-11 w-button"><spring:message code="support.addFile" /></a> 
								<a href="#" onclick="fileClick(1)" class="button-11 w-button"><spring:message code="support.addFile" /></a> 
								<a href="#" onclick="fileClick(2)" class="button-11 w-button"><spring:message code="support.addFile" /></a>
							</div>
							<div class="file_uploadbox kyc" id="fileList">
								<div class="fileselect_block">
									<div class="fileselect1">
										<div class="text7 filetext0"><spring:message code="menu.fileNoSelect"/></div>
									</div>
								</div>
								<div class="fileselect_block">
									<div class="fileselect1">
										<div class="text7 filetext1"><spring:message code="menu.fileNoSelect"/></div>
									</div>
								</div>
								<div class="fileselect_block">
									<div class="fileselect1">
										<div class="text7 filetext2"><spring:message code="menu.fileNoSelect"/></div>
									</div>
								</div>
							</div>
						</div>
						<div class="p2p_c_warn">
							<div class="text-block-59"><spring:message code="support.kyc_1"/></div>
							<div>
								<spring:message code="support.kyc_2"/> <span class="colortxt"><spring:message code="support.kyc_3"/>
								</span><spring:message code="support.kyc_4"/><br>
								<span class="warn"><spring:message code="support.kyc_5"/></span><br>
								<br><spring:message code="support.kyc_6"/> <spring:message code="support.kyc_7"/>
							</div>
						</div>
						<label class="w-checkbox privacy_check">
							<input type="checkbox" id="calAgree" class="w-checkbox-input checkbox-5">
							<span class="w-form-label" for="calAgree"><spring:message code="join.calAgree"/></span>
						</label>
						<input type="button" onclick="submitForm()" value="<spring:message code='support.submit' />" class="submit-button-3 w-button">
					</div>
				</div>

			</div>
			<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
		</form>
	</div>
	<script
		src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=615fe8348801178bd89ede05"
		type="text/javascript"
		integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
		crossorigin="anonymous"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
</body>
<script>
	let uploading = false;
	var fileIdx = 0;
	var fileList = [null,null,null]; // 개수 고정으로.
	let clicknum = 0;
	function fileClick(num){
		clicknum = num;
		$('#files'+num).click();
	}
	$("[id*=files]").on("change",function() {		
		var file = this.files;
		fileList[clicknum] = file[0];
		$(".filetext"+clicknum).text(file[0].name);
	});
	function SetNum(obj) {
		val = obj.value;
		re = /[^0-9]/gi;
		obj.value = val.replace(re, "");
	}
	function delFile(self) {
		var $file = $(self).parent().parent();
		var fileIdx = $file.index()-1;
		$file.remove();
		fileList.splice(fileIdx, 1);
		if(fileList.length == 0)
			$("#notselect").css("display","flex");
	}
	function submitForm() {
		if(!$("#calAgree").is(":checked")){
			alert("<spring:message code='join.calAgree_msg'/>");
			return false;
		}
		
		var form = $("#kycForm")[0];
		var data = new FormData(form);
		for (var i = 0; i < fileList.length; i++) {
			if(fileList[i] == null) {
				alert("<spring:message code='support.kyc_checkFile'/>");
				return;
			}			
			data.append("uploadFiles", fileList[i]);
		}

		if(uploading) return;
		uploading = true;
		
		$.ajax({
			type : 'post',
			url : '/wesell/kycDataUpdate.do',
			data : data,
			processData : false,
			contentType : false,
			success : function(data) {
				uploading = false;
				if (data.result != 'fail') {
					alert("<spring:message code='support.kyc_complete'/>");
					location.reload();
					
				} else {
					alert(data.msg);
				}
			},
			error : function(e) {
				console.log('ajaxError' + JSON.stringify(e));
			}
		})
	}
</script>
</html>