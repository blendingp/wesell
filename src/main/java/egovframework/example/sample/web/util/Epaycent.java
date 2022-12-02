package egovframework.example.sample.web.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
public class Epaycent {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	

	/*@RequestMapping(value="/epayProcess.do" , produces="application/x-www-form-urlencoded; charset=utf8")*/
	@ResponseBody
	@RequestMapping(value="/epayProcess.do" , produces="application/json; charset=utf8")
	public String epayProcess(HttpServletRequest request) throws UnsupportedEncodingException{
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "wallet");
		int userIdx = Integer.parseInt("" + session.getAttribute("userIdx"));
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		EgovMap uinfo = (EgovMap) sampleDAO.select("selectMemberByIdx", userIdx);
		String username = ""+uinfo.get("email");
		String password = ""+uinfo.get("pw");
		/*String sendername = ""+uinfo.get("mname");
		String bankname = ""+uinfo.get("mbank");
		String accountnumber = ""+uinfo.get("maccount");*/
		String sendername = request.getParameter("mname");
		String bankname = request.getParameter("mbank");
		String accountnumber = request.getParameter("maccount");
		in.put("idx", userIdx);
		in.put("mname", sendername);
		in.put("mbank", bankname);
		in.put("maccount", accountnumber);
		sampleDAO.update("updateMemberInfo", in);
		JSONObject obj = new JSONObject();
		try {
			HashMap<String, Object> resultMap = new HashMap();
			resultMap.put("agencyurl", "bm778899.epaycent.com");
			resultMap.put("username", username);
			resultMap.put("password", password);
			resultMap.put("amount", "10000");
			resultMap.put("sendername", sendername);
			resultMap.put("bankname", bankname);
			resultMap.put("accountnumber", accountnumber);
			ObjectMapper mapper = new ObjectMapper();
			String json = mapper.writeValueAsString(resultMap);
			Log.print("epayProcess json: "+json, 1, "call");
			String rt = callAPI("POST", "https://epaycent.com/checkout/request", json);
			JSONParser p = new JSONParser();
			JSONObject rto = (JSONObject) p.parse(rt);
			Log.print("epayProcess call: "+rto, 1, "call");
			if(rto.get("type").equals("success")) {
				obj.put("result", "success");
				obj.put("uri", rto.get("redirectURI"));
			} else {
				obj.put("result", "APIfail");
			}
			return obj.toJSONString();
		} catch (Exception e) {
			Log.print("epayProcess err! "+e, 1, "err");
			obj.put("result", "fail");
			//obj.put("msg", Message.get().msg(messageSource, "pop.joinFail", request));
			return obj.toJSONString();
		}
	}
	
	public static String callAPI(String method , String surl, String paremeter) throws IllegalStateException {
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
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
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
}
