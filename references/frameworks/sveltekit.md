# SvelteKit Security Checks [A01-A10:2025]

Detection: `package.json` + `svelte.config`

## Configuration [A02:2025 | PR.PS]
- [ ] No secrets in client-accessible `$env/static/public` or `$env/dynamic/public`
- [ ] `svelte.config.js` CSP directives are configured via `kit.csp`
- [ ] Source maps disabled in production
- [ ] CSRF protection is enabled (`kit.csrf.checkOrigin` is not set to `false`)
- [ ] Prerender does not expose authenticated or sensitive content as static HTML

## Server Load Functions [A01:2025, A05:2025 | PR.AA, PR.DS]
- [ ] `+page.server.ts` load functions validate user authentication
- [ ] `+layout.server.ts` auth checks cannot be bypassed by nested routes
- [ ] Load functions do not return more data than the page needs (over-exposure)
- [ ] `params` from URL are validated before use in database queries
- [ ] Server load functions do not fetch user-controlled URLs (SSRF)
- [ ] `depends()` keys do not leak internal resource identifiers
- [ ] Sensitive data is not passed from server load to client via `data` prop

## Form Actions [A01:2025, A05:2025 | PR.AA, PR.DS]
- [ ] Form actions in `+page.server.ts` validate authentication
- [ ] `request.formData()` input is validated and sanitized
- [ ] Named actions are authorized - users cannot invoke admin-only actions
- [ ] File uploads via form actions validate file type, size and content
- [ ] Action responses do not leak sensitive data in `ActionFailure`
- [ ] Progressive enhancement does not bypass server-side validation

## Hooks [A01:2025, A07:2025 | PR.AA, DE.CM]
- [ ] `handle` hook in `hooks.server.ts` enforces authentication
- [ ] `handleError` hook does not expose stack traces or internal paths
- [ ] `handleFetch` hook validates URLs before server-side fetching
- [ ] `handle` hook sets security headers (CSP, X-Frame-Options, etc.)
- [ ] `event.locals` does not carry stale auth state across requests
- [ ] Sequence of hooks (`sequence()`) runs auth checks before other logic

## Content Security Policy [A02:2025, A05:2025 | PR.PS, PR.DS]
- [ ] CSP configured via `kit.csp` with restrictive `script-src`
- [ ] `unsafe-inline` is not used for scripts (use nonces or hashes)
- [ ] `unsafe-eval` is not used in CSP directives
- [ ] CSP report-uri or report-to is configured for violation monitoring
- [ ] Third-party scripts are allowlisted explicitly in CSP

## Environment Variables [A04:2025 | PR.DS]
- [ ] Secrets use `$env/static/private` or `$env/dynamic/private` (never `public`)
- [ ] `.env` files are in `.gitignore`
- [ ] API keys for third-party services are not in client-accessible env vars
- [ ] Environment validation runs at startup (fail fast on missing required vars)
- [ ] Production environment variables are managed via secrets manager (not plain files)

## Adapter Security [A02:2025, A03:2025 | PR.PS, GV.SC]
- [ ] Adapter configuration does not expose internal file paths
- [ ] Node adapter runs behind a reverse proxy with security headers
- [ ] Static adapter prerendered pages do not contain sensitive data
- [ ] Vercel/Netlify/Cloudflare adapter settings restrict function regions appropriately
- [ ] Build output directory is not publicly accessible on the server

## Injection and XSS [A05:2025 | PR.DS]
- [ ] `{@html}` directive only renders sanitized content (DOMPurify or equivalent)
- [ ] Dynamic component rendering does not use user-controlled component names
- [ ] URL parameters rendered in templates are escaped
- [ ] `svelte:head` does not inject unsanitized user input
- [ ] Server-rendered HTML does not include unescaped user data

## Authentication [A07:2025 | PR.AA]
- [ ] Auth state is validated server-side in hooks or load functions
- [ ] Session cookies are HttpOnly, Secure and SameSite
- [ ] OAuth callbacks validate `state` parameter
- [ ] Protected routes redirect unauthenticated users server-side (not client-side)
- [ ] Token refresh handles race conditions in concurrent requests

## Error Handling [A10:2025 | DE.AE]
- [ ] `+error.svelte` pages do not display stack traces
- [ ] `handleError` hook logs errors server-side and returns generic messages
- [ ] API endpoints return consistent error format without internal details
- [ ] Unexpected errors do not fail open (granting access on error)

## Logging [A09:2025 | DE.CM]
- [ ] Authentication events are logged server-side
- [ ] Failed access attempts are logged with context
- [ ] No sensitive data in `console.log` statements in production

## Supply Chain [A03:2025 | GV.SC]
- [ ] `npm audit` or `pnpm audit` shows no critical CVEs
- [ ] Lock file is committed (`package-lock.json` or `pnpm-lock.yaml`)
- [ ] SvelteKit plugins and preprocessors are from trusted sources

## Dependency Audit Command
```bash
npm audit
# or
pnpm audit
```
