package com.training.util;

import java.util.Map;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Configuration
public class RestUtil {
    //For GetMapping
    public String get(String url, Map<String, Object> params) throws JsonProcessingException {
        RestTemplate template = new RestTemplate();
        String reqBodyData = new ObjectMapper().writeValueAsString(params);
        HttpEntity<String> requestEntity = new HttpEntity<>(reqBodyData);
        ResponseEntity<String> response = template.getForEntity(url, String.class, requestEntity);
        return response.getBody();
    }
    //for PostMapping
    public String post(String url, Map<String, Object> params) throws JsonProcessingException {
        RestTemplate template = new RestTemplate();
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.APPLICATION_JSON);

        String reqBodyData = new ObjectMapper().writeValueAsString(params);
        HttpEntity<String> requestEntity = new HttpEntity<>(reqBodyData, header);
        ResponseEntity<String> response = template.postForEntity(url, requestEntity, String.class);
        return response.getBody();
    }
    //for DeleteMapping
    public String delete(String url, Map<String, Object> params) throws JsonProcessingException{
        RestTemplate template = new RestTemplate();
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.APPLICATION_JSON);

        String reqBodyData = new ObjectMapper().writeValueAsString(params);
        HttpEntity<String> requestEntity = new HttpEntity<>(reqBodyData, header);
        
        ResponseEntity<String> response = template.exchange(url,HttpMethod.DELETE,requestEntity,String.class);
        return response.getBody();
    }

    //for PutMapping
    public String put(String url, Map<String, Object> params) throws JsonProcessingException{
        RestTemplate template = new RestTemplate();
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.APPLICATION_JSON);

        String reqBodyData = new ObjectMapper().writeValueAsString(params);
        HttpEntity<String> requestEntity = new HttpEntity<>(reqBodyData, header);
        
        ResponseEntity<String> response = template.exchange(url,HttpMethod.PUT,requestEntity,String.class);
        return response.getBody();
    }

    //for PatchMapping

   /* public String patch() throws JsonProcessingException{
        RestTemplate restTemplate = new RestTemplate();
        HttpClient httpClient = HttpClientBuilder.create().build();
        HttpComponentsClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory(httpClient);
        restTemplate.setRequestFactory(requestFactory);
        return restTemplate;
        }
    */
}
