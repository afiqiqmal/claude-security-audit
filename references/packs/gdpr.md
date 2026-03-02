# GDPR Compliance Pack

Security checks for applications processing personal data of EU/EEA residents. Load this pack with `--pack gdpr`.

### When to use this pack

Running `/security-audit` without `--pack` already covers general security (OWASP Top 10, injection, auth, crypto, etc.). Packs are **optional add-ons** that layer domain-specific compliance checks on top of the standard audit. Use this pack when your application collects or processes personal data of EU/EEA residents and you need to verify GDPR-specific requirements like lawful basis, data subject rights, consent management and cross-border transfer safeguards.

```bash
/security-audit --pack gdpr
/security-audit full --fix --pack gdpr
```

## Lawful Basis and Consent [A01:2025, A06:2025 | GV.PO, PR.AA]

- [ ] Each data processing activity has a documented lawful basis (CWE-862)
- [ ] Consent collection is granular - separate consent per purpose (CWE-863)
- [ ] Consent is freely given, specific, informed and unambiguous (CWE-862)
- [ ] Pre-ticked consent boxes are not used (CWE-862)
- [ ] Consent withdrawal is as easy as consent giving (CWE-862)
- [ ] Consent records include timestamp, version of terms and method of consent (CWE-778)
- [ ] Legitimate interest processing has a documented balancing test (CWE-862)

## Data Subject Rights [A01:2025 | PR.AA, PR.DS]

- [ ] Right to access - data export endpoint returns all personal data for a subject (CWE-862)
- [ ] Right to rectification - correction workflow exists for personal data (CWE-862)
- [ ] Right to erasure - deletion endpoint removes personal data from all stores (CWE-459)
- [ ] Right to data portability - export in machine-readable format (JSON/CSV) (CWE-862)
- [ ] Right to restriction - ability to flag and restrict processing of specific records (CWE-862)
- [ ] Right to object - opt-out mechanism for profiling and direct marketing (CWE-862)
- [ ] Automated decision-making - human review option exists for automated decisions (CWE-862)
- [ ] Data subject requests are fulfilled within 30 days (CWE-862)

## Data Protection by Design [A04:2025, A06:2025 | PR.DS, GV.RM]

- [ ] Personal data is encrypted at rest and in transit (CWE-311, CWE-319)
- [ ] Data minimization - only necessary personal data is collected (CWE-359)
- [ ] Purpose limitation - data is not used beyond its stated purpose (CWE-359)
- [ ] Storage limitation - retention periods are defined and enforced (CWE-459)
- [ ] Pseudonymization is applied where full identification is not required (CWE-359)
- [ ] Privacy by default - most restrictive privacy settings applied by default (CWE-276)
- [ ] Data Protection Impact Assessment (DPIA) triggers are documented (CWE-862)

## International Transfers [A02:2025, A04:2025 | GV.SC, PR.DS]

- [ ] Cross-border data transfers have a legal mechanism (SCCs, adequacy decision, BCRs) (CWE-829)
- [ ] Third-party processors are documented with DPA agreements (CWE-829)
- [ ] Data residency requirements are enforced (EU data stays in EU if required) (CWE-829)
- [ ] Sub-processors are disclosed and authorized (CWE-829)
- [ ] Cloud services used for personal data have EU data center options (CWE-829)

## Breach Management [A09:2025, A10:2025 | RS.MA, RS.AN, DE.CM]

- [ ] Personal data breach detection mechanisms are in place (CWE-778)
- [ ] Breach notification to supervisory authority within 72 hours is documented (CWE-778)
- [ ] Breach notification to data subjects for high-risk breaches is planned (CWE-778)
- [ ] Breach register maintains records of all personal data incidents (CWE-778)
- [ ] Data breach risk assessment methodology is documented (CWE-778)

## Technical Measures [A07:2025, A09:2025 | PR.AA, DE.CM]

- [ ] Access to personal data requires authentication and authorization (CWE-862)
- [ ] Personal data access is logged with user ID, timestamp and action (CWE-778)
- [ ] Cookie consent banner implements granular cookie categories (CWE-862)
- [ ] Analytics and tracking respect user consent preferences (CWE-359)
- [ ] Third-party scripts are loaded conditionally based on consent (CWE-829)
- [ ] Privacy policy is accessible and references all data processing activities (CWE-862)
- [ ] Age verification exists for services directed at children (under 16 / under 13) (CWE-862)
