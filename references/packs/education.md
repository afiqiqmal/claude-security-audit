# Education Compliance Pack (FERPA / COPPA)

Security checks for applications handling student education records (FERPA) and children's data (COPPA). Load this pack with `--pack education`.

### When to use this pack

Running `/security-audit` without `--pack` already covers general security (OWASP Top 10, injection, auth, crypto, etc.). Packs are **optional add-ons** that layer domain-specific compliance checks on top of the standard audit. Use this pack when your application handles student education records or serves users under 13 and you need to verify FERPA/COPPA-specific requirements like student data protection, parental consent verification, directory information controls and age-gated features.

```bash
/security-audit --pack education
/security-audit full --fix --pack education
```

## Student Data Protection [A01:2025, A04:2025 | PR.DS, PR.AA]

- [ ] Student education records are encrypted at rest (CWE-311)
- [ ] Student records are encrypted in transit using TLS 1.2+ (CWE-319)
- [ ] Personally identifiable student information is never exposed in URLs or query params (CWE-598)
- [ ] Student data is not shared with third parties without proper authorization (CWE-359)
- [ ] De-identified or aggregate data does not allow re-identification of individual students (CWE-359)
- [ ] Student data is segregated from non-education data in storage (CWE-653)
- [ ] Data retention policies enforce deletion of student records after the required period (CWE-459)

## Parental Consent and Access [A01:2025, A07:2025 | PR.AA, GV.PO]

- [ ] Verifiable parental consent is collected before gathering data from children under 13 (CWE-862)
- [ ] Consent mechanism verifies parent identity (not just a checkbox) (CWE-287)
- [ ] Parents can review personal information collected from their child (CWE-862)
- [ ] Parents can request deletion of their child's personal information (CWE-459)
- [ ] Parents can revoke consent and halt further data collection (CWE-862)
- [ ] Consent records include timestamp, parent identity and scope of consent (CWE-778)
- [ ] Re-consent is required when data use practices materially change (CWE-862)

## Directory Information and Disclosure [A01:2025, A06:2025 | PR.AA, GV.PO]

- [ ] Directory information categories are clearly defined and documented (CWE-200)
- [ ] Opt-out mechanism exists for directory information disclosure (CWE-862)
- [ ] Legitimate educational interest is validated before granting internal staff access (CWE-862)
- [ ] Disclosure logging tracks all releases of student records with recipient and purpose (CWE-778)
- [ ] FERPA-required annual notification is supported by the application (CWE-862)
- [ ] Third-party access to education records requires written consent or qualifying exception (CWE-862)
- [ ] Subcontractors with student data access are bound by data use agreements (CWE-829)

## Age Verification and Child Safety [A07:2025, A06:2025 | PR.AA, GV.RM]

- [ ] Age gate or date-of-birth collection determines if user is under 13 (CWE-306)
- [ ] Users identified as under 13 trigger COPPA-compliant consent flow (CWE-862)
- [ ] Data collection from children is limited to what is necessary for the service (CWE-359)
- [ ] Behavioral advertising and profiling are disabled for child accounts (CWE-359)
- [ ] Chat, messaging and social features have safety controls for child users (CWE-862)
- [ ] User-generated content from children is moderated before public display (CWE-862)
- [ ] Geolocation tracking is disabled for child accounts unless parental consent is given (CWE-359)

## Audit Trail and Accountability [A09:2025 | DE.CM, DE.AE]

- [ ] All access to student records is logged with user ID, timestamp and action (CWE-778)
- [ ] Audit logs are retained for the institution's required compliance period (CWE-778)
- [ ] Audit logs are tamper-proof (append-only or integrity-protected) (CWE-778)
- [ ] Failed access attempts to student records are logged and alerted on (CWE-778)
- [ ] Data breach notification procedures comply with state student privacy laws (CWE-778)
- [ ] Annual security review process is documented for FERPA compliance (CWE-778)
- [ ] Role-based access to student records is reviewed periodically (CWE-862)
