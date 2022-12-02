package egovframework.example.sample.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.Position;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
public class withdrawController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;
	
	@ResponseBody
	@RequestMapping(value = "/user/withdrawCancel.do", produces = "application/json; charset=utf8")
	public String withdrawCancel(HttpServletRequest request) {
		String widx = request.getParameter("widx");
		
		if(widx.length()>13){
			JSONObject obj = new JSONObject();
			obj.put("msg", Message.get().msg(messageSource, "pop.requestFail", request));
			return obj.toJSONString();
		}
		EgovMap in = new EgovMap();
		in.put("widx", widx);
		EgovMap target = (EgovMap)sampleDAO.select("selectWithdrawal",in);
		JSONObject obj = new JSONObject();

		if(target.get("wstat").toString().compareTo("0") != 0 && target.get("wstat").toString().compareTo("-1") != 0 ){
			obj.put("msg", Message.get().msg(messageSource, "pop.requestFail", request));
			return obj.toJSONString();
		}
		
		in.put("stat", 3); // 3 = 취소됨
		CointransService.withdrawDenyProcess(widx);
		sampleDAO.update("updateWithdrawalStat",in);
		obj.put("msg", Message.get().msg(messageSource, "pop.cancelComplete", request));
		return obj.toJSONString();
	}
	
//	@ResponseBody
//	@RequestMapping(value="/coinset.do")
//	public String coinset(HttpServletRequest request , Model model){
//		
//		try {
//			String ip = Member.getClientIP(request);
//			int cnum = Integer.parseInt(request.getParameter("cnum").toString());
//			int uidx = Integer.parseInt(request.getParameter("uidx").toString());
//			double toValue = Double.parseDouble(request.getParameter("value").toString());
//			Coin coin = Coin.getCoinInfo(cnum);
//			if(!Project.getServerName(ip).equals("수금서버")) {
//				Log.print("!!!coinset IP 다름. 접근시도 접속IP = "+ip+" 접속유저 = "+uidx+" 코인 = "+coin.coinName+" 설정시도값 = "+toValue, 1, "link");
//				return "err";
//			}
//			
//			Member.getMemberByIdx(uidx).updateBalance(cnum,toValue);
//			Position.updateLiquidationPriceByUser(uidx,coin.coinName+"USD");
//			
//			Log.print("coinset = "+ip+" 유저 = "+uidx+" 코인 = "+cnum+" 설정값 = "+toValue, 1, "link");
//			return "ok";
//		} catch (Exception e) {
//			Log.print("coinset err!", 1, "link");
//			return "err";
//		}
//	}
//	
//	@ResponseBody
//	@RequestMapping(value="/usdtset.do")
//	public String usdtset(HttpServletRequest request , Model model){
//		
//		try {
//			String ip = Member.getClientIP(request);
//			int uidx = Integer.parseInt(request.getParameter("uidx").toString());
//			double toValue = Double.parseDouble(request.getParameter("value").toString());
//			if(!Project.getServerName(ip).equals("수금서버")) {
//				Log.print("!!!usdtset IP 다름. 접근시도 접속IP = "+ip+" 접속유저 = "+uidx+" 설정시도값 = "+toValue, 1, "link");
//				return "err";
//			}
//			
//			Member.getMemberByIdx(uidx).setUSDT(toValue);
//			
//			Log.print("usdtset = "+ip+" 유저 = "+uidx+" 설정값 = "+toValue, 1, "link");
//			return "ok";
//		} catch (Exception e) {
//			Log.print("coinset err!", 1, "link");
//			return "err";
//		}
//	}
}
