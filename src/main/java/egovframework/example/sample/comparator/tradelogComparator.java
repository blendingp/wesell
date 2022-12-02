package egovframework.example.sample.comparator;

import java.sql.Timestamp;
import java.util.Comparator;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class tradelogComparator implements Comparator<EgovMap>{

	@Override
	public int compare(EgovMap o1, EgovMap o2){
		Timestamp date1 = Timestamp.valueOf(o1.get("buyDatetime").toString());
		Timestamp date2 = Timestamp.valueOf(o2.get("buyDatetime").toString());
		
		if( date1.after(date2)){
			return -1;
		}else if(date1.before(date2)){
			return 1;
		}else
			return 0;
	}
}
