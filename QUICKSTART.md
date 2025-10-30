# Zedule Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Option 1: Local Development (Recommended for Development)

```bash
# Navigate to project
cd cal.com-main/cal.com-main

# Run setup script
chmod +x setup-zedule.sh
./setup-zedule.sh

# Install dependencies
yarn install

# Start with local database (Docker required)
yarn dx

# Open browser to http://localhost:3000
```

### Option 2: Docker Deployment (Recommended for Production)

```bash
# Navigate to project
cd cal.com-main/cal.com-main

# Update secrets in docker-compose.zedule.yml
# Generate secrets with: openssl rand -base64 32

# Start services
docker-compose -f docker-compose.zedule.yml up -d

# View logs
docker-compose -f docker-compose.zedule.yml logs -f zedule

# Open browser to http://localhost:3000
```

### Option 3: Manual Setup

```bash
cd cal.com-main/cal.com-main

# Create .env file
cp .env.example .env

# Generate and add secrets
echo "NEXTAUTH_SECRET=$(openssl rand -base64 32)" >> .env
echo "CALENDSO_ENCRYPTION_KEY=$(openssl rand -base64 32)" >> .env

# Add database URL
echo 'DATABASE_URL="postgresql://user:pass@localhost:5432/zedule"' >> .env

# Install and setup
yarn install
yarn prisma db push
yarn db-seed

# Start development server
yarn dev
```

## ⚙️ Environment Variables (Minimal)

```bash
# Required
DATABASE_URL="postgresql://user:pass@localhost:5432/zedule"
NEXTAUTH_SECRET="your-generated-secret"
CALENDSO_ENCRYPTION_KEY="your-generated-secret"

# Recommended  
NEXT_PUBLIC_WEBAPP_URL="http://localhost:3000"
NEXTAUTH_URL="http://localhost:3000"
NEXT_PUBLIC_APP_NAME="Zedule"
```

## 🎯 First Login

1. Visit `http://localhost:3000`
2. Complete setup wizard:
   - Create admin user ✅
   - Configure apps (optional) ✅
   - **No license step!** 🎉
3. Start using all features!

## 🐳 Docker Commands Cheat Sheet

```bash
# Start services
docker-compose -f docker-compose.zedule.yml up -d

# Stop services
docker-compose -f docker-compose.zedule.yml down

# View logs
docker-compose -f docker-compose.zedule.yml logs -f

# Restart app only
docker-compose -f docker-compose.zedule.yml restart zedule

# Rebuild after changes
docker-compose -f docker-compose.zedule.yml up -d --build

# Remove everything (including data)
docker-compose -f docker-compose.zedule.yml down -v
```

## 🛠️ Common Tasks

### Reset Database
```bash
yarn prisma db push --force-reset
yarn db-seed
```

### Run Tests
```bash
yarn test              # Unit tests
yarn test-e2e          # E2E tests
yarn lint              # Linting
yarn type-check        # Type checking
```

### Build for Production
```bash
yarn build
yarn start
```

## 📊 Verify Installation

Check these after setup:

1. ✅ App loads at http://localhost:3000
2. ✅ No license selection during setup
3. ✅ Can create admin user
4. ✅ Dashboard accessible
5. ✅ All features visible (no "Enterprise" locks)

## ❓ Troubleshooting

**Port 3000 already in use?**
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9
# Or use different port
NEXT_PUBLIC_WEBAPP_URL=http://localhost:3001 yarn dev
```

**Database connection failed?**
```bash
# Check PostgreSQL is running
pg_isready
# Or use Docker
yarn dx
```

**Build errors?**
```bash
# Increase Node memory
export NODE_OPTIONS="--max-old-space-size=8192"
yarn build
```

## 📚 More Information

- Full setup guide: See `ZEDULE_README.md`
- All modifications: See `MODIFICATIONS_SUMMARY.md`
- Docker deployment: See `docker-compose.zedule.yml`

## 🎉 What's Different from Cal.com?

- ✅ **No license required** - All features free
- ✅ **No setup wizard license step** - Faster onboarding
- ✅ **All enterprise features unlocked** - Full functionality
- ✅ **Rebranded to Zedule** - Your own scheduling platform

---

**Need help?** Check the full documentation in ZEDULE_README.md
