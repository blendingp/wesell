package egovframework.example.sample.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringEscapeUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fasterxml.jackson.core.JsonProcessingException;

import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class NotLoginMoneyController {
	
	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;
	
	@Resource(name = "fileProperties")
	private Properties fileProperties;
		
	@RequestMapping(value = "/kWalletNotLogin.do")
	public String kWalletNotLogin(HttpServletRequest request, ModelMap model) throws JsonProcessingException {		
		return "user/kWalletNotLogin";
	}
	
	@ResponseBody
	@RequestMapping(value = "/notLogDepositProcess.do" , method = RequestMethod.POST ,produces = "application/json; charset=utf8")
	public String notLogDepositProcess(HttpServletRequest request, ModelMap model) throws Exception {
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		//HttpSession session = request.getSession();
		//String userIdx = "" + session.getAttribute("userIdx");
		String money = ""+request.getParameter("depositMoney");
		String name = ""+request.getParameter("depositName");
		String account = ""+request.getParameter("depositAccount");
		
		
		EgovMap in = new EgovMap();
		//in.put("userIdx", userIdx);
		in.put("money", money);
		in.put("kind", "+");
		in.put("account", account);
		in.put("name", name);
		
		if(money.equals("") || Double.parseDouble(money)<0) {
			obj.put("msg", Message.get().msg(messageSource, "wallet.inputAmount", request));
			return obj.toJSONString();
		}
		
		if(name.equals("")) {
			obj.put("msg", Message.get().msg(messageSource, "pop.inputName", request));
			return obj.toJSONString();
		}
		if(account.equals("")) {
			obj.put("msg", Message.get().msg(messageSource, "pop.wallet.inputWalletAddress", request));
			return obj.toJSONString();
		}


		sampleDAO.insert("insertMoneyNotUser",in);
		
		obj.put("result", "suc");
		obj.put("msg", Message.get().msg(messageSource, "wallet.dreqSuccess", request));
		obj.put("protocol", "dwRequest");
		SocketHandler.sh.sendAdminMessage(obj);
		return obj.toJSONString();
	}
}
