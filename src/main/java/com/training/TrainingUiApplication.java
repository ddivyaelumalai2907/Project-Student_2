package com.training;

import java.util.HashMap;
import java.util.Map;
import com.training.util.RestUtil;
import com.training.controller.TrainingController;
import com.fasterxml.jackson.core.JsonProcessingException;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TrainingUiApplication{
   private static String subjectresponse =null;
	public static void main(String[] args) throws JsonProcessingException{
	    refresh();
		SpringApplication.run(TrainingUiApplication.class, args);
	}

	public static String refresh() throws JsonProcessingException{
		RestUtil restUtil = new RestUtil();
		Map<String,Object> params = new HashMap<String,Object>();
		subjectresponse = restUtil.get("http://localhost:5000/subject", params);
		return subjectresponse;
	}
	public static String getsubjects(){
		return subjectresponse;
	}
}
