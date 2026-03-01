# FastAPI / Python Security Checks [A01-A10:2025]

Detection: `requirements.txt` + `fastapi`

## Input Validation [A05:2025 | PR.DS]
- [ ] Pydantic models validate all request inputs (body, query, path)
- [ ] No `eval()`, `exec()` or `compile()` with user input
- [ ] `subprocess` calls use `shell=False` and argument lists (not shell strings)
- [ ] No `pickle.loads()`, `yaml.unsafe_load()` or `marshal.loads()` with user data
- [ ] Jinja2 templates use `autoescape=True`
- [ ] No `render_template_string()` with user-controlled content
- [ ] SQL queries use parameterized statements (SQLAlchemy bind params)
- [ ] No f-string or `.format()` in raw SQL via `text()`

## Configuration [A02:2025 | PR.PS]
- [ ] CORS middleware configured restrictively (not `allow_origins=["*"]` with credentials)
- [ ] `debug=False` in production (Uvicorn/Gunicorn config)
- [ ] `docs_url` and `redoc_url` disabled or protected in production
- [ ] `openapi_url` disabled or protected in production
- [ ] Trusted host middleware configured
- [ ] Database sessions properly closed (dependency injection with `yield`)

## Access Control [A01:2025 | PR.AA]
- [ ] Dependency injection used for auth (`Depends(get_current_user)`)
- [ ] Route dependencies enforce authorization (not just authentication)
- [ ] No SSRF in `httpx` or `requests` calls with user-controlled URLs
- [ ] File path operations sanitize against traversal
- [ ] Background tasks don't bypass permission checks

## Authentication [A07:2025 | PR.AA]
- [ ] JWT tokens validated server-side (signature, expiry, issuer)
- [ ] OAuth2 password flow uses proper scopes
- [ ] API key validation is constant-time
- [ ] Rate limiting on auth endpoints
- [ ] Session/token expiry configured

## Data Integrity [A08:2025 | PR.DS]
- [ ] Webhook receivers validate HMAC signatures
- [ ] File uploads validated (content type, size, filename)
- [ ] Response models filter sensitive fields (`response_model` excludes secrets)

## Logging [A09:2025 | DE.CM]
- [ ] Structured logging without sensitive data (passwords, tokens)
- [ ] Auth failures logged with context
- [ ] Request tracing enabled (correlation IDs)

## Error Handling [A10:2025 | DE.AE]
- [ ] Custom exception handlers return generic errors in production
- [ ] No stack traces in error responses
- [ ] External HTTP calls have timeouts (`httpx` timeout parameter)
- [ ] Database connection errors handled gracefully
- [ ] Pydantic validation errors don't leak internal field names

## Supply Chain [A03:2025 | GV.SC]
- [ ] `pip-audit` or `safety check` shows no critical CVEs
- [ ] `requirements.txt` has pinned versions or lock file committed (`poetry.lock`, `Pipfile.lock`)
- [ ] No unused dependencies

## Dependency Audit Command
```bash
pip-audit
# or
safety check
```
