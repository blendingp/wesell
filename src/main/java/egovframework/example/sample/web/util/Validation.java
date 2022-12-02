package egovframework.example.sample.web.util;

import java.util.List;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor.HSSFColorPredefined;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;

import egovframework.example.sample.classes.QueryWait;
import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class Validation {
	public static boolean isNull(String str){
		return str == null || str.isEmpty() || str.equals("null") || str.equals("NaN") || str.equals("undefined");
	}
	
	public static boolean isValidEmail(String email) { 
		return Pattern.matches("^[_a-zA-Z0-9-\\.]+@[\\.a-zA-Z0-9-]+\\.[a-zA-Z]+$", email);
//		boolean err = false; 
//		String regex = "^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$"; 
//		Pattern p = Pattern.compile(regex); 
//		Matcher m = p.matcher(email); 
//		if(m.matches()) { err = true; } 
//		System.out.println("err:"+err);
//		return err;
	}
	public static boolean isEnNum(String str){
		return Pattern.matches("[a-zA-Z0-9]*$", str);
	}
	public static boolean isValidPhone(String str) {
	    return Pattern.matches("^\\d{2,3}\\d{3,4}\\d{4}$", str);
	}

	public static String getTempPassword(int length) {
		int index = 0;
		char[] charArr = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
				'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a',
				'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
				'w', 'x', 'y', 'z' };
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < length; i++) {
			index = (int) (charArr.length * Math.random());
			sb.append(charArr[index]);
		}
		return sb.toString();
	}
	
	public static String getTempNumber(int length) {
		int index = 0;
		char[] charArr = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < length; i++) {
			index = (int) (charArr.length * Math.random());
			sb.append(charArr[index]);
		}
		return sb.toString();
	}
	
	// 엑셀
	public static void excelDown(HttpServletResponse response , List<EgovMap> list , String name , String[] header , String[] dataNm , String searchData , String period , String searchData2)throws Exception{
		Workbook wb = new HSSFWorkbook();
		Sheet sheet = wb.createSheet(name);
		Row row = null;
		Cell cell = null;
		int rowNo = 0;
		// 테이블 헤더용 스타일
		CellStyle headStyle = wb.createCellStyle();
		// 가는 경계선을 가집니다.
		headStyle.setBorderTop(BorderStyle.THIN);
		headStyle.setBorderBottom(BorderStyle.THIN);
		headStyle.setBorderLeft(BorderStyle.THIN);
		headStyle.setBorderRight(BorderStyle.THIN);
		// 배경색은 노란색입니다.
		headStyle.setFillForegroundColor(HSSFColorPredefined.YELLOW.getIndex());
		headStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		// 데이터는 가운데 정렬합니다.
		headStyle.setAlignment(HorizontalAlignment.CENTER);
		// 데이터용 경계 스타일 테두리만 지정
		CellStyle bodyStyle = wb.createCellStyle();
		bodyStyle.setBorderTop(BorderStyle.THIN);
		bodyStyle.setBorderBottom(BorderStyle.THIN);
		bodyStyle.setBorderLeft(BorderStyle.THIN);
		bodyStyle.setBorderRight(BorderStyle.THIN);
		// 헤더 생성
		sheet.addMergedRegion(new CellRangeAddress(0 , 0 , 0 , header.length-1)); // 병합 cellRangeAddress(첫행,마지막행, 첫열, 마지막열)
	    row = sheet.createRow(rowNo++);
	    cell = row.createCell(0);
	    cell.setCellStyle(headStyle);
	    if(period.equals("~")) period = "";
	    cell.setCellValue(period+" "+name);
	    row = sheet.createRow(rowNo++);

	    sheet.addMergedRegion(new CellRangeAddress(1 , 1 , 0 , header.length-1)); // 병합 cellRangeAddress(첫행,마지막행, 첫열, 마지막열)	    row = sheet.createRow(rowNo++);
	    cell = row.createCell(0);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue(searchData);
	    row = sheet.createRow(rowNo++);
	    
	    if(searchData2 != null && !searchData2.equals("")){
	    	sheet.addMergedRegion(new CellRangeAddress(2 , 2 , 0 , header.length-1)); // 병합 cellRangeAddress(첫행,마지막행, 첫열, 마지막열)	    row = sheet.createRow(rowNo++);
	    	cell = row.createCell(0);
	    	cell.setCellStyle(headStyle);
	    	cell.setCellValue(searchData2);
	    	row = sheet.createRow(rowNo++);
	    }
	    
	    row = sheet.createRow(rowNo++);
	    for(int i=0; i< header.length; i++){
		    cell = row.createCell(i);
		    cell.setCellStyle(headStyle);
		    cell.setCellValue(header[i]);
	    }		
		// 데이터 부분 생성
		for(EgovMap info : list) {
			row = sheet.createRow(rowNo++);
			for(int i=0; i<dataNm.length; i++){
				cell = row.createCell(i);
				cell.setCellStyle(bodyStyle);
				if(info.get(dataNm[i]) == null || info.get(dataNm[i]).equals("")|| info.get(dataNm[i]).equals("null") || info.get(dataNm[i]).equals("&nbsp;")){
					cell.setCellValue("");
				}else{
					cell.setCellValue(""+info.get(dataNm[i]));
				}
				
			}
		}
	    // 컨텐츠 타입과 파일명 지정
	    response.setContentType("ms-vnd/excel");
	    String outputFileName = new String(name.getBytes("KSC5601"), "8859_1");
	    response.setHeader("Content-Disposition", "attachment;filename="+outputFileName+".xls");
	    // 엑셀 출력
	    wb.write(response.getOutputStream());
	    response.getOutputStream().flush();
	    response.getOutputStream().close();	    
	    wb.close();
	}
}
