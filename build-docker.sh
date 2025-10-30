#!/bin/bash

echo "🔨 Zedule Docker Build Script"
echo "=============================="
echo ""

# Set build directory
BUILD_DIR="/c/Users/Pasindu Lakshitha/Videos/cal.com-main/cal.com-main"
cd "$BUILD_DIR" || exit 1

echo "📁 Working directory: $PWD"
echo ""

# Check Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

echo "✅ Docker is running"
echo ""

# Enable BuildKit for faster builds
export DOCKER_BUILDKIT=1

echo "🧹 Cleaning previous build artifacts..."
# Clean previous containers
docker-compose -f docker-compose.zedule.yml down -v 2>/dev/null || true

echo ""
echo "🏗️  Building Zedule Docker image..."
echo "This may take 15-25 minutes on first build..."
echo ""

# Build with docker-compose
docker-compose -f docker-compose.zedule.yml build --no-cache 2>&1 | tee build.log

BUILD_STATUS=$?

echo ""
if [ $BUILD_STATUS -eq 0 ]; then
    echo "✅ Build completed successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Update secrets in docker-compose.zedule.yml"
    echo "   - Generate with: openssl rand -base64 32"
    echo "2. Start services: docker-compose -f docker-compose.zedule.yml up -d"
    echo "3. View logs: docker-compose -f docker-compose.zedule.yml logs -f"
    echo "4. Access app: http://localhost:3000"
    echo ""
else
    echo "❌ Build failed! Check build.log for details."
    echo ""
    echo "Common fixes:"
    echo "1. Increase Docker memory to 8GB+"
    echo "2. Clear Docker cache: docker builder prune -a"
    echo "3. Check build.log for specific errors"
    echo ""
    exit 1
fi
