package egovframework.example.sample.classes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
 
public class AdminUtil {
 
	// int 는 없으면 -1 string 은 없으면 null
	
	public static void insertAdminLog(HttpServletRequest request, SampleDAO sampleDAO , AdminLog log , int uidx, String coin , int action , double change , String result){
		insertAdminLog(request, sampleDAO , log , uidx, coin , action , ""+change , result);
	}
	
	public static void insertAdminLog(HttpServletRequest request, SampleDAO sampleDAO , AdminLog log , int uidx, String coin , int action , String change , String result){
		EgovMap in = new EgovMap();
		HttpSession session = request.getSession();
		String aidx = ""+session.getAttribute("adminIdx");
		in.put("kind", log.getValue());
		in.put("uidx", uidx);
		in.put("aidx", aidx);
		if(coin != null)in.put("etc1", coin);
		if(action != -1)in.put("etc2", action);
		if(change != null && !change.isEmpty())in.put("etc3", change);
		if(result != null)in.put("etc4", result);
		sampleDAO.insert("insertAdminLog" , in);
	}
	
	public static boolean highAdminCheck(HttpSession session){
		if(Project.isSubAdminPower() || session.getAttribute("adminLevel") != null && session.getAttribute("adminLevel").toString().compareTo("1")==0){
			return true;
		}
		return false;
	}
}