# SOC 2 Type II Compliance Pack

Security checks for applications subject to SOC 2 Type II audits. Maps to Trust Service Criteria (TSC). Load this pack with `--pack soc2`.

### When to use this pack

Running `/security-audit` without `--pack` already covers general security (OWASP Top 10, injection, auth, crypto, etc.). Packs are **optional add-ons** that layer domain-specific compliance checks on top of the standard audit. Use this pack when your application is subject to SOC 2 Type II audits and you need to verify Trust Service Criteria like logical access controls (CC6), system operations and monitoring (CC7), change management (CC8), data protection, availability and vendor management.

```bash
/security-audit --pack soc2
/security-audit full --fix --pack soc2
```

## Logical and Physical Access Controls (CC6) [A01:2025, A07:2025 | PR.AA]

- [ ] Unique user IDs are assigned - no shared or generic accounts (CWE-306)
- [ ] Role-based access control is enforced at the application layer (CWE-862)
- [ ] Least privilege principle applied - users only access what their role requires (CWE-862)
- [ ] Multi-factor authentication is required for privileged accounts (CWE-308)
- [ ] Access reviews are supported - ability to list all users and their permissions (CWE-862)
- [ ] User provisioning and de-provisioning workflows exist (CWE-286)
- [ ] Session timeout is enforced after inactivity (CWE-613)
- [ ] Failed login attempts are tracked and accounts lock after repeated failures (CWE-307)
- [ ] API keys and service accounts have scoped permissions (CWE-250)
- [ ] Network segmentation isolates sensitive components from public-facing services (CWE-653)

## System Operations and Monitoring (CC7) [A09:2025, A10:2025 | DE.CM, DE.AE]

- [ ] Security events are logged with timestamp, actor, action and resource (CWE-778)
- [ ] Audit logs are tamper-proof (append-only storage or integrity protection) (CWE-778)
- [ ] Anomaly detection alerts on unusual access patterns (CWE-778)
- [ ] Infrastructure monitoring covers CPU, memory, disk and network thresholds (CWE-400)
- [ ] Application health checks expose uptime and error rate metrics (CWE-778)
- [ ] Alerting is configured for security events (not just logging) (CWE-778)
- [ ] Log retention meets SOC 2 audit window requirements (minimum 12 months) (CWE-778)
- [ ] Incident response runbooks exist for common security scenarios (CWE-778)
- [ ] Third-party service outages are detected and alerted on (CWE-778)

## Change Management (CC8) [A03:2025, A08:2025 | GV.SC, PR.PS]

- [ ] Code changes require pull request review before merge (CWE-1104)
- [ ] CI/CD pipelines run automated tests before deployment (CWE-1104)
- [ ] Production deployments require approval from authorized personnel (CWE-1104)
- [ ] Rollback procedures are documented and tested (CWE-1104)
- [ ] Infrastructure changes are managed via IaC (Terraform, CloudFormation) with version control (CWE-1104)
- [ ] Dependency updates are reviewed for security implications (CWE-1104)
- [ ] Emergency change procedures exist with post-incident review (CWE-1104)
- [ ] Database schema migrations are versioned and reversible (CWE-1104)

## Data Protection [A04:2025 | PR.DS]

- [ ] Sensitive data is encrypted at rest using AES-256 or equivalent (CWE-311)
- [ ] Data in transit uses TLS 1.2+ with strong cipher suites (CWE-319)
- [ ] Encryption keys are managed via a dedicated key management service (CWE-321)
- [ ] Encryption key rotation is automated on a defined schedule (CWE-324)
- [ ] Backups are encrypted and access-controlled (CWE-311)
- [ ] Data classification labels are applied to distinguish sensitivity levels (CWE-359)
- [ ] Sensitive data is masked or redacted in non-production environments (CWE-212)
- [ ] Data disposal procedures exist for decommissioned systems (CWE-459)

## Availability and Disaster Recovery [A10:2025 | RC.RP, PR.IR]

- [ ] Application has defined SLA/SLO targets for uptime (CWE-400)
- [ ] Automated failover is configured for critical services (CWE-400)
- [ ] Backup procedures run on schedule with verification (CWE-778)
- [ ] Disaster recovery plan is documented and tested annually (CWE-400)
- [ ] Rate limiting and throttling protect against resource exhaustion (CWE-770)
- [ ] DDoS mitigation is in place for public-facing endpoints (CWE-400)
- [ ] Graceful degradation handles partial service outages (CWE-404)

## Risk Assessment and Vendor Management [A02:2025, A03:2025 | GV.RM, GV.SC]

- [ ] Third-party services have documented risk assessments (CWE-1104)
- [ ] Vendor SOC 2 reports are reviewed annually (CWE-1104)
- [ ] Data processing agreements are in place with all vendors handling customer data (CWE-1104)
- [ ] Sub-processor lists are maintained and changes communicated (CWE-1104)
- [ ] Vulnerability scanning runs on a regular schedule (CWE-1104)
- [ ] Penetration testing is conducted annually by an independent party (CWE-1104)
- [ ] Risk register tracks identified risks with owners and mitigation plans (CWE-1104)
- [ ] Security awareness training is documented for development teams (CWE-1104)
