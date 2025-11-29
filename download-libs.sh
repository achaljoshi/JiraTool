#!/bin/bash

# Script to download all required JAR libraries
# This script downloads all dependencies needed for the Jira Tool project

set -e

LIB_DIR="lib"
BASE_URL="https://repo1.maven.org/maven2"

echo "Downloading required JAR libraries..."
echo ""

# Create lib directory if it doesn't exist
mkdir -p "$LIB_DIR"

# Apache HttpClient
echo "Downloading Apache HttpClient..."
curl -L -o "$LIB_DIR/httpclient-4.5.14.jar" \
  "$BASE_URL/org/apache/httpcomponents/httpclient/4.5.14/httpclient-4.5.14.jar"

# Apache HttpCore (dependency of httpclient)
echo "Downloading Apache HttpCore..."
curl -L -o "$LIB_DIR/httpcore-4.4.16.jar" \
  "$BASE_URL/org/apache/httpcomponents/httpcore/4.4.16/httpcore-4.4.16.jar"

# Jackson Core
echo "Downloading Jackson Core..."
curl -L -o "$LIB_DIR/jackson-core-2.15.2.jar" \
  "$BASE_URL/com/fasterxml/jackson/core/jackson-core/2.15.2/jackson-core-2.15.2.jar"

# Jackson Annotations
echo "Downloading Jackson Annotations..."
curl -L -o "$LIB_DIR/jackson-annotations-2.15.2.jar" \
  "$BASE_URL/com/fasterxml/jackson/core/jackson-annotations/2.15.2/jackson-annotations-2.15.2.jar"

# Jackson Databind
echo "Downloading Jackson Databind..."
curl -L -o "$LIB_DIR/jackson-databind-2.15.2.jar" \
  "$BASE_URL/com/fasterxml/jackson/core/jackson-databind/2.15.2/jackson-databind-2.15.2.jar"

# SLF4J API
echo "Downloading SLF4J API..."
curl -L -o "$LIB_DIR/slf4j-api-1.7.36.jar" \
  "$BASE_URL/org/slf4j/slf4j-api/1.7.36/slf4j-api-1.7.36.jar"

# Logback Core
echo "Downloading Logback Core..."
curl -L -o "$LIB_DIR/logback-core-1.2.12.jar" \
  "$BASE_URL/ch/qos/logback/logback-core/1.2.12/logback-core-1.2.12.jar"

# Logback Classic
echo "Downloading Logback Classic..."
curl -L -o "$LIB_DIR/logback-classic-1.2.12.jar" \
  "$BASE_URL/ch/qos/logback/logback-classic/1.2.12/logback-classic-1.2.12.jar"

echo ""
echo "All libraries downloaded successfully!"
echo "JAR files are in the $LIB_DIR directory"

