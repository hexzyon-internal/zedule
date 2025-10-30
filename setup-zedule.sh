#!/bin/bash

echo "🔧 Zedule Setup Script"
echo "======================"
echo ""

# Check if .env exists
if [ -f ".env" ]; then
    echo "⚠️  .env file already exists. Backup will be created as .env.backup"
    cp .env .env.backup
fi

# Copy example env
echo "📝 Creating .env file from .env.example..."
cp .env.example .env

# Generate secrets
echo "🔐 Generating secure secrets..."
NEXTAUTH_SECRET=$(openssl rand -base64 32)
CALENDSO_ENCRYPTION_KEY=$(openssl rand -base64 32)

# Update .env file
echo "✍️  Updating .env file with generated secrets..."

# For Unix-like systems
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s|NEXTAUTH_SECRET=.*|NEXTAUTH_SECRET=\"$NEXTAUTH_SECRET\"|" .env
    sed -i '' "s|CALENDSO_ENCRYPTION_KEY=.*|CALENDSO_ENCRYPTION_KEY=\"$CALENDSO_ENCRYPTION_KEY\"|" .env
    sed -i '' "s|NEXT_PUBLIC_APP_NAME=.*|NEXT_PUBLIC_APP_NAME=\"Zedule\"|" .env
else
    # Linux
    sed -i "s|NEXTAUTH_SECRET=.*|NEXTAUTH_SECRET=\"$NEXTAUTH_SECRET\"|" .env
    sed -i "s|CALENDSO_ENCRYPTION_KEY=.*|CALENDSO_ENCRYPTION_KEY=\"$CALENDSO_ENCRYPTION_KEY\"|" .env
    sed -i "s|NEXT_PUBLIC_APP_NAME=.*|NEXT_PUBLIC_APP_NAME=\"Zedule\"|" .env
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Review and update .env file with your database connection"
echo "2. Run: yarn install"
echo "3. Run: yarn dx (to start local dev with Docker DB)"
echo "   OR"
echo "   Run: yarn prisma db push && yarn db-seed (if you have your own DB)"
echo "4. Run: yarn dev (to start development server)"
echo ""
echo "🐳 For Docker deployment:"
echo "   docker-compose -f docker-compose.zedule.yml up -d"
echo ""
echo "📖 See ZEDULE_README.md for more information"
echo ""
