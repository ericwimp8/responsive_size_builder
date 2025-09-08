#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script to remove all inline documentation comments (///) from Dart files
/// while preserving code structure and readability.
void main() async {
  print('🗑️  Removing inline documentation comments from Dart files...');
  
  final currentDir = Directory.current;
  await processDirectory(currentDir);
  
  print('✅ Documentation removal complete!');
  print('📊 Running dart format to clean up formatting...');
  
  // Format the code
  final formatResult = await Process.run('dart', ['format', '.']);
  if (formatResult.exitCode == 0) {
    print('✅ Formatting complete!');
  } else {
    print('⚠️  Formatting had issues: ${formatResult.stderr}');
  }
  
  print('🔍 Running dart analyze to check for issues...');
  
  // Analyze the code
  final analyzeResult = await Process.run('dart', ['analyze']);
  if (analyzeResult.exitCode == 0) {
    print('✅ No analysis issues!');
  } else {
    print('ℹ️  Analysis output: ${analyzeResult.stdout}');
  }
  
  print('🎉 All done! Inline documentation comments have been removed.');
}

Future<void> processDirectory(Directory dir) async {
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      // Skip generated files and hidden directories
      if (entity.path.contains('/.') || 
          entity.path.contains('.g.dart') || 
          entity.path.contains('.freezed.dart') ||
          entity.path.contains('.part.dart')) {
        continue;
      }
      
      await processFile(entity);
    }
  }
}

Future<void> processFile(File file) async {
  print('Processing: ${file.path}');
  
  try {
    final content = await file.readAsString();
    final lines = LineSplitter.split(content).toList();
    final processedLines = <String>[];
    
    bool inDocBlock = false;
    int consecutiveEmptyLines = 0;
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();
      
      // Check if this is a documentation line
      if (trimmed.startsWith('///')) {
        inDocBlock = true;
        continue; // Skip this line
      }
      
      // If we just exited a doc block and this is an empty line, skip excessive empty lines
      if (inDocBlock && trimmed.isEmpty) {
        inDocBlock = false;
        consecutiveEmptyLines++;
        if (consecutiveEmptyLines <= 1) {
          processedLines.add(line);
        }
        continue;
      }
      
      // Reset doc block flag if we hit non-empty, non-doc content
      if (trimmed.isNotEmpty) {
        inDocBlock = false;
        consecutiveEmptyLines = 0;
      }
      
      // Handle consecutive empty lines (limit to 2)
      if (trimmed.isEmpty) {
        consecutiveEmptyLines++;
        if (consecutiveEmptyLines <= 2) {
          processedLines.add(line);
        }
      } else {
        consecutiveEmptyLines = 0;
        processedLines.add(line);
      }
    }
    
    // Write the processed content back to the file
    final newContent = processedLines.join('\n');
    await file.writeAsString(newContent);
    
  } catch (e) {
    print('❌ Error processing ${file.path}: $e');
  }
}