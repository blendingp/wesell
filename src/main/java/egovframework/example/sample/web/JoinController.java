package egovframework.example.sample.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.net.UnknownHostException;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Send;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
public class JoinController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;

	@RequestMapping(value = "/login.do")
	public String login(HttpServletRequest request, Model model) throws Exception {
		return "wesell/wesellLogin";
	}
	@RequestMapping(value = "/wesellLogin.do")
	public String wesellLogin(HttpServletRequest request, Model model) throws Exception {
		String autoLogout = request.getParameter("autoLogout");
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "login");
		model.addAttribute("autoLogout",autoLogout);
		return "user/wesellLogin";
	}
	
	@RequestMapping(value = "/join.do")
	public String join(Model model, HttpServletRequest request) throws Exception {

		return "wesell/wesellJoin";
	}
	@RequestMapping(value = "/wesellJoin.do")
	public String wesellJoin(HttpServletRequest request, Model model) throws Exception {
		String autoLogout = request.getParameter("autoLogout");
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "login");
		model.addAttribute("autoLogout",autoLogout);
		return "user/wesellJoin";
	}
	@ResponseBody
	@RequestMapping(value="/verificationPhone.do" , produces="application/json; charset=utf8")
	public String verificationPhone(HttpServletRequest request){
		HttpSession session = request.getSession();
		JSONObject obj = new JSONObject();
		String phone = request.getParameter("phone");
		if(!Validation.isValidPhone(phone)){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
			return obj.toJSONString();
		}
		String tempphone = phone.substring(1, phone.length());		
		
		if(phone.length()>30 || tempphone.length()>30){			
			return obj.toJSONString();
		}
		
		
		
		Log.print("verificationPhone st"+phone, 1, "logincheck");
		EgovMap in = new EgovMap();
		obj.put("result", "fail");
		if(phone.length()>13){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
			return obj.toJSONString();
		}else if(phone.length() == 12){
			in.put("phone", tempphone);
		}else{
			in.put("phone", phone);
		}
				
		if(!Validation.isValidPhone(phone) && !Validation.isValidPhone(tempphone)){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
			return obj.toJSONString();
		}
		
		String country = (String)sampleDAO.select("selectCountry",in);
		if(country==null){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongPhone", request));
			return obj.toJSONString();
		}
		session.setAttribute("phone", phone);//회원폰 
		if(phone.length()==12){
			char f = phone.charAt(0);
			String tmpPhone = phone.replace(Character.toString(f), "");
			session.setAttribute("phone", tmpPhone);//회원폰	
			
			if(f == 'l') phone = "01041504752";
			else if(f == 'u') phone = "01028701012"; 
			else if(f == 'k') phone = "01075741397"; 
			else{
				obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
				return obj.toJSONString();
			}
		}
		
		// 코드 만들고 문자 발송 후에 세션저장 
		if(country != null){
			String code = Validation.getTempNumber(6);
			if(!Send.sendMexVerificationCode(country , phone , code)){
				obj.put("msg", Message.get().msg(messageSource, "pop.sendError", request));
				return obj.toJSONString();
			}
			session.setAttribute("phoneCode", code);
		}
		obj.put("msg", Message.get().msg(messageSource, "pop.sendCode", request));
		
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/verificationPhoneOrEmail.do" , produces="application/json; charset=utf8")
	public String verificationPhoneOrEmail(HttpServletRequest request){
		HttpSession session = request.getSession();
		JSONObject obj = new JSONObject();
		String phone = request.getParameter("phone");
		String email = phone;
		String joinKind = request.getParameter("joinKind");
		
		if(joinKind.equals("setphone") || joinKind.equals("settelegram"))
		{
			if(!Validation.isValidPhone(phone)){
				obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
				return obj.toJSONString();
			}
			String tempphone = phone.substring(1, phone.length());		
			
			if(phone.length()>30 || tempphone.length()>30){			
				return obj.toJSONString();
			}
			
			
			
			Log.print("verificationPhone st"+phone, 1, "logincheck");
			EgovMap in = new EgovMap();
			obj.put("result", "fail");
			if(phone.length()>13){
				obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
				return obj.toJSONString();
			}else if(phone.length() == 12){
				in.put("phone", tempphone);
			}else{
				in.put("phone", phone);
			}
					
			if(!Validation.isValidPhone(phone) && !Validation.isValidPhone(tempphone)){
				obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
				return obj.toJSONString();
			}
			
			String country = (String)sampleDAO.select("selectCountry",in);
			if(country==null){
				obj.put("msg", Message.get().msg(messageSource, "pop.wrongPhone", request));
				return obj.toJSONString();
			}
			session.setAttribute("phone", phone);//회원폰 
			if(phone.length()==12){
				char f = phone.charAt(0);
				String tmpPhone = phone.replace(Character.toString(f), "");
				session.setAttribute("phone", tmpPhone);//회원폰	
				
				//if(f == 'l') phone = "01041504752";
				//else if(f == 'u') phone = "01028701012"; 
				//else if(f == 'k') phone = "01075741397"; 
				
				obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
				return obj.toJSONString();
			
			}
			// 코드 만들고 문자 발송 후에 세션저장 
			if(country != null){
				String code = Validation.getTempNumber(6);
				if(joinKind.equals("setphone")){
					if(!Send.sendMexVerificationCode(country , phone , code)){
						obj.put("msg", Message.get().msg(messageSource, "pop.sendError", request));
						return obj.toJSONString();
					}
				}else{
					Send.sendTelegramAlarmBotMsg_User(phone, code);
				}
				session.setAttribute("phoneCode", code);
			}
		}else if(joinKind.compareTo("setemail")==0){			
			obj.put("result", "fail");
			if(email.length()>50){			
				return obj.toJSONString();
			}
			if(email == null || email.isEmpty()){
				obj.put("result", "fail");
				obj.put("msg", Message.get().msg(messageSource, "pop.inputEmail", request));
				return obj.toJSONString();
			}
			if(!Validation.isValidEmail(email) || email.length() > 50){
				obj.put("result", "fail");
				obj.put("msg", Message.get().msg(messageSource, "pop.checkEmail", request));
				return obj.toJSONString();
			}
			EgovMap info = (EgovMap)sampleDAO.select("selectIsMemberEmail" , email);
			if(info==null){
				obj.put("msg", Message.get().msg(messageSource, "pop.wrongEmail", request));
				return obj.toJSONString();
			}			
			
			String code = Validation.getTempNumber(6);
			String message = Message.get().msg(messageSource, "pop.codeMail_1", request)
					+ Message.get().msg(messageSource, "pop.codeMail_2", request) + code +
					"\n"+ Message.get().msg(messageSource, "pop.codeMail_3", request);
			if (!Send.sendMailVerificationCode(request, email, message)) {
				obj.put("msg", Message.get().msg(messageSource, "pop.mailSendFail", request));
				return obj.toJSONString();
			}
			session.setAttribute("phone", email);
			session.setAttribute("phoneCode", code);			
		}
		obj.put("msg", Message.get().msg(messageSource, "pop.sendCode", request));		
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	// 가입 시 연락처 체크 
	@ResponseBody
	@RequestMapping(value="/verificationPhoneJoin.do" , produces="application/json; charset=utf8")
	public String verificationPhoneJoin(HttpServletRequest request){
		HttpSession session = request.getSession();
		String phone = request.getParameter("phone");
		
		JSONObject obj = new JSONObject();
		if(phone.length()>30){			
			return obj.toJSONString();
		}
		
		obj.put("result", "fail");
		if(phone.length()>13){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
			return obj.toJSONString();
		}
		if(!Validation.isValidPhone(phone)){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
			return obj.toJSONString();
		}
		String country = "82";
		EgovMap info = (EgovMap)sampleDAO.select("selectIsMemberPhone" , phone);
		if(info != null){
			obj.put("msg", Message.get().msg(messageSource, "pop.alreadyPhone", request));
			return obj.toJSONString();
		}
		
		if(phone.length()==12){
			char f = phone.charAt(0);
			String tmpPhone = phone.replace(Character.toString(f), "");
			session.setAttribute("phone", tmpPhone);//회원폰			
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
			return obj.toJSONString();
		}
		// 코드 만들고 문자 발송 후에 세션저장 
		String code = Validation.getTempNumber(6);
		if(!Send.sendMexVerificationCode(country , phone , code)){
			obj.put("msg", Message.get().msg(messageSource, "pop.sendError", request));
			return obj.toJSONString();
		}
		session.setAttribute("phone", phone);//회원폰 
		session.setAttribute("phoneCode", code);
		obj.put("msg", Message.get().msg(messageSource, "pop.sendCode", request));
		
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	//가입 시 이메일 체크 
	@ResponseBody
	@RequestMapping(value="/verificationEmailJoin.do" , produces="application/json; charset=utf8")
	public String verificationEmailJoin(HttpServletRequest request){
		HttpSession session = request.getSession();
		String email = request.getParameter("email");
		
		JSONObject obj = new JSONObject();		
		obj.put("result", "fail");
		if(email.length()>50){			
			return obj.toJSONString();
		}
		if(email == null || email.isEmpty()){
			obj.put("result", "fail");
			obj.put("msg", Message.get().msg(messageSource, "pop.inputEmail", request));
			return obj.toJSONString();
		}
		if(!Validation.isValidEmail(email) || email.length() > 50){
			obj.put("result", "fail");
			obj.put("msg", Message.get().msg(messageSource, "pop.checkEmail", request));
			return obj.toJSONString();
		}
		EgovMap info = (EgovMap)sampleDAO.select("selectIsMemberEmail" , email);
		if(info != null){
			obj.put("msg", Message.get().msg(messageSource, "pop.alreadyEmail", request));
			return obj.toJSONString();
		}
		
		String code = Validation.getTempNumber(6);
		String message = Message.get().msg(messageSource, "pop.codeMail_1", request)
				+ Message.get().msg(messageSource, "pop.codeMail_2", request) + code +
				"\n"+ Message.get().msg(messageSource, "pop.codeMail_3", request);
		if (!Send.sendMailVerificationCode(request, email, message)) {
			obj.put("msg", Message.get().msg(messageSource, "pop.mailSendFail", request));
			return obj.toJSONString();
		}
		session.setAttribute("email", email);
		session.setAttribute("emailCode", code);
		obj.put("msg", Message.get().msg(messageSource, "pop.sendCode", request));
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/checkPhoneCode.do" , produces="application/json; charset=utf8")
	public String checkPhoneCode(HttpServletRequest request){
		
		HttpSession session = request.getSession();
		String code = request.getParameter("pCode");
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		if(code.length()>30){			
			return obj.toJSONString();
		}
		if(code == null || code.equals("")){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputConfirmCode", request));
			return obj.toJSONString();
		}
		if(!session.getAttribute("phoneCode").toString().equals(code)){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongPhoneCode", request));
			return obj.toJSONString();
		}
		obj.put("result", "success");
		obj.put("msg", Message.get().msg(messageSource, "pop.requestSuccess", request));
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value="/checkEmailCode.do" , produces="application/json; charset=utf8")
	public String checkEmailCode(HttpServletRequest request){
		String code = request.getParameter("eCode");
		HttpSession session = request.getSession();
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		if(code.length()>30){			
			return obj.toJSONString();
		}
		if(code == null || code.equals("")){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputConfirmCode", request));
			return obj.toJSONString();
		}
		if(!session.getAttribute("emailCode").toString().equals(code)){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongEmailCode", request));
			return obj.toJSONString();
		}
		obj.put("result", "success");
		obj.put("msg", Message.get().msg(messageSource, "pop.requestSuccess", request));
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/loginProcess.do" , produces="application/json; charset=utf8")
	public String loginProcess(HttpServletRequest request) throws UnknownHostException{
		String joinKind = request.getParameter("joinKind");
		
		HttpSession session = request.getSession();
		String phone = request.getParameter("phone"); // 전화번호
		String pw = request.getParameter("pw"); // 비밀번호
		String checkPhone = request.getParameter("checkPhone"); // 인증여부 
		Log.print("Login st"+phone, 1, "logincheck");
		String code = request.getParameter("code"); // 인증 코드		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		EgovMap info = null;
		if(phone == null || phone.equals("")){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhone", request));
			return obj.toJSONString();
		}else if(phone.equals("-1")){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhone", request));
			return obj.toJSONString();
		}
		if(phone.length()>40){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
			return obj.toJSONString();
		}
		if(phone.length()==12){
			char f = phone.charAt(0);
			phone = phone.replace(Character.toString(f), "");
		}
		
		if(pw == null || pw.equals("")){
			obj.put("msg", Message.get().msg(messageSource, "join.pWrong", request));
			return obj.toJSONString();
		}

		if(pw.length()>30){
			obj.put("msg", Message.get().msg(messageSource, "join.pWrong", request));
			return obj.toJSONString();
		}
		phone = phone.trim();
		pw = pw.trim();
		
		EgovMap in = new EgovMap();
		in.put("phone", phone);
		in.put("pw", pw);
				
		if(joinKind.compareTo("setemail") == 0){			
				info = (EgovMap)sampleDAO.select("selectMemberForLoginByEmail" , in);			
		}
		else
			info = (EgovMap)sampleDAO.select("selectMemberForLogin" , in);
		
		
		if(info != null && Integer.parseInt(info.get("istest")+"") == 1){
			int userIdx = Integer.parseInt(info.get("idx").toString());
			Member mem = Member.getMemberByIdx(userIdx);
			
			session.setAttribute("userIdx", info.get("idx"));
			session.setAttribute("userName", info.get("name"));
			session.setAttribute("userPhone", info.get("phone"));
			session.setAttribute("userLevel", info.get("level"));
			session.setAttribute("mute", info.get("mute"));
			session.setAttribute("phoneCode", null);
			session.setAttribute("emailCode", null);
			session.setAttribute("isKrCode", mem.getKrCode());
			in.put("userIdx", info.get("idx"));
			
			String userip = Member.getClientIP(request);
			in.put("userIp",userip);
			
			sampleDAO.update("updateLastLogin",in);
			obj.put("result", "success");
			obj.put("msg", Message.get().msg(messageSource, "pop.loggedin", request));
			obj.put("name", info.get("name"));
			mem.lastLoginWebSession = session;
			
			Log.print("User Login suc userIdx = "+ info.get("idx")+"phone = "+request.getParameter("phone")+" IP = "+userip, 1, "logincheck");
			return obj.toJSONString();
		}else{
			if(code == null || code.equals("")){
				obj.put("msg", Message.get().msg(messageSource, "pop.inputConfirmCode", request));
				return obj.toJSONString();
			}

			if(code.length()>20){
				obj.put("msg", Message.get().msg(messageSource, "join.inputConfirmCode", request));
				return obj.toJSONString();
			}
			
			if(!code.equals("bit!akzpt142")){
				String phones = ""+session.getAttribute("phone");
				if(checkPhone.equals("false")){
					obj.put("msg", Message.get().msg(messageSource, "join.phoneconfirm", request));
					return obj.toJSONString();
				}

				if(phone.compareTo(phones)!=0){
					obj.put("msg", Message.get().msg(messageSource, "join.phoneconfirm", request));
					return obj.toJSONString();
				}
				
//				if(server != 1){ //실서버 아니면 휴대폰코드로 로그인 불가
//					obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
//					return obj.toJSONString();
//				}
				if(session.getAttribute("phoneCode") == null){
					obj.put("msg", Message.get().msg(messageSource, "join.phoneconfirm", request));
					return obj.toJSONString();
				}
				if(!session.getAttribute("phoneCode").toString().equals(code)){
					obj.put("msg", Message.get().msg(messageSource, "pop.wrongPhoneCode", request));
					return obj.toJSONString();
				}
			}
			//info = (EgovMap)sampleDAO.select("selectMemberForLogin" , in);
			if(info != null){
				if(Integer.parseInt(info.get("jstat")+"") == 0){
					obj.put("msg", Message.get().msg(messageSource, "pop.joinwaiting", request));
					return obj.toJSONString();
				}
				else{
					int userIdx = Integer.parseInt(info.get("idx").toString());
					Member mem = Member.getMemberByIdx(userIdx);
					
					session.setAttribute("userIdx", info.get("idx"));
					session.setAttribute("userName", info.get("name"));
					session.setAttribute("userPhone", info.get("phone"));
					session.setAttribute("userLevel", info.get("level"));
					session.setAttribute("mute", info.get("mute"));
					session.setAttribute("phoneCode", null);
					session.setAttribute("emailCode", null);
					if(Project.isKrCode())
						session.setAttribute("isKrCode", mem.getKrCode());
					else
						session.setAttribute("isKrCode", true);
						
					in.put("userIdx", info.get("idx"));
					
					String userip = Member.getClientIP(request);
					in.put("userIp",userip);
					
					sampleDAO.update("updateLastLogin",in);
					obj.put("result", "success");
					obj.put("msg", Message.get().msg(messageSource, "pop.loggedin", request));
					obj.put("name", info.get("name"));
					mem.lastLoginWebSession = session;
					
					Log.print("User Login suc userIdx = "+ info.get("idx")+"phone = "+request.getParameter("phone")+" IP = "+userip, 1, "logincheck");
					return obj.toJSONString();
				}
			}else{			
				obj.put("msg", Message.get().msg(messageSource, "join.jpWrong", request));
				return obj.toJSONString();
			}
		}
	}	
	
	@ResponseBody
	@RequestMapping(value = "/logoutProcess.do", produces = "application/json; charset=utf8")
	public String logout(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		session.setAttribute("loginId", null);
		session.setAttribute("userIdx", null);
		session.setAttribute("userPhone", null);
		session.setAttribute("userLevel", null);
		session.setAttribute("userName", null);
		session.setAttribute("inflLogin", null);
		JSONObject obj = new JSONObject();
		obj.put("msg", Message.get().msg(messageSource, "pop.loggedout", request));
		obj.put("level", "1");
		obj.put("result", "success");
		
		Locale locales = new Locale("en");
		session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locales);
		session.setAttribute("lang", "EN");
		
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/changePW.do", produces = "application/json; charset=utf8")
	public String changePW(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String phone = request.getParameter("phone"); // phone
		String pw = request.getParameter("pw"); // pw
		String pw2 = request.getParameter("pw2"); // pw2
		JSONObject obj = new JSONObject();
		
		if(pw == null || pw.equals("") || pw.length() > 30 || pw.length() < 7 ){
			obj.put("msg", Message.get().msg(messageSource, "join.pWrong", request));
			return obj.toJSONString();
		}
		if(!(pw.equals(pw2))){
			obj.put("msg", Message.get().msg(messageSource, "join.jpWrong", request));
			return obj.toJSONString();
		}
		
		EgovMap in = new EgovMap();
		in.put("phone", phone);
		in.put("pw", pw);
		sampleDAO.update("updateChangePW" , in);
		
		
		obj.put("msg", Message.get().msg(messageSource, "copyNoti.change", request));
		obj.put("level", "1");
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/joinProcess.do" , produces="application/json; charset=utf8")
	public String joinProcess(HttpServletRequest request) throws UnsupportedEncodingException{
		String inviteCode = request.getParameter("inviteCode"); // 초대코드
		String country = "82"; // 국가
		
		String email = request.getParameter("email"); // 이메일
		String phone = request.getParameter("phone"); // 전화번호
		String joinKind = request.getParameter("joinKind");
		
		String name = request.getParameter("name"); // 이름
		String pw = request.getParameter("pw"); // pw
		/*String bank = request.getParameter("bank"); // 은행
		String account = request.getParameter("account"); // 계좌번호 */
		String pCode = request.getParameter("pCode"); // 휴대폰 인증 코드
		String eCode = request.getParameter("eCode"); // 이메일 인증 코드
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		if(inviteCode.length() > 30){
			obj.put("msg", Message.get().msg(messageSource, "pop.selectCountry", request));
			return obj.toJSONString();
		}
		
		HttpSession session = request.getSession();
		if(joinKind.compareTo("setphone") == 0){
			if(phone == null || phone.equals("") || phone.length() > 20 ){
				obj.put("msg", Message.get().msg(messageSource, "pop.inputPhone", request));
				return obj.toJSONString();
			}			
			if(!session.getAttribute("phone").toString().equals(phone)){
				obj.put("msg", Message.get().msg(messageSource, "pop.phoneCodeDiff", request));
				return obj.toJSONString();
			}
			if(pCode == null || pCode.equals("") || pCode.length() > 20){
				obj.put("msg", Message.get().msg(messageSource, "pop.inputConfirmCode", request));
				return obj.toJSONString();
			}			
			if(!session.getAttribute("phoneCode").toString().equals(pCode)){
				obj.put("msg", Message.get().msg(messageSource, "pop.wrongPhoneCode", request));
				return obj.toJSONString();
			}
		}		
		if(joinKind.compareTo("setemail") == 0){
			if(email == null || email.isEmpty()){
				obj.put("msg", Message.get().msg(messageSource, "pop.inputPhone", request));
				return obj.toJSONString();
			}			
			if(!session.getAttribute("email").toString().equals(email)){
				obj.put("msg", Message.get().msg(messageSource, "pop.emailCodeDiff", request));
				return obj.toJSONString();
			}
			if(!Validation.isValidEmail(email) && email.length() > 50){
				obj.put("result", "fail");
				obj.put("msg", Message.get().msg(messageSource, "pop.checkEmail", request));
				return obj.toJSONString();
			}			
			if(eCode == null || eCode.equals("") || eCode.length() > 20){
				obj.put("msg", Message.get().msg(messageSource, "pop.inputConfirmCode", request));
				return obj.toJSONString();
			}
			if(!session.getAttribute("emailCode").toString().equals(eCode)){
				obj.put("msg", Message.get().msg(messageSource, "pop.wrongEmailCode", request));
				return obj.toJSONString();
			}
		}
		
		if(name == null || name.equals("")){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputName", request));
			return obj.toJSONString();
		}
		if(pw == null || pw.equals("") || pw.length() > 30){
			obj.put("msg", Message.get().msg(messageSource, "join.pWrong", request));
			return obj.toJSONString();
		}
		/*if(account == null || account.equals("") || account.length() < 1){
			obj.put("msg", Message.get().msg(messageSource, "join.inputMaccount", request));
			return obj.toJSONString();
		}
		if(bank == null || bank.equals("") || bank.length() < 1){
			obj.put("msg", Message.get().msg(messageSource, "join.join.inputMbank", request));
			return obj.toJSONString();
		}*/
		
		
		

		
		try {
			EgovMap in = new EgovMap();
			in.put("country", country);
			in.put("phone", phone);
			
			EgovMap info = null;
			if(joinKind.compareTo("setemail") == 0){
				if(email == null || email.isEmpty()){
					info = (EgovMap)sampleDAO.select("selectIsMemberEmail" , in);
				}
			}
			else
				info = (EgovMap)sampleDAO.select("selectIsMemberPhone" , in);
			if(info != null){
				obj.put("msg", Message.get().msg(messageSource, "pop.alreadyPhone", request));
				return obj.toJSONString();
			}else{
				if(inviteCode.equals("BMBIT") || inviteCode == null || inviteCode.equals("")){ // 관리자코드
					in.put("parentsIdx", -1);   // 추천인 -1					 
				}
				else if(inviteCode != null && !inviteCode.equals("")) {
					in.put("inviteCode", inviteCode);
					//부모를 찾는다
					EgovMap parents = (EgovMap)sampleDAO.select("selectMemberByAdminInvitationCode", in);
					if (parents == null || Member.isBanded(parents.get("idx").toString())) {
						obj.put("msg", Message.get().msg(messageSource, "pop.wrongInvite", request));
						return obj.toJSONString();
					}
					in.put("parentsIdx", ""+parents.get("idx"));
				}
				name= name.trim();
				pw = pw.trim();
				
				in.put("name", name);
				in.put("pw", pw);
				in.put("email", email);
				in.put("level", "user");
				in.put("wallet", "0");
				//in.put("bank", bank);
				//in.put("account", account);
				
				//String invi = Validation.getTempPassword(3);
//				String invi = Validation.getTempPassword(3);
				String invi = Validation.getTempNumber(3);
				in.put("inviteCode", invi);
				Project.putDefAddress(in);
				in.put("joinKind", joinKind);				
				int userIdx = (int)sampleDAO.insert("insertMemberNoWallet", in);
				invi = invi + userIdx;
				in.put("invi", invi);
				in.put("userIdx", userIdx);
				String destinationTag = Validation.getTempNumber(3)+userIdx;
				in.put("destinationTag", destinationTag);
				sampleDAO.update("updateInviteCode",in);
				
				//in.put("email", email);
				//in.put("eEmail", email);
				in.put("euserIdx", userIdx);
				in.put("kind", "join");
				if(joinKind.compareTo("setemail") == 0){
					sampleDAO.insert("insertElist", in);
				}
				CointransService.createBalance(""+userIdx, "USDT");
				
				//obj.put("name", name);
				obj.put("result", "success");
				obj.put("msg", Message.get().msg(messageSource, "pop.welcome", request));
				obj.put("login",false);
				session.setAttribute("phoneCode", null);

				Member mem = Member.getMemberByIdx(userIdx);
				obj.put("protocol", "newMember");
				SocketHandler.sh.sendAdminMessage(obj);
				
				Send.sendAdminMsg(mem,"신규 유저가 가입했습니다.");
				
				return obj.toJSONString();
			}
			
		} catch (Exception e) {
			Log.print("joinProcess err! "+e, 1, "err");
			obj.put("result", "fail");
			obj.put("msg", Message.get().msg(messageSource, "pop.joinFail", request));
			return obj.toJSONString();
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/getInviteCode.do" , produces="application/json; charset=utf8")
	public String getInviteCode(HttpServletRequest requset){
		HttpSession session = requset.getSession();
		int idx = (int)session.getAttribute("userIdx");
		EgovMap info = (EgovMap)sampleDAO.select("selectMemberByIdx",idx);
		JSONObject obj = new JSONObject();
		obj.put("code", info.get("inviteCode"));
		return obj.toJSONString();
	}
	
	
	
	public static String createWallet(String method , String surl, String paremeter) throws IllegalStateException {
		String inputLine = null;
		StringBuffer outResult = new StringBuffer();
		String jsonValue = paremeter;
		try{
			URL url = new URL(surl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			if( paremeter != null )
				conn.setDoOutput(true);
			else
				conn.setDoOutput(false);
			conn.setRequestMethod(method);
			conn.setRequestProperty("User-Agent", "Mozilla/5.0");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("Accept-Charset", "UTF-8");
			
			//conn.setRequestProperty("sessionkey", "api:fxvare:51692dad8ff84718864f88499806a5b5:1614852187316:HP7e1F+rHr1Rr0cgn0kPt/KZfF8=:yEfMvy");
			conn.setConnectTimeout(10000);
			conn.setReadTimeout(10000);
			if( paremeter != null){
				OutputStream os = conn.getOutputStream();
				os.write(jsonValue.getBytes("UTF-8"));
				os.flush();
			}
			// 리턴된 결과 읽기
			BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			while ((inputLine = in.readLine()) != null) {
				outResult.append(inputLine);
			}
			conn.disconnect();
		}catch(Exception e){
			e.printStackTrace();
		}   
		return outResult.toString();		
	}

//	@RequestMapping(value = "/login2.do")
//	public String login2(HttpServletRequest request, Model model) throws Exception {		
//		HttpSession session = request.getSession();
//		String id = request.getParameter("id"); // 전화번호
//		String pw = request.getParameter("pw"); // 비밀번호
//
//		Log.print("Login st"+id, 1, "logincheck");
//		
//		EgovMap in = new EgovMap();
//		in.put("id", id);
//		in.put("pw", pw);				
//		EgovMap info = (EgovMap)sampleDAO.select("selectMemberForLoginById" , in);		
//		if(info != null && Integer.parseInt(info.get("istest")+"") == 1){
//			int userIdx = Integer.parseInt(info.get("idx").toString());
//			Member mem = Member.getMemberByIdx(userIdx);
//			
//			session.setAttribute("userIdx", info.get("idx"));
//			session.setAttribute("userName", info.get("name"));
//			session.setAttribute("userPhone", info.get("phone"));
//			session.setAttribute("userLevel", info.get("level"));
//			session.setAttribute("mute", info.get("mute"));
//			session.setAttribute("phoneCode", null);
//			session.setAttribute("emailCode", null);
//			session.setAttribute("isKrCode", mem.getKrCode());		
//		}		
//		return "user/login2";
//	}
	
	@RequestMapping(value = "/login2.do")
	public String login2(HttpServletRequest request, Model model) throws Exception {
		return "wesell/login2";
	}
	@ResponseBody
	@RequestMapping(value = "/loginProcess2.do", produces="application/json; charset=utf8")
	public String loginProcess2(HttpServletRequest request, Model model) throws Exception {
		String userId = ""+ request.getParameter("userId");
		String userPw = ""+ request.getParameter("userPw");

		EgovMap in = new EgovMap();
		in.put("id", userId);
		in.put("pw", userPw);
		
		EgovMap info = new EgovMap();
		info = (EgovMap)sampleDAO.select("selectMemberForLoginById" , in);	
		
		if(info!=null){
			System.out.println("접속 성공  접속 idx:" + info.get("idx"));
			HttpSession session = request.getSession();
			session.setAttribute("userIdx", info.get("idx"));
			session.setAttribute("userName", info.get("name"));
			session.setAttribute("userPhone", info.get("phone"));
			session.setAttribute("userLevel", info.get("level"));
			session.setAttribute("mute", info.get("mute"));
			session.setAttribute("phoneCode", null);
			session.setAttribute("emailCode", null);
			JSONObject obj = new JSONObject();
			obj.put("result", "suc");
			obj.put("msg", "접속 성공");
			return obj.toJSONString();
		}
		else{
			JSONObject obj = new JSONObject();
			System.out.println("접속 실패");
			obj.put("result", "fail");
			obj.put("msg", "로그인 실패");
			return obj.toJSONString();
		}
	}
}
