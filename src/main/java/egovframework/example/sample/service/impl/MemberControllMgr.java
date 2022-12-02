package egovframework.example.sample.service.impl;

import egovframework.example.sample.classes.SocketHandler;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class MemberControllMgr {
	
	public static MemberControllMgr get(){
		if( manager == null)
			manager = new MemberControllMgr();
		return manager;
	}
	public static MemberControllMgr manager=null;
	
	public String insertTestMember(int count, int wallet){
		Integer lastIdx = (Integer)SocketHandler.sh.getSampleDAO().select("selectMemberLastIndex");
		if(lastIdx == null)
			lastIdx = 0;
		
		String insertUser = "";
		EgovMap in = new EgovMap();
		for(int i = 0; i < count; i++){
			in.put("idx", ++lastIdx);
			in.put("wallet", wallet);
			SocketHandler.sh.getSampleDAO().insert("insertTestMember",in);
			insertUser+="Testuser"+lastIdx+"\n";
		}
		return insertUser;
	}
}
