package com.jiratool;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

/**
 * Main class for adding test cases to a Jira test cycle.
 * 
 * Usage:
 * java -jar add-tests-to-cycle.jar <baseUrl> <username> <password> <issueKeys> <versionId> <cycleId> <projectId> [method]
 * 
 * Arguments:
 *   baseUrl    - Jira base URL (e.g., https://alm-jira.systems.uk.hsbc)
 *   username   - Jira username
 *   password   - Jira password
 *   issueKeys  - Comma-separated list of issue keys (e.g., DOMEGPS-179,DOMEGPS-180)
 *   versionId  - Version ID
 *   cycleId    - Cycle ID
 *   projectId  - Project ID
 *   method     - Method (optional, default: "1")
 */
public class AddTestsToCycle {
    private static final Logger logger = LoggerFactory.getLogger(AddTestsToCycle.class);
    private static final String DEFAULT_METHOD = "1";
    private static final String ENDPOINT = "/jira/rest/zapi/latest/execution/addTestsToCycle";
    
    public static void main(String[] args) {
        if (args.length < 7) {
            System.err.println("Usage: java -jar add-tests-to-cycle.jar <baseUrl> <username> <password> " +
                    "<issueKeys> <versionId> <cycleId> <projectId> [method]");
            System.err.println("Example: java -jar add-tests-to-cycle.jar " +
                    "https://alm-jira.systems.uk.hsbc user pass DOMEGPS-179 298124 178750 143306 1");
            System.exit(1);
        }
        
        try {
            String baseUrl = args[0];
            String username = args[1];
            String password = args[2];
            String issueKeysStr = args[3];
            long versionId = Long.parseLong(args[4]);
            long cycleId = Long.parseLong(args[5]);
            long projectId = Long.parseLong(args[6]);
            String method = args.length > 7 ? args[7] : DEFAULT_METHOD;
            
            // Parse issue keys
            List<String> issueKeys = Arrays.asList(issueKeysStr.split(","));
            // Remove duplicates while preserving order
            List<String> uniqueIssues = new ArrayList<>(new LinkedHashSet<>(issueKeys));
            
            logger.info("Adding tests to cycle:");
            logger.info("  Base URL: {}", baseUrl);
            logger.info("  Issue Keys: {}", uniqueIssues);
            logger.info("  Version ID: {}", versionId);
            logger.info("  Cycle ID: {}", cycleId);
            logger.info("  Project ID: {}", projectId);
            logger.info("  Method: {}", method);
            
            // Create API client
            JiraApiClient client = new JiraApiClient(baseUrl, username, password);
            
            // Build request body
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("issues", uniqueIssues);
            requestBody.put("versionId", versionId);
            requestBody.put("cycleId", cycleId);
            requestBody.put("projectId", projectId);
            requestBody.put("method", method);
            
            // Make API call
            String response = client.post(ENDPOINT, requestBody);
            
            logger.info("Successfully added tests to cycle");
            logger.debug("Response: {}", response);
            System.out.println("SUCCESS: Tests added to cycle successfully");
            System.out.println("Response: " + response);
            
        } catch (NumberFormatException e) {
            logger.error("Invalid number format for versionId, cycleId, or projectId", e);
            System.err.println("ERROR: Invalid number format. versionId, cycleId, and projectId must be valid numbers.");
            System.exit(1);
        } catch (Exception e) {
            logger.error("Failed to add tests to cycle", e);
            System.err.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}

