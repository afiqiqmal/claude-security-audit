# ASP.NET Core Security Checks [A01-A10:2025]

Detection: `*.csproj` + `Program.cs`

## Configuration [A02:2025 | PR.PS]
- [ ] `ASPNETCORE_ENVIRONMENT` set to `Production` (not `Development`) in prod
- [ ] HSTS enabled via `UseHsts()` middleware
- [ ] HTTPS redirection enabled via `UseHttpsRedirection()`
- [ ] Security headers configured (CSP, X-Frame-Options, X-Content-Type-Options)
- [ ] Kestrel server limits configured (max request body size, header size)
- [ ] Swagger/OpenAPI disabled or protected in production
- [ ] `ForwardedHeaders` middleware configured correctly behind reverse proxy

## Access Control [A01:2025 | PR.AA]
- [ ] `[ValidateAntiForgeryToken]` or auto-validation on all POST/PUT/DELETE actions
- [ ] `[Authorize]` attribute with policies on all protected endpoints
- [ ] Policy-based authorization with custom requirements (not just role checks)
- [ ] SignalR hubs enforce authorization
- [ ] Minimal API endpoints have `.RequireAuthorization()`
- [ ] No SSRF in `HttpClient` calls with user-controlled URLs
- [ ] `IHttpClientFactory` used with named/typed clients (not raw `HttpClient`)

## Injection [A05:2025 | PR.DS]
- [ ] No `FromSqlRaw` with string interpolation (use `FromSqlInterpolated` or parameterized)
- [ ] No `Process.Start()` with user-controlled arguments
- [ ] Razor views use `@` encoding by default (verify no `@Html.Raw()` on user input)
- [ ] Input validation with Data Annotations or FluentValidation on all models
- [ ] Model binding doesn't allow over-posting (`[Bind]` or dedicated DTOs)
- [ ] No `System.Reflection` with user-controlled type/method names

## Cryptographic Failures [A04:2025 | PR.DS]
- [ ] Data Protection API used for encrypting sensitive data at rest
- [ ] Connection strings and secrets in User Secrets, Key Vault or environment vars (not `appsettings.json`)
- [ ] No hardcoded encryption keys or connection strings in source
- [ ] DPAPI key ring stored in persistent location for production (not in-memory)
- [ ] Certificate validation not disabled (`ServerCertificateCustomValidationCallback`)

## Authentication [A07:2025 | PR.AA]
- [ ] ASP.NET Core Identity configured with strong password rules
- [ ] Account lockout enabled after failed attempts
- [ ] Cookie authentication has `SecurePolicy`, `HttpOnly` and `SameSite` set
- [ ] JWT Bearer validation includes issuer, audience and lifetime checks
- [ ] Rate limiting via `Microsoft.AspNetCore.RateLimiting` middleware
- [ ] Two-factor authentication available for sensitive accounts

## Error Handling [A10:2025 | DE.AE]
- [ ] Exception handling middleware returns generic errors in production
- [ ] `UseDeveloperExceptionPage()` only in Development environment
- [ ] Custom error pages via `UseExceptionHandler("/Error")`
- [ ] `HttpClient` calls have timeout configured via `HttpClientHandler`
- [ ] Background services (`IHostedService`) have exception handling
- [ ] Health checks (`UseHealthChecks`) don't expose internal details publicly

## Logging [A09:2025 | DE.CM]
- [ ] Logging with Serilog/NLog, sensitive data destructured or masked
- [ ] Auth events logged via Identity events or custom middleware
- [ ] Request logging middleware configured (not logging sensitive headers/bodies)
- [ ] Application Insights or equivalent monitoring in production

## Supply Chain [A03:2025 | GV.SC]
- [ ] `dotnet list package --vulnerable` shows no critical CVEs
- [ ] .NET runtime version is actively supported (check end-of-life)
- [ ] NuGet packages from trusted sources only
- [ ] No deprecated packages in use

## Dependency Audit Command
```bash
dotnet list package --vulnerable --include-transitive
```
