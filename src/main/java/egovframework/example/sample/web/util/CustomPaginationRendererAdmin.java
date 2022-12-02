package egovframework.example.sample.web.util;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;

public class CustomPaginationRendererAdmin extends AbstractPaginationRenderer{
	
	public CustomPaginationRendererAdmin() {
		firstPageLabel = "<li class=\"paginate_button page-item previous\"><a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"page-link\">처음</a></li>"; 
		previousPageLabel = "<li class=\"paginate_button page-item previous\"><a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"page-link\">이전</a></li>";
		currentPageLabel = "<li class=\"paginate_button page-item active\"><a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"page-link\">{0}</a></li>";
		otherPageLabel = "<li class=\"paginate_button page-item\"><a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"page-link\">{2}</a></li>";
		nextPageLabel = "<li class=\"paginate_button page-item next\"><a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"page-link\">다음</a></li>";
		lastPageLabel = "<li class=\"paginate_button page-item next\"><a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"page-link\">마지막</a></li>";
		
	}
}
