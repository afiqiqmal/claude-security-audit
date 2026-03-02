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

## Example: GraphQL Security [A01:2025, A05:2025 | PR.AA, PR.DS]

- [ ] Query depth limiting is enforced to prevent denial-of-service (CWE-400)
- [ ] Query complexity analysis rejects expensive nested queries (CWE-770)
- [ ] Introspection is disabled in production (CWE-215)
- [ ] Field-level authorization checks are applied (not just type-level) (CWE-862)
- [ ] Batch query (query batching / aliased queries) abuse is rate-limited (CWE-799)
- [ ] Input variables are validated before reaching resolvers (CWE-20)

## Example: Microservices Communication [A01:2025, A04:2025 | PR.AA, PR.DS]

- [ ] Service-to-service calls use mTLS or signed JWTs (CWE-295)
- [ ] API gateways enforce authentication before forwarding to internal services (CWE-306)
- [ ] Service mesh policies restrict which services can communicate (CWE-862)
- [ ] Secrets for inter-service auth are rotated on a schedule (CWE-798)
- [ ] Circuit breakers prevent cascading failures across services (CWE-404)
- [ ] Internal service endpoints are not exposed to the public network (CWE-653)

## Example: Real-Time Security (WebSocket / SignalR) [A01:2025, A07:2025 | PR.AA, DE.CM]

- [ ] WebSocket handshake validates authentication tokens (CWE-306)
- [ ] Per-message authorization prevents channel/topic leakage (CWE-862)
- [ ] Broadcast messages are scoped to authorized subscribers only (CWE-862)
- [ ] Message payloads are validated and size-limited (CWE-20)
- [ ] Connection rate limiting prevents resource exhaustion (CWE-770)

## Example: Event Streaming (Kafka / RabbitMQ) [A04:2025, A09:2025 | PR.DS, DE.CM]

- [ ] Messages containing PII are encrypted before publishing (CWE-311)
- [ ] Consumer groups have ACLs restricting topic access (CWE-862)
- [ ] Dead letter queues do not expose sensitive payloads without access control (CWE-200)
- [ ] Message schemas are validated on both producer and consumer sides (CWE-20)
- [ ] Poison message handling does not silently discard security-relevant events (CWE-390)
- [ ] Broker credentials are not hardcoded in application config (CWE-798)
