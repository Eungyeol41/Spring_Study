package com.ini.sport;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HomeController {

	@ResponseBody
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		return "HomeController - home method";
	}

	// tiles-layout 실험 method
	@RequestMapping(value = "/sport", method = RequestMethod.GET)
	public String sport() {
		return ".sport:/sport";
	}

}
