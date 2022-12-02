package egovframework.example.sample.web.util;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;

public class CustomPaginationRenderer extends AbstractPaginationRenderer{
	
	public CustomPaginationRenderer() {
		// 
		firstPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"button-18 w-button\">&lt;&lt;</div>";
		previousPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"button-18 w-button\">&lt;</div>";
		currentPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"button-18 click w-button\">{0}</div>";
		otherPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"button-18 w-button\">{2}</div>";
		nextPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"button-18 w-button\">&gt;</div>";
		lastPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"button-18 w-button\">&gt;&gt;</div>";
		
	}
}

