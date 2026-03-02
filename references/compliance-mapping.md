# Compliance Framework Mapping

Cross-reference tables mapping OWASP Top 10:2025 findings to CWE, SANS/CWE Top 25, OWASP ASVS 5.0, PCI DSS 4.0.1, MITRE ATT&CK, SOC 2 and ISO 27001:2022.

## Table of Contents

1. [CWE Mapping by OWASP Category](#1-cwe-mapping-by-owasp-category)
2. [SANS/CWE Top 25 (2025) Coverage](#2-sanscwe-top-25-2025-coverage)
3. [OWASP ASVS 5.0 Mapping](#3-owasp-asvs-50-mapping)
4. [PCI DSS 4.0.1 Mapping](#4-pci-dss-401-mapping)
5. [MITRE ATT&CK Mapping](#5-mitre-attck-mapping)
6. [SOC 2 Trust Service Criteria Mapping](#6-soc-2-trust-service-criteria-mapping)
7. [ISO 27001:2022 Annex A Mapping](#7-iso-270012022-annex-a-mapping)

---

## 1. CWE Mapping by OWASP Category

Each OWASP Top 10:2025 category maps to specific Common Weakness Enumeration (CWE) entries. The top CWEs per category are listed below.

### A01:2025 Broken Access Control

| CWE ID | Name | Common Example |
|--------|------|----------------|
| CWE-200 | Exposure of Sensitive Information | API returning data the user should not see |
| CWE-284 | Improper Access Control | Missing authorization checks |
| CWE-285 | Improper Authorization | Incorrect role/permission validation |
| CWE-352 | Cross-Site Request Forgery | State-changing requests without CSRF tokens |
| CWE-425 | Direct Request (Forced Browsing) | Accessing admin pages by URL |
| CWE-639 | Authorization Bypass Through User-Controlled Key | IDOR via predictable IDs |
| CWE-862 | Missing Authorization | No auth check on sensitive endpoint |
| CWE-863 | Incorrect Authorization | Auth check present but flawed |
| CWE-918 | Server-Side Request Forgery | Fetching user-supplied URLs server-side |
| CWE-22 | Path Traversal | `../` in file path parameters |

### A02:2025 Security Misconfiguration

| CWE ID | Name | Common Example |
|--------|------|----------------|
| CWE-16 | Configuration | Insecure default settings |
| CWE-260 | Password in Configuration File | Credentials in config files |
| CWE-315 | Cleartext Storage in a Cookie | Sensitive data in unencrypted cookies |
| CWE-520 | .NET Misconfiguration: Use of Impersonation | Framework-specific misconfig |
| CWE-526 | Exposure Through Environment Variables | Secrets in env vars exposed to client |
| CWE-537 | Java Runtime Error Message | Stack traces in production |
| CWE-611 | Improper Restriction of XML External Entity | XXE attacks |
| CWE-756 | Missing Custom Error Page | Default error pages leaking info |
| CWE-942 | Permissive Cross-domain Policy | Overly broad CORS |
| CWE-1004 | Sensitive Cookie Without HttpOnly | Cookies accessible to JavaScript |

### A03:2025 Software Supply Chain Failures

| CWE ID | Name | Common Example |
|--------|------|----------------|
| CWE-829 | Inclusion of Functionality from Untrusted Control Sphere | Third-party code without verification |
| CWE-494 | Download of Code Without Integrity Check | Auto-updates without signature verification |
| CWE-1035 | OWASP Top 10 2017 Category A9 | Using components with known vulnerabilities |
| CWE-1104 | Use of Unmaintained Third-Party Components | Abandoned dependencies |
| CWE-426 | Untrusted Search Path | DLL/module hijacking via package managers |
| CWE-427 | Uncontrolled Search Path Element | Dependency confusion attacks |

### A04:2025 Cryptographic Failures

| CWE ID | Name | Common Example |
|--------|------|----------------|
| CWE-261 | Weak Encoding for Password | Base64 instead of proper hashing |
| CWE-310 | Cryptographic Issues | General crypto weakness |
| CWE-319 | Cleartext Transmission | HTTP instead of HTTPS |
| CWE-321 | Use of Hard-coded Cryptographic Key | Encryption key in source code |
| CWE-326 | Inadequate Encryption Strength | Short key lengths |
| CWE-327 | Use of a Broken or Risky Cryptographic Algorithm | MD5, SHA1, DES |
| CWE-328 | Use of Weak Hash | Weak hashing for passwords |
| CWE-330 | Use of Insufficiently Random Values | Predictable tokens |
| CWE-347 | Improper Verification of Cryptographic Signature | Skipping signature checks |
| CWE-916 | Use of Password Hash With Insufficient Computational Effort | Fast hash (MD5/SHA) for passwords |

### A05:2025 Injection

| CWE ID | Name | Common Example |
|--------|------|----------------|
| CWE-20 | Improper Input Validation | Missing or incomplete validation |
| CWE-74 | Improper Neutralization of Special Elements in Output | General injection |
| CWE-77 | Command Injection | User input in shell commands |
| CWE-78 | OS Command Injection | `exec()`, `system()` with user input |
| CWE-79 | Cross-site Scripting (XSS) | Unsanitized output in HTML |
| CWE-89 | SQL Injection | String concatenation in SQL queries |
| CWE-90 | LDAP Injection | User input in LDAP queries |
| CWE-94 | Code Injection | `eval()` with user input |
| CWE-116 | Improper Encoding or Escaping of Output | Missing output encoding |
| CWE-917 | Expression Language Injection | SpEL, OGNL, EL injection |
| CWE-643 | XPath Injection | User input in XPath queries |
| CWE-80 | Improper Neutralization of Script-Related HTML Tags | Basic XSS via script tags |
| CWE-83 | Improper Neutralization of Script in Attributes | XSS via event handler attributes |

### A06:2025 Insecure Design

| CWE ID | Name | Common Example |
|--------|------|----------------|
| CWE-209 | Generation of Error Message Containing Sensitive Info | Verbose errors leaking internals |
| CWE-256 | Plaintext Storage of a Password | Passwords stored unencrypted |
| CWE-269 | Improper Privilege Management | Users can escalate their own roles |
| CWE-280 | Improper Handling of Insufficient Permissions | Failing open when permissions missing |
| CWE-311 | Missing Encryption of Sensitive Data | PII stored in plaintext |
| CWE-434 | Unrestricted Upload of File with Dangerous Type | No file type validation |
| CWE-501 | Trust Boundary Violation | Client-side data trusted server-side |
| CWE-602 | Client-Side Enforcement of Server-Side Security | Validation only in frontend |
| CWE-799 | Improper Control of Interaction Frequency | Missing rate limiting |
| CWE-841 | Improper Enforcement of Behavioral Workflow | Skippable multi-step flows |
| CWE-362 | Concurrent Execution Using Shared Resource with Improper Synchronization | Race conditions in business logic |

### A07:2025 Authentication Failures

| CWE ID | Name | Common Example |
|--------|------|----------------|
| CWE-255 | Credentials Management Errors | Poor credential handling |
| CWE-287 | Improper Authentication | Broken auth logic |
| CWE-288 | Authentication Bypass Using an Alternate Path | Bypassing login via another endpoint |
| CWE-290 | Authentication Bypass by Spoofing | IP-based auth bypass |
| CWE-294 | Authentication Bypass by Capture-replay | Session replay attacks |
| CWE-307 | Improper Restriction of Excessive Auth Attempts | No brute force protection |
| CWE-384 | Session Fixation | Reusing session ID after login |
| CWE-521 | Weak Password Requirements | Short or simple passwords allowed |
| CWE-613 | Insufficient Session Expiration | Sessions that never expire |
| CWE-640 | Weak Password Recovery Mechanism | Predictable reset tokens |
| CWE-798 | Use of Hard-coded Credentials | Default admin/admin |

### A08:2025 Software or Data Integrity Failures

| CWE ID | Name | Common Example |
|--------|------|----------------|
| CWE-345 | Insufficient Verification of Data Authenticity | Unsigned webhook payloads |
| CWE-353 | Missing Support for Integrity Check | No checksums on downloads |
| CWE-426 | Untrusted Search Path | Module loading from writable paths |
| CWE-494 | Download of Code Without Integrity Check | Auto-updates without verification |
| CWE-502 | Deserialization of Untrusted Data | `unserialize()`, `pickle.loads()` |
| CWE-565 | Reliance on Cookies without Validation | Trusting unsigned cookie values |
| CWE-784 | Reliance on Cookies in Security Decision | Auth decisions from unsigned cookies |
| CWE-830 | Inclusion of Web Functionality from an Untrusted Source | External scripts without SRI |
| CWE-915 | Improperly Controlled Modification of Dynamically-Determined Object Attributes | Mass assignment |

### A09:2025 Security Logging and Alerting Failures

| CWE ID | Name | Common Example |
|--------|------|----------------|
| CWE-117 | Improper Output Neutralization for Logs | Log injection attacks |
| CWE-223 | Omission of Security-relevant Information | Missing audit trail |
| CWE-532 | Insertion of Sensitive Information into Log File | Passwords in logs |
| CWE-778 | Insufficient Logging | No logs for auth events |

### A10:2025 Mishandling of Exceptional Conditions

| CWE ID | Name | Common Example |
|--------|------|----------------|
| CWE-248 | Uncaught Exception | Unhandled exceptions crashing the app |
| CWE-390 | Detection of Error Condition Without Action | Catching errors but ignoring them |
| CWE-392 | Missing Report of Error Condition | Errors silently swallowed |
| CWE-395 | Use of NullPointerException Catch | Catching NPE instead of null-checking |
| CWE-396 | Declaration of Catch for Generic Exception | `catch (Exception e)` hiding real errors |
| CWE-397 | Declaration of Throws for Generic Exception | Broad exception declarations |
| CWE-754 | Improper Check for Unusual or Exceptional Conditions | Missing edge case handling |
| CWE-755 | Improper Handling of Exceptional Conditions | Fail-open on errors |

---

## 2. SANS/CWE Top 25 (2025) Coverage

The SANS/CWE Top 25 Most Dangerous Software Weaknesses, mapped to OWASP Top 10:2025 categories.

| Rank | CWE ID | Name | OWASP 2025 |
|------|--------|------|------------|
| 1 | CWE-79 | Cross-site Scripting | A05:2025 |
| 2 | CWE-787 | Out-of-bounds Write | A05:2025 |
| 3 | CWE-89 | SQL Injection | A05:2025 |
| 4 | CWE-352 | Cross-Site Request Forgery | A01:2025 |
| 5 | CWE-22 | Path Traversal | A01:2025 |
| 6 | CWE-125 | Out-of-bounds Read | A05:2025 |
| 7 | CWE-78 | OS Command Injection | A05:2025 |
| 8 | CWE-416 | Use After Free | A05:2025 |
| 9 | CWE-862 | Missing Authorization | A01:2025 |
| 10 | CWE-434 | Unrestricted Upload of File with Dangerous Type | A06:2025 |
| 11 | CWE-94 | Code Injection | A05:2025 |
| 12 | CWE-20 | Improper Input Validation | A05:2025 |
| 13 | CWE-77 | Command Injection | A05:2025 |
| 14 | CWE-287 | Improper Authentication | A07:2025 |
| 15 | CWE-269 | Improper Privilege Management | A01:2025 |
| 16 | CWE-502 | Deserialization of Untrusted Data | A08:2025 |
| 17 | CWE-200 | Exposure of Sensitive Information | A01:2025 |
| 18 | CWE-863 | Incorrect Authorization | A01:2025 |
| 19 | CWE-918 | Server-Side Request Forgery | A01:2025 |
| 20 | CWE-119 | Buffer Overflow | A05:2025 |
| 21 | CWE-476 | NULL Pointer Dereference | A10:2025 |
| 22 | CWE-798 | Use of Hard-coded Credentials | A07:2025 |
| 23 | CWE-190 | Integer Overflow or Wraparound | A05:2025 |
| 24 | CWE-400 | Uncontrolled Resource Consumption | A10:2025 |
| 25 | CWE-306 | Missing Authentication for Critical Function | A07:2025 |

**Coverage**: All 25 entries are checked by the security audit. 11 map to Injection (A05), 7 to Access Control (A01), 3 to Authentication (A07), 2 to Exceptional Conditions (A10), 1 to Insecure Design (A06) and 1 to Data Integrity (A08).

---

## 3. OWASP ASVS 5.0 Mapping

The OWASP Application Security Verification Standard (ASVS) 5.0 provides verification requirements across chapters and 3 levels.

### Levels

| Level | Target | Description |
|-------|--------|-------------|
| L1 | All applications | Minimum security - basic controls all apps should meet |
| L2 | Sensitive data applications | Standard security - apps handling PII, financial or health data |
| L3 | Critical applications | Advanced security - military, healthcare, critical infrastructure |

### ASVS to OWASP Top 10:2025 Chapter Mapping

| ASVS Chapter | Title | OWASP 2025 | Key Requirements |
|--------------|-------|------------|------------------|
| V1 | Architecture, Design and Threat Modeling | A06:2025 | Threat modeling, secure architecture, input validation architecture |
| V2 | Authentication | A07:2025 | Password security, credential storage, lookup secrets, credential recovery |
| V3 | Session Management | A07:2025 | Session binding, cookie security, token-based sessions, session termination |
| V4 | Access Control | A01:2025 | General access control, operation-level, data-level, attribute-based |
| V5 | Validation, Sanitization and Encoding | A05:2025 | Input validation, sanitization, output encoding, deserialization |
| V6 | Stored Cryptography | A04:2025 | Data classification, algorithms, random values, secret management |
| V7 | Error Handling and Logging | A09:2025, A10:2025 | Log content, log processing, log protection, error handling |
| V8 | Data Protection | A04:2025, A01:2025 | General data protection, client-side, sensitive private data, HTTP headers |
| V9 | Communication | A04:2025 | Client communication, server communication |
| V10 | Malicious Code | A08:2025 | Code integrity, malicious code search, deployed application integrity |
| V11 | Business Logic | A06:2025 | Business logic security, anti-automation, input limits |
| V12 | Files and Resources | A01:2025, A06:2025 | File upload, file integrity, file execution, file storage, SSRF protection |
| V13 | API and Web Service | A01:2025, A05:2025 | Generic web service, RESTful, SOAP, GraphQL, WebSocket |
| V14 | Configuration | A02:2025 | Build and deploy, dependency, unintended security disclosure, HTTP headers |

### ASVS Requirements Count by Level

| Level | Total Requirements | What It Adds |
|-------|-------------------|--------------|
| L1 | ~130 | Core security controls every application needs |
| L2 | ~230 | Session management, data protection, API hardening |
| L3 | ~286 | Advanced crypto, defense-in-depth, tamper resistance |

---

## 4. PCI DSS 4.0.1 Mapping

Payment Card Industry Data Security Standard 4.0 requirements relevant to application security audits.

### PCI DSS Requirements to OWASP Top 10:2025

| PCI DSS Req | Title | OWASP 2025 | Application Security Relevance |
|-------------|-------|------------|-------------------------------|
| 2.2 | System Components Configured and Managed Securely | A02:2025 | Default credentials, unnecessary services, security parameters |
| 3.3-3.5 | Protect Stored Account Data | A04:2025 | Encryption at rest, key management, PAN masking |
| 4.2 | Protect with Strong Cryptography During Transmission | A04:2025 | TLS configuration, certificate validation |
| 5.2-5.4 | Protect from Malicious Software | A08:2025 | Anti-malware, phishing controls |
| 6.2 | Bespoke and Custom Software Developed Securely | A05:2025, A06:2025 | Secure coding practices, code review |
| 6.3 | Security Vulnerabilities Identified and Addressed | A03:2025 | Vulnerability management, patching, dependency scanning |
| 6.4 | Public-Facing Web Applications Protected | A05:2025, A01:2025 | WAF, input validation, output encoding |
| 6.5 | Changes Managed Securely | A08:2025 | Change control, code review, rollback procedures |
| 7.2-7.3 | Restrict Access by Business Need to Know | A01:2025 | Access control, least privilege, role-based access |
| 8.2-8.6 | Identify Users and Authenticate Access | A07:2025 | MFA, password requirements, session management, service accounts |
| 10.2-10.7 | Log and Monitor All Access | A09:2025 | Audit logging, log review, alerting, time synchronization |
| 11.3-11.4 | Test Security Regularly | A02:2025, A03:2025 | Vulnerability scanning, penetration testing |
| 12.3 | Risks Formally Identified and Managed | A06:2025 | Risk assessment, targeted risk analysis |

### PCI DSS 4.0.1 Requirement 6.2 Secure Development Checklist

These requirements directly map to code-level findings:

| Sub-Requirement | What to Check | CWE |
|----------------|---------------|-----|
| 6.2.1 | Software developed based on industry standards for secure development | Multiple |
| 6.2.2 | Software developers trained in secure coding (annually) | N/A (process) |
| 6.2.3 | Code reviewed before release for potential vulnerabilities | Multiple |
| 6.2.4 | Techniques to prevent common attacks in custom code | CWE-89, CWE-79, CWE-78 |
| 6.2.4.a | Injection attacks (SQL, LDAP, XPath, command, object) | CWE-89, CWE-90, CWE-78, CWE-77 |
| 6.2.4.b | Attacks on data and data structures (buffer overflows, XSS) | CWE-79, CWE-787 |
| 6.2.4.c | Attacks on cryptography usage | CWE-327, CWE-326, CWE-321 |
| 6.2.4.d | Attacks on business logic | CWE-841, CWE-799 |
| 6.2.4.e | Attacks on access control mechanisms | CWE-862, CWE-863, CWE-639 |
| 6.2.4.f | Attacks on any other identified vulnerability (from risk assessment) | Varies |

---

## 5. MITRE ATT&CK Mapping

MITRE ATT&CK techniques relevant to web application security findings. Maps attacker techniques to OWASP Top 10:2025 categories.

### Initial Access

| ATT&CK ID | Technique | OWASP 2025 | Finding Examples |
|-----------|-----------|------------|-----------------|
| T1190 | Exploit Public-Facing Application | A05:2025, A01:2025 | SQLi, command injection, auth bypass, SSRF |
| T1078 | Valid Accounts | A07:2025 | Default credentials, credential stuffing, compromised accounts |
| T1078.001 | Valid Accounts: Default Accounts | A02:2025 | Default admin/admin, test accounts in production |
| T1133 | External Remote Services | A01:2025, A02:2025 | Exposed admin panels, debug endpoints, management APIs |
| T1195 | Supply Chain Compromise | A03:2025 | Malicious packages, compromised dependencies |
| T1195.002 | Supply Chain Compromise: Software Supply Chain | A03:2025 | Typosquatting, dependency confusion |
| T1189 | Drive-by Compromise | A05:2025 | Stored XSS serving malicious payloads |

### Execution

| ATT&CK ID | Technique | OWASP 2025 | Finding Examples |
|-----------|-----------|------------|-----------------|
| T1059 | Command and Scripting Interpreter | A05:2025 | OS command injection via user input |
| T1059.007 | JavaScript | A05:2025 | XSS, DOM manipulation, prototype pollution |
| T1203 | Exploitation for Client Execution | A05:2025 | XSS triggering client-side code execution |

### Persistence

| ATT&CK ID | Technique | OWASP 2025 | Finding Examples |
|-----------|-----------|------------|-----------------|
| T1505.003 | Server Software Component: Web Shell | A01:2025, A06:2025 | Unrestricted file upload allowing web shell |
| T1556 | Modify Authentication Process | A07:2025 | Backdoor in auth logic, bypassed MFA |
| T1574 | Hijack Execution Flow | A08:2025 | Dependency confusion, DLL hijacking |

### Credential Access

| ATT&CK ID | Technique | OWASP 2025 | Finding Examples |
|-----------|-----------|------------|-----------------|
| T1110 | Brute Force | A07:2025 | Missing rate limiting on login |
| T1110.001 | Password Guessing | A07:2025 | Weak password policies |
| T1110.004 | Credential Stuffing | A07:2025 | No detection of credential reuse attacks |
| T1539 | Steal Web Session Cookie | A07:2025 | Missing HttpOnly, session hijacking |
| T1552 | Unsecured Credentials | A04:2025 | Hardcoded secrets, credentials in source |
| T1552.001 | Credentials In Files | A04:2025 | API keys in config files, .env committed |
| T1212 | Exploitation for Credential Access | A07:2025 | Auth bypass, token forgery |

### Privilege Escalation

| ATT&CK ID | Technique | OWASP 2025 | Finding Examples |
|-----------|-----------|------------|-----------------|
| T1068 | Exploitation for Privilege Escalation | A01:2025 | IDOR, role manipulation, vertical escalation |
| T1078 | Valid Accounts | A01:2025 | Horizontal privilege escalation |

### Defense Evasion

| ATT&CK ID | Technique | OWASP 2025 | Finding Examples |
|-----------|-----------|------------|-----------------|
| T1562 | Impair Defenses | A09:2025 | Disabling logging, bypassing WAF |
| T1562.001 | Disable or Modify Tools | A09:2025 | Log tampering, audit trail deletion |

### Collection and Exfiltration

| ATT&CK ID | Technique | OWASP 2025 | Finding Examples |
|-----------|-----------|------------|-----------------|
| T1530 | Data from Cloud Storage Object | A01:2025 | Public S3 buckets, exposed blob storage |
| T1567 | Exfiltration Over Web Service | A01:2025 | SSRF to exfiltrate data |
| T1565 | Data Manipulation | A08:2025 | Unsigned webhooks, mass assignment |
| T1557 | Adversary-in-the-Middle | A04:2025 | Missing TLS, certificate pinning bypass |

### Impact

| ATT&CK ID | Technique | OWASP 2025 | Finding Examples |
|-----------|-----------|------------|-----------------|
| T1499 | Endpoint Denial of Service | A10:2025 | Resource exhaustion, missing rate limits |
| T1498 | Network Denial of Service | A10:2025 | Amplification via SSRF, WebSocket flooding |

---

## 6. SOC 2 Trust Service Criteria Mapping

SOC 2 Type II Trust Service Criteria relevant to application security findings.

### Common Criteria (CC) to OWASP Top 10:2025

| SOC 2 Criteria | Title | OWASP 2025 | What the Audit Checks |
|---------------|-------|------------|----------------------|
| CC6.1 | Logical Access Security | A01:2025, A07:2025 | Authentication mechanisms, access control enforcement, session management |
| CC6.2 | User Registration and Authorization | A07:2025 | Registration flows, credential issuance, role assignment |
| CC6.3 | Access Removal | A07:2025 | Session invalidation on logout, account deactivation, token revocation |
| CC6.6 | System Boundary Protection | A01:2025, A02:2025 | Network segmentation, CORS, SSRF prevention, input validation boundaries |
| CC6.7 | Data Movement Restrictions | A04:2025, A01:2025 | Encryption in transit, data export controls, API data exposure |
| CC6.8 | Unauthorized Software Prevention | A03:2025, A08:2025 | Dependency verification, SRI, CSP, file upload restrictions |
| CC7.1 | Detection and Monitoring | A09:2025 | Security event logging, audit trails |
| CC7.2 | Anomaly Monitoring | A09:2025, A10:2025 | Alert configuration, anomaly detection, failed auth monitoring |
| CC7.3 | Security Event Evaluation | A09:2025 | Log analysis procedures, incident classification |
| CC7.4 | Incident Response | A10:2025 | Error handling, fail-safe defaults, incident response triggers |
| CC8.1 | Change Management | A08:2025, A03:2025 | Code review, CI/CD security, deployment verification |

### Additional Trust Service Categories

| SOC 2 Category | Title | OWASP 2025 | What the Audit Checks |
|---------------|-------|------------|----------------------|
| A1.1 | Availability Commitments | A10:2025 | Resource exhaustion prevention, rate limiting, timeout handling |
| A1.2 | Environmental Protections | A02:2025 | Infrastructure configuration, container security |
| C1.1 | Confidentiality Commitments | A04:2025, A01:2025 | Encryption, access controls, data classification |
| C1.2 | Confidentiality Disposal | A04:2025 | Secure deletion, data retention enforcement |
| PI1.1 | Processing Integrity | A08:2025, A06:2025 | Input validation, data integrity checks, business logic validation |

---

## 7. ISO 27001:2022 Annex A Mapping

ISO/IEC 27001:2022 Annex A controls relevant to application security findings.

### Annex A Controls to OWASP Top 10:2025

| Control | Title | OWASP 2025 | What the Audit Checks |
|---------|-------|------------|----------------------|
| A.5.15 | Access Control | A01:2025 | Authorization enforcement, RBAC, least privilege |
| A.5.17 | Authentication Information | A07:2025 | Password policies, credential storage, MFA |
| A.5.34 | Privacy and Protection of PII | A01:2025, A04:2025 | PII exposure, data encryption, consent management |
| A.8.2 | Privileged Access Rights | A01:2025 | Admin access controls, privilege escalation prevention |
| A.8.3 | Information Access Restriction | A01:2025 | Data-level access control, API authorization |
| A.8.4 | Access to Source Code | A02:2025 | Exposed .git, source code leaks |
| A.8.5 | Secure Authentication | A07:2025 | Login mechanisms, session management, token security |
| A.8.6 | Capacity Management | A10:2025 | Rate limiting, resource exhaustion, DoS prevention |
| A.8.7 | Protection Against Malware | A08:2025 | File upload validation, CSP, deserialization safety |
| A.8.8 | Management of Technical Vulnerabilities | A03:2025 | Dependency scanning, CVE monitoring, patching cadence |
| A.8.9 | Configuration Management | A02:2025 | Secure defaults, hardening, environment separation |
| A.8.10 | Information Deletion | A04:2025 | Secure data deletion, retention policies |
| A.8.11 | Data Masking | A04:2025, A01:2025 | PII masking, log redaction, API response filtering |
| A.8.12 | Data Leakage Prevention | A01:2025, A04:2025 | Data exposure in errors, logs, API responses, client bundles |
| A.8.16 | Monitoring Activities | A09:2025 | Security logging, alerting, audit trail completeness |
| A.8.24 | Use of Cryptography | A04:2025 | Algorithm selection, key management, TLS configuration |
| A.8.25 | Secure Development Life Cycle | A06:2025 | Secure design patterns, threat modeling |
| A.8.26 | Application Security Requirements | A05:2025, A06:2025 | Input validation, output encoding, error handling |
| A.8.27 | Secure System Architecture | A06:2025, A02:2025 | Defense in depth, trust boundaries, separation of concerns |
| A.8.28 | Secure Coding | A05:2025 | Injection prevention, parameterized queries, safe APIs |
| A.8.29 | Security Testing | A03:2025, A05:2025 | Dependency audit, vulnerability scanning, SAST/DAST findings |
| A.8.30 | Outsourced Development | A03:2025 | Third-party code review, supply chain verification |
| A.8.31 | Separation of Environments | A02:2025 | Dev/staging/production separation, environment-specific configs |

---

## Cross-Framework Quick Reference

Quick lookup: given an OWASP Top 10:2025 category, find the corresponding references in all frameworks.

| OWASP 2025 | Top CWEs | SANS Top 25 | ASVS | PCI DSS 4.0.1 | ATT&CK | SOC 2 | ISO 27001 |
|------------|----------|-------------|------|-------------|--------|-------|-----------|
| A01:2025 | CWE-862, CWE-863, CWE-639, CWE-352, CWE-918 | #4,#5,#9,#15,#17,#18,#19 | V4, V12, V13 | 7.2, 7.3 | T1190, T1068, T1530 | CC6.1, CC6.6 | A.5.15, A.8.2, A.8.3 |
| A02:2025 | CWE-16, CWE-611, CWE-942 | - | V14 | 2.2, 11.3 | T1078.001, T1133 | CC6.6, A1.2 | A.8.4, A.8.9, A.8.31 |
| A03:2025 | CWE-829, CWE-494, CWE-1104 | - | V14 | 6.3, 11.3 | T1195, T1574 | CC6.8, CC8.1 | A.8.8, A.8.29, A.8.30 |
| A04:2025 | CWE-327, CWE-328, CWE-330, CWE-321 | - | V6, V8, V9 | 3.3-3.5, 4.2 | T1552, T1557 | CC6.7, C1.1 | A.8.10, A.8.11, A.8.24 |
| A05:2025 | CWE-79, CWE-89, CWE-78, CWE-94 | #1,#2,#3,#6,#7,#8,#11,#12,#13,#20,#23 | V5, V13 | 6.2, 6.4 | T1059, T1190, T1203 | CC6.6, PI1.1 | A.8.26, A.8.28 |
| A06:2025 | CWE-209, CWE-434, CWE-799, CWE-841 | #10 | V1, V11 | 12.3 | T1505.003 | PI1.1 | A.8.25, A.8.27 |
| A07:2025 | CWE-287, CWE-307, CWE-384, CWE-798 | #14,#22,#25 | V2, V3 | 8.2-8.6 | T1078, T1110, T1539 | CC6.1, CC6.2, CC6.3 | A.5.17, A.8.5 |
| A08:2025 | CWE-502, CWE-345, CWE-494, CWE-915 | #16 | V10 | 6.5 | T1565, T1574 | CC8.1, CC6.8 | A.8.7 |
| A09:2025 | CWE-778, CWE-532, CWE-117 | - | V7 | 10.2-10.7 | T1562 | CC7.1, CC7.2, CC7.3 | A.8.16 |
| A10:2025 | CWE-754, CWE-755, CWE-248, CWE-390 | #21,#24 | V7 | - | T1499 | CC7.4, A1.1 | A.8.6 |
