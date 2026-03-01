# Express / Node.js Security Checks [A01-A10:2025]

Detection: `package.json` + `express`

## Configuration [A02:2025 | PR.PS]
- [ ] Helmet.js middleware applied (sets security headers)
- [ ] `trust proxy` configured correctly (not blindly trusting all proxies)
- [ ] CORS configured restrictively (not `origin: '*'` with credentials)
- [ ] Cookie parser uses signed cookies with strong secret
- [ ] `NODE_ENV=production` in production
- [ ] Express error handler customized (no default stack trace page)

## Injection [A05:2025 | PR.DS]
- [ ] No `eval()`, `new Function()` or `vm.runInNewContext()` with user input
- [ ] MongoDB queries sanitized (no `$where`, `$gt`, `$ne` from raw user input)
- [ ] SQL queries parameterized (no string concatenation)
- [ ] No `child_process.exec()` or `execSync()` with user-controlled arguments
- [ ] Template engines configured with auto-escaping
- [ ] No prototype pollution via `Object.assign()` or spread with user objects
- [ ] `express-mongo-sanitize` or equivalent for NoSQL injection prevention

## Access Control [A01:2025 | PR.AA]
- [ ] File paths sanitized against traversal (`path.normalize`, `path.resolve` + prefix check)
- [ ] Route middleware enforces authentication and authorization
- [ ] No SSRF in `axios`, `fetch` or `got` calls with user-controlled URLs
- [ ] CSRF protection on state-changing routes (if using cookies for auth)
- [ ] Rate limiting middleware applied to auth and sensitive endpoints

## Authentication [A07:2025 | PR.AA]
- [ ] Rate limiting on login, registration and password reset endpoints
- [ ] JWT secret is strong and not hardcoded
- [ ] Session cookies have `httpOnly`, `secure` and `sameSite` flags
- [ ] Passport.js (or equivalent) configured with secure strategies
- [ ] Bcrypt or Argon2 used for password hashing

## Error Handling [A10:2025 | DE.AE]
- [ ] Error handler doesn't leak stack traces in production
- [ ] Unhandled promise rejections caught (`process.on('unhandledRejection')`)
- [ ] Uncaught exceptions handled gracefully
- [ ] External API calls have timeouts
- [ ] JSON parse errors return 400, not 500 with details

## Logging [A09:2025 | DE.CM]
- [ ] Audit logging on auth events (login, logout, failed attempts)
- [ ] No sensitive data in logs (passwords, tokens, credit cards)
- [ ] Request logging with correlation IDs (Morgan, Winston, Pino)
- [ ] Error logging includes context but not user secrets

## Supply Chain [A03:2025 | GV.SC]
- [ ] `npm audit` shows no critical CVEs
- [ ] `package-lock.json` committed
- [ ] No unnecessary `postinstall` scripts in dependencies
- [ ] No wildcard (`*`) version ranges in `package.json`

## Dependency Audit Command
```bash
npm audit
# or
yarn audit
```
