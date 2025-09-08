#!/bin/bash

# Script to remove all inline documentation comments (///) from Dart files
# Usage: ./remove_docs.sh

echo "🗑️  Removing inline documentation comments from Dart files..."

# Find all .dart files and process them
find . -name "*.dart" -type f | while read -r file; do
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

# Format all dart files
dart format .

echo "🔍 Running dart analyze to check for issues..."

# Analyze the code
dart analyze

echo "🎉 All done! Inline documentation comments have been removed."