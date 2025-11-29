#!/bin/bash

# Vulnerability check script for Jira Tool project
# This script helps identify known vulnerabilities in the project's dependencies
# Uses OWASP Dependency-Check if available, otherwise provides manual checking instructions

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

LIB_DIR="lib"

echo "========================================="
echo "Vulnerability Check for Jira Tool"
echo "========================================="
echo ""

# Check if OWASP Dependency-Check is available
if command -v dependency-check.sh &> /dev/null || command -v dependency-check &> /dev/null; then
    echo "OWASP Dependency-Check found. Running scan..."
    echo ""
    
    DEPENDENCY_CHECK_CMD=""
    if command -v dependency-check.sh &> /dev/null; then
        DEPENDENCY_CHECK_CMD="dependency-check.sh"
    elif command -v dependency-check &> /dev/null; then
        DEPENDENCY_CHECK_CMD="dependency-check"
    fi
    
    # Run dependency check on lib directory
    $DEPENDENCY_CHECK_CMD \
        --project "JiraTool" \
        --scan "$LIB_DIR" \
        --out "$SCRIPT_DIR" \
        --format HTML \
        --format JSON \
        --enableExperimental \
        --failOnCVSS 0
    
    echo ""
    echo "Vulnerability report generated:"
    echo "  - HTML: dependency-check-report.html"
    echo "  - JSON: dependency-check-report.json"
    echo ""
    
elif [ -f "$SCRIPT_DIR/dependency-check/bin/dependency-check.sh" ]; then
    echo "Using local OWASP Dependency-Check installation..."
    echo ""
    
    "$SCRIPT_DIR/dependency-check/bin/dependency-check.sh" \
        --project "JiraTool" \
        --scan "$LIB_DIR" \
        --out "$SCRIPT_DIR" \
        --format HTML \
        --format JSON \
        --enableExperimental \
        --failOnCVSS 0
    
    echo ""
    echo "Vulnerability report generated:"
    echo "  - HTML: dependency-check-report.html"
    echo "  - JSON: dependency-check-report.json"
    echo ""
    
else
    echo "OWASP Dependency-Check not found."
    echo ""
    echo "To check for vulnerabilities, you have the following options:"
    echo ""
    echo "Option 1: Install OWASP Dependency-Check"
    echo "  Download from: https://github.com/dependency-check/dependency-check/releases"
    echo "  Extract and run: ./dependency-check/bin/dependency-check.sh --scan lib --out ."
    echo ""
    echo "Option 2: Use Snyk (if you have an account)"
    echo "  Install: npm install -g snyk"
    echo "  Run: snyk test --file=lib/*.jar"
    echo ""
    echo "Option 3: Use IntelliJ IDEA Package Checker"
    echo "  Open project in IntelliJ IDEA"
    echo "  Go to: Code > Analyze Code > Show Vulnerable Dependencies"
    echo ""
    echo "Option 4: Manual check via online tools"
    echo "  - National Vulnerability Database: https://nvd.nist.gov/"
    echo "  - Snyk Vulnerability DB: https://security.snyk.io/"
    echo "  - Maven Central Security: Check each library's security advisories"
    echo ""
    echo "Current library versions in use:"
    echo "  - Apache HttpClient: 4.5.15"
    echo "  - Apache HttpCore: 4.4.16"
    echo "  - Jackson Core: 2.17.1"
    echo "  - Jackson Annotations: 2.17.1"
    echo "  - Jackson Databind: 2.17.1"
    echo "  - SLF4J API: 1.7.36"
    echo "  - Logback Core: 1.5.3"
    echo "  - Logback Classic: 1.5.3"
    echo ""
    echo "These versions were selected as the latest stable releases with security patches."
    echo "However, you should regularly check for new vulnerabilities and updates."
    echo ""
fi

echo "========================================="
echo "Vulnerability Check Complete"
echo "========================================="

