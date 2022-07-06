package com.ini.sport.user;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UserController {

	/** folderPath **/
	private final static String folderPath = "/user/";

	@RequestMapping(value = folderPath + "/list.do")
	public String list() {
		return ".sport:/" + folderPath + "list";
	}
}
