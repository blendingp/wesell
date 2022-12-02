package egovframework.example.sample.classes;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.Wallet;
import egovframework.example.sample.web.spot.SpotOrder;
import egovframework.example.sample.web.util.CryptoUtil;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;


/*
 * 로그남기고, 잔액 디비 값 수정하는 정도의 역할. 실제로 코인 API를 호출하고 연결하는 것은 코인 api 개발자와 상의해서 여기다 넣는게 좋을거 같긴한데. 2021 05 30
 * 테스트 웹컨트롤러 기능을 안쓰게 된다 해도 @Controller는 빼지 마라. 그게 있어야 서버 켜질때 자동 객체 생성되고  생성자가 호출 될테니.
*/
public class CointransService {
	public static SampleDAO getsd(){
		return SocketHandler.sh.getSampleDAO();
	}
	
	public static double getDepositFee(String coinname){
		EgovMap fee = (EgovMap)getsd().select("selectDepositFee",coinname);
		return Double.parseDouble(fee.get("fee").toString());
	}
	
	public static String sqlIsInverseValue(String inverse){
		if(inverse.equals("inverse")){
			return "D";
		}
		return "T";
	}
	
	public static BigDecimal coinTrans(BigDecimal usdt , String symbol){
		Coin coin = Coin.getCoinInfo(symbol);
		return coinTrans(usdt,coin);
	}
	
	public static BigDecimal coinTrans(BigDecimal usdt , Coin coin){
		double sise = coin.getSise("long");
		Log.print("coinTrans coin = "+coin.coinName+" / sise = "+sise, 1, "test");
		usdt = usdt.divide(BigDecimal.valueOf(sise),8,RoundingMode.HALF_DOWN);
		return usdt;
	}
	
	public static BigDecimal coinTransUsdt(BigDecimal spot , Coin coin){
		double sise = coin.getSise("long");
		Log.print("coinTrans coin = "+coin.coinName+" / sise = "+sise, 1, "test");
		spot = spot.multiply(BigDecimal.valueOf(sise));
		return spot;
	}
	
	public static boolean isInverse(String symbol){
		if(symbol.equals("futures"))
			return false;
		else if(symbol.startsWith("USDT")){
			return true;
		}
		else if(symbol.charAt(symbol.length()-1)=='T')
			return false;
		return true;
	}
	
	//유저에게 최초의 잔액 테이블 공간 할당
	public static void createBalance(String useridx , String coinname){
		EgovMap in=new EgovMap();
		in.put("useridx", useridx);
		in.put("coinname", coinname);
		getsd().insert("coin_isnertBalance",in);
	}
	
	//유저 코인 spot 잔액 가져오기
	public static double getBalanceCoin(String useridx,String coinname){
		EgovMap in=new EgovMap();
		in.put("useridx", useridx);
		in.put("coinname", coinname);
		EgovMap cb = (EgovMap)getsd().select("coin_getBalance",in);
		double balance = 0;
		if(cb == null){//비어 있으면 경고 로그 남기고 0원 발란스 코인 테이블 줄 추가.
			Log.print("코인 잔액 테이블이 비었습니다. 테이블 생성 useridx:"+useridx+" coinname:"+coinname, 1, "err_notsend");
			createBalance(useridx, coinname);
		}else{
			try{
				balance = Double.parseDouble(""+cb.get("balance"));
			}catch(Exception e){
				Log.print("getBalanceCoin try err "+e.getMessage(),1,"err")
			;}
		}
		return balance;
	}
	
	public static double getRealBalanceCoin(String useridx,String coinname){
		Log.print("4 getRealBalanceCoin balance useridx:"+useridx+" coinname:"+coinname, 1, "inmoney");
		EgovMap in=new EgovMap();
		in.put("useridx", useridx);
		in.put("coinname", coinname);
		EgovMap cb = (EgovMap)getsd().select("coin_getBalance",in);
		double balance = 0;
		if(cb == null){//비어 있으면 경고 로그 남기고 0원 발란스 코인 테이블 줄 추가.
			Log.print("error real 코인 잔액 테이블이 비었습니다. useridx:"+useridx+" coinname:"+coinname, 1, "err");
			createBalance(useridx, coinname);
		}else{
			try{
				balance = Double.parseDouble(""+cb.get("balancereal"));
				Log.print("5 balance:"+balance, 1, "inmoney");
			}catch(Exception e){Log.print("getBalanceCoin try err "+e.getMessage(),1,"err");}
		}
		return balance;
	}	
	////////////////////////////////////////////////////////////////////////////////////////
			
	//ok 유저 입금 : balancereal, balance 갱신 
	public static void depositProcess(String useridx,double price,String coinname){
		Log.print("1 depositProcess useridx:"+useridx+" price:"+price+" coinname:"+coinname , 1, "inmoney");
		if(price < 0) return;
		//price : 실제API지갑을 계속 체크하는 로직 (balancereal+수금액) 실제 지갑잔액 변동감지, 변동된금액
		
		EgovMap in=new EgovMap();
		//in.put("idx",idx);
		//int flag = (int)getsd().select("selectFlag",in);
		//if(flag == 1)	return;//이미처리됨
		
		//balance
		double before = Member.getWalletC(Integer.parseInt(useridx), coinname);
		Log.print("2 depositProcess balance before:"+before, 1, "inmoney");
		
		in.put("useridx", useridx);
		in.put("desc", "deposit");
		in.put("coinname",coinname );//usdt, btc
		in.put("before",before);
		in.put("after",before+price);
		in.put("price",price);
		in.put("balance",price);
		
		//balance
//		getsd().insert("coin_insertTranslog",in);
//		getsd().update("coin_updateBalance",in);
		int userIdx = Integer.parseInt(useridx);
		QueryWait.pushQuery("coin_insertTranslog",userIdx, in, QueryType.INSERT);
		QueryWait.pushQuery("coin_updateBalance",userIdx, in, QueryType.UPDATE, false);
		
		Log.print("3 depositProcess 입금처리 중 uidx: "+useridx, 1, "inmoney");
		//balancereal
		before = Double.parseDouble(""+ getRealBalanceCoin(useridx,coinname) );	
		Log.print("6 depositProcess realbalance before:"+before, 1, "inmoney");
		in.put("before",before);
		in.put("after",before+price);
//		getsd().insert("coin_insertRealTranslog",in);
//		getsd().update("coin_updateBalanceReal",in);
//		QueryWait.pushQuery("coin_insertRealTranslog", in, QueryType.INSERT);
//		QueryWait.pushQuery("coin_updateBalanceReal", in, QueryType.UPDATE);
		
		Log.print("depositProcess 7 입금처리 사후금액"+(before+price), 1, "inmoney");
		//transaction 업데이트		
		//getsd().update("coin_updateFlag",in);
	}
	
	//유저 출금 :출금신청할때  UserController /withdrawEmail.do
	public static String withdrawRequestProcess(String useridx,double price,String coinname, double fee){
		if(!coinname.equals("USDT"))
			coinname += "USD";
		String result = "ok";
		//수수료 디비에서 조회
		Member member = Member.getMemberByIdx(Integer.parseInt(useridx));
		
		double before = 0;
		before = member.getWithdrawWalletC(coinname);
		
		double priceResult = (fee+price)*(-1);
		if( Math.abs( fee + price - before ) < 0.000001 ){
			priceResult = before*(-1);
		}else if( before < fee+price ){
			result = "fail";
			Log.print("잔액보다 많은 금액 요청함. 에러  balance :"+before+" 필요한 비용:"+(fee+price), 2, "err");
			return result;
		}
		double sise = 0;
		if(coinname.equals("USDT"))
			sise = 1;
		else
			sise = Coin.getCoinInfo(coinname).getSise("long");

		double accumWdUsdt = price * sise;
		if(!Project.checkLimitWd(accumWdUsdt + member.accumWd)){
			result = "wdfail";
			Log.print("유저 일일 출금한도 도달. 누적액 :"+member.accumWd+" 출금액:"+accumWdUsdt, 2, "withdraw");
			return result;
		}
		
		member.updateAccumWd(accumWdUsdt);
		////////////유저의 balance 갱신//////////
		//유저의 balance갱신  -price
		
	    Wallet.updateWallet(member, before+priceResult, priceResult, coinname, "-", "withdraw");
		return result;
	}	
	
	//관리자 출금 미승인 시 or 유저 출금 취소시:UserController ?
	public static String withdrawDenyProcess(String widx){
		//widx로 디비 조회해서 값 저장 
		EgovMap withdraw = (EgovMap)getsd().select("selectWithdraw",widx);
		String useridx = withdraw.get("wuseridx").toString();
		String coinname = withdraw.get("wcoinname").toString(); 
		double price = Double.parseDouble(withdraw.get("wamount").toString());
		double fee = Double.parseDouble(withdraw.get("wfee").toString());
		String result = "ok";
		//수수료 디비에서 조회
		double before = Member.getMemberByIdx(Integer.parseInt(useridx)).getWalletC(coinname);
		double priceResult = (fee+price);
		Member member = Member.getMemberByIdx(Integer.parseInt(useridx));
		
		if(Send.isEqualDay(withdraw.get("wdate").toString())){
			double resetUSDT = 0;
			if(coinname.equals("USDT")){
				resetUSDT = -price;
			}
			else{
				double sise = Coin.getCoinInfo(coinname).getSise("long");
				resetUSDT = -(sise * price);
			}
			member.updateAccumWd(resetUSDT);
		}
		////////////유저의 balance 갱신//////////
		//유저의 balance갱신  -price
		if(!coinname.equals("USDT"))
			coinname += "USD";
	    Wallet.updateWallet(member, before+priceResult, priceResult, coinname, "+", "withdrawDeny");
		return result;
	}	
	
	//관리자 출금 미승인 시 or 유저 출금 취소시:UserController ?
	public static String kWithdrawDenyProcessP2P(String widx){
		//widx로 디비 조회해서 값 저장 
		EgovMap withdraw = (EgovMap)getsd().select("checkMoneyIdxP2P",widx);
		String useridx = withdraw.get("useridx").toString();
		double price = Double.parseDouble(withdraw.get("money").toString());
		//double fee = Double.parseDouble(withdraw.get("wfee").toString());
		String result = "ok";
		EgovMap in=new EgovMap();
		Member member = Member.getMemberByIdx(Integer.parseInt(useridx));
		double before = member.getWallet();
		in.put("userIdx", useridx);
		double exchangeValue = Double.parseDouble(""+withdraw.get("exchangeValue"));
		in.put("kind", "+");
		in.put("lkind", "withdrawDeny");	
		in.put("userPoint", before);
		
		////////////유저의 balance 갱신//////////
		in.put("exchangeValue", exchangeValue);
		in.put("idx", widx);
		in.put("stat", 2);
		//유저의 balance갱신  -price
		getsd().update("updateMoneyP2P",in);
		
		if(Boolean.parseBoolean(withdraw.get("send").toString())){
			Wallet.updateWallet(member, before+exchangeValue, exchangeValue, "futures", "+", "withdrawDeny");
		}
		return result;
	}	
	
	public static String kWithdrawDenyProcess(String widx){
		//widx로 디비 조회해서 값 저장 
		EgovMap withdraw = (EgovMap)getsd().select("checkMoneyIdx",widx);
		String useridx = withdraw.get("useridx").toString();
		double price = Double.parseDouble(withdraw.get("money").toString());
		//double fee = Double.parseDouble(withdraw.get("wfee").toString());
		String result = "ok";
		EgovMap in=new EgovMap();
		double before = Member.getMemberByIdx(Integer.parseInt(useridx)).getWallet();
		in.put("userIdx", useridx);
		double exchangeValue = Double.parseDouble(""+withdraw.get("exchangeValue"));
		in.put("kind", "+");
		in.put("lkind", "withdrawDeny");	
		in.put("userPoint", before);
		
		////////////유저의 balance 갱신//////////
		in.put("exchangeValue", exchangeValue);
		in.put("idx", widx);
		in.put("stat", 2);
		//유저의 balance갱신  -price
		getsd().update("updateMoney",in);
		Member member = Member.getMemberByIdx(Integer.parseInt(useridx));
	    Wallet.updateWallet(member, before+exchangeValue, exchangeValue, "futures", "+", "withdrawDeny");
		return result;
	}	

	//관리자 출금 승인 시 : AdminTradeController /withdrawalProcess.do
	public static String withdrawProcess(String useridx,double price,String coinname, String widx, String tx){
		String result = "ok";		

		if(price > 0){
			price = (price)*-1;
		}else{
			result = "fail";
			return result;
		}
		int uidx = Integer.parseInt(useridx);
		int pidx = Member.getMemberByIdx(uidx).parentsIdx;
		if(pidx == -1) {
			pidx = 1;
		}
		
		//API 호출시 관리자의 balancereal 이 변동된다.
		EgovMap in=new EgovMap();				
		in.put("useridx", 1);//관리자는 -1로 기록
		in.put("price", (price));		
		in.put("desc","withdraw" );
		in.put("coinname",coinname );
		
		//before = mymoney; 
		//after = mymoney+price;
		
		in.put("before",null);
		in.put("after",null);
//		getsd().insert("coin_insertRealTranslog",in);
		
		in.put("balance", price);
		getsd().update("coin_updateAdminRealBalance",in);//유저의 총 누적 수금 금액 기록 outmoney
		in.put("widx", widx);
		EgovMap wd = (EgovMap) getsd().select("selectWithdraw", in);
		in.put("dtag", ""+wd.get("xrptag"));
		in.put("coin", coinname);
		in.put("tx", tx);
		in.put("to", useridx);
		in.put("from", pidx);
		in.put("userIdx", useridx);
		in.put("label", "-");
		in.put("status", "1");
		in.put("fee", ""+wd.get("wfee"));
		in.put("amount", ""+wd.get("wamount"));
		getsd().insert("insertTransaction",in);
		
		return result;
	}	
	
	//관리자 출금 승인 시 : AdminTradeController /withdrawalProcess.do
	public static String kWithdrawProcess(String useridx,double price, String stat, String widx){
		String result = "ok";
		//관리자 돈 ----송금API----> 유저지갑 해야될꺼같은데?
/*		if( realMoneyWithdraw( widx ) == 0 ){
			result = "fail";
			return result;
		}*/
		EgovMap in=new EgovMap();
		in.put("widx", widx);
		EgovMap ed = (EgovMap) getsd().select("checkMoneyIdx", in);
		String kind = ""+ed.get("kind");
		if (price < 0) {
			result = "fail";
			return result;
		}
		
/*		if(price > 0 && stat == "-"){
			price = (price)*-1;
		} else if (price > 0 && stat == "+") {
			price = price;
		} else{
			result = "fail";
			return result;
		}*/
		double before = Member.getMemberByIdx(Integer.parseInt(useridx)).getWallet();
			
		in.put("userIdx", useridx);
		
		String desc = "";
		String exchangeValue = "";
		String exchangeRate = "";
		Double eRate = Double.parseDouble(SocketHandler.exchangeRate);
		Double eVal = Math.round(price/eRate*100)/100.0;
		if(kind.equals("+")) {
			desc = "deposit";
			exchangeRate = SocketHandler.exchangeRate;
			exchangeValue = ""+eVal;
		} else if(kind.equals("-")) {
			desc = "withdraw";
			exchangeValue = ""+ed.get("exchangeValue");
			exchangeRate = ""+ed.get("exchangeRate");
		}
		in.put("kind", kind );
		in.put("lkind", desc );
		in.put("userPoint", before);
		in.put("exchangeValue", exchangeValue);
		in.put("exchangeRate", exchangeRate);
		//before = mymoney; 
		//after = mymoney+price;
		
		in.put("stat", stat);
		in.put("idx", widx);
		getsd().update("updateMoney",in);
		if(kind.equals("+")) {
			Member member = Member.getMemberByIdx(Integer.parseInt(useridx));
		    Wallet.updateWallet(member, before+eVal, eVal, "futures", "+", "deposit");
		}
		//in.put("balance", price);
		getsd().update("coin_updateAdminRealBalance",in);//유저의 총 누적 수금 금액 기록 outmoney 
		return result;
	}	
	
	public static String kWithdrawProcessP2P(int useridx,double price, String stat, String widx, double rate, double usdtValue){
		String result = "ok";
		EgovMap in=new EgovMap();
		in.put("widx", widx);
		EgovMap ed = (EgovMap) getsd().select("checkMoneyIdxP2P", in);
		String kind = ""+ed.get("kind");
		if (price < 0) {
			result = "fail";
			return result;
		}
		Member mem = Member.getMemberByIdx(useridx);
		double before = mem.getWallet();
			
		in.put("userIdx", useridx);
		
		String desc = "";
		if(kind.equals("+")) {
			desc = "deposit";
		} else if(kind.equals("-")) {
			desc = "withdraw";
		}
		in.put("kind", kind );
		in.put("lkind", desc );
		in.put("userPoint", before);
		in.put("exchangeValue", usdtValue);
		in.put("exchangeRate", rate);
		in.put("stat", stat);
		in.put("idx", widx);
		getsd().update("updateMoneyP2P",in);
		if(kind.equals("+")) {
		    Wallet.updateWallet(mem, before+usdtValue, usdtValue, "futures", "+", "deposit");
		    mem.depositUSDT = mem.getDepositUSDT() + usdtValue;
		}
		return result;
	}
		
	public static String depositProcess(String useridx,double price,String coinname, String widx, double fee){
		String result = "ok";		
		if(price < 0 || fee > price){
			result = "fail";
			return result;
		}
		Member member = Member.getMemberByIdx(Integer.parseInt(useridx));
		double before = member.getWalletC(coinname);
		
		double depoUSDT = 0;
		if(coinname.equals("USDT")){
			depoUSDT = price;
		}else{
			Coin coinInfo = Coin.getCoinInfo(coinname);
			double sise = coinInfo.getSise("long");
			depoUSDT = price * sise;
		}
		member.depositUSDT = member.getDepositUSDT() + depoUSDT;
		
		if(!coinname.equals("USDT"))
			coinname += "USD";
	    Wallet.updateWallet(member, before+price-fee, price-fee, coinname, "+", "deposit");
	    
		
		return result;
	}	

//-----------------------------exchange-----------------------------------------------//
	//SPOT Exchange 유저지갑  BTC에서 USDT spot로  가상 전송
public static String exchangeCoinToUSDT(String useridx,double amount,String coin){
		
		Coin coinInfo = Coin.getCoinInfo(coin);
		double siseb = coinInfo.getSise("long");
		
		if(siseb == -1){
			return "fail";
		}
		
		Log.print("지갑 유저번호:"+useridx+" Exchange "+coin+" -> USDT", 2, "wallet");
		if(amount < 0) {
			Log.print("요청수량 음수로 요청 : "+amount, 2, "wallet");
			return "fail";
		}
		
		Member member = Member.getMemberByIdx(Integer.parseInt(useridx));
		double mybalance = member.getWalletC(coin); 
		double withdraw = getWithdrawWallet(Integer.parseInt(useridx),coin+"USD").doubleValue();
		
		Log.print("요청수량:"+amount+" 사용가능 잔고 "+coin+":"+ withdraw +"   "+coin, 2, "test");
		
		//amount는 BTC 의미함
		if( amount > withdraw){
			Log.print("요청수량:"+amount+" 사용가능"+coin+":"+ withdraw +"   "+coin+" 잔액보다 많은 금액 요청함. 에러 ", 2, "wallet");
			return "fail";
		}
		///////////////BTC처리////////////////
		double before = mybalance;
		double after = mybalance-amount;
		
		EgovMap in=new EgovMap();
		in.put("useridx", useridx);
		in.put("price","-"+amount );		
		in.put("desc",coin+"ToU" );
		in.put("coinname",coin );
		in.put("before", before);
		in.put("after", after);
//		getsd().insert("coin_insertTranslog",in);

		in.put("balance","-"+amount );
//		getsd().update("coin_addBalance",in);
		int userIdx = Integer.parseInt(useridx);
		QueryWait.pushQuery("coin_insertTranslog", userIdx, in, QueryType.INSERT);
		QueryWait.pushQuery("coin_addBalance", userIdx, in, QueryType.UPDATE, false);

		///////////////USDT처리////////////////
		double myusdt = member.getWalletC("USDT");
		
		Log.print("보유 usdt : "+myusdt+" 시세 :"+siseb+" "+coin+"->usdt로 치환해서 usdt수량계산 : 시세*수량="+siseb+"*"+amount+"=" , 2, "wallet");
		amount = Math.floor(amount*siseb*100000)/100000;//btc->usdt로 치환? 
		Log.print("요청수량 "+coin+"->usdt : "+amount , 2, "wallet");
		double beforeU = myusdt;
		double afterU = myusdt+amount;
		
		in.put("price","+"+amount );	
		in.put("desc",coin+"ToU" );
		in.put("coinname","USDT" );
		in.put("before", beforeU);
		in.put("after", afterU);
//		getsd().insert("coin_insertTranslog",in);	
				
		in.put("balance",""+amount );
//		getsd().update("coin_addBalance",in);	
		
		QueryWait.pushQuery("coin_insertTranslog",userIdx, in, QueryType.INSERT);
		QueryWait.pushQuery("coin_addBalance",userIdx, in, QueryType.UPDATE, false);
		member.setUSDT(afterU);
		member.updateBalance(coinInfo.coinNum, after);
		Position.updateLiquidationPriceByUser(Integer.parseInt(useridx),coin+"USD");
		return "suc";
	}
	
	//SPOT Exchange 유저지갑  USDT spot에서 BTC로  가상 전송
	public  static String exchangeUSDTToCoin(String useridx,double amount,String coin){
		
		Coin coinInfo = Coin.getCoinInfo(coin);
		int cnum = coinInfo.coinNum;
		double siseb = coinInfo.getSise("long");
		
		if(siseb == -1){
			return "fail";
		}
		
		Log.print("지갑 유저번호:"+useridx+" Exchange USDT -> "+coin+"", 2, "wallet");
		if(amount < 0) {
			Log.print("요청수량 음수로 요청 : "+amount, 2, "wallet");
			return "fail";
		}
		Member member = Member.getMemberByIdx(Integer.parseInt(useridx));
		double myusdt = member.getWithdrawWalletC("USDT"); 
		if( amount > myusdt){
			Log.print("요청수량:"+amount+" 보유usdt:"+ myusdt +"   usdt 잔액보다 많은 금액 요청함. 에러 ", 2, "wallet");			
			return "fail";
		}
		//amount는 USDT를 의미함
		//////////////////usdt 차감///////////////// 
		double before = myusdt;
		double after = myusdt-amount;
		EgovMap in=new EgovMap();
		in.put("useridx", useridx);
		in.put("price","-"+amount );		
		in.put("desc","UTo"+coin );
		in.put("coinname","USDT" );
		in.put("before",before );
		in.put("after",after );
//		getsd().insert("coin_insertTranslog",in);

		in.put("balance","-"+amount );
//		getsd().update("coin_addBalance",in);
		
		int userIdx = Integer.parseInt(useridx);
		QueryWait.pushQuery("coin_insertTranslog",userIdx, in, QueryType.INSERT);
		QueryWait.pushQuery("coin_addBalance",userIdx, in, QueryType.UPDATE, false);
		member.setUSDT(after);
		
		//////////////////BTC 증감/////////////////
		double mybalance = member.getWalletC(coin);
		Log.print("요청수량  usdt: "+amount+" 시세 :"+siseb+" usdt->"+coin+" 로 치환해서  btc수량계산 : 수량/시세="+amount+"/"+siseb+"=" , 2, "wallet");					 
		amount = Math.floor(amount/siseb*100000)/100000; //usdt -> BTC
		Log.print("요청수량 usdt->"+coin+" : "+amount , 2, "wallet");
		double beforebtc = mybalance;
		double afterbtc = mybalance+amount;		
		in.put("useridx", useridx);
		in.put("price", amount );		
		in.put("desc","UTo"+coin );
		in.put("coinname",coin );
		in.put("before",beforebtc );
		in.put("after",afterbtc );
//		getsd().insert("coin_insertTranslog",in);

		in.put("balance",""+amount );
//		getsd().update("coin_addBalance",in);
		
		QueryWait.pushQuery("coin_insertTranslog",userIdx, in, QueryType.INSERT);
		QueryWait.pushQuery("coin_addBalance",userIdx, in, QueryType.UPDATE, false);
		member.updateBalance(coinInfo.coinNum, afterbtc);
		Position.updateLiquidationPriceByUser(Integer.parseInt(useridx),coin+"USD");
		return "suc";
	}
	
	
	//-----------------------------trans-----------------------------------------------//
	//Transfer 유저 usdt 지갑에서 Point 지갑으로 코인 이동처리(가상)	
	public static String transUsdtToPoint(String useridx,double price, boolean max){
		Log.print("지갑 유저번호:"+useridx+" Transfer USDT -> Point", 2, "wallet");
		if(price < 0) {
			Log.print("요청수량 음수로 요청 : "+price, 2, "wallet");
			return "fail";
		}
		Member member = Member.getMemberByIdx(Integer.parseInt(useridx));	
		double myusdt = member.getWithdrawWalletC("USDT");
		if( price > myusdt){
			Log.print("요청수량:"+price+" 보유usdt:"+ myusdt +"   usdt 잔액보다 많은 금액 요청함. 에러 ", 2, "wallet");
			return "fail";
		}
		if(max)
			price = myusdt;

		//////////////////usdt 차감/////////////////
		//API호출 

		double before = myusdt;
		double after = myusdt-price;
		Log.print("usdt 차감  before:"+before  +" 변동금액: "+price+" after: "+after, 2, "wallet");
		EgovMap in=new EgovMap();
		in.put("useridx", useridx);
		in.put("price","-"+price );		
		in.put("desc","UToP" );
		in.put("coinname","USDT" );
		in.put("before",before );
		in.put("after",after );
//		getsd().insert("coin_insertTranslog",in);
		
		//코인 바란스 감소 및 증가
		in.put("balance","-"+price );
//		getsd().update("coin_addBalance",in);
		int userIdx = Integer.parseInt(useridx);
		QueryWait.pushQuery("coin_insertTranslog", userIdx, in, QueryType.INSERT);
		QueryWait.pushQuery("coin_addBalance", userIdx, in, QueryType.UPDATE, false);
		member.setUSDT(after);

		//////////////////Point 증감/////////////////
		in.put("userIdx", useridx);
		double beforewallet = member.getWallet();
		double afterwallet = beforewallet + price;
		Log.print("point 증감  beforewallet:"+beforewallet  +" 변동금액: "+price+" afterwallet: "+afterwallet, 2, "wallet");
		
		in.put("useridx", useridx);
		in.put("price", price);		
		in.put("desc","UToP" );
		in.put("coinname","point" );
		in.put("before",beforewallet );
		in.put("after",afterwallet );
//		getsd().insert("coin_insertTranslog",in);
		QueryWait.pushQuery("coin_insertTranslog", userIdx, in, QueryType.INSERT);
		Wallet.updateWallet(member, afterwallet, price, "UToP", "+", "exchange");
		Position.updateLiquidationPriceByUser(Integer.parseInt(useridx), "UToP");
		return "suc";
	}
	
	// 유저 future 지갑에서 spot 지갑으로 코인 이동처리(가상)
	public static String transPointToUsdt(String useridx,double price, boolean max){
		Log.print("지갑 유저번호:"+useridx+" Transfer Point -> USDT ", 2, "wallet");
		if(price < 0) {
			Log.print("요청수량 음수로 요청 : "+price, 2, "wallet");
			return "fail";
		}
		int uidx = Integer.parseInt(useridx);
		Member member = Member.getMemberByIdx(Integer.parseInt(useridx));	
		if(max) {price = CointransService.getWithdrawWallet(uidx, "futures").doubleValue();}
		///////////////포인트 처리/////////////
		//double marginsum = SocketHandler.sh.getFuturesMainMarginSum(Integer.parseInt(useridx));
		double withdrawWallet = CointransService.getWithdrawWallet(Integer.parseInt(useridx), "futures").doubleValue();
		EgovMap in=new EgovMap();
		in.put("useridx", useridx);
		in.put("userIdx", useridx);
		
		BigDecimal beforewallet = BigDecimal.valueOf(member.getWallet());
		BigDecimal afterwallet = beforewallet.subtract(BigDecimal.valueOf(price)).setScale(8,RoundingMode.HALF_DOWN);
		Log.print("사용가능 : " + withdrawWallet + "증감값" + price, 2, "wallet");
		if( price > withdrawWallet){
			Log.print("포인트 잔액보다 많은 금액 요청함. 에러 ", 2, "wallet");
			return "fail";
		}
		
		int userIdx = Integer.parseInt(useridx);
		Wallet.updateWallet(member, afterwallet.doubleValue(), (price*-1), "PToU", "-", "exchange");
		Position.updateLiquidationPriceByUser(Integer.parseInt(useridx), "USDT");
		in.put("useridx", useridx);
		in.put("price","-"+price );		
		in.put("desc","PToU" );
		in.put("coinname","point" );
		in.put("before",beforewallet);
		in.put("after",afterwallet);
//		getsd().insert("coin_insertTranslog",in);
		QueryWait.pushQuery("coin_insertTranslog",userIdx, in, QueryType.INSERT);
		
		///////////////usdt 처리/////////////		
		double myusdt = member.getWalletC("USDT");
		in.put("useridx", useridx);
		in.put("price",""+price );		
		in.put("desc","PToU" );
		in.put("coinname","USDT" );
		in.put("before",myusdt);
		in.put("after",myusdt+price);
//		getsd().insert("coin_insertTranslog",in);
		in.put("balance",""+price );
		Log.print("point 증감  beforewallet:"+myusdt  +" 변동금액: "+price+" afterwallet: "+(myusdt+price), 2, "wallet");
//		getsd().update("coin_addBalance",in);
		QueryWait.pushQuery("coin_insertTranslog",userIdx, in, QueryType.INSERT);
		QueryWait.pushQuery("coin_addBalance",userIdx, in, QueryType.UPDATE, false);
		member.setUSDT(myusdt+price);
		return "suc";
	}
	
	public static BigDecimal getWithdrawWallet(Member user , String symbol){
		BigDecimal wallet = BigDecimal.ZERO;
		if(symbol.equals("USDT") || isInverse(symbol)){
			wallet = BigDecimal.valueOf(user.getWalletC(symbol));
		}else{
			wallet = BigDecimal.valueOf(user.getWallet());
		}

		for (Iterator<Position> iter = SocketHandler.positionList.iterator(); iter.hasNext(); ) {
			Position position = iter.next();
			
			if (position.userIdx == user.userIdx) {
				if(isInverse(symbol)){ // 구할 코인이 현물일때
					if(position.symbol.equals(symbol)){
						wallet = wallet.subtract(BigDecimal.valueOf(position.fee));
						wallet = overLossMarginMinus(wallet,position);
					}
				}else{ // 구할 코인이 선물일때
					if(!isInverse(position.symbol)){
						wallet = wallet.subtract(BigDecimal.valueOf(position.fee));
						wallet = overLossMarginMinus(wallet,position);
					}
				}
			}
		}
		for (Iterator<Order> iter = SocketHandler.orderList.iterator(); iter.hasNext(); ) {
			Order order = iter.next();
			if (order.userIdx == user.userIdx) {
				if(isInverse(symbol)){
					if(order.symbol.equals(symbol)){
						if(order.getIsLiq() == 1)
							continue;
						
						wallet = wallet.subtract(BigDecimal.valueOf(order.paidVolume));
						wallet = wallet.subtract(BigDecimal.valueOf(order.openFee));
					}
				}else{
					//청산 주문인지 체크
					//포지션이 선물인지 체크
					if(!isInverse(order.symbol) && order.getIsLiq() == 0){
						wallet = wallet.subtract(BigDecimal.valueOf(order.paidVolume));
						wallet = wallet.subtract(BigDecimal.valueOf(order.openFee));
					}
				}
			}
		} 
		
		if(isInverse(symbol))
		{
			for (Iterator<SpotOrder> iter = SocketHandler.spotOrderList.iterator(); iter.hasNext(); ) {
				SpotOrder order = iter.next();
				if (order.userIdx == user.userIdx) {
					//현물 USDT 
					if(symbol.equals("USDT")){
						if(order.position.equals("long")){
							wallet = wallet.subtract(BigDecimal.valueOf(order.paidVolume));						
						}
					}
					//현물 BTCUSD
					else if(isInverse(symbol) &&  order.symbol.equals(symbol) && order.position.equals("short")){
						wallet = wallet.subtract(BigDecimal.valueOf(order.buyQuantity));
					}
				}
			} 
		}
		return wallet;
	}
	
	public static BigDecimal getWithdrawWallet(int userIdx , String symbol){
		Member user = Member.getMemberByIdx(userIdx);
		return getWithdrawWallet(user,symbol);
	}
	
	private static BigDecimal overLossMarginMinus(BigDecimal wallet, Position position){
		if(position.marginType.equals("cross")){
			BigDecimal profit = position.getProfit();
			if(profit.doubleValue() < 0 && //손실이고
					Math.abs(profit.doubleValue()) > position.fee){ //증거금보다 크다면
				profit = profit.add(BigDecimal.valueOf(position.fee));
				wallet = wallet.add(profit);
			}
		}
		return wallet;
	}
}
