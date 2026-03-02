# SaaS Multi-Tenant Security Pack

Security checks for multi-tenant SaaS applications. Load this pack with `--pack saas-multi-tenant`.

### When to use this pack

Running `/security-audit` without `--pack` already covers general security (OWASP Top 10, injection, auth, crypto, etc.). Packs are **optional add-ons** that layer domain-specific compliance checks on top of the standard audit. Use this pack when your application serves multiple tenants from a shared infrastructure and you need to verify multi-tenancy-specific requirements like tenant data isolation, cross-tenant access prevention, resource limits and tenant administration controls.

```bash
/security-audit --pack saas-multi-tenant
/security-audit full --fix --pack saas-multi-tenant
```

## Tenant Isolation [A01:2025 | PR.AA, PR.DS]

- [ ] Every database query includes tenant scoping (WHERE tenant_id = ?) (CWE-863)
- [ ] Global scopes or query filters enforce tenant isolation at the ORM level (CWE-863)
- [ ] Direct SQL queries and raw database calls include tenant filtering (CWE-863)
- [ ] Background jobs and queue workers operate within tenant context (CWE-863)
- [ ] Cache keys are namespaced per tenant to prevent cross-tenant data leaks (CWE-200)
- [ ] File storage paths/buckets are isolated per tenant (CWE-863)
- [ ] Search indexes are scoped per tenant (CWE-200)
- [ ] WebSocket channels and real-time events are isolated per tenant (CWE-863)
- [ ] Exported reports and downloads are scoped to the requesting tenant (CWE-200)

## Authentication and Session [A01:2025, A07:2025 | PR.AA]

- [ ] Tenant identification happens before authentication (subdomain, header or token claim) (CWE-287)
- [ ] JWT tokens or session data include tenant ID claim (CWE-862)
- [ ] Cross-tenant session reuse is impossible (session bound to tenant) (CWE-384)
- [ ] Tenant switching (if supported) requires re-authentication or explicit authorization (CWE-862)
- [ ] Admin impersonation of tenant users is audit-logged (CWE-778)
- [ ] OAuth/SSO configurations are per-tenant (CWE-287)
- [ ] API keys are bound to a specific tenant (CWE-862)

## Data Segregation [A01:2025, A04:2025 | PR.DS]

- [ ] Tenant data is logically or physically separated in the database (CWE-653)
- [ ] Database migrations do not break tenant isolation (CWE-863)
- [ ] Tenant data deletion (offboarding) removes all data across all stores (CWE-459)
- [ ] Backups can be restored per-tenant without affecting others (CWE-653)
- [ ] Encryption keys are per-tenant or tenant data is encrypted with tenant-specific keys (CWE-311)
- [ ] Shared tables (lookup data, configuration) are read-only for tenants (CWE-863)

## Resource Limits [A06:2025, A02:2025 | PR.DS, PR.PS]

- [ ] API rate limits are enforced per-tenant, not just per-IP (CWE-770)
- [ ] Storage quotas are enforced per-tenant (CWE-770)
- [ ] Database query limits prevent one tenant from degrading performance for others (CWE-400)
- [ ] Background job queues have per-tenant fair scheduling (CWE-400)
- [ ] Bulk operations (import, export) have size limits per tenant (CWE-770)
- [ ] Webhook delivery retries have per-tenant backoff and circuit breakers (CWE-400)
- [ ] Noisy neighbor protection - resource-intensive operations are throttled (CWE-400)

## Tenant Administration [A01:2025, A07:2025 | PR.AA, GV.RR]

- [ ] Tenant admin cannot escalate to platform admin (CWE-269)
- [ ] Tenant admin actions are scoped to their own tenant only (CWE-863)
- [ ] User invitation flow validates the target tenant (CWE-862)
- [ ] Role definitions are per-tenant (tenant A's admin is not tenant B's admin) (CWE-862)
- [ ] Billing and subscription changes are authorized per-tenant (CWE-862)
- [ ] Tenant configuration changes do not affect other tenants (CWE-863)
- [ ] Platform admin access to tenant data requires justification and is logged (CWE-778)

## Cross-Tenant Vulnerabilities [A01:2025, A05:2025 | PR.DS, DE.CM]

- [ ] IDOR attacks tested - can tenant A access tenant B's resources by changing IDs? (CWE-639)
- [ ] Subdomain/hostname validation prevents tenant spoofing (CWE-346)
- [ ] Shared infrastructure (Redis, message queues) uses tenant-prefixed keys (CWE-200)
- [ ] Error messages do not leak data from other tenants (CWE-209)
- [ ] Search and autocomplete results are scoped to the current tenant (CWE-200)
- [ ] Webhook payloads contain only the originating tenant's data (CWE-200)
- [ ] Public-facing pages (status pages, shared links) respect tenant boundaries (CWE-863)
