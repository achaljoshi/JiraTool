# Quick Start Guide

## Initial Setup

### 1. Download Libraries (One-Time Only)

**Skip this if `lib/` directory already contains all JAR files.**

```bash
./download-libs.sh
```

### 2. Build the JARs (Required Every Time)

**Option A: Using Command Line (Recommended)**
```bash
./build.sh
```

**Option B: Using IntelliJ IDEA**
1. Open the project in IntelliJ IDEA
2. Configure Project Structure (File → Project Structure):
   - Add `lib/` directory as a library
   - Mark `src` as Sources root
   - Mark `resources` as Resources root
3. Create artifacts (File → Project Structure → Artifacts):
   - Create JAR artifact for `com.jiratool.AddTestsToCycle` (extract libraries)
   - Create JAR artifact for `com.jiratool.UpdateExecutionStatus` (extract libraries)
4. Build → Build Artifacts → Build All
5. JARs will be in `out/artifacts/` directory

See README.md for detailed IntelliJ instructions.

This creates two executable JAR files:
- `add-tests-to-cycle.jar`
- `update-execution-status.jar`

## Usage Examples

### Add Tests to Cycle

```bash
java -jar add-tests-to-cycle.jar \
  https://alm-jira.systems.uk.hsbc \
  your-username \
  your-password \
  DOMEGPS-179,DOMEGPS-180 \
  298124 \
  178750 \
  143306 \
  1
```

### Update Execution Status (Pass)

```bash
java -jar update-execution-status.jar \
  https://alm-jira.systems.uk.hsbc \
  your-username \
  your-password \
  12345,12346,12347 \
  1
```

### Update Execution Status (Fail)

```bash
java -jar update-execution-status.jar \
  https://alm-jira.systems.uk.hsbc \
  your-username \
  your-password \
  12345,12346,12347 \
  2
```

## Integration with Tosca

1. Copy the JAR files to a location accessible by your Tosca scripts
2. Add a post-step in Tosca that executes:
   ```bash
   java -jar /path/to/update-execution-status.jar ${JIRA_URL} ${JIRA_USER} ${JIRA_PASS} ${EXECUTION_IDS} ${STATUS}
   ```
3. Set the variables:
   - `${JIRA_URL}` - Your Jira base URL
   - `${JIRA_USER}` - Jira username
   - `${JIRA_PASS}` - Jira password
   - `${EXECUTION_IDS}` - Comma-separated execution IDs
   - `${STATUS}` - `1` for Pass, `2` for Fail

## Project Structure

- `src/` - Java source files
- `lib/` - All required JAR dependencies (downloaded by `download-libs.sh`)
- `resources/` - Configuration files (logback.xml)
- `build/` - Temporary build directory (created during build, can be deleted)
- `*.jar` - Executable JAR files (created by `build.sh`)

## Notes

- All dependencies are included in the JAR files - no need to set classpath
- The JARs are "fat JARs" containing all required libraries
- No Maven or Gradle required - pure Java project with included dependencies
