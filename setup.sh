#!/usr/bin/env bash

# 🏥 GRACE CLINIC - STARTUP SCRIPT
# Quick setup and launch for Windows/Mac/Linux

echo ""
echo "╔════════════════════════════════════════╗"
echo "║   🏥 GRACE CLINIC - STARTUP HELPER     ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}→${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

echo ""
print_step "Checking prerequisites..."
echo ""

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_success "Node.js installed: $NODE_VERSION"
else
    print_error "Node.js not found. Please install from https://nodejs.org"
    exit 1
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    print_success "npm installed: $NPM_VERSION"
else
    print_error "npm not found. Please install Node.js"
    exit 1
fi

# Check MySQL
if command -v mysql &> /dev/null; then
    MYSQL_VERSION=$(mysql --version)
    print_success "MySQL installed: $MYSQL_VERSION"
else
    print_warning "MySQL not found. You can install it later or use cloud MySQL"
fi

echo ""
print_step "Setting up backend..."
echo ""

# Check if server directory exists
if [ ! -d "server" ]; then
    print_error "server/ directory not found!"
    exit 1
fi

# Navigate to server directory
cd server

# Check if package.json exists
if [ ! -f "package.json" ]; then
    print_error "package.json not found in server/"
    exit 1
fi

# Install dependencies
print_step "Installing Node.js dependencies..."
npm install

if [ $? -eq 0 ]; then
    print_success "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Check .env file
if [ ! -f ".env" ]; then
    print_warning ".env file not found"
    if [ -f ".env.example" ]; then
        print_step "Creating .env from .env.example..."
        cp .env.example .env
        print_success ".env file created"
        print_warning "⚠ IMPORTANT: Edit .env file with your MySQL credentials!"
    fi
else
    print_success ".env file found"
fi

echo ""
print_success "Setup complete!"
echo ""
echo "╔════════════════════════════════════════╗"
echo "║    📋 NEXT STEPS                       ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "1️⃣  Configure database:"
echo "   • Edit server/.env with MySQL credentials"
echo "   • Run: mysql -u root -p < database/schema.sql"
echo ""
echo "2️⃣  Start backend server:"
echo "   • Run: npm start"
echo "   • Keep this terminal open"
echo ""
echo "3️⃣  Open frontend:"
echo "   • Open client/index.html in browser"
echo "   • Or use VS Code Live Server"
echo ""
echo "4️⃣  Test appointment booking"
echo ""
echo "5️⃣  View admin dashboard:"
echo "   • Open admin/dashboard.html"
echo ""
echo "📚 Documentation:"
echo "   • QUICK_START.md - Fast setup"
echo "   • README.md - Complete info"
echo "   • API_DOCS.md - API reference"
echo ""
echo "🎨 Customize:"
echo "   • Edit DEPLOYMENT.md for customization guide"
echo ""
echo "🚀 Ready to deploy?"
echo "   • See DEPLOYMENT.md for hosting options"
echo ""
echo "╔════════════════════════════════════════╗"
echo "║    Happy coding! 🎉                    ║"
echo "╚════════════════════════════════════════╝"
echo ""
