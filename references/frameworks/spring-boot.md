# Spring Boot / Java Security Checks [A01-A10:2025]

Detection: `pom.xml` or `build.gradle` + `@SpringBootApplication`

## Configuration [A02:2025 | PR.PS]
- [ ] Actuator endpoints not publicly accessible (`/actuator`, `/env`, `/beans`, `/heapdump`, `/threaddump`)
- [ ] Production profile disables debug endpoints and verbose errors
- [ ] `application.properties` / `application.yml` secrets externalized (not in source)
- [ ] `server.error.include-stacktrace=never` in production
- [ ] `server.error.include-message=never` in production
- [ ] Security headers configured (Spring Security defaults or custom filter)
- [ ] CORS configured restrictively (not `allowedOrigins("*")` with `allowCredentials(true)`)
- [ ] HTTP response headers include `X-Content-Type-Options`, `X-Frame-Options`, `CSP`

## Access Control [A01:2025 | PR.AA]
- [ ] Spring Security configured and not disabled via `@EnableWebSecurity` overrides
- [ ] CSRF protection enabled for web endpoints (not disabled globally with `.csrf().disable()`)
- [ ] Method-level security (`@PreAuthorize`, `@Secured`, `@RolesAllowed`) used consistently
- [ ] URL-based security rules in `SecurityFilterChain` are ordered correctly (most specific first)
- [ ] No SSRF in `RestTemplate`, `WebClient` or `HttpClient` calls with user URLs
- [ ] File upload paths sanitized against traversal

## Injection [A05:2025 | PR.DS]
- [ ] No SpEL (Spring Expression Language) injection via user input
- [ ] All SQL uses prepared statements or JPA parameterized queries (no string concatenation)
- [ ] `@Valid` or `@Validated` annotations on all `@RequestBody` DTOs
- [ ] No `Runtime.exec()` or `ProcessBuilder` with user-controlled arguments
- [ ] Thymeleaf templates use `th:text` (escaped) not `th:utext` for user data
- [ ] No `ScriptEngine.eval()` with user input
- [ ] Log injection prevented (no unsanitized user input in log messages)

## Authentication [A07:2025 | PR.AA]
- [ ] Password encoder uses BCrypt or Argon2 (not MD5/SHA)
- [ ] Login throttling configured (Spring Security or custom)
- [ ] Session fixation protection enabled (`sessionManagement().sessionFixation()`)
- [ ] JWT validation checks signature, expiry, issuer and audience
- [ ] OAuth2 `state` parameter validated
- [ ] Remember-me token is persistent and rotated (not simple hash)

## Data Integrity [A08:2025 | PR.DS]
- [ ] No `ObjectInputStream.readObject()` on untrusted data
- [ ] Jackson deserialization: `DefaultTyping` disabled or restricted
- [ ] No `@JsonTypeInfo` with `As.PROPERTY` on untrusted input classes
- [ ] Webhook receivers validate HMAC signatures
- [ ] Multipart file uploads validated (content type, size)

## Logging [A09:2025 | DE.CM]
- [ ] Logging with SLF4J/Logback, sensitive fields masked in MDC
- [ ] Auth events logged (login, logout, failures)
- [ ] Actuator audit events enabled for security tracking
- [ ] No sensitive data in log output (`logback.xml` patterns reviewed)

## Error Handling [A10:2025 | DE.AE]
- [ ] Custom error pages configured (no Whitelabel Error Page in production)
- [ ] `@ControllerAdvice` exception handler returns generic messages
- [ ] `RestTemplate` and `WebClient` calls have timeouts configured
- [ ] Circuit breakers (Resilience4j) on external service calls
- [ ] `@Async` methods have exception handlers

## Supply Chain [A03:2025 | GV.SC]
- [ ] `mvn dependency-check:check` or `gradle dependencyCheckAnalyze` shows no critical CVEs
- [ ] Spring Boot version is actively supported
- [ ] No snapshot dependencies in production builds
- [ ] Parent POM or BOM manages dependency versions consistently

## Dependency Audit Command
```bash
# Maven
mvn org.owasp:dependency-check-maven:check

# Gradle
gradle dependencyCheckAnalyze
```
