# Attack Vectors Reference

Detailed checklists for each attack category. Use these as a systematic guide when auditing each area. Every section is tagged with OWASP Top 10:2025, NIST CSF 2.0 and top CWE IDs. See `compliance-mapping.md` for full cross-references to SANS/CWE Top 25, OWASP ASVS 5.0, PCI DSS 4.0.1, MITRE ATT&CK, SOC 2 and ISO 27001:2022.

## OWASP Top 10:2025 Changes from 2021

| 2025 | Category | Was in 2021 |
|------|----------|-------------|
| A01:2025 | Broken Access Control (now includes SSRF) | A01:2021 + A10:2021 merged |
| A02:2025 | Security Misconfiguration | A05:2021 (moved up to #2) |
| A03:2025 | Software Supply Chain Failures | A06:2021 expanded (was "Vulnerable and Outdated Components") |
| A04:2025 | Cryptographic Failures | A02:2021 (moved to #4) |
| A05:2025 | Injection | A03:2021 (moved to #5) |
| A06:2025 | Insecure Design | A04:2021 (moved to #6) |
| A07:2025 | Authentication Failures | A07:2021 (renamed, dropped "Identification and") |
| A08:2025 | Software or Data Integrity Failures | A08:2021 (renamed, "and" changed to "or") |
| A09:2025 | Security Logging and Alerting Failures | A09:2021 (renamed, emphasis on alerting) |
| A10:2025 | Mishandling of Exceptional Conditions | NEW |

## Table of Contents
1. [Broken Access Control (A01:2025)](#1-broken-access-control-a012025--praa--cwe-284-cwe-862-cwe-863-cwe-639-cwe-918)
2. [Security Misconfiguration (A02:2025)](#2-security-misconfiguration-a022025--prps--cwe-16-cwe-611-cwe-942-cwe-756)
3. [Software Supply Chain Failures (A03:2025)](#3-software-supply-chain-failures-a032025--gvsc--cwe-829-cwe-494-cwe-1104)
4. [Cryptographic Failures (A04:2025)](#4-cryptographic-failures-a042025--prds--cwe-327-cwe-328-cwe-330-cwe-321)
5. [Injection (A05:2025)](#5-injection-a052025--prds-decm--cwe-79-cwe-89-cwe-78-cwe-94-cwe-917)
6. [Insecure Design (A06:2025)](#6-insecure-design-a062025--gvrm--cwe-209-cwe-434-cwe-799-cwe-841)
7. [Authentication Failures (A07:2025)](#7-authentication-failures-a072025--praa--cwe-287-cwe-307-cwe-384-cwe-798)
8. [Software or Data Integrity Failures (A08:2025)](#8-software-or-data-integrity-failures-a082025--prds-gvsc--cwe-502-cwe-345-cwe-494-cwe-915)
9. [Security Logging and Alerting Failures (A09:2025)](#9-security-logging-and-alerting-failures-a092025--decm-deae--cwe-778-cwe-532-cwe-117)
10. [Mishandling of Exceptional Conditions (A10:2025)](#10-mishandling-of-exceptional-conditions-a102025--deae--cwe-754-cwe-755-cwe-248-cwe-390)
11. [XSS](#11-xss-a052025--prds--cwe-79-cwe-80-cwe-83)
12. [CSRF](#12-csrf-a012025--prds--cwe-352)
13. [File Upload & Storage](#13-file-upload--storage-a012025-a062025--prds--cwe-434-cwe-22)
14. [API Security](#14-api-security-a012025-a052025-a062025--praa--cwe-862-cwe-20-cwe-200)
15. [Business Logic Flaws](#15-business-logic-flaws-a062025--prds-deae--cwe-841-cwe-799-cwe-362)
16. [Infrastructure & DevOps](#16-infrastructure--devops-a022025-a032025-a082025--prps-gvsc--cwe-16-cwe-260-cwe-829)
17. [AI/LLM Security](#17-aillm-security-a052025-a012025-a042025--prds-praa--cwe-74-cwe-20-cwe-200)
18. [WebSocket Security](#18-websocket-security-a012025-a052025-a072025--praa-prds--cwe-287-cwe-20-cwe-400)
19. [gRPC Security](#19-grpc-security-a012025-a052025-a022025--praa-prds--cwe-287-cwe-20-cwe-400)
20. [Serverless and Cloud-Native](#20-serverless-and-cloud-native-a012025-a022025-a032025--prps-praa--cwe-269-cwe-16-cwe-284)
21. [Gray-Box Testing](#21-gray-box-testing-a012025-a062025-a072025)
22. [Security Hotspots](#22-security-hotspots-a062025--id-gv)
23. [Code Smells](#23-code-smells-a062025--gv-pr)
24. [Framework-Specific Checks](#24-framework-specific-checks)

---

## 1. Broken Access Control [A01:2025 | PR.AA | CWE-284, CWE-862, CWE-863, CWE-639, CWE-918]

Now includes SSRF (previously A10:2021), reflecting that SSRF is fundamentally about improper access control.

### IDOR (Insecure Direct Object Reference)
- [ ] Can user A access user B's resources by changing IDs in URLs/params?
- [ ] Are UUIDs used instead of sequential IDs for sensitive resources?
- [ ] Is ownership verified server-side before every data access?

### Privilege Escalation
- [ ] Can a regular user access admin endpoints?
- [ ] Can a user change their own role via API (mass assignment)?
- [ ] Are role checks enforced in middleware, not just UI?
- [ ] Are there routes/controllers missing authorization middleware?

### Horizontal Access
- [ ] Can a user in tenant A access tenant B's data?
- [ ] Are database queries scoped to the authenticated user/tenant?
- [ ] Are file/object storage paths isolated per user?

### CORS
- [ ] Is CORS configured with `*` for credentialed requests?
- [ ] Can arbitrary origins access authenticated endpoints?
- [ ] Are preflight responses cached too aggressively?

### SSRF (Server-Side Request Forgery)
- [ ] Does the application fetch URLs provided by users (webhooks, image processing, link previews, PDF generation)?
- [ ] Are fetched URLs validated against an allowlist of domains/IPs?
- [ ] Can internal IPs (127.0.0.1, 10.x, 172.16.x, 169.254.169.254) be reached?
- [ ] Is DNS rebinding prevented (resolve-then-fetch, not fetch-then-resolve)?
- [ ] Can file import features (CSV, XML, XLSX) reference external URLs?
- [ ] Do image/file processors follow redirects to internal resources?
- [ ] Can SVG or XML uploads trigger server-side requests via entities or href?
- [ ] Do PDF generators fetch external stylesheets or images?
- [ ] Can the application reach cloud metadata endpoints (169.254.169.254, metadata.google.internal)?
- [ ] Are IMDSv2 or equivalent protections enforced?
- [ ] Is there a URL allowlist/denylist for outbound requests?
- [ ] Are redirects re-validated after following?

### Missing Checks
- [ ] Grep for routes without auth/authorization middleware
- [ ] Check if API endpoints have different auth requirements than web routes
- [ ] Verify that CLI/artisan/management commands don't bypass auth
- [ ] Check if soft-deleted records are accessible through relationships

---

## 2. Security Misconfiguration [A02:2025 | PR.PS | CWE-16, CWE-611, CWE-942, CWE-756]

Moved up from #5 in 2021 to #2 in 2025. Now affects 3% of tested applications.

- [ ] Is debug mode OFF in production?
- [ ] Are default admin credentials changed?
- [ ] Are admin panels protected (IP restriction, strong auth)?
- [ ] Are security headers set: X-Frame-Options, X-Content-Type-Options, CSP, HSTS, Referrer-Policy, Permissions-Policy?
- [ ] Are directory listings disabled?
- [ ] Are backup files accessible (`.bak`, `.sql`, `.tar.gz`)?
- [ ] Is the `.git` directory exposed publicly?
- [ ] Are unnecessary HTTP methods enabled?
- [ ] Are error pages customized (no stack traces in production)?
- [ ] Are unnecessary features/modules disabled?
- [ ] Is the application server version exposed in headers?
- [ ] Are cloud storage buckets (S3, GCS) properly ACL'd?
- [ ] Are default ports and services locked down?
- [ ] Are CORS settings restrictive (not `*` with credentials)?

---

## 3. Software Supply Chain Failures [A03:2025 | GV.SC | CWE-829, CWE-494, CWE-1104]

NEW in 2025. Expands the old "Vulnerable and Outdated Components" (A06:2021) to cover the entire software supply chain. Has the highest average exploit and impact scores from CVEs.

### Dependency Vulnerabilities
- [ ] Run `composer audit` (PHP)
- [ ] Run `npm audit` or `yarn audit` (Node.js)
- [ ] Run `pip-audit` or `safety check` (Python)
- [ ] Run `bundle audit` (Ruby)
- [ ] Check for outdated packages with known CVEs

### Supply Chain Integrity
- [ ] Are lock files committed (composer.lock, package-lock.json, yarn.lock, Pipfile.lock)?
- [ ] Are package names verified (no typosquatting)?
- [ ] Are post-install scripts reviewed for malicious behavior?
- [ ] Are packages from trusted registries only?
- [ ] Are there unmaintained packages (no updates in 2+ years)?

### Build Pipeline Security
- [ ] Are CI/CD plugins and actions from verified sources?
- [ ] Are build inputs (base images, scripts, tools) verified with checksums or signatures?
- [ ] Can PRs from forks access CI/CD secrets?
- [ ] Are environment variables injected securely in CI/CD?
- [ ] Are build artifacts signed before deployment?

### Container Supply Chain
- [ ] Are container base images pinned to specific digests (not just tags)?
- [ ] Are base images from trusted registries (not random Docker Hub)?
- [ ] Are container images scanned for vulnerabilities?
- [ ] Are multi-stage builds used to minimize attack surface?

### Transitive Dependencies
- [ ] Are transitive (indirect) dependencies audited?
- [ ] Can a compromised transitive dependency modify build output?
- [ ] Are dependency trees reviewed for unexpected packages?

### SBOM and Provenance
- [ ] Is a Software Bill of Materials (SBOM) generated for releases (SPDX or CycloneDX)?
- [ ] Are build artifacts attested with provenance (SLSA Level 2+)?
- [ ] Are commits signed with verified GPG or SSH keys?
- [ ] Is there artifact attestation linking builds to source (in-toto, Sigstore)?
- [ ] Are SBOM reports reviewed before deployment?

---

## 4. Cryptographic Failures [A04:2025 | PR.DS | CWE-327, CWE-328, CWE-330, CWE-321]

### Passwords
- [ ] Are passwords hashed with bcrypt/argon2 (not MD5/SHA1/SHA256)?
- [ ] Is there a minimum password length enforced (>= 8 chars)?
- [ ] Are passwords checked against breach databases or common password lists?

### Encryption
- [ ] Is sensitive data encrypted at rest (PII, payment data)?
- [ ] Are modern algorithms used (AES-256-GCM, not DES/3DES/ECB)?
- [ ] Are encryption keys stored separately from encrypted data?
- [ ] Is HTTPS enforced (HSTS header)?
- [ ] Is TLS 1.2+ enforced?

### Secrets Management
- [ ] Is `.env` in `.gitignore`?
- [ ] Are API keys, database passwords or tokens hardcoded in source?
- [ ] Are secrets exposed in client-side JavaScript bundles?
- [ ] Check `config/` files for hardcoded credentials
- [ ] Are secrets logged anywhere (request logs, error logs)?

### Data Exposure
- [ ] Do API responses include more data than the client needs?
- [ ] Are columns like `password`, `token`, `secret` excluded from serialization?
- [ ] Are sensitive parameters logged (passwords, tokens, credit cards)?
- [ ] Check for PII in URLs (email, SSN, etc.)

---

## 5. Injection [A05:2025 | PR.DS, DE.CM | CWE-79, CWE-89, CWE-78, CWE-94, CWE-917]

### SQL Injection
- [ ] Are all database queries parameterized?
- [ ] Grep for raw SQL: `DB::raw`, `DB::statement`, `whereRaw`, `raw()`, string concatenation
- [ ] Check for dynamic column/table names from user input
- [ ] Check ORDER BY clauses (often injectable)

### Command Injection
- [ ] Grep for: `exec()`, `system()`, `shell_exec()`, `passthru()`, `popen()`, backticks
- [ ] In Node: `child_process.exec()`, `execSync()` with interpolated input
- [ ] In Python: `os.system()`, `subprocess.call(shell=True)`, `eval()`, `exec()`

### Template Injection (SSTI)
- [ ] Is user input rendered directly in template strings?
- [ ] In Blade: `{!! $userInput !!}` (unescaped)
- [ ] In Jinja2: `render_template_string()` with user input
- [ ] In Twig/Nunjucks: user-controlled template content

### NoSQL Injection
- [ ] In MongoDB: `$where`, `$gt`, `$ne` from user input
- [ ] Are query operators sanitized?

### Header Injection
- [ ] Is user input used in HTTP response headers?
- [ ] Are newlines stripped from header values?

### Expression Language Injection
- [ ] Are user inputs passed to expression evaluators or template engines?
- [ ] Check for `SpEL`, `OGNL`, `MVEL` in Java projects
- [ ] Check for `eval()` or `new Function()` in JavaScript

### HTTP Request Smuggling / Desync
- [ ] Are frontend and backend servers using the same HTTP parsing rules (Content-Length vs Transfer-Encoding)?
- [ ] Is `Transfer-Encoding: chunked` handled consistently across proxy layers?
- [ ] Can CL.TE or TE.CL desync attacks bypass WAF or auth checks?
- [ ] Are HTTP/2 downgrade attacks possible (h2c smuggling)?
- [ ] Is request body size validated at every layer (proxy, load balancer, app server)?
- [ ] Are ambiguous requests (conflicting Content-Length and Transfer-Encoding) rejected?

---

## 6. Insecure Design [A06:2025 | GV.RM | CWE-209, CWE-434, CWE-799, CWE-841]

Covers fundamental design flaws, not implementation bugs.

### Threat Modeling Gaps
- [ ] Are there high-value operations without rate limiting (money transfer, password reset, OTP)?
- [ ] Is there no limit on failed attempts for any critical action?
- [ ] Are abuse cases considered (account enumeration, spam, resource exhaustion)?
- [ ] Are trust boundaries clearly defined between components?

### Missing Security Controls by Design
- [ ] No CAPTCHA or bot protection on public forms
- [ ] No re-authentication required for sensitive operations (password change, email change, payment)
- [ ] No confirmation step for destructive actions (delete account, bulk delete)
- [ ] No cooling-off period for high-risk changes

### Unsafe Business Flows
- [ ] Can checkout/payment flow be completed without proper validation at each step?
- [ ] Can referral/reward systems be gamed through self-referral?
- [ ] Are feature flags used as security controls (easily toggled off)?
- [ ] Can users create unlimited resources (accounts, API keys, projects) without limits?

### Architecture Issues
- [ ] Is the same database connection used for read and write operations with different trust levels?
- [ ] Are internal services accessible from the public network?
- [ ] Is there no input validation layer (validation scattered across controllers)?
- [ ] Are secrets shared across environments (dev/staging/production)?

---

## 7. Authentication Failures [A07:2025 | PR.AA | CWE-287, CWE-307, CWE-384, CWE-798]

### Sessions
- [ ] Are session IDs generated with a CSPRNG?
- [ ] Is session fixation prevented (regenerate session on login)?
- [ ] Do sessions expire after reasonable inactivity?
- [ ] Are sessions invalidated on logout (server-side)?
- [ ] Are session cookies set with HttpOnly, Secure, SameSite flags?

### Tokens (JWT/API Keys)
- [ ] Are JWTs signed with a strong secret (not "secret" or empty)?
- [ ] Is the `alg: none` attack prevented?
- [ ] Are tokens validated server-side (not just decoded)?
- [ ] Do tokens have reasonable expiry times?
- [ ] Are refresh tokens stored securely and rotated?

### Brute Force
- [ ] Is there rate limiting on login endpoints?
- [ ] Is there account lockout after failed attempts?
- [ ] Are timing attacks mitigated (constant-time comparison)?

### OAuth 2.1 / SSO
- [ ] Is the `state` parameter validated to prevent CSRF?
- [ ] Are redirect URIs strictly validated (no open redirect)?
- [ ] Is the token exchange done server-side (not in client)?
- [ ] Is PKCE (Proof Key for Code Exchange) required for all OAuth flows?
- [ ] Is the implicit grant flow disabled (removed in OAuth 2.1)?
- [ ] Are authorization code lifetimes short (< 60 seconds)?
- [ ] Is DPoP (Demonstrating Proof-of-Possession) used for sender-constrained tokens?
- [ ] Are resource indicators (RFC 8707) validated to prevent token misuse across APIs?

### Passkeys / FIDO2 / WebAuthn
- [ ] Is credential attestation verified during registration?
- [ ] Is the authenticator counter (sign count) validated to detect cloned credentials?
- [ ] Is the User Verification (UV) flag enforced for sensitive operations?
- [ ] Are backup eligibility and backup state flags handled (synced passkeys)?
- [ ] Is passkey revocation supported (user can remove a credential)?
- [ ] Are discoverable credentials (resident keys) properly scoped per relying party?
- [ ] Is the relying party ID configured correctly (domain scoping)?
- [ ] Are fallback authentication methods (backup codes) stored securely?

### Password Reset
- [ ] Are reset tokens time-limited and single-use?
- [ ] Can reset tokens be predicted or reused?
- [ ] Does password reset invalidate existing sessions?

---

## 8. Software or Data Integrity Failures [A08:2025 | PR.DS, GV.SC | CWE-502, CWE-345, CWE-494, CWE-915]

### Software Integrity
- [ ] Are CI/CD pipelines protected from unauthorized modification?
- [ ] Are build artifacts signed or verified?
- [ ] Can PRs from forks access CI secrets?
- [ ] Are auto-update mechanisms verifying signatures?

### Data Integrity
- [ ] Is user input deserialized without validation (`unserialize()`, `pickle.loads()`, `JSON.parse()` of untrusted complex objects)?
- [ ] Are database migrations reversible and audited?
- [ ] Are import/export functions validating data integrity?
- [ ] Are webhooks verified with signatures (HMAC)?

### Pipeline Security
- [ ] Are deployment scripts pulling from verified sources?
- [ ] Are container images verified before deployment?
- [ ] Are environment variables injected securely in CI/CD?
- [ ] Can a compromised dependency modify the build output?

---

## 9. Security Logging and Alerting Failures [A09:2025 | DE.CM, DE.AE | CWE-778, CWE-532, CWE-117]

Renamed from "Security Logging and Monitoring Failures" to emphasize that logging without alerting is insufficient.

### Audit Logging
- [ ] Are login attempts (success and failure) logged?
- [ ] Are authorization failures logged?
- [ ] Are high-value transactions logged (payments, role changes, data exports)?
- [ ] Are admin actions logged with actor identity?
- [ ] Do logs include enough context (user ID, IP, timestamp, action, resource)?

### Log Safety
- [ ] Are passwords, tokens or credit card numbers excluded from logs?
- [ ] Are logs stored securely (not world-readable)?
- [ ] Is log integrity protected (append-only, tamper-evident)?
- [ ] Are logs rotated and retained appropriately?

### Alerting (NEW emphasis in 2025)
- [ ] Is there alerting on repeated auth failures?
- [ ] Is there alerting on privilege escalation attempts?
- [ ] Are application errors monitored with alerts in production?
- [ ] Is there anomaly detection on API usage patterns?
- [ ] Are alerts routed to the right team (not just logged and ignored)?
- [ ] Are alert thresholds tuned to avoid fatigue?
- [ ] Do security alerts have escalation paths defined?

### Missing Logging
- [ ] Grep for security-critical operations without any logging
- [ ] Check if error handlers silently swallow exceptions without logging
- [ ] Verify that rate limit violations are logged and alerted

---

## 10. Mishandling of Exceptional Conditions [A10:2025 | DE.AE | CWE-754, CWE-755, CWE-248, CWE-390]

NEW in 2025. Covers 24 CWEs focusing on improper error handling, logical errors, failing open and other scenarios when systems encounter abnormal conditions. 50% of OWASP survey respondents ranked this their #1 emerging concern.

### Fail-Open Logic
- [ ] Does the application grant access when an error occurs in the auth/authz path?
- [ ] If a permission check throws an exception, does the request proceed or get denied?
- [ ] If an external auth service (OAuth, LDAP, SAML) times out, does the system fail open?
- [ ] If rate limiting fails (Redis down, cache miss), are requests allowed through?
- [ ] Do payment/billing checks fail open (free access on payment service error)?

### Error Information Leakage
- [ ] Do error responses expose stack traces in production (CWE-209)?
- [ ] Do error messages reveal database column names, table structure or query syntax?
- [ ] Are API keys, tokens or secrets visible in error output?
- [ ] Do different error paths reveal whether a resource/user exists?
- [ ] Are internal service names, IPs or ports leaked in error messages?

### Resource Exhaustion Handling
- [ ] Are there timeouts on all external HTTP calls?
- [ ] What happens when the database connection pool is exhausted?
- [ ] What happens when disk space runs out during file upload or log writing?
- [ ] Are memory limits set for request processing (preventing OOM crashes)?
- [ ] Is there graceful degradation under high load (not cascading failures)?

### NULL and Undefined Handling
- [ ] Are NULL dereference crashes possible (CWE-476)?
- [ ] What happens when expected config values are missing?
- [ ] Are optional relationship lookups handled (user->profile when profile is null)?
- [ ] Do missing environment variables cause silent failures or crashes?

### Inconsistent Error Responses
- [ ] Does the same error condition return different formats (JSON vs HTML) on different endpoints?
- [ ] Are HTTP status codes used consistently (not 200 for errors)?
- [ ] Do error responses maintain the same security posture as success responses (CORS, CSP headers)?

### Silent Failures
- [ ] Are catch-all exception handlers swallowing errors without logging?
- [ ] Do background jobs fail silently without alerting?
- [ ] Are webhook delivery failures retried and logged?
- [ ] Do health check endpoints hide underlying service failures?

### Secure Failure Modes
- [ ] Define default-deny: if anything goes wrong, deny access
- [ ] Use consistent error-handling frameworks across the application
- [ ] Log error details internally, return generic messages externally
- [ ] Test failure scenarios explicitly (kill dependencies, exhaust resources)

---

## 11. XSS [A05:2025 | PR.DS | CWE-79, CWE-80, CWE-83]

### Stored XSS
- [ ] Is user-generated content (comments, profiles, messages) escaped on output?
- [ ] Check rich text editors (is HTML sanitized before storage and rendering)?
- [ ] Are database values rendered without escaping in templates?

### Reflected XSS
- [ ] Are URL parameters reflected in page content without escaping?
- [ ] Check error messages that include user input
- [ ] Check search results pages

### DOM-based XSS
- [ ] Grep for: `innerHTML`, `outerHTML`, `document.write`, `eval()`, `setTimeout(string)`
- [ ] Check for: `dangerouslySetInnerHTML` (React), `v-html` (Vue), `[innerHTML]` (Angular)
- [ ] Is URL fragment (`location.hash`) used in DOM manipulation?

### Output Context
- [ ] HTML context: HTML-entity encoded?
- [ ] JavaScript context: JS-escaped?
- [ ] URL context: URL-encoded?
- [ ] Are Content-Security-Policy headers set?

---

## 12. CSRF [A01:2025 | PR.DS | CWE-352]

- [ ] Are CSRF tokens included in all state-changing forms?
- [ ] Are CSRF tokens validated server-side?
- [ ] Are state-changing operations using POST/PUT/DELETE (not GET)?
- [ ] Is SameSite cookie attribute set to `Lax` or `Strict`?
- [ ] Are API endpoints protected (especially if using cookie auth)?
- [ ] Check for CSRF exemptions (are they justified)?

---

## 13. File Upload & Storage [A01:2025, A06:2025 | PR.DS | CWE-434, CWE-22]

- [ ] Are file types validated server-side (not just by extension)?
- [ ] Are uploaded files scanned for executable content?
- [ ] Is there a file size limit?
- [ ] Are filenames sanitized (no path traversal: `../../etc/passwd`)?
- [ ] Are uploaded files stored outside the web root?
- [ ] Are storage buckets (S3, GCS) properly ACL'd?
- [ ] Can users overwrite other users' files?
- [ ] Are uploaded images re-processed to strip metadata/payloads?

---

## 14. API Security [A01:2025, A05:2025, A06:2025 | PR.AA | CWE-862, CWE-20, CWE-200]

### REST API
- [ ] Is input validation applied to all API parameters?
- [ ] Are error responses generic (no stack traces, no DB column names)?
- [ ] Is rate limiting applied to sensitive endpoints?
- [ ] Is pagination enforced (no unbounded queries)?
- [ ] Are batch/bulk endpoints limited in size?
- [ ] Are deprecated endpoints still accessible?
- [ ] Is API versioning handled securely?
- [ ] Are shadow/undocumented endpoints reachable (routes registered but not in API docs)?

### GraphQL
- [ ] Is introspection disabled in production?
- [ ] Are queries depth-limited (preventing nested query attacks)?
- [ ] Is query complexity/cost analysis enforced (not just depth)?
- [ ] Are batch requests limited (query batching, alias abuse)?
- [ ] Is field-level authorization enforced (not just type-level)?
- [ ] Are persisted queries used (reject arbitrary query strings)?
- [ ] Is mutation rate limiting applied separately from queries?
- [ ] Are circular fragment references rejected?
- [ ] Does the schema expose internal types or debugging fields?

---

## 15. Business Logic Flaws [A06:2025 | PR.DS, DE.AE | CWE-841, CWE-799, CWE-362]

- [ ] Race conditions: can concurrent requests exploit timing (double-spend)?
- [ ] Price/quantity manipulation: can negative values bypass rules?
- [ ] Workflow bypass: can steps be skipped (payment in checkout)?
- [ ] Coupon/discount abuse: can codes be reused or stacked?
- [ ] Feature flag bypass: are premium features properly gated?
- [ ] Email/notification abuse: can the system be used to spam?

---

## 16. Infrastructure & DevOps [A02:2025, A03:2025, A08:2025 | PR.PS, GV.SC | CWE-16, CWE-260, CWE-829]

### Docker
- [ ] Is the container running as non-root?
- [ ] Are base images pinned to specific versions/digests?
- [ ] Are unnecessary packages removed?
- [ ] Are secrets passed via environment, not baked into images?

### CI/CD
- [ ] Are secrets stored in CI variables (not in pipeline files)?
- [ ] Can PRs from forks access secrets?
- [ ] Are build artifacts signed or verified?
- [ ] Are CI/CD actions/plugins from verified publishers?

### Git
- [ ] Scan git history for committed secrets
- [ ] Check `.gitignore` for sensitive patterns
- [ ] Are force pushes restricted on main branches?

---

## 17. AI/LLM Security [A05:2025, A01:2025, A04:2025 | PR.DS, PR.AA | CWE-74, CWE-20, CWE-200]

Covers applications that integrate AI/LLM services (OpenAI, Anthropic, Google AI, Cohere, local models via Ollama/vLLM). Aligned with OWASP Top 10 for LLM Applications 2025.

### Prompt Injection [A05:2025 | PR.DS]
- [ ] Can user input override or escape the system prompt (direct injection)?
- [ ] Can retrieved data (RAG context, tool results, emails, documents) inject instructions (indirect injection)?
- [ ] Are system prompts concatenated with user input via string interpolation (not parameterized)?
- [ ] Is there input filtering or classification before prompts reach the model?
- [ ] Can users extract the system prompt through adversarial queries?
- [ ] Are multi-turn conversations validated (can earlier turns poison later context)?
- [ ] Do structured output modes (JSON mode, tool calling) prevent injection in schema fields?

### Sensitive Data in Prompts [A04:2025 | PR.DS]
- [ ] Is PII (names, emails, SSNs, health data) sent to external AI APIs without redaction?
- [ ] Are API keys for AI services (OpenAI, Anthropic, Google) hardcoded or in client bundles?
- [ ] Is conversation history stored unencrypted?
- [ ] Are model responses cached with sensitive data included?
- [ ] Do system prompts contain API keys, database credentials or internal URLs?
- [ ] Is fine-tuning or training data reviewed for secrets and PII?
- [ ] Are AI provider data retention policies reviewed (does the provider train on your data)?

### Output Handling [A05:2025 | PR.DS]
- [ ] Is AI-generated content rendered as HTML without sanitization (XSS via LLM)?
- [ ] Is AI-generated SQL or code executed without validation?
- [ ] Are AI-generated URLs or links rendered without validation?
- [ ] Is markdown from AI output rendered unsanitized (markdown injection)?
- [ ] Are AI-generated file paths used in file system operations without sanitization?
- [ ] Do AI responses get interpolated into shell commands?
- [ ] Are tool/function call arguments from the model validated before execution?

### Access Control for AI Features [A01:2025 | PR.AA]
- [ ] Are AI tools and function calls gated by user role and permissions?
- [ ] Can all users invoke expensive AI operations (no role-based access)?
- [ ] Does RAG retrieve documents the current user is not authorized to see?
- [ ] Is there rate limiting on AI endpoints (both for cost and abuse)?
- [ ] Are AI features isolated per tenant (shared context between tenants)?
- [ ] Can users access other users' conversation history or AI-generated content?
- [ ] Are admin-only AI tools (data analysis, bulk operations) properly restricted?

### Data Integrity and Poisoning [A08:2025 | PR.DS, GV.SC]
- [ ] Can users inject content into the RAG knowledge base or vector store?
- [ ] Are embedding sources validated and from trusted origins?
- [ ] Is fine-tuning data validated before training?
- [ ] Are model versions pinned (not auto-updated to potentially compromised versions)?
- [ ] Are vector database access controls enforced (who can write embeddings)?
- [ ] Can adversarial documents in the corpus influence model outputs for other users?

### Logging and Cost Monitoring [A09:2025 | DE.CM]
- [ ] Are AI interactions logged (prompt, response, model, tokens used)?
- [ ] Is there cost monitoring and alerting for AI API spend?
- [ ] Are prompt injection attempts detected and logged?
- [ ] Is token usage tracked per user for abuse detection?
- [ ] Are AI-related errors (timeouts, rate limits, content filters) logged?
- [ ] Is there alerting on unusual AI usage patterns (sudden spikes, bulk extraction)?

### Error Handling for AI Services [A10:2025 | DE.AE]
- [ ] What happens when the AI service times out (does the request hang indefinitely)?
- [ ] Does the application fail open when the AI service is down (unfiltered content, bypassed checks)?
- [ ] Is token/context limit exceeded handled gracefully?
- [ ] Are AI provider rate limits (429 responses) handled with backoff?
- [ ] Do malformed AI responses (invalid JSON, unexpected format) crash the application?
- [ ] Are content filter rejections (model refuses to answer) handled in the UX?
- [ ] Is there a fallback when the AI model returns empty or null responses?

---

## 18. WebSocket Security [A01:2025, A05:2025, A07:2025 | PR.AA, PR.DS | CWE-287, CWE-20, CWE-400]

Covers WebSocket (ws/wss) and Server-Sent Events (SSE) implementations.

### Authentication and Authorization
- [ ] Is authentication validated during the WebSocket handshake (not just on HTTP upgrade)?
- [ ] Are authorization checks enforced per message type (not just on connection)?
- [ ] Can unauthenticated clients establish WebSocket connections?
- [ ] Is the `Origin` header validated to prevent cross-site WebSocket hijacking (CSWSH)?
- [ ] Are JWT/session tokens validated on each reconnection (not cached from initial handshake)?
- [ ] Do channel/room subscriptions enforce user permissions?

### Input Validation
- [ ] Are incoming WebSocket messages validated against an expected schema?
- [ ] Is message size limited (preventing large payload DoS)?
- [ ] Are binary frames validated if accepted?
- [ ] Can malformed JSON or protocol messages crash the handler?
- [ ] Is user input from WebSocket messages sanitized before database storage or broadcast?

### Broadcast and Isolation
- [ ] Are messages isolated per user/tenant (no cross-tenant leakage)?
- [ ] Can a user subscribe to channels they should not access?
- [ ] Are presence indicators (online/typing) scoped to authorized users?
- [ ] Is message history access controlled (can new subscribers see previous messages)?

### Resource Management
- [ ] Is there a per-user connection limit (preventing connection exhaustion)?
- [ ] Are idle connections timed out?
- [ ] Is backpressure handled (slow client consuming server memory)?
- [ ] Is message rate limiting enforced per connection?
- [ ] Are reconnection storms handled (exponential backoff on client, server-side throttle)?

---

## 19. gRPC Security [A01:2025, A05:2025, A02:2025 | PR.AA, PR.DS | CWE-287, CWE-20, CWE-400]

### Transport Security
- [ ] Is TLS/mTLS enforced for all gRPC connections (not plaintext)?
- [ ] Are client certificates validated (mutual TLS, not just server TLS)?
- [ ] Is channel encryption configured correctly (`grpc.ssl_channel_credentials`)?
- [ ] Are insecure channels (`grpc.insecure_channel`) used only in development?

### Authentication and Authorization
- [ ] Is per-RPC authentication enforced (interceptors/middleware)?
- [ ] Are metadata headers validated (no injection via user-controlled metadata)?
- [ ] Is service-to-service authentication enforced (not trusting network boundaries)?
- [ ] Are authorization checks per method (not just per service)?

### Input Validation
- [ ] Are Protobuf message fields validated beyond type checking (ranges, lengths, formats)?
- [ ] Are `oneof` fields handled correctly (unexpected field selection)?
- [ ] Are unknown fields rejected or ignored safely?
- [ ] Is maximum message size configured (`grpc.max_receive_message_length`)?
- [ ] Are streaming RPCs rate-limited (preventing message flood)?

### Service Exposure
- [ ] Is gRPC server reflection disabled in production?
- [ ] Are health check endpoints (`grpc.health.v1.Health`) not leaking internal state?
- [ ] Are internal services accessible from untrusted networks?
- [ ] Is the gRPC-Web proxy (Envoy, grpc-gateway) configured securely?

### Error Handling
- [ ] Do gRPC error responses avoid leaking internal details (status codes only, no stack traces)?
- [ ] Are deadline/timeout values set on all RPCs?
- [ ] Are cancelled contexts propagated correctly (preventing resource leaks)?
- [ ] Is retry logic bounded (preventing amplification)?

---

## 20. Serverless and Cloud-Native [A01:2025, A02:2025, A03:2025 | PR.PS, PR.AA | CWE-269, CWE-16, CWE-284]

### Serverless / FaaS (Lambda, Cloud Functions, Azure Functions)
- [ ] Are execution roles following least privilege (not `*` on all resources)?
- [ ] Are environment variables used for secrets (not hardcoded in function code)?
- [ ] Are function URLs or API Gateway endpoints authenticated (not publicly open)?
- [ ] Is the `/tmp` directory cleaned between invocations (no cross-invocation data leaks)?
- [ ] Are function timeouts configured (preventing runaway executions and cost)?
- [ ] Are cold start behaviors secure (initialization code doesn't bypass auth)?
- [ ] Are function-to-function calls authenticated (not trusting VPC boundaries)?
- [ ] Are event source mappings validated (SQS, SNS, S3 triggers can be spoofed)?
- [ ] Are layers and extensions from trusted sources?
- [ ] Is concurrency limited to prevent resource exhaustion and cost spikes?

### Kubernetes
- [ ] Are RBAC roles following least privilege (no `cluster-admin` for workloads)?
- [ ] Are `RoleBinding` and `ClusterRoleBinding` reviewed for over-permission?
- [ ] Are NetworkPolicies enforced (default deny, allow only required traffic)?
- [ ] Are Pod Security Standards applied (restricted, baseline, or privileged)?
- [ ] Are containers running as non-root with `runAsNonRoot: true`?
- [ ] Are service account tokens auto-mounted only when needed (`automountServiceAccountToken: false`)?
- [ ] Are Secrets encrypted at rest in etcd (`EncryptionConfiguration`)?
- [ ] Is the Kubernetes API server not publicly accessible?
- [ ] Are admission controllers (OPA Gatekeeper, Kyverno) enforcing policies?
- [ ] Are kubelet API endpoints secured (not accessible without auth)?
- [ ] Are container images pulled from trusted registries with image pull policies?
- [ ] Is `hostPID`, `hostNetwork`, `privileged` disabled for workload pods?

### Infrastructure as Code (Terraform, Pulumi, CloudFormation)
- [ ] Is IaC state file stored securely (encrypted S3 bucket, not local)?
- [ ] Are state file access controls enforced (not world-readable)?
- [ ] Are secrets in IaC managed via vault references (not plaintext in templates)?
- [ ] Are `terraform plan` / `pulumi preview` reviewed before apply?
- [ ] Are IaC modules from trusted sources (pinned versions, verified publishers)?
- [ ] Are drift detection and reconciliation configured?
- [ ] Are destructive changes (`destroy`, `replace`) gated behind approval?

---

## 21. Gray-Box Testing [A01:2025, A06:2025, A07:2025]

Checklists for testing from an authenticated user's perspective with partial system knowledge.

### Role-Based Access
- [ ] List all roles defined in code (migrations, models, enums, seeders, config)
- [ ] For each protected endpoint, verify which roles can access it
- [ ] Can lower-privilege roles reach higher-privilege endpoints?
- [ ] Are role checks in middleware (not just UI)?
- [ ] Does role downgrade take immediate effect?
- [ ] Are there endpoints accessible to all authenticated users that should be role-restricted?

### API Probing
- [ ] Test all endpoints with unexpected HTTP verbs (verb tampering)
- [ ] Look for undocumented params in controller code that are not in API docs
- [ ] Check if responses return more fields than the frontend uses
- [ ] Test pagination boundaries (`page=-1`, `per_page=999999`)
- [ ] Send extra fields to test mass assignment from outside

### Credential Boundaries
- [ ] What happens with expired tokens mid-request?
- [ ] Are deleted/revoked users' sessions immediately invalidated?
- [ ] Can tenant A's token access tenant B's data?
- [ ] Does password change invalidate other sessions?
- [ ] Is "remember me" token rotated and time-limited?

### Partial Knowledge Exploitation
- [ ] Use migration files to craft targeted IDOR payloads
- [ ] Use route files to find hidden/undocumented endpoints
- [ ] Check if soft-deleted records are accessible by ID
- [ ] Are internal endpoints (health, metrics, debug) reachable?

### Rate Limit Verification
- [ ] Test rate limits on login, registration, password reset, OTP
- [ ] Are limits per-user or per-IP only?
- [ ] Do rate limit headers leak configuration info?
- [ ] Do limits reset on success (enabling slow brute force)?

### Error Differential
- [ ] Compare errors between roles for the same forbidden resource
- [ ] Does "not found" vs "forbidden" leak resource existence?
- [ ] Is error format consistent across all endpoints?
- [ ] Do errors fail open under exceptional conditions? [A10:2025]

---

## 22. Security Hotspots [A06:2025 | ID, GV]

Flag sensitive code matching these patterns:

### Crypto Boundaries
- [ ] Any encryption/decryption functions
- [ ] Hashing implementations
- [ ] Key generation or storage
- [ ] Random number generation for security purposes

### Trust Boundaries
- [ ] Points where authenticated and unauthenticated contexts meet
- [ ] Serialization/deserialization crossing trust boundaries
- [ ] Webhook receivers accepting external payloads
- [ ] Message queue consumers processing external data

### Sensitive Data Handlers
- [ ] Code reading or writing PII
- [ ] Payment processing logic
- [ ] Token/OTP generation and validation
- [ ] Data export or reporting functions

### Configuration Hotspots
- [ ] Middleware registration order
- [ ] Route grouping logic (misplaced bracket can un-protect routes)
- [ ] Feature flags gating security controls
- [ ] Environment-specific behavior

### Concurrency Hotspots
- [ ] Database transactions involving money or inventory
- [ ] Job handlers modifying shared state
- [ ] Cache operations used for rate limiting

### Error Handling Hotspots [A10:2025]
- [ ] Exception handlers in auth/authz paths
- [ ] Fallback logic that could fail open
- [ ] Health check endpoints masking failures
- [ ] Circuit breaker configurations

---

## 23. Code Smells [A06:2025 | GV, PR]

### Architecture
- [ ] Controllers over 500 lines (authorization inconsistency)
- [ ] Business logic in controllers (hard to audit)
- [ ] Multiple auth mechanisms without unified interface
- [ ] No separation of public vs authenticated routes

### Authorization
- [ ] Auth checks inside methods instead of middleware/policies
- [ ] Copy-pasted role checks instead of policy system
- [ ] Routes relying only on UI hiding
- [ ] Hard-coded user IDs for permission checks

### Data Model
- [ ] Models without `$fillable` or with `$guarded = []`
- [ ] No `$casts` on models with sensitive fields
- [ ] API returning full `toArray()` without resource/transformer
- [ ] Soft-deleted records accessible through relationships

### Error Handling [A10:2025]
- [ ] Bare `catch (Exception $e)` swallowing errors
- [ ] Error responses varying between "not found" and "wrong password"
- [ ] Missing error handling on external HTTP calls
- [ ] Debug/dump statements in codebase
- [ ] Fail-open patterns in catch blocks
- [ ] Inconsistent HTTP status codes for error states

### Testing
- [ ] No tests for auth or authorization flows
- [ ] No tests for input validation edge cases
- [ ] Test fixtures with hardcoded credentials matching defaults
- [ ] No tests for error/failure scenarios

### Dependencies [A03:2025]
- [ ] Packages imported but never used
- [ ] Multiple libraries doing the same job
- [ ] No lock file committed
- [ ] Direct use of low-level crypto instead of higher-level libraries
- [ ] Wildcard version constraints

---

## 24. Framework-Specific Checks

Framework checklists are in dedicated files under `references/frameworks/` (or `~/.claude/security-audit-references/frameworks/` when installed globally).

Read the matching file based on the detected framework:

| Framework | File | Detection |
|-----------|------|-----------|
| Laravel | `frameworks/laravel.md` | `composer.json` + `artisan` |
| Next.js / React | `frameworks/nextjs.md` | `package.json` + `next.config` |
| FastAPI | `frameworks/fastapi.md` | `requirements.txt` + `fastapi` |
| Express / Node.js | `frameworks/express.md` | `package.json` + `express` |
| Django | `frameworks/django.md` | `requirements.txt` + `manage.py` |
| Ruby on Rails | `frameworks/rails.md` | `Gemfile` + `config/routes.rb` |
| Spring Boot | `frameworks/spring-boot.md` | `pom.xml` or `build.gradle` + `@SpringBootApplication` |
| ASP.NET Core | `frameworks/aspnet-core.md` | `*.csproj` + `Program.cs` |
| Go (Gin/Echo/Fiber) | `frameworks/go.md` | `go.mod` + `gin` or `echo` or `fiber` |
| Flask | `frameworks/flask.md` | `requirements.txt` + `flask` |

Load only the framework(s) detected during Phase 1 reconnaissance.
