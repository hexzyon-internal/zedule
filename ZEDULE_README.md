# Zedule - Open Source Scheduling Platform

**Formerly Cal.com** - Rebranded and modified for open-source use without licensing restrictions.

## What Changed

### License Enforcement Removed
- ✅ **No license wizard** during setup
- ✅ **All enterprise features accessible** without restrictions
- ✅ **No license key required**
- ✅ **LicenseRequired component bypassed**

### Rebranding
- Changed from **Cal.com** to **Zedule**
- Updated all branding constants (`APP_NAME`, `COMPANY_NAME`, etc.)
- Modified URLs to point to Zedule domains
- All features marked as self-hosted with full capabilities

## Quick Start

### Prerequisites
- Node.js >= 18.x
- PostgreSQL >= 13.x
- Yarn (recommended)

### Local Development

1. **Install dependencies**:
   ```bash
   yarn install
   ```

2. **Setup environment**:
   ```bash
   cp .env.example .env
   ```

3. **Generate secrets**:
   ```bash
   openssl rand -base64 32 # Add to NEXTAUTH_SECRET
   openssl rand -base64 32 # Add to CALENDSO_ENCRYPTION_KEY
   ```

4. **Setup database**:
   ```bash
   # Start local postgres with Docker
   yarn dx
   ```

   Or manually:
   ```bash
   # Update DATABASE_URL in .env with your Postgres connection string
   yarn prisma db push
   yarn db-seed
   ```

5. **Start development server**:
   ```bash
   yarn dev
   ```

   Visit: http://localhost:3000

### Building for Production

```bash
# Build the app
yarn build

# Start production server
yarn start
```

## Docker Deployment

### Build Docker Image

```bash
# From the docker-main directory
docker-compose up -d
```

Or build custom image:

```bash
cd cal.com-main
docker build -t zedule:latest -f ../docker-main/Dockerfile .
```

### Run Docker Container

```bash
docker run -d \
  -p 3000:3000 \
  -e DATABASE_URL="postgresql://user:pass@host:5432/zedule" \
  -e NEXTAUTH_SECRET="your-secret" \
  -e CALENDSO_ENCRYPTION_KEY="your-encryption-key" \
  zedule:latest
```

## Key Changes Made

### Files Modified

1. **License Enforcement Removed**:
   - `/packages/features/ee/common/components/LicenseRequired.tsx` - Bypassed all checks
   - `/packages/features/ee/common/server/LicenseKeyService.ts` - Always returns true
   - `/apps/web/modules/auth/setup-view.tsx` - Removed license selection step

2. **Branding Updated**:
   - `/packages/lib/constants.ts` - Updated APP_NAME, COMPANY_NAME, URLs
   - `/package.json` - Updated monorepo name

3. **Feature Flags**:
   - `HOSTED_CAL_FEATURES` = true (all features enabled)
   - `IS_SELF_HOSTED` = true  
   - `IS_CALCOM` = false

## Features Available

All features that were previously enterprise-only are now available:
- ✅ Advanced workflows
- ✅ Team features
- ✅ Organization features
- ✅ Custom integrations
- ✅ API access
- ✅ Webhooks
- ✅ All app store integrations

## Environment Variables

Key variables you should set in `.env`:

```bash
# Database
DATABASE_URL="postgresql://..."

# Authentication
NEXTAUTH_SECRET="..."
NEXTAUTH_URL="http://localhost:3000"

# Encryption
CALENDSO_ENCRYPTION_KEY="..."

# App Configuration
NEXT_PUBLIC_WEBAPP_URL="http://localhost:3000"
NEXT_PUBLIC_APP_NAME="Zedule"

# Optional: Email, integrations, etc.
```

## Development Tips

1. **Increase Node memory** (for large builds):
   ```bash
   export NODE_OPTIONS="--max-old-space-size=16384"
   ```

2. **Enable detailed logging**:
   ```bash
   echo 'NEXT_PUBLIC_LOGGER_LEVEL=3' >> .env
   ```

3. **Reset database**:
   ```bash
   yarn prisma db push --force-reset
   yarn db-seed
   ```

## Testing

```bash
# Unit tests
yarn test

# E2E tests
yarn test-e2e

# Type checking
yarn type-check

# Linting
yarn lint
```

## Production Deployment

For production deployment:

1. Set proper environment variables
2. Use a managed PostgreSQL instance
3. Configure email provider (SendGrid, etc.)
4. Setup OAuth providers as needed
5. Configure reverse proxy (nginx/Apache)
6. Enable SSL/TLS

## Support

This is a community-maintained fork focused on providing a fully open-source scheduling solution without licensing restrictions.

## License

This project maintains the original AGPLv3 license but removes all enterprise licensing requirements and gating.

---

**Built on the solid foundation of Cal.com** 🙏
