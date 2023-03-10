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
<title><spring:message code="menu.submitrequest" /></title>
<meta content="account setting" property="og:title">
<meta content="account setting" property="twitter:title">
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
</head>
<body class="body">
	<div class="frame">
		<form id="contactForm" name="contactForm" method="post" enctype="multipart/form-data" class="form-6">
			<jsp:include page="../wesellFrame/top2.jsp" />
			<div class="frame5">
				<jsp:include page="../userFrame/customerBanner.jsp"></jsp:include>
				<div class="custermer_listblock">
					<div class="custermer_titlewarp">
						<div class="title6"><spring:message code="submitRequest" /></div>
 					</div>
					<div class="form-block-6 w-form">
						<input type="text" value="${ title}" class="text-field-11 w-input" maxlength="100" name="title"  placeholder="<spring:message code="support.subject" />" id="title">
						<textarea placeholder="<spring:message code="support.description" />" maxlength="5000" id="content" name="content"  class="textarea w-input"></textarea>
						<div class="title2"><spring:message code="support.image" /></div>
						<div class="fileblock">
							<input type="file" name="files" accept="image/*;" id="files" multiple="" style="display: none;"> 
							<span onclick="$('#files').click();" class="button-11 w-button"><spring:message code="support.addFile" /></span>
							<div class="file_uploadbox" id="fileList">
								<div class="fileselect_block" id="notselect" style="display:flex;">
									<div class="fileselect1">
										<div class="text7"><spring:message code="menu.fileNoSelect"/></div>
									</div>
									<div class="deletebtn_box">
										<img src="/wesell/webflow/images2/wx.png" loading="lazy" sizes="(max-width: 479px) 100vw, (max-width: 767px) 4vw, 20px" srcset="/wesell/webflow/images2/wx-p-800.png 800w, /wesell/webflow/images2/wx-p-1080.png 1080w, /wesell/webflow/images2/wx.png 1600w" alt="" class="deletebtn_icon">
										<a href="#" class="deletebtn w-button"></a>
									</div>
								</div>
							</div>
						</div>
						<button type="button" onclick="javascript:submitForm()" class="submit-button-3 w-button"><spring:message code="support.submit" /></button>
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
	var fileIdx = 0;
	var fileList = [];
	$("input[name=files]").on("change",function() {
		var files = this.files;
		if (files.length > 5 || fileList.length >= 5) {
			alert("<spring:message code='menu.fileupFail'/>");
			return;
		}
		Array.prototype.push.apply(fileList, files);
		var $fileList = $("#fileList");
		for (var i = 0; i < files.length; i++) {
			$("#notselect").css("display","none");
			$fileList.append("<div class='fileselect_block'> <div class='fileselect1'> <div class='text7' style='overflow: hidden; text-overflow:ellipsis;  width: 510px;'>"+files[i].name+"</div> </div> <div class='deletebtn_box'> <img src='/wesell/webflow/images2/wx.png' loading='lazy' sizes='(max-width: 479px) 100vw, (max-width: 767px) 4vw, 20px' srcset='/wesell/webflow/images2/wx-p-800.png 800w, /wesell/webflow/images2/wx-p-1080.png 1080w, /wesell/webflow/images2/wx.png 1600w' alt='' class='deletebtn_icon'> <a href='#' onclick='delFile(this)' class='deletebtn w-button'></a> </div> </div>");
			fileIdx++;
		}
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
		var form = $("#contactForm")[0];
		var data = new FormData(form);
		for (var i = 0; i < fileList.length; i++) {
			data.append("uploadFiles", fileList[i]);
		}
		$.ajax({
			type : 'post',
			url : '/wesell/contactInsert.do',
			data : data,
			processData : false,
			contentType : false,
			success : function(data) {
				if (data.result != 'fail') {
					alert("<spring:message code='menu.inquiryComplete'/>");
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