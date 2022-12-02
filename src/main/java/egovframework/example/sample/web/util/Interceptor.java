package egovframework.example.sample.web.util;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.MessageSource;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;

public class Interceptor  extends HandlerInterceptorAdapter{
	List<String> urls;
	@Resource (name="sampleDAO")
	private SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;
	
	public long timecheck;
	
	public void setUrls(List urls) {
		this.urls = urls;
	}

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    	HttpSession session = request.getSession();
    	String url = request.getRequestURI();
    	String[] urlArr = request.getRequestURI().split("/");
    	String userip = Member.getClientIP(request);
    	String userIdx = ""+session.getAttribute("userIdx");
		String path = "/wesell/";
		String subProject = Project.getProjectName();
		if(urlArr[2].equals(subProject))				
			path = path+subProject+"/";
		
		timecheck = System.currentTimeMillis();

		if(Project.isKrCode() && session.getAttribute("userIdx") != null){
			Member m = Member.getMemberByIdx(Integer.parseInt(userIdx));
			if(m.lastLoginLogout(session)){
				response.sendRedirect(path+"login.do?autoLogout=1");
				return false;
			}
		}
		
		if(url.equals(path+"user/main.do")){// user/main 로그인 안해도 됨.
			return true;
		}
		if(urlArr[2].equals("user") || urlArr[2].equals("trade.do") || urlArr[2].equals("tradeSpot.do")){// 유저 로그인이 필요한 페이지 일 경우  
			// 로그인 안되어있으면 로그인 페이지로 
			if(userIdx.isEmpty() || userIdx.equals("null")){ 
				response.sendRedirect(path+"login.do");
				return false;
			}
			if(Project.isVAccount()){
				Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
				if(!mem.vConfirm){
					response.sendRedirect(path+"vAccount.do");
					return false;
				}
			}
		}
		
		if(urlArr[2].equals("0nI0lMy6jAzAFRVe0DqLOw")){
			if(!adminServerCheck(request))
				return false;
		}
		
    	for(int i=0; i < urls.size(); i++){ // url이 무시해야될 url이면 
    		if(urls.get(i).equals(url)){
    			return true; // 바로 그 url로 이동 
    		}
    		else if(url.contains(subProject)){
    			String [] reurl = url.split(subProject+"/");
    			if(reurl.length > 1 && urls.get(i).equals(reurl[0]+reurl[1])){
        			return true; // 바로 그 url로 이동 
        		}
    		}
    	}
    	
    	if(urlArr[2].equals("WEB-INF")){
    		return true;
    	}else if(urlArr[2].equals("0nI0lMy6jAzAFRVe0DqLOw")){// 관리자의 경우 
			// 로그인 안되어있으면 로그인 페이지로 
			if(session.getAttribute("adminLogin") == null){ 
    			response.sendRedirect("/wesell/0nI0lMy6jAzAFRVe0DqLOw/login.do");
    			return false;
			}
			if(!adminIpCheck(userip, request)){
				session.setAttribute("adminIdx",null);
				session.setAttribute("adminLogin", null);
				response.sendRedirect("/wesell/0nI0lMy6jAzAFRVe0DqLOw/login.do");
				return false;
			}
			String adminLevel = ""+session.getAttribute("adminLevel");
			
			if(adminLevel.equals("3")){
				if(urlArr[urlArr.length-2].equals("p2p")){
					return true;
				}
				switch(urlArr[urlArr.length-1]){
				case "getDangerRead.do":
				case "isAllAlarmCheck.do":
					return true;
				default:
					System.out.println(urlArr[urlArr.length-1]);
					response.sendRedirect("/wesell/0nI0lMy6jAzAFRVe0DqLOw/p2p/p2pLog.do?kind=d");
					return false;
				}
			}
			
			switch (urlArr[urlArr.length-1]) {
				case "deleteSubAdmin.do":
				case "changeAuthkey.do":
				case "subAdminList.do":
				case "createSubAdmin.do":
				case "log.do":
					if( adminLevel.equals("1"))
						return true;
					response.sendRedirect("/wesell/0nI0lMy6jAzAFRVe0DqLOw/login.do");
					return false;
				default:
					return true;
			}
		}else{ // 점검중 처리			
			if(SocketHandler.fixstat == 1){									
				response.sendRedirect(path+"showRest.do");
				return false;
			}
		}

		for(int i = 0; i < SocketHandler.ipBanList.size(); i++){
			if(userip.compareTo(SocketHandler.ipBanList.get(i).get("ip").toString()) == 0){
				response.sendRedirect(path+"block.do");
				return false;
			}
		}
		for(int i = 0; i < SocketHandler.userBanList.size(); i++){
			if(userIdx.compareTo(SocketHandler.userBanList.get(i).get("useridx").toString()) == 0){
				response.sendRedirect(path+"block.do");
				return false;
			}
		}
		
		if(!request.getServerName().equals("localhost")){
//			boolean p2pServer = isP2PServer(request);
//			if(urlArr[2].equals("easy")){
//				if(p2pServer) return true;
//			}else{
//				if(p2pServer) return false;
//			}
			return true;
		}
		
		if(urlArr[2].equals(subProject)){
			if(urlArr[3].equals("infl")){
				if(!urlArr[4].equals("login.do") && session.getAttribute("inflLogin") == null){ 
	    			response.sendRedirect(path+"infl/login.do");
	    			return false;
				}					
			}else{
				if(session.getAttribute("userIdx") == null){ 
					switch (urlArr[urlArr.length-1]) {
					case "wallet.do":
					case "walletWithdraw.do":
					case "transactions.do":
					case "myInfo.do":
					case "tradeHistory.do":
					case "fundingHistory.do":
					case "traderList.do":
						response.sendRedirect(path+"login.do");
						return false;
					default:
						return true;
					}
				}
			}
		}
		
		if(urlArr[2].equals("infl")){// 인플루언서
			// 로그인 안되어있으면 로그인 페이지로 
			if(session.getAttribute("inflLogin") == null){ 
    			response.sendRedirect(path+"infl/login.do");
    			return false;
			}
		}
		
		if(Project.isKyc()){
			if(!userIdx.equals("null")){
				Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
				if(!mem.isKyc && url.contains("/user/") && !url.contains("kycCenter.do")){
					
					response.sendRedirect(path+"user/kycCenter.do");
					return false;
				}
			}
		}
        return true;
    }
  
    // 컨트롤러가 수행되고 화면이 보여지기 직전에 수행되는 메서드
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
    	if(modelAndView != null){
    		long after = System.currentTimeMillis();
    		Log.print("접속성공 걸린시간 = "+(after - timecheck)+" ms / url = "+modelAndView.getViewName(), 1, "timecheck");
    	}
        super.postHandle(request, response, handler, modelAndView);
    }   
    
    private boolean adminServerCheck(HttpServletRequest request){
    	String serverName = request.getServerName();
		String project = Project.getProjectName();
		
		if(serverName.equals("localhost")) return true;
		switch(project){
		case "wesell": if(serverName.equals("wesell.com")) return false;
		}
		return true;
    }
    
    private boolean adminIpCheck(String userip, HttpServletRequest request){
    	if(Project.isAdminIp()){
    		String serverName = request.getServerName();
    		if(serverName.equals("localhost") ||  
    				(userip.length() <= 15 && userip.startsWith("61.79.227") || userip.startsWith("118.37.234") || userip.startsWith("211.222.65") || userip.startsWith("183.102.237"))) 
    			return true;
    		
    		Log.print("userIp = "+userip, 1, "test");
			boolean adminIp = false;
			for(int i = 0; i < SocketHandler.adminIpList.size(); i++){
				if(userip.equals(SocketHandler.adminIpList.get(i).get("ip")))
					adminIp = true;
			}
			if(!adminIp){ // 관리자IP 아니면 강제로그아웃
				return false;
			}
		}
    	return true;
    }
    
    private boolean isP2PServer(HttpServletRequest request){
    	String serverName = request.getServerName();
    	String project = Project.getProjectName();
    	switch(project){
    	case "bitocean": if(serverName.equals("easy-exchange.net")) return true;
    	}
    	return false;
    }
}
