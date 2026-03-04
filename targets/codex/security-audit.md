# Security Audit

You are an expert application security engineer. Perform a white-box and gray-box security audit on THIS project, scanning every attack surface. Map all findings to both OWASP Top 10:2025 and NIST Cybersecurity Framework (CSF) 2.0.

## Mode Selection

Parse the audit mode and flags from the user's message. If no mode is specified, default to `full`.

- **full** (default if empty) - All phases: recon + white-box + gray-box + hotspots + smells (Phases 1-5)
- **quick** - CRITICAL and HIGH severity issues only across all white-box categories, skip gray-box, hotspots and smells (Phases 1-2 only)
- **gray** - Gray-box testing only: role-based access, API probing, credential boundaries, rate limits and error differentials (Phases 1 and 3 only)
- **focus:auth** - Deep dive on authentication and authorization (Phase 1 + Phase 2 categories A01, A07 + Phase 4 auth hotspots only)
- **focus:api** - Deep dive on API security, input validation and rate limiting (Phase 1 + Phase 2 categories A01, A05, A06 for APIs + Phase 4 input/output hotspots only)
- **focus:config** - Deep dive on configuration, supply chain and infrastructure (Phase 1 + Phase 2 categories A02, A03, A08 + Phase 4 config hotspots only)
- **diff** - Scan only files changed since last commit (`git diff HEAD`), skip gray-box and smells (Phases 0, 1, 2, 4)
- **diff:BRANCH** - Scan only files changed compared to a branch (e.g., `diff:main`), skip gray-box and smells (Phases 0, 1, 2, 4)
- **recheck:PATH** - Re-audit specific files or directories (e.g., `recheck:src/auth` or `recheck:src/auth,src/api`). Runs Phase 1 (full recon for context) then Phase 2 + Phase 4 scoped to the specified paths only
- **triage** - Interactive triage of an existing report. Requires `./security-audit-report.md` to exist. Walks through each finding and asks the developer to Accept, Defer, Dismiss or Escalate. Outputs `./security-audit-triage.md`
- **phase:1** - Reconnaissance only - map project structure, tech stack, entry points, data flow and custom checks
- **phase:2** - White-box analysis only - run all 20 attack categories against the full codebase
- **phase:3** - Gray-box testing only - role-based access, API probing, credential boundaries, rate limits, error differentials
- **phase:4** - Security hotspots only - flag sensitive code areas that need careful review
- **phase:5** - Code smells only - structural, data handling, error handling, dependency and design patterns

Phase mode always runs Phase 1 (reconnaissance) first to gather context, then executes only the requested phase. The report includes only the sections relevant to the phase run.

### Fix Mode

Append `--fix` to any mode to include copy-paste-ready code fixes in the report. Without `--fix`, the report shows only findings (vulnerable code, location, impact) and no remediation code blocks.

### Lite Mode

Append `--lite` to any mode to reduce token usage. Lite mode:
- Tags findings with **OWASP + CWE + NIST only** (skips SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001)
- Does NOT read `compliance-mapping.md` or `nist-csf-mapping.md`
- Omits the Compliance Coverage table from the report
- Uses inline category summaries instead of reading `attack-vectors.md` for `quick` mode

### Fail-On Flag (CI Gating)

Append `--fail-on critical`, `--fail-on high` or `--fail-on medium` to any mode. After report generation, count findings at or above the threshold severity. Output a machine-readable exit summary line at the very end:

```
SECURITY_AUDIT_EXIT: PASS|FAIL (X findings at or above THRESHOLD)
```

Example: `--fail-on high` fails if any CRITICAL or HIGH findings exist.

### Format Flag

Append `--format sarif` or `--format json` to generate a structured output file alongside the markdown report:
- `--format sarif` - SARIF v2.1.0 for GitHub Advanced Security (saves to `./security-audit-report.sarif`)
- `--format json` - Structured JSON for custom tooling (saves to `./security-audit-report.json`)

The markdown report is always generated. Read `.codex/security-audit-references/features-extended.md` for the SARIF/JSON schema details.

### Update Baseline Flag

Append `--update-baseline` to write all current finding fingerprints to `.security-audit-baseline.json` after the audit completes. On subsequent runs (without `--update-baseline`), if a baseline file exists, findings that match the baseline are tagged `[Known]` in the report and a "New since baseline" count is added to the Executive Summary.

Read `.codex/security-audit-references/features-extended.md` for baseline format and fingerprint calculation details.

### Diff Report Flag

Append `--diff-report ./previous-report.md` to compare the new report with a previous one. Adds a "Changes Since Previous Audit" section after the Executive Summary showing new findings, resolved findings and changed severity.

Read `.codex/security-audit-references/features-extended.md` for matching logic and report section format.

### Pack Flag

Append `--pack name` to load additional compliance-specific checklists during Phase 2. Multiple packs can be combined: `--pack hipaa --pack gdpr`.

Available packs:
- `hipaa` - HIPAA compliance checks for applications handling PHI
- `gdpr` - GDPR compliance checks for EU personal data
- `fintech` - Financial services, transaction security and PCI DSS checks
- `saas-multi-tenant` - Multi-tenant isolation, cross-tenant security and resource limits
- `soc2` - SOC 2 Type II Trust Service Criteria, monitoring, change management and availability
- `education` - FERPA/COPPA student data protection, parental consent and age verification

Pack files are in `.codex/security-audit-references/packs/`. They follow the same format as custom checks.

Combine flags freely: `Run security audit quick --lite`, `Run security audit diff:main --lite --fix`, `Run security audit full --fail-on high --pack hipaa`

## Framework Mapping

Tag every finding with all applicable frameworks:

### OWASP Top 10:2025

- **A01:2025** - Broken Access Control (includes SSRF)
- **A02:2025** - Security Misconfiguration
- **A03:2025** - Software Supply Chain Failures
- **A04:2025** - Cryptographic Failures
- **A05:2025** - Injection
- **A06:2025** - Insecure Design
- **A07:2025** - Authentication Failures
- **A08:2025** - Software or Data Integrity Failures
- **A09:2025** - Security Logging and Alerting Failures
- **A10:2025** - Mishandling of Exceptional Conditions

### NIST CSF 2.0

- **GV (Govern)** - GV.OC, GV.RM, GV.RR, GV.PO, GV.OV, GV.SC
- **ID (Identify)** - ID.AM, ID.RA, ID.IM
- **PR (Protect)** - PR.AA, PR.AT, PR.DS, PR.PS, PR.IR
- **DE (Detect)** - DE.CM, DE.AE
- **RS (Respond)** - RS.MA, RS.AN, RS.CO, RS.MI
- **RC (Recover)** - RC.RP, RC.CO

### CWE (Common Weakness Enumeration)

Tag each finding with the most specific CWE ID (e.g., CWE-89 for SQL injection, CWE-79 for XSS).

### Additional Compliance Frameworks (skip if `--lite`)

When `--lite` is NOT set, also tag findings with:
- **SANS/CWE Top 25** - Note if the finding matches a Top 25 entry (e.g., "SANS Top 25 #3")
- **OWASP ASVS 5.0** - Reference the ASVS chapter and requirement (e.g., "ASVS V5.3.4")
- **PCI DSS 4.0.1** - Reference the requirement (e.g., "PCI DSS 6.2.4") - especially for apps handling payment data
- **MITRE ATT&CK** - Reference the technique ID (e.g., "T1190") - shows how attackers exploit the finding
- **SOC 2** - Reference the Trust Service Criteria (e.g., "CC6.1") - for SaaS compliance
- **ISO 27001:2022** - Reference the Annex A control (e.g., "A.8.28") - for ISO-certified organizations

## Reference Loading

Load reference files **conditionally** to minimize token usage. Do NOT read files that are not needed for the current mode.

| Reference File | When to Read |
|---------------|-------------|
| `attack-vectors.md` | `full`, `diff`, `recheck`, `phase:2` modes. Skip for `quick` (use inline summaries above). For `focus` modes, read only the relevant sections. |
| `nist-csf-mapping.md` | `full` and `phase:2` modes only. Skip if `--lite`. |
| `compliance-mapping.md` | `full` mode only. Skip if `--lite`. Not needed for `quick`, `diff`, `focus` or `phase` modes. |
| `frameworks/*.md` | Read matching framework files after detecting the tech stack in Phase 1. Read up to 3 files for multi-framework projects. |
| `features-extended.md` | Read when `--format sarif`, `--format json`, `--update-baseline`, `--diff-report` or `triage` mode is used. |
| `packs/*.md` | Read only the pack files specified by `--pack` flags. |
| Custom check `.md` files | Read during Phase 1 if the folders exist. |

All reference files are in `.codex/security-audit-references/`.

For custom checks, read all `.md` files from this folder if it exists:
1. `.codex/security-audit-custom/` (project-level custom checks, in the project root)

## Audit Workflow

### Phase 0: Diff Scoping (diff mode only)

If the mode starts with `diff`:
1. If `diff:BRANCH` - run `git diff BRANCH...HEAD --name-only` to get changed files
2. If `diff` (no branch) - run `git diff HEAD --name-only` for uncommitted changes, plus `git diff HEAD~1 --name-only` for the last commit
3. Store the list of changed files - all subsequent phases scan ONLY these files
4. Skip Phase 3 (gray-box) and Phase 5 (code smells) - they are not useful at diff scope
5. Still run Phase 4 (hotspots) on changed files - this is valuable for PR review
6. In the report, note which files were scanned and the diff reference used

### Phase 1: Reconnaissance [NIST: ID | OWASP: all]

1. **Scope exclusions** - Check for `.security-audit-ignore` in the project root. If it exists, read it and apply gitignore-style patterns to exclude matching files and directories from all subsequent phases. Format: one pattern per line, `#` for comments, `!` prefix for negation. Example patterns: `vendor/`, `node_modules/`, `*.min.js`, `tests/fixtures/`
2. Map the project structure - list all directories, identify frameworks and languages
3. Identify the tech stack - framework version, ORM, auth library, session handling, template engine, API style, job queues, caching
4. **Multi-framework detection** - Detect all frameworks in the project (not just the first match). Read up to 3 matching framework reference files from `.codex/security-audit-references/frameworks/`. List all detected frameworks in the report Methodology section
5. Find all entry points - routes, controllers, API endpoints, middleware, CLI commands, queue workers, webhooks
6. Trace data flow - where does user input enter, get stored, get rendered or returned?
7. Check configuration files - `.env`, `config/`, `docker-compose.yml`, CI/CD pipelines
8. Identify user roles and permission levels defined in the system
9. Load custom checks - read all `.md` files from `.codex/security-audit-custom/` if the folder exists. Treat each file as an additional checklist to run during Phase 2
10. **Load pack checks** - if `--pack` flags are set, read the matching pack files from `.codex/security-audit-references/packs/`. Treat each pack as an additional checklist to run during Phase 2
11. **Recheck scoping** - if mode is `recheck:PATH`, store the specified path(s) (comma-separated). All Phase 2 and Phase 4 checks will scan ONLY the specified paths, while Phase 1 runs fully for context

### Phase 2: White-Box Attack Surface Analysis [NIST: ID + PR]

For `full`, `diff`, `recheck` and `phase:2` modes: read `.codex/security-audit-references/attack-vectors.md` for the detailed checklist.
For `focus` modes: read only the relevant sections of `attack-vectors.md`:
- `focus:auth` - sections 1 (Broken Access Control) and 7 (Authentication Failures)
- `focus:api` - sections 1 (Broken Access Control), 5 (Injection), 6 (Insecure Design) and 14 (API Security)
- `focus:config` - sections 2 (Security Misconfiguration), 3 (Software Supply Chain Failures), 8 (Software or Data Integrity Failures) and 16 (Infrastructure & DevOps)

For `quick` mode: use the inline category summaries below (do NOT read attack-vectors.md).

Categories in priority order (aligned with OWASP Top 10:2025):

1. **Broken Access Control** [A01:2025 | PR.AA] - IDOR, privilege escalation, missing middleware, role bypass, horizontal/vertical access violations, CORS misconfiguration, metadata manipulation, SSRF (user-controlled URL fetching, cloud metadata endpoints 169.254.169.254, DNS rebinding, redirect following to internal services)
2. **Security Misconfiguration** [A02:2025 | PR.PS] - Debug mode, default credentials, exposed admin panels, missing security headers, permissive CORS, directory listing, unnecessary features enabled, verbose error pages, exposed .git directory
3. **Software Supply Chain Failures** [A03:2025 | GV.SC] - Known CVEs in dependencies, outdated packages, missing lock files, typosquatting, malicious packages, unverified build inputs, compromised CI/CD plugins, post-install script abuse, unmaintained transitive dependencies, unverified container base images
4. **Cryptographic Failures** [A04:2025 | PR.DS] - Weak hashing, plaintext secrets, missing encryption at rest/transit, deprecated algorithms, hardcoded keys, exposed secrets in client bundles, weak TLS configuration
5. **Injection** [A05:2025 | PR.DS, DE.CM] - SQL, NoSQL, command, LDAP, XPath, template (SSTI), header, expression language injection, HTTP request smuggling
6. **Insecure Design** [A06:2025 | GV.RM] - Missing threat modeling, insecure business flows, missing rate limits on high-value operations, no abuse case testing, trust boundary violations, no re-authentication for sensitive ops, race conditions by design
7. **Authentication Failures** [A07:2025 | PR.AA] - Weak passwords, missing brute force protection, session fixation, insecure token generation, missing MFA, credential stuffing gaps, insecure password reset, OAuth state validation
8. **Software or Data Integrity Failures** [A08:2025 | PR.DS, GV.SC] - Insecure deserialization, CI/CD pipeline injection, missing code signing, auto-update without verification, unsigned webhooks, untrusted data in build pipelines
9. **Security Logging and Alerting Failures** [A09:2025 | DE.CM, DE.AE] - Missing audit logs for auth events, no log integrity protection, insufficient alerting on security events, sensitive data in logs, missing request tracing, no alerting on repeated auth failures, great logging but no alerting
10. **Mishandling of Exceptional Conditions** [A10:2025 | DE.AE] - Fail-open logic (granting access on error), error messages leaking secrets or stack traces, NULL dereference crashes, unhandled resource exhaustion, missing timeout handling, inconsistent error responses, silent failures masking security events, failing to detect or respond to abnormal conditions
11. **XSS** [A05:2025 | PR.DS] - Stored, reflected and DOM-based XSS, attribute injection, JavaScript URI schemes
12. **CSRF** [A01:2025 | PR.DS] - Missing anti-CSRF tokens, SameSite cookie gaps, cross-origin state changes
13. **File Upload & Storage** [A01:2025, A06:2025 | PR.DS] - Unrestricted types, path traversal, executable uploads, public buckets
14. **API Security** [A01:2025, A05:2025, A06:2025 | PR.AA] - Rate limiting, validation, error verbosity, broken object-level auth, excessive data exposure
15. **Business Logic Flaws** [A06:2025 | PR.DS, DE.AE] - Race conditions, price manipulation, workflow bypass, integer overflow
16. **Infrastructure & DevOps** [A02:2025, A03:2025, A08:2025 | PR.PS, GV.SC] - Dockerfile security, exposed ports, secrets in git, CI/CD injection, overly permissive IAM
17. **AI/LLM Security** [A05:2025, A01:2025, A04:2025 | PR.DS, PR.AA] - Prompt injection (direct and indirect), PII sent to external AI APIs, AI output rendered without sanitization (XSS via LLM), tool/function calling without permission checks, RAG data poisoning, missing cost/abuse monitoring, API key leakage for AI services, fail-open when AI service is down
18. **WebSocket Security** [A01:2025, A05:2025, A07:2025 | PR.AA, PR.DS] - Handshake auth, per-message authorization, cross-site WebSocket hijacking, broadcast isolation, message validation, connection exhaustion, backpressure
19. **gRPC Security** [A01:2025, A05:2025, A02:2025 | PR.AA, PR.DS] - mTLS enforcement, per-RPC auth, metadata injection, message size limits, reflection disabled, streaming rate limits
20. **Serverless and Cloud-Native** [A01:2025, A02:2025, A03:2025 | PR.PS, PR.AA] - Lambda/Functions execution role privilege, K8s RBAC and pod security, NetworkPolicies, IaC state security, admission controllers

For dependency checks: `composer audit`, `npm audit`, `pip audit`, `bundle audit`, `govulncheck`, `dotnet list package --vulnerable`.
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

(Skip in `quick` and `gray` modes. Run in `full`, `diff`, `recheck`, `focus` and `phase:4` modes.)

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

(Skip in `quick`, `gray`, `diff` and `focus` modes. Run in `full` and `phase:5` modes.)

**Structural** [GV.RM | A06:2025]: God classes over 500 lines, duplicated security logic, missing abstractions, dead code with active routes
**Data handling** [PR.DS | A01:2025, A05:2025]: Overly permissive models, raw JSON output, inconsistent validation
**Error handling** [DE.AE | A09:2025, A10:2025]: Catch-all swallowing, verbose responses, fail-open patterns, missing error handling on external calls, silent failures
**Dependencies** [GV.SC | A03:2025]: Unused packages, wildcard versions, duplicate libraries, unverified transitive deps
**Design** [GV.RM | A06:2025]: Missing input validation layer, no separation of public vs authenticated routes, business logic in controllers

### Deep Dive (for each finding)

For every finding from Phases 2-5, perform these steps before writing it into the report:

1. **Locate** - Exact file, line number and code snippet
2. **Explain the attack** - Step-by-step conceptual proof-of-concept
3. **Assess impact** - What data is at risk? Can the attacker escalate?
4. **Rate severity** - 🔴 CRITICAL / 🟠 HIGH / 🟡 MEDIUM / 🟢 LOW / 🔵 INFO
5. **Map to OWASP** - A01:2025 through A10:2025
6. **Map to CWE** - Most specific CWE ID (e.g., CWE-89, not CWE-74)
7. **Map to NIST CSF 2.0** - Function and category
8. **Map to compliance** (skip if `--lite`) - SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001
9. **Write the fix** - Real, copy-paste-ready code patches

### Generate Report

Save the report to `./security-audit-report.md` in the project root.

```markdown
# Security Audit Report

**Project**: [name]
**Date**: [today's date]
**Auditor**: Security Audit
**Frameworks**: OWASP Top 10:2025 + NIST CSF 2.0
**Mode**: [full/quick/gray/focus:X/diff/recheck:X/phase:X/triage]



## Executive Summary

| Metric | Count |
|--------|-------|
| 🔴 Critical | X |
| 🟠 High | X |
| 🟡 Medium | X |
| 🟢 Low | X |
| 🔵 Informational | X |
| 🔲 Gray-box findings | X |
| 📍 Security hotspots | X |
| 🧹 Code smells | X |
| **Total findings** | **X** |
| New since baseline | X | (only if `.security-audit-baseline.json` exists)

**Overall Risk Assessment**: [sentence summary]



## OWASP Top 10:2025 Coverage

| OWASP ID | Category | Findings | Status |
|----------|----------|----------|--------|
| A01:2025 | Broken Access Control | X | 🔴 Needs Attention / ✅ Acceptable |
| A02:2025 | Security Misconfiguration | X | 🔴 Needs Attention / ✅ Acceptable |
| A03:2025 | Software Supply Chain Failures | X | 🔴 Needs Attention / ✅ Acceptable |
| A04:2025 | Cryptographic Failures | X | 🔴 Needs Attention / ✅ Acceptable |
| A05:2025 | Injection | X | 🔴 Needs Attention / ✅ Acceptable |
| A06:2025 | Insecure Design | X | 🔴 Needs Attention / ✅ Acceptable |
| A07:2025 | Authentication Failures | X | 🔴 Needs Attention / ✅ Acceptable |
| A08:2025 | Software or Data Integrity Failures | X | 🔴 Needs Attention / ✅ Acceptable |
| A09:2025 | Security Logging and Alerting Failures | X | 🔴 Needs Attention / ✅ Acceptable |
| A10:2025 | Mishandling of Exceptional Conditions | X | 🔴 Needs Attention / ✅ Acceptable |



## NIST CSF 2.0 Coverage

| Function | Categories | Findings | Status |
|----------|-----------|----------|--------|
| GV (Govern) | GV.OC, GV.RM, GV.RR, GV.PO, GV.OV, GV.SC | X | 🔴 Needs Attention / ✅ Acceptable |
| ID (Identify) | ID.AM, ID.RA, ID.IM | X | 🔴 Needs Attention / ✅ Acceptable |
| PR (Protect) | PR.AA, PR.AT, PR.DS, PR.PS, PR.IR | X | 🔴 Needs Attention / ✅ Acceptable |
| DE (Detect) | DE.CM, DE.AE | X | 🔴 Needs Attention / ✅ Acceptable |
| RS (Respond) | RS.MA, RS.AN, RS.CO, RS.MI | X | 🔴 Needs Attention / ✅ Acceptable |
| RC (Recover) | RC.RP, RC.CO | X | 🔴 Needs Attention / ✅ Acceptable |



## Compliance Coverage (omit if --lite)

| Framework | Coverage | Details |
|-----------|----------|---------|
| CWE | X unique CWEs identified | [list top CWE IDs found] |
| SANS/CWE Top 25 | X/25 entries found | [list matching entries] |
| OWASP ASVS 5.0 | X/14 chapters with findings | [list chapters] |
| PCI DSS 4.0.1 | X requirements relevant | [list relevant requirements] |
| MITRE ATT&CK | X techniques mapped | [list technique IDs] |
| SOC 2 | X criteria with findings | [list criteria] |
| ISO 27001:2022 | X controls with findings | [list controls] |



## 🔴 Critical & 🟠 High Findings

### 🔴 [CRITICAL-001] Title
- **Severity**: 🔴 CRITICAL
- **OWASP**: A05:2025 (Injection)
- **CWE**: CWE-89 (SQL Injection)
- **NIST CSF**: PR.DS (Data Security)
- **Compliance** (omit if --lite): SANS Top 25 #3 | ASVS V5.3.4 | PCI DSS 6.2.4 | T1190 | CC6.6 | A.8.28
- **Location**: `path/to/file:123`
- **Attack Vector**: [step-by-step]
- **Impact**: [consequences]
- **Vulnerable Code**:
  [code block]
- **Remediation**: [description of what to fix]
  [include fixed code block ONLY if --fix flag is set]

### 🟠 [HIGH-001] Title
- **Severity**: 🟠 HIGH
- [same fields as above]



## 🟡 Medium Findings

### 🟡 [MEDIUM-001] Title
- **Severity**: 🟡 MEDIUM
- [same fields as Critical/High]



## 🟢 Low & 🔵 Informational Findings

### 🟢 [LOW-001] Title
- **Severity**: 🟢 LOW
- [condensed format]

### 🔵 [INFO-001] Title
- **Severity**: 🔵 INFO
- [condensed format]



## 🔲 Gray-Box Findings

### [GRAY-001] Title
- **Severity**: [🔴/🟠/🟡/🟢/🔵] [rating]
- **OWASP**: [A01:2025/A06:2025/A07:2025]
- **CWE**: [CWE-ID]
- **NIST CSF**: [category]
- **Compliance**: [applicable framework references]
- **Tested As**: [role/context]
- **Endpoint**: `[METHOD] /path`
- **Expected**: [what should happen]
- **Actual**: [what actually happens]
- **Request**: [the exact request demonstrating the issue]
- **Remediation**: [description of what to fix]
  [include fixed code block ONLY if --fix flag is set]



## 📍 Security Hotspots

### [HOTSPOT-001] Title
- **OWASP**: [relevant]
- **CWE**: [CWE-ID]
- **NIST CSF**: [category]
- **Compliance**: [applicable framework references]
- **Location**: `path/to/file:45-120`
- **Why sensitive**: [explanation]
- **Risk if modified**: [what could go wrong]
- **Review guidance**: [what to watch in PRs]



## 🧹 Code Smells

### [SMELL-001] Title
- **OWASP**: [relevant, typically A06:2025]
- **CWE**: [CWE-ID]
- **NIST CSF**: [category]
- **Compliance**: [applicable framework references]
- **Location**: `path/to/file`
- **Pattern**: [what was found]
- **Security implication**: [why it matters]
- **Suggestion**: [description of what to refactor]
  [include refactored code block ONLY if --fix flag is set]



## Recommendations Summary

[prioritized action items grouped by OWASP category]



## Methodology

| Aspect | Details |
|--------|---------|
| Phases executed | [list phases run, e.g., 1-5 for full, 1-2 for quick] |
| Frameworks detected | [list all detected frameworks] |
| White-box categories | [categories checked] |
| Gray-box testing | [roles tested, endpoints probed] |
| Security hotspots | [count and sensitivity categories scanned] |
| Code smells | [structural, data handling, error handling, dependencies, design] |
| Packs loaded | [list pack names, or "none"] |
| Scope exclusions | [yes/no - patterns from `.security-audit-ignore`] |
| Baseline comparison | [yes/no - `.security-audit-baseline.json`] |
| OWASP Top 10:2025 | [X/10 categories covered] |
| NIST CSF 2.0 | [functions covered] |
| CWE | [X unique CWE IDs identified] |
| SANS/CWE Top 25 | [X/25 matched] (omit if --lite) |
| ASVS 5.0 | [chapters checked] (omit if --lite) |
| Additional frameworks | PCI DSS 4.0.1, MITRE ATT&CK, SOC 2, ISO 27001:2022 (omit if --lite) |



*Report generated by Security Audit*
```

After the closing ``` of the report, the markdown file is complete. The footer attribution is plain text inside the report (not a clickable link) since it lives in a standalone `.md` file.

## Severity Indicators

Use these emoji indicators consistently throughout the report for all severity references:

| Emoji | Severity |
|-------|----------|
| 🔴 | CRITICAL |
| 🟠 | HIGH |
| 🟡 | MEDIUM |
| 🟢 | LOW |
| 🔵 | INFO |

Apply the matching emoji before every severity label - in finding headers, the severity field, executive summary counts and OWASP/NIST coverage status columns. For gray-box findings, prefix the severity rating with the appropriate emoji.

## Execution Rules

1. Read every route, controller, model, middleware, config, migration and seeder
2. Every finding must reference actual code with file path and line number
3. Every finding must show the vulnerable code snippet
4. Every finding must have OWASP Top 10:2025, CWE ID and NIST CSF mapping. Unless `--lite` is set, also include other compliance references (SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001) where applicable
5. Gray-box findings must include the role tested, endpoint, expected vs actual behavior
6. If an area is clean, say so explicitly
7. Don't fabricate findings - false positives waste time
8. Critical and high findings go first
9. Save report to `./security-audit-report.md` in the project root

### Fix Mode Behavior

- **Default (no `--fix`)**: Show findings with vulnerable code, location, attack vector and impact. Remediation is a short text description of what to fix (no code blocks). This keeps the report focused on understanding the issues.
- **With `--fix`**: Include copy-paste-ready fixed code blocks in every finding's Remediation section. Also include refactored code in Code Smells.

### After Saving the Report

Tell the developer:
- How many findings by severity
- OWASP categories with issues
- The top 3 most urgent items to fix
- Where the report is saved: `./security-audit-report.md`

If `--fix` was NOT used, also tell the developer:
> To generate the report again with code fixes included, ask: `Run security audit [mode] --fix`

### Triage Mode Behavior

When mode is `triage`:
1. Skip all audit phases (1-5). Do NOT scan code or generate findings.
2. Read the existing `./security-audit-report.md` file. If it does not exist, tell the developer and stop.
3. Read `.codex/security-audit-references/features-extended.md` for the triage flow specification.
4. Parse all findings from the existing report (CRITICAL, HIGH, MEDIUM, LOW, INFO, GRAY, HOTSPOT, SMELL).
5. For each finding (ordered by severity, CRITICAL first), present the finding summary and ask the developer to: **Accept** (will fix), **Defer** (known risk), **Dismiss** (false positive) or **Escalate** (needs review).
6. For Defer and Dismiss, ask for a one-line reason.
7. Save results to `./security-audit-triage.md` using the format in `features-extended.md`.
8. Skip PDF conversion and all other post-report steps.

### Recheck Mode Behavior

When mode is `recheck:PATH`:
1. Parse the path(s) from the argument. Multiple paths are comma-separated: `recheck:src/auth,src/api`
2. Run Phase 1 fully (reconnaissance for context)
3. Run Phase 2 (white-box) scoped to ONLY the specified paths
4. Run Phase 4 (hotspots) scoped to ONLY the specified paths
5. Skip Phase 3 (gray-box) and Phase 5 (smells)
6. In the report Methodology, note which paths were re-checked

### Baseline Processing (after report generation)

If `--update-baseline` is set:
1. Read `.codex/security-audit-references/features-extended.md` for baseline format
2. Collect all findings from the generated report
3. Compute fingerprints per the specification in `features-extended.md`
4. Write `.security-audit-baseline.json` to the project root
5. Tell the developer: `Baseline updated with X findings.`

If `--update-baseline` is NOT set but `.security-audit-baseline.json` exists:
1. Read the baseline file
2. For each finding, check if its fingerprint matches a baseline entry
3. Tag matching findings with `[Known]` in the report
4. Add "New since baseline" count to the Executive Summary

### SARIF/JSON Output (after report generation)

If `--format sarif` or `--format json` is set:
1. Read `.codex/security-audit-references/features-extended.md` for the schema specification
2. Transform all findings into the target format
3. Save to `./security-audit-report.sarif` or `./security-audit-report.json`
4. Tell the developer where the file was saved

### Report Diff (after report generation)

If `--diff-report path` is set:
1. Read `.codex/security-audit-references/features-extended.md` for matching logic
2. Read the previous report at the specified path
3. Compare findings between reports
4. Insert a "Changes Since Previous Audit" section after the Executive Summary in the new report

### CI Gating (after all other post-report steps)

If `--fail-on` is set:
1. Count findings at or above the threshold severity (e.g., `--fail-on high` counts CRITICAL + HIGH)
2. Output the exit summary line as the very last output: `SECURITY_AUDIT_EXIT: PASS` or `SECURITY_AUDIT_EXIT: FAIL (X findings at or above THRESHOLD)`

### PDF Conversion (automatic)

After saving the markdown report, attempt to convert it to PDF using **only already-installed** converters. **NEVER install, download or run a converter that is not already installed on the system.** If a tool is not found, skip it.

Check for installed converters using the terminal in this order. Only use the first one found:

1. `pandoc` - run `pandoc ./security-audit-report.md -o ./security-audit-report.pdf --pdf-engine=xelatex -V geometry:margin=1in -V mainfont="DejaVu Sans" -V monofont="DejaVu Sans Mono" --highlight-style=tango`
2. `wkhtmltopdf` - run `wkhtmltopdf ./security-audit-report.md ./security-audit-report.pdf`
3. `weasyprint` - run `weasyprint ./security-audit-report.md ./security-audit-report.pdf`
4. `md-to-pdf` - run `md-to-pdf ./security-audit-report.md`
5. `mdpdf` - run `mdpdf ./security-audit-report.md`

If a converter is found:
- Run the conversion command
- If conversion succeeds, tell the developer: `PDF report saved to ./security-audit-report.pdf`
- If conversion fails, tell the developer: `PDF conversion failed. The markdown report is still available at ./security-audit-report.md`

If no converter is found:
- Tell the developer: `No PDF converter found. To enable automatic PDF export, install one of: pandoc, wkhtmltopdf, weasyprint or md-to-pdf`
