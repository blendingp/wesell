package egovframework.example.sample.classes;

import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.MessageSource;

public class Message {
	
	public static Message get(){
		if( manager == null)
			manager = new Message();
		return manager;
	}
	public static Message manager=null;
	
	public Locale getLocale(HttpServletRequest request){
		HttpSession session = request.getSession();
		if(session.getAttribute("lang") == null){
			return new Locale("en");
		}
		return new Locale((""+session.getAttribute("lang")).toLowerCase());
	}
	
	public String msg(MessageSource source, String code, HttpServletRequest request){
		String msg = source.getMessage(code, null, "", getLocale(request));
		return msg;
	}
	
	public String msg(MessageSource source, String code, String locale){
		String msg = source.getMessage(code, null, "", new Locale(locale));
		return msg;
	}

}
