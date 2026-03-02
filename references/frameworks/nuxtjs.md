# Nuxt.js Security Checks [A01-A10:2025]

Detection: `package.json` + `nuxt.config`

## Configuration [A02:2025 | PR.PS]
- [ ] No secrets in `runtimeConfig.public` (only non-sensitive values)
- [ ] `nuxt.config` does not expose internal service URLs in public runtime config
- [ ] Security headers configured via `routeRules` or Nitro middleware
- [ ] Source maps disabled in production (`sourcemap: false`)
- [ ] Debug mode disabled in production (`debug: false`)
- [ ] `devtools` disabled in production builds

## Server Routes and API [A01:2025, A05:2025 | PR.AA, PR.DS]
- [ ] All `server/api/` and `server/routes/` handlers validate authentication
- [ ] `defineEventHandler` checks user permissions before data access
- [ ] `readBody()` input is validated before use in queries
- [ ] `getQuery()` parameters are sanitized and typed
- [ ] `getRouterParam()` values are validated (no path traversal)
- [ ] Server routes do not pass raw user input to `$fetch` or `ofetch` (SSRF)
- [ ] File uploads via `readMultipartFormData()` validate file type and size

## Auto-Imports and Composables [A04:2025, A05:2025 | PR.DS]
- [ ] Auto-imported composables do not accidentally expose server-only logic to client
- [ ] `useState()` does not store sensitive data (it serializes to client)
- [ ] `useFetch()` and `useAsyncData()` do not leak server-side secrets in response
- [ ] Custom composables in `composables/` validate inputs from URL params
- [ ] Server-only utilities are in `server/utils/` (not `utils/` which auto-imports to client)

## Middleware [A01:2025, A07:2025 | PR.AA]
- [ ] Route middleware (`middleware/`) validates authentication server-side
- [ ] Global middleware runs on all routes (not just named middleware on selected pages)
- [ ] Middleware cannot be bypassed by direct API calls to server routes
- [ ] `navigateTo()` in middleware does not use unvalidated user input (open redirect)
- [ ] Server middleware in `server/middleware/` runs before route handlers
- [ ] Auth middleware checks are not client-side only (`definePageMeta` + client middleware)

## Nitro Engine [A02:2025, A08:2025 | PR.PS, GV.SC]
- [ ] Nitro presets do not expose debug endpoints in production
- [ ] Server plugins (`server/plugins/`) do not register insecure hooks
- [ ] Nitro storage drivers use authenticated backends (not public S3 buckets)
- [ ] Cached responses do not include user-specific sensitive data
- [ ] Server assets are not publicly accessible without authorization
- [ ] `nitro.routeRules` do not set overly permissive CORS or cache headers

## Data Fetching [A01:2025, A05:2025 | PR.AA, PR.DS]
- [ ] `useFetch()` to internal API includes auth credentials
- [ ] `$fetch()` on the server does not follow redirects to untrusted hosts (SSRF)
- [ ] Server-side `$fetch()` to external APIs does not include user-controlled URLs
- [ ] `useAsyncData()` keys are not predictable or user-controllable
- [ ] Error responses from `useFetch()` do not expose stack traces to the client

## Authentication [A07:2025 | PR.AA]
- [ ] Session tokens are stored in HttpOnly cookies (not localStorage)
- [ ] Auth state checked in server middleware (not client-side `onMounted`)
- [ ] OAuth callback validates `state` parameter
- [ ] JWT verification happens server-side with proper signature validation
- [ ] Protected pages use server-side auth checks via `defineEventHandler` or middleware

## CSRF and Request Integrity [A01:2025 | PR.DS]
- [ ] State-changing server routes require CSRF token validation
- [ ] Forms use anti-CSRF tokens (framework-provided or custom)
- [ ] `SameSite` cookie attribute is set to `Lax` or `Strict`
- [ ] Cross-origin requests are restricted via CORS configuration

## Head and Meta Injection [A05:2025 | PR.DS]
- [ ] `useHead()` does not inject unsanitized user input into meta tags
- [ ] `useSeoMeta()` values are escaped (no script injection via Open Graph tags)
- [ ] Dynamic `<script>` injection via `useHead()` does not include user-controlled URLs
- [ ] SSR-rendered HTML does not include unescaped user data in `<head>`

## Error Handling [A10:2025 | DE.AE]
- [ ] `error.vue` does not display stack traces or internal paths
- [ ] `showError()` and `createError()` use generic messages in production
- [ ] Unhandled server errors return 500 with no sensitive details

## Supply Chain [A03:2025 | GV.SC]
- [ ] `npm audit` or `pnpm audit` shows no critical CVEs
- [ ] `package-lock.json` or `pnpm-lock.yaml` is committed
- [ ] Nuxt modules are from trusted sources (official or well-maintained)

## Dependency Audit Command
```bash
npm audit
# or
pnpm audit
```
