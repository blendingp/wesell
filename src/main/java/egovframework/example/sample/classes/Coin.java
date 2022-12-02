package egovframework.example.sample.classes;

import java.math.BigDecimal;
import java.math.RoundingMode;

import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.sise.Hoga;
import egovframework.example.sample.sise.SiseManager;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class Coin {
	public final int coinNum;
	public final String coinName;
	public final int qtyFixed;
	public final int priceFixed;
	public final int maxLeverage;
	public final int maxVolumeType;
	public final boolean isUse;
	public final int siseAlarmCnt;
	public String fundingRate;
	public int tailRate = 0;
	public double tailPrice = 0;

	public String bidsH = "-1";
	public String asksH = "-1";
	public String bidsL = "-1";
	public String asksL = "-1";
	public Double tmpBidsH = -1.0;
	public Double tmpBidsL = 999999999.0;
	public Double tmpAsksH = -1.0;
	public Double tmpAsksL = 999999999.0;
	public double siseCHECK = 0;
	
	public String mStatus = "-1";
	public String[] asksPriceList;
	public String[] asksQuantityList;
	public String[] bidsPriceList;
	public String[] bidsQuantityList;
	public Hoga[] hogaLongList;
	public Hoga[] hogaShortList;
	public int nullCheckVal = 0;
	public double connectCheck = -1;
	public boolean connected = true;
	public String mGap;
	public String mPrice;
	
	public Coin(int _coinNum, String _coinName, int _qtyFixed, int _priceFixed, int _maxLeverage, int _maxVolumeType, boolean _isUse, int _siseAlarmCnt, int tailRate, double tailPrice){
		this.coinNum = _coinNum;
		this.coinName = _coinName;
		this.qtyFixed = _qtyFixed;
		this.priceFixed = _priceFixed;
		this.maxLeverage = _maxLeverage;
		this.maxVolumeType = _maxVolumeType;
		this.isUse = _isUse;
		this.siseAlarmCnt = _siseAlarmCnt;
		
		this.asksPriceList = new String[10];
		this.asksQuantityList = new String[10];
		this.bidsPriceList = new String[10];
		this.bidsQuantityList = new String[10];
		this.hogaLongList = new Hoga[100];
		this.hogaShortList = new Hoga[100];
		this.tailRate = tailRate;
		this.tailPrice = tailPrice;
	}
	
	public void siseTmpChange(){
		tmpBidsH = Double.parseDouble(bidsH);
		bidsH = "-1";
		tmpBidsL = Double.parseDouble(bidsL);
		bidsL = "999999999";
		tmpAsksH = Double.parseDouble(asksH);
		asksH = "-1";
		tmpAsksL = Double.parseDouble(asksL);
		asksL = "999999999";
		if(tmpBidsH > -1 )
			siseCHECK = tmpBidsH;
	}

	public boolean nullCheck(){
		if(bidsPriceList[0] == null || asksPriceList[0] == null){
			if(nullCheckVal == 0){
				nullCheckVal += 1000;
			}
			nullCheckVal--;
			return true;
		}
		return false;
	}
	
	public Double getTailSise(String position){
		double sise = getSise(position);
//		if(sise > 0 && Project.isTailUse()){
//			int rand = (int) (Math.random() * 100)+1;
//			if(rand <= tailRate){
//				if(position.equals("long")){
//					BigDecimal bigSise = BigDecimal.valueOf(sise).add(BigDecimal.valueOf(tailPrice).multiply(BigDecimal.valueOf(Math.random()))).setScale(priceFixed, RoundingMode.HALF_UP);
//					sise = bigSise.doubleValue();
//				}else{
//					BigDecimal bigSise = BigDecimal.valueOf(sise).subtract(BigDecimal.valueOf(tailPrice).multiply(BigDecimal.valueOf(Math.random()))).setScale(priceFixed, RoundingMode.HALF_UP);
//					sise = bigSise.doubleValue();
//				}
//				Log.print(coinName+" getTailSise 발동! 원 시세 - "+getSise(position)+" / 변동값 - "+tailPrice+" / 변동확률 - "+tailRate+" / 적용 시세 = "+sise, 1, "call");
//			}
//		}
		return sise;
	}
	
	public void tailSet(SampleDAO dao, int rate, double price){
		this.tailRate = rate;
		this.tailPrice = price;
		EgovMap in = new EgovMap();
		in.put("coinNum", coinNum);
		in.put("tailRate", tailRate);
		in.put("tailPrice", tailPrice);
		dao.update("updateCoinTail",in);
	}
	public Double getSise(String position){
    	return getSise(position,true);
    }
	
	public Double getSise(String position, boolean log){
    	double price = -1;
    	try {
    		if(position.equals("long")){
				price = Double.parseDouble(asksPriceList[0]) + SiseManager._rc_adder;
    		}else{
    			price = Double.parseDouble(asksPriceList[0]) + SiseManager._rc_adder;
//    			price = Double.parseDouble(SocketHandler.bidsPriceList[coinNum][0]);
    		}
		} catch (Exception e) {
			if(log)
				Log.print("siseCheck err!! position = "+position+" coinNum = "+coinNum,	1, "err_notsend");
		}
    	return price;
    }
	
	public void setDisconnectedCheck(){
		connectCheck = getSise("long");
		connected = false;
	}

	public void disconnectedCheck(){
		if(!connected && connectCheck != -1 && connectCheck != getSise("long")){
			connected = true;
		}
	}
	
	public static Coin getCoinInfo(String symbol){
		if(symbol.equals("USDT") || symbol.equals("futures"))
			return null;
		
		for(Coin coin : Project.getFullCoinList()){
			if(symbol.contains(coin.coinName))
				return coin;
		}
		
		Log.print("getCoinInfo 코인정보 불러오기 에러. symbol = "+symbol, 1, "err");
		return null;
	}
	
	public static Coin getCoinInfo(int cnum){
		for(Coin coin : Project.getFullCoinList()){
			if(coin.coinNum == cnum)
				return coin;
		}
		Log.print("getCoinInfo 코인정보 불러오기 에러. cnum = "+cnum, 1, "err");
		return null;
	}
	
	public static double getRoi(double profit, double margin){
		if(profit == 0 || margin == 0)
			return 0;
		return PublicUtils.toFixed( (profit / margin) * 100 ,2);
	}
	
	public static int getMaxContractVolume(String symbol, int leverage){
		Coin coin = getCoinInfo(symbol);
		return getMaxContractVolume(coin,leverage);
	}
	public static int getMaxContractVolume(int cnum, int leverage){
		Coin coin = getCoinInfo(cnum);
		return getMaxContractVolume(coin,leverage);
	}
	public static int getMaxContractVolume(Coin coin, int leverage){
		int maxContractVolume = -1;
		switch(coin.maxVolumeType){
		case 1:
			if(leverage <= 18.18){
				maxContractVolume = 10000000;
			}else if(leverage<= 20){
				maxContractVolume = 9000000;
			}else if(leverage<= 22.22){
				maxContractVolume = 8000000;
			}else if(leverage<= 25){
				maxContractVolume = 7000000;
			}else if(leverage<= 28.57){
				maxContractVolume = 6000000;
			}else if(leverage<= 33.33){
				maxContractVolume = 5000000;
			}else if(leverage<= 40){
				maxContractVolume = 4000000;
			}else if(leverage<= 50){
				maxContractVolume = 3000000;
			}else if(leverage<= 66.67){
				maxContractVolume = 2000000;
			}else if(leverage<= 100){
				maxContractVolume = 1000000;
			}
			break;
		case 2:
			if(leverage <= 9.09){
				maxContractVolume = 8000000;
			}else if(leverage<= 10){
				maxContractVolume = 7200000;
			}else if(leverage<= 11.11){
				maxContractVolume = 6400000;
			}else if(leverage<= 12.50){
				maxContractVolume = 5600000;
			}else if(leverage<= 14.29){
				maxContractVolume = 4800000;
			}else if(leverage<= 16.67){
				maxContractVolume = 4000000;
			}else if(leverage<= 20){
				maxContractVolume = 3200000;
			}else if(leverage<= 25){
				maxContractVolume = 2400000;
			}else if(leverage<= 33.33){
				maxContractVolume = 1600000;
			}else if(leverage<= 50){
				maxContractVolume = 800000;
			}
			break;
		case 3:
			if(leverage <= 6.25){
				maxContractVolume = 3000000;
			}else if(leverage<= 6.67){
				maxContractVolume = 2800000;
			}else if(leverage<= 7.14){
				maxContractVolume = 2600000;
			}else if(leverage<= 7.69){
				maxContractVolume = 2400000;
			}else if(leverage<= 8.33){
				maxContractVolume = 2200000;
			}else if(leverage<= 9.09){
				maxContractVolume = 2000000;
			}else if(leverage<= 10.00){
				maxContractVolume = 1800000;
			}else if(leverage<= 11.11){
				maxContractVolume = 1600000;
			}else if(leverage<= 12.50){
				maxContractVolume = 1400000;
			}else if(leverage<= 14.29){
				maxContractVolume = 1200000;
			}else if(leverage<= 16.67){
				maxContractVolume = 1000000;
			}else if(leverage<= 20){
				maxContractVolume = 800000;
			}else if(leverage<= 25){
				maxContractVolume = 600000;
			}else if(leverage<= 33.33){
				maxContractVolume = 400000;
			}else if(leverage<= 50){
				maxContractVolume = 200000;
			}
			break;
		case 4:
			if(leverage <= 5.56){
				maxContractVolume = 3000000;
			}else if(leverage<= 5.88){
				maxContractVolume = 2800000;
			}else if(leverage<= 6.25){
				maxContractVolume = 2600000;
			}else if(leverage<= 6.67){
				maxContractVolume = 2400000;
			}else if(leverage<= 7.14){
				maxContractVolume = 2200000;
			}else if(leverage<= 7.69){
				maxContractVolume = 2000000;
			}else if(leverage<= 8.33){
				maxContractVolume = 1800000;
			}else if(leverage<= 9.09){
				maxContractVolume = 1600000;
			}else if(leverage<= 10.00){
				maxContractVolume = 1400000;
			}else if(leverage<= 11.11){
				maxContractVolume = 1200000;
			}else if(leverage<= 12.50){
				maxContractVolume = 1000000;
			}else if(leverage<= 14.29){
				maxContractVolume = 800000;
			}else if(leverage<= 16.67){
				maxContractVolume = 600000;
			}else if(leverage<= 20){
				maxContractVolume = 400000;
			}else if(leverage<= 25){
				maxContractVolume = 200000;
			}
			break;
		case 5:
			if(leverage <= 2.78){
				maxContractVolume = 375000;
			}else if(leverage<= 2.94){
				maxContractVolume = 350000;
			}else if(leverage<= 3.13){
				maxContractVolume = 325000;
			}else if(leverage<= 3.33){
				maxContractVolume = 300000;
			}else if(leverage<= 4.17){
				maxContractVolume = 225000;
			}else if(leverage<= 5.00){
				maxContractVolume = 175000;
			}else if(leverage<= 6.25){
				maxContractVolume = 125000;
			}else if(leverage<= 7.14){
				maxContractVolume = 100000;
			}else if(leverage<= 8.33){
				maxContractVolume = 75000;
			}else if(leverage<= 10){
				maxContractVolume = 50000;
			}else if(leverage<= 12){
				maxContractVolume = 25000;
			}
		}
		return maxContractVolume;
	}
	
	public static void coinDisconnectedCheck(){
		for(Coin coin : Project.getUseCoinList()){
			coin.disconnectedCheck();
		}
	}
}
