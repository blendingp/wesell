package egovframework.example.sample.classes;

import java.math.BigDecimal;
import java.util.ArrayList;

import org.springframework.context.MessageSource;

import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class Project {
    public static String projectName = "";
    private static ArrayList<Coin> fullCoins = new ArrayList<>();
    private static ArrayList<Coin> useCoins = new ArrayList<>();
    private static ArrayList<String> useCoinNames = null;
    private static EgovMap useCoinMap = null;
    public final String serverIp;  // 실서버
    public final boolean copytrade;
    public final boolean feeAccum;
    public final boolean feeReferral;
    public final boolean copyRequest;
    public final boolean inverse;
    public final boolean coinDeposit;
    public final boolean krwDeposit;
    public final boolean notloginmoney;
    public final boolean tUserFeeIsParent;
    public final boolean depositFee;
    public final boolean p2p;
    public final boolean kyc;
    public final boolean wdPhoneMsg;
    public final boolean letter;
    public final boolean p2pAutoCancel;
    public final boolean subAdminPower;
    public final boolean copyProfitShowSum;
    public final boolean adminIp;
    public final boolean krCode;
    public final boolean selferral;
    public final boolean tailUse;
    public final boolean usdtERC;
    public final boolean vAccount;
    public final boolean newSiseLoad;
    public final boolean spotTrade;
    public final boolean liqFee;
    public final double [] rate;
    public final double chongMaxRate;
    public final double limitWd;
    public final double autoWarningUser;
    public final int kycGift;
    public String [] defWalletAddress = {null,null,null};
    public ArrayList<EgovMap> wdPhoneList = null;

    MessageSource messageSource;
    
    
    public static int getKycGift(){
    	return SocketHandler.sh.setting.kycGift;
    }
    public static boolean isLiqFee(){
    	return SocketHandler.sh.setting.liqFee;
    }
    public static boolean isVAccount(){
    	return SocketHandler.sh.setting.vAccount;
    }
    public static boolean isUsdtERC(){
    	return SocketHandler.sh.setting.usdtERC;
    }
    public static boolean isSelferral(){
    	return SocketHandler.sh.setting.selferral;
    }
    public static double getAutoWarningUser(){
    	return SocketHandler.sh.setting.autoWarningUser;
    }
    
    public static ArrayList<Coin> getFullCoinList(){
    	return fullCoins;
    }
    public static ArrayList<Coin> getUseCoinList(){
    	return useCoins;
    }
    
    public static BigDecimal getFeeRate(Member member, String orderType){
    	try {
    		BigDecimal rate = null;
    		if (member.parentsIdx != -1 ||
    				(member.getIstest() && Project.isTuserFeeIsParent()) ) {
    			if (orderType.compareTo("market") == 0) {
    				rate = BigDecimal.valueOf(SocketHandler.sh.setting.rate[0]);
    			}else if (orderType.compareTo("limit") == 0) {
    				rate = BigDecimal.valueOf(SocketHandler.sh.setting.rate[2]);
    			}else{
    				Log.print("getFeeRate err! orderType = "+orderType, 0, "err");
    			}
			}else{
				if (orderType.compareTo("market") == 0) {
					rate = BigDecimal.valueOf(SocketHandler.sh.setting.rate[1]);
    			}else if (orderType.compareTo("limit") == 0) {
    				rate = BigDecimal.valueOf(SocketHandler.sh.setting.rate[3]);
    			}else{
    				Log.print("getFeeRate err! orderType = "+orderType, 0, "err");
    			}
			}
    		Log.print("getFeeRate("+member.userIdx+", "+orderType+") = "+rate, 0, "evt");
    		return rate;
		} catch (Exception e) {
			Log.print("getFeeRate err! "+e, 0, "err");
			return null;
		}
    }
    public static ArrayList<EgovMap> getWdPhoneList(){
    	return SocketHandler.sh.setting.wdPhoneList;
    }
    public static boolean isSpotTrade(){
    	return SocketHandler.sh.setting.newSiseLoad;
    }
    public static boolean isNewSiseLoad(){
    	return SocketHandler.sh.setting.newSiseLoad;
    }
    public static boolean isTailUse(){
    	return SocketHandler.sh.setting.tailUse;
    }
    public static boolean isKrCode(){
    	return SocketHandler.sh.setting.krCode;
    }
    public static boolean isAdminIp(){
    	return SocketHandler.sh.setting.adminIp;
    }
    public static boolean isCopyProfitShowSum(){
    	return SocketHandler.sh.setting.copyProfitShowSum;
    }
    public static boolean isSubAdminPower(){
    	return SocketHandler.sh.setting.subAdminPower;
    }
    public static boolean isLetter(){
    	return SocketHandler.sh.setting.letter;
	}
    public static boolean isP2PAutoCancel(){
    	return SocketHandler.sh.setting.p2pAutoCancel;
    }
    public static boolean isWdPhoneMsg(){
    	return SocketHandler.sh.setting.wdPhoneMsg;
    }
    public static boolean isKyc(){
    	return SocketHandler.sh.setting.kyc;
    }
    public static boolean isCopytrade(){
    	return SocketHandler.sh.setting.copytrade;
    }
    public static boolean isCopyRequest(){
    	return SocketHandler.sh.setting.copyRequest;
    }
    public static boolean isFeeReferral(){
    	return SocketHandler.sh.setting.feeReferral;
    }
    public static boolean isFeeAccum(){
    	return SocketHandler.sh.setting.feeAccum;
    }
    public static boolean isInverse(){
    	return SocketHandler.sh.setting.inverse;
    }
    public static boolean isCoinDeposit(){
    	return SocketHandler.sh.setting.coinDeposit;
    }
    public static boolean isKrwDeposit(){
    	return SocketHandler.sh.setting.krwDeposit;
    }
    public static boolean isNotloginmoney(){
    	return SocketHandler.sh.setting.notloginmoney;
    }
    public static boolean isTuserFeeIsParent(){
    	return SocketHandler.sh.setting.tUserFeeIsParent;
    }
    public static boolean isDepositFee(){
    	return SocketHandler.sh.setting.depositFee;
    }
    public static boolean isP2P(){
    	return SocketHandler.sh.setting.p2p;
    }
    public static double getChongMaxRate(){
    	return SocketHandler.sh.setting.chongMaxRate;
    }
    public static boolean isLimitWd(){
    	if(SocketHandler.sh.setting.limitWd == 0){
    		return false;
    	}
    	return true;
    }
    public static double getLimitWd(){
    	return SocketHandler.sh.setting.limitWd;
    }
    public static boolean checkLimitWd(double accumWd){
    	if(isLimitWd()){
    		if(accumWd >= SocketHandler.sh.setting.limitWd){
    			return false;
    		}
    	}
    	return true;
    }
    public static void putDefAddress(EgovMap in){
    	in.put("btcAddress",SocketHandler.sh.setting.defWalletAddress[0]);
    	in.put("ercAddress",SocketHandler.sh.setting.defWalletAddress[1]);
    	in.put("trxAddress",SocketHandler.sh.setting.defWalletAddress[2]);
    }
    
    public static EgovMap getUseCoinMap(){
    	if(useCoinMap == null){
    		useCoinMap = new EgovMap();
    		for(Coin coin : fullCoins){
				useCoinMap.put(coin.coinName, coin.isUse);
    		}
    	}
    	return useCoinMap;
    }
    
    public static ArrayList<String> getUseCoinNames(){
    	if(useCoinNames == null){
    		useCoinNames = new ArrayList<>();
    		for(Coin coin : useCoins){
    			useCoinNames.add(coin.coinName);
    		}
    	}
    	return useCoinNames;
    }
    
    public static ArrayList<EgovMap> getUseCoinInfoList(){
		ArrayList<EgovMap> clist = new ArrayList<>();
		for(Coin coin : useCoins){
			EgovMap c = new EgovMap();
			c.put("coinNum", coin.coinNum);
			c.put("coinName", coin.coinName);
			c.put("tailPrice", coin.tailPrice);
			c.put("tailRate", coin.tailRate);
			clist.add(c);
		}
    	return clist;
    }
    
    public static boolean isRealServer(){
    	String ip = Send.getServerIp();
    	if ( ip.equals(SocketHandler.sh.setting.serverIp) )
    		return true;
    	else
    		return false;
    }
    
	public Project(EgovMap setting, ArrayList<EgovMap> coinlist, MessageSource messageSource){
		Log.print("ProjectSetting 호출. setting = "+setting, 1, "call");
		if(setting == null){
			Log.print("ProjectSetting Load err!!", 1, "err");
		}
		
		feeAccum = Boolean.parseBoolean(setting.get("feeAccum").toString());
		feeReferral = Boolean.parseBoolean(setting.get("feeReferral").toString());
		copytrade = Boolean.parseBoolean(setting.get("copytrade").toString());
		copyRequest = Boolean.parseBoolean(setting.get("copyRequest").toString());
		inverse = Boolean.parseBoolean(setting.get("inverse").toString());
		coinDeposit = Boolean.parseBoolean(setting.get("coinDeposit").toString());
		krwDeposit = Boolean.parseBoolean(setting.get("krwDeposit").toString());
		notloginmoney = Boolean.parseBoolean(setting.get("notloginmoney").toString());
		tUserFeeIsParent = Boolean.parseBoolean(setting.get("tUserFeeIsParent").toString());
		depositFee = Boolean.parseBoolean(setting.get("depositFee").toString());
		p2p = Boolean.parseBoolean(setting.get("p2p").toString());
		chongMaxRate = Double.parseDouble(setting.get("chongMaxRate").toString());
		limitWd = Double.parseDouble(setting.get("limitwd").toString());
		kyc = Boolean.parseBoolean(setting.get("kyc").toString());
		wdPhoneMsg = Boolean.parseBoolean(setting.get("wdPhoneMsg").toString());
		letter = Boolean.parseBoolean(setting.get("letter").toString());
		p2pAutoCancel = Boolean.parseBoolean(setting.get("p2pAutoCancel").toString());
		subAdminPower = Boolean.parseBoolean(setting.get("subAdminPower").toString());
		copyProfitShowSum = Boolean.parseBoolean(setting.get("copyProfitShowSum").toString());
		adminIp = Boolean.parseBoolean(setting.get("adminIp").toString());
		krCode = Boolean.parseBoolean(setting.get("krCode").toString());
		selferral = Boolean.parseBoolean(setting.get("selferral").toString());
		tailUse = Boolean.parseBoolean(setting.get("tailUse").toString());
		usdtERC = Boolean.parseBoolean(setting.get("usdtERC").toString());
		vAccount = Boolean.parseBoolean(setting.get("vAccount").toString());
		newSiseLoad = Boolean.parseBoolean(setting.get("newSiseLoad").toString());
		spotTrade = Boolean.parseBoolean(setting.get("spotTrade").toString());
		liqFee = Boolean.parseBoolean(setting.get("liqFee").toString());
		autoWarningUser = Double.parseDouble(setting.get("autoWarningUser").toString());
		kycGift = Integer.parseInt(setting.get("kycGift").toString());
		serverIp = setting.get("realServerIp").toString();
		this.messageSource = messageSource;
		double [] tmpRate = {
					Double.parseDouble(setting.get("mprate").toString()),
					Double.parseDouble(setting.get("mrate").toString()),
					Double.parseDouble(setting.get("lprate").toString()),
					Double.parseDouble(setting.get("lrate").toString())};
		rate = tmpRate;
		
		for(EgovMap coin : coinlist){
			Coin addCoin = new Coin(
					Integer.parseInt(coin.get("coinNum").toString()),
					coin.get("coinName").toString(),
					Integer.parseInt(coin.get("qtyFixed").toString()),
					Integer.parseInt(coin.get("priceFixed").toString()),
					Integer.parseInt(coin.get("maxLeverage").toString()),
					Integer.parseInt(coin.get("maxVolumeType").toString()),
					Boolean.parseBoolean(coin.get("use").toString()),
					Integer.parseInt(coin.get("siseAlarmCnt").toString()),
					Integer.parseInt(coin.get("tailRate").toString()),
					Double.parseDouble(coin.get("tailPrice").toString())
					);
			fullCoins.add(addCoin);
			if(addCoin.isUse)
				useCoins.add(addCoin);
		}
		if(setting.get("defbtc") != null)
			defWalletAddress[0] = setting.get("defbtc").toString();
		if(setting.get("deferc") != null)
			defWalletAddress[1] = setting.get("deferc").toString();
		if(setting.get("deftrx") != null)
			defWalletAddress[2] = setting.get("deftrx").toString();
		
		if(wdPhoneMsg){
			wdPhoneList = (ArrayList<EgovMap>)SocketHandler.sh.getSampleDAO().list("selectWdPhone");
		}
	}
	
	public static String getProjectName(){
		return SocketHandler.sh.setting.getProject();
	}
	
	private String getProject(){
    	if(projectName.isEmpty())
    		projectName = Message.get().msg(messageSource, "root.project", "en");
    	return projectName;
    }
	
	public static EgovMap getPropertieMap(){
		EgovMap map = new EgovMap();
		map.put("name", SocketHandler.sh.setting.getProjectName());
		map.put("feeReferral", isFeeReferral());
		map.put("feeAccum", isFeeAccum());
		map.put("copytrade", isCopytrade());
		map.put("copyRequest", isCopyRequest());
		map.put("coinDeposit", isCoinDeposit());
		map.put("krwDeposit", isKrwDeposit());
		map.put("notloginmoney", isNotloginmoney());
		map.put("inverse", isInverse());
		map.put("depositFee", isDepositFee());
		map.put("p2p", isP2P());
		map.put("chongMaxRate", getChongMaxRate());
		map.put("kyc", isKyc());
		map.put("wdPhoneMsg", isWdPhoneMsg());
		map.put("letter", isLetter());
		map.put("subAdminPower", isSubAdminPower());
		map.put("adminIp", isAdminIp());
		map.put("krCode", isKrCode());
		map.put("tailUse", isTailUse());
		map.put("usdtERC", isUsdtERC());
		map.put("vAccount", isVAccount());
		map.put("spotTrade", isSpotTrade());
		return map;
	}
	
	public static String getP2PSiteName(){
		String name = getProjectName();
		switch(name){
		case "bitocean": return "Easy-exchange";
		default: return name;
		}
	}
}
