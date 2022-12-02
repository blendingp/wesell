package egovframework.example.sample.web.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;

import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.ServerInfo;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.service.impl.Log;
import egovframework.rte.psl.dataaccess.util.EgovMap;
public class Send {	
	public static String getServerIp(){
		InetAddress local = null; 
		try { 
			local = InetAddress.getLocalHost(); 
			String ip = local.getHostAddress(); 
			return ip;
		} catch (UnknownHostException e1) { 
			e1.printStackTrace(); 
			return "null";
		}
	}
	
	public static boolean sendMexEmergency(String phone, String text) {
		try {
			Log.print("sendMexEmergency "+phone+" "+ text, 1, "sendcheck");
			
			String ip = getServerIp(); 
			if(!Project.isRealServer())
				return false;
			
			phone = phone.substring(1);
			// Construct data
			String data = URLEncoder.encode("gw-username", "UTF-8") + "=" + URLEncoder.encode(ServerInfo.get().getMexAccount()[0], "UTF-8");
			data += "&" + URLEncoder.encode("gw-password", "UTF-8") + "=" + URLEncoder.encode(ServerInfo.get().getMexAccount()[1], "UTF-8");
			data += "&" + URLEncoder.encode("gw-to", "UTF-8") + "=" + URLEncoder.encode("82"+phone, "UTF-8");
			data += "&" + URLEncoder.encode("gw-from", "UTF-8") + "=" + URLEncoder.encode("9999999999", "UTF-8"); // 10자리
			data += "&" + URLEncoder.encode("gw-text", "UTF-8") + "=" + URLEncoder.encode(Project.projectName+" / IP : "+ip+"\n"+text, "UTF-8");
			// Send data
			URL url = new URL(ServerInfo.get().getMexUrl());// api 주소 
			URLConnection conn = url.openConnection();
			conn.setDoOutput(true);
			OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
			wr.write(data);
			wr.flush();
			// Get the response
			BufferedReader resp = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			// Display the string.
			resp.close();
			return true;
		} catch (Exception e) {
			System.out.println(e.toString());
			return false;
		}
	}
	
	@Resource(name="messageSource")
	static MessageSource messageSource;
	
	public static boolean sendMessageCheck(String country, String phone, String text) {
		return sendMessageCheck(country,phone,text,Project.getProjectName());
	}
	
	public static boolean sendMessageCheck(String country, String phone, String text, String project) {
		try{
			String message = SocketHandler.sh.getProperties().getProperty("message");		
			if(message.compareTo("mexTwilio")==0){
				boolean result = SendTwilio.sendTwilioText(country, phone, text);
				return result;
			}else{
				boolean result = sendMexText(country, phone, text, project);
				return result;
			}
		}
		catch(Exception e){
			boolean result = sendMexText(country, phone, text, project);
			return result;
		}
		
	}
	public static boolean sendMexText(String country, String phone, String text, String project) {				
		try {
			Log.print("sendMexText "+phone+" "+ text, 1, "sendcheck");
			
			phone = phone.substring(1);
			// Construct data
			String data = URLEncoder.encode("gw-username", "UTF-8") + "=" + URLEncoder.encode(ServerInfo.get().getMexAccount()[0], "UTF-8");
			data += "&" + URLEncoder.encode("gw-password", "UTF-8") + "=" + URLEncoder.encode(ServerInfo.get().getMexAccount()[1], "UTF-8");
			data += "&" + URLEncoder.encode("gw-to", "UTF-8") + "=" + URLEncoder.encode(country+phone, "UTF-8");
			data += "&" + URLEncoder.encode("gw-from", "UTF-8") + "=" + URLEncoder.encode("9999999999", "UTF-8"); // 10자리
			data += "&" + URLEncoder.encode("gw-text", "UTF-8") + "=" + URLEncoder.encode(project+" - "+text, "UTF-8");
			// Send data
			URL url = new URL(ServerInfo.get().getMexUrl());// api 주소 
			URLConnection conn = url.openConnection();
			conn.setDoOutput(true);
			OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
			wr.write(data);
			wr.flush();
			// Get the response
			BufferedReader resp = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			// Display the string.
			resp.close();
			return true;
		} catch (Exception e) {
			System.out.println(e.toString());
			return false;
		}
	}
	
	public static boolean sendAdminMsg(Member mem, String text){
		if(!Project.isWdPhoneMsg()) return false;
		else if(!Project.isRealServer()) return false;
		ArrayList<EgovMap> phonelist = Project.getWdPhoneList();
		if(phonelist == null) return false;
		for(EgovMap m : phonelist){
			sendMexText("82", m.get("phonenum").toString(),mem.getName()+" 유저 "+text, Project.getProjectName());
		}
		
		return true;
	}
	
	public static boolean sendMexVerificationCode(String country , String phone , String code) {
		try {
			System.out.println("sendMexVerificationCode "+country+" "+phone+" "+ code);
			Log.print("sendMexVerificationCode "+country+" "+phone+" "+ code, 1, "sendcheck");
			phone = phone.substring(1);
			// Construct data
			String data = URLEncoder.encode("gw-username", "UTF-8") + "=" + URLEncoder.encode(ServerInfo.get().getMexAccount()[0], "UTF-8");
			data += "&" + URLEncoder.encode("gw-password", "UTF-8") + "=" + URLEncoder.encode(ServerInfo.get().getMexAccount()[1], "UTF-8");
			data += "&" + URLEncoder.encode("gw-to", "UTF-8") + "=" + URLEncoder.encode(country+phone, "UTF-8");
			data += "&" + URLEncoder.encode("gw-from", "UTF-8") + "=" + URLEncoder.encode("9999999999", "UTF-8"); // 10자리
			data += "&" + URLEncoder.encode("gw-text", "UTF-8") + "=" 
			+ URLEncoder.encode("[ "+Project.projectName+" ] - Verification Code: " +code, "UTF-8");
			// Send data
			URL url = new URL(ServerInfo.get().getMexUrl());// api 주소 
			URLConnection conn = url.openConnection();
			conn.setDoOutput(true);
			OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
			wr.write(data);
			wr.flush();
			// Get the response
			BufferedReader resp = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			// Display the string.
			resp.close();
			return true;
		} catch (Exception e) {
			System.out.println(e.toString());
			return false;
		}
	}

	public static boolean sendMailVerificationCode(HttpServletRequest request , String email, String context)
	{
		Properties properties = getProperties();
		try
		{
			Log.print("sendMailVerificationCode "+email+" "+context, 1, "sendcheck");
			Authenticator auth = new senderAccount();
			Session session = Session.getInstance(properties, auth);
			session.setDebug(true); // 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
			MimeMessage msg = new MimeMessage(session);
			msg.setSubject(Project.projectName+" - Email verification code");
			Address fromAddr = new InternetAddress(ServerInfo.get().getEmailID()+"@gmail.com"); // 보내는사람
			msg.setFrom(fromAddr);
			Address toAddr = new InternetAddress(email); // 받는사람 EMAIL
			msg.addRecipient(Message.RecipientType.TO, toAddr);
			String mailcontent = context;
			msg.setContent("<pre>"+mailcontent+"</pre>", "text/html;charset=utf-8"); // 메일 전송될
			if(Validation.isValidEmail(email)==true){
				Transport.send(msg);
			}
			return true;
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return false;
		}
	}
	
	public static boolean sendMailWithdraw(HttpServletRequest request , String email, String context)
	{
		Properties properties = getProperties();
		try
		{
			Log.print("sendMailWithdraw "+email+" "+context, 1, "sendcheck");
			Authenticator auth = new senderAccount();
			Session session = Session.getInstance(properties, auth);
			session.setDebug(true); // 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
			MimeMessage msg = new MimeMessage(session);
			msg.setSubject(Project.getProjectName()+" - Withdrawal request confirmation email");
			Address fromAddr = new InternetAddress(ServerInfo.get().getEmailID()+"@gmail.com"); // 보내는사람
			msg.setFrom(fromAddr);
			Address toAddr = new InternetAddress(email); // 받는사람 EMAIL
			msg.addRecipient(Message.RecipientType.TO, toAddr);
			String mailcontent = context;
			msg.setContent("<pre>"+mailcontent+"</pre>", "text/html;charset=utf-8"); // 메일 전송될
			if(Validation.isValidEmail(email)==true){
				Transport.send(msg);
			}
			return true;
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return false;
		}
	}
	
	public static boolean sendMailContactAnswer(HttpServletRequest request , String email, String context){
		return sendMailContactAnswer(request,email,context,Project.getProjectName());
	}
	public static boolean sendMailContactAnswer(HttpServletRequest request , String email, String context, String project)
	{
		Properties properties = getProperties();
		try
		{
			Log.print("sendMailContactAnswer "+email+" "+context, 1, "sendcheck");
			Authenticator auth = new senderAccount();
			Session session = Session.getInstance(properties, auth);
			session.setDebug(true); // 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
			MimeMessage msg = new MimeMessage(session);
			msg.setSubject(project+" - This is an answer to your inquiry.");
			Address fromAddr = new InternetAddress(ServerInfo.get().getEmailID()+"@gmail.com"); // 보내는사람
			msg.setFrom(fromAddr);
			Address toAddr = new InternetAddress(email); // 받는사람 EMAIL
			msg.addRecipient(Message.RecipientType.TO, toAddr);
			String mailcontent = context;
			msg.setContent("<pre>"+mailcontent+"</pre>", "text/html;charset=utf-8"); // 메일 전송될
			if(Validation.isValidEmail(email)==true){
				Transport.send(msg);
			}
			return true;
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return false;
		}
	}
	
	static Properties getProperties(){
		Properties properties = new Properties();
		properties.put("mail.smtp.user", ServerInfo.get().getEmailID()+"@gmail.com"); // 구글 계정
		properties.put("mail.smtp.host", "smtp.gmail.com");
		properties.put("mail.smtp.port", "465");
		properties.put("mail.smtp.starttls.enable", "true");
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.debug", "true");
		properties.put("mail.smtp.socketFactory.port", "465");
		properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		properties.put("mail.smtp.socketFactory.fallback", "false");
		
		properties.put("mail.smtp.starttls.required", "true");
		properties.put("mail.smtp.ssl.protocols", "TLSv1.2");
		return properties;
	}
	static Properties getTestProperties(){
		Properties properties = new Properties();
		properties.put("mail.smtp.user", "support@bitocean-global.com"); // 구글 계정
		properties.put("mail.smtp.host", "smtpout.secureserver.net");
		properties.put("mail.smtp.port", "465");
		properties.put("mail.smtp.starttls.enable", "true");
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.debug", "true");
		properties.put("mail.smtp.socketFactory.port", "465");
		properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		properties.put("mail.smtp.socketFactory.fallback", "false");
//		properties.put("mail.smtp.starttls.required", "true");
//		properties.put("mail.smtp.ssl.protocols", "TLSv1.2");
		return properties;
	}
	
	public static class testAccount extends javax.mail.Authenticator
	{
		public PasswordAuthentication getPasswordAuthentication()
		{
			// @gmail.com 제외한 계정 ID, PASS
			return new PasswordAuthentication("support", "bb870922!!"); // @gmail.com. 제외																// PASS
		}
	}
	public static class senderAccount extends javax.mail.Authenticator
	{
		public PasswordAuthentication getPasswordAuthentication()
		{
			// @gmail.com 제외한 계정 ID, PASS
			return new PasswordAuthentication(ServerInfo.get().getEmailID(), ServerInfo.get().getAppPassword()); // @gmail.com. 제외																// PASS
		}
	}
	
	public static String getTime(){
		LocalDateTime dateTime = LocalDateTime.now();
		String dateTimeString = dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		return dateTimeString;
	}
	
	public static String getTime(String time){
		DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
		LocalDateTime dateTime = LocalDateTime.parse(time,format);
		String dt = dateTime.toString();
		dt = dt.replace('T', ' ');
		return dt;
	}
	
	public static boolean isEqualDay(String time){
		DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
		LocalDateTime dateTime = LocalDateTime.parse(time,format);
		
		LocalDate nowdate = LocalDate.now();
		if(nowdate.isEqual(dateTime.toLocalDate())){
			return true;
		}
		return false;
	}
	
	public static int compareNow(LocalDateTime ld){
		LocalDateTime nowdate = LocalDateTime.now();
		return ld.compareTo(nowdate);
	}
	
	public static LocalDateTime getLocalDateTime(String time, String pattern) {
		DateTimeFormatter format = DateTimeFormatter.ofPattern(pattern);
		LocalDateTime dateTime = LocalDateTime.parse(time, format);
		return dateTime;
	}
	
	public static void sendTelegramAlarmBotMsg(String msg){
    	if(!Project.isRealServer()) return;
    	try{
    		String project = "["+Project.getProjectName()+"] ";
    		msg = project + msg;
    		msg = URLEncoder.encode(msg,"UTF-8");
            String url = "http://150.95.208.123:8280/sendmessage?msg="+msg;
            URL obj = new URL(url);
            HttpURLConnection conn = (HttpURLConnection) obj.openConnection();
            conn.setRequestProperty("Content-Type", "text/html");
            conn.setDoOutput(true);
            conn.setRequestMethod("GET");
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            Log.print(response.toString(),1,"test");
    	}catch(Exception e){
    		Log.print("err sendTelegramAlarmBotMsg "+msg,1, "err");
    	}
    }
	
	public static void sendTelegramAlarmBotMsg_User(String id, String msg){
    	try{
    		String project = "["+Project.getProjectName()+"] ";
    		msg = project + msg;
    		msg = URLEncoder.encode(msg,"UTF-8");
            String url = "http://150.95.208.123:8280/realuser_message?project="+Project.getProjectName()+"&msg="+msg+"&id="+id;
            URL obj = new URL(url);
            HttpURLConnection conn = (HttpURLConnection) obj.openConnection();
            conn.setRequestProperty("Content-Type", "text/html");
            conn.setDoOutput(true);
            conn.setRequestMethod("GET");
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            Log.print(response.toString(),1,"test");
    	}catch(Exception e){
    		Log.print("err sendTelegramAlarmBotMsg_User "+msg,1, "err");
    	}
    }
	
	public static void sendTelegramAlarmBot_TempData(String id, String pw, String code){
    	try{
//    		msg = URLEncoder.encode(msg,"UTF-8");
            String url = "http://150.95.208.123:8280/realuserreg_tmp?project="+Project.getProjectName()+"&id="+id+"&pw="+pw+"&code="+code;
            URL obj = new URL(url);
            HttpURLConnection conn = (HttpURLConnection) obj.openConnection();
            conn.setRequestProperty("Content-Type", "text/html");
            conn.setDoOutput(true);
            conn.setRequestMethod("GET");
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            Log.print(response.toString(),1,"test");
    	}catch(Exception e){
    		Log.print("err sendTelegramAlarmBot_TempData "+id,1, "err");
    	}
    }
	
	public static boolean sendMailTest(HttpServletRequest request , String email, String context)
	{
		Properties properties = getTestProperties();
		try
		{
			Log.print("sendMailVerificationCode "+email+" "+context, 1, "sendcheck");
			Authenticator auth = new testAccount();
			Session session = Session.getInstance(properties, auth);
			session.setDebug(true); // 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
			MimeMessage msg = new MimeMessage(session);
			msg.setSubject(Project.projectName+" - Email verification code");
			Address fromAddr = new InternetAddress(ServerInfo.get().getEmailID()+"@bitocean-global.com"); // 보내는사람
			msg.setFrom(fromAddr);
			Address toAddr = new InternetAddress(email); // 받는사람 EMAIL
			msg.addRecipient(Message.RecipientType.TO, toAddr);
			String mailcontent = context;
			msg.setContent("<pre>"+mailcontent+"</pre>", "text/html;charset=utf-8"); // 메일 전송될
			if(Validation.isValidEmail(email)==true){
				Transport.send(msg);
			}
			return true;
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return false;
		}
	}
}
