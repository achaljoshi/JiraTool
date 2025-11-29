package com.jiratool;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

/**
 * Main class for updating test execution status in Jira.
 * 
 * Usage:
 * java -jar update-execution-status.jar <baseUrl> <username> <password> <executionIds> <status>
 * 
 * Arguments:
 *   baseUrl      - Jira base URL (e.g., https://alm-jira.systems.uk.hsbc)
 *   username     - Jira username
 *   password     - Jira password
 *   executionIds - Comma-separated list of execution IDs (e.g., 12345,12346,12347)
 *   status       - Status code: "1" for Pass, "2" for Fail
 */
public class UpdateExecutionStatus {
    private static final Logger logger = LoggerFactory.getLogger(UpdateExecutionStatus.class);
    private static final String ENDPOINT = "/jira/rest/zapi/latest/execution/updateBulkStatus";
    private static final int CHUNK_SIZE = 25; // Process in chunks of 25 as shown in the Python code
    
    public static void main(String[] args) {
        if (args.length < 5) {
            System.err.println("Usage: java -jar update-execution-status.jar <baseUrl> <username> <password> " +
                    "<executionIds> <status>");
            System.err.println("Example: java -jar update-execution-status.jar " +
                    "https://alm-jira.systems.uk.hsbc user pass 12345,12346,12347 1");
            System.err.println("Status: 1 = Pass, 2 = Fail");
            System.exit(1);
        }
        
        try {
            String baseUrl = args[0];
            String username = args[1];
            String password = args[2];
            String executionIdsStr = args[3];
            String status = args[4];
            
            // Validate status
            if (!status.equals("1") && !status.equals("2")) {
                System.err.println("ERROR: Status must be '1' (Pass) or '2' (Fail)");
                System.exit(1);
            }
            
            // Parse execution IDs
            String[] executionIdArray = executionIdsStr.split(",");
            List<String> executionIds = new ArrayList<>();
            for (String id : executionIdArray) {
                String trimmed = id.trim();
                if (!trimmed.isEmpty()) {
                    executionIds.add(trimmed);
                }
            }
            
            // Remove duplicates while preserving order
            List<String> uniqueExecutionIds = new ArrayList<>(new LinkedHashSet<>(executionIds));
            
            logger.info("Updating execution status:");
            logger.info("  Base URL: {}", baseUrl);
            logger.info("  Execution IDs: {} (total: {})", uniqueExecutionIds, uniqueExecutionIds.size());
            logger.info("  Status: {} ({})", status, status.equals("1") ? "Pass" : "Fail");
            
            // Create API client
            JiraApiClient client = new JiraApiClient(baseUrl, username, password);
            
            // Process in chunks
            int totalChunks = (int) Math.ceil((double) uniqueExecutionIds.size() / CHUNK_SIZE);
            logger.info("Processing {} execution(s) in {} chunk(s) of size {}", 
                    uniqueExecutionIds.size(), totalChunks, CHUNK_SIZE);
            
            int successCount = 0;
            int failCount = 0;
            
            for (int i = 0; i < uniqueExecutionIds.size(); i += CHUNK_SIZE) {
                int end = Math.min(i + CHUNK_SIZE, uniqueExecutionIds.size());
                List<String> chunk = uniqueExecutionIds.subList(i, end);
                
                logger.info("Processing chunk {}/{} with {} execution(s)", 
                        (i / CHUNK_SIZE) + 1, totalChunks, chunk.size());
                
                try {
                    // Build request body
                    Map<String, Object> requestBody = new HashMap<>();
                    requestBody.put("executions", chunk);
                    requestBody.put("status", status);
                    
                    // Make API call
                    String response = client.put(ENDPOINT, requestBody);
                    
                    successCount += chunk.size();
                    logger.info("Successfully updated {} execution(s) in chunk", chunk.size());
                    logger.debug("Response: {}", response);
                    
                } catch (Exception e) {
                    failCount += chunk.size();
                    logger.error("Failed to update chunk: {}", chunk, e);
                    System.err.println("WARNING: Failed to update chunk: " + e.getMessage());
                    // Continue with next chunk
                }
            }
            
            logger.info("Update completed: {} successful, {} failed", successCount, failCount);
            
            if (failCount == 0) {
                System.out.println("SUCCESS: All " + successCount + " execution(s) updated successfully");
            } else {
                System.out.println("PARTIAL SUCCESS: " + successCount + " execution(s) updated, " + 
                        failCount + " execution(s) failed");
                System.exit(1);
            }
            
        } catch (Exception e) {
            logger.error("Failed to update execution status", e);
            System.err.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}

