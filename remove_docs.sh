#!/bin/bash

# Script to remove all inline documentation comments (///) from Dart files
# Usage: ./remove_docs.sh <folder_name>
# Example: ./remove_docs.sh lib

# Check if folder argument is provided
if [ $# -eq 0 ]; then
    echo "❌ Error: Please provide a folder name"
    echo "Usage: ./remove_docs.sh <folder_name>"
    echo "Example: ./remove_docs.sh lib"
    exit 1
fi

TARGET_FOLDER="$1"

# Check if the target folder exists
if [ ! -d "$TARGET_FOLDER" ]; then
    echo "❌ Error: Folder '$TARGET_FOLDER' does not exist"
    exit 1
fi

echo "🗑️  Removing inline documentation comments from Dart files in '$TARGET_FOLDER'..."

# Find all .dart files in specified directory and process them
find "$TARGET_FOLDER" -name "*.dart" -type f | while read -r file; do
    echo "Processing: $file"
    
    # Create a temporary file
    temp_file=$(mktemp)
    
    # Remove all lines that start with optional whitespace followed by ///
    # Also remove empty lines that follow documentation blocks
    sed '/^[[:space:]]*\/\/\//d' "$file" > "$temp_file"
    
    # Remove excessive blank lines (more than 2 consecutive)
    awk '/^$/{blank++} !/^$/{if(blank>2) {print ""} else {for(i=0;i<blank;i++) print ""} blank=0} !/^$/{print}' "$temp_file" > "${temp_file}.clean"
    
    # Move the cleaned file back
    mv "${temp_file}.clean" "$file"
    
    # Clean up
    rm -f "$temp_file"
done

echo "✅ Documentation removal complete!"
echo "📊 Running dart format to clean up formatting..."

# Format specified directory dart files
dart format "$TARGET_FOLDER"

echo "🔍 Running dart analyze to check for issues..."

# Analyze the code
dart analyze

echo "🎉 All done! Inline documentation comments have been removed."