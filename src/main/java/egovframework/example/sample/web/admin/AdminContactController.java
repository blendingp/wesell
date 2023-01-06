package egovframework.example.sample.web.admin;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringEscapeUtils;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.classes.AdminUtil;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.QueryWait;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/admin/contact")
public class AdminContactController {
	
	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	
	@RequestMapping(value = "/contactList.do")
	public String contactList(HttpServletRequest request , Model model){
		String search = request.getParameter("search");
		String searchSelect = request.getParameter("searchSelect");
		String isp2p = request.getParameter("isp2p");
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
		in.put("search", search);
		in.put("searchSelect",searchSelect);
		in.put("isp2p",request.getParameter("isp2p"));
		pi.setTotalRecordCount((int)sampleDAO.select("selectContactListCnt",in));
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectContactList",in);
		model.addAttribute("project", Project.getPropertieMap());
		model.addAttribute("isp2p", isp2p);
		model.addAttribute("search", search);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		return "admin/contactList";
	}
	
	@RequestMapping(value="/contactDetail.do")
	public String contactDetail(HttpServletRequest request , Model model){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		EgovMap info = (EgovMap)sampleDAO.select("selectContactDetail",idx);
		if(!info.get("readYn").equals("Y")){
			sampleDAO.update("updateContactReadYn",idx);
		}
		if(info.get("fkey") != null && !info.get("fkey").toString().isEmpty()){
			model.addAttribute("fileList", sampleDAO.list("selectFileList" , info.get("fkey")));
		}
		model.addAttribute("info", info);
		List<EgovMap> list = (List<EgovMap>)sampleDAO.list("selectBoardSystemList");
		for(int i=0; i<list.size(); i++){
			list.get(i).put("bcontent", StringEscapeUtils.unescapeHtml4(list.get(i).get("bcontent").toString()));
		}
		model.addAttribute("systemlist", list);
		return "admin/contactDetail";
	}
	
	@ResponseBody
	@RequestMapping(value="/contactAnswer.do", produces = "application/json; charset=utf8")
	public String contactAnswer(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));		
		String answer = request.getParameter("answer");
		JSONObject obj = new JSONObject();
		if(answer == null || answer.isEmpty()){
			obj.put("result", "fail");
			obj.put("msg", "답변내용을 작성해주세요");
			return obj.toJSONString();
		}
		
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		EgovMap prev = (EgovMap)sampleDAO.select("selectContactDetail",in);
		String prevAnswer = ""+prev.get("answer");
		if(prevAnswer.compareTo("null")!=0 && !prevAnswer.isEmpty()){
			answer = ""+prev.get("answer") + "\n\n------------------------------------------------------------------------------------\n\n" + answer;
		}
		
		int uidx = Integer.parseInt(prev.get("uidx").toString());		
		
		in.put("answer", answer);
		sampleDAO.update("updateContactAnswer" , in);		
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.CONTACT_ANSWER, uidx, null, 1, null,null);
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/contactMailAnswer.do", produces = "application/json; charset=utf8")
	public String contactMailAnswer(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		String email = request.getParameter("email");
		String answer = request.getParameter("answer");
		JSONObject obj = new JSONObject();
		if(answer == null || answer.isEmpty()){
			obj.put("result", "fail");
			obj.put("msg", "답변내용을 작성해주세요");
			return obj.toJSONString();
		}
		
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		EgovMap prev = (EgovMap)sampleDAO.select("selectContactDetail",in);
		String prevAnswer = ""+prev.get("answer");
		if(prevAnswer.compareTo("null")!=0 && !prevAnswer.isEmpty()){
			answer = ""+prev.get("answer") + "\n\n------------------------------------------------------------------------------------\n\n" + answer;
		}
		
		int uidx = Integer.parseInt(prev.get("uidx").toString());	
		
		String isp2p = ""+prev.get("isp2p");
		String project = Project.getProjectName();
		if(isp2p.equals("true"))
			project = Project.getP2PSiteName();
		
		if(Send.sendMailContactAnswer(request, email, answer, project)){			
			obj.put("result", "success");
			
			//sampleDAO.update("updateContactAnswer" , in);
			//AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.CONTACT_ANSWER, uidx, null, 1, null,null);
		}else{			
			obj.put("result", "fail");
			obj.put("msg", "이메일이 없는 회원입니다. 이메일 발송 불가");
		}
		
		in.put("answer", answer);
		sampleDAO.update("updateContactAnswer" , in);		
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.CONTACT_ANSWER, uidx, null, 1, null,null);
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/contactAnswerSms.do", produces = "application/json; charset=utf8")
	public String contactAnswerSms(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		String country = request.getParameter("country");
		String phone = request.getParameter("phone");
		String answer = request.getParameter("answer");
		JSONObject obj = new JSONObject();
		if(answer == null || answer.isEmpty()){
			obj.put("result", "fail");
			obj.put("msg", "답변내용을 작성해주세요");
			return obj.toJSONString();
		}
		
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		EgovMap prev = (EgovMap)sampleDAO.select("selectContactDetail",in);
//		String prevAnswer = ""+prev.get("answer");
//		if(prevAnswer.compareTo("null")!=0 && !prevAnswer.isEmpty()){
//			answer = ""+prev.get("answer") + "\n\n------------------------------------------------------------------------------------\n\n" + answer;
//		}
		int uidx = Integer.parseInt(prev.get("uidx").toString());
		String isp2p = ""+prev.get("isp2p");
		String project = Project.getProjectName();
		if(isp2p.equals("true"))
			project = Project.getP2PSiteName();
		
		if(Send.sendMessageCheck(country, phone, answer, project)){
			obj.put("result", "success");
			in.put("answer", answer);
			sampleDAO.update("updateContactAnswer" , in);
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.CONTACT_ANSWER, uidx, null, 1, null,null);
		}else{
			obj.put("result", "fail");
			obj.put("msg", "문자 발송에 실패했습니다.");
		}
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/contactConfirm.do", produces = "application/json; charset=utf8")
	public String contactConfirm(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));

		EgovMap in = new EgovMap();
		in.put("idx", idx);
		EgovMap prev = (EgovMap)sampleDAO.select("selectContactDetail",in);
		int uidx = Integer.parseInt(prev.get("uidx").toString());
		
		JSONObject obj = new JSONObject();
		sampleDAO.update("updateContactConfirm",in);
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.CONTACT, uidx, null, 1, null,null);
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/contactDelete.do")
	public String contactDelete(HttpServletRequest request){
		String idxs = request.getParameter("idxs");
		String [] idxArray = idxs.split("\\:");
		EgovMap in = new EgovMap();
		for(int i = 0; i < idxArray.length; i++){
			in.put("idx", idxArray[i]);
			sampleDAO.delete("deleteContact",in);
		}
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.CONTACT, -1, null, 0, null,null);
		return "redirect:contactList.do";
	}
	
	@RequestMapping(value="/sendMessage.do")
	public String sendMessage(HttpServletRequest request , Model model){
		
		model.addAttribute("userlist",sampleDAO.list("selectAllMemberIdxWithName"));
		return "admin/sendMessage";
	}
	
	@ResponseBody
	@RequestMapping(value="/messageInsert.do" , produces = "application/json; charset=utf8")
	public String messageInsert(HttpServletRequest request , Model model){
		String useridx = request.getParameter("useridx");
		String title = request.getParameter("title");
		String text = request.getParameter("text");
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
		in.put("title", title);
		in.put("content", text);
		
		if(useridx.equals("0")){ //전체 쪽지 보내기
			synchronized (SocketHandler.members) {
				for(Member m : SocketHandler.members){
					EgovMap in2 = new EgovMap();
					in2.put("useridx", m.userIdx);
					in2.put("title", title);
					in2.put("content", text);
					QueryWait.pushQuery("insertMessage", m.userIdx, in2, QueryType.INSERT);
				}
			}
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.SEND_MESSAGE, -1, null, 1, null, null);
		}
		else{
			in.put("useridx", useridx);
			sampleDAO.insert("insertMessage" , in);
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.SEND_MESSAGE, Integer.parseInt(useridx), null, 1, null, null);
		}
		obj.put("result", "success");
		return obj.toJSONString();
	}
}
