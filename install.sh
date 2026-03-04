#!/bin/bash

# Claude Security Audit Installer
# Usage (remote):    curl -fsSL https://raw.githubusercontent.com/afiqiqmal/claude-security-audit/main/install.sh | bash
# Usage (local):     bash install.sh
# Usage (uninstall): bash install.sh --uninstall
# Usage (cursor):    bash install.sh --target cursor
# Usage (copilot):   bash install.sh --target copilot
# Usage (windsurf):  bash install.sh --target windsurf
# Usage (codex):     bash install.sh --target codex

set -e

# Parse arguments
TARGET="claude"
UNINSTALL=false

while [ $# -gt 0 ]; do
    case "$1" in
        --uninstall)
            UNINSTALL=true
            shift
            ;;
        --target)
            TARGET="${2:-claude}"
            shift 2
            ;;
        --target=*)
            TARGET="${1#*=}"
            shift
            ;;
        *)
            shift
            ;;
    esac
done

# Validate target
case "$TARGET" in
    claude|cursor|copilot|windsurf|codex) ;;
    *)
        echo "Unknown target: $TARGET. Valid targets: claude, cursor, copilot, windsurf, codex"
        exit 1
        ;;
esac

# Uninstall mode
if [ "$UNINSTALL" = true ]; then
    echo ""
    echo "Claude Security Audit Uninstaller"
    echo "================================="
    echo ""

    REMOVED=0

    case "$TARGET" in
        claude)
            COMMANDS_DIR="$HOME/.claude/commands"
            REFERENCES_DIR="$HOME/.claude/security-audit-references"
            CUSTOM_DIR="$HOME/.claude/security-audit-custom"
            GUIDELINES_DIR="$HOME/.claude"
            for target in "$COMMANDS_DIR/security-audit.md" "$REFERENCES_DIR" "$CUSTOM_DIR" "$GUIDELINES_DIR/security-audit-guidelines.md"; do
                if [ -e "$target" ]; then
                    rm -rf "$target"
                    echo "  Removed $target"
                    REMOVED=$((REMOVED + 1))
                fi
            done
            ;;
        cursor)
            for target in ".cursor/rules/security-audit.mdc" ".cursor/security-audit-references" ".cursor/security-audit-custom"; do
                if [ -e "$target" ]; then
                    rm -rf "$target"
                    echo "  Removed $target"
                    REMOVED=$((REMOVED + 1))
                fi
            done
            ;;
        copilot)
            for target in ".github/prompts/security-audit.prompt.md" ".github/prompts/security-audit-references" ".github/security-audit-custom"; do
                if [ -e "$target" ]; then
                    rm -rf "$target"
                    echo "  Removed $target"
                    REMOVED=$((REMOVED + 1))
                fi
            done
            ;;
        windsurf)
            for target in ".windsurf/rules/security-audit.md" ".windsurf/security-audit-references" ".windsurf/security-audit-custom"; do
                if [ -e "$target" ]; then
                    rm -rf "$target"
                    echo "  Removed $target"
                    REMOVED=$((REMOVED + 1))
                fi
            done
            ;;
        codex)
            for target in ".codex/security-audit.md" ".codex/security-audit-references" ".codex/security-audit-custom"; do
                if [ -e "$target" ]; then
                    rm -rf "$target"
                    echo "  Removed $target"
                    REMOVED=$((REMOVED + 1))
                fi
            done
            ;;
    esac

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
case "$TARGET" in
    claude)   echo "Claude Security Audit Installer" ;;
    cursor)   echo "Claude Security Audit Installer - Cursor" ;;
    copilot)  echo "Claude Security Audit Installer - GitHub Copilot" ;;
    windsurf) echo "Claude Security Audit Installer - Windsurf" ;;
    codex)    echo "Claude Security Audit Installer - OpenAI Codex" ;;
esac
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

# ─────────────────────────────────────────────
#  Target: claude (default)
# ─────────────────────────────────────────────
if [ "$TARGET" = "claude" ]; then

    COMMANDS_DIR="$HOME/.claude/commands"
    REFERENCES_DIR="$HOME/.claude/security-audit-references"
    GUIDELINES_DIR="$HOME/.claude"

    for dir in "$COMMANDS_DIR" "$REFERENCES_DIR"; do
        if [ ! -d "$dir" ]; then
            echo -e "${YELLOW}Creating $dir${NC}"
            mkdir -p "$dir"
        fi
    done

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

fi

# ─────────────────────────────────────────────
#  Target: cursor
# ─────────────────────────────────────────────
if [ "$TARGET" = "cursor" ]; then

    RULES_DIR=".cursor/rules"
    REFERENCES_DIR=".cursor/security-audit-references"
    CUSTOM_DIR=".cursor/security-audit-custom"

    for dir in "$RULES_DIR" "$REFERENCES_DIR"; do
        if [ ! -d "$dir" ]; then
            echo -e "${YELLOW}Creating $dir${NC}"
            mkdir -p "$dir"
        fi
    done

    # Install Cursor rule
    if install_file "targets/cursor/security-audit.mdc" "$RULES_DIR/security-audit.mdc"; then
        echo -e "  ${GREEN}✓${NC} security-audit Cursor rule"
        INSTALLED=$((INSTALLED + 1))
    else
        echo -e "  ${RED}✗${NC} security-audit Cursor rule"
        FAILED=$((FAILED + 1))
    fi

    # Install reference files
    for ref in attack-vectors nist-csf-mapping compliance-mapping features-extended; do
        if install_file "references/${ref}.md" "$REFERENCES_DIR/${ref}.md"; then
            echo -e "  ${GREEN}✓${NC} ${ref}.md reference"
            INSTALLED=$((INSTALLED + 1))
        else
            echo -e "  ${RED}✗${NC} ${ref}.md reference"
            FAILED=$((FAILED + 1))
        fi
    done

    # Install compliance packs
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

    # Install framework references
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

    echo ""

    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}All $INSTALLED files installed successfully!${NC}"
    else
        echo -e "${YELLOW}Installed $INSTALLED files ($FAILED failed)${NC}"
    fi

    echo ""
    echo -e "Installed to:"
    echo -e "  Rule:       ${BLUE}$RULES_DIR/security-audit.mdc${NC}"
    echo -e "  References: ${BLUE}$REFERENCES_DIR/${NC}"
    echo -e "  Packs:      ${BLUE}$REFERENCES_DIR/packs/${NC}"
    echo -e "  Custom:     ${BLUE}$CUSTOM_DIR/${NC}"
    echo ""
    echo "Usage in Cursor:"
    echo ""
    echo "  The rule is 'agent-requested': Cursor auto-applies it when relevant,"
    echo "  or you can reference it explicitly with @security-audit in chat."
    echo ""
    echo "  @security-audit run full audit"
    echo "  @security-audit run quick audit"
    echo "  @security-audit run diff audit"
    echo "  @security-audit run diff:main audit"
    echo "  @security-audit run focus:auth audit"
    echo "  @security-audit run focus:api audit"
    echo "  @security-audit run focus:config audit"
    echo "  @security-audit recheck src/auth"
    echo "  @security-audit triage"
    echo ""
    echo "  Append --fix to include remediation code blocks:"
    echo "  @security-audit run full audit --fix"
    echo "  @security-audit run quick audit --fix"
    echo ""
    echo "  Additional flags:"
    echo "  --lite           OWASP + CWE + NIST only (reduces token usage)"
    echo "  --fail-on high   CI gating with PASS/FAIL exit line"
    echo "  --format sarif   SARIF v2.1.0 output for GitHub Advanced Security"
    echo "  --pack hipaa     Load HIPAA compliance checklist"
    echo ""
    echo "Report will be saved to ./security-audit-report.md in your project root."
    echo ""
    echo -e "${GREEN}You're all set!${NC}"
    echo ""

fi

# ─────────────────────────────────────────────
#  Target: copilot
# ─────────────────────────────────────────────
if [ "$TARGET" = "copilot" ]; then

    PROMPTS_DIR=".github/prompts"
    REFERENCES_DIR=".github/prompts/security-audit-references"
    CUSTOM_DIR=".github/security-audit-custom"

    for dir in "$PROMPTS_DIR" "$REFERENCES_DIR"; do
        if [ ! -d "$dir" ]; then
            echo -e "${YELLOW}Creating $dir${NC}"
            mkdir -p "$dir"
        fi
    done

    # Install Copilot prompt file
    if install_file "targets/copilot/security-audit.prompt.md" "$PROMPTS_DIR/security-audit.prompt.md"; then
        echo -e "  ${GREEN}✓${NC} security-audit Copilot prompt"
        INSTALLED=$((INSTALLED + 1))
    else
        echo -e "  ${RED}✗${NC} security-audit Copilot prompt"
        FAILED=$((FAILED + 1))
    fi

    # Install reference files
    for ref in attack-vectors nist-csf-mapping compliance-mapping features-extended; do
        if install_file "references/${ref}.md" "$REFERENCES_DIR/${ref}.md"; then
            echo -e "  ${GREEN}✓${NC} ${ref}.md reference"
            INSTALLED=$((INSTALLED + 1))
        else
            echo -e "  ${RED}✗${NC} ${ref}.md reference"
            FAILED=$((FAILED + 1))
        fi
    done

    # Install compliance packs
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

    # Install framework references
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

    echo ""

    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}All $INSTALLED files installed successfully!${NC}"
    else
        echo -e "${YELLOW}Installed $INSTALLED files ($FAILED failed)${NC}"
    fi

    echo ""
    echo -e "Installed to:"
    echo -e "  Prompt:     ${BLUE}$PROMPTS_DIR/security-audit.prompt.md${NC}"
    echo -e "  References: ${BLUE}$REFERENCES_DIR/${NC}"
    echo -e "  Packs:      ${BLUE}$REFERENCES_DIR/packs/${NC}"
    echo -e "  Custom:     ${BLUE}$CUSTOM_DIR/${NC}"
    echo ""
    echo "Usage in GitHub Copilot (VS Code):"
    echo ""
    echo "  Prompt files are enabled by default in VS Code 1.99+."
    echo "  To add extra locations, set in settings.json:"
    echo "  \"chat.promptFilesLocations\": { \"path/to/dir\": true }"
    echo ""
    echo "  In Copilot Chat, click the paperclip icon, select 'Prompt...',"
    echo "  then pick 'security-audit'. Or type:"
    echo ""
    echo "  Run a full security audit"
    echo "  Run a quick security audit"
    echo "  Run a diff security audit"
    echo "  Run a diff:main security audit"
    echo "  Run a focus:auth security audit"
    echo "  Run a focus:api security audit"
    echo "  Run a focus:config security audit"
    echo "  Recheck src/auth security audit"
    echo "  Run security audit triage"
    echo ""
    echo "  Append --fix to include remediation code blocks:"
    echo "  Run a full security audit --fix"
    echo "  Run a quick security audit --fix"
    echo ""
    echo "  Additional flags:"
    echo "  --lite           OWASP + CWE + NIST only (reduces token usage)"
    echo "  --fail-on high   CI gating with PASS/FAIL exit line"
    echo "  --format sarif   SARIF v2.1.0 output for GitHub Advanced Security"
    echo "  --pack hipaa     Load HIPAA compliance checklist"
    echo ""
    echo "Report will be saved to ./security-audit-report.md in your project root."
    echo ""
    echo -e "${GREEN}You're all set!${NC}"
    echo ""

fi

# ─────────────────────────────────────────────
#  Target: windsurf
# ─────────────────────────────────────────────
if [ "$TARGET" = "windsurf" ]; then

    RULES_DIR=".windsurf/rules"
    REFERENCES_DIR=".windsurf/security-audit-references"
    CUSTOM_DIR=".windsurf/security-audit-custom"

    for dir in "$RULES_DIR" "$REFERENCES_DIR"; do
        if [ ! -d "$dir" ]; then
            echo -e "${YELLOW}Creating $dir${NC}"
            mkdir -p "$dir"
        fi
    done

    # Install Windsurf rule
    if install_file "targets/windsurf/security-audit.md" "$RULES_DIR/security-audit.md"; then
        echo -e "  ${GREEN}✓${NC} security-audit Windsurf rule"
        INSTALLED=$((INSTALLED + 1))
    else
        echo -e "  ${RED}✗${NC} security-audit Windsurf rule"
        FAILED=$((FAILED + 1))
    fi

    # Install reference files
    for ref in attack-vectors nist-csf-mapping compliance-mapping features-extended; do
        if install_file "references/${ref}.md" "$REFERENCES_DIR/${ref}.md"; then
            echo -e "  ${GREEN}✓${NC} ${ref}.md reference"
            INSTALLED=$((INSTALLED + 1))
        else
            echo -e "  ${RED}✗${NC} ${ref}.md reference"
            FAILED=$((FAILED + 1))
        fi
    done

    # Install compliance packs
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

    # Install framework references
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

    echo ""

    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}All $INSTALLED files installed successfully!${NC}"
    else
        echo -e "${YELLOW}Installed $INSTALLED files ($FAILED failed)${NC}"
    fi

    echo ""
    echo -e "Installed to:"
    echo -e "  Rule:       ${BLUE}$RULES_DIR/security-audit.md${NC}"
    echo -e "  References: ${BLUE}$REFERENCES_DIR/${NC}"
    echo -e "  Packs:      ${BLUE}$REFERENCES_DIR/packs/${NC}"
    echo -e "  Custom:     ${BLUE}$CUSTOM_DIR/${NC}"
    echo ""
    echo "Usage in Windsurf:"
    echo ""
    echo "  The rule has 'manual' trigger: reference it with @security-audit in Cascade chat."
    echo ""
    echo "  @security-audit run full audit"
    echo "  @security-audit run quick audit"
    echo "  @security-audit run diff audit"
    echo "  @security-audit run diff:main audit"
    echo "  @security-audit run focus:auth audit"
    echo "  @security-audit run focus:api audit"
    echo "  @security-audit run focus:config audit"
    echo "  @security-audit recheck src/auth"
    echo "  @security-audit triage"
    echo ""
    echo "  Append --fix to include remediation code blocks:"
    echo "  @security-audit run full audit --fix"
    echo "  @security-audit run quick audit --fix"
    echo ""
    echo "  Additional flags:"
    echo "  --lite           OWASP + CWE + NIST only (reduces token usage)"
    echo "  --fail-on high   CI gating with PASS/FAIL exit line"
    echo "  --format sarif   SARIF v2.1.0 output for GitHub Advanced Security"
    echo "  --pack hipaa     Load HIPAA compliance checklist"
    echo ""
    echo "Report will be saved to ./security-audit-report.md in your project root."
    echo ""
    echo -e "${GREEN}You're all set!${NC}"
    echo ""

fi

# ─────────────────────────────────────────────
#  Target: codex
# ─────────────────────────────────────────────
if [ "$TARGET" = "codex" ]; then

    CODEX_DIR=".codex"
    REFERENCES_DIR=".codex/security-audit-references"
    CUSTOM_DIR=".codex/security-audit-custom"

    for dir in "$CODEX_DIR" "$REFERENCES_DIR"; do
        if [ ! -d "$dir" ]; then
            echo -e "${YELLOW}Creating $dir${NC}"
            mkdir -p "$dir"
        fi
    done

    # Install Codex instructions file
    if install_file "targets/codex/security-audit.md" "$CODEX_DIR/security-audit.md"; then
        echo -e "  ${GREEN}✓${NC} security-audit Codex instructions"
        INSTALLED=$((INSTALLED + 1))
    else
        echo -e "  ${RED}✗${NC} security-audit Codex instructions"
        FAILED=$((FAILED + 1))
    fi

    # Install reference files
    for ref in attack-vectors nist-csf-mapping compliance-mapping features-extended; do
        if install_file "references/${ref}.md" "$REFERENCES_DIR/${ref}.md"; then
            echo -e "  ${GREEN}✓${NC} ${ref}.md reference"
            INSTALLED=$((INSTALLED + 1))
        else
            echo -e "  ${RED}✗${NC} ${ref}.md reference"
            FAILED=$((FAILED + 1))
        fi
    done

    # Install compliance packs
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

    # Install framework references
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

    echo ""

    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}All $INSTALLED files installed successfully!${NC}"
    else
        echo -e "${YELLOW}Installed $INSTALLED files ($FAILED failed)${NC}"
    fi

    echo ""
    echo -e "Installed to:"
    echo -e "  Instructions: ${BLUE}$CODEX_DIR/security-audit.md${NC}"
    echo -e "  References:   ${BLUE}$REFERENCES_DIR/${NC}"
    echo -e "  Packs:        ${BLUE}$REFERENCES_DIR/packs/${NC}"
    echo -e "  Custom:       ${BLUE}$CUSTOM_DIR/${NC}"
    echo ""
    echo "Usage with OpenAI Codex CLI:"
    echo ""
    echo "  Pass the instructions file as context when running codex:"
    echo ""
    echo "  codex --context .codex/security-audit.md 'run full audit'"
    echo "  codex --context .codex/security-audit.md 'run quick audit'"
    echo "  codex --context .codex/security-audit.md 'run diff audit'"
    echo "  codex --context .codex/security-audit.md 'run diff:main audit'"
    echo "  codex --context .codex/security-audit.md 'run focus:auth audit'"
    echo "  codex --context .codex/security-audit.md 'run focus:api audit'"
    echo "  codex --context .codex/security-audit.md 'run focus:config audit'"
    echo "  codex --context .codex/security-audit.md 'recheck src/auth'"
    echo "  codex --context .codex/security-audit.md 'triage'"
    echo ""
    echo "  Or add to your project AGENTS.md to load automatically:"
    echo "  echo '' >> AGENTS.md"
    echo "  echo '## Security Audit' >> AGENTS.md"
    echo "  echo 'See .codex/security-audit.md for security audit instructions.' >> AGENTS.md"
    echo ""
    echo "  Append --fix to include remediation code blocks:"
    echo "  codex --context .codex/security-audit.md 'run full audit --fix'"
    echo ""
    echo "  Additional flags:"
    echo "  --lite           OWASP + CWE + NIST only (reduces token usage)"
    echo "  --fail-on high   CI gating with PASS/FAIL exit line"
    echo "  --format sarif   SARIF v2.1.0 output for GitHub Advanced Security"
    echo "  --pack hipaa     Load HIPAA compliance checklist"
    echo ""
    echo "Report will be saved to ./security-audit-report.md in your project root."
    echo ""
    echo -e "${GREEN}You're all set!${NC}"
    echo ""

fi
