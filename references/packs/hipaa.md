# HIPAA Compliance Pack

Security checks for applications handling Protected Health Information (PHI). Load this pack with `--pack hipaa`.

### When to use this pack

Running `/security-audit` without `--pack` already covers general security (OWASP Top 10, injection, auth, crypto, etc.). Packs are **optional add-ons** that layer domain-specific compliance checks on top of the standard audit. Use this pack when your application stores, processes or transmits PHI and you need to verify HIPAA-specific requirements like PHI encryption, audit trails, BAA agreements and breach notification readiness.

```bash
/security-audit --pack hipaa
/security-audit full --fix --pack hipaa
```

## PHI Data Protection [A01:2025, A04:2025 | PR.DS, PR.AA]

- [ ] PHI is encrypted at rest using AES-256 or equivalent (CWE-311)
- [ ] PHI is encrypted in transit using TLS 1.2+ (CWE-319)
- [ ] Database columns containing PHI use column-level encryption (CWE-312)
- [ ] PHI is never logged in application logs, debug output or error messages (CWE-532)
- [ ] PHI is never included in URLs or query parameters (CWE-598)
- [ ] PHI is never stored in browser localStorage, sessionStorage or cookies (CWE-922)
- [ ] Backups containing PHI are encrypted (CWE-311)
- [ ] PHI at rest has documented encryption key management and rotation (CWE-324)

## Access Controls [A01:2025, A07:2025 | PR.AA]

- [ ] Role-based access control enforced for all PHI endpoints (CWE-862)
- [ ] Minimum necessary access - users only see PHI required for their role (CWE-862)
- [ ] Break-the-glass / emergency access has audit logging and approval workflow (CWE-778)
- [ ] Patient consent is verified before sharing PHI with third parties (CWE-862)
- [ ] Unique user identification - no shared accounts for PHI access (CWE-306)
- [ ] Automatic session timeout after inactivity (15 minutes recommended) (CWE-613)
- [ ] Multi-factor authentication required for remote PHI access (CWE-308)

## Audit Trail [A09:2025 | DE.CM, DE.AE]

- [ ] All PHI access events are logged (read, create, update, delete) (CWE-778)
- [ ] Audit logs include user ID, timestamp, action, resource accessed and IP address (CWE-778)
- [ ] Audit logs are tamper-proof (append-only or integrity-protected) (CWE-778)
- [ ] Audit logs are retained for minimum 6 years (HIPAA requirement) (CWE-778)
- [ ] Failed access attempts to PHI are logged and alerted on (CWE-778)
- [ ] Audit log exports are available for compliance reviews (CWE-778)
- [ ] PHI disclosure tracking - who accessed what patient data and when (CWE-778)

## Business Associate Requirements [A03:2025, A08:2025 | GV.SC]

- [ ] Third-party services processing PHI have BAA agreements (CWE-829)
- [ ] PHI sent to external APIs is minimized and encrypted (CWE-319)
- [ ] Cloud storage for PHI uses HIPAA-eligible services with BAA (CWE-829)
- [ ] Email containing PHI uses encryption (not plain SMTP) (CWE-319)
- [ ] AI/LLM services do not receive raw PHI without de-identification (CWE-359)

## Data Integrity and Disposal [A08:2025 | PR.DS]

- [ ] PHI modifications are tracked with before/after values (CWE-345)
- [ ] Data disposal procedures exist for PHI (secure delete, not soft delete alone) (CWE-459)
- [ ] De-identification follows HIPAA Safe Harbor or Expert Determination method (CWE-359)
- [ ] Patient right to access - export functionality exists for patient data (CWE-862)
- [ ] Patient right to amendment - correction workflow exists for PHI records (CWE-862)

## Breach Notification [A10:2025 | RS.MA, RS.AN]

- [ ] Breach detection mechanisms are in place (anomaly detection on PHI access) (CWE-778)
- [ ] Incident response plan covers PHI breach notification within 60 days (CWE-778)
- [ ] Breach risk assessment methodology is documented (CWE-778)
- [ ] Contact information for HHS OCR breach reporting is documented (CWE-778)
