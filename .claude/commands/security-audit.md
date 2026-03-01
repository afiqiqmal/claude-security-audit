---
allowed-tools: Read, Grep, Glob, Bash(grep:*), Bash(find:*), Bash(cat:*), Bash(wc:*), Bash(head:*), Bash(tail:*), Bash(composer:*), Bash(npm:*), Bash(pip:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), Bash(curl:*)
description: Run a comprehensive white-box and gray-box security audit on the current project with OWASP Top 10:2025 and NIST CSF 2.0 mapping, security hotspots, code smells and actionable remediation. Outputs report to project directory.
argument-hint: "[full|quick|gray|diff|diff:branch|focus:auth|focus:api|focus:config]"
---

# Security Audit Command

You are an expert application security engineer. Perform a white-box and gray-box security audit on THIS project, scanning every attack surface. Map all findings to both OWASP Top 10:2025 and NIST Cybersecurity Framework (CSF) 2.0.

## Mode Selection

Based on `$ARGUMENTS`:
- **full** (default if empty) - White-box + gray-box audit across all categories, hotspots and smells
- **quick** - CRITICAL and HIGH severity issues only, skip hotspots, smells and gray-box
- **gray** - Gray-box testing only (role-based access, API probing, credential boundaries)
- **focus:auth** - Deep dive on authentication and authorization
- **focus:api** - Deep dive on API security, input validation and rate limiting
- **diff** - Scan only files changed since last commit (`git diff HEAD`), skip gray-box and smells
- **diff:BRANCH** - Scan only files changed compared to a branch (e.g., `diff:main`), skip gray-box and smells
- **focus:config** - Deep dive on configuration, supply chain and infrastructure

## Framework Mapping

Tag every finding with both:

### OWASP Top 10:2025

- **A01:2025** - Broken Access Control (includes SSRF)
- **A02:2025** - Security Misconfiguration
- **A03:2025** - Software Supply Chain Failures
- **A04:2025** - Cryptographic Failures
- **A05:2025** - Injection
- **A06:2025** - Insecure Design
- **A07:2025** - Identification and Authentication Failures
- **A08:2025** - Software and Data Integrity Failures
- **A09:2025** - Security Logging and Alerting Failures
- **A10:2025** - Mishandling of Exceptional Conditions

### NIST CSF 2.0

- **GV (Govern)** - GV.OC, GV.RM, GV.RR, GV.PO, GV.OV, GV.SC
- **ID (Identify)** - ID.AM, ID.RA, ID.IM
- **PR (Protect)** - PR.AA, PR.DS, PR.PS, PR.IR
- **DE (Detect)** - DE.CM, DE.AE
- **RS (Respond)** - RS.MA, RS.AN, RS.MI
- **RC (Recover)** - RC.RP, RC.CO

Read `~/.claude/security-audit-references/nist-csf-mapping.md` for the full mapping table if available.

## Audit Workflow

### Phase 0: Diff Scoping (diff mode only)

If `$ARGUMENTS` starts with `diff`:
1. If `diff:BRANCH` - run `git diff BRANCH...HEAD --name-only` to get changed files
2. If `diff` (no branch) - run `git diff HEAD --name-only` for uncommitted changes, plus `git diff HEAD~1 --name-only` for the last commit
3. Store the list of changed files - all subsequent phases scan ONLY these files
4. Skip Phase 3 (gray-box) and Phase 5 (code smells) - they are not useful at diff scope
5. Still run Phase 4 (hotspots) on changed files - this is valuable for PR review
6. In the report, note which files were scanned and the diff reference used

### Phase 1: Reconnaissance [NIST: ID | OWASP: all]

1. Map the project structure - list all directories, identify frameworks and languages
2. Identify the tech stack - framework version, ORM, auth library, session handling, template engine, API style, job queues, caching
3. Find all entry points - routes, controllers, API endpoints, middleware, CLI commands, queue workers, webhooks
4. Trace data flow - where does user input enter, get stored, get rendered or returned?
5. Check configuration files - `.env`, `config/`, `docker-compose.yml`, CI/CD pipelines
6. Identify user roles and permission levels defined in the system

### Phase 2: White-Box Attack Surface Analysis [NIST: ID + PR]

Read `~/.claude/security-audit-references/attack-vectors.md` for the full checklist if available.

Categories in priority order (aligned with OWASP Top 10:2025):

1. **Broken Access Control** [A01:2025 | PR.AA] - IDOR, privilege escalation, missing middleware, role bypass, horizontal/vertical access violations, CORS misconfiguration, metadata manipulation, SSRF (user-controlled URL fetching, cloud metadata endpoints 169.254.169.254, DNS rebinding, redirect following to internal services)
2. **Security Misconfiguration** [A02:2025 | PR.PS] - Debug mode, default credentials, exposed admin panels, missing security headers, permissive CORS, directory listing, unnecessary features enabled, verbose error pages, exposed .git directory
3. **Software Supply Chain Failures** [A03:2025 | GV.SC] - Known CVEs in dependencies, outdated packages, missing lock files, typosquatting, malicious packages, unverified build inputs, compromised CI/CD plugins, post-install script abuse, unmaintained transitive dependencies, unverified container base images
4. **Cryptographic Failures** [A04:2025 | PR.DS] - Weak hashing, plaintext secrets, missing encryption at rest/transit, deprecated algorithms, hardcoded keys, exposed secrets in client bundles, weak TLS configuration
5. **Injection** [A05:2025 | PR.DS] - SQL, NoSQL, command, LDAP, XPath, template (SSTI), header, expression language injection, stored/reflected/DOM XSS, CSRF
6. **Insecure Design** [A06:2025 | GV.RM] - Missing threat modeling, insecure business flows, missing rate limits on high-value operations, no abuse case testing, trust boundary violations, no re-authentication for sensitive ops, race conditions by design
7. **Identification and Authentication Failures** [A07:2025 | PR.AA] - Weak passwords, missing brute force protection, session fixation, insecure token generation, missing MFA, credential stuffing gaps, insecure password reset, OAuth state validation
8. **Software and Data Integrity Failures** [A08:2025 | PR.DS] - Insecure deserialization, CI/CD pipeline injection, missing code signing, auto-update without verification, unsigned webhooks, untrusted data in build pipelines
9. **Security Logging and Alerting Failures** [A09:2025 | DE.CM] - Missing audit logs for auth events, no log integrity protection, insufficient alerting on security events, sensitive data in logs, missing request tracing, no alerting on repeated auth failures, great logging but no alerting
10. **Mishandling of Exceptional Conditions** [A10:2025 | DE.AE] - Fail-open logic (granting access on error), error messages leaking secrets or stack traces, NULL dereference crashes, unhandled resource exhaustion, missing timeout handling, inconsistent error responses, silent failures masking security events, failing to detect or respond to abnormal conditions
11. **File Upload & Storage** [A01:2025, A06:2025 | PR.DS] - Unrestricted types, path traversal, executable uploads, public buckets
12. **API Security** [A01:2025, A05:2025, A06:2025 | PR.AA] - Rate limiting, validation, error verbosity, broken object-level auth, excessive data exposure
13. **Business Logic Flaws** [A06:2025 | PR.DS] - Race conditions, price manipulation, workflow bypass, integer overflow
14. **Infrastructure & DevOps** [A02:2025, A03:2025, A08:2025 | PR.PS] - Dockerfile security, exposed ports, secrets in git, CI/CD injection, overly permissive IAM
15. **AI/LLM Security** [A05:2025, A01:2025, A04:2025 | PR.DS, PR.AA] - Prompt injection (direct and indirect), PII sent to external AI APIs, AI output rendered without sanitization (XSS via LLM), tool/function calling without permission checks, RAG data poisoning, missing cost/abuse monitoring, API key leakage for AI services, fail-open when AI service is down

For dependency checks: `composer audit`, `npm audit`, `pip audit`.
For git secrets: `git log -p --all -S 'password' --since="1 year ago"`.

### Phase 3: Gray-Box Testing [NIST: PR + DE | OWASP: A01:2025, A06:2025, A07:2025]

Test the application from the perspective of an authenticated user with partial system knowledge. Use what you learned in reconnaissance (routes, roles, database schema from migrations) to probe boundaries.

**Role-Based Access Testing** [A01:2025 | PR.AA]:
- Identify all defined roles from code (models, enums, migrations, seeders, config)
- For every protected route/endpoint, verify which roles can actually access it vs which roles should
- Check if lower-privilege roles can access higher-privilege endpoints by manipulating request parameters
- Test if role checks are enforced at the controller/middleware level or only in the UI/frontend
- Verify that role downgrade mid-session (e.g. admin removes own admin role) takes immediate effect

**API Endpoint Probing** [A01:2025, A06:2025 | PR.AA, PR.DS]:
- Test all endpoints with GET/POST/PUT/PATCH/DELETE to check verb tampering
- Look for undocumented query parameters by reading controller code and trying params that exist in validation but are not in API docs
- Check if API responses return more fields than the frontend consumes (over-fetching)
- Test pagination boundaries - what happens with `page=-1`, `per_page=999999`, `offset=0`
- Send requests with extra fields not in the validation rules to test mass assignment from the outside

**Credential and Session Boundary Testing** [A07:2025 | PR.AA, PR.DS]:
- Check what happens when a token expires mid-request in a multi-step flow
- Test if a revoked/deleted user's existing sessions are immediately invalidated
- Verify tenant isolation - can tenant A's auth token access tenant B's data?
- Test if downgraded API keys still retain previous permission scope
- Check if password change invalidates all other active sessions
- Verify "remember me" token rotation and expiration

**Partial Knowledge Exploitation** [A01:2025, A06:2025 | PR.AA]:
- Use database migration files to identify table structures, then craft targeted IDOR payloads using known column names and relationships
- Use route files to identify hidden/undocumented endpoints (routes registered but not in docs or UI)
- Check if soft-deleted records are accessible via API by guessing IDs from sequences
- Test if internal-only endpoints (health checks, metrics, debug routes) are reachable externally

**Rate Limit and Throttle Verification** [A06:2025, A07:2025 | PR.AA, DE.CM]:
- Test actual rate limit enforcement on login, registration, password reset and OTP endpoints
- Verify rate limits apply per-user, not just per-IP (can an attacker rotate IPs?)
- Check if rate limit headers (`X-RateLimit-*`, `Retry-After`) leak information about limits
- Test if rate limits reset on success (allowing slow brute force)

**Error Response Differential Analysis** [A01:2025, A10:2025 | PR.DS, DE.AE]:
- Compare error responses between different roles for the same forbidden resource
- Check if "not found" vs "forbidden" responses leak resource existence
- Verify error format consistency (does a 403 on one endpoint return JSON while another returns HTML?)
- Test if verbose errors appear only for certain auth states
- Check if error responses fail open (granting access when an error occurs)
- Verify that exceptional conditions (timeouts, resource exhaustion) don't bypass security controls

For each gray-box finding, include:
- The role/context tested from
- The endpoint and HTTP method
- The expected behavior vs actual behavior
- The exact request that demonstrates the issue

### Phase 4: Security Hotspots [NIST: ID + GV | OWASP: A06:2025]

(Skip in `quick` and `gray` modes)

Flag sensitive code areas that are not vulnerable today but would break if modified carelessly:

- Crypto and hashing [PR.DS | A04:2025]
- Auth boundaries [PR.AA | A07:2025]
- Permission checks [PR.AA | A01:2025]
- Dynamic code execution [PR.DS | A05:2025]
- Input/output boundaries [PR.DS | A05:2025]
- Database query construction [PR.DS | A05:2025]
- File system operations [PR.DS | A01:2025]
- Third-party integrations [GV.SC | A03:2025, A08:2025]
- Security configuration [PR.PS | A02:2025]
- Error handling and failure modes [DE.AE | A09:2025, A10:2025]
- AI/LLM integration points [PR.DS | A05:2025, A01:2025] - prompt construction, output rendering, tool calling, RAG retrieval boundaries

### Phase 5: Code Smells [NIST: GV + PR | OWASP: A06:2025]

(Skip in `quick` and `gray` modes)

**Structural** [GV.RM | A06:2025]: God classes over 500 lines, duplicated security logic, missing abstractions, dead code with active routes
**Data handling** [PR.DS | A01:2025, A05:2025]: Overly permissive models, raw JSON output, inconsistent validation
**Error handling** [DE.AE | A09:2025, A10:2025]: Catch-all swallowing, verbose responses, fail-open patterns, missing error handling on external calls, silent failures
**Dependencies** [GV.SC | A03:2025]: Unused packages, wildcard versions, duplicate libraries, unverified transitive deps
**Design** [GV.RM | A06:2025]: Missing input validation layer, no separation of public vs authenticated routes, business logic in controllers

### Phase 6: Deep Dive (for each finding)

1. **Locate** - Exact file, line number and code snippet
2. **Explain the attack** - Step-by-step conceptual proof-of-concept
3. **Assess impact** - What data is at risk? Can the attacker escalate?
4. **Rate severity** - CRITICAL / HIGH / MEDIUM / LOW / INFO
5. **Map to OWASP** - A01:2025 through A10:2025
6. **Map to NIST CSF 2.0** - Function and category
7. **Write the fix** - Real, copy-paste-ready code patches

### Phase 7: Generate Report

Save the report to `./security-audit-report.md` in the project root.

```markdown
# Security Audit Report

**Project**: [name]
**Date**: [today's date]
**Auditor**: Claude Security Audit
**Frameworks**: OWASP Top 10:2025 + NIST CSF 2.0
**Mode**: [full/quick/gray/focus:X]

---

## Executive Summary

- Total findings: X
- Critical: X | High: X | Medium: X | Low: X | Info: X
- Gray-box findings: X
- Security hotspots: X
- Code smells: X
- Overall risk assessment: [sentence summary]

## OWASP Top 10:2025 Coverage

| OWASP ID | Category | Findings | Status |
|----------|----------|----------|--------|
| A01:2025 | Broken Access Control | X | [needs attention / acceptable] |
| A02:2025 | Security Misconfiguration | X | [needs attention / acceptable] |
| A03:2025 | Software Supply Chain Failures | X | [needs attention / acceptable] |
| A04:2025 | Cryptographic Failures | X | [needs attention / acceptable] |
| A05:2025 | Injection | X | [needs attention / acceptable] |
| A06:2025 | Insecure Design | X | [needs attention / acceptable] |
| A07:2025 | Identification and Auth Failures | X | [needs attention / acceptable] |
| A08:2025 | Software and Data Integrity Failures | X | [needs attention / acceptable] |
| A09:2025 | Security Logging and Alerting Failures | X | [needs attention / acceptable] |
| A10:2025 | Mishandling of Exceptional Conditions | X | [needs attention / acceptable] |

## NIST CSF 2.0 Coverage

| Function | Categories | Findings | Status |
|----------|-----------|----------|--------|
| GV (Govern) | GV.RM, GV.SC | X | [needs attention / acceptable] |
| ID (Identify) | ID.AM, ID.RA | X | [needs attention / acceptable] |
| PR (Protect) | PR.AA, PR.DS, PR.PS | X | [needs attention / acceptable] |
| DE (Detect) | DE.CM, DE.AE | X | [needs attention / acceptable] |
| RS (Respond) | RS.MA | X | [needs attention / acceptable] |
| RC (Recover) | RC.RP | X | [needs attention / acceptable] |

## Critical & High Findings

### [CRITICAL-001] Title
- **Severity**: CRITICAL
- **OWASP**: A05:2025 (Injection)
- **NIST CSF**: PR.DS (Data Security)
- **Location**: `path/to/file:123`
- **Attack Vector**: [step-by-step]
- **Impact**: [consequences]
- **Vulnerable Code**:
  [code block]
- **Remediation**:
  [fixed code block]

## Medium Findings
[same format]

## Low & Informational Findings
[condensed format]

## Gray-Box Findings

### [GRAY-001] Title
- **Severity**: [rating]
- **OWASP**: [A01:2025/A06:2025/A07:2025]
- **NIST CSF**: [category]
- **Tested As**: [role/context]
- **Endpoint**: `[METHOD] /path`
- **Expected**: [what should happen]
- **Actual**: [what actually happens]
- **Request**: [the exact request demonstrating the issue]
- **Remediation**:
  [fixed code block]

## Security Hotspots
### [HOTSPOT-001] Title
- **OWASP**: [relevant]
- **NIST CSF**: [category]
- **Location**: `path/to/file:45-120`
- **Why sensitive**: [explanation]
- **Risk if modified**: [what could go wrong]
- **Review guidance**: [what to watch in PRs]

## Code Smells
### [SMELL-001] Title
- **OWASP**: [relevant, typically A06:2025]
- **NIST CSF**: [category]
- **Location**: `path/to/file`
- **Pattern**: [what was found]
- **Security implication**: [why it matters]
- **Refactoring**:
  [code suggestion]

## Recommendations Summary
[prioritized action items grouped by OWASP category]

## Methodology
- White-box: [categories checked]
- Gray-box: [roles tested, endpoints probed]
- OWASP Top 10:2025 coverage: [X/10 categories]
- NIST CSF 2.0 coverage: [functions covered]
```

## Execution Rules

1. Read every route, controller, model, middleware, config, migration and seeder
2. Every finding must reference actual code with file path and line number
3. Every finding must include a copy-paste-ready fix
4. Every finding must have both OWASP Top 10:2025 and NIST CSF mapping
5. Gray-box findings must include the role tested, endpoint, expected vs actual behavior
6. If an area is clean, say so explicitly
7. Don't fabricate findings - false positives waste time
8. Critical and high findings go first
9. Save report to `./security-audit-report.md` in the project root

After saving the report, tell the developer:
- How many findings by severity
- OWASP categories with issues
- The top 3 most urgent items to fix
- Where the full report is saved
