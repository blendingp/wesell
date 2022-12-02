package egovframework.example.sample.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
public class EmergencyController {
	
	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	//회사 IP 바뀌었을 경우 어드민 진입을 위한 어드민IP 메모리 갱신 링크.
	@RequestMapping(value="/adminIpReset.do"  , produces="application/json; charset=utf8")
    public String adminIpReset(HttpServletRequest request){
    	Log.print("call adminIpReset!", 1, "call");
		SocketHandler.adminIpList = (List<EgovMap>)sampleDAO.list("selectAdminIp");
		return "redirect:block.do";
    		
    }
}
