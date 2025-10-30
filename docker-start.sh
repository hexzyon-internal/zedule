#!/bin/bash
set -e

echo "🚀 Starting Zedule..."

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo "❌ ERROR: DATABASE_URL is not set"
    exit 1
fi

# Check if NEXTAUTH_SECRET is set
if [ -z "$NEXTAUTH_SECRET" ] || [ "$NEXTAUTH_SECRET" = "secret" ]; then
    echo "⚠️  WARNING: NEXTAUTH_SECRET is not set or using default value"
fi

# Check if CALENDSO_ENCRYPTION_KEY is set
if [ -z "$CALENDSO_ENCRYPTION_KEY" ] || [ "$CALENDSO_ENCRYPTION_KEY" = "secret" ]; then
    echo "⚠️  WARNING: CALENDSO_ENCRYPTION_KEY is not set or using default value"
fi

# Run database migrations
echo "📦 Running database migrations..."
cd /app
yarn workspace @calcom/prisma prisma migrate deploy || {
    echo "⚠️  Migration failed, attempting to push schema..."
    yarn workspace @calcom/prisma prisma db push --skip-generate
}

echo "✅ Database ready"

# Start the application
echo "🎉 Starting Zedule application..."

# Check if build exists
if [ ! -d "/app/apps/web/.next" ]; then
    echo "❌ Error: .next build directory not found"
    exit 1
fi

if [ ! -f "/app/apps/web/.next/BUILD_ID" ]; then
    echo "❌ Error: BUILD_ID not found in .next directory"
    exit 1
fi

echo "Starting Next.js production server..."
cd /app/apps/web
NODE_ENV=production /app/node_modules/.bin/next start
