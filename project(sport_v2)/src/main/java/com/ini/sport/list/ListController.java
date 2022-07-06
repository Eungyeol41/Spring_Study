package com.ini.sport.list;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ListController {

	/** folderPath **/
	private final static String folderPath = "/list/";

	@RequestMapping(value = folderPath + "/list.do")
	public String list() {
		return ".sport:/" + folderPath + "list";
	}
}
