package egovframework.example.sample.web.util;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;

import egovframework.example.sample.service.impl.Log;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class PublicUtils {
	private static long before = 0;
	public static double toFixed(double val, int num){
    	BigDecimal fix = BigDecimal.valueOf(val).setScale(num, RoundingMode.HALF_DOWN);
    	return fix.doubleValue();
    }
	
	public static double getRoi(double profit, double margin){
		if(profit == 0 || margin == 0)
			return 0;
		return PublicUtils.toFixed( (profit / margin) * 100 ,2);
	}
	
	public static void timeCheck(String checkmsg){
		long after = System.currentTimeMillis();
		if(before != 0)
			Log.print("처리완료 걸린 시간 = "+(after - before)+" ms check="+checkmsg, 1, "timecheck");
		before = after;
	}
	public static void resetTimeCheck(){
		before = 0;
	}
	public static ArrayList<EgovMap> sortParentChongList(ArrayList<EgovMap> mlist, String uidxColumn){
		ArrayList<EgovMap> newlist = new ArrayList<>();
		try {
			appendChild(null, uidxColumn, mlist, newlist);
			
		} catch (Exception e) {
			Log.print("sortParentMemberList err! ", 1, "err_notsend");
			return null;
		}
		
		return newlist;
	}
	private static void appendChild(EgovMap parent, String uidxText, ArrayList<EgovMap> source, ArrayList<EgovMap> appendList){
		for(EgovMap child : source){
			if(child == null)
				continue;
			try {
				if(parent == null && child.get("parentsIdx").toString().equals("-1") ||
						parent != null && child.get("parentsIdx").toString().equals(parent.get(uidxText).toString())){
					int source_pidx = appendList.indexOf(parent);
					appendList.add(child);
					appendChild(child, uidxText, source, appendList);
				}
			} catch (Exception e) {
				Log.print("appendChild err! ", 1, "err_notsend");
				// TODO: handle exception
			}
		}
	}
}
