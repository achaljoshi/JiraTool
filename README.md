# Jira Tool

Java-based command-line tools for interacting with Jira Zephyr APIs without requiring the official Jira integration. These tools can be used as post-steps in Tosca automation scripts to update test execution results in Jira.

## Features

- **Add Tests to Cycle**: Add test cases to a Jira test cycle
- **Update Execution Status**: Update test execution status (Pass/Fail) in bulk
- **Standalone JARs**: All dependencies are included in the JAR files - no external dependencies required

## Prerequisites

- Java 11 or higher
- Jira credentials with appropriate permissions

## Project Setup

### 1. Download Required Libraries (One-Time Setup)

**Note:** This step is only needed once, or if the `lib/` directory is missing. If you already have all JAR files in the `lib/` directory, you can skip this step.

**Important:** If you have older library versions and want to update to the latest secure versions, delete the old JARs and re-run this script:
```bash
rm -rf lib/*.jar
./download-libs.sh
```

Download all required JAR libraries:

```bash
./download-libs.sh
```

This script downloads all necessary dependencies into the `lib/` directory:
- Apache HttpClient 4.5.15 (for HTTP requests)
- Jackson 2.17.1 (for JSON processing)
- SLF4J 2.0.9 and Logback 1.5.3 (for logging)

**Security Note:** All libraries are updated to the latest stable versions with security patches as of December 2024. To check for vulnerabilities, run `./check-vulnerabilities.sh` after downloading libraries.

**After libraries are downloaded:** The `download-libs.sh` script is no longer needed unless you need to re-download libraries (e.g., if they get deleted or you're setting up on a new machine).

### 2. Building the Project

**This step is required every time you want to build/rebuild the JAR files.**

To build the project and create the executable JAR files:

```bash
./build.sh
```

This will:
1. Compile all Java source files
2. Create two executable "fat JAR" files in the project root:
   - `add-tests-to-cycle.jar` - For adding tests to a cycle
   - `update-execution-status.jar` - For updating execution status

Both JARs include all dependencies, so they can be run standalone without requiring additional classpath configuration.

**Note:** You must run `./build.sh` every time you:
- Make changes to the Java source code
- Want to rebuild the JAR files
- Need to create fresh JAR files

The `build.sh` script is essential and always needed for compilation and packaging.

## Building with IntelliJ IDEA

If you prefer to use IntelliJ IDEA instead of the command-line build script, follow these steps:

### Step 1: Open Project in IntelliJ IDEA

1. Open IntelliJ IDEA
2. Select **File → Open**
3. Navigate to the JiraTool project directory and select it
4. IntelliJ will detect it as a Java project

### Step 2: Configure Project Structure

1. Go to **File → Project Structure** (or press `Cmd+;` on Mac / `Ctrl+Alt+Shift+S` on Windows/Linux)
2. In the **Project** tab:
   - Set **Project SDK** to Java 11 or higher
   - Set **Project language level** to 11 or higher
3. In the **Libraries** tab:
   - Click the **+** button and select **Java**
   - Navigate to the `lib/` directory and select all JAR files
   - Click **OK** to add them as a library

### Step 3: Configure Source Folders

1. In **Project Structure → Modules**:
   - Ensure `src` is marked as a **Sources** folder (should be blue)
   - If not, right-click on `src` → **Mark Directory as → Sources Root**
   - Ensure `resources` is marked as a **Resources** folder (should be green)
   - If not, right-click on `resources` → **Mark Directory as → Resources Root**

### Step 4: Create Artifact Configuration for add-tests-to-cycle.jar

1. Go to **File → Project Structure → Artifacts**
2. Click the **+** button and select **JAR → From modules with dependencies**
3. Configure the artifact:
   - **Module**: Select your project module
   - **Main Class**: `com.jiratool.AddTestsToCycle`
   - **JAR files from libraries**: Select **extract to the target JAR**
   - **Directory for META-INF/MANIFEST.MF**: Leave as default or select `src` directory
4. Click **OK**
5. Rename the artifact to `add-tests-to-cycle` (right-click → Rename)

### Step 5: Create Artifact Configuration for update-execution-status.jar

1. In the same **Artifacts** window, click **+** again and select **JAR → From modules with dependencies**
2. Configure the artifact:
   - **Module**: Select your project module
   - **Main Class**: `com.jiratool.UpdateExecutionStatus`
   - **JAR files from libraries**: Select **extract to the target JAR**
   - **Directory for META-INF/MANIFEST.MF**: Leave as default or select `src` directory
3. Click **OK**
4. Rename the artifact to `update-execution-status` (right-click → Rename)

### Step 6: Build the JARs

1. Go to **Build → Build Artifacts**
2. You'll see both artifacts listed:
   - `add-tests-to-cycle:jar`
   - `update-execution-status:jar`
3. Select **Build** for each artifact, or select **Build All** to build both
4. The JAR files will be created in the `out/artifacts/` directory:
   - `out/artifacts/add-tests_to_cycle/add-tests-to-cycle.jar`
   - `out/artifacts/update_execution_status/update-execution-status.jar`

### Alternative: Quick Build Method

If you want to build both JARs quickly:

1. **Build → Build Artifacts → add-tests-to-cycle:jar → Build**
2. **Build → Build Artifacts → update-execution-status:jar → Build**

Or use the shortcut: **Build → Build Artifacts → Build All**

### Notes for IntelliJ Build

- The JARs created by IntelliJ will include all dependencies (fat JARs)
- You can copy the JARs from `out/artifacts/` to your project root or any desired location
- To change the output directory, go to **Project Structure → Artifacts** and modify the **Output directory** for each artifact
- You can also set up a **Build Configuration** to automate the build process

## Usage

### 1. Add Tests to Cycle

Adds test cases to a specified test cycle in Jira.

**Syntax:**
```bash
java -jar add-tests-to-cycle.jar <baseUrl> <username> <password> <issueKeys> <versionId> <cycleId> <projectId> [method]
```

**Parameters:**
- `baseUrl` - Jira base URL (e.g., `https://alm-jira.systems.uk.hsbc`)
- `username` - Jira username
- `password` - Jira password
- `issueKeys` - Comma-separated list of issue keys (e.g., `DOMEGPS-179,DOMEGPS-180`)
- `versionId` - Version ID (numeric)
- `cycleId` - Cycle ID (numeric)
- `projectId` - Project ID (numeric)
- `method` - Method (optional, default: `"1"`)

**Example:**
```bash
java -jar add-tests-to-cycle.jar \
  https://alm-jira.systems.uk.hsbc \
  myusername \
  mypassword \
  DOMEGPS-179,DOMEGPS-180 \
  298124 \
  178750 \
  143306 \
  1
```

### 2. Update Execution Status

Updates the status of test executions in Jira. Processes executions in chunks of 25 to handle large batches efficiently.

**Syntax:**
```bash
java -jar update-execution-status.jar <baseUrl> <username> <password> <executionIds> <status>
```

**Parameters:**
- `baseUrl` - Jira base URL (e.g., `https://alm-jira.systems.uk.hsbc`)
- `username` - Jira username
- `password` - Jira password
- `executionIds` - Comma-separated list of execution IDs (e.g., `12345,12346,12347`)
- `status` - Status code: `"1"` for Pass, `"2"` for Fail

**Example:**
```bash
# Update executions to Pass status
java -jar update-execution-status.jar \
  https://alm-jira.systems.uk.hsbc \
  myusername \
  mypassword \
  12345,12346,12347 \
  1

# Update executions to Fail status
java -jar update-execution-status.jar \
  https://alm-jira.systems.uk.hsbc \
  myusername \
  mypassword \
  12345,12346,12347 \
  2
```

## Integration with Tosca

These JAR files can be used as post-steps in your Tosca automation scripts:

1. **Add Tests to Cycle**: Run this after your test execution starts to ensure test cases are added to the cycle
2. **Update Execution Status**: Run this at the end of your test execution to update the status based on results

### Example Tosca Post-Step Configuration

In Tosca, you can add a post-step that executes the Java command:

```
Post-Step: Execute Command
Command: java
Arguments: -jar /path/to/update-execution-status.jar https://alm-jira.systems.uk.hsbc ${JIRA_USER} ${JIRA_PASS} ${EXECUTION_IDS} ${STATUS}
```

Where:
- `${JIRA_USER}` and `${JIRA_PASS}` are Tosca variables containing credentials
- `${EXECUTION_IDS}` is a comma-separated list of execution IDs from your test run
- `${STATUS}` is either `1` (Pass) or `2` (Fail)

## API Endpoints

The tools interact with the following Jira Zephyr APIs:

- **Add Tests to Cycle**: `POST /jira/rest/zapi/latest/execution/addTestsToCycle`
- **Update Execution Status**: `PUT /jira/rest/zapi/latest/execution/updateBulkStatus`

## Error Handling

- Both tools provide clear error messages if required parameters are missing
- Invalid credentials or API errors will be logged and cause the tool to exit with a non-zero status code
- The update execution status tool processes executions in chunks and will continue processing even if one chunk fails

## Logging

The tools use SLF4J with Logback for logging. Logs are output to the console with timestamps and log levels. Debug-level logging is enabled for API request/response details.

## Security

### Library Security

All libraries used in this project are kept up-to-date with the latest secure versions:

- **Apache HttpClient 4.5.15** - Latest stable 4.5.x release with security patches
- **Apache HttpCore 4.4.16** - Compatible with HttpClient 4.5.15
- **Jackson 2.17.1** - Latest stable release with deserialization vulnerability fixes
- **SLF4J 1.7.36** - Stable release (2.0.x has breaking changes, using 1.7.x for compatibility)
- **Logback 1.5.3** - Latest stable release with security patches

### Checking for Vulnerabilities

To check for known vulnerabilities in the project dependencies:

```bash
./check-vulnerabilities.sh
```

This script will:
- Use OWASP Dependency-Check if installed (recommended)
- Provide instructions for manual checking if tools are not available
- Generate vulnerability reports in HTML and JSON formats

**Recommended Tools for Vulnerability Scanning:**
1. **OWASP Dependency-Check** - Free, open-source tool
   - Download: https://github.com/dependency-check/dependency-check/releases
   - Run: `dependency-check.sh --scan lib --out .`
2. **Snyk** - Commercial tool with free tier
   - Install: `npm install -g snyk`
   - Run: `snyk test`
3. **IntelliJ IDEA Package Checker** - Built-in IDE feature
   - Go to: Code > Analyze Code > Show Vulnerable Dependencies

### Security Best Practices

- **Never commit credentials to version control**
- Consider using environment variables or secure credential storage for passwords
- Use HTTPS for all Jira API communications (as configured in the base URL)
- **Regularly update libraries** - Run `./download-libs.sh` periodically to get latest versions
- **Scan for vulnerabilities** - Run `./check-vulnerabilities.sh` regularly, especially after library updates
- Monitor security advisories for all dependencies

## Project Structure

```
JiraTool/
├── build.sh                 # Build script - REQUIRED: compiles and creates JARs
├── download-libs.sh         # One-time setup: downloads libraries (optional if lib/ exists)
├── check-vulnerabilities.sh # Security: checks for known vulnerabilities in dependencies
├── README.md
├── QUICKSTART.md
├── src/
│   └── com/
│       └── jiratool/
│           ├── JiraApiClient.java
│           ├── AddTestsToCycle.java
│           └── UpdateExecutionStatus.java
├── lib/                     # Directory containing all JAR dependencies
│   ├── httpclient-4.5.14.jar
│   ├── httpcore-4.4.16.jar
│   ├── jackson-core-2.15.2.jar
│   ├── jackson-annotations-2.15.2.jar
│   ├── jackson-databind-2.15.2.jar
│   ├── slf4j-api-1.7.36.jar
│   ├── logback-core-1.2.12.jar
│   └── logback-classic-1.2.12.jar
├── resources/
│   └── logback.xml          # Logging configuration
└── build/                   # Temporary build directory (created during build)
```

## Script Usage Summary

| Script | When to Use | Required? |
|--------|-------------|-----------|
| `download-libs.sh` | One-time setup: Only if `lib/` directory is missing or empty | Optional (if libs already exist) |
| `build.sh` | Every time you want to compile and create JAR files | **Always Required** |

**Quick Reference:**
- **Libraries already in `lib/`?** → Skip `download-libs.sh`, just run `./build.sh`
- **Need to build/rebuild JARs?** → Always run `./build.sh`
- **Setting up on new machine?** → Run both scripts in order

## Building from Scratch

If you're setting up the project for the first time:

```bash
# 1. Download all required libraries (skip if lib/ already has JARs)
./download-libs.sh

# 2. Build the project (always required to create JARs)
./build.sh

# 3. The JAR files will be created in the project root
ls -lh *.jar
```

## Troubleshooting

### Common Issues

1. **Connection Refused**: Verify the base URL is correct and accessible
2. **Authentication Failed**: Check username and password are correct
3. **Invalid IDs**: Ensure versionId, cycleId, projectId, and executionIds are valid numeric values
4. **JAR Not Found**: Ensure you've built the project with `./build.sh` and the JAR files exist in the project root
5. **Library Download Failed**: If `download-libs.sh` fails, check your internet connection and try again. The script downloads from Maven Central repository.

### Build Issues

- **Compilation Errors**: Ensure Java 11 or higher is installed (`java -version`)
- **Missing Libraries**: Run `./download-libs.sh` to download all required dependencies
- **Permission Denied**: Make build scripts executable: `chmod +x *.sh`

### Debug Mode

To see detailed request/response logging, the tools already log at DEBUG level for API calls. Check the console output for detailed information.

## License

This project is provided as-is for internal use.
