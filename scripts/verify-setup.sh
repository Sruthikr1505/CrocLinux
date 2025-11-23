#!/usr/bin/env bash
# Verify CrocLinux setup - Ensure everything works like Kali Linux

set -euo pipefail

echo "🐊 CrocLinux Setup Verification"
echo "=============================="
echo ""

ERRORS=0
WARNINGS=0

# Check build scripts
echo "[+] Checking build scripts..."
if [[ -f "scripts/build/build_iso_variant.sh" ]]; then
    echo "  ✅ ISO build script found"
    if [[ -x "scripts/build/build_iso_variant.sh" ]]; then
        echo "  ✅ ISO build script is executable"
    else
        echo "  ⚠️  ISO build script not executable (run: chmod +x scripts/build/build_iso_variant.sh)"
        ((WARNINGS++))
    fi
else
    echo "  ❌ ISO build script missing"
    ((ERRORS++))
fi

if [[ -f "scripts/build/build_vm_images.sh" ]]; then
    echo "  ✅ VM image build script found"
    if [[ -x "scripts/build/build_vm_images.sh" ]]; then
        echo "  ✅ VM image build script is executable"
    else
        echo "  ⚠️  VM image build script not executable"
        ((WARNINGS++))
    fi
else
    echo "  ❌ VM image build script missing"
    ((ERRORS++))
fi

# Check GitHub Actions workflow
echo ""
echo "[+] Checking GitHub Actions workflow..."
if [[ -f ".github/workflows/build-iso.yml" ]]; then
    echo "  ✅ GitHub Actions workflow found"
else
    echo "  ❌ GitHub Actions workflow missing"
    ((ERRORS++))
fi

# Check package lists
echo ""
echo "[+] Checking package lists..."
if [[ -f "build/iso/config/package-lists/croclinux-full.list.chroot" ]]; then
    echo "  ✅ Full package list found"
    PACKAGE_COUNT=$(grep -v '^#' build/iso/config/package-lists/croclinux-full.list.chroot | grep -v '^$' | wc -l)
    echo "  ✅ Found $PACKAGE_COUNT packages"
else
    echo "  ❌ Full package list missing"
    ((ERRORS++))
fi

if [[ -f "build/iso/config/package-lists/croclinux-mini.list.chroot" ]]; then
    echo "  ✅ Mini package list found"
else
    echo "  ❌ Mini package list missing"
    ((ERRORS++))
fi

# Check theme files
echo ""
echo "[+] Checking theme files..."
if [[ -d "build/iso/config/includes.chroot/usr/share/themes/CrocLinux-Hacker" ]]; then
    echo "  ✅ Hacker theme found"
else
    echo "  ⚠️  Hacker theme directory missing"
    ((WARNINGS++))
fi

if [[ -d "build/iso/config/includes.chroot/usr/share/themes/CrocLinux" ]]; then
    echo "  ✅ Dark theme found"
else
    echo "  ⚠️  Dark theme directory missing"
    ((WARNINGS++))
fi

# Check desktop entries
echo ""
echo "[+] Checking desktop entries..."
DESKTOP_COUNT=$(find build/iso/config/includes.chroot/usr/share/applications -name "croclinux-*.desktop" 2>/dev/null | wc -l)
if [[ $DESKTOP_COUNT -gt 0 ]]; then
    echo "  ✅ Found $DESKTOP_COUNT desktop entries"
else
    echo "  ⚠️  No desktop entries found"
    ((WARNINGS++))
fi

# Check documentation
echo ""
echo "[+] Checking documentation..."
DOCS=(
    "docs/download-guide.md"
    "docs/install-guide.md"
    "docs/usage-guide.md"
    "docs/theme-guide.md"
    "docs/publishing-guide.md"
    "docs/build-instructions.md"
    "docs/project-concept.md"
    "docs/blue-team-enhancements.md"
    "docs/kali-linux-compatibility.md"
)

DOC_COUNT=0
for doc in "${DOCS[@]}"; do
    if [[ -f "$doc" ]]; then
        ((DOC_COUNT++))
    fi
done

echo "  ✅ Found $DOC_COUNT/${#DOCS[@]} documentation files"

# Check scripts
echo ""
echo "[+] Checking configuration scripts..."
SCRIPTS=(
    "scripts/base/prepare_system.sh"
    "scripts/base/hardening.sh"
    "scripts/base/configure_theme.sh"
    "scripts/services/install_blue_team_stack.sh"
    "scripts/automation/setup_integrations.sh"
)

SCRIPT_COUNT=0
for script in "${SCRIPTS[@]}"; do
    if [[ -f "$script" ]]; then
        ((SCRIPT_COUNT++))
        if [[ -x "$script" ]]; then
            echo "  ✅ $(basename $script) found and executable"
        else
            echo "  ⚠️  $(basename $script) found but not executable"
            ((WARNINGS++))
        fi
    else
        echo "  ❌ $(basename $script) missing"
        ((ERRORS++))
    fi
done

# Check Docker Compose
echo ""
echo "[+] Checking Docker Compose..."
if [[ -f "docker/docker-compose.yml" ]]; then
    echo "  ✅ Docker Compose file found"
else
    echo "  ⚠️  Docker Compose file missing"
    ((WARNINGS++))
fi

# Summary
echo ""
echo "=============================="
echo "Verification Summary"
echo "=============================="
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
    echo "✅ All checks passed! CrocLinux is ready to build."
    exit 0
elif [[ $ERRORS -eq 0 ]]; then
    echo "⚠️  Some warnings found, but setup is functional."
    exit 0
else
    echo "❌ Errors found. Please fix before building."
    exit 1
fi

