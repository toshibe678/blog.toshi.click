#!/bin/bash

echo "Running documentation linters..."

# MarkdownファイルのLint
echo "Checking Markdown files..."
find . -type f -name "*.md" ! -path "./blog/*" -exec textlint {} +

# YAMLファイルのLint
echo "Checking YAML files..."
find . -type f \( -name "*.yml" -o -name "*.yaml" \) ! -path "./blog/*" -exec yamllint {} +

# 結果の確認
if [ $? -eq 0 ]; then
    echo "✅ All documentation files passed linting"
    exit 0
else
    echo "❌ Some files failed linting. Please check the errors above"
    exit 1
fi
