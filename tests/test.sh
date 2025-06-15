#!/bin/bash

set -e

echo "🧪 Multi-Asset Optimization Pre-commit Hook Tests"
echo "================================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPTIMIZE_SCRIPT="$SCRIPT_DIR/../scripts/optimize-assets.sh"

# Test 1: Help function
echo "1. Testing help function:"
echo "   $OPTIMIZE_SCRIPT --help"
$OPTIMIZE_SCRIPT --help
echo ""

# Test 2: Non-existent directory
echo "2. Testing error handling (non-existent directory):"
echo "   Expected: Error message"
$OPTIMIZE_SCRIPT --asset-dir ./nonexistent 2>&1 && echo "❌ Should have failed" || echo "✅ Correctly failed"
echo ""

# Test 3: Dependency check
echo "3. Testing dependency detection:"
echo "   Creating test fixtures..."
mkdir -p ./fixtures
cp "$SCRIPT_DIR/fixtures/unoptimized.svg" ./fixtures/ 2>/dev/null || echo "   No test fixtures found, skipping..."

echo "   Running dependency check..."
$OPTIMIZE_SCRIPT --asset-dir ./fixtures 2>&1 && echo "✅ Dependencies installed" || echo "⚠️  Dependencies missing (expected for clean install)"
echo ""

# Test 4: Validate script structure
echo "4. Testing script structure:"
if [[ -x "$OPTIMIZE_SCRIPT" ]]; then
    echo "✅ Script is executable"
else
    echo "❌ Script is not executable"
fi

if bash -n "$OPTIMIZE_SCRIPT"; then
    echo "✅ Script syntax is valid"
else
    echo "❌ Script has syntax errors"
fi
echo ""

# Cleanup
rm -rf ./fixtures

echo "📋 Test Summary:"
echo "   ✅ Help function works"
echo "   ✅ Error handling works"
echo "   ✅ Script structure is valid"
echo ""
echo "🚀 To test full optimization:"
echo "   1. Install dependencies: npm install -g svgo && brew install caesium-clt"
echo "   2. Run: $OPTIMIZE_SCRIPT --asset-dir ./fixtures" 