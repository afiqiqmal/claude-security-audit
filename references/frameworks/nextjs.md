# Next.js / React Security Checks [A01-A10:2025]

Detection: `package.json` + `next.config`

## Configuration [A02:2025 | PR.PS]
- [ ] No secrets in `NEXT_PUBLIC_*` environment variables
- [ ] `next.config.js` has restrictive `images.remotePatterns` (not `*`)
- [ ] Security headers configured via `next.config.js` headers or middleware
- [ ] `poweredByHeader: false` set in config
- [ ] Source maps disabled in production (`productionBrowserSourceMaps: false`)

## Access Control [A01:2025 | PR.AA]
- [ ] API routes validate authentication (not just frontend guards)
- [ ] Middleware authorization not bypassable via direct API calls
- [ ] Server Actions validate user permissions
- [ ] `getServerSideProps` / `getStaticProps` don't leak sensitive data to client
- [ ] Route handlers check authorization before data access
- [ ] `getServerSideProps` doesn't fetch arbitrary URLs (SSRF)

## Injection [A05:2025 | PR.DS]
- [ ] `dangerouslySetInnerHTML` content is sanitized (DOMPurify or equivalent)
- [ ] No `eval()` or `new Function()` with user input
- [ ] Server Components don't pass unsanitized data to Client Components
- [ ] URL parameters validated before use in queries or rendering
- [ ] No template literal injection in API route SQL/queries

## Cryptographic Failures [A04:2025 | PR.DS]
- [ ] Client components don't expose sensitive server data
- [ ] No sensitive data in client-side state management (Redux, Zustand, Context)
- [ ] API keys for third-party services not in client bundle
- [ ] JWT tokens stored in HttpOnly cookies (not localStorage)
- [ ] No secrets in `next.config.js` (it can be exposed via `/__nextjs_original-stack-frame`)

## Authentication [A07:2025 | PR.AA]
- [ ] Auth state checked server-side (not just client hooks)
- [ ] Session tokens have expiry and rotation
- [ ] OAuth callback validates `state` parameter
- [ ] Protected pages redirect unauthenticated users server-side

## Error Handling [A10:2025 | DE.AE]
- [ ] Error boundaries don't leak sensitive info (`error.tsx` / `global-error.tsx`)
- [ ] API routes return generic error messages in production
- [ ] `not-found.tsx` doesn't reveal internal routing structure
- [ ] Server Action errors don't expose stack traces

## Logging [A09:2025 | DE.CM]
- [ ] API routes log authentication failures
- [ ] Server-side errors logged with context (not swallowed)
- [ ] No `console.log` with sensitive data in production

## Supply Chain [A03:2025 | GV.SC]
- [ ] `npm audit` or `yarn audit` shows no critical CVEs
- [ ] `package-lock.json` or `yarn.lock` committed
- [ ] No unnecessary `next.config.js` rewrites exposing internal services

## Dependency Audit Command
```bash
npm audit
# or
yarn audit
```
