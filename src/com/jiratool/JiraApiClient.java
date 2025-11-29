package com.jiratool;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Map;

/**
 * Common HTTP client utility for making Jira API calls.
 */
public class JiraApiClient {
    private static final Logger logger = LoggerFactory.getLogger(JiraApiClient.class);
    
    private final String baseUrl;
    private final String username;
    private final String password;
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;
    
    public JiraApiClient(String baseUrl, String username, String password) {
        this.baseUrl = baseUrl;
        this.username = username;
        this.password = password;
        this.httpClient = HttpClients.createDefault();
        this.objectMapper = new ObjectMapper();
    }
    
    /**
     * Creates Basic Authentication header value.
     */
    private String createAuthHeader() {
        String credentials = username + ":" + password;
        String encodedCredentials = Base64.getEncoder().encodeToString(
            credentials.getBytes(StandardCharsets.UTF_8));
        return "Basic " + encodedCredentials;
    }
    
    /**
     * Makes a POST request to the Jira API.
     * 
     * @param endpoint API endpoint (e.g., "/jira/rest/zapi/latest/execution/addTestsToCycle")
     * @param requestBody Request body as a Map
     * @return Response body as string
     * @throws Exception if the request fails
     */
    public String post(String endpoint, Map<String, Object> requestBody) throws Exception {
        String url = baseUrl + endpoint;
        logger.info("Making POST request to: {}", url);
        
        HttpPost request = new HttpPost(url);
        request.setHeader("Authorization", createAuthHeader());
        request.setHeader("Content-Type", "application/json");
        
        String jsonBody = objectMapper.writeValueAsString(requestBody);
        logger.debug("Request body: {}", jsonBody);
        request.setEntity(new StringEntity(jsonBody, StandardCharsets.UTF_8));
        
        HttpResponse response = httpClient.execute(request);
        int statusCode = response.getStatusLine().getStatusCode();
        HttpEntity entity = response.getEntity();
        String responseBody = entity != null ? EntityUtils.toString(entity) : "";
        
        logger.info("Response status: {}", statusCode);
        logger.debug("Response body: {}", responseBody);
        
        if (statusCode >= 200 && statusCode < 300) {
            return responseBody;
        } else {
            throw new RuntimeException(
                String.format("API request failed with status %d: %s", statusCode, responseBody));
        }
    }
    
    /**
     * Makes a PUT request to the Jira API.
     * 
     * @param endpoint API endpoint (e.g., "/jira/rest/zapi/latest/execution/updateBulkStatus")
     * @param requestBody Request body as a Map
     * @return Response body as string
     * @throws Exception if the request fails
     */
    public String put(String endpoint, Map<String, Object> requestBody) throws Exception {
        String url = baseUrl + endpoint;
        logger.info("Making PUT request to: {}", url);
        
        HttpPut request = new HttpPut(url);
        request.setHeader("Authorization", createAuthHeader());
        request.setHeader("Content-Type", "application/json");
        
        String jsonBody = objectMapper.writeValueAsString(requestBody);
        logger.debug("Request body: {}", jsonBody);
        request.setEntity(new StringEntity(jsonBody, StandardCharsets.UTF_8));
        
        HttpResponse response = httpClient.execute(request);
        int statusCode = response.getStatusLine().getStatusCode();
        HttpEntity entity = response.getEntity();
        String responseBody = entity != null ? EntityUtils.toString(entity) : "";
        
        logger.info("Response status: {}", statusCode);
        logger.debug("Response body: {}", responseBody);
        
        if (statusCode >= 200 && statusCode < 300) {
            return responseBody;
        } else {
            throw new RuntimeException(
                String.format("API request failed with status %d: %s", statusCode, responseBody));
        }
    }
}

