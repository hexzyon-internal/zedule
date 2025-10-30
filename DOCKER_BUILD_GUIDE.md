# Zedule Docker Build Guide

## Prerequisites

- Docker installed and running
- Docker Compose installed
- At least 8GB RAM allocated to Docker
- At least 20GB free disk space

## Quick Build

### Option 1: Using Docker Compose (Recommended)

```bash
cd /c/Users/Pasindu\ Lakshitha/Videos/cal.com-main/cal.com-main

# Build and start all services
docker-compose -f docker-compose.zedule.yml up -d --build

# View logs
docker-compose -f docker-compose.zedule.yml logs -f
```

### Option 2: Build Docker Image Only

```bash
cd /c/Users/Pasindu\ Lakshitha/Videos/cal.com-main/cal.com-main

# Build the image
docker build -f Dockerfile.zedule -t zedule:latest .

# Run the container (requires external PostgreSQL)
docker run -d \
  -p 3000:3000 \
  -e DATABASE_URL="postgresql://user:pass@host:5432/zedule" \
  -e NEXTAUTH_SECRET="$(openssl rand -base64 32)" \
  -e CALENDSO_ENCRYPTION_KEY="$(openssl rand -base64 32)" \
  -e NEXT_PUBLIC_WEBAPP_URL="http://localhost:3000" \
  zedule:latest
```

## Build with Custom Configuration

### Build Arguments

You can pass build arguments to customize the build:

```bash
docker build -f Dockerfile.zedule \
  --build-arg MAX_OLD_SPACE_SIZE=8192 \
  --build-arg NEXT_PUBLIC_WEBAPP_URL=http://localhost:3000 \
  --build-arg DATABASE_URL=postgresql://... \
  -t zedule:latest .
```

### Available Build Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `DATABASE_URL` | - | PostgreSQL connection string |
| `NEXTAUTH_SECRET` | secret | NextAuth.js secret (change in production!) |
| `CALENDSO_ENCRYPTION_KEY` | secret | Encryption key (change in production!) |
| `MAX_OLD_SPACE_SIZE` | 4096 | Node.js memory limit (MB) |
| `NEXT_PUBLIC_WEBAPP_URL` | http://WEBAPP_URL_PLACEHOLDER | Your app URL |

## Environment Variables at Runtime

These must be set when running the container:

```bash
# Required
DATABASE_URL=postgresql://user:pass@host:5432/zedule
NEXTAUTH_SECRET=your-secure-secret-here
CALENDSO_ENCRYPTION_KEY=your-secure-key-here

# Recommended
NEXT_PUBLIC_WEBAPP_URL=http://localhost:3000
NEXTAUTH_URL=http://localhost:3000
NEXT_PUBLIC_APP_NAME=Zedule
```

## Troubleshooting

### Issue: "COPY prisma ./prisma: not found"

**Cause**: The Dockerfile was trying to copy a non-existent directory.

**Solution**: Fixed in latest Dockerfile.zedule - prisma files are in `packages/prisma`

### Issue: Build runs out of memory

**Symptoms**: Build fails with "JavaScript heap out of memory"

**Solutions**:

1. Increase Docker memory:
   - Docker Desktop → Settings → Resources → Memory → Set to 8GB+

2. Increase Node memory in build:
   ```bash
   docker build -f Dockerfile.zedule \
     --build-arg MAX_OLD_SPACE_SIZE=8192 \
     -t zedule:latest .
   ```

3. Clear Docker cache and rebuild:
   ```bash
   docker builder prune -a
   docker build --no-cache -f Dockerfile.zedule -t zedule:latest .
   ```

### Issue: Build is very slow

**Solutions**:

1. Use BuildKit for faster builds:
   ```bash
   export DOCKER_BUILDKIT=1
   docker build -f Dockerfile.zedule -t zedule:latest .
   ```

2. Clean up build context:
   ```bash
   # Remove node_modules before building
   find . -name "node_modules" -type d -prune -exec rm -rf {} \;
   docker build -f Dockerfile.zedule -t zedule:latest .
   ```

### Issue: "version is obsolete" warning

**Cause**: Docker Compose v2 format change

**Solution**: This is just a warning and can be ignored, or remove the `version:` line from docker-compose.zedule.yml

### Issue: Permission denied errors

**On Windows/Git Bash**:
```bash
# Make scripts executable
chmod +x docker-start.sh
chmod +x setup-zedule.sh
chmod +x scripts/*.sh
```

### Issue: Container starts but app doesn't work

**Check logs**:
```bash
docker-compose -f docker-compose.zedule.yml logs -f zedule
```

**Common causes**:
1. Database not ready - wait 30 seconds and check again
2. Missing environment variables - check all required vars are set
3. Database migrations failed - check logs for migration errors

**Fix database issues**:
```bash
# Access container shell
docker-compose -f docker-compose.zedule.yml exec zedule bash

# Run migrations manually
yarn workspace @calcom/prisma prisma migrate deploy

# Or push schema
yarn workspace @calcom/prisma prisma db push
```

### Issue: Port 3000 already in use

**Solution**: Change port mapping:
```bash
# In docker-compose.zedule.yml, change:
ports:
  - "3001:3000"  # Use 3001 on host

# Then access at http://localhost:3001
```

## Build Optimization Tips

### 1. Multi-stage Build

The Dockerfile uses 3 stages for optimal size:
- **builder**: Installs deps and builds
- **builder-two**: Prepares production files
- **runner**: Final minimal runtime image

### 2. Layer Caching

Files are copied in order of change frequency:
1. Package files (changes rarely)
2. Source code (changes often)
3. Build artifacts

### 3. .dockerignore

Reduces build context size by excluding:
- node_modules
- .git
- Test files
- Documentation

## Production Deployment

### Recommended Setup

```bash
# 1. Build image
docker build -f Dockerfile.zedule -t zedule:v1.0.0 .

# 2. Tag for registry
docker tag zedule:v1.0.0 your-registry.com/zedule:v1.0.0

# 3. Push to registry
docker push your-registry.com/zedule:v1.0.0

# 4. Deploy on server
docker run -d \
  --name zedule \
  --restart unless-stopped \
  -p 3000:3000 \
  -e DATABASE_URL="postgresql://..." \
  -e NEXTAUTH_SECRET="..." \
  -e CALENDSO_ENCRYPTION_KEY="..." \
  -e NEXT_PUBLIC_WEBAPP_URL="https://your-domain.com" \
  -e NEXTAUTH_URL="https://your-domain.com" \
  your-registry.com/zedule:v1.0.0
```

### Health Check

The container includes a health check:
```bash
# Check container health
docker ps
# Look for "healthy" status

# Manual health check
curl http://localhost:3000
```

## Complete Example: Fresh Build

```bash
#!/bin/bash

# Navigate to project
cd "/c/Users/Pasindu Lakshitha/Videos/cal.com-main/cal.com-main"

# Clean previous builds
docker-compose -f docker-compose.zedule.yml down -v
docker builder prune -f

# Generate secrets
export NEXTAUTH_SECRET=$(openssl rand -base64 32)
export CALENDSO_KEY=$(openssl rand -base64 32)

# Update docker-compose.zedule.yml with secrets
# Or pass as environment variables

# Build and start
export DOCKER_BUILDKIT=1
docker-compose -f docker-compose.zedule.yml up -d --build

# Wait for services to be ready
echo "Waiting for services to start..."
sleep 30

# Check logs
docker-compose -f docker-compose.zedule.yml logs --tail=50 zedule

# Test
curl http://localhost:3000

echo "✅ Zedule should now be running at http://localhost:3000"
```

## Performance Benchmarks

### Build Time (typical)
- First build: 15-25 minutes
- Cached rebuild: 2-5 minutes
- With BuildKit: 10-15 minutes (first) / 1-2 minutes (cached)

### Image Size
- Final image: ~1.5GB (node:18 based)
- Build cache: ~3-4GB

### Resource Usage (running)
- Memory: 500MB-1GB
- CPU: 0.5-1 core (idle)
- Disk: 1.5GB

## Next Steps

After successful build:

1. Access http://localhost:3000
2. Complete setup wizard (no license required!)
3. Create admin user
4. Configure integrations
5. Start scheduling!

For production deployment, see `ZEDULE_README.md`

---

**Need help?** Check the logs first, then see `QUICKSTART.md` and `MODIFICATIONS_SUMMARY.md`
