package egovframework.example.sample.classes;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class Member {
	public int userIdx = 0;
	double wallet = 0;
	double walletUSDT = 0;
	double [] walletC = null;
	
	String level = "";
	String parentsLevel = "admin"; //초기값 admin 직속 회원으로 설정
	String name = "";
	public String phone = "";
	public String pw = "";
	public String bank = "";
	public String account = "";
	public int parentsIdx = 0;
	public boolean block = false;
	Member parent = null;
	public double myRate = 0;
	int istest = 0;
	Trader traderInfo = null;
	public boolean isTrader = false;
	boolean isDanger = false;
	public String inviteCode;
	double dMoney = 0;
	public Double accum = null;
	public int jstat = 0;
	private ArrayList<AdminChat> chats = new ArrayList<AdminChat>();
	public double accumWd = 0;
	public boolean isKyc = false;
	public boolean isKrCode = false;
	public HttpSession lastLoginWebSession = null;
	public double depositUSDT = 0;
	private boolean callDepositUSDT = false;
	private int orderCnt = 0;
	public boolean vConfirm = false;
	public boolean mute = false;
	
	private Boolean p2pRun = null;
	
	public double getMyGetRate(Member member){
		while(member.parentsIdx != -1){
			if(member.parentsIdx == userIdx)
				return myRate - member.myRate;
			else
				member = member.parent;
		}
		return 0;	
	}
	
	public boolean p2pCheck(){
		if(Project.isP2P()){
			if(p2pRun == null){
				EgovMap in = new EgovMap();
				in.put("userIdx",userIdx);
				if(SocketHandler.sh.getSampleDAO().select("selectAnyRunP2P",in) != null)
					p2pRun = true;
				else
					p2pRun = false;
			}
			return p2pRun;
		}
		return false;
	}
	
	public void setMute(SampleDAO dao, int val){
		boolean setval = false;
		if(val==1) setval = true;
		mute = setval;
		EgovMap in = new EgovMap();
		in.put("idx",userIdx);
		in.put("mute",val);
		dao.update("updateToggleMute",in);
//		QueryWait.pushQuery("updateToggleMute", userIdx, in, QueryType.UPDATE);
		
	}
	public void resetP2PRun(){
		p2pRun = null;
	}
	public String getOrderNum(){
		orderCnt++;
		if(orderCnt >= 10)
			orderCnt -= 10;
		return ""+System.currentTimeMillis()+orderCnt+userIdx;
	}
	
	public void updateAccumWd(double accumUsdt){
		if(Project.isLimitWd()){
			accumWd += accumUsdt;
			EgovMap in = new EgovMap();
			in.put("userIdx", userIdx);
			in.put("accumWd", accumWd);
			QueryWait.pushQuery("updateMemberAccumWd", userIdx, in, QueryType.UPDATE);
		}
	}
	public void resetAccumWd(){
		if(Project.isLimitWd() && accumWd != 0){
			accumWd = 0;
			EgovMap in = new EgovMap();
			in.put("userIdx", userIdx);
			in.put("accumWd", accumWd);
			QueryWait.pushQuery("updateMemberAccumWd", userIdx, in, QueryType.UPDATE);
		}
	}
	
	public boolean unReadChat(){
		return false;
	}
	public boolean isUnreadChats(){
		for(AdminChat chat : chats){
			if(!chat.userRead){
				return true;
			}
		}
		return false;
	}
	public ArrayList<AdminChat> getUnreadChats(boolean isAdmin, int pidx){
		ArrayList<AdminChat> unreadlist = new ArrayList<>();
		for(AdminChat chat : chats){
			if(chat.pidx == pidx){
				if(isAdmin && !chat.adminRead){
					unreadlist.add(chat);
				}else if(!isAdmin && !chat.userRead){
					unreadlist.add(chat);
				}
			}
		}
		return unreadlist;
	}
	public ArrayList<AdminChat> getChats(){
		return chats;
	}
	public ArrayList<EgovMap> getChatData(int pidx){
		ArrayList<EgovMap> adminChats = new ArrayList<>();
		for(AdminChat chat : chats){
			if(chat.pidx == pidx){
				EgovMap tmp = new EgovMap();
				tmp.put("time", chat.time);
				tmp.put("text", chat.text);
				tmp.put("isAdmin", chat.isAdmin);
				tmp.put("pidx", chat.pidx);
				adminChats.add(tmp);
			}
		}
		return adminChats;
	}
	
	public boolean getKrCode(){
		ArrayList<Member> parents = new ArrayList<>();
		parents = getParents(this);
		if(parents.size() != 0){
			return parents.get(parents.size()-1).isKrCode;
		}
		return isKrCode;
    }
	
	public void setKrCode(boolean kr, SampleDAO dao){
		this.isKrCode = kr;
		EgovMap in = new EgovMap();
		in.put("krCode", isKrCode);
		in.put("userIdx", userIdx);
		dao.update("updateMemberKrCode",in);
	}
	
	public static ArrayList<Member> getParents(Member user){
		ArrayList<Member> parents = new ArrayList<>();
		while(user.parent != null){
			parents.add(user.parent);
			user = user.parent;
		}
		return parents;
	}
	
	public String getLevel(){
		return level;
	}
	public Member getParent(){
		return parent;
	}
	public ArrayList<Member> getChildrenChong(){
		ArrayList<Member> children = new ArrayList<>();
		synchronized(SocketHandler.members){
			for(Member m : SocketHandler.members){
				if(m.parent != null && m.parent.userIdx == userIdx && m.level.equals("chong")){
					children.add(m);
					children.addAll(m.getChildrenChong());
				}
			}
		}
		return children;
	}
	
	public void accumPile(BigDecimal pile){
		Double prev = getAccum();
		if(prev == null) return;
		
		BigDecimal now = BigDecimal.valueOf(prev).add(pile);
		accum = now.doubleValue();
	}
	public void giveAccum(){
		accum=0.0;
	}
	public Double getAccum(){
		needCreateAccum();
		return accum;
	}
	public void needCreateAccum(){
		if(accum == null && !level.equals("user")){
			EgovMap in = new EgovMap();
			in.put("uidx", userIdx);
			in.put("givedate", "2000-01-01 00:00:00");
			QueryWait.pushQuery("insertAccumRef",userIdx, in, QueryType.INSERT);
			accum = 0.0;
		}
	}
	
	public void insertTrader(){
		if(!isTrader){
			EgovMap in = new EgovMap();
			in.put("tuseridx", userIdx);
			in.put("tintro", "");
			in.put("timg","");
			int tidx = (int)SocketHandler.sh.getSampleDAO().insert("insertTrader",in);
			
			in.put("tidx", tidx);
			in.put("tstat", 1);
			in.put("istrader", 1);
			SocketHandler.sh.getSampleDAO().update("updateUserTstat",in);
			
			isTrader = true;
			traderSetting();
		}
	}
	
	public void dangerCheck(String symbol, double money){ // 주의회원 거래 판별
		if(isDanger){
			if(dMoney < money){
				String msg = Send.getTime()+" / USER "+userIdx+"("+name+") 회원 "+PublicUtils.toFixed(money, 5)+" USDT 만큼 "+symbol+" 포지션 진입. ";
				JSONObject obj = new JSONObject();
				obj.put("protocol", "dangerTrade");
				obj.put("msg",msg);
				SocketHandler.sh.sendAdminMessage(obj);
				SocketHandler.dangerMsg.add(msg);
				SocketHandler.dangerMsgRead++;
			}
		}
	}
	
	public void setName(String name){
		this.name = name;
	}
	public String getName(){
		return this.name;
	}
	
	public void setDanger(Double dmoney, SampleDAO dao){
		
		int danger = 0;
		if(dmoney == null || dmoney == 0){
			isDanger = false;
			dMoney = 0;
		}else{
			isDanger = true;
			dMoney = dmoney;
			danger = 1;
		}
		
		if(dao != null){
			EgovMap in = new EgovMap();
			in.put("idx", userIdx);
			in.put("dmoney", dmoney);
			in.put("danger", danger);
			dao.update("updateUserDanger" , in);
		}
	}
	
	public void setIstest(int istest){
		this.istest = istest;
	}
	
	
	public boolean getIstest(){
		if(istest == 0)
			return false;
		return true;
	}
	
	public String getInfo(){
		String info = "level:"+level+" parentsLevel:"+parentsLevel+
				" parentsIdx:"+parentsIdx+
				" myRate:"+myRate+" istest:"+istest;
				
		return info;
	}
	
	public void setLevel(String level){
		this.level = level;
	}
	
	public void setBalance(){
		for(Coin coin : Project.getUseCoinList()){
			int cnum = coin.coinNum;
			setCoinValue(cnum, CointransService.getBalanceCoin(""+userIdx, coin.coinName));
		}
		setUSDT(CointransService.getBalanceCoin(""+userIdx, "USDT"));
	}
	
	
	public void setCoinValue(int coinnum , double value){
		walletC[coinnum] = Double.parseDouble(String.format("%.8f",value));
	}
	
	//현물usdt
	public void setUSDT(double value){
		walletUSDT = Double.parseDouble(String.format("%.8f",value));
		
		JSONObject obj = new JSONObject();
		obj.put("protocol", "update usdt");
		obj.put("userIdx", userIdx);
		obj.put("newBalance", walletUSDT);
		SocketHandler.sh.spotManager.sendMessageToMeAllBrowser(obj);
	}
	public Trader getTrader() { 
		if(!isTrader) return null;
		else if(!Project.isCopytrade()) return null;
		
		if(traderInfo == null){
			traderSetting();
		}
		return traderInfo;
	}
	public void setTrader(){
		isTrader = true;
		traderSetting();
	}
	public Member(String _userIdx, String _name, String _wallet,String _level, int _parentsIdx, int _istest, double _myRate, boolean _isTrader, Double dmoney, String _inviteCode, int _jstat, double accumwd, String kidx,
			String _phone, String _pw, String _bank, String _account, boolean isKrCode, boolean vConfirm, int mute){
		try {
			userIdx = Integer.parseInt(_userIdx);
			wallet = Double.parseDouble(_wallet);
		} catch (Exception e) {
			Log.print("Member err! "+e, 0, "member");
		}
		walletC = new double[Project.getFullCoinList().size()];
		this.jstat = _jstat;
		name = _name;
		phone = _phone;
		pw = _pw;
		bank = _bank;
		account = _account;
		level = _level;
		parentsIdx = _parentsIdx;
		istest = _istest;
		myRate = _myRate;
		accumWd = accumwd;
		this.isKrCode = isKrCode;
		this.inviteCode = _inviteCode;
		this.vConfirm = vConfirm;
		Log.print("Member 회원:"+userIdx, 0, "member");
		EgovMap in = new EgovMap();
		
		in.put("userIdx", userIdx);
		EgovMap blocked = (EgovMap)SocketHandler.sh.getSampleDAO().select("selectIsBan", in);
		if(blocked!=null)	block = true;
		
		try {
			in.put("userIdx", parentsIdx);						
			if(parentsIdx != -1)
			{
				EgovMap ed = (EgovMap)SocketHandler.sh.getSampleDAO().select("selectMemberLevelByIdx", in);
				if(ed!=null){
					parentsLevel = ""+ed.get("level");
//					parentsRate = Double.parseDouble(""+ed.get("commissionRate"));//부모의 수수료율					
				}
			}
		} catch (Exception e) {
			Log.print("Member err Parents set! "+e, 0, "member");
		}
		Log.print("parentsIdx: "+parentsIdx+" parentsLevel:"+parentsLevel, 0, "member");
		isTrader = _isTrader;
		//getSum();
		setBalance();
		setDanger(dmoney, null);
		setAccum();
		if(_parentsIdx != -1){
			this.parent = getMemberByIdx(_parentsIdx);
		}
		AdminChat.initList(this);
		p2pCheck();
		kycSetting(kidx);
		if(mute == 1)
			this.mute = true;
	}
	
	private void kycSetting(String kidx){
		if(Project.isKyc()){
			if(kidx.equals("null")){
				EgovMap in = new EgovMap();
				in.put("userIdx", userIdx);
				QueryWait.pushQuery("insertKyc", userIdx, in, QueryType.INSERT);
			}
			else{
				EgovMap kycInfo = (EgovMap)SocketHandler.sh.getSampleDAO().select("selectKyc", userIdx);
				if(Boolean.parseBoolean(kycInfo.get("confirm").toString())){
					this.isKyc = true;
				}
			}
		}
	}
	
	private void setAccum(){
		EgovMap in = new EgovMap();
		in.put("uidx", userIdx);
		EgovMap accum = (EgovMap)SocketHandler.sh.getSampleDAO().select("selectAccumRef", in);
		if(accum != null)
			this.accum = Double.parseDouble(accum.get("accum").toString());
		else
			getAccum();
	}
	
	private boolean[] getTraderUseCoins(ArrayList<EgovMap> traderCoinlist){
		boolean [] isSymbols = new boolean[Project.getFullCoinList().size()];

		EgovMap in = new EgovMap();
		in.put("tidx", userIdx);

		if(traderCoinlist.size() == 0){
			for(Coin coin : Project.getUseCoinList()){
				in.put("coinNum", coin.coinNum);
				SocketHandler.sh.getSampleDAO().insert("insertTraderCoinlist", in);
				isSymbols[coin.coinNum] = true;
			}
		}else{
			boolean [] isSet = new boolean[Project.getFullCoinList().size()];
			
			for(EgovMap tc : traderCoinlist){
				int cnum = Integer.parseInt(tc.get("coinNum").toString());
				boolean use = Boolean.parseBoolean(tc.get("use").toString());
				Coin coin = Coin.getCoinInfo(cnum);
				isSymbols[coin.coinNum] = use;
				isSet[coin.coinNum] = true;
			}
			for(int i = 0; i < isSet.length; i++){
				Coin coin = Coin.getCoinInfo(i);
				if(!coin.isUse) continue;
				if(!isSet[i]){
					in.put("coinNum", coin.coinNum);
					SocketHandler.sh.getSampleDAO().insert("insertTraderCoinlist", in);
					isSymbols[coin.coinNum] = true;
				}
			}
		}
		
		return isSymbols;
	}
	private void traderSetting(){
		Log.print("traderSetting, userIdx = "+userIdx, 0, "call");
		EgovMap in = new EgovMap();
		in.put("tidx", userIdx);
		EgovMap trader = (EgovMap)SocketHandler.sh.getSampleDAO().select("copyTraderFollowerInfo", in);
		if(trader == null){
			Log.print("Member isTrader, Trader Table 데이터불일치 (테이블에 없음) ", 0, "err");
			return;
		}
		int total = 0;
		if(trader.get("total") != null){
			total = Integer.parseInt(trader.get("total").toString());
		}
		
		ArrayList<EgovMap> traderCoinlist = (ArrayList<EgovMap>)SocketHandler.sh.getSampleDAO().list("selectTraderCoinlist", in);
		boolean [] isSymbols = getTraderUseCoins(traderCoinlist);
		double minRegist = 0;
		if(trader.get("minRegistWallet") != null){
			minRegist = Double.parseDouble(trader.get("minRegistWallet").toString());
		}
		traderInfo = new Trader(userIdx, total, isSymbols, minRegist);
	}
	public void traderRelease(){
		Copytrade.releaseFollower(userIdx);
		traderInfo = null;
		isTrader = false;
	}
	
	public void updateWallet(double newWallet){
		try {
			wallet = newWallet;
			JSONObject obj = new JSONObject();
			obj.put("protocol", "update wallet");
			obj.put("userIdx", userIdx);
			obj.put("newWallet", Double.parseDouble(String.format("%.8f",newWallet)));
			SocketHandler.sh.sendMessageToMeAllBrowser(obj);
		} catch (Exception e) {
			Log.print("member updateWallet err! "+e, 0, "test");
		}
	}
	
	public void updateBalance(int cnum, double newBalance){
		try {
			walletC[cnum] = Double.parseDouble(String.format("%.8f",newBalance));
			JSONObject obj = new JSONObject();
			obj.put("protocol", "update balance");
			obj.put("userIdx", userIdx);
			obj.put("newBalance", newBalance);
			obj.put("cnum", cnum);
			SocketHandler.sh.sendMessageToMeAllBrowser(obj);
			SocketHandler.sh.spotManager.sendMessageToMeAllBrowser(obj);
		} catch (Exception e) {
			Log.print("member updateWallet Balance err! "+e, 0, "test");
		}
	}

	public void liqAlert(Position pos, double profit, double liqPrice){
		try {			
			JSONObject obj = new JSONObject();
			obj.put("protocol", "liqAlert");
			obj.put("userIdx", userIdx);			
			obj.put("entryPrice", pos.entryPrice);			
			obj.put("liqPrice", liqPrice);
			obj.put("leverage", pos.leverage);
			obj.put("symbol", pos.symbol);
			obj.put("profit", profit);
			obj.put("margin", pos.fee);
			obj.put("marginType", pos.marginType);
			obj.put("position", pos.position);
			obj.put("openfee", pos.openFee);
			obj.put("liqfee", pos.liqFee);
			obj.put("position", pos.position);
			SocketHandler.sh.sendMessageToMeAllBrowser(obj);
		} catch (Exception e) {
			Log.print("member updateWallet liq err! "+e, 0, "test");
		}
	}
	
	public void changeParent(Member newParent)
	{
		parentsIdx = newParent.userIdx;
		parent = newParent;
	}
	
	public boolean lastLoginLogout(HttpSession session){
		if(session != lastLoginWebSession){
			webLogout(session);
			return true;
		}
		return false;
	}
	public void webLogout(HttpSession session){
		session.setAttribute("loginId", null);
		session.setAttribute("userIdx", null);
		session.setAttribute("userPhone", null);
		session.setAttribute("userLevel", null);
		session.setAttribute("userName", null);
		session.setAttribute("inflLogin", null);
		Locale locales = new Locale("en");
		session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locales);
		session.setAttribute("lang", "EN");
	}
	public void checkSetWarningUser(double profit){
		if(profit < 0) return;
		else if(isDanger) return;
		
		double autoWarningSet = Project.getAutoWarningUser();
		if(autoWarningSet != 0){
			
			double depoUSDT = getDepositUSDT();
			if(profit >= (depoUSDT * (0.01 * autoWarningSet))){
				Log.print("autoWarningSet 자동 주의회원 설정. 정산액 = "+profit+" / 입금총액 = "+depoUSDT+" , 수익이 입금총액의 "+autoWarningSet+"% 넘어감.", 1, "call");
				setDanger(100d, SocketHandler.sh.getSampleDAO());
			}
		}
	}
	public double getDepositUSDT(){
		if(!callDepositUSDT){
			EgovMap in = new EgovMap();
			in.put("userIdx", userIdx);
			int p2pMoney = (int)SocketHandler.sh.getSampleDAO().select("selectP2PDeposit",in);
			int krwMoney = (int)SocketHandler.sh.getSampleDAO().select("selectKrwDeposit",in);
			ArrayList<EgovMap> coinDeposit = (ArrayList<EgovMap>)SocketHandler.sh.getSampleDAO().list("selectCoinDeposit",in);
			try {
				double exRate = Double.parseDouble(SocketHandler.sh.exchangeRate);
				depositUSDT += (p2pMoney + krwMoney) / exRate;
				
				for(EgovMap coinDepo : coinDeposit){
					String coin = coinDepo.get("coin").toString();
					double depoUSDT = 0;
					if(coin.equals("USDT")){
						depoUSDT = Double.parseDouble(coinDepo.get("amountSum").toString());
					}else{
						Coin coinInfo = Coin.getCoinInfo(coin);
						double sise = coinInfo.getSise("long");
						depoUSDT = Double.parseDouble(coinDepo.get("amountSum").toString()) * sise;
					}
					depositUSDT += depoUSDT;
				}
				callDepositUSDT = true;

			} catch (Exception e) {
			}
		}
		return depositUSDT;
	}
	
	public static Member getGrandMember(Member mem){
		if(mem.getParent() != null){
			return getGrandMember(mem.getParent());
		}else{
			return mem;
		}
	}
	
	public static String getClientIP(HttpServletRequest request) {
	    String ip = request.getHeader("X-Forwarded-For");

	    if (ip == null) {
	        ip = request.getHeader("Proxy-Client-IP");
	    }
	    if (ip == null) {
	        ip = request.getHeader("WL-Proxy-Client-IP");
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_CLIENT_IP");
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	    }
	    if (ip == null) {
	        ip = request.getRemoteAddr();
	    }

	    return ip;
	}
	//futures 이용가능자산
	public double getWithdrawWallet(){
		return CointransService.getWithdrawWallet(this, "futures").doubleValue();
	}
	//futures balance
	public double getWallet(){
		return wallet;
	}
	public static double getWallet(String userIdx){
		return getWallet(Integer.parseInt(userIdx));
	}
	public static double getWallet(int userIdx){
		return getMemberByIdx(userIdx).getWallet();
	}
	public static double getWalletC(String userIdx, String symbol){
		return getWalletC(Integer.parseInt(userIdx),symbol);
	}
	
	//현물 BTCUSD, ETHUSD, ...., USDT
	public static double getWalletC(int userIdx, String symbol){
		return getMemberByIdx(userIdx).getWalletC(symbol);
	}
	public double getWalletC(String symbol){
		if(symbol.startsWith("USDT")){
			return zero(walletUSDT);
		}
		Coin coin = Coin.getCoinInfo(symbol);
		if(coin == null){
			Log.print("getWalletC symbol 대한 코인정보 없음. 에러 유저 = "+userIdx+"  symbol = "+symbol, 1, "err");
			return 0;
		}
		return zero(walletC[coin.coinNum]);
	}
	private double zero(double value){
		if(value < 0) return 0;
		return value;
	}
	public double getWithdrawWalletC(String symbol){
		return CointransService.getWithdrawWallet(this, symbol).doubleValue();
	}
	
	public static ArrayList<EgovMap> getMemberListMapToLevel(String level){
		ArrayList<EgovMap> list = new ArrayList<>();
		synchronized (SocketHandler.members) {
			for(Member m : SocketHandler.members){
				if(m.level.equals(level)){
					if(isBanded(String.valueOf(m.userIdx))) 
						continue;
					else if(m.jstat != 1) 
						continue;
					
					EgovMap map = new EgovMap();
					map.put("userIdx", m.userIdx);
					map.put("name", m.name);
					String pname = null;
					if(m.getParent() != null)
						pname = m.getParent().name;	
					map.put("pname", pname);
					map.put("inviteCode", m.inviteCode);
					list.add(map);
				}
			}
		}
		return list;
	}
	
	public static ArrayList<Member> getChongList(){
		ArrayList<Member> list = new ArrayList<>();
		synchronized (SocketHandler.members) {
			for(Member m : SocketHandler.members){
				if(isBanded(m.userIdx)) 
					continue;
				else if(m.jstat != 1) 
					continue;

				list.add(m);
			}
		}
		return list;
	}
	
	public static boolean isBanded(String userIdx){
		return isBanded(Integer.parseInt(userIdx));
    }
	public static boolean isBanded(int userIdx){
    	for(int i = 0; i < SocketHandler.userBanList.size(); i++){
    		if(userIdx == Integer.parseInt(SocketHandler.userBanList.get(i).get("useridx").toString())){
    			return true;
    		}
    		
    	}
    	return false;
    }
	
	public static Member getMemberByIdx(int userIdx){
		return getMemberByIdx(userIdx,false);
	}
	public static Member getMemberByIdx(int userIdx, boolean nullReturn){
    	Member returnMember = null;
    	
    	synchronized (SocketHandler.members) {
    		for (Iterator<Member> iter = SocketHandler.members.iterator(); iter.hasNext(); ) {
    			Member mem = iter.next();
				if (mem.userIdx == userIdx) {
					returnMember = mem;
				}
			}
    	}
		
		if (returnMember == null && !nullReturn) {
			Log.print("getMemberByIdx is null! userIdx : "+userIdx, 0, "evt" );
			returnMember = addMembers(String.valueOf(userIdx), null);
		}
		if (returnMember == null && !nullReturn) {
			Log.print("getMemberByIdx is null again! userIdx : "+userIdx, 0, "err" );
		}
		return returnMember;
	}
    
    public static Member getMemberByInviteCode(String inviteCode){
    	Member returnMember = null;
    	
    	synchronized (SocketHandler.members) {
    		for (Iterator<Member> iter = SocketHandler.members.iterator(); iter.hasNext(); ) {
    			Member mem = iter.next();
				if (mem.inviteCode.equals(inviteCode)) {
					returnMember = mem;
				}
			}
    	}
		
		if (returnMember == null) {
			returnMember = addMembersInviteCode(inviteCode);
		}
		return returnMember;
	}
    
    public static Member addMembers(String userIdx, EgovMap member) {
    	try {
    		if(member == null){
    			EgovMap in = new EgovMap();
    			in.put("userIdx", userIdx);
    			member = (EgovMap)SocketHandler.sh.getSampleDAO().select("selectMemberByIdx" ,in);
    		}
			if (member != null) {
				int parentsIdx = -1; if(member.get("parentsIdx") == null){ parentsIdx = -1; } else { parentsIdx = Integer.parseInt(member.get("parentsIdx").toString()); }
				
				Member newMember = new Member(member.get("idx").toString(),
												member.get("name").toString(),
												member.get("wallet").toString(),
												member.get("level").toString(),
												parentsIdx, Integer.parseInt(""+member.get("istest"))
												,Double.parseDouble(""+member.get("commissionRate")),
												Boolean.parseBoolean(""+member.get("istrader")),
												Double.parseDouble(""+member.get("dmoney")),
												""+member.get("inviteCode"),
												Integer.parseInt(""+member.get("jstat")),
												Double.parseDouble(""+member.get("accumwd")),
												""+member.get("kidx"),
												""+member.get("phone"),
												""+member.get("pw"),
												""+member.get("mbank"),
												""+member.get("maccount"),
												Boolean.parseBoolean(""+member.get("isKrCode")),
												Boolean.parseBoolean(""+member.get("vConfirm")),
												Integer.parseInt(""+member.get("mute")));
				
				synchronized(SocketHandler.members){
					SocketHandler.members.add(newMember);	
				}
				return newMember;
			} else {
				Log.print("addMembers member DB is null userIdx = "+userIdx, 0, "err");
				return null;
			}
		} catch (Exception e) {
			Log.print("addMembers err! "+e, 0, "err");
			return null;
		}
	}
    
    public static Member addMembersInviteCode(String inviteCode) {
    	try {
    		EgovMap in = new EgovMap();
	    	in.put("inviteCode", inviteCode);
			EgovMap member = (EgovMap)SocketHandler.sh.getSampleDAO().select("selectMemberByInviteCode" ,in);
			return addMembers(member.get("idx").toString(),member);
		} catch (Exception e) {
			Log.print("addMembers err! "+e, 0, "err");
			return null;
		}
	}
    
    public static boolean hasPositionOrder(int userIdx, String symbol){
    	if(symbol == null)
    		return false;
    	
    	for(Position po : SocketHandler.positionList){
    		if(po.userIdx == userIdx &&
    				po.symbol.equals(symbol)) return true;
    	}
    	for(Order o : SocketHandler.orderList){
    		if(o.userIdx == userIdx &&
    				o.symbol.equals(symbol)) return true;
    	}
    	return false;
    }
    public static boolean hasAnyPositionOrder(int userIdx){
    	
    	for(Position po : SocketHandler.positionList){
    		if(po.userIdx == userIdx) return true;
    	}
    	for(Order o : SocketHandler.orderList){
    		if(o.userIdx == userIdx) return true;
    	}
    	return false;
    }
    
    public static void allResetWd(){
    	long before = System.currentTimeMillis();
    	for(Member mem : SocketHandler.members){
    		mem.resetAccumWd();
    	}
    	long after = System.currentTimeMillis();
    	Log.print("allResetWd 처리완료 걸린시간 = "+(after - before)+" ms",1,"timecheck");
    }
}
