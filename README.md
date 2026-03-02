# Claude Security Audit

A Claude Code slash command for running comprehensive white-box and gray-box security audits on your projects, with findings mapped to OWASP Top 10:2025, CWE, NIST CSF 2.0, SANS/CWE Top 25, OWASP ASVS 4.0, PCI DSS 4.0, MITRE ATT&CK, SOC 2 and ISO 27001:2022.

## Features

- **Slash Command** - Run `/security-audit` in any project from Claude Code
- **Local Output** - Report saves to `./security-audit-report.md` in your project root
- **OWASP Top 10:2025 Coverage** - All 10 categories explicitly tested (A01-A10:2025)
- **CWE Mapping** - Every finding tagged with specific CWE IDs
- **NIST CSF 2.0 Mapping** - Every finding maps to Govern, Identify, Protect, Detect, Respond or Recover
- **Multi-Framework Compliance** - SANS/CWE Top 25, OWASP ASVS 4.0, PCI DSS 4.0, MITRE ATT&CK, SOC 2 and ISO 27001:2022
- **White-Box Testing** - 20 attack categories with 475+ individual checks
- **AI/LLM Security** - Prompt injection, output sanitization, RAG poisoning, cost monitoring, tool calling permissions
- **Diff Mode** - Scan only git-changed files for fast PR-level reviews
- **Gray-Box Testing** - Role-based access probing, API endpoint testing, credential boundary checks, error differential analysis
- **Security Hotspots** - Flags sensitive code that needs careful review during PRs
- **Code Smells** - Quality patterns that breed security bugs
- **Framework Detection** - Tailored checks for Laravel, Next.js, FastAPI, Express, Django, Rails, Spring Boot, ASP.NET Core, Go and Flask
- **Findings First** - Shows findings by default, append `--fix` to include remediation code blocks
- **Lite Mode** - Append `--lite` to reduce token usage (OWASP + CWE + NIST only, skips extra compliance mapping)
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
├── references/
│   ├── attack-vectors.md           # 475+ security checks (OWASP 2025 + NIST + CWE tagged)
│   ├── nist-csf-mapping.md         # OWASP 2025-to-NIST cross-reference tables
│   ├── compliance-mapping.md       # CWE, SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001
│   ├── custom-template.md          # Template for custom checks
│   └── frameworks/                 # Framework-specific checklists
│       ├── laravel.md
│       ├── nextjs.md
│       ├── fastapi.md
│       ├── express.md
│       ├── django.md
│       ├── rails.md
│       ├── spring-boot.md
│       ├── aspnet-core.md
│       ├── go.md
│       └── flask.md
├── security-audit-guidelines.md    # Severity ratings, conventions, framework detection
├── install.sh                      # One-command installer
├── CLAUDE.md                       # Project context for Claude Code
└── README.md
```

## Quick Install

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/afiqiqmal/claude-security-audit/main/install.sh | bash
```

### Manual Install

```bash
git clone https://github.com/afiqiqmal/claude-security-audit.git
cd claude-security-audit
bash install.sh
```

### Per-Project Install (no global)

```bash
cp -r .claude/commands/security-audit.md /path/to/your-project/.claude/commands/
```

When installed per-project, use `/project:security-audit`. Note: this copies only the command file. Reference files (`attack-vectors.md`, `compliance-mapping.md`, etc.) must be installed globally via `bash install.sh` for full and diff modes. Quick and lite modes work without references.

### Uninstall

```bash
bash install.sh --uninstall
```

Removes the command file, reference files, custom checks folder and guidelines.

## What Gets Installed

| File | Location | Purpose |
|------|----------|---------|
| `security-audit.md` | `~/.claude/commands/` | `/security-audit` slash command |
| `attack-vectors.md` | `~/.claude/security-audit-references/` | 475+ OWASP 2025/NIST/CWE-tagged security checks |
| `nist-csf-mapping.md` | `~/.claude/security-audit-references/` | OWASP 2025-to-NIST cross-reference tables |
| `compliance-mapping.md` | `~/.claude/security-audit-references/` | CWE, SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001 |
| `frameworks/*.md` | `~/.claude/security-audit-references/frameworks/` | 10 framework-specific checklists |
| `custom-template.md` | `~/.claude/security-audit-custom/` | Template for writing custom checks |
| `security-audit-guidelines.md` | `~/.claude/` | Severity ratings and conventions |

## Usage

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
```

By default, the report shows findings only (vulnerable code, impact and a text description of what to fix). Append `--fix` to include copy-paste-ready remediation code blocks. Append `--lite` to skip SANS Top 25, ASVS, PCI DSS, MITRE ATT&CK, SOC 2 and ISO 27001 mapping and reduce token usage.

### Output

Report saves to `./security-audit-report.md` in your project root. If a PDF converter is installed, it also saves `./security-audit-report.pdf`.

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
| `quick` | ~19K tokens | ~20-60K | ~10-25K | **~50-105K tokens** |
| `focus:auth` | ~15K tokens | ~15-40K | ~10-20K | **~40-75K tokens** |
| `diff` | ~19K tokens | ~5-20K | ~10-20K | **~35-60K tokens** |
| `full --lite` | ~19K tokens | ~40-120K | ~15-30K | **~75-170K tokens** |
| `full` | ~29K tokens | ~40-120K | ~20-40K | **~90-190K tokens** |
| `full --fix` | ~29K tokens | ~40-120K | ~30-60K | **~100-210K tokens** |

**Reference overhead breakdown** (tokens loaded before scanning starts):

| File | Tokens | Loaded In |
|------|--------|-----------|
| Command file (always loaded) | ~7K | All modes |
| `attack-vectors.md` | ~10K | `full`, `diff`, `phase:2` (skipped in `quick`) |
| `compliance-mapping.md` | ~7K | `full` only (skipped with `--lite`) |
| `nist-csf-mapping.md` | ~3K | `full`, `phase:2` (skipped with `--lite`) |
| `guidelines.md` | ~2K | All modes |
| Framework file (1 of 10) | ~1K | When framework detected |

Codebase scan tokens depend on your project size. A small project (10-20 files) uses ~20K scan tokens while a large project (200+ files) can use 100K+. The `diff` and `focus` modes significantly reduce scan tokens by limiting scope. Adding `--fix` increases report output by roughly 50% due to remediation code blocks.

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

## OWASP Top 10:2025 Coverage

| # | Category | OWASP ID | Key Changes from 2021 |
|---|----------|----------|----------------------|
| 1 | Broken Access Control | A01:2025 | Now includes SSRF (was separate A10:2021) |
| 2 | Security Misconfiguration | A02:2025 | Moved up from #5 |
| 3 | Software Supply Chain Failures | A03:2025 | NEW - expands "Vulnerable Components" to full supply chain |
| 4 | Cryptographic Failures | A04:2025 | Moved from #2 to #4 |
| 5 | Injection | A05:2025 | Moved from #3 to #5 |
| 6 | Insecure Design | A06:2025 | Moved from #4 to #6 |
| 7 | Identification and Auth Failures | A07:2025 | Unchanged |
| 8 | Software and Data Integrity Failures | A08:2025 | Unchanged |
| 9 | Security Logging and Alerting Failures | A09:2025 | Renamed - emphasis on alerting |
| 10 | Mishandling of Exceptional Conditions | A10:2025 | NEW - fail-open logic, crashes, silent failures |

## Compliance Frameworks

Every finding is tagged with the applicable compliance references:

| Framework | Version | What It Provides |
|-----------|---------|-----------------|
| CWE | 4.x | Specific weakness IDs per finding (e.g., CWE-89 for SQL injection) |
| SANS/CWE Top 25 | 2024 | Flags findings matching the 25 most dangerous software weaknesses |
| OWASP ASVS | 4.0 | Maps findings to 286 verification requirements across 14 chapters (L1/L2/L3) |
| PCI DSS | 4.0 | Maps findings to payment card industry requirements (Req 2-12) |
| MITRE ATT&CK | v15 | Maps findings to attacker techniques (Initial Access through Impact) |
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
