package egovframework.example.sample.web.admin;

import java.io.File;
import java.io.PrintWriter;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.example.sample.classes.AdminUtil;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/0nI0lMy6jAzAFRVe0DqLOw/board")
public class AdminBoardController {

	@Resource(name="sampleDAO")
	SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;
	
	@Resource(name = "fileProperties")
	private Properties fileProperties;
	
	@RequestMapping(value="/{type}List.do")
	public String boardList(@PathVariable("type") String type,HttpServletRequest request , Model model){
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(20);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("bcategory", type);
		pi.setTotalRecordCount((int)sampleDAO.select("selectBoardListCnt",in));
		model.addAttribute("list", sampleDAO.list("selectBoardList",in));
		model.addAttribute("pi", pi);
		model.addAttribute("type", type);
		return "admin/boardList";
	}
	
	@RequestMapping(value="/{type}Write.do")
	public String boardWrite(@PathVariable("type") String type,HttpServletRequest request , Model model){
		model.addAttribute("type", type);
		model.addAttribute("project", Project.getPropertieMap());
		return "admin/boardWrite";
	}
	
	@ResponseBody
	@RequestMapping(value="/{type}Insert.do" , produces = "application/json; charset=utf8")
	public String boardInsert(@PathVariable("type") String type,HttpServletRequest request , Model model){
		HttpSession session = request.getSession();
		String title = request.getParameter("title");
		String text = request.getParameter("text");
		String bwhere = request.getParameter("bwhere");
		String blang = request.getParameter("blang");
		JSONObject obj = new JSONObject();
		if(title == null || title.trim().equals("")){
			obj.put("result", "fail");
			obj.put("msg", "제목을 입력해주세요.");
			return obj.toJSONString();
		}
		if(text == null || text.trim().replaceAll(" ", "").replaceAll("&amp;nbsp;", "").equals("")){
			obj.put("result", "fail");
			obj.put("msg", "내용을 입력해주세요.");
			return obj.toJSONString();
		}
		EgovMap in = new EgovMap();
		in.put("btitle", title);
		in.put("buseridx", session.getAttribute("adminIdx"));
		in.put("bcontent", text);
		in.put("bcategory", type);
		in.put("bwhere", bwhere);
		in.put("blang", blang);
		sampleDAO.insert("insertBoard" , in);
		
		AdminLog log = null;
		switch(type){
		case "notice": log = AdminLog.INSERT_NOTICE; break;
		case "faq": log = AdminLog.INSERT_FAQ; break;
		case "event": log = AdminLog.INSERT_EVENT; break;
		}
		if(log == null){
			Log.print(type+" 등록 중 에러.", 1, "err");
			return obj.toJSONString();
		}
		
		AdminUtil.insertAdminLog(request, sampleDAO, log, -1, null, 1, null,null);
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/{type}Detail.do")
	public String boardDetail(@PathVariable("type") String type,HttpServletRequest request , Model model){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		EgovMap info = (EgovMap)sampleDAO.select("selectBoardDetail",idx);
		model.addAttribute("type", type);
		model.addAttribute("project", Project.getPropertieMap());
		model.addAttribute("info", info);
		model.addAttribute("type", type);
		return "admin/boardDetail";
	}
	
	@ResponseBody
	@RequestMapping(value="/{type}Update.do" , produces = "application/json; charset=utf8")
	public String boardUpdate(@PathVariable("type") String type,HttpServletRequest request , Model model){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		String title = request.getParameter("title");
		String text = request.getParameter("text");
		String bwhere = request.getParameter("bwhere");
		String blang = request.getParameter("blang");
		String bdate = request.getParameter("bdate");
		JSONObject obj = new JSONObject();
		if(title == null || title.trim().equals("")){
			obj.put("result", "fail");
			obj.put("msg", "제목을 입력해주세요.");
			return obj.toJSONString();
		}
		if(text == null || text.trim().replaceAll(" ", "").replaceAll("&amp;nbsp;", "").equals("")){
			obj.put("result", "fail");
			obj.put("msg", "내용을 입력해주세요.");
			return obj.toJSONString();
		}
		EgovMap in = new EgovMap();
		in.put("bidx", idx);
		in.put("btitle", title);
		in.put("bcontent", text);
		in.put("bwhere", bwhere);
		in.put("blang", blang);
		in.put("bdate", bdate);
		sampleDAO.update("updateBoard" , in);
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/{type}Delete.do" , produces = "application/json; charset=utf8")
	public String boardDelete(@PathVariable("type") String type,HttpServletRequest request){
		EgovMap in = new EgovMap();
		JSONObject obj = new JSONObject();
		String result = "success";
		//게시글 삭제처리 
		String delList = request.getParameter("delArray");
		String[] delArray = delList.split("-");
		if(delArray != null && delArray.length > 0){
			for(int i=0; i<delArray.length; i++){
				in.put("idx", delArray[i]);
				sampleDAO.delete("deleteBoard" , in);
			}
			result = "success";
		}else{
			result = "nothing";
		}
		AdminLog log = null;
		switch(type){
		case "notice": log = AdminLog.INSERT_NOTICE; break;
		case "faq": log = AdminLog.INSERT_FAQ; break;
		case "event": log = AdminLog.INSERT_EVENT; break;
		}
		if(log == null){
			Log.print(type+" 삭제 중 에러.", 1, "err");
			return obj.toJSONString();
		}
		
		AdminUtil.insertAdminLog(request, sampleDAO, log, -1, null, 0, null,null);
		obj.put("result", result);
		return obj.toJSONString();
	}
	
	@RequestMapping(value = "/editorFileUpload.do") // attach_photo.js 에 설정한 업로드 경로 
	public void editorFileUpload(MultipartHttpServletRequest mre,HttpServletRequest request, ModelMap model , HttpServletResponse response) throws Exception {
		System.out.println("editorFileUpload");
	    try {
	         String sFileInfo = "";
	         String filename = mre.getFile("file").getOriginalFilename();
	         String filename_ext = filename.substring(filename.lastIndexOf(".")+1);
	         filename_ext = filename_ext.toLowerCase();
	         String dftFilePath = fileProperties.getProperty("file.editor.upload");
	         String filePath = dftFilePath;  // 서버 업로드 경로 
	         File file = new File(filePath);
	         if(!file.exists()) {
	            file.mkdirs();
	         }
	         String realFileNm = "";
	         realFileNm = UUID.randomUUID().toString().replaceAll("-", "") + filename.substring(filename.lastIndexOf("."));
	         String rlFileNm = filePath + realFileNm;
	         ///////////////// 서버에 파일쓰기 /////////////////
	         MultipartFile mf = mre.getFile("file");
	         mf.transferTo(new File(rlFileNm));
	         // 정보 출력
	         sFileInfo += "&bNewLine=true";
	         sFileInfo += "&sFileName="+ realFileNm;;
	         sFileInfo += "&sFileURL=/filePath/wesell/editor/"+realFileNm; //에디터 이미지 나타낼 소스 경로
	         PrintWriter print = response.getWriter();
	         print.print(sFileInfo);
	         print.flush();
	         print.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
	@ResponseBody
	@RequestMapping(value = "/askCheck.do", produces="application/json; charset=utf8")
	public String askCheck(HttpServletRequest request) throws Exception {		
		JSONObject obj = new JSONObject();
		EgovMap ask = (EgovMap)sampleDAO.select("selectNonReadContact");
		if(ask != null){
			obj.put("result", "ask");
		}else{
			obj.put("result", "null");
		}
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/eventBanner.do")
	public String eventBanner(HttpServletRequest request , Model model){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		EgovMap list = (EgovMap)sampleDAO.list("selectEventBannerList");
		model.addAttribute("list", list);
		return "admin/boardDetail";
	}
}
