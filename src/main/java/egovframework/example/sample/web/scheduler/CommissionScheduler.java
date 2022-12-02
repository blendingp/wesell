package egovframework.example.sample.web.scheduler;

import javax.annotation.Resource;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.P2PAutoCancel;
import egovframework.example.sample.classes.Position;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Send;

@Component
public class CommissionScheduler {
    @Resource(name = "sampleDAO")        
    SampleDAO sampleDAO;
    
    @Scheduled(cron = "0 0/1 * * * *")
    public void autoCancel(){
    	P2PAutoCancel.cancelCheck(sampleDAO);
    }

    @Scheduled(cron = "0 0/1 * * * *")
    public void siseDisconnectedCheck(){
    	if(SocketHandler.fixstat == 1) return;
    	listSet();
    	for(Coin coin : Project.getUseCoinList()){
    		if(coin.connected){
    			cont[coin.coinNum] = 0;
    			coin.setDisconnectedCheck();
    		}else{
    			cont[coin.coinNum]++;
    			int alarnCnt = cont[coin.coinNum] % coin.siseAlarmCnt;
    			if(alarnCnt == 0){
    				String msg = coin.coinName+" 코인 시세 끊김 "+cont[coin.coinNum];
    				Send.sendTelegramAlarmBotMsg(msg);
    				coin.setDisconnectedCheck();
    			}
    		}
    	}
    }
    
    int cont [] = null;
    int oneday = 0;
    private void listSet(){
    	if(cont == null){
    		int size = Project.getFullCoinList().size();
    		cont = new int[size];
    	}
    }
    @Scheduled(cron = "0/10 * * * * *")
    public void checkStop()
    {
    	oneday++;
    	if (oneday % 8600 == 0) {
			Send.sendTelegramAlarmBotMsg("12시간째  돌아가고 있음.");
		}
	}
      
	@Scheduled(cron = "0 0 0 * * *")//0시 마다 호출
    public void resetAccumWd()
    {       
		Member.allResetWd();
    }
	
    @Scheduled(cron = "0 0 1 * * *")//1시 마다 호출
    public void giveFundingScheduler()
    {       
    	Log.print("Funding execute-----------오전 1시 ---", 0, "FundingFee");
    	Position.giveFunding();
    }
    
    @Scheduled(cron = "0 0 9 * * *")//9시 마다 호출
    public void giveFundingScheduler2()
    {       
    	Log.print("Funding execute-----------오전 9시 ---", 0, "FundingFee");
    	Position.giveFunding();
    }
    
    @Scheduled(cron = "0 0 17 * * *")//5시 마다 호출
    public void giveFundingScheduler3()
    {       
    	Log.print("Funding execute-----------오후 5시 ---", 0, "FundingFee");
    	Position.giveFunding();
    }    
}
