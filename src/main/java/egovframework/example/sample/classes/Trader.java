package egovframework.example.sample.classes;
import java.util.ArrayList;
import java.util.LinkedList;

import org.apache.ibatis.javassist.bytecode.analysis.Util;

import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class Trader {
	private int tidx;
	public int maxFollower = 0;
	private ArrayList<Member> followers = new ArrayList<>();
	private double minRegistWallet = 0;
	boolean [] copySymbols = null;
	
	public Trader(int _tidx, int _maxFollower, boolean [] _isBuySymbols, Double minRegistWallet) 
	{
		tidx = _tidx;
		setInfo(_maxFollower, minRegistWallet);
		setMyFollowers();
		copySymbols = _isBuySymbols;
	}
	
	public double getMinRegistWallet(){
		return minRegistWallet;
	}
	public void setRegistWallet(double registWallet){
		this.minRegistWallet = registWallet;
		EgovMap in = new EgovMap();
		in.put("tidx", tidx);
		in.put("minRegistWallet", minRegistWallet);
		
		SocketHandler.sh.getSampleDAO().update("updateTraderMinRegist",in);
	}
	
	public void setInfo(int maxFollower, Double minRegistWallet){
		this.maxFollower = maxFollower;
		if(minRegistWallet != null)
			this.minRegistWallet = minRegistWallet;
	}
	
	private void setMyFollowers(){
		followers.clear();
		synchronized (SocketHandler.copytradeList) {
			for(Copytrade copy : SocketHandler.copytradeList){
				if(copy.traderIdx == tidx){
					Member m = Member.getMemberByIdx(copy.userIdx);
					boolean already = false;
					for(Member f : followers){
						if(f == m){
							already = true;
						}
					}
					if(already) continue;
					followers.add(m);
				}
			}
		}
	}

	public int getFollowCount(){
		return followers.size();
	}
	
	public boolean isFollowPossible(){
		if(maxFollower > followers.size()){
			return true;
		}
		return false;
	}
	
	public void addFollowers(int useridx){
		Member m = Member.getMemberByIdx(useridx);
		addFollowers(m);
	}
	public void addFollowers(Member m){
		boolean already = false;
		for(Member f : followers){
			if(f == m){
				already = true;
			}
		}
		if(!already)
			followers.add(m);
	}
	public void removeFollower(int userIdx){
		Member m = Member.getMemberByIdx(userIdx);
		for(Member f : followers){
			if(f == m){
				followers.remove(m);
				return;
			}
		}
	}
	
	//팔로워 데이터 추가하는 곳
	public ArrayList<EgovMap> getFollowersMap(){
		EgovMap in = new EgovMap();
		in.put("tidx", tidx);
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)SocketHandler.sh.getSampleDAO().list("selectCopytradeFollowInfo",in);
		return list;
	}
	
	public boolean getCoinUse(Coin coin){
		if(!coin.isUse) return false;
		return copySymbols[coin.coinNum];
	}
	public int getCoinUseInt(Coin coin){
		if(!coin.isUse) return 0;
		if(copySymbols[coin.coinNum]) return 1;
		return 0;
	}
	
	public void setUseCoin(int coinNum, boolean value){
		Coin coin = Coin.getCoinInfo(coinNum);
		setUseCoin(coin,value);
	}
	public void setUseCoin(Coin coin, boolean value){
		if(copySymbols[coin.coinNum] == value) return;
		
		copySymbols[coin.coinNum] = value;
		if(!value){
			//등록된 카피 거래 중지
			Copytrade.stopSymbol(tidx, coin.coinName +"USDT");
			Copytrade.stopSymbol(tidx, coin.coinName +"USD");
			setMyFollowers();
		}
	}
	public static boolean setTraderUse(int userIdx, boolean [] isUseCoins){
		Log.print("call setTraderUse / user "+userIdx+" coin val = "+isUseCoins, 1, "copytrade");
		Trader trader = Member.getMemberByIdx(userIdx).getTrader();
		if(trader == null) return false;
		
		EgovMap in = new EgovMap();
		in.put("tidx", userIdx);
		
		for(int i = 0; i < isUseCoins.length; i++){
			trader.setUseCoin(i,isUseCoins[i]);
			in.put("coinNum", i);
			in.put("use", isUseCoins[i]);
			SocketHandler.sh.getSampleDAO().update("updateTraderCoinlist",in);
		}
		return true;
	}
	public static void removeFollower(int tidx, int uidx){
		Trader t = Member.getMemberByIdx(tidx).getTrader();
		if(t != null){
			t.removeFollower(uidx);
		}
	}
}
