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
		switch(Project.getProjectName()){
		case "best":
		case "blockbit": return "newwave0107";
		case "macrobit": return "upbit01014";
		case "xbit": return "lusv0531";
		case "miixbit": return "upbit01014";
		case "vetabit": return "vetabit1004";
		case "byflow": return "david33180941";
		case "bexlime": return "bexlimeglobal";
		case "bitocean": return "globalbitmarketgp";
		case "graphttok": return "david33180941";
		case "vista-bit": return "vetabit1004";
		case "BITWIN": return "upbit01014";
		case "worldbit": return "newwave0107";
		}
		return null;
	}
	public String getAppPassword(){
		switch(Project.getProjectName()){
		case "best":
		case "blockbit": return "kqzbkvnylatfrydl";
		case "macrobit": return "pkxjekwjyxoewjik";
		case "xbit": return "fhzbpoefetkqpteo";
		case "miixbit": return "pkxjekwjyxoewjik";
		case "vetabit": return "jnzgbtwkjirzxcfh";
		case "byflow": return "feqmeryqjjhfdodr";
		case "bexlime": return "xtonmoyddxijqkre";
		case "bitocean": return "tiymplhzbwxxkulp";
		case "graphttok": return "feqmeryqjjhfdodr";
		case "vista-bit": return "jnzgbtwkjirzxcfh";
		case "BITWIN": return "pkxjekwjyxoewjik";
		case "worldbit": return "kqzbkvnylatfrydl";
		}
		return null;
	}
	
	public String [] getMexAccount(){ // 0 - id, 1 - pw
		String id = "";
		String pw = "";
		
		switch(Project.getProjectName()){
		case "best":
		case "blockbit":
			id="newwave0101";
			pw="Choi958100@";
			break;
		case "macrobit": 
			id="crome1234";
			pw="Choi958100@";
			break;
		case "xbit":
			id="lustv";
			pw="Gogogo11!!";
			break;
		case "miixbit": 
			id="xiukor";
			pw="@Aa13579a";
			break;
		case "vetabit": 
			id="vetabit";
			pw="wjsenghks1Q";
			break;
		case "byflow": 
			id="olivia";
			pw="Qufgkfn6775!!";
			break;
		case "bexlime": 
			id="bitrichclub2";
			pw="!@#Bitrichmail1215!@#";
			break;
		case "graphttok": 
			id="graphttok";
			pw="Wortmthvmxm123!";
			break;
		case "bitocean": 
			id="jhkim6";
			pw="Bb870922!!";
			break;
		case "vista-bit": 
			id="vetabit";
			pw="wjsenghks1Q";
			break;
		case "BITWIN": 
			id="newwave0101";
			pw="Choi958100@";
			break;
		case "worldbit": 
			id="newwave0101";
			pw="Choi958100@";
			break;
		}
		
		if(id.isEmpty()){
			return null;
		}
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
