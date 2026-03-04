# Claude Security Audit

A Claude Code slash command for running comprehensive white-box and gray-box security audits on your projects, with findings mapped to OWASP Top 10:2025, CWE, NIST CSF 2.0, SANS/CWE Top 25, OWASP ASVS 5.0, PCI DSS 4.0.1, MITRE ATT&CK, SOC 2 and ISO 27001:2022.

## Features

- **Slash Command** - Run `/security-audit` in any project from Claude Code
- **Local Output** - Report saves to `./security-audit-report.md` in your project root
- **OWASP Top 10:2025 Coverage** - All 10 categories explicitly tested (A01-A10:2025)
- **CWE Mapping** - Every finding tagged with specific CWE IDs
- **NIST CSF 2.0 Mapping** - Every finding maps to Govern, Identify, Protect, Detect, Respond or Recover
- **Multi-Framework Compliance** - SANS/CWE Top 25, OWASP ASVS 5.0, PCI DSS 4.0.1, MITRE ATT&CK, SOC 2 and ISO 27001:2022
- **White-Box Testing** - 20 attack categories with 475+ individual checks
- **AI/LLM Security** - Prompt injection, output sanitization, RAG poisoning, cost monitoring, tool calling permissions
- **Diff Mode** - Scan only git-changed files for fast PR-level reviews
- **Recheck Mode** - Re-audit specific files or directories after fixes
- **Gray-Box Testing** - Role-based access probing, API endpoint testing, credential boundary checks, error differential analysis
- **Security Hotspots** - Flags sensitive code that needs careful review during PRs
- **Code Smells** - Quality patterns that breed security bugs
- **Multi-Framework Detection** - Auto-detects and loads checks for up to 3 frameworks (Laravel, Next.js, FastAPI, Express, Django, Rails, Spring Boot, ASP.NET Core, Go, Flask, Nuxt.js, SvelteKit)
- **Findings First** - Shows findings by default, append `--fix` to include remediation code blocks
- **Lite Mode** - Append `--lite` to reduce token usage (OWASP + CWE + NIST only, skips extra compliance mapping)
- **CI Gating** - `--fail-on` flag outputs machine-readable PASS/FAIL for CI/CD pipelines
- **SARIF/JSON Output** - `--format sarif` for GitHub Advanced Security, `--format json` for custom tooling
- **Baseline Suppression** - `--update-baseline` tracks known findings across audit runs
- **Report Diff** - `--diff-report` compares with previous audits to show new, resolved and changed findings
- **Triage Mode** - Interactive walkthrough to Accept, Defer, Dismiss or Escalate each finding
- **Compliance Packs** - `--pack` loads HIPAA, GDPR, fintech, SaaS multi-tenant, SOC 2 or Education checks
- **Scope Exclusions** - `.security-audit-ignore` file to skip files and directories
- **Custom Checks** - Add your own `.md` checklists globally or per-project
- **Phase Control** - Run individual phases (recon, white-box, gray-box, hotspots, smells) independently
- **Multiple Modes** - Full audit, quick scan, gray-box only, focused deep dives or single phases
- **Severity Indicators** - Color-coded emoji for severity levels (🔴 Critical, 🟠 High, 🟡 Medium, 🟢 Low, 🔵 Info)
- **PDF Export** - Automatically converts report to PDF if pandoc, wkhtmltopdf, weasyprint or md-to-pdf is installed

## What's Included

```
claude-security-audit/
├── .claude/
│   └── commands/
│       └── security-audit.md       # /security-audit slash command
├── targets/
│   ├── cursor/
│   │   └── security-audit.mdc      # Cursor agent rule
│   ├── copilot/
│   │   └── security-audit.prompt.md  # GitHub Copilot prompt file
│   ├── windsurf/
│   │   └── security-audit.md       # Windsurf Cascade rule
│   └── codex/
│       └── security-audit.md       # OpenAI Codex instructions
├── references/
│   ├── attack-vectors.md           # 475+ security checks (OWASP 2025 + NIST + CWE tagged)
│   ├── nist-csf-mapping.md         # OWASP 2025-to-NIST cross-reference tables
│   ├── compliance-mapping.md       # CWE, SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001
│   ├── features-extended.md        # Baseline, SARIF/JSON, report diff, triage specs
│   ├── custom-template.md          # Template for custom checks
│   ├── frameworks/                 # Framework-specific checklists
│   │   ├── laravel.md
│   │   ├── nextjs.md
│   │   ├── fastapi.md
│   │   ├── express.md
│   │   ├── django.md
│   │   ├── rails.md
│   │   ├── spring-boot.md
│   │   ├── aspnet-core.md
│   │   ├── go.md
│   │   ├── flask.md
│   │   ├── nuxtjs.md
│   │   └── sveltekit.md
│   └── packs/                      # Compliance check packs
│       ├── hipaa.md
│       ├── gdpr.md
│       ├── fintech.md
│       ├── saas-multi-tenant.md
│       ├── soc2.md
│       └── education.md
├── security-audit-guidelines.md    # Severity ratings, conventions, framework detection
├── install.sh                      # One-command installer (supports --target cursor/copilot)
├── CLAUDE.md                       # Project context for Claude Code
├── LICENSE
├── .gitignore
└── README.md
```

## Quick Install

### Claude Code (default)

```bash
# One-line install
curl -fsSL https://raw.githubusercontent.com/afiqiqmal/claude-security-audit/main/install.sh | bash

# Or clone and install locally
git clone https://github.com/afiqiqmal/claude-security-audit.git
cd claude-security-audit
bash install.sh
```

Installs the `/security-audit` slash command and all reference files to `~/.claude/`.

### Cursor

```bash
# From project root
curl -fsSL https://raw.githubusercontent.com/afiqiqmal/claude-security-audit/main/install.sh | bash -s -- --target cursor

# Or clone and install locally
bash install.sh --target cursor
```

Installs a Cursor agent rule to `.cursor/rules/security-audit.mdc` and reference files to `.cursor/security-audit-references/`. Run from your project root.

### GitHub Copilot

```bash
# From project root
curl -fsSL https://raw.githubusercontent.com/afiqiqmal/claude-security-audit/main/install.sh | bash -s -- --target copilot

# Or clone and install locally
bash install.sh --target copilot
```

Installs a Copilot prompt file to `.github/prompts/security-audit.prompt.md` and reference files to `.github/prompts/security-audit-references/`. Run from your project root.

### Windsurf

```bash
# From project root
curl -fsSL https://raw.githubusercontent.com/afiqiqmal/claude-security-audit/main/install.sh | bash -s -- --target windsurf

# Or clone and install locally
bash install.sh --target windsurf
```

Installs a Windsurf Cascade rule to `.windsurf/rules/security-audit.md` and reference files to `.windsurf/security-audit-references/`. Run from your project root.

### OpenAI Codex

```bash
# From project root
curl -fsSL https://raw.githubusercontent.com/afiqiqmal/claude-security-audit/main/install.sh | bash -s -- --target codex

# Or clone and install locally
bash install.sh --target codex
```

Installs instructions to `.codex/security-audit.md` and reference files to `.codex/security-audit-references/`. Run from your project root.

### Per-Project Install (Claude Code, no global)

```bash
cp -r .claude/commands/security-audit.md /path/to/your-project/.claude/commands/
```

When installed per-project, use `/project:security-audit`. Note: this copies only the command file. Reference files (`attack-vectors.md`, `compliance-mapping.md`, etc.) must be installed globally via `bash install.sh` for full and diff modes. Quick and lite modes work without references.

### Uninstall

```bash
bash install.sh --uninstall                      # Claude Code
bash install.sh --uninstall --target cursor      # Cursor
bash install.sh --uninstall --target copilot     # GitHub Copilot
bash install.sh --uninstall --target windsurf    # Windsurf
bash install.sh --uninstall --target codex       # OpenAI Codex
```

## What Gets Installed

### Claude Code (`--target claude`, default)

| File | Location | Purpose |
|------|----------|---------|
| `security-audit.md` | `~/.claude/commands/` | `/security-audit` slash command |
| `attack-vectors.md` | `~/.claude/security-audit-references/` | 475+ OWASP 2025/NIST/CWE-tagged security checks |
| `nist-csf-mapping.md` | `~/.claude/security-audit-references/` | OWASP 2025-to-NIST cross-reference tables |
| `compliance-mapping.md` | `~/.claude/security-audit-references/` | CWE, SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001 |
| `features-extended.md` | `~/.claude/security-audit-references/` | Baseline, SARIF/JSON, report diff and triage specs |
| `frameworks/*.md` | `~/.claude/security-audit-references/frameworks/` | 12 framework-specific checklists |
| `packs/*.md` | `~/.claude/security-audit-references/packs/` | 6 compliance check packs (HIPAA, GDPR, fintech, SaaS, SOC 2, Education) |
| `custom-template.md` | `~/.claude/security-audit-custom/` | Template for writing custom checks |
| `security-audit-guidelines.md` | `~/.claude/` | Severity ratings and conventions |

### Cursor (`--target cursor`)

| File | Location | Purpose |
|------|----------|---------|
| `security-audit.mdc` | `.cursor/rules/` | Cursor agent rule (auto-applied or via `@security-audit`) |
| `attack-vectors.md` | `.cursor/security-audit-references/` | 475+ OWASP 2025/NIST/CWE-tagged security checks |
| `nist-csf-mapping.md` | `.cursor/security-audit-references/` | OWASP 2025-to-NIST cross-reference tables |
| `compliance-mapping.md` | `.cursor/security-audit-references/` | CWE, SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001 |
| `features-extended.md` | `.cursor/security-audit-references/` | Baseline, SARIF/JSON, report diff and triage specs |
| `frameworks/*.md` | `.cursor/security-audit-references/frameworks/` | 12 framework-specific checklists |
| `packs/*.md` | `.cursor/security-audit-references/packs/` | 6 compliance check packs |
| `custom-template.md` | `.cursor/security-audit-custom/` | Template for writing custom checks |

### GitHub Copilot (`--target copilot`)

| File | Location | Purpose |
|------|----------|---------|
| `security-audit.prompt.md` | `.github/prompts/` | Copilot prompt file (select via paperclip icon in chat) |
| `attack-vectors.md` | `.github/prompts/security-audit-references/` | 475+ OWASP 2025/NIST/CWE-tagged security checks |
| `nist-csf-mapping.md` | `.github/prompts/security-audit-references/` | OWASP 2025-to-NIST cross-reference tables |
| `compliance-mapping.md` | `.github/prompts/security-audit-references/` | CWE, SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001 |
| `features-extended.md` | `.github/prompts/security-audit-references/` | Baseline, SARIF/JSON, report diff and triage specs |
| `frameworks/*.md` | `.github/prompts/security-audit-references/frameworks/` | 12 framework-specific checklists |
| `packs/*.md` | `.github/prompts/security-audit-references/packs/` | 6 compliance check packs |
| `custom-template.md` | `.github/security-audit-custom/` | Template for writing custom checks |

### Windsurf (`--target windsurf`)

| File | Location | Purpose |
|------|----------|---------|
| `security-audit.md` | `.windsurf/rules/` | Windsurf Cascade rule (manual trigger via `@security-audit`) |
| `attack-vectors.md` | `.windsurf/security-audit-references/` | 475+ OWASP 2025/NIST/CWE-tagged security checks |
| `nist-csf-mapping.md` | `.windsurf/security-audit-references/` | OWASP 2025-to-NIST cross-reference tables |
| `compliance-mapping.md` | `.windsurf/security-audit-references/` | CWE, SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001 |
| `features-extended.md` | `.windsurf/security-audit-references/` | Baseline, SARIF/JSON, report diff and triage specs |
| `frameworks/*.md` | `.windsurf/security-audit-references/frameworks/` | 12 framework-specific checklists |
| `packs/*.md` | `.windsurf/security-audit-references/packs/` | 6 compliance check packs |
| `custom-template.md` | `.windsurf/security-audit-custom/` | Template for writing custom checks |

### OpenAI Codex (`--target codex`)

| File | Location | Purpose |
|------|----------|---------|
| `security-audit.md` | `.codex/` | Audit instructions (pass via `--context` or reference in `AGENTS.md`) |
| `attack-vectors.md` | `.codex/security-audit-references/` | 475+ OWASP 2025/NIST/CWE-tagged security checks |
| `nist-csf-mapping.md` | `.codex/security-audit-references/` | OWASP 2025-to-NIST cross-reference tables |
| `compliance-mapping.md` | `.codex/security-audit-references/` | CWE, SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001 |
| `features-extended.md` | `.codex/security-audit-references/` | Baseline, SARIF/JSON, report diff and triage specs |
| `frameworks/*.md` | `.codex/security-audit-references/frameworks/` | 12 framework-specific checklists |
| `packs/*.md` | `.codex/security-audit-references/packs/` | 6 compliance check packs |
| `custom-template.md` | `.codex/security-audit-custom/` | Template for writing custom checks |

## Usage

### Claude Code

```bash
# Full audit (white-box + gray-box + hotspots + smells)
/security-audit

# Quick scan (CRITICAL and HIGH only, no gray-box)
/security-audit quick

# Gray-box testing only
/security-audit gray

# Diff mode - scan only changed files (fast PR reviews)
/security-audit diff           # Changes since last commit
/security-audit diff:main      # Changes compared to main branch
/security-audit diff:develop   # Changes compared to develop branch

# Focused deep dives
/security-audit focus:auth     # Authentication and authorization
/security-audit focus:api      # API security and input validation
/security-audit focus:config   # Configuration, supply chain, infrastructure

# Re-audit specific paths after fixing
/security-audit recheck:src/auth           # Single path
/security-audit recheck:src/auth,src/api   # Multiple paths

# Interactive triage of existing findings
/security-audit triage

# Run individual phases
/security-audit phase:1        # Reconnaissance only
/security-audit phase:2        # White-box analysis only
/security-audit phase:3        # Gray-box testing only
/security-audit phase:4        # Security hotspots only
/security-audit phase:5        # Code smells only

# Include code fixes in the report (off by default)
/security-audit --fix          # Full audit with remediation code blocks
/security-audit quick --fix    # Quick scan with fixes
/security-audit diff:main --fix

# Lite mode - reduce token usage (OWASP + CWE + NIST only)
/security-audit --lite         # Full audit without extra compliance mapping
/security-audit quick --lite   # Cheapest useful scan
/security-audit diff:main --lite --fix

# CI gating - fail if findings at or above threshold
/security-audit diff:main --fail-on high
/security-audit full --fail-on critical

# Structured output (alongside markdown)
/security-audit --format sarif       # SARIF v2.1.0 for GitHub Advanced Security
/security-audit --format json        # JSON for custom tooling

# Baseline tracking
/security-audit --update-baseline    # Save current findings as baseline
/security-audit full                 # Future runs auto-tag known findings

# Compare with previous report
/security-audit --diff-report ./previous-report.md

# Compliance packs
/security-audit --pack hipaa                    # HIPAA checks
/security-audit --pack gdpr --pack fintech      # Multiple packs
/security-audit --pack saas-multi-tenant
/security-audit --pack soc2
/security-audit --pack education

# Combine everything
/security-audit diff:main --lite --fix --fail-on high --pack hipaa
```

By default, the report shows findings only (vulnerable code, impact and a text description of what to fix). Append `--fix` to include copy-paste-ready remediation code blocks. Append `--lite` to skip SANS Top 25, ASVS, PCI DSS, MITRE ATT&CK, SOC 2 and ISO 27001 mapping and reduce token usage.

### Cursor

After installing with `--target cursor`, reference the rule in Cursor chat:

```
@security-audit run full audit
@security-audit run quick audit
@security-audit run diff audit
@security-audit run diff:main audit
@security-audit run focus:auth audit
@security-audit run focus:api audit
@security-audit run focus:config audit
@security-audit recheck src/auth
@security-audit triage

# With flags
@security-audit run full audit --fix
@security-audit run quick audit --lite
@security-audit run diff:main audit --fail-on high
@security-audit run full audit --pack hipaa
```

The rule type is `agent-requested` - Cursor auto-applies it when the task is security-related, or you can reference it explicitly with `@security-audit`.

### GitHub Copilot (VS Code)

After installing with `--target copilot`, open Copilot Chat, click the paperclip icon, select **Prompt...** and pick `security-audit`. Prompt files require VS Code 1.99+.

```
Run a full security audit
Run a quick security audit
Run a diff security audit
Run a diff:main security audit
Run a focus:auth security audit
Run a focus:api security audit
Run a focus:config security audit
Recheck src/auth security audit
Run security audit triage

# With flags
Run a full security audit --fix
Run a quick security audit --lite
Run a diff:main security audit --fail-on high
Run a full security audit --pack hipaa
```

To add extra prompt file locations, set in `settings.json`:
```json
"chat.promptFilesLocations": { "path/to/dir": true }
```

### Windsurf

After installing with `--target windsurf`, reference the rule in Cascade chat:

```
@security-audit run full audit
@security-audit run quick audit
@security-audit run diff audit
@security-audit run diff:main audit
@security-audit run focus:auth audit
@security-audit run focus:api audit
@security-audit run focus:config audit
@security-audit recheck src/auth
@security-audit triage

# With flags
@security-audit run full audit --fix
@security-audit run quick audit --lite
@security-audit run diff:main audit --fail-on high
@security-audit run full audit --pack hipaa
```

The rule uses `trigger: manual` - it is only applied when you explicitly reference it with `@security-audit` in Cascade.

### OpenAI Codex

After installing with `--target codex`, pass the instructions file as context:

```bash
codex --context .codex/security-audit.md 'run full audit'
codex --context .codex/security-audit.md 'run quick audit'
codex --context .codex/security-audit.md 'run diff audit'
codex --context .codex/security-audit.md 'run diff:main audit'
codex --context .codex/security-audit.md 'run focus:auth audit'
codex --context .codex/security-audit.md 'run focus:api audit'
codex --context .codex/security-audit.md 'run focus:config audit'
codex --context .codex/security-audit.md 'recheck src/auth'
codex --context .codex/security-audit.md 'triage'

# With flags
codex --context .codex/security-audit.md 'run full audit --fix'
codex --context .codex/security-audit.md 'run quick audit --lite'
codex --context .codex/security-audit.md 'run diff:main audit --fail-on high'
codex --context .codex/security-audit.md 'run full audit --pack hipaa'
```

Or add a reference to your project `AGENTS.md` so it loads automatically:

```markdown
## Security Audit

See .codex/security-audit.md for security audit instructions.
```

### Output

Report saves to `./security-audit-report.md` in your project root. If a PDF converter is installed, it also saves `./security-audit-report.pdf`.

| Output File | When Generated |
|------------|----------------|
| `security-audit-report.md` | Always (primary report) |
| `security-audit-report.pdf` | When a PDF converter is installed |
| `security-audit-report.sarif` | With `--format sarif` |
| `security-audit-report.json` | With `--format json` |
| `security-audit-triage.md` | After running `triage` mode |
| `.security-audit-baseline.json` | With `--update-baseline` |

Supported PDF converters (checked in order):

| Converter | Install |
|-----------|---------|
| pandoc | `brew install pandoc` or [pandoc.org](https://pandoc.org/installing.html) |
| wkhtmltopdf | `brew install wkhtmltopdf` or [wkhtmltopdf.org](https://wkhtmltopdf.org) |
| weasyprint | `pip install weasyprint` |
| md-to-pdf | `npm install -g md-to-pdf` |
| mdpdf | `npm install -g mdpdf` |

If no converter is found, the audit still completes - only the markdown report is generated.

### Token Usage Warning

This audit is **token-intensive**. Claude reads the command file, reference files and your entire codebase before generating a report. Estimated token usage by mode:

| Mode | Reference Overhead | Codebase Scan | Report Output | Estimated Total |
|------|-------------------|---------------|---------------|-----------------|
| `quick --lite` | ~9K tokens | ~20-60K | ~5-15K | **~35-85K tokens** |
| `diff --lite` | ~9K tokens | ~5-20K | ~5-15K | **~20-45K tokens** |
| `recheck:path` | ~19K tokens | ~5-20K | ~5-15K | **~30-55K tokens** |
| `quick` | ~19K tokens | ~20-60K | ~10-25K | **~50-105K tokens** |
| `focus:auth` | ~15K tokens | ~15-40K | ~10-20K | **~40-75K tokens** |
| `diff` | ~19K tokens | ~5-20K | ~10-20K | **~35-60K tokens** |
| `full --lite` | ~19K tokens | ~40-120K | ~15-30K | **~75-170K tokens** |
| `full` | ~29K tokens | ~40-120K | ~20-40K | **~90-190K tokens** |
| `full --fix` | ~29K tokens | ~40-120K | ~30-60K | **~100-210K tokens** |
| `full --pack hipaa` | ~31K tokens | ~40-120K | ~25-45K | **~95-195K tokens** |
| `full --pack soc2` | ~31K tokens | ~40-120K | ~25-45K | **~95-195K tokens** |
| `triage` | ~10K tokens | ~0K | ~5-10K | **~15-20K tokens** |

**Reference overhead breakdown** (tokens loaded before scanning starts):

| File | Tokens | Loaded In |
|------|--------|-----------|
| Command file (always loaded) | ~9K | All modes |
| `attack-vectors.md` | ~10K | `full`, `diff`, `recheck`, `phase:2` (skipped in `quick`) |
| `compliance-mapping.md` | ~7K | `full` only (skipped with `--lite`) |
| `nist-csf-mapping.md` | ~3K | `full`, `phase:2` (skipped with `--lite`) |
| `guidelines.md` | ~2K | All modes |
| Framework file (up to 3) | ~1K each | When framework detected |
| `features-extended.md` | ~3K | When `--format`, `--update-baseline`, `--diff-report` or `triage` used |
| Pack file (each) | ~1K | When `--pack` used |

Codebase scan tokens depend on your project size. A small project (10-20 files) uses ~20K scan tokens while a large project (200+ files) can use 100K+. The `diff`, `focus` and `recheck` modes significantly reduce scan tokens by limiting scope. Adding `--fix` increases report output by roughly 50% due to remediation code blocks. Compliance packs add ~1K tokens each.

**To minimize costs**: use `quick --lite` for fast checks, `diff --lite` for PR reviews and reserve `full` for thorough audits.

## Custom Checks

Add your own security checklists that run alongside the built-in checks. The audit reads all `.md` files from two folders:

| Folder | Scope | Use Case |
|--------|-------|----------|
| `~/.claude/security-audit-custom/` | Global (all projects) | Company-wide standards, compliance rules |
| `.claude/security-audit-custom/` | Project-level | Project-specific checks, internal API rules |

A template file is installed at `~/.claude/security-audit-custom/custom-template.md` during setup. Copy and rename it to create your own checklists.

### Writing Custom Checks

Organize checks under headings with OWASP and NIST tags:

```markdown
## Internal API Standards [A01:2025, A05:2025 | PR.AA, PR.DS]

- [ ] All internal endpoints require service-to-service auth tokens
- [ ] Response bodies never include internal database IDs
- [ ] Deprecated endpoints return 410 Gone
```

Custom checks are loaded during Phase 1 (reconnaissance) and run as additional checklists during Phase 2 (white-box analysis). Both global and project-level checks are merged - project-level checks do not override global ones.

## Scope Exclusions

Create a `.security-audit-ignore` file in your project root to exclude files and directories from the audit:

```
# Dependencies (already covered by dependency audit tools)
vendor/
node_modules/
.venv/

# Build artifacts
dist/
build/
*.min.js

# Test fixtures with intentionally vulnerable code
tests/fixtures/

# Negate to include a specific file
!tests/fixtures/auth-test.php
```

Format follows gitignore conventions: one pattern per line, `#` for comments, `!` for negation. Exclusions apply to all audit phases.

## Compliance Packs

Load compliance-specific checklists with `--pack`:

| Pack | Checks | Focus Areas |
|------|--------|-------------|
| `hipaa` | 36 | PHI protection, access controls, audit trails, BAA requirements, breach notification |
| `gdpr` | 39 | Consent, data subject rights, data protection by design, international transfers, breach management |
| `fintech` | 42 | Transaction security, PCI DSS, fraud detection, regulatory compliance (KYC/AML) |
| `saas-multi-tenant` | 43 | Tenant isolation, cross-tenant vulnerabilities, resource limits, tenant administration |
| `soc2` | 50 | Trust Service Criteria (CC6-CC8), monitoring, change management, availability, vendor management |
| `education` | 35 | FERPA/COPPA student data, parental consent, directory information, age verification |

```bash
/security-audit --pack hipaa                    # Single pack
/security-audit --pack gdpr --pack fintech      # Multiple packs
/security-audit full --pack saas-multi-tenant --fix
```

Packs are loaded during Phase 1 and run as additional checklists during Phase 2, the same mechanism as custom checks. Pack findings include OWASP, CWE and NIST tags.

## CI/CD Integration

### GitHub Actions

Use `--fail-on` and `diff` mode for automated PR security checks:

```yaml
name: Security Audit
on:
  pull_request:
    branches: [main]

jobs:
  security-audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run security audit
        run: |
          claude /security-audit "diff:main --lite --fail-on high"

      - name: Upload report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: security-audit-report
          path: |
            security-audit-report.md
            security-audit-report.sarif
```

The `--fail-on` flag outputs a machine-readable line at the end of the audit:

```
SECURITY_AUDIT_EXIT: PASS
SECURITY_AUDIT_EXIT: FAIL (3 findings at or above HIGH)
```

Threshold levels: `critical` (only CRITICAL), `high` (CRITICAL + HIGH), `medium` (CRITICAL + HIGH + MEDIUM).

### SARIF Integration

Use `--format sarif` to upload results to GitHub Advanced Security:

```yaml
      - name: Upload SARIF
        if: always()
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: security-audit-report.sarif
```

## Baseline Tracking

Track known findings across audit runs with `--update-baseline`:

```bash
# First run - establish baseline
/security-audit full --update-baseline

# Future runs - new findings are highlighted, known findings tagged [Known]
/security-audit full
```

The baseline file (`.security-audit-baseline.json`) stores fingerprints of each finding. On subsequent runs, findings matching the baseline appear with a `[Known]` badge and a "New since baseline" count is added to the Executive Summary. Commit the baseline file to track security posture over time.

## Report Diff

Compare the current audit with a previous report to see what changed:

```bash
# Save current report, then run again later
/security-audit full --diff-report ./previous-report.md
```

Adds a "Changes Since Previous Audit" section showing:
- **New findings** - issues found in the current audit but not in the previous one
- **Resolved findings** - issues from the previous audit that no longer appear
- **Changed severity** - same finding with a different severity level

## Triage Mode

After running an audit, use triage mode to categorize each finding:

```bash
/security-audit triage
```

Walks through each finding (ordered by severity) and asks the developer to:
- **Accept** - Will fix this finding
- **Defer** - Known risk, accepted for now (with reason)
- **Dismiss** - False positive or not applicable (with reason)
- **Escalate** - Needs team review or architect decision

Results are saved to `./security-audit-triage.md`. This is useful for tracking team decisions on which findings to address and which to accept as known risks.

## OWASP Top 10:2025 Coverage

| # | Category | OWASP ID | Key Changes from 2021 |
|---|----------|----------|----------------------|
| 1 | Broken Access Control | A01:2025 | Now includes SSRF (was separate A10:2021) |
| 2 | Security Misconfiguration | A02:2025 | Moved up from #5 |
| 3 | Software Supply Chain Failures | A03:2025 | NEW - expands "Vulnerable and Outdated Components" to full supply chain |
| 4 | Cryptographic Failures | A04:2025 | Moved from #2 to #4 |
| 5 | Injection | A05:2025 | Moved from #3 to #5 |
| 6 | Insecure Design | A06:2025 | Moved from #4 to #6 |
| 7 | Authentication Failures | A07:2025 | Renamed - dropped "Identification and" |
| 8 | Software or Data Integrity Failures | A08:2025 | Renamed - "and" changed to "or" |
| 9 | Security Logging and Alerting Failures | A09:2025 | Renamed - emphasis on alerting |
| 10 | Mishandling of Exceptional Conditions | A10:2025 | NEW - fail-open logic, crashes, silent failures |

## Compliance Frameworks

Every finding is tagged with the applicable compliance references:

| Framework | Version | What It Provides |
|-----------|---------|-----------------|
| CWE | 4.x | Specific weakness IDs per finding (e.g., CWE-89 for SQL injection) |
| SANS/CWE Top 25 | 2025 | Flags findings matching the 25 most dangerous software weaknesses |
| OWASP ASVS | 5.0 | Maps findings to verification requirements across chapters (L1/L2/L3) |
| PCI DSS | 4.0.1 | Maps findings to payment card industry requirements (Req 2-12) |
| MITRE ATT&CK | v18 | Maps findings to attacker techniques (Initial Access through Impact) |
| SOC 2 | 2017 | Maps findings to Trust Service Criteria (CC6, CC7, CC8) |
| ISO 27001 | 2022 | Maps findings to Annex A controls (A.5-A.8) |
| NIST CSF | 2.0 | Maps findings to Govern, Identify, Protect, Detect, Respond, Recover |

## Additional Attack Categories

Beyond the OWASP Top 10, the audit also checks:

| Category | Maps to OWASP |
|----------|--------------|
| XSS (Stored, Reflected, DOM) | A05:2025 |
| CSRF | A01:2025 |
| File Upload & Storage | A01:2025, A06:2025 |
| API Security | A01:2025, A05:2025, A06:2025 |
| Business Logic Flaws | A06:2025 |
| AI/LLM Security | A05:2025, A01:2025, A04:2025 |
| WebSocket Security | A01:2025, A05:2025, A07:2025 |
| gRPC Security | A01:2025, A05:2025, A02:2025 |
| Serverless & Cloud-Native | A01:2025, A02:2025, A03:2025 |
| Infrastructure & DevOps | A02:2025, A03:2025, A08:2025 |

## Gray-Box Testing (6 areas)

| Area | What It Tests | OWASP |
|------|--------------|-------|
| Role-Based Access | Can lower-privilege roles reach higher-privilege endpoints? | A01:2025 |
| API Probing | Verb tampering, undocumented params, over-fetching, mass assignment | A01:2025, A06:2025 |
| Credential Boundaries | Expired tokens, revoked sessions, tenant isolation, password change effects | A07:2025 |
| Partial Knowledge | Hidden endpoints from routes, IDOR via migration schema, soft-deleted records | A01:2025, A06:2025 |
| Rate Limit Verification | Actual enforcement on login, registration, OTP, per-user vs per-IP | A06:2025, A07:2025 |
| Error Differentials | Resource existence leaks, inconsistent error formats, fail-open on errors | A01:2025, A10:2025 |

## Report Structure

1. Executive Summary (color-coded finding counts, risk assessment)
2. OWASP Top 10:2025 Coverage Matrix
3. NIST CSF 2.0 Coverage Matrix
4. Compliance Coverage (omitted with `--lite`)
5. 🔴 Critical & 🟠 High Findings (with code + fixes)
6. 🟡 Medium Findings
7. 🟢 Low & 🔵 Informational
8. 🔲 Gray-Box Findings (with role, endpoint, expected vs actual)
9. 📍 Security Hotspots (with PR review guidance)
10. 🧹 Code Smells (with refactoring suggestions)
11. Recommendations Summary (grouped by OWASP)
12. Methodology

## Contributing

1. Fork the repository
2. Follow conventions in `security-audit-guidelines.md`
3. No em-dashes, no comma before "and"
4. Submit a pull request

## License

MIT
