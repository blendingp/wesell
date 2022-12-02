package egovframework.example.sample.web.util;


import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

//Install the Java helper library from twilio.com/docs/libraries/java
import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.rest.api.v2010.account.ValidationRequest;
import com.twilio.type.PhoneNumber;

import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.ServerInfo;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.example.sample.service.impl.SampleDAO;

@Controller
public class SendTwilio{
	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
 // Find your Account Sid and Auth Token at twilio.com/console
 public static final String ACCOUNT_SID =
         "AC1673b1c1d6a7706fd55dcba46423fc7b";
 public static final String AUTH_TOKEN =
         "f75ff80701aee8f11e26c391b50808dc";

 @RequestMapping(value = "/sendM.do")
public String sendM(HttpServletRequest request, ModelMap model) throws Exception {
	 System.out.println("send before");
	 twilioSendMessage();
	 System.out.println("send after");
	return "redirect:/main.do";
}
 public void twilioSendMessage() {
	 System.out.println("step1");
     Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
/*     ValidationRequest validationRequest = ValidationRequest.creator(
             new com.twilio.type.PhoneNumber("+821075741234"))
         .setFriendlyName("My Home Phone Number")
         .create();
     
     System.out.println("step2");
     System.out.println(validationRequest.getFriendlyName());
     System.out.println("step3");*/
     
     Message message = Message
             .creator(new PhoneNumber("+821028701012"), // to
                     new PhoneNumber("+17047515010"), // from
                     "Test Message")
             .create();
     System.out.println("step4");
     System.out.println(message.getSid());
     System.out.println("step5");
 }

	public static boolean sendTwilioVerificationCode(String country , String phone , String code) {
		try {
			if(country.compareTo("82")==0){
				boolean result = Send.sendMexVerificationCode(country, phone, code);
				return result;
			}
			Log.print("sendTwilioVerificationCode "+country+" "+phone+" "+ code, 1, "sendcheck");
			 System.out.println("step1");
		     Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
		     phone = phone.substring(1);
		     phone = country+phone;
		     String myMessage = "[ "+Project.projectName+" ] - Verification Code: " +code;		     
		     Message message = Message
		             .creator(new PhoneNumber("+"+phone), // to
		                     new PhoneNumber("+17047515010"), // from
		                     myMessage)
		             .create();
		     System.out.println("step4");
		     System.out.println(message.getSid());
		     System.out.println("step5");			
			return true;
		} catch (Exception e) {
			System.out.println(e.toString());
			return false;
		}
	}

	public static boolean sendTwilioText(String country, String phone, String text) {
		try {
			if(country.compareTo("82")==0){
				boolean result = Send.sendMexVerificationCode(country, phone, text);
				return result;
			}
			Log.print("sendTwilioVerificationCode "+country+" "+phone+" ", 1, "sendcheck");
			 System.out.println("step1");
		     Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
		     phone = phone.substring(1);
		     phone = country+phone;
		     		     
		     Message message = Message
		             .creator(new PhoneNumber("+"+phone), // to
		                     new PhoneNumber("+17047515010"), // from
		                     text)
		             .create();
		     System.out.println("step4");
		     System.out.println(message.getSid());
		     System.out.println("step5");			
			return true;
		} catch (Exception e) {
			System.out.println(e.toString());
			return false;
		}
	}	
}
