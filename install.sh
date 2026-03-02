#!/bin/bash

# Claude Security Audit Installer
# Usage (remote):    curl -fsSL https://raw.githubusercontent.com/afiqiqmal/claude-security-audit/main/install.sh | bash
# Usage (local):     bash install.sh
# Usage (uninstall): bash install.sh --uninstall

set -e

# Uninstall mode
if [ "${1:-}" = "--uninstall" ]; then
    echo ""
    echo "Claude Security Audit Uninstaller"
    echo "================================="
    echo ""
    COMMANDS_DIR="$HOME/.claude/commands"
    REFERENCES_DIR="$HOME/.claude/security-audit-references"
    CUSTOM_DIR="$HOME/.claude/security-audit-custom"
    GUIDELINES_DIR="$HOME/.claude"

    REMOVED=0
    for target in "$COMMANDS_DIR/security-audit.md" "$REFERENCES_DIR" "$CUSTOM_DIR" "$GUIDELINES_DIR/security-audit-guidelines.md"; do
        if [ -e "$target" ]; then
            rm -rf "$target"
            echo "  Removed $target"
            REMOVED=$((REMOVED + 1))
        fi
    done

    if [ $REMOVED -eq 0 ]; then
        echo "  Nothing to remove (not installed)"
    else
        echo ""
        echo "Uninstalled $REMOVED item(s). Done."
    fi
    echo ""
    exit 0
fi

echo ""
echo "Claude Security Audit Installer"
echo "================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Detect installation method
if [ -d ".git" ] && [ -f ".claude/commands/security-audit.md" ]; then
    INSTALL_MODE="local"
    REPO_DIR="$(pwd)"
    echo -e "${BLUE}Installing from local repository${NC}"
else
    INSTALL_MODE="remote"
    REPO_URL="https://raw.githubusercontent.com/afiqiqmal/claude-security-audit/main"
    echo -e "${BLUE}Installing from remote repository${NC}"
fi

echo ""

# Destinations
COMMANDS_DIR="$HOME/.claude/commands"
REFERENCES_DIR="$HOME/.claude/security-audit-references"
GUIDELINES_DIR="$HOME/.claude"

# Create directories
for dir in "$COMMANDS_DIR" "$REFERENCES_DIR"; do
    if [ ! -d "$dir" ]; then
        echo -e "${YELLOW}Creating $dir${NC}"
        mkdir -p "$dir"
    fi
done

# Install helper
install_file() {
    local source_path=$1
    local dest_path=$2

    mkdir -p "$(dirname "$dest_path")"

    if [ "$INSTALL_MODE" = "local" ]; then
        cp "$REPO_DIR/$source_path" "$dest_path"
    else
        if ! curl -fsSL "$REPO_URL/$source_path" -o "$dest_path"; then
            echo -e "  ${RED}Failed to download $source_path${NC}" >&2
            return 1
        fi
    fi

    [ -f "$dest_path" ]
}

INSTALLED=0
FAILED=0

echo "Installing files..."
echo ""

# Install slash command
if install_file ".claude/commands/security-audit.md" "$COMMANDS_DIR/security-audit.md"; then
    echo -e "  ${GREEN}✓${NC} /security-audit command"
    INSTALLED=$((INSTALLED + 1))
else
    echo -e "  ${RED}✗${NC} /security-audit command"
    FAILED=$((FAILED + 1))
fi

# Install reference files
if install_file "references/attack-vectors.md" "$REFERENCES_DIR/attack-vectors.md"; then
    echo -e "  ${GREEN}✓${NC} attack-vectors.md reference"
    INSTALLED=$((INSTALLED + 1))
else
    echo -e "  ${RED}✗${NC} attack-vectors.md reference"
    FAILED=$((FAILED + 1))
fi

if install_file "references/nist-csf-mapping.md" "$REFERENCES_DIR/nist-csf-mapping.md"; then
    echo -e "  ${GREEN}✓${NC} nist-csf-mapping.md reference"
    INSTALLED=$((INSTALLED + 1))
else
    echo -e "  ${RED}✗${NC} nist-csf-mapping.md reference"
    FAILED=$((FAILED + 1))
fi

if install_file "references/compliance-mapping.md" "$REFERENCES_DIR/compliance-mapping.md"; then
    echo -e "  ${GREEN}✓${NC} compliance-mapping.md reference"
    INSTALLED=$((INSTALLED + 1))
else
    echo -e "  ${RED}✗${NC} compliance-mapping.md reference"
    FAILED=$((FAILED + 1))
fi

# Install features-extended reference
if install_file "references/features-extended.md" "$REFERENCES_DIR/features-extended.md"; then
    echo -e "  ${GREEN}✓${NC} features-extended.md reference"
    INSTALLED=$((INSTALLED + 1))
else
    echo -e "  ${RED}✗${NC} features-extended.md reference"
    FAILED=$((FAILED + 1))
fi

# Install compliance pack files
PACKS="hipaa gdpr fintech saas-multi-tenant soc2 education"
PACK_FAILED=0
PACK_INSTALLED=0

for pack in $PACKS; do
    if install_file "references/packs/${pack}.md" "$REFERENCES_DIR/packs/${pack}.md"; then
        PACK_INSTALLED=$((PACK_INSTALLED + 1))
    else
        PACK_FAILED=$((PACK_FAILED + 1))
    fi
done

if [ $PACK_FAILED -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} compliance packs (${PACK_INSTALLED} packs)"
    INSTALLED=$((INSTALLED + 1))
else
    echo -e "  ${YELLOW}~${NC} compliance packs (${PACK_INSTALLED}/$((PACK_INSTALLED + PACK_FAILED)))"
    INSTALLED=$((INSTALLED + 1))
fi

# Install framework reference files
FRAMEWORKS="laravel nextjs fastapi express django rails spring-boot aspnet-core go flask nuxtjs sveltekit"
FRAMEWORK_FAILED=0
FRAMEWORK_INSTALLED=0

for fw in $FRAMEWORKS; do
    if install_file "references/frameworks/${fw}.md" "$REFERENCES_DIR/frameworks/${fw}.md"; then
        FRAMEWORK_INSTALLED=$((FRAMEWORK_INSTALLED + 1))
    else
        FRAMEWORK_FAILED=$((FRAMEWORK_FAILED + 1))
    fi
done

if [ $FRAMEWORK_FAILED -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} framework references (${FRAMEWORK_INSTALLED} frameworks)"
    INSTALLED=$((INSTALLED + 1))
else
    echo -e "  ${YELLOW}~${NC} framework references (${FRAMEWORK_INSTALLED}/$((FRAMEWORK_INSTALLED + FRAMEWORK_FAILED)))"
    INSTALLED=$((INSTALLED + 1))
fi

# Create custom checks directory and install template
CUSTOM_DIR="$HOME/.claude/security-audit-custom"
if [ ! -d "$CUSTOM_DIR" ]; then
    mkdir -p "$CUSTOM_DIR"
fi
if [ ! -f "$CUSTOM_DIR/custom-template.md" ]; then
    if install_file "references/custom-template.md" "$CUSTOM_DIR/custom-template.md"; then
        echo -e "  ${GREEN}✓${NC} custom checks folder + template"
        INSTALLED=$((INSTALLED + 1))
    else
        echo -e "  ${YELLOW}~${NC} custom checks folder created (template skipped)"
        INSTALLED=$((INSTALLED + 1))
    fi
else
    echo -e "  ${GREEN}✓${NC} custom checks folder (already exists)"
    INSTALLED=$((INSTALLED + 1))
fi

# Install guidelines
if install_file "security-audit-guidelines.md" "$GUIDELINES_DIR/security-audit-guidelines.md"; then
    echo -e "  ${GREEN}✓${NC} security-audit-guidelines.md"
    INSTALLED=$((INSTALLED + 1))
else
    echo -e "  ${RED}✗${NC} security-audit-guidelines.md"
    FAILED=$((FAILED + 1))
fi

echo ""

# Summary
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All $INSTALLED files installed successfully!${NC}"
else
    echo -e "${YELLOW}Installed $INSTALLED files ($FAILED failed)${NC}"
fi

echo ""
echo -e "Installed to:"
echo -e "  Command:    ${BLUE}$COMMANDS_DIR/security-audit.md${NC}"
echo -e "  References: ${BLUE}$REFERENCES_DIR/${NC}"
echo -e "  Packs:      ${BLUE}$REFERENCES_DIR/packs/${NC}"
echo -e "  Custom:     ${BLUE}$CUSTOM_DIR/${NC}"
echo -e "  Guidelines: ${BLUE}$GUIDELINES_DIR/security-audit-guidelines.md${NC}"
echo ""
echo "Usage in Claude Code:"
echo ""
echo "  /security-audit              Full audit (all categories)"
echo "  /security-audit quick        Critical and high issues only"
echo "  /security-audit diff         Scan only changed files (PR review)"
echo "  /security-audit diff:main    Scan changes compared to main branch"
echo "  /security-audit gray         Gray-box testing only"
echo "  /security-audit focus:auth   Authentication and authorization deep dive"
echo "  /security-audit focus:api    API security deep dive"
echo "  /security-audit focus:config Configuration and infrastructure deep dive"
echo "  /security-audit recheck:src/auth  Re-audit specific paths"
echo "  /security-audit triage       Interactive finding triage"
echo ""
echo "  /security-audit phase:1     Reconnaissance only"
echo "  /security-audit phase:2     White-box analysis only"
echo "  /security-audit phase:3     Gray-box testing only"
echo "  /security-audit phase:4     Security hotspots only"
echo "  /security-audit phase:5     Code smells only"
echo ""
echo "  Append --fix to include remediation code blocks in the report:"
echo "  /security-audit --fix        Full audit with code fixes"
echo "  /security-audit quick --fix  Quick scan with code fixes"
echo ""
echo "  Append --lite to reduce token usage (OWASP + CWE + NIST only):"
echo "  /security-audit --lite       Full audit without extra compliance mapping"
echo "  /security-audit quick --lite Cheapest useful scan"
echo ""
echo "  Additional flags:"
echo "  --fail-on critical|high|medium   CI gating with PASS/FAIL exit line"
echo "  --format sarif|json              Structured output (GitHub/custom)"
echo "  --update-baseline                Save finding fingerprints for tracking"
echo "  --diff-report ./prev-report.md   Compare with previous report"
echo "  --pack hipaa|gdpr|fintech|saas-multi-tenant|soc2|education  Compliance packs"
echo ""
echo "Report will be saved to ./security-audit-report.md in your project root."
echo ""
echo "  PDF export: install pandoc, wkhtmltopdf, weasyprint or md-to-pdf"
echo "  for automatic PDF conversion after each audit."
echo ""
echo -e "${GREEN}You're all set!${NC}"
echo ""
