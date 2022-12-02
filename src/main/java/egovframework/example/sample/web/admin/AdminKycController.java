package egovframework.example.sample.web.admin;

import java.util.ArrayList;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.classes.AdminUtil;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.Wallet;
import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping("/0nI0lMy6jAzAFRVe0DqLOw/user")
public class AdminKycController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;
	
	@ResponseBody
	@RequestMapping(value="/kycConfirm.do" , produces="application/json; charset=utf8")
	public String kycConfirm(HttpServletRequest request){
		String idx = request.getParameter("idx");
		String confirm = request.getParameter("confirm");
		JSONObject obj = new JSONObject();
		EgovMap in = new EgovMap();
		in.put("userIdx", idx);
		
		EgovMap mem = (EgovMap)sampleDAO.select("selectMemberByIdx",in);

		Member member = Member.getMemberByIdx(Integer.parseInt(idx));
		if(confirm.equals("2")){
			String text = ""+request.getParameter("text");
			Send.sendMessageCheck(mem.get("country").toString(), mem.get("phone").toString(), text);
//			obj.put("msg", "문자 전송이 완료되었습니다.");
//			return obj.toJSONString();
		}
		
		int cf = 0;
		if(Boolean.parseBoolean(confirm))
			cf = 1;
		in.put("confirm", cf);
		sampleDAO.update("updateKyc" , in);
		member.isKyc = Boolean.parseBoolean(confirm);
		
		if(member.isKyc){
			int gift = Project.getKycGift();
			if(gift != 0)
				Wallet.updateWallet(member, member.getWallet() + gift, gift, "futures", "+", "event");
			
			Send.sendMessageCheck(mem.get("country").toString(), mem.get("phone").toString(), "KYC authentication approved");
		}
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_KYC, member.userIdx, null, cf, null, null);
		obj.put("msg", "변경완료되었습니다.");
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/kycInfo.do")
	public String kycInfo(HttpServletRequest request , Model model){
		int userIdx = Integer.parseInt(""+request.getParameter("idx"));
		EgovMap info = (EgovMap)sampleDAO.select("selectKyc",userIdx);
		if(info.get("fkey") != null && !info.get("fkey").toString().isEmpty()){
			model.addAttribute("fileList", sampleDAO.list("selectFileList" , info.get("fkey")));
		}
		model.addAttribute("info",info);
		return "admin/kycInfo";
	}	
}