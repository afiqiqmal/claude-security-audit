# Attack Vectors Reference

Detailed checklists for each attack category. Use these as a systematic guide when auditing each area. Every section is tagged with OWASP Top 10:2025 and NIST CSF 2.0.

## OWASP Top 10:2025 Changes from 2021

| 2025 | Category | Was in 2021 |
|------|----------|-------------|
| A01:2025 | Broken Access Control (now includes SSRF) | A01:2021 + A10:2021 merged |
| A02:2025 | Security Misconfiguration | A05:2021 (moved up to #2) |
| A03:2025 | Software Supply Chain Failures | A06:2021 expanded (was "Vulnerable Components") |
| A04:2025 | Cryptographic Failures | A02:2021 (moved to #4) |
| A05:2025 | Injection | A03:2021 (moved to #5) |
| A06:2025 | Insecure Design | A04:2021 (moved to #6) |
| A07:2025 | Identification and Authentication Failures | A07:2021 (unchanged) |
| A08:2025 | Software and Data Integrity Failures | A08:2021 (unchanged) |
| A09:2025 | Security Logging and Alerting Failures | A09:2021 (renamed, emphasis on alerting) |
| A10:2025 | Mishandling of Exceptional Conditions | NEW |

## Table of Contents
1. [Broken Access Control (A01:2025)](#1-broken-access-control-a012025)
2. [Security Misconfiguration (A02:2025)](#2-security-misconfiguration-a022025)
3. [Software Supply Chain Failures (A03:2025)](#3-software-supply-chain-failures-a032025)
4. [Cryptographic Failures (A04:2025)](#4-cryptographic-failures-a042025)
5. [Injection (A05:2025)](#5-injection-a052025)
6. [Insecure Design (A06:2025)](#6-insecure-design-a062025)
7. [Identification and Authentication Failures (A07:2025)](#7-identification-and-authentication-failures-a072025)
8. [Software and Data Integrity Failures (A08:2025)](#8-software-and-data-integrity-failures-a082025)
9. [Security Logging and Alerting Failures (A09:2025)](#9-security-logging-and-alerting-failures-a092025)
10. [Mishandling of Exceptional Conditions (A10:2025)](#10-mishandling-of-exceptional-conditions-a102025)
11. [XSS](#11-xss-a052025--prds)
12. [CSRF](#12-csrf-a012025--prds)
13. [File Upload & Storage](#13-file-upload--storage-a012025-a062025--prds)
14. [API Security](#14-api-security-a012025-a052025-a062025--praa)
15. [Business Logic Flaws](#15-business-logic-flaws-a062025--prds)
16. [Infrastructure & DevOps](#16-infrastructure--devops-a022025-a032025-a082025--prps)
17. [AI/LLM Security](#17-aillm-security-a052025-a012025-a042025--prds-praa)
18. [Gray-Box Testing](#18-gray-box-testing-a012025-a062025-a072025)
19. [Security Hotspots](#19-security-hotspots-a062025--id-gv)
20. [Code Smells](#20-code-smells-a062025--gv-pr)
21. [Framework-Specific Checks](#21-framework-specific-checks)

---

## 1. Broken Access Control [A01:2025 | PR.AA]

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

## 2. Security Misconfiguration [A02:2025 | PR.PS]

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

## 3. Software Supply Chain Failures [A03:2025 | GV.SC]

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

---

## 4. Cryptographic Failures [A04:2025 | PR.DS]

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

## 5. Injection [A05:2025 | PR.DS, DE.CM]

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

---

## 6. Insecure Design [A06:2025 | GV.RM]

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

## 7. Identification and Authentication Failures [A07:2025 | PR.AA]

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

### OAuth/SSO
- [ ] Is the `state` parameter validated to prevent CSRF?
- [ ] Are redirect URIs strictly validated (no open redirect)?
- [ ] Is the token exchange done server-side (not in client)?

### Password Reset
- [ ] Are reset tokens time-limited and single-use?
- [ ] Can reset tokens be predicted or reused?
- [ ] Does password reset invalidate existing sessions?

---

## 8. Software and Data Integrity Failures [A08:2025 | PR.DS, GV.SC]

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

## 9. Security Logging and Alerting Failures [A09:2025 | DE.CM, DE.AE]

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

## 10. Mishandling of Exceptional Conditions [A10:2025 | DE.AE]

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

## 11. XSS [A05:2025 | PR.DS]

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

## 12. CSRF [A01:2025 | PR.DS]

- [ ] Are CSRF tokens included in all state-changing forms?
- [ ] Are CSRF tokens validated server-side?
- [ ] Are state-changing operations using POST/PUT/DELETE (not GET)?
- [ ] Is SameSite cookie attribute set to `Lax` or `Strict`?
- [ ] Are API endpoints protected (especially if using cookie auth)?
- [ ] Check for CSRF exemptions (are they justified)?

---

## 13. File Upload & Storage [A01:2025, A06:2025 | PR.DS]

- [ ] Are file types validated server-side (not just by extension)?
- [ ] Are uploaded files scanned for executable content?
- [ ] Is there a file size limit?
- [ ] Are filenames sanitized (no path traversal: `../../etc/passwd`)?
- [ ] Are uploaded files stored outside the web root?
- [ ] Are storage buckets (S3, GCS) properly ACL'd?
- [ ] Can users overwrite other users' files?
- [ ] Are uploaded images re-processed to strip metadata/payloads?

---

## 14. API Security [A01:2025, A05:2025, A06:2025 | PR.AA]

- [ ] Is input validation applied to all API parameters?
- [ ] Are error responses generic (no stack traces, no DB column names)?
- [ ] Is rate limiting applied to sensitive endpoints?
- [ ] Is pagination enforced (no unbounded queries)?
- [ ] Are batch/bulk endpoints limited in size?
- [ ] Is GraphQL introspection disabled in production?
- [ ] Are GraphQL queries depth-limited?
- [ ] Are deprecated endpoints still accessible?
- [ ] Is API versioning handled securely?

---

## 15. Business Logic Flaws [A06:2025 | PR.DS, DE.AE]

- [ ] Race conditions: can concurrent requests exploit timing (double-spend)?
- [ ] Price/quantity manipulation: can negative values bypass rules?
- [ ] Workflow bypass: can steps be skipped (payment in checkout)?
- [ ] Coupon/discount abuse: can codes be reused or stacked?
- [ ] Feature flag bypass: are premium features properly gated?
- [ ] Email/notification abuse: can the system be used to spam?

---

## 16. Infrastructure & DevOps [A02:2025, A03:2025, A08:2025 | PR.PS, GV.SC]

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

## 17. AI/LLM Security [A05:2025, A01:2025, A04:2025 | PR.DS, PR.AA]

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

## 18. Gray-Box Testing [A01:2025, A06:2025, A07:2025]

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

## 19. Security Hotspots [A06:2025 | ID, GV]

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

## 20. Code Smells [A06:2025 | GV, PR]

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

## 21. Framework-Specific Checks

### Laravel [A01-A10:2025]
- [ ] `APP_DEBUG=false` in production [A02:2025]
- [ ] `APP_KEY` is set and unique [A04:2025]
- [ ] `.env` is not accessible via web [A02:2025]
- [ ] Mass assignment protection on all models [A01:2025]
- [ ] `$casts` used for attribute types [A05:2025]
- [ ] CSRF middleware enabled for web routes [A01:2025]
- [ ] Authorization policies used [A01:2025]
- [ ] `whereRaw()` / `DB::raw()` with user input [A05:2025]
- [ ] File validation includes `mimes` and `max` [A01:2025]
- [ ] Queued jobs don't contain unserialized user objects [A08:2025]
- [ ] Broadcasting channels verify authorization [A01:2025]
- [ ] API rate limiting configured [A07:2025]
- [ ] `Storage::url()` doesn't expose private files [A01:2025]
- [ ] Blade uses `{{ }}` not `{!! !!}` for user data [A05:2025]
- [ ] Route model binding doesn't bypass tenant scoping [A01:2025]
- [ ] No SSRF in HTTP client calls or webhook processing [A01:2025]
- [ ] Audit logging for admin actions [A09:2025]
- [ ] Exception handler doesn't fail open [A10:2025]
- [ ] `composer audit` shows no critical CVEs [A03:2025]
- [ ] Lock file committed and up to date [A03:2025]

### Next.js / React [A01-A10:2025]
- [ ] No secrets in `NEXT_PUBLIC_*` env vars [A04:2025]
- [ ] API routes validate authentication [A07:2025]
- [ ] `getServerSideProps` doesn't fetch arbitrary URLs (SSRF) [A01:2025]
- [ ] `dangerouslySetInnerHTML` sanitized [A05:2025]
- [ ] Client components don't expose sensitive server data [A04:2025]
- [ ] Middleware authorization not bypassable [A01:2025]
- [ ] Image domains restricted in `next.config.js` [A01:2025]
- [ ] No sensitive data in client-side state management [A04:2025]
- [ ] Error boundaries don't leak sensitive info [A10:2025]
- [ ] `npm audit` shows no critical CVEs [A03:2025]

### FastAPI / Python [A01-A10:2025]
- [ ] Pydantic models validate all inputs [A05:2025]
- [ ] No `eval()`, `exec()` or `pickle.loads()` with user input [A05:2025, A08:2025]
- [ ] `subprocess` calls use `shell=False` [A05:2025]
- [ ] Jinja2 templates use `autoescape=True` [A05:2025]
- [ ] CORS middleware configured restrictively [A02:2025]
- [ ] Database sessions properly closed [A02:2025]
- [ ] No SSRF in httpx/requests calls [A01:2025]
- [ ] Structured logging without sensitive data [A09:2025]
- [ ] Exception handlers return generic errors [A10:2025]
- [ ] `pip-audit` shows no critical CVEs [A03:2025]

### Express / Node.js [A01-A10:2025]
- [ ] Helmet.js middleware applied [A02:2025]
- [ ] No `eval()` or `new Function()` with user input [A05:2025]
- [ ] MongoDB queries sanitized [A05:2025]
- [ ] File paths sanitized against traversal [A01:2025]
- [ ] Rate limiting on auth endpoints [A07:2025]
- [ ] Error handler doesn't leak stack traces [A10:2025]
- [ ] Prototype pollution mitigated [A05:2025]
- [ ] No SSRF in axios/fetch calls [A01:2025]
- [ ] Audit logging on auth events [A09:2025]
- [ ] Unhandled promise rejections caught [A10:2025]
- [ ] `npm audit` shows no critical CVEs [A03:2025]

### Ruby on Rails [A01-A10:2025]
- [ ] `config.force_ssl = true` in production [A02:2025]
- [ ] `protect_from_forgery with: :exception` in ApplicationController [A01:2025]
- [ ] Strong parameters used (`params.require().permit()`) on all controllers [A01:2025]
- [ ] No `html_safe`, `raw()` or `sanitize` bypass on user input in views [A05:2025]
- [ ] `SECRET_KEY_BASE` set and not committed to source [A04:2025]
- [ ] `config.consider_all_requests_local = false` in production [A02:2025]
- [ ] No raw SQL via `find_by_sql`, `execute` or `where("col = '#{input}'")` [A05:2025]
- [ ] No `render inline:` with user-controlled content [A05:2025]
- [ ] Devise or `has_secure_password` configured with strong defaults [A07:2025]
- [ ] Session store is server-side for sensitive apps (not cookie-only) [A07:2025]
- [ ] Rack::Attack or similar rate limiting configured [A07:2025]
- [ ] `config.filter_parameters` includes passwords, tokens and secrets [A09:2025]
- [ ] Active Record callbacks don't bypass authorization checks [A01:2025]
- [ ] ActiveJob payloads don't serialize sensitive user objects [A08:2025]
- [ ] Content Security Policy configured via `content_security_policy` [A02:2025]
- [ ] `bundle audit` shows no critical CVEs [A03:2025]
- [ ] `Gemfile.lock` committed [A03:2025]

### Spring Boot / Java [A01-A10:2025]
- [ ] Spring Security configured and not disabled via `@EnableWebSecurity` overrides [A07:2025]
- [ ] CSRF protection enabled for web endpoints (not disabled globally) [A01:2025]
- [ ] Actuator endpoints not publicly accessible (`/actuator`, `/env`, `/beans`, `/heapdump`) [A02:2025]
- [ ] No SpEL (Spring Expression Language) injection via user input [A05:2025]
- [ ] All SQL uses prepared statements or JPA parameterized queries (no string concatenation) [A05:2025]
- [ ] `@Valid` or `@Validated` annotations on all request body DTOs [A05:2025]
- [ ] No `ObjectInputStream.readObject()` on untrusted data [A08:2025]
- [ ] No `Runtime.exec()` or `ProcessBuilder` with user-controlled arguments [A05:2025]
- [ ] Security headers configured (Spring Security defaults or custom) [A02:2025]
- [ ] `application.properties` / `application.yml` secrets externalized (not in source) [A04:2025]
- [ ] Production profile disables debug endpoints and verbose errors [A02:2025]
- [ ] Method-level security (`@PreAuthorize`, `@Secured`, `@RolesAllowed`) used consistently [A01:2025]
- [ ] Jackson deserialization: `DefaultTyping` disabled or restricted [A08:2025]
- [ ] Custom error pages configured (no Whitelabel Error Page in production) [A10:2025]
- [ ] CORS configured restrictively (not `allowedOrigins("*")` with credentials) [A02:2025]
- [ ] Logging with SLF4J/Logback, sensitive fields masked in MDC [A09:2025]
- [ ] `mvn dependency-check:check` or `gradle dependencyCheckAnalyze` shows no critical CVEs [A03:2025]

### ASP.NET Core [A01-A10:2025]
- [ ] `[ValidateAntiForgeryToken]` or auto-validation on all POST/PUT/DELETE actions [A01:2025]
- [ ] `[Authorize]` attribute with policies on all protected endpoints [A01:2025]
- [ ] Data Protection API used for encrypting sensitive data at rest [A04:2025]
- [ ] `ASPNETCORE_ENVIRONMENT` set to `Production` (not `Development`) in prod [A02:2025]
- [ ] Connection strings and secrets in User Secrets, Key Vault or environment vars (not `appsettings.json`) [A04:2025]
- [ ] Input validation with Data Annotations or FluentValidation on all models [A05:2025]
- [ ] No `FromSqlRaw` with string interpolation (use `FromSqlInterpolated` or parameterized) [A05:2025]
- [ ] CORS policy restrictive (not `AllowAnyOrigin().AllowCredentials()`) [A02:2025]
- [ ] HSTS, CSP and security headers via middleware [A02:2025]
- [ ] ASP.NET Core Identity configured with strong password rules [A07:2025]
- [ ] Rate limiting via `Microsoft.AspNetCore.RateLimiting` middleware [A07:2025]
- [ ] Exception handling middleware returns generic errors in production [A10:2025]
- [ ] No `Process.Start()` with user-controlled arguments [A05:2025]
- [ ] SignalR hubs enforce authorization [A01:2025]
- [ ] Logging with Serilog/NLog, sensitive data destructured or masked [A09:2025]
- [ ] `dotnet list package --vulnerable` shows no critical CVEs [A03:2025]

### Go (Gin / Echo / Fiber) [A01-A10:2025]
- [ ] SQL queries use parameterized statements (`db.Query(sql, args...)` or `sqlx`) [A05:2025]
- [ ] No `fmt.Sprintf` or string concatenation for SQL query construction [A05:2025]
- [ ] Input validation with `go-playground/validator` tags or equivalent [A05:2025]
- [ ] CORS middleware configured restrictively (not `AllowAllOrigins`) [A02:2025]
- [ ] No `os/exec.Command` with user-controlled arguments without sanitization [A05:2025]
- [ ] Templates use `html/template` (auto-escaping), not `text/template` for web output [A05:2025]
- [ ] JWT validation checks signature, expiry, issuer and audience [A07:2025]
- [ ] Rate limiting middleware applied to auth and sensitive endpoints [A07:2025]
- [ ] Panic recovery middleware installed (`gin.Recovery()`, `echo.Recover()`) [A10:2025]
- [ ] Error responses return generic messages, not stack traces or internal details [A10:2025]
- [ ] File path handling uses `filepath.Clean()` and validates against traversal [A01:2025]
- [ ] Context timeouts (`context.WithTimeout`) on all external HTTP calls and DB queries [A10:2025]
- [ ] TLS configured for production (not plain HTTP) [A04:2025]
- [ ] Structured logging (`slog`, `zerolog`, `zap`) without sensitive fields [A09:2025]
- [ ] `govulncheck ./...` shows no critical vulnerabilities [A03:2025]
- [ ] `go.sum` committed [A03:2025]

### Flask [A01-A10:2025]
- [ ] `DEBUG = False` and `TESTING = False` in production config [A02:2025]
- [ ] `SECRET_KEY` is strong, random and not hardcoded in source [A04:2025]
- [ ] CSRF protection via Flask-WTF (`CSRFProtect(app)`) [A01:2025]
- [ ] Jinja2 `autoescape=True` (default in Flask, verify not overridden) [A05:2025]
- [ ] No `| safe` filter on user-controlled content in templates [A05:2025]
- [ ] No `eval()`, `exec()`, `pickle.loads()` or `yaml.load()` with user data [A05:2025, A08:2025]
- [ ] SQLAlchemy uses parameterized queries (no `text()` with f-strings or `.format()`) [A05:2025]
- [ ] File uploads validate MIME type, size and sanitize filename (`werkzeug.utils.secure_filename`) [A01:2025]
- [ ] Session cookie has `SESSION_COOKIE_SECURE`, `SESSION_COOKIE_HTTPONLY`, `SESSION_COOKIE_SAMESITE` [A07:2025]
- [ ] Flask-Login or Flask-Security configured with session timeout [A07:2025]
- [ ] Rate limiting via Flask-Limiter on auth and sensitive endpoints [A07:2025]
- [ ] CORS configured via Flask-CORS (not `origins="*"` with `supports_credentials=True`) [A02:2025]
- [ ] Error handlers (`@app.errorhandler`) return generic messages in production [A10:2025]
- [ ] Logging configured without sensitive data (`password`, `token`, `secret`) [A09:2025]
- [ ] `pip-audit` or `safety check` shows no critical CVEs [A03:2025]
- [ ] `requirements.txt` has pinned versions or `Pipfile.lock` / `poetry.lock` committed [A03:2025]
