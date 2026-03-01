# Flask Security Checks [A01-A10:2025]

Detection: `requirements.txt` + `flask`

## Configuration [A02:2025 | PR.PS]
- [ ] `DEBUG = False` and `TESTING = False` in production config
- [ ] `SECRET_KEY` is strong, random and not hardcoded in source
- [ ] `SERVER_NAME` set correctly for production
- [ ] CORS configured via Flask-CORS (not `origins="*"` with `supports_credentials=True`)
- [ ] `MAX_CONTENT_LENGTH` set to limit upload sizes
- [ ] Werkzeug debugger disabled in production (`WERKZEUG_DEBUG_PIN` irrelevant if debug off)
- [ ] `SESSION_COOKIE_SECURE = True` in production
- [ ] `PREFERRED_URL_SCHEME = 'https'` in production

## Access Control [A01:2025 | PR.AA]
- [ ] CSRF protection via Flask-WTF (`CSRFProtect(app)`) on all state-changing forms
- [ ] `@login_required` decorator on all protected routes
- [ ] Role-based access control enforced (Flask-Principal, Flask-Security or custom)
- [ ] No SSRF in `requests.get()` or `httpx` calls with user-controlled URLs
- [ ] File upload filenames sanitized with `werkzeug.utils.secure_filename`
- [ ] Static file serving doesn't expose sensitive directories
- [ ] `send_file()` and `send_from_directory()` validate paths against traversal

## Injection [A05:2025 | PR.DS]
- [ ] Jinja2 `autoescape=True` (default in Flask, verify not overridden in `Environment`)
- [ ] No `| safe` filter on user-controlled content in templates
- [ ] No `Markup()` wrapping user input
- [ ] No `eval()`, `exec()`, `compile()` or `__import__()` with user data
- [ ] No `pickle.loads()`, `yaml.load()` (use `yaml.safe_load()`) or `marshal.loads()` with user data
- [ ] SQLAlchemy uses parameterized queries (no `text()` with f-strings or `.format()`)
- [ ] No `render_template_string()` with user-controlled template content
- [ ] `subprocess` calls use `shell=False` and argument lists

## Authentication [A07:2025 | PR.AA]
- [ ] Flask-Login or Flask-Security configured with session timeout
- [ ] `SESSION_COOKIE_HTTPONLY = True`
- [ ] `SESSION_COOKIE_SAMESITE = 'Lax'` or `'Strict'`
- [ ] Rate limiting via Flask-Limiter on auth and sensitive endpoints
- [ ] Password hashing with bcrypt or argon2 (via Flask-Bcrypt or passlib)
- [ ] Session regeneration on login (`session.regenerate()` or equivalent)
- [ ] `PERMANENT_SESSION_LIFETIME` set to reasonable duration

## Cryptographic Failures [A04:2025 | PR.DS]
- [ ] `SECRET_KEY` not reused across environments
- [ ] No sensitive data in URL query parameters
- [ ] `itsdangerous` serializer used for signed tokens (not custom crypto)
- [ ] API keys and database credentials in environment variables (not in source)

## Data Integrity [A08:2025 | PR.DS]
- [ ] File uploads validate MIME type and content (not just extension)
- [ ] Webhook receivers validate signatures
- [ ] Form data validated with WTForms validators
- [ ] JSON request data validated against expected schema

## Logging [A09:2025 | DE.CM]
- [ ] Logging configured without sensitive data (`password`, `token`, `secret`)
- [ ] Auth events logged (login, logout, failures)
- [ ] Flask `app.logger` used with appropriate log level in production
- [ ] Request logging includes IP, user agent and endpoint

## Error Handling [A10:2025 | DE.AE]
- [ ] Error handlers (`@app.errorhandler`) return generic messages in production
- [ ] No `traceback.format_exc()` in responses
- [ ] External HTTP calls have timeouts (`requests.get(url, timeout=10)`)
- [ ] Database connection errors handled gracefully (not app crash)
- [ ] `500` errors logged with full context server-side

## Supply Chain [A03:2025 | GV.SC]
- [ ] `pip-audit` or `safety check` shows no critical CVEs
- [ ] `requirements.txt` has pinned versions or lock file committed (`Pipfile.lock`, `poetry.lock`)
- [ ] Flask version is actively supported
- [ ] No unused packages installed

## Dependency Audit Command
```bash
pip-audit
# or
safety check
```
