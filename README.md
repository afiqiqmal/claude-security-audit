# Claude Security Audit

A Claude Code slash command for running comprehensive white-box and gray-box security audits on your projects, with findings mapped to OWASP Top 10:2025 and NIST CSF 2.0.

## Features

- **Slash Command** - Run `/security-audit` in any project from Claude Code
- **Local Output** - Report saves to `./security-audit-report.md` in your project root
- **OWASP Top 10:2025 Coverage** - All 10 categories explicitly tested (A01-A10:2025)
- **NIST CSF 2.0 Mapping** - Every finding maps to Govern, Identify, Protect, Detect, Respond or Recover
- **White-Box Testing** - 18 attack categories with 850+ individual checks
- **AI/LLM Security** - Prompt injection, output sanitization, RAG poisoning, cost monitoring, tool calling permissions
- **Diff Mode** - Scan only git-changed files for fast PR-level reviews
- **Gray-Box Testing** - Role-based access probing, API endpoint testing, credential boundary checks, error differential analysis
- **Security Hotspots** - Flags sensitive code that needs careful review during PRs
- **Code Smells** - Quality patterns that breed security bugs
- **Framework Detection** - Tailored checks for Laravel, Next.js, FastAPI, Express, Django, Rails, Spring Boot, ASP.NET Core, Go and Flask
- **Findings First** - Shows findings by default, append `--fix` to include remediation code blocks
- **Custom Checks** - Add your own `.md` checklists globally or per-project
- **Multiple Modes** - Full audit, quick scan, gray-box only, or focused deep dives

## What's Included

```
claude-security-audit/
├── .claude/
│   └── commands/
│       └── security-audit.md       # /security-audit slash command
├── references/
│   ├── attack-vectors.md           # 850+ security checks (OWASP 2025 + NIST tagged)
│   ├── nist-csf-mapping.md         # OWASP 2025-to-NIST cross-reference tables
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

When installed per-project, use `/project:security-audit`.

## What Gets Installed

| File | Location | Purpose |
|------|----------|---------|
| `security-audit.md` | `~/.claude/commands/` | `/security-audit` slash command |
| `attack-vectors.md` | `~/.claude/security-audit-references/` | 850+ OWASP 2025/NIST-tagged security checks |
| `nist-csf-mapping.md` | `~/.claude/security-audit-references/` | OWASP 2025-to-NIST cross-reference tables |
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

# Include code fixes in the report (off by default)
/security-audit --fix          # Full audit with remediation code blocks
/security-audit quick --fix    # Quick scan with fixes
/security-audit diff:main --fix
```

By default, the report shows findings only (vulnerable code, impact and a text description of what to fix). Append `--fix` to include copy-paste-ready remediation code blocks.

### Output

Report saves to `./security-audit-report.md` in your project root.

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

1. Executive Summary (finding counts, risk assessment)
2. OWASP Top 10:2025 Coverage Matrix
3. NIST CSF 2.0 Coverage Matrix
4. Critical & High Findings (with code + fixes)
5. Medium Findings
6. Low & Informational
7. Gray-Box Findings (with role, endpoint, expected vs actual)
8. Security Hotspots (with PR review guidance)
9. Code Smells (with refactoring suggestions)
10. Recommendations Summary (grouped by OWASP)
11. Methodology

## Contributing

1. Fork the repository
2. Follow conventions in `security-audit-guidelines.md`
3. No em-dashes, no comma before "and"
4. Submit a pull request

## License

MIT
