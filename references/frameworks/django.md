# Django Security Checks [A01-A10:2025]

Detection: `requirements.txt` + `manage.py`

## Configuration [A02:2025 | PR.PS]
- [ ] `DEBUG = False` in production settings
- [ ] `ALLOWED_HOSTS` is not `['*']`
- [ ] `SECRET_KEY` is strong, unique and not committed to source
- [ ] Security middleware enabled (`SecurityMiddleware` in `MIDDLEWARE`)
- [ ] `SECURE_SSL_REDIRECT = True` in production
- [ ] `SECURE_HSTS_SECONDS` set (HSTS enabled)
- [ ] `SECURE_BROWSER_XSS_FILTER = True`
- [ ] `X_FRAME_OPTIONS = 'DENY'` or `'SAMEORIGIN'`
- [ ] Admin URL is not `/admin/` (changed to non-default path)

## Access Control [A01:2025 | PR.AA]
- [ ] CSRF middleware enabled (`CsrfViewMiddleware` in `MIDDLEWARE`)
- [ ] No `@csrf_exempt` on state-changing views without justification
- [ ] `@login_required` or `LoginRequiredMixin` on all protected views
- [ ] Permission checks use `@permission_required` or `PermissionRequiredMixin`
- [ ] Object-level permissions enforced (not just model-level)
- [ ] File upload paths sanitized (no path traversal in `FileField` storage)

## Injection [A05:2025 | PR.DS]
- [ ] No raw SQL via `raw()`, `extra()` or `cursor.execute()` with user input
- [ ] QuerySet methods used instead of string interpolation in queries
- [ ] Templates use auto-escaping (default in Django, verify `{% autoescape on %}`)
- [ ] No `|safe` or `mark_safe()` on user-controlled content
- [ ] No `eval()`, `exec()` or `pickle.loads()` with user data
- [ ] `json.loads()` input validated before processing

## Authentication [A07:2025 | PR.AA]
- [ ] Password validators configured in `AUTH_PASSWORD_VALIDATORS`
- [ ] Session cookies: `SESSION_COOKIE_SECURE`, `SESSION_COOKIE_HTTPONLY`, `SESSION_COOKIE_SAMESITE`
- [ ] `SESSION_COOKIE_AGE` set to reasonable duration
- [ ] Session engine is server-side (database or cache, not cookie-based for sensitive apps)
- [ ] Login throttling via `django-axes` or similar
- [ ] Password reset tokens are time-limited

## Cryptographic Failures [A04:2025 | PR.DS]
- [ ] Passwords hashed with PBKDF2, bcrypt or Argon2 (check `PASSWORD_HASHERS`)
- [ ] No sensitive data in URL parameters
- [ ] Secrets managed via environment variables or vault (not in `settings.py`)

## Data Integrity [A08:2025 | PR.DS]
- [ ] `pickle` deserialization not used with untrusted data
- [ ] Signed cookies and sessions use `SECRET_KEY` properly
- [ ] Form uploads validated (file type, size)
- [ ] Model `clean()` methods validate business rules

## Logging [A09:2025 | DE.CM]
- [ ] Django logging configured (`LOGGING` dict in settings)
- [ ] Auth events logged (login, logout, failed attempts)
- [ ] Sensitive data excluded from logs
- [ ] Admin actions logged via `django.contrib.admin` log entries

## Error Handling [A10:2025 | DE.AE]
- [ ] Custom 404 and 500 templates configured (no debug pages in production)
- [ ] `handler404`, `handler500` set in URL config
- [ ] External API calls have timeouts
- [ ] Database connection errors handled gracefully

## Supply Chain [A03:2025 | GV.SC]
- [ ] `pip-audit` or `safety check` shows no critical CVEs
- [ ] `requirements.txt` has pinned versions or lock file committed
- [ ] Django version is actively supported (check end-of-life dates)

## Dependency Audit Command
```bash
pip-audit
# or
safety check
```
