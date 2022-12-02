package egovframework.example.sample.classes;

import java.io.IOException;

import org.json.simple.JSONObject;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import egovframework.example.sample.service.impl.Log;

public class SendMsg {
	public WebSocketSession session;
	public JSONObject jobj;

	public SendMsg(WebSocketSession tsession,JSONObject _jobj) 
	{
		session = tsession;
		this.jobj=_jobj;
	}
	public void send(){
		try {
			synchronized(session){
				session.sendMessage(new TextMessage(jobj.toString()));
			}
		} catch (IOException e) {
			Log.print("sendMessage Err! text="+jobj.toString(), 1,"err");
			e.printStackTrace();
		}
	}
	public SendMsg deepCopy(){
		SendMsg sm = new SendMsg(this.session,this.jobj);
		return sm;
	}
}
