# NIST CSF 2.0 + OWASP Top 10:2025 Cross-Reference

This reference maps audit findings to both NIST CSF 2.0 and OWASP Top 10:2025.

## OWASP Top 10:2025 to NIST Quick Mapping

| OWASP | Category | Primary NIST | Secondary NIST |
|-------|----------|-------------|---------------|
| A01:2025 | Broken Access Control (incl. SSRF) | PR.AA | PR.DS, DE.CM, PR.PS |
| A02:2025 | Security Misconfiguration | PR.PS | PR.IR, GV.PO |
| A03:2025 | Software Supply Chain Failures | GV.SC | ID.RA, PR.DS |
| A04:2025 | Cryptographic Failures | PR.DS | PR.PS |
| A05:2025 | Injection | PR.DS | DE.CM, PR.PS |
| A06:2025 | Insecure Design | GV.RM | GV.RR, ID.RA |
| A07:2025 | Authentication Failures | PR.AA | PR.DS, DE.CM |
| A08:2025 | Software or Data Integrity Failures | PR.DS | GV.SC, PR.PS |
| A09:2025 | Security Logging and Alerting Failures | DE.CM | DE.AE, RS.MA |
| A10:2025 | Mishandling of Exceptional Conditions | DE.AE | PR.DS, PR.IR, RS.MA |

## NIST CSF 2.0 Functions and Categories

### GV - Govern

| Category | ID | OWASP 2025 | Description |
|----------|------|-------|-------------|
| Organizational Context | GV.OC | A06:2025 | Mission, stakeholders, legal/regulatory requirements |
| Risk Management Strategy | GV.RM | A06:2025 | Priorities, risk tolerance, appetite |
| Roles and Responsibilities | GV.RR | A01:2025, A06:2025 | Cybersecurity roles and accountability |
| Policy | GV.PO | A02:2025 | Organizational policy enforcement |
| Oversight | GV.OV | A09:2025 | Review of cybersecurity activities |
| Supply Chain Risk Management | GV.SC | A03:2025, A08:2025 | Third-party and supply chain risk |

### ID - Identify

| Category | ID | OWASP 2025 | Description |
|----------|------|-------|-------------|
| Asset Management | ID.AM | A01:2025, A04:2025 | Identifying and managing assets |
| Risk Assessment | ID.RA | A03:2025, A06:2025 | Understanding cybersecurity risk |
| Improvement | ID.IM | A06:2025 | Identifying improvements from assessments |

### PR - Protect

| Category | ID | OWASP 2025 | Description |
|----------|------|-------|-------------|
| Auth and Access Control | PR.AA | A01:2025, A07:2025 | Limiting access to authorized users |
| Awareness and Training | PR.AT | A06:2025, A07:2025 | Security awareness for personnel |
| Data Security | PR.DS | A04:2025, A05:2025, A08:2025, A10:2025 | Protecting data confidentiality and integrity |
| Platform Security | PR.PS | A02:2025, A01:2025 | Securing hardware, software and services |
| Infrastructure Resilience | PR.IR | A02:2025, A10:2025 | Security architecture and resilience |

### DE - Detect

| Category | ID | OWASP 2025 | Description |
|----------|------|-------|-------------|
| Continuous Monitoring | DE.CM | A09:2025 | Monitoring for anomalies and compromise indicators |
| Adverse Event Analysis | DE.AE | A09:2025, A10:2025 | Analyzing anomalies and detecting incidents |

### RS - Respond

| Category | ID | OWASP 2025 | Description |
|----------|------|-------|-------------|
| Incident Management | RS.MA | A09:2025, A10:2025 | Managing incident responses |
| Incident Analysis | RS.AN | A09:2025 | Investigation for effective response |
| Incident Response Reporting | RS.CO | A09:2025 | Coordinating response with stakeholders |
| Incident Mitigation | RS.MI | A01:2025 | Preventing expansion of events |

### RC - Recover

| Category | ID | OWASP 2025 | Description |
|----------|------|-------|-------------|
| Recovery Plan Execution | RC.RP | - | Restoring operational availability |
| Recovery Communication | RC.CO | - | Coordinating restoration activities |

---

## Detailed Finding Type Mapping

### A01:2025 - Broken Access Control (includes SSRF)

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| IDOR | A01:2025 | PR.AA | PR.DS |
| Privilege escalation | A01:2025 | PR.AA | GV.RR |
| Missing auth middleware | A01:2025 | PR.AA | GV.PO |
| Tenant isolation failure | A01:2025 | PR.AA | PR.DS |
| CORS misconfiguration | A01:2025 | PR.AA | PR.PS |
| CSRF | A01:2025 | PR.DS | PR.AA |
| Path traversal | A01:2025 | PR.AA | PR.DS |
| SSRF - URL fetching | A01:2025 | PR.AA | PR.DS |
| SSRF - cloud metadata | A01:2025 | PR.AA | PR.PS |
| SSRF - DNS rebinding | A01:2025 | PR.AA | DE.CM |
| SSRF - redirect following | A01:2025 | PR.DS | PR.PS |

### A02:2025 - Security Misconfiguration

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| Debug mode in production | A02:2025 | PR.PS | PR.DS |
| Default credentials | A02:2025 | PR.PS | PR.AA |
| Missing security headers | A02:2025 | PR.PS | PR.DS |
| Exposed admin panel | A02:2025 | PR.PS | PR.AA |
| Directory listing enabled | A02:2025 | PR.PS | PR.DS |
| Permissive CORS | A02:2025 | PR.PS | PR.AA |

### A03:2025 - Software Supply Chain Failures

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| Known CVEs in deps | A03:2025 | GV.SC | ID.RA |
| Outdated dependencies | A03:2025 | GV.SC | ID.RA |
| Missing lock files | A03:2025 | GV.SC | PR.PS |
| Unmaintained packages | A03:2025 | GV.SC | ID.RA |
| Typosquatting risk | A03:2025 | GV.SC | ID.RA |
| Malicious post-install scripts | A03:2025 | GV.SC | PR.DS |
| Unverified CI/CD plugins | A03:2025 | GV.SC | PR.PS |
| Unverified container images | A03:2025 | GV.SC | PR.PS |
| Compromised transitive deps | A03:2025 | GV.SC | ID.RA |

### A04:2025 - Cryptographic Failures

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| Weak password hashing | A04:2025 | PR.DS | PR.AA |
| Missing encryption at rest | A04:2025 | PR.DS | GV.RM |
| Hardcoded secrets | A04:2025 | PR.DS | ID.AM |
| Exposed secrets in client bundle | A04:2025 | PR.DS | PR.PS |
| Weak TLS configuration | A04:2025 | PR.PS | PR.DS |

### A05:2025 - Injection

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| SQL injection | A05:2025 | PR.DS | DE.CM |
| Command injection | A05:2025 | PR.DS | RS.MA |
| Template injection (SSTI) | A05:2025 | PR.DS | PR.PS |
| XSS (stored/reflected/DOM) | A05:2025 | PR.DS | PR.PS |
| NoSQL injection | A05:2025 | PR.DS | DE.CM |
| Header injection | A05:2025 | PR.DS | PR.PS |

### A06:2025 - Insecure Design

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| Missing rate limits on critical ops | A06:2025 | GV.RM | PR.AA |
| No re-authentication for sensitive ops | A06:2025 | GV.RM | PR.AA |
| Workflow bypass possible | A06:2025 | GV.RM | PR.DS |
| Race conditions by design | A06:2025 | GV.RM | PR.DS |
| No input validation layer | A06:2025 | GV.RM | PR.DS |
| Business logic flaws | A06:2025 | GV.RM | DE.AE |

### A07:2025 - Authentication Failures

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| Session fixation | A07:2025 | PR.AA | PR.DS |
| JWT misconfiguration | A07:2025 | PR.AA | PR.DS |
| Missing brute force protection | A07:2025 | PR.AA | DE.CM |
| Insecure password reset | A07:2025 | PR.AA | PR.DS |
| OAuth state missing | A07:2025 | PR.AA | PR.DS |

### A08:2025 - Software or Data Integrity Failures

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| Insecure deserialization | A08:2025 | PR.DS | PR.PS |
| CI/CD pipeline injection | A08:2025 | GV.SC | PR.PS |
| Missing code signing | A08:2025 | GV.SC | PR.DS |
| Unsigned webhooks | A08:2025 | PR.DS | GV.SC |
| Untrusted build inputs | A08:2025 | GV.SC | PR.PS |

### A09:2025 - Security Logging and Alerting Failures

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| No auth event logging | A09:2025 | DE.CM | RS.MA |
| Sensitive data in logs | A09:2025 | DE.CM | PR.DS |
| No alerting on failures | A09:2025 | DE.AE | RS.MA |
| Silent exception swallowing | A09:2025 | DE.AE | DE.CM |
| Missing audit trail | A09:2025 | DE.CM | GV.OV |
| Logging without alerting | A09:2025 | DE.AE | RS.MA |

### A10:2025 - Mishandling of Exceptional Conditions

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| Fail-open on auth error | A10:2025 | DE.AE | PR.AA |
| Stack trace in error response | A10:2025 | DE.AE | PR.DS |
| NULL dereference crash | A10:2025 | DE.AE | PR.IR |
| Resource exhaustion unhandled | A10:2025 | DE.AE | PR.IR |
| Missing timeout on external calls | A10:2025 | DE.AE | PR.IR |
| Inconsistent error responses | A10:2025 | DE.AE | PR.DS |
| Silent failure masking incidents | A10:2025 | DE.AE | DE.CM |
| Missing graceful degradation | A10:2025 | PR.IR | DE.AE |

---

## WebSocket, gRPC and Serverless Finding Mapping

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| WebSocket handshake auth missing | A07:2025 | PR.AA | PR.DS |
| Cross-site WebSocket hijacking | A01:2025 | PR.AA | PR.DS |
| WebSocket message injection | A05:2025 | PR.DS | PR.AA |
| WebSocket broadcast leakage | A01:2025 | PR.AA | PR.DS |
| WebSocket connection exhaustion | A06:2025 | PR.IR | DE.CM |
| gRPC plaintext channel in prod | A04:2025 | PR.DS | PR.PS |
| gRPC reflection enabled in prod | A02:2025 | PR.PS | ID.AM |
| gRPC metadata injection | A05:2025 | PR.DS | PR.AA |
| gRPC missing per-RPC auth | A01:2025 | PR.AA | GV.RR |
| Serverless over-privileged execution role | A01:2025 | PR.AA | GV.RM |
| Serverless env var secret exposure | A04:2025 | PR.DS | PR.PS |
| K8s RBAC over-permission | A01:2025 | PR.AA | GV.RR |
| K8s NetworkPolicy missing | A02:2025 | PR.PS | PR.IR |
| K8s secrets unencrypted in etcd | A04:2025 | PR.DS | PR.PS |
| K8s privileged container | A01:2025 | PR.AA | PR.PS |
| IaC state file exposed | A04:2025 | PR.DS | PR.PS |
| IaC secrets in plaintext | A04:2025 | PR.DS | GV.PO |
| HTTP request smuggling | A05:2025 | PR.DS | PR.PS |
| SBOM not generated | A03:2025 | GV.SC | ID.AM |
| Build provenance missing (SLSA) | A08:2025 | GV.SC | PR.DS |

---

## OAuth 2.1, Passkeys and FIDO2 Finding Mapping

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| PKCE not enforced | A07:2025 | PR.AA | PR.DS |
| Implicit grant flow enabled | A07:2025 | PR.AA | GV.PO |
| Auth code lifetime too long | A07:2025 | PR.AA | PR.DS |
| DPoP not used for token binding | A07:2025 | PR.AA | PR.DS |
| WebAuthn attestation not verified | A07:2025 | PR.AA | PR.DS |
| Authenticator counter not validated | A07:2025 | PR.AA | DE.CM |
| Passkey revocation not supported | A07:2025 | PR.AA | RS.MI |
| Backup codes stored insecurely | A04:2025 | PR.DS | PR.AA |

---

## AI/LLM Security Finding Mapping

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| Direct prompt injection | A05:2025 | PR.DS | DE.CM |
| Indirect prompt injection (RAG) | A05:2025 | PR.DS | GV.SC |
| PII sent to external AI APIs | A04:2025 | PR.DS | GV.PO |
| AI API keys hardcoded or exposed | A04:2025 | PR.DS | ID.AM |
| AI output rendered as unsanitized HTML | A05:2025 | PR.DS | PR.PS |
| AI-generated code/SQL executed unvalidated | A05:2025 | PR.DS | PR.PS |
| Tool/function calling without auth checks | A01:2025 | PR.AA | GV.RR |
| RAG retrieving unauthorized documents | A01:2025 | PR.AA | PR.DS |
| RAG data source poisoning | A08:2025 | PR.DS | GV.SC |
| No rate limiting on AI endpoints | A06:2025 | PR.AA | DE.CM |
| AI cost monitoring absent | A06:2025 | DE.CM | GV.RM |
| AI interactions not logged | A09:2025 | DE.CM | GV.OV |
| Prompt injection attempts not detected | A09:2025 | DE.AE | DE.CM |
| AI service timeout unhandled | A10:2025 | DE.AE | PR.IR |
| Fail-open when AI service is down | A10:2025 | DE.AE | PR.AA |
| Model version not pinned | A03:2025 | GV.SC | ID.RA |
| Shared AI context between tenants | A01:2025 | PR.AA | PR.DS |

---

## Gray-Box Finding Mapping

| Finding Type | OWASP | NIST Primary | NIST Secondary |
|-------------|-------|-------------|---------------|
| Role-based access bypass | A01:2025 | PR.AA | GV.RR |
| API verb tampering | A01:2025 | PR.AA | PR.PS |
| Over-fetching in responses | A01:2025 | PR.DS | PR.AA |
| Expired token still valid | A07:2025 | PR.AA | PR.DS |
| Tenant isolation breach | A01:2025 | PR.AA | PR.DS |
| Rate limit not enforced | A06:2025, A07:2025 | PR.AA | DE.CM |
| Error differential leaking info | A10:2025 | PR.DS | DE.AE |
| Hidden endpoint accessible | A01:2025 | PR.AA | PR.PS |
| Soft-deleted records accessible | A01:2025 | PR.AA | PR.DS |
| Session not invalidated on revoke | A07:2025 | PR.AA | RS.MI |
| Fail-open on error during gray-box | A10:2025 | DE.AE | PR.AA |
