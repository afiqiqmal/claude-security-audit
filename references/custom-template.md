# Custom Security Checks Template

Copy this file to one of the custom check folders and rename it to describe your checks:
- `~/.claude/security-audit-custom/` for checks that apply to all your projects
- `.claude/security-audit-custom/` (in your project root) for project-specific checks

The audit will read all `.md` files from these folders during Phase 1 and treat each file as an additional checklist during Phase 2.

## Format

Organize your checks under headings. Use checkboxes for individual items. Tag each section with the relevant OWASP and NIST categories.

---

## Example: Internal API Standards [A01:2025, A05:2025 | PR.AA, PR.DS]

- [ ] All internal API endpoints require service-to-service auth tokens
- [ ] Request payloads are validated against a JSON schema before processing
- [ ] Response bodies never include internal database IDs (use UUIDs)
- [ ] API versioning follows the `/v1/` prefix convention
- [ ] Deprecated endpoints return 410 Gone with a migration guide header

## Example: Payment Processing [A04:2025, A09:2025 | PR.DS, DE.CM]

- [ ] Credit card numbers are never stored - only tokenized references
- [ ] Payment webhook signatures are verified before processing
- [ ] All payment events are logged with amount, status and actor
- [ ] Refund operations require a separate permission from charge operations
- [ ] Failed payment attempts trigger alerts after 3 consecutive failures

## Example: Compliance Requirements [A09:2025 | GV.OC, GV.PO]

- [ ] All PII access is logged with the accessing user and timestamp
- [ ] Data retention policies are enforced via automated cleanup jobs
- [ ] User consent records are stored with version and timestamp
- [ ] Data export requests can be fulfilled within 72 hours
- [ ] Audit logs are immutable and retained for 12 months
