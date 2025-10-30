#!/bin/bash

echo "🧪 Testing Zedule Docker Build Prerequisites"
echo "============================================="
echo ""

# Check if we're in the right directory
if [ ! -f "Dockerfile.zedule" ]; then
    echo "❌ Error: Dockerfile.zedule not found"
    echo "Please run this script from: /c/Users/Pasindu Lakshitha/Videos/cal.com-main/cal.com-main"
    exit 1
fi

echo "✅ Dockerfile.zedule found"

# Check required files
REQUIRED_FILES=(
    "package.json"
    "yarn.lock"
    ".yarnrc.yml"
    "turbo.json"
    "i18n.json"
    "docker-compose.zedule.yml"
    "docker-start.sh"
)

echo ""
echo "Checking required files..."
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file - MISSING!"
        exit 1
    fi
done

# Check required directories
REQUIRED_DIRS=(
    ".yarn"
    "apps/web"
    "apps/api/v2"
    "packages"
    "scripts"
)

echo ""
echo "Checking required directories..."
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✅ $dir"
    else
        echo "  ❌ $dir - MISSING!"
        exit 1
    fi
done

# Check Docker
echo ""
echo "Checking Docker..."
if docker info > /dev/null 2>&1; then
    echo "✅ Docker is running"
    echo "   Version: $(docker --version)"
else
    echo "❌ Docker is not running"
    echo "   Please start Docker Desktop"
    exit 1
fi

# Check Docker Compose
if docker-compose --version > /dev/null 2>&1; then
    echo "✅ Docker Compose is available"
    echo "   Version: $(docker-compose --version)"
else
    echo "❌ Docker Compose not found"
    exit 1
fi

# Check .dockerignore
if [ -f ".dockerignore" ]; then
    echo "✅ .dockerignore found"
else
    echo "⚠️  .dockerignore not found (optional but recommended)"
fi

echo ""
echo "========================================="
echo "✅ All prerequisites met!"
echo ""
echo "You can now build with:"
echo "  docker-compose -f docker-compose.zedule.yml build"
echo ""
echo "Or use the automated script:"
echo "  ./build-docker.sh"
echo ""
