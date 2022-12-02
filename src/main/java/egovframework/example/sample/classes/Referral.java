package egovframework.example.sample.classes;

import java.math.BigDecimal;
import java.util.ArrayList;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class Referral {
	
	public static BigDecimal accumPileFee(Member user,double volume, String symbol, BigDecimal fee, String orderNum){
		if(!Project.isFeeReferral()) return BigDecimal.ZERO;
		fee = fee.multiply(BigDecimal.valueOf(-1));
		return accumPile(user,volume,symbol,fee, orderNum, false);
	}
	public static BigDecimal accumPile(Member user,double volume, String symbol, BigDecimal profit, String orderNum, boolean accum){
		if(accum && !Project.isFeeAccum()) return BigDecimal.ZERO;
		Coin coin = Coin.getCoinInfo(symbol);
		if(CointransService.isInverse(symbol))
			profit = CointransService.coinTransUsdt(profit, coin);
			
		if(!accum) 
			Log.print("accumPileFee - 유저 = "+user.userIdx+" symbol = "+symbol+" 총 분배 수수료 = "+profit, 1, "referells");
		else 
			Log.print("accumPileFee - 유저 = "+user.userIdx+" symbol = "+symbol+" 총 분배 정산액 = "+profit, 1, "referells");
		
		if(user.istest == 1)
			return BigDecimal.ZERO;

		profit = profit.multiply(BigDecimal.valueOf(-1));
		BigDecimal left = profit;
		
		if(profit.doubleValue() == 0)
			return BigDecimal.ZERO;
		
		ArrayList<Member> piles = Member.getParents(user);

		if(Project.isSelferral() && user.level.equals("chong")){//본인 총판
			piles.add(0, user);
		}
		
		if(piles.size() != 0){
			double childRate = 0;
			for(int i = 0; i < piles.size(); i++){
				double myRate = piles.get(i).myRate;
				if(i==piles.size()-1)
					Log.print("admin 레퍼럴 퍼센트 - "+(100 - myRate), 1, "referells");
				
				double rate = (myRate - childRate) * 0.01;
				left = plieProcess(piles.get(i).userIdx , rate, left, profit, orderNum);
				childRate = piles.get(i).myRate;
			}
		}
		return left; // 본사수익
	}
	
	public static BigDecimal plieProcess(int uidx, double rate, BigDecimal left, BigDecimal profit, String orderNum){
		if(Member.isBanded(uidx) == false){
			EgovMap in = new EgovMap();
			in.put("uidx", uidx );
			BigDecimal com = profit.multiply(BigDecimal.valueOf(rate));	
			left = left.subtract(com);
			Member user = Member.getMemberByIdx(uidx);
			user.accumPile(com);
			in.put("accum", user.accum);
			QueryWait.pushQuery("updatePileAccumRef",uidx, in, QueryType.UPDATE);
			
			in.put("orderNum", orderNum);
			in.put("gidx", uidx);
			in.put("allot", com);
			QueryWait.pushQuery("insertAccumRefLog",uidx, in, QueryType.INSERT);
			Log.print("plieProcess - 죽장 idx = "+uidx+" 분배 비율 = "+rate+" 총 분배금 = "+profit+" 본인 분배금 = "+com, 1, "referells");
		}
		return left;
	}
	
	public static boolean giveAccum(SampleDAO dao, HttpServletRequest request, int uidx){
		Member user = Member.getMemberByIdx(uidx);
		Double accum = user.getAccum();
		if(accum == null){
			return false;
		}
		if(accum <= 0)
			return false;
		
		AdminUtil.insertAdminLog(request, SocketHandler.sh.getSampleDAO(), AdminLog.REFERRAL, uidx, null, 1, accum, user.getWallet()+" -> "+(user.getWallet()+accum));
		Wallet.updateWallet(user, user.getWallet() + accum, accum, "futures", "+", "accumRef"); // 지갑 업데이트
		user.giveAccum();
		
		EgovMap in = new EgovMap();
		in.put("uidx", uidx);
		in.put("givedate", Send.getTime());
		dao.update("updateGiveAccumRef",in);
//		QueryWait.pushQuery("updateGiveAccumRef",uidx, in, QueryType.UPDATE);
		return true;
	}
	
	public static Member giveAccum_top(SampleDAO dao, HttpServletRequest request, int uidx){
		Member user = Member.getMemberByIdx(uidx);
		Double accum = user.getAccum();
		if(accum == null){
			return null;
		}
		if(accum <= 0)
			return null;
		
		Member topChong = Member.getGrandMember(user);
		
		AdminUtil.insertAdminLog(request, SocketHandler.sh.getSampleDAO(), AdminLog.REFERRAL, topChong.userIdx, null, 1, accum, topChong.getWallet()+" -> "+(topChong.getWallet()+accum));
		Wallet.updateWallet(topChong, topChong.getWallet() + accum, accum, "futures", "+", "accumRef"); // 지갑 업데이트
		user.giveAccum();
		
		EgovMap in = new EgovMap();
		in.put("uidx", uidx);
		in.put("givedate", Send.getTime());
		dao.update("updateEmptyAccumRef",in);
//		QueryWait.pushQuery("updateEmptyAccumRef",uidx, in, QueryType.UPDATE);
		return topChong;
	}
}
