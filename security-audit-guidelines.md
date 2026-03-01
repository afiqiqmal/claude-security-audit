# Security Audit Guidelines

Global security audit standards for Claude Code projects. Defines the methodology, severity ratings, OWASP/NIST mapping conventions and report format used by `/security-audit`.

## Severity Ratings

| Rating | Criteria | Action |
|--------|----------|--------|
| CRITICAL | Remote code execution, auth bypass, full data breach, admin takeover | Fix tonight |
| HIGH | Privilege escalation, significant data exposure, account takeover | Fix this sprint |
| MEDIUM | XSS, CSRF, partial data exposure, IDOR with limited scope | Fix next sprint |
| LOW | Information disclosure, missing headers, minor misconfigurations | Schedule fix |
| INFO | Best practice recommendations, defense-in-depth suggestions | Consider adopting |

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
| A07:2025 | Identification and Auth Failures | Session fixation, JWT flaws, brute force, weak reset flows |
| A08:2025 | Software and Data Integrity Failures | Insecure deserialization, CI/CD injection, unsigned webhooks |
| A09:2025 | Security Logging and Alerting Failures | No audit logs, sensitive data in logs, logging without alerting |
| A10:2025 | Mishandling of Exceptional Conditions | Fail-open logic, stack trace leaks, resource exhaustion, silent failures |

### Key Changes from OWASP 2021

- SSRF absorbed into A01 (no longer standalone A10:2021)
- Security Misconfiguration jumped from #5 to #2
- A03 is now **Software Supply Chain Failures** (was "Vulnerable Components")
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

## Report Conventions

- Every finding must have both OWASP Top 10:2025 and NIST mapping
- One finding per issue (don't bundle multiple vulnerabilities)
- Show exact file path and line number
- Include both vulnerable code and fixed code
- Use fenced code blocks with language identifiers
- Prefix IDs: `[CRITICAL-001]`, `[HIGH-001]`, `[GRAY-001]`, `[HOTSPOT-001]`, `[SMELL-001]`
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

## Output Location

Reports save to `./security-audit-report.md` in the project root. Add to `.gitignore` if reports should not be committed, or commit them as part of your security review workflow.
