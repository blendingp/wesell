package egovframework.example.sample.classes;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class ServerInfo {
	
	public static ServerInfo get(){
		if( manager == null)
			manager = new ServerInfo();
		return manager;
	}
	private static ServerInfo manager=null;
	
	public String getMexUrl(){
//		String url = "http://mexkr2.sms-service.com.my:29146/cgi-bin/sendsms";
		String url = "http://mexkr.sms-service.com.my:29143/cgi-bin/sendsms";
		return url;
	}
	
	public String getEmailID(){
		return "gmailID";
	}
	public String getAppPassword(){
		return "gmailAppPass";
	}
	
	public String [] getMexAccount(){ // 0 - id, 1 - pw
		String id = "";
		String pw = "";
		
		String [] account = {id,pw};
		return account;
	}
	
	public void insertAdminAccessLog(String ip, String id, String pw, boolean pass, String loginUser){
		EgovMap in = new EgovMap();
		in.put("ip", ip);
		in.put("atID", id);
		in.put("atPW", pw);
		in.put("pass", pass);
		in.put("loginUser", loginUser);
		SocketHandler.sh.getSampleDAO().insert("insertAdminAccessLog",in);
	}
}
