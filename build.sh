#!/bin/bash

# Build script for traditional Java project
# Compiles the Java source files and creates executable JARs with all dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

SRC_DIR="src"
BUILD_DIR="build"
LIB_DIR="lib"
RESOURCES_DIR="resources"

echo "========================================="
echo "Building Jira Tool"
echo "========================================="
echo ""

# Check if lib directory exists and has JARs
if [ ! -d "$LIB_DIR" ] || [ -z "$(ls -A $LIB_DIR/*.jar 2>/dev/null)" ]; then
    echo "ERROR: Library JARs not found in $LIB_DIR directory"
    echo "Please run ./download-libs.sh first to download required libraries"
    exit 1
fi

# Create build directory
echo "Creating build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/classes"

# Build classpath from all JARs in lib directory
CLASSPATH="$LIB_DIR/*"
if [ -d "$RESOURCES_DIR" ]; then
    CLASSPATH="$CLASSPATH:$RESOURCES_DIR"
fi

echo "Compiling Java source files..."
javac -d "$BUILD_DIR/classes" \
      -cp "$CLASSPATH" \
      -sourcepath "$SRC_DIR" \
      "$SRC_DIR/com/jiratool/"*.java

# Copy resources
if [ -d "$RESOURCES_DIR" ]; then
    echo "Copying resources..."
    cp -r "$RESOURCES_DIR"/* "$BUILD_DIR/classes/" 2>/dev/null || true
fi

echo ""
echo "Compilation successful!"
echo ""
echo "Creating JAR files with all dependencies..."

# Create temporary directory for fat JAR assembly
TEMP_DIR="$BUILD_DIR/fat-jar"
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Copy compiled classes
echo "  Assembling add-tests-to-cycle.jar..."
cp -r "$BUILD_DIR/classes"/* "$TEMP_DIR/"

# Extract all library JARs into temp directory
for jar in "$LIB_DIR"/*.jar; do
    if [ -f "$jar" ]; then
        cd "$TEMP_DIR"
        jar xf "$SCRIPT_DIR/$jar" 2>/dev/null || true
        cd "$SCRIPT_DIR"
    fi
done

# Remove duplicate signature files
find "$TEMP_DIR/META-INF" -name "*.SF" -delete 2>/dev/null || true
find "$TEMP_DIR/META-INF" -name "*.DSA" -delete 2>/dev/null || true
find "$TEMP_DIR/META-INF" -name "*.RSA" -delete 2>/dev/null || true

# Create manifest
mkdir -p "$TEMP_DIR/META-INF"
cat > "$TEMP_DIR/META-INF/MANIFEST.MF" << 'EOF'
Manifest-Version: 1.0
Main-Class: com.jiratool.AddTestsToCycle
EOF

# Create JAR
cd "$TEMP_DIR"
jar cfm "$SCRIPT_DIR/add-tests-to-cycle.jar" META-INF/MANIFEST.MF *
cd "$SCRIPT_DIR"

echo "  Assembling update-execution-status.jar..."

# Update manifest for second JAR
cat > "$TEMP_DIR/META-INF/MANIFEST.MF" << 'EOF'
Manifest-Version: 1.0
Main-Class: com.jiratool.UpdateExecutionStatus
EOF

# Create second JAR
cd "$TEMP_DIR"
jar cfm "$SCRIPT_DIR/update-execution-status.jar" META-INF/MANIFEST.MF *
cd "$SCRIPT_DIR"

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "========================================="
echo "Build completed successfully!"
echo "========================================="
echo ""
echo "JAR files created:"
echo "  - add-tests-to-cycle.jar"
echo "  - update-execution-status.jar"
echo ""
