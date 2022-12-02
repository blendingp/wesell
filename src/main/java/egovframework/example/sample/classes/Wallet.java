package egovframework.example.sample.classes;

import java.math.BigDecimal;

import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class Wallet {
	public static double walletValidation(Member member, double volume, Order order, String symbol){
    	try {
    		Log.print("call walletValidation", 1, "call");
    		double wallet = CointransService.getWithdrawWallet(member.userIdx, symbol).doubleValue();
    		if(order != null && order.orderMemory()) wallet += (order.paidVolume + order.openFee);
    		
    		Log.print("현재 사용가능금액 symbol = "+symbol+" wallet:"+wallet, 0, "checkMoney");
    		
    		if(wallet <  volume){
    			Log.print("잔액부족 wallet<volume ", 0, "checkMoney");
    			SocketHandler.sh.showPopup(member.userIdx, "notBalance", 2);
    			return -1;
    		}else{
    			Log.print("구매가능 wallet>=volume ", 0, "checkMoney");
    			return wallet;
    		}
		} catch (Exception e) {
			Log.print("walletValidation err! "+e, 1, "err");
			return -1;
		}
    }
	
	public static void updateWallet(Member member, double newWallet, double chansgeAmount, String symbol, String pm, String kind){
		EgovMap in = new EgovMap();
		in.put("userIdx", member.userIdx);
		in.put("useridx", member.userIdx);
		double coinbefore = 0;
		
		Coin coin = null;
		if(!symbol.equals("UToP") && !symbol.equals("PToU"))
			coin = Coin.getCoinInfo(symbol);
		
		boolean futures = true;
		try {
			//인버스 아닌 경우 ( 선물 )
			if(symbol.equals("futures") || !symbol.equals("USDT") && (!CointransService.isInverse(symbol) || symbol.equals("UToP") || symbol.equals("PToU"))){
				Log.print("call updateWallet "+chansgeAmount, 5, "call");
				coinbefore = member.getWallet(member.userIdx);
				if(pm.compareTo("+")==0 && chansgeAmount < 0){
					Log.print(member.userIdx+"회원 call updateWallet +일떄 마이너스금액들어옴  ca:"+chansgeAmount, 5, "err_notsend");
				}
				in.put("midx", member.userIdx);
				in.put("bfPoint", coinbefore);
				in.put("chansgeWallet", newWallet);
				QueryWait.pushQuery("updateWallet",member.userIdx, in, QueryType.UPDATE);
				member.updateWallet(newWallet);
			}else{
				//현물 
				coinbefore = member.getWalletC(symbol);
				in.put("balance",chansgeAmount);
				if(symbol.startsWith("USDT")) { //현물 usdt
					in.put("coinname", "USDT");
					QueryWait.pushQuery("coin_updateBalance",member.userIdx, in, QueryType.UPDATE, false);
					member.setUSDT(newWallet);
				} else {//현물 BTCUSD
					in.put("coinname",coin.coinName);
					QueryWait.pushQuery("coin_updateBalance",member.userIdx, in, QueryType.UPDATE, false);
					member.updateBalance(coin.coinNum, newWallet);
				}
				futures = false;
			}
		} catch (Exception e) {
			Log.print("updateWallet err! "+e, 1, "err");
		}
		
		if(futures){
			in.put("point", member.getWallet(member.userIdx)-coinbefore);
			in.put("afPoint", member.getWallet(member.userIdx));
			in.put("coinType", symbol);
			in.put("pm" , pm);
			in.put("kind" , kind);
			QueryWait.pushQuery("insertPointLog",member.userIdx, in, QueryType.INSERT);
		}else{
			in.put("desc", kind);
			if(symbol.startsWith("USDT")) {
				in.put("coinname", "USDT");
			} else {
				in.put("coinname", coin.coinName);
			}
			in.put("price", member.getWalletC(symbol) - coinbefore);
			in.put("before" , coinbefore);
			in.put("after" , member.getWalletC(symbol));
			QueryWait.pushQuery("coin_insertTranslog",member.userIdx, in, QueryType.INSERT);
		}
	}
	
	public static void updateWalletAmountAdd(Member member, double amount, String symbol, String kind){
		try {
			Log.print("call updateWalletAmountAdd "+amount, 5, "call");
			BigDecimal wallet;
			BigDecimal newWallet;
			
			if(CointransService.isInverse(symbol)){
				wallet = BigDecimal.valueOf(member.getWalletC(symbol));
				newWallet = wallet.add(BigDecimal.valueOf(amount));
			}else{
				wallet = BigDecimal.valueOf(member.wallet);
				newWallet = wallet.add(BigDecimal.valueOf(amount));
			}
			
			if(newWallet.doubleValue() < 0){
				Log.print("call updateWalletAmountAdd "+member.userIdx+"번 회원 잔액부족으로 인해서 잔액0원 처리 "+ amount, 5, "call");
				amount = wallet.doubleValue();
				amount = amount*-1;
				newWallet = wallet.add(BigDecimal.valueOf(amount));
			}
			String plus = "+";
			if(amount < 0){
				plus = "-";
			}
			
			updateWallet(member, newWallet.doubleValue(), amount, symbol, plus, kind);
		} catch (Exception e) {
			Log.print("updateWalletAmountAdd err! "+e, 1, "err");
		}
	}
	public static double updateWalletAmountSubtract(Member member, double openFee, String symbol, String kind){
		try {
			Log.print("call updateWalletAmountSubtract "+ openFee, 5, "call");
			BigDecimal wallet = BigDecimal.valueOf(member.wallet);
			if(CointransService.isInverse(symbol))
				wallet = BigDecimal.valueOf(member.getWalletC(symbol));
			
			BigDecimal newWallet = wallet.subtract(BigDecimal.valueOf(openFee));
			
			if(newWallet.doubleValue() < 0){
				Log.print("call updateWalletAmountSubtract "+member.userIdx+"번 회원 잔액부족으로 인해서 잔액0원 처리 "+ openFee, 5, "call");
				openFee = wallet.doubleValue();
				newWallet = wallet.subtract(BigDecimal.valueOf(openFee));
			}
			openFee = openFee*-1;
			updateWallet(member, newWallet.doubleValue(), openFee, symbol, "-", kind);
			return newWallet.doubleValue();
			
		} catch (Exception e) {
			Log.print("updateWalletAmountSubtract err! "+e, 1, "err");
		}
		return -1;
	}
}

