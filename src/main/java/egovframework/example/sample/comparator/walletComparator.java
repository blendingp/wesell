package egovframework.example.sample.comparator;

import java.util.Comparator;

import egovframework.example.sample.classes.Order;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class walletComparator implements Comparator<EgovMap>{

	@Override
	public int compare(EgovMap o1, EgovMap o2){
		double wallet1 = Double.parseDouble(o1.get("wallet").toString());
		double wallet2 = Double.parseDouble(o2.get("wallet").toString());
		
		if( wallet1 > wallet2 ){
			return -1;
		}else if(wallet1 < wallet2){
			return 1;
		}else
			return 0;
	}
}
