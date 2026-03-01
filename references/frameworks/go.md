# Go (Gin / Echo / Fiber) Security Checks [A01-A10:2025]

Detection: `go.mod` + `gin-gonic/gin` or `labstack/echo` or `gofiber/fiber`

## Injection [A05:2025 | PR.DS]
- [ ] SQL queries use parameterized statements (`db.Query(sql, args...)`, `sqlx`, `gorm` placeholders)
- [ ] No `fmt.Sprintf` or string concatenation for SQL query construction
- [ ] Input validation with `go-playground/validator` struct tags or equivalent
- [ ] No `os/exec.Command` with user-controlled arguments without sanitization
- [ ] Templates use `html/template` (auto-escaping), not `text/template` for web output
- [ ] No `template.HTML()` type conversion on user input (bypasses escaping)
- [ ] JSON unmarshaling into typed structs (not `map[string]interface{}` for validation)
- [ ] No `reflect` usage with user-controlled type or field names

## Configuration [A02:2025 | PR.PS]
- [ ] CORS middleware configured restrictively (not `AllowAllOrigins` or `AllowOrigins: *`)
- [ ] `GIN_MODE=release` in production (Gin)
- [ ] TLS configured for production (not plain HTTP)
- [ ] Request body size limits set (`MaxBytesReader` or framework config)
- [ ] Trusted proxies configured explicitly (not trusting all)
- [ ] Security headers set via middleware (X-Frame-Options, CSP, etc.)

## Access Control [A01:2025 | PR.AA]
- [ ] Authentication middleware applied to protected route groups
- [ ] File path handling uses `filepath.Clean()` and validates against traversal
- [ ] No SSRF in `http.Get()`, `http.Post()` or client libraries with user URLs
- [ ] File uploads validate content type, size and sanitize filename
- [ ] Static file serving restricted to intended directory (`http.Dir` path checked)

## Authentication [A07:2025 | PR.AA]
- [ ] JWT validation checks signature, expiry, issuer and audience
- [ ] JWT secret/key is strong and externalized (not hardcoded)
- [ ] Rate limiting middleware applied to auth and sensitive endpoints
- [ ] Password hashing uses `bcrypt` or `argon2` (not MD5/SHA)
- [ ] Session tokens generated with `crypto/rand` (not `math/rand`)
- [ ] Cookie flags set: `Secure`, `HttpOnly`, `SameSite`

## Error Handling [A10:2025 | DE.AE]
- [ ] Panic recovery middleware installed (`gin.Recovery()`, `echo.Recover()`, `fiber.Recover()`)
- [ ] Error responses return generic messages, not stack traces or internal details
- [ ] Context timeouts (`context.WithTimeout`) on all external HTTP calls and DB queries
- [ ] `http.Server` has `ReadTimeout`, `WriteTimeout` and `IdleTimeout` set
- [ ] Goroutine leaks prevented (context cancellation, `errgroup`)
- [ ] Channel operations don't block indefinitely (use `select` with timeout)
- [ ] Deferred resource cleanup (`defer rows.Close()`, `defer resp.Body.Close()`)

## Logging [A09:2025 | DE.CM]
- [ ] Structured logging (`slog`, `zerolog`, `zap`) without sensitive fields
- [ ] Auth events logged (login, failures, token operations)
- [ ] Request logging middleware with request ID / correlation ID
- [ ] No `fmt.Println` or `log.Println` with sensitive data in production

## Data Integrity [A08:2025 | PR.DS]
- [ ] `encoding/gob` and `encoding/json` decode into typed structs
- [ ] No `unsafe` package usage with external data
- [ ] Webhook receivers validate HMAC signatures
- [ ] Protobuf/gRPC inputs validated with constraints

## Supply Chain [A03:2025 | GV.SC]
- [ ] `govulncheck ./...` shows no critical vulnerabilities
- [ ] `go.sum` committed
- [ ] Dependencies from known/trusted modules
- [ ] Go version is actively supported (check release policy)
- [ ] No `replace` directives pointing to untrusted sources in `go.mod`

## Dependency Audit Command
```bash
govulncheck ./...
```
