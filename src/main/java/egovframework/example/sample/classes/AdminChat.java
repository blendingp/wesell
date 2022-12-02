package egovframework.example.sample.classes;

import java.util.ArrayList;
import java.util.Iterator;

import org.json.simple.JSONObject;
import org.springframework.web.socket.WebSocketSession;

import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class AdminChat {
	String text;
	String time;
	boolean isAdmin;
	int pidx;
	boolean userRead = false;
	boolean adminRead = false;
	
	public AdminChat(boolean isAdmin, int pidx, String text, String time, boolean adminRead, boolean userRead){
		this.time = Send.getTime(time);
		this.text = text;
		this.isAdmin = isAdmin;
		this.pidx = pidx;
		this.adminRead = adminRead;
		this.userRead = userRead;
	}
	
	public AdminChat(boolean isAdmin, int pidx, String text){
		this.time = Send.getTime();
		this.text = text;
		this.isAdmin = isAdmin;
		this.pidx = pidx;
		if(this.isAdmin)
			this.adminRead = true;
		else
			this.userRead = true;
			
	}
	
	public static boolean chat(boolean isAdmin, Member user, int pidx, String text){
		if(user == null){
			Log.print("chat 전송 실패. Member정보 없음", 1, "err");
			return false;
		}
		AdminChat newchat = new AdminChat(isAdmin, pidx, text);
		user.getChats().add(newchat);
		//서버에 프로토콜 전송
		JSONObject obj = new JSONObject();
		obj.put("protocol", "chatMsg");
		obj.put("userIdx", user.userIdx);
		obj.put("pidx", pidx);
		obj.put("text", text);
		obj.put("time", newchat.time);
		obj.put("isAdmin", isAdmin);
		SocketHandler.sh.sendAdminMessage(obj);
		SocketHandler.sh.sendMessageToMeAllBrowser(obj);
		
		//db waitquery 추가
		EgovMap in = new EgovMap();
		in.put("userIdx", user.userIdx);
		in.put("pidx", pidx);
		in.put("text", text);
		in.put("time", newchat.time);
		in.put("isAdmin", isAdmin);
		QueryWait.pushQuery("insertChatLog", user.userIdx, in, QueryType.INSERT);
		return true;
	}
	
	public static void initList(Member user){
		EgovMap in = new EgovMap();
		in.put("userIdx", user.userIdx);
		ArrayList<EgovMap> msgList = (ArrayList<EgovMap>)SocketHandler.sh.getSampleDAO().list("selectChatList",in);
		for(EgovMap msg : msgList){
			boolean isAdmin = Boolean.parseBoolean(msg.get("isAdmin").toString());
			int pidx = Integer.parseInt(msg.get("pidx").toString());
			String text = msg.get("text").toString();
			String time = msg.get("time").toString();
			boolean adminRead = Boolean.parseBoolean(msg.get("adminRead").toString());
			boolean userRead = Boolean.parseBoolean(msg.get("userRead").toString());
			AdminChat newchat = new AdminChat(isAdmin, pidx, text, time, adminRead, userRead);
			user.getChats().add(newchat);
		}
	}
	
	public static void p2pReload(Member user, int tidx){
		JSONObject obj = new JSONObject();
		obj.put("protocol", "p2pReload");
		obj.put("userIdx", user.userIdx);
		obj.put("tidx", tidx);
		SocketHandler.sh.sendAdminMessage(obj);
		SocketHandler.sh.sendMessageToMeAllBrowser(obj);
	}
	
	public static void read(boolean isAdmin, Member user, int pidx){
		ArrayList<AdminChat> chats = user.getUnreadChats(isAdmin,pidx);
		for(AdminChat chat : chats){
			if(isAdmin)
				chat.adminRead=true;
			else
				chat.userRead=true;
		}
		EgovMap in = new EgovMap();
		in.put("userIdx", user.userIdx);
		in.put("pidx", pidx);
		if(isAdmin)
			in.put("adminRead", true);
		else
			in.put("userRead", true);
		
		QueryWait.pushQuery("updateChatRead", user.userIdx, in, QueryType.UPDATE, false);
	}
	
	public static boolean deleteChat(Member user, int pidx){
		ArrayList<AdminChat> chats = user.getChats();
		for(Iterator<AdminChat> iter = chats.iterator(); iter.hasNext(); ){
			AdminChat chat = iter.next();
			if(chat.pidx == pidx){
				iter.remove();
			}
		}
		
		EgovMap in = new EgovMap();
		in.put("userIdx", user.userIdx);
		in.put("pidx", pidx);
		QueryWait.pushQuery("deleteChatLog", user.userIdx, in, QueryType.DELETE);
		return true;
	}
}
