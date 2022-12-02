package egovframework.example.sample.web.admin;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.CryptoUtil;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping("/0nI0lMy6jAzAFRVe0DqLOw/crypto")
public class AdminCryptoController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	
	//전체 1->2로 암호화 버전 갱신
	@ResponseBody
	@RequestMapping(value="/walletPrivateEncrypt.do" , produces="application/json; charset=utf8")
	public String walletPrivateEncrypt(HttpServletRequest requset) throws UnsupportedEncodingException{
		JSONObject obj = new JSONObject();
		HttpSession session = requset.getSession();
		String adminLogin = ""+session.getAttribute("adminLogin");
		obj.put("result", "fail");
		if(adminLogin.compareTo("1")!=0) return obj.toJSONString();
					
		List<EgovMap> list = (List<EgovMap>) sampleDAO.list("selectOnlyVersion1");
		for(int i =0; i<list.size(); i++){
			String userIdx = ""+list.get(i).get("idx");
			EgovMap info = (EgovMap)sampleDAO.select("selectMemberByIdx",userIdx);
			int version = Integer.parseInt(""+info.get("version"));
			if(version == 1){
				CryptoUtil crypto = CryptoUtil.getInstance();
				String btcWif = ""+info.get("btcWif");
				String ercPrivateKey = ""+info.get("ercPrivateKey");
				String trxPrivateKey = ""+info.get("trxPrivateKey");
				try {
					btcWif = crypto.encrypt(""+info.get("btcWif"));
					ercPrivateKey = crypto.encrypt(""+info.get("ercPrivateKey"));
					trxPrivateKey = crypto.encrypt(""+info.get("trxPrivateKey"));
					obj.put("result", "suc");
					obj.put("b", btcWif);
					obj.put("e", ercPrivateKey);
					obj.put("t", trxPrivateKey);
					
					//비번변경, version 2로 변경
					EgovMap in = new EgovMap();
					in.put("userIdx", userIdx);
					in.put("btcWif", btcWif);
					in.put("ercPrivateKey", ercPrivateKey);
					in.put("trxPrivateKey", trxPrivateKey);
					sampleDAO.update("updateWalletPrivateVersion2", in);
				} catch (NoSuchAlgorithmException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					obj.put("result", "fail1");
					return obj.toJSONString();
				} catch (GeneralSecurityException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					obj.put("result", "fail2");
					return obj.toJSONString();
				}			
			}			
		}

		
		return obj.toJSONString();
	}	
	
/*	//복호화값 가져오기
	@RequestMapping(value="/getWalletPrivateDecrypt.do")
	public String getWalletPrivateDecrypt(HttpServletRequest request, ModelMap model) throws UnsupportedEncodingException, ParseException, NoSuchAlgorithmException, GeneralSecurityException{
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		String adminLogin = ""+session.getAttribute("adminLogin");
		obj.put("result", "fail");
		if(adminLogin.compareTo("1")!=0) return obj.toJSONString();
		
		String userIdx = ""+request.getParameter("userIdx");		
		EgovMap info = (EgovMap)sampleDAO.select("selectMemberByIdx",userIdx);
		int version = Integer.parseInt(""+info.get("version"));
		if(version == 2){
			CryptoUtil crypto = CryptoUtil.getInstance();
			String bp = crypto.decrypt(""+info.get("btcWif"));
			String ep = crypto.decrypt(""+info.get("ercPrivateKey"));
			String tp = crypto.decrypt(""+info.get("trxPrivateKey"));
			
			model.addAttribute("btcAddress", info.get("btcAddress"));
			model.addAttribute("ercAddress", info.get("ercAddress"));
			model.addAttribute("trxAddress", info.get("trxAddress"));
			
			model.addAttribute("bp", bp);
			model.addAttribute("ep", ep);
			model.addAttribute("tp", tp);			
		}
		
		return "admin/tmp";
	}	
	//암호화값 가져오기
	@RequestMapping(value="/getWalletPrivateEncrypt.do")
	public String walletPrivateEncrypt(HttpServletRequest request, ModelMap model) throws UnsupportedEncodingException, ParseException, NoSuchAlgorithmException, GeneralSecurityException{
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		String adminLogin = ""+session.getAttribute("adminLogin");
		obj.put("result", "fail");
		if(adminLogin.compareTo("1")!=0) return obj.toJSONString();
		
		String userIdx = ""+request.getParameter("userIdx");		
		EgovMap info = (EgovMap)sampleDAO.select("selectMemberByIdx",userIdx);
		int version = Integer.parseInt(""+info.get("version"));
		if(version == 2){
			CryptoUtil crypto = CryptoUtil.getInstance();
			String bp = crypto.encrypt(""+info.get("btcWif"));
			String ep = crypto.encrypt(""+info.get("ercPrivateKey"));
			String tp = crypto.encrypt(""+info.get("trxPrivateKey"));
			
			model.addAttribute("btcAddress", info.get("btcAddress"));
			model.addAttribute("ercAddress", info.get("ercAddress"));
			model.addAttribute("trxAddress", info.get("trxAddress"));
			
			model.addAttribute("bp", bp);
			model.addAttribute("ep", ep);
			model.addAttribute("tp", tp);			
		}
		
		return "admin/tmp";
	}
	
	//관리자 지갑 새로 생성
	@RequestMapping(value="/walletAdminPrivateEncrypt.do")
	public String walletAdminPrivateEncrypt(HttpServletRequest request, ModelMap model) throws UnsupportedEncodingException, ParseException, NoSuchAlgorithmException, GeneralSecurityException{
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		String adminLogin = ""+session.getAttribute("adminLogin");
		obj.put("result", "fail");
		if(adminLogin.compareTo("1")!=0) return obj.toJSONString();
		
		String userIdx = ""+1;//""+request.getParameter("userIdx");		
		EgovMap info = (EgovMap)sampleDAO.select("selectMemberByIdx",userIdx);
		int version = Integer.parseInt(""+info.get("version"));
		//if(version == 1){
			CryptoUtil crypto = CryptoUtil.getInstance();
			String rt = JoinController.createWallet("POST", "http://"+request.getServerName()+":5000/v1/ethereum/addresses/generate", null );
			Log.print("rta:"+rt, 0, "test" );
			if(rt == null || rt.equals("")){
				obj.put("result", "fail");
				obj.put("msg", "erc wallet error");
				return obj.toJSONString();
			}
			JSONParser p = new JSONParser();
			JSONObject rto = (JSONObject) p.parse(rt);
			JSONObject ercinfo = (JSONObject)rto.get("payload");
			String ercAddress = (String) ercinfo.get("address");
			String ep = (String) ercinfo.get("privateKey");
			String ercPrivateKey = crypto.encrypt(ep);
			Log.print("rta:"+ercAddress+"  ", 0, "test" );
			
			String btcWallet = JoinController.createWallet("POST", "http://"+request.getServerName()+":5000/v1/bitcoin/addresses/generate", null );
			Log.print("btc:"+btcWallet, 0, "test" );
			if(btcWallet == null || btcWallet.equals("")){
				obj.put("result", "fail");
				obj.put("msg", "btc wallet error");
				return obj.toJSONString();
			}
			JSONParser par = new JSONParser();
			JSONObject btcObj = (JSONObject) par.parse(btcWallet);
			JSONObject btcinfo = (JSONObject)btcObj.get("payload");
			String btcAddress = (String) btcinfo.get("address");
			String bp = (String) btcinfo.get("wif");
			String btcWif = crypto.encrypt(bp);
			Log.print("rta:"+btcAddress+"  ", 0, "test" );
			
			String trxWallet = JoinController.createWallet("POST", "http://"+request.getServerName()+":5000/v1/tron/addresses/generate", null );
			Log.print("trx:"+trxWallet, 0, "test" );
			if(trxWallet == null || trxWallet.equals("")){
				obj.put("result", "fail");
				obj.put("msg", "trx wallet error");
				return obj.toJSONString();
			}
			JSONParser trxp = new JSONParser();
			JSONObject trxObj = (JSONObject) trxp.parse(trxWallet);
			String trxAddress = (String) trxObj.get("address");
			String tp = (String) trxObj.get("privateKey");
			String trxPrivateKey = crypto.encrypt(tp);	
			
			//비번변경, version 2로 변경
			EgovMap in = new EgovMap();
			in.put("userIdx", userIdx);
			in.put("btcWif", btcWif);
			in.put("ercPrivateKey", ercPrivateKey);
			in.put("trxPrivateKey", trxPrivateKey);
			
			in.put("btcAddress", btcAddress);
			in.put("ercAddress", ercAddress);
			in.put("trxAddress", trxAddress);
						
			sampleDAO.update("newAdminWallet", in);
			model.addAttribute("btcAddress", btcAddress);
			model.addAttribute("ercAddress", ercAddress);
			model.addAttribute("trxAddress", trxAddress);
			
			model.addAttribute("bp", bp);
			model.addAttribute("ep", ep);
			model.addAttribute("tp", tp);			
		//}
		
		return "admin/tmp";
	}		*/
}
