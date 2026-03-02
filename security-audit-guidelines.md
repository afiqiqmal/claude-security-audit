# Security Audit Guidelines

Global security audit standards for Claude Code projects. Defines the methodology, severity ratings, compliance mapping conventions and report format used by `/security-audit`.

## Severity Ratings

| Indicator | Rating | Criteria | Action |
|-----------|--------|----------|--------|
| 🔴 | CRITICAL | Remote code execution, auth bypass, full data breach, admin takeover | Fix tonight |
| 🟠 | HIGH | Privilege escalation, significant data exposure, account takeover | Fix this sprint |
| 🟡 | MEDIUM | XSS, CSRF, partial data exposure, IDOR with limited scope | Fix next sprint |
| 🟢 | LOW | Information disclosure, missing headers, minor misconfigurations | Schedule fix |
| 🔵 | INFO | Best practice recommendations, defense-in-depth suggestions | Consider adopting |

Emoji indicators are used throughout the report for visual severity scanning.

## Testing Types

| Type | Perspective | Knowledge Level | Phase |
|------|------------|----------------|-------|
| White-box | Full source code access | Complete | Phases 1-2 |
| Gray-box | Authenticated user with partial knowledge | Routes, roles, schema from migrations | Phase 3 |
| Hotspot analysis | Code reviewer perspective | Full source | Phase 4 |
| Smell detection | Architecture reviewer perspective | Full source | Phase 5 |

## OWASP Top 10:2025 Quick Reference

| ID | Category | Common Findings |
|----|----------|----------------|
| A01:2025 | Broken Access Control | IDOR, privilege escalation, CORS, CSRF, path traversal, SSRF |
| A02:2025 | Security Misconfiguration | Debug mode, default creds, missing headers, exposed admin |
| A03:2025 | Software Supply Chain Failures | Known CVEs, outdated deps, missing lock files, malicious packages, unverified builds |
| A04:2025 | Cryptographic Failures | Weak hashing, hardcoded secrets, missing encryption |
| A05:2025 | Injection | SQLi, XSS, command injection, SSTI, NoSQL injection |
| A06:2025 | Insecure Design | Missing rate limits, workflow bypass, race conditions, no threat modeling |
| A07:2025 | Authentication Failures | Session fixation, JWT flaws, brute force, weak reset flows |
| A08:2025 | Software or Data Integrity Failures | Insecure deserialization, CI/CD injection, unsigned webhooks |
| A09:2025 | Security Logging and Alerting Failures | No audit logs, sensitive data in logs, logging without alerting |
| A10:2025 | Mishandling of Exceptional Conditions | Fail-open logic, stack trace leaks, resource exhaustion, silent failures |

### Key Changes from OWASP 2021

- SSRF absorbed into A01 (no longer standalone A10:2021)
- Security Misconfiguration jumped from #5 to #2
- A03 is now **Software Supply Chain Failures** (was "Vulnerable and Outdated Components")
- A09 renamed to emphasize **Alerting** (not just monitoring)
- A10 is **NEW**: Mishandling of Exceptional Conditions (fail-open, crashes, silent failures)

## NIST CSF 2.0 Quick Reference

| Code | Function | What It Covers |
|------|----------|---------------|
| GV | Govern | Risk strategy, policy, roles, supply chain oversight |
| ID | Identify | Asset inventory, risk assessment, improvement planning |
| PR | Protect | Access control, data security, platform hardening, resilience |
| DE | Detect | Monitoring, anomaly detection, event analysis |
| RS | Respond | Incident management, analysis, mitigation |
| RC | Recover | Recovery planning, coordination |

## Compliance Frameworks Quick Reference

| Framework | Version | Tag Format | Example |
|-----------|---------|-----------|---------|
| OWASP Top 10 | 2025 | A01:2025 - A10:2025 | A05:2025 |
| CWE | 4.x | CWE-{ID} | CWE-89 |
| NIST CSF | 2.0 | {Function}.{Category} | PR.DS |
| SANS/CWE Top 25 | 2025 | SANS Top 25 #{rank} | SANS Top 25 #3 |
| OWASP ASVS | 5.0 | ASVS V{chapter}.{section}.{req} | ASVS V5.3.4 |
| PCI DSS | 4.0.1 | PCI DSS {req} | PCI DSS 6.2.4 |
| MITRE ATT&CK | v18 | T{ID} | T1190 |
| SOC 2 | 2017 | CC{X}.{Y} | CC6.1 |
| ISO 27001 | 2022 | A.{X}.{Y} | A.8.28 |

See `~/.claude/security-audit-references/compliance-mapping.md` for the full cross-reference tables.

## Audit Modes

| Mode | Phases | Description |
|------|--------|-------------|
| `full` (default) | 1-5 | All phases: recon + white-box + gray-box + hotspots + smells |
| `quick` | 1-2 | CRITICAL and HIGH only, no gray-box |
| `gray` | 1, 3 | Gray-box testing only |
| `focus:auth` | 1, 2, 4 | Authentication and authorization deep dive |
| `focus:api` | 1, 2, 4 | API security and input validation deep dive |
| `focus:config` | 1, 2, 4 | Configuration and infrastructure deep dive |
| `diff` / `diff:BRANCH` | 0, 1, 2, 4 | Scan only git-changed files |
| `recheck:PATH` | 1, 2, 4 | Re-audit specific files or directories |
| `triage` | none | Interactive triage of existing report |
| `phase:1` - `phase:5` | 1 + N | Run a single phase |

### Flags

| Flag | Effect |
|------|--------|
| `--fix` | Include copy-paste-ready remediation code blocks (off by default) |
| `--lite` | OWASP + CWE + NIST only, skip SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001 |
| `--fail-on LEVEL` | CI gating - output PASS/FAIL based on finding severity threshold (critical, high or medium) |
| `--format FORMAT` | Generate structured output alongside markdown (sarif or json) |
| `--update-baseline` | Write finding fingerprints to `.security-audit-baseline.json` for future comparison |
| `--diff-report PATH` | Compare new report with a previous report and show changes |
| `--pack NAME` | Load a compliance-specific check pack (hipaa, gdpr, fintech, saas-multi-tenant, soc2, education) |

### Scope Exclusions

Create a `.security-audit-ignore` file in the project root with gitignore-style patterns to exclude files from the audit. One pattern per line, `#` for comments, `!` for negation.

### Compliance Packs

| Pack | Focus Area |
|------|-----------|
| `hipaa` | PHI protection, access controls, audit trails, BAA requirements, breach notification |
| `gdpr` | Consent, data subject rights, data protection by design, international transfers, breach management |
| `fintech` | Transaction security, PCI DSS, fraud detection, regulatory compliance (KYC/AML) |
| `saas-multi-tenant` | Tenant isolation, cross-tenant vulnerabilities, resource limits, tenant administration |
| `soc2` | Trust Service Criteria (CC6-CC8), monitoring, change management, availability, vendor management |
| `education` | FERPA/COPPA student data, parental consent, directory information, age verification |

## Report Conventions

- Every finding must have OWASP Top 10:2025, CWE ID and NIST CSF mapping (other frameworks where applicable)
- One finding per issue (don't bundle multiple vulnerabilities)
- Show exact file path and line number
- Include vulnerable code; include fixed code only when `--fix` is set
- Use fenced code blocks with language identifiers
- Prefix IDs with emoji: `🔴 [CRITICAL-001]`, `🟠 [HIGH-001]`, `🟡 [MEDIUM-001]`, `🟢 [LOW-001]`, `🔵 [INFO-001]`, `[GRAY-001]`, `[HOTSPOT-001]`, `[SMELL-001]`
- Gray-box findings must include: role tested, endpoint, expected vs actual behavior
- Group recommendations by OWASP category in the summary

## Framework Detection

| Indicator | Framework | Extra Checks |
|-----------|-----------|-------------|
| `composer.json` + `artisan` | Laravel | Mass assignment, Blade escaping, .env, `DB::raw`, CSRF, SSRF in HTTP client, fail-open exception handler |
| `package.json` + `next.config` | Next.js | `NEXT_PUBLIC_*` secrets, `dangerouslySetInnerHTML`, SSRF in SSR, error boundaries |
| `requirements.txt` + `manage.py` | Django | `DEBUG=True`, raw SQL, pickle deserialization, CSRF exemptions |
| `package.json` + `express` | Express | Prototype pollution, NoSQL injection, helmet, `eval()`, unhandled rejections |
| `requirements.txt` + `fastapi` | FastAPI | Pydantic bypass, SSTI, `subprocess(shell=True)`, CORS, exception handlers |
| `Gemfile` + `config/routes.rb` | Ruby on Rails | `html_safe`, raw SQL, mass assignment, `protect_from_forgery`, strong params |
| `pom.xml` or `build.gradle` + `@SpringBootApplication` | Spring Boot | Actuator endpoints, SpEL injection, deserialization, CSRF config |
| `*.csproj` + `Program.cs` | ASP.NET Core | Anti-forgery, `FromSqlRaw`, Data Protection API, Kestrel config |
| `go.mod` + `gin` or `echo` or `fiber` | Go (Gin/Echo/Fiber) | `text/template` vs `html/template`, `os/exec`, SQL string concat, panic recovery |
| `requirements.txt` + `flask` | Flask | Jinja2 `\| safe`, `SECRET_KEY`, CSRF (Flask-WTF), debug mode, `pickle.loads()` |
| `package.json` + `nuxt.config` | Nuxt.js | `runtimeConfig.public` secrets, server routes auth, auto-import leaks, Nitro engine, head injection |
| `package.json` + `svelte.config` | SvelteKit | Server load functions, form actions, hooks auth, CSP config, `{@html}` sanitization, env handling |

## Guidelines Reference

This file is read by `/security-audit` when installed globally at `~/.claude/security-audit-guidelines.md`. It defines conventions that the slash command follows when generating reports.

## Output Location

Reports save to `./security-audit-report.md` in the project root. If a PDF converter is installed (pandoc, wkhtmltopdf, weasyprint or md-to-pdf), a PDF version is also generated at `./security-audit-report.pdf`.

Additional output files (generated when corresponding flags are used):

| File | Generated By |
|------|-------------|
| `security-audit-report.sarif` | `--format sarif` |
| `security-audit-report.json` | `--format json` |
| `security-audit-triage.md` | `triage` mode |
| `.security-audit-baseline.json` | `--update-baseline` |

Add to `.gitignore` if reports should not be committed, or commit them as part of your security review workflow.
