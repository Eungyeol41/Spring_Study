package com.ini.sport.qna;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class QnaController {

	/** folderPath **/
	private final static String folderPath = "/qna/";

	@RequestMapping(value = folderPath + "/list.do")
	public String list() {
		return ".sport:/" + folderPath + "list";
	}
}
