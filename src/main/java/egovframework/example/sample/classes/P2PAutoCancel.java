package egovframework.example.sample.classes;

import java.time.LocalDateTime;
import java.util.Iterator;

import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class P2PAutoCancel {
	public int p2pIdx;
	public int userIdx;
	public LocalDateTime time;
	public P2PAutoCancel(int p2pIdx, int userIdx, LocalDateTime time){	
		if(time == null){
			time = LocalDateTime.now();
		}
		this.time = time;
		this.p2pIdx = p2pIdx;
		this.userIdx = userIdx;
		synchronized (SocketHandler.p2pAutoCancelList) {
			SocketHandler.p2pAutoCancelList.add(this);
		}
	}
	public static void putAutoCancelList(int p2pIdx, int userIdx, LocalDateTime time){
		if(Project.isP2PAutoCancel()){
			new P2PAutoCancel(p2pIdx, userIdx, time);
		}
	}
	public static void cancelCheck(SampleDAO dao){
		if(Project.isP2PAutoCancel()){
			synchronized (SocketHandler.p2pAutoCancelList) {
				for (Iterator<P2PAutoCancel> iter = SocketHandler.p2pAutoCancelList.iterator(); iter.hasNext(); ) {
					P2PAutoCancel p = iter.next();
					if(Send.compareNow(p.time.plusHours(1)) < 0){
						Log.print("cancelCheck p2p 입금 없이 1시간 경과, 취소 처리 p2pidx = "+p.p2pIdx+" / userIdx = "+p.userIdx, 1, "call");
						EgovMap in = new EgovMap();
						in.put("idx", p.p2pIdx);
						dao.update("updateP2PDepositCancel",in);
						Member m = Member.getMemberByIdx(p.userIdx);
						m.resetP2PRun();
						iter.remove();
					}
	    		}
	    	}
		}
	}
	public static void remove(int userIdx){
		if(Project.isP2PAutoCancel()){
			synchronized (SocketHandler.p2pAutoCancelList) {
				for (Iterator<P2PAutoCancel> iter = SocketHandler.p2pAutoCancelList.iterator(); iter.hasNext(); ) {
					P2PAutoCancel p = iter.next();
					if(p.userIdx == userIdx)
						iter.remove();
				}
			}
		}
	}
}
