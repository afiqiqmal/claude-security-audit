# Fintech Compliance Pack

Security checks for financial services applications handling transactions, payment data and financial records. Load this pack with `--pack fintech`.

### When to use this pack

Running `/security-audit` without `--pack` already covers general security (OWASP Top 10, injection, auth, crypto, etc.). Packs are **optional add-ons** that layer domain-specific compliance checks on top of the standard audit. Use this pack when your application handles financial transactions, payment processing or regulated financial data and you need to verify fintech-specific requirements like PCI DSS controls, fraud detection, KYC/AML workflows and transaction integrity.

```bash
/security-audit --pack fintech
/security-audit full --fix --pack fintech
```

## Transaction Security [A01:2025, A05:2025 | PR.DS, PR.AA]

- [ ] All financial transactions use database transactions with proper isolation levels (CWE-367)
- [ ] Double-spend prevention - idempotency keys required on payment endpoints (CWE-362)
- [ ] Race condition protection on balance updates (optimistic locking or serializable isolation) (CWE-362)
- [ ] Transaction amount validation - max limits, negative amount rejection, precision checks (CWE-20)
- [ ] Currency handling uses integer/decimal types, never floating point (CWE-681)
- [ ] Transaction reversal/refund has separate authorization from creation (CWE-862)
- [ ] Batch transaction processing validates each item individually (CWE-20)
- [ ] Transaction timestamps use server-side UTC, never client-provided times (CWE-345)

## Payment Card Data (PCI DSS) [A01:2025, A04:2025 | PR.DS, PR.AA]

- [ ] Primary Account Numbers (PAN) are never stored in plaintext (CWE-312)
- [ ] PAN is masked in all display contexts (show only last 4 digits) (CWE-200)
- [ ] CVV/CVC is never stored after authorization (CWE-312)
- [ ] Card data is tokenized using a PCI-compliant payment processor (CWE-311)
- [ ] PAN is never logged in application logs, debug output or error messages (CWE-532)
- [ ] Card data transmission uses TLS 1.2+ exclusively (CWE-319)
- [ ] Cardholder data environment (CDE) is segmented from other systems (CWE-653)
- [ ] Payment forms use iframes from PCI-compliant providers (not self-hosted fields) (CWE-319)

## Authentication and Authorization [A01:2025, A07:2025 | PR.AA]

- [ ] Multi-factor authentication required for financial transactions above threshold (CWE-308)
- [ ] Step-up authentication for high-value operations (wire transfers, beneficiary changes) (CWE-306)
- [ ] Session timeout is aggressive for financial operations (5-15 minutes) (CWE-613)
- [ ] IP/device change during session triggers re-authentication (CWE-384)
- [ ] Maker-checker (dual control) for high-value or bulk operations (CWE-862)
- [ ] API keys for financial operations have granular scopes and IP whitelisting (CWE-862)
- [ ] Withdrawal and transfer endpoints have separate rate limits from read operations (CWE-770)

## Fraud Detection [A06:2025, A09:2025 | DE.CM, DE.AE]

- [ ] Velocity checks on transaction frequency and amounts (CWE-799)
- [ ] Anomaly detection on transaction patterns (unusual amounts, times, locations) (CWE-778)
- [ ] Device fingerprinting for transaction risk scoring (CWE-778)
- [ ] Geographic restriction enforcement (blocked countries, unusual locations) (CWE-778)
- [ ] Real-time alerting on suspicious transaction patterns (CWE-778)
- [ ] Account takeover detection (credential change + immediate withdrawal) (CWE-778)
- [ ] Transaction audit trail is immutable and complete (CWE-778)

## Regulatory Compliance [A09:2025 | GV.PO, DE.CM]

- [ ] KYC (Know Your Customer) verification status checked before financial operations (CWE-862)
- [ ] AML (Anti-Money Laundering) screening on transactions above reporting thresholds (CWE-778)
- [ ] Suspicious Activity Report (SAR) triggers are documented and automated (CWE-778)
- [ ] Transaction reporting for regulatory requirements (CTR for >$10K) (CWE-778)
- [ ] Audit trail retention meets regulatory minimums (5-7 years) (CWE-778)
- [ ] Regulatory holds - ability to freeze accounts/transactions on demand (CWE-862)

## Data Protection [A02:2025, A04:2025 | PR.DS, PR.PS]

- [ ] Financial records encrypted at rest with key rotation (CWE-311)
- [ ] Account numbers and routing numbers masked in UI and logs (CWE-200)
- [ ] API responses never include full account numbers (CWE-200)
- [ ] Database backups are encrypted and access-controlled (CWE-311)
- [ ] Test environments never use production financial data (CWE-200)
- [ ] Secrets and API keys for payment processors stored in vault, not config files (CWE-798)
