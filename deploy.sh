#!/bin/bash

# ============================================
# Deploy Script - backend.tafooq.com
# ============================================

set -e

REPO="https://github.com/Ahmed-2020-98/test-backend-laravel-crud.git"
DIR="$HOME/domains/backend.tafooq.com/public_html"

echo "=============================="
echo " Starting Deployment..."
echo "=============================="

# Clone or pull latest code
if [ -d "$DIR/.git" ]; then
    echo "[1/7] Pulling latest code..."
    cd "$DIR"
    git pull origin main
else
    echo "[1/7] Cloning repository..."
    git clone "$REPO" "$DIR"
    cd "$DIR"
fi

# Install PHP dependencies
echo "[2/7] Installing Composer dependencies..."
composer install --optimize-autoloader --no-dev --quiet

# Upload .env (must be done manually before running this script)
if [ ! -f "$DIR/.env" ]; then
    echo "ERROR: .env file not found!"
    echo "Upload your .env file to $DIR/.env then run this script again."
    exit 1
fi

# Run database migrations
echo "[3/7] Running migrations..."
php artisan migrate --force

# Set storage permissions
echo "[4/7] Setting permissions..."
chmod -R 775 storage bootstrap/cache

# Clear and cache config
echo "[5/7] Caching config..."
php artisan config:cache

# Cache routes
echo "[6/7] Caching routes..."
php artisan route:cache

# Cache views
echo "[7/7] Caching views..."
php artisan view:cache

echo ""
echo "=============================="
echo " Deployment Complete!"
echo " Visit: https://backend.tafooq.com/api/students"
echo "=============================="
