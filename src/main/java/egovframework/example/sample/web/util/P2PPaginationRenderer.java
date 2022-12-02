package egovframework.example.sample.web.util;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;

public class P2PPaginationRenderer extends AbstractPaginationRenderer{
	
	public P2PPaginationRenderer() {
		// 
		firstPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"page_btn w-button\">&lt;&lt;</div>";
		previousPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"page_btn w-button\">&lt;</div>";
		currentPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"page_btn w-button click\">{0}</div>";
		otherPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"page_btn w-button\">{2}</div>";
		nextPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"page_btn w-button\">&gt;</div>";
		lastPageLabel = "<div onclick=\"{0}({1}); return false;\" style=\"cursor:pointer;\" class=\"page_btn w-button\">&gt;&gt;</div>";
		
	}
}

