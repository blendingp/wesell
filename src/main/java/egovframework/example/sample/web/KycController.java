package egovframework.example.sample.web;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringEscapeUtils;
import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class KycController {
	
	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;
	
	@Resource(name = "fileProperties")
	private Properties fileProperties;
	
	@RequestMapping(value="/vAccount.do")
	public String vAccount(HttpServletRequest request, ModelMap model){
		HttpSession session = request.getSession();
		int uidx = Integer.parseInt(session.getAttribute("userIdx").toString());
		
		Member mem = Member.getMemberByIdx(uidx);
		if(mem.vConfirm){
			return "redirect:user/main.do";
		}
		return "user/vAccount";
	}
	
	@ResponseBody
	@RequestMapping(value="/vAccountUpdate.do" , produces = "application/json; charset=utf8")
	public String vAccountUpdate(HttpServletRequest request){
		JSONObject obj = new JSONObject();

		obj.put("result", "fail");
		HttpSession session = request.getSession();
		String uidx = session.getAttribute("userIdx").toString();
		try {
			String vAccount = request.getParameter("vAccount").toString();
			String vBank = request.getParameter("vBank").toString();
			EgovMap in = new EgovMap();
			in.put("vAccount", vAccount);
			in.put("vBank", vBank);
			in.put("userIdx", uidx);
			sampleDAO.update("updateMemberVAccount" , in);
			obj.put("msg", Message.get().msg(messageSource, "join.vSubmit", request));
			obj.put("result", "suc");
			
		} catch (Exception e) {
			obj.put("msg", Message.get().msg(messageSource, "pop.requestFail", request));
			// TODO: handle exception
		}
		
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/user/kycCenter.do")
	public String kycCenter(HttpServletRequest request, ModelMap model){
		HttpSession session = request.getSession();
		int uidx = Integer.parseInt(session.getAttribute("userIdx").toString());
		
		Member mem = Member.getMemberByIdx(uidx);
		if(mem.isKyc){
			return "redirect:main.do";
		}
		
		EgovMap user = (EgovMap)sampleDAO.select("selectMemberDetail",uidx);
		model.addAttribute("fkey", user.get("fkey"));
		model.addAttribute("phone", mem.phone);
		model.addAttribute("emailconfirm", user.get("emailconfirm"));
		model.addAttribute("email", user.get("email"));
		model.addAttribute("nowpage", "kyc");
		return "board/kycCenter";
	}
	
	@ResponseBody
	@RequestMapping(value="/kycDataUpdate.do" , produces = "application/json; charset=utf8")
	public String kycDataUpdate(MultipartHttpServletRequest request){
		List<MultipartFile> files = request.getFiles("uploadFiles");
		JSONObject obj = new JSONObject();

		HttpSession session = request.getSession();
		String uidx = session.getAttribute("userIdx").toString();
		Member mem = Member.getMemberByIdx(Integer.parseInt(uidx));
		
		EgovMap in = new EgovMap();
		in.put("uidx", uidx);
		in.put("userIdx", uidx);
		if(files.size() > 0){
			String fkey = UUID.randomUUID().toString().replaceAll("-", "");
			in.put("fkey", fkey);
			String path = fileProperties.getProperty("file.photo.upload");
			File file = new File(path);
			if(!file.exists()){
				file.mkdirs();
			}
			for(int i=0; i<files.size(); i++){
				if(!files.get(i).isEmpty()){
					String fileNm = files.get(i).getOriginalFilename();
					String saveNm = UUID.randomUUID().toString().replaceAll("-", "") + fileNm.substring(fileNm.lastIndexOf("."));
					try {
						files.get(i).transferTo(new File(path+saveNm));
						in.put("originNm", fileNm);
						in.put("saveNm" ,saveNm);
						sampleDAO.insert("insertFile",in);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			sampleDAO.update("updateKyc" , in);
			
			Send.sendAdminMsg(mem,"kyc 인증 신청이 들어왔습니다.");
			obj.put("result", "success");
		}else{
			Log.print(mem.getName()+" 유저 kyc인증 파일 없이 접근. 스크립트 조작 의심", 1, "err_notsend");
			obj.put("result", "fail");
			obj.put("msg", "The request failed.");
		}
		return obj.toJSONString();
	}
}
