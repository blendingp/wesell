package egovframework.example.sample.web.util;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;

public class CustomPaginationRendererInfl extends AbstractPaginationRenderer{
	
	public CustomPaginationRendererInfl() {
		// 
		firstPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"button-27 next w-button\">&lt;&lt;</a>";
		previousPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"button-27 next w-button\">&lt;</a>";
		currentPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"button-27 click w-button\">{0}</a>";
		otherPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"button-27 w-button\">{2}</a>";
		nextPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"button-27 next w-button\">&gt;</a>";
		lastPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"button-27 next w-button\">&gt;&gt;</a>";
	}
}

