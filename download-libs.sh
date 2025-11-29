#!/bin/bash

# Script to download all required JAR libraries
# This script downloads all dependencies needed for the Jira Tool project
# Updated to use latest secure versions as of December 2024

set -e

LIB_DIR="lib"
BASE_URL="https://repo1.maven.org/maven2"

echo "Downloading required JAR libraries..."
echo "Using latest secure versions..."
echo ""

# Create lib directory if it doesn't exist
mkdir -p "$LIB_DIR"

# Apache HttpClient - Updated to 4.5.15 (latest 4.5.x, maintains compatibility)
echo "Downloading Apache HttpClient 4.5.15..."
curl -L -o "$LIB_DIR/httpclient-4.5.15.jar" \
  "$BASE_URL/org/apache/httpcomponents/httpclient/4.5.15/httpclient-4.5.15.jar"

# Apache HttpCore - Updated to 4.4.16 (compatible with httpclient 4.5.15)
echo "Downloading Apache HttpCore 4.4.16..."
curl -L -o "$LIB_DIR/httpcore-4.4.16.jar" \
  "$BASE_URL/org/apache/httpcomponents/httpcore/4.4.16/httpcore-4.4.16.jar"

# Jackson Core - Updated to 2.17.1 (latest stable, includes security fixes)
echo "Downloading Jackson Core 2.17.1..."
curl -L -o "$LIB_DIR/jackson-core-2.17.1.jar" \
  "$BASE_URL/com/fasterxml/jackson/core/jackson-core/2.17.1/jackson-core-2.17.1.jar"

# Jackson Annotations - Updated to 2.17.1
echo "Downloading Jackson Annotations 2.17.1..."
curl -L -o "$LIB_DIR/jackson-annotations-2.17.1.jar" \
  "$BASE_URL/com/fasterxml/jackson/core/jackson-annotations/2.17.1/jackson-annotations-2.17.1.jar"

# Jackson Databind - Updated to 2.17.1 (includes security fixes for deserialization vulnerabilities)
echo "Downloading Jackson Databind 2.17.1..."
curl -L -o "$LIB_DIR/jackson-databind-2.17.1.jar" \
  "$BASE_URL/com/fasterxml/jackson/core/jackson-databind/2.17.1/jackson-databind-2.17.1.jar"

# SLF4J API - Using 1.7.36 (stable, widely compatible; 2.0.x has breaking changes)
echo "Downloading SLF4J API 1.7.36..."
curl -L -o "$LIB_DIR/slf4j-api-1.7.36.jar" \
  "$BASE_URL/org/slf4j/slf4j-api/1.7.36/slf4j-api-1.7.36.jar"

# Logback Core - Updated to 1.5.3 (latest stable, includes security fixes)
echo "Downloading Logback Core 1.5.3..."
curl -L -o "$LIB_DIR/logback-core-1.5.3.jar" \
  "$BASE_URL/ch/qos/logback/logback-core/1.5.3/logback-core-1.5.3.jar"

# Logback Classic - Updated to 1.5.3
echo "Downloading Logback Classic 1.5.3..."
curl -L -o "$LIB_DIR/logback-classic-1.5.3.jar" \
  "$BASE_URL/ch/qos/logback/logback-classic/1.5.3/logback-classic-1.5.3.jar"

echo ""
echo "All libraries downloaded successfully!"
echo "JAR files are in the $LIB_DIR directory"
echo ""
echo "Library versions:"
echo "  - Apache HttpClient: 4.5.15"
echo "  - Apache HttpCore: 4.4.16"
echo "  - Jackson Core: 2.17.1"
echo "  - Jackson Annotations: 2.17.1"
echo "  - Jackson Databind: 2.17.1"
echo "  - SLF4J API: 1.7.36"
echo "  - Logback Core: 1.5.3"
echo "  - Logback Classic: 1.5.3"
echo ""
echo "Note: These versions include the latest security patches."
echo "      Run ./check-vulnerabilities.sh to verify for any known CVEs."
