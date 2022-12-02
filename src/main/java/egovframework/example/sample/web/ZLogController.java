package egovframework.example.sample.web;

import java.util.Calendar;

import egovframework.example.sample.service.impl.Log;

public class ZLogController {
	
	public long preMin=-1;
	public int preSendcount=0;//패킷 전송 직전 1분간  기록.
	public int curSendcount=0;//현재 패킷 전송 갯수 증가
	
	public ZLogController (){
		Log.print("ZLogController  생성자", 1, "log");
	}
	
	public void adderSendPacket(){
		curSendcount++;
		if( preMin != Calendar.getInstance().getTime().getMinutes()){
			preSendcount = curSendcount;
			curSendcount = 0;
			preMin = Calendar.getInstance().getTime().getMinutes();
		}
	}

}
