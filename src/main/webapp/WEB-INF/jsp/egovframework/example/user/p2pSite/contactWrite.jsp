<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<jsp:include page="../../p2pSiteFrame/header.jsp"></jsp:include>
</head>
<body class="body">
	<div class="frame">
		<jsp:include page="../../p2pSiteFrame/top.jsp"></jsp:include>
		<div class="general_section wf-section">
			<div class="banner" style="background-image:url('/global/webflow/p2pImages/header_bg.png')">
				<div class="banner_warp">
					<img src="/global/webflow/p2pImages/header_art1.png" loading="lazy"
						srcset="/global/webflow/p2pImages/header_art1-p-500.png 500w, /global/webflow/p2pImages/header_art1.png 547w"
						sizes="(max-width: 479px) 100vw, 300px" alt="" class="banner_img">
					<div class="m_head_box">
						<h1 class="m_head">FAQ 및 고객센터</h1>
						<h2 class="m_head _3">
							운영시간: 09:00~18:00<br>
						</h2>
						<h4 class="m_head _2">문의사항을 남겨주시면 친절하게 답변해드리겠습니다.</h4>
					</div>
				</div>
			</div>
			<div class="general_block">
				<div class="deco"></div>
				<h1 class="general_title">문의하기</h1>
				<div class="inqury_box">
					<div class="form-block w-form">
						<form id="contactForm" name="contactForm" method="post" enctype="multipart/form-data">
							<div class="m_c_title">제목</div>
							<div class="write_box">
								<input type="text" class="text-field w-input" maxlength="100" name="title"  placeholder="제목을 입력하세요." id="title">
							</div>
							<div class="m_c_title">문의 내용</div>
							<div class="write_box">
								<textarea placeholder="내용을 입력하세요." maxlength="5000" id="content" name="content"  class="textarea w-input"></textarea>
							</div>
							<div class="file_block">
								<input type="file" name="files" accept="image/*;" id="files" multiple="" style="display: none;"> 
								<span onclick="$('#files').click();" class="btn w-button">파일 추가</span>
								<div class="file_uploadbox" id="fileList">
									<div class="file_box" id="notselect" style="display:flex;">
										<div>선택된 파일이 없습니다.</div>
										<div class="file_d_btn">
											<img src="/global/webflow/p2pImages/wx_black.png" loading="lazy" srcset="/global/webflow/p2pImages/wx_black-p-500.png 500w, /global/webflow/p2pImages/wx_black-p-800.png 800w, /global/webflow/p2pImages/wx_black-p-1080.png 1080w, /global/webflow/p2pImages/wx_black-p-1600.png 1600w, /global/webflow/p2pImages/wx_black.png 1600w" sizes="(max-width: 767px) 4vw, 20px" alt="" class="file_x_icon">
										</div>
									</div>
								</div>
							</div>
							<div class="bottom_btn">
								<a href="/global/easy/contactList.do" class="btn w-button">뒤로가기</a> 
								<a href="#" class="btn w-button" onclick="javascript:submitForm()">작성완료</a>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../../p2pSiteFrame/footer.jsp"></jsp:include>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6180a71858466749aa0b95bc" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="../js/webflow.js" type="text/javascript"></script>
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
	var fileIdx = 0;
	var fileList = [];
	$("input[name=files]").on("change",function() {
		var files = this.files;
		if (files.length > 5 || fileList.length >= 5) {
			alert("파일은 5개 이하로 첨부 가능합니다.");
			return;
		}
		Array.prototype.push.apply(fileList, files);
		var $fileList = $("#fileList");
		for (var i = 0; i < files.length; i++) {
			$("#notselect").css("display","none");
			
			$fileList.append("<div class='file_box'> <div>"+files[i].name+"</div> <div class='file_d_btn'><img src='/global/webflow/p2pImages/wx_black.png' loading='lazy' srcset='/global/webflow/p2pImages/wx_black-p-500.png 500w, /global/webflow/p2pImages/wx_black-p-800.png 800w, /global/webflow/p2pImages/wx_black-p-1080.png 1080w, /global/webflow/p2pImages/wx_black-p-1600.png 1600w, /global/webflow/p2pImages/wx_black.png 1600w' sizes='(max-width: 767px) 4vw, 20px' alt='' onclick='delFile(this)' class='file_x_icon'></div> </div>");
// 			$fileList.append("<div class='fileselect_block'> <div class='fileselect1'> <div class='text7' style='overflow: hidden; text-overflow:ellipsis;  width: 510px;'>"+files[i].name+"</div> </div> <div class='deletebtn_box'> <img src='/global/webflow/images/wx.png' loading='lazy' sizes='(max-width: 479px) 100vw, (max-width: 767px) 4vw, 20px' srcset='/global/webflow/images/wx-p-800.png 800w, /global/webflow/images/wx-p-1080.png 1080w, /global/webflow/images/wx.png 1600w' alt='' class='deletebtn_icon'> <a href='#' onclick='delFile(this)' class='deletebtn w-button'></a> </div> </div>");
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
			url : '/global/easy/contactInsert.do',
			data : data,
			processData : false,
			contentType : false,
			success : function(data) {
				if (data.result != 'fail') {
					alert("문의 접수가 완료되었습니다.");
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
</body>
</html>