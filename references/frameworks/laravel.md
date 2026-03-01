# Laravel Security Checks [A01-A10:2025]

Detection: `composer.json` + `artisan`

## Configuration [A02:2025 | PR.PS]
- [ ] `APP_DEBUG=false` in production
- [ ] `APP_KEY` is set and unique per environment
- [ ] `.env` is not accessible via web (check web server config)
- [ ] `APP_URL` matches actual production domain
- [ ] `SESSION_SECURE_COOKIE=true` in production
- [ ] `config:cache` used in production (prevents runtime .env reads)

## Access Control [A01:2025 | PR.AA]
- [ ] Mass assignment protection on all models (`$fillable` or `$guarded`)
- [ ] No model uses `$guarded = []`
- [ ] Authorization policies used for resource access (`authorize()`, `can()`)
- [ ] CSRF middleware enabled for web routes
- [ ] Route model binding doesn't bypass tenant scoping
- [ ] Broadcasting channels verify authorization
- [ ] `Storage::url()` doesn't expose private files
- [ ] Middleware applied to route groups (not missing on individual routes)
- [ ] No SSRF in HTTP client calls (`Http::get($userUrl)`) or webhook processing

## Injection [A05:2025 | PR.DS]
- [ ] `whereRaw()` / `DB::raw()` / `DB::statement()` don't interpolate user input
- [ ] Blade uses `{{ }}` not `{!! !!}` for user data
- [ ] `$casts` used for attribute types (prevents type juggling)
- [ ] No `eval()` or `preg_replace` with `e` modifier
- [ ] Validation rules use `Rule::in()` for enum values (not raw strings)

## Authentication [A07:2025 | PR.AA]
- [ ] API rate limiting configured (`throttle` middleware)
- [ ] Login throttling enabled
- [ ] Password validation rules meet minimum strength
- [ ] Session regeneration on login
- [ ] `remember_me` token has expiry

## Data Integrity [A08:2025 | PR.DS]
- [ ] Queued jobs don't contain unserialized user objects
- [ ] Webhook receivers validate signatures
- [ ] Event listeners don't blindly trust payload data

## Logging [A09:2025 | DE.CM]
- [ ] Audit logging for admin actions
- [ ] Failed login attempts logged
- [ ] `LOG_LEVEL` appropriate for production (not `debug`)
- [ ] Sensitive data excluded from logs (`config('logging.channels')`)

## Error Handling [A10:2025 | DE.AE]
- [ ] Exception handler doesn't fail open (check `app/Exceptions/Handler.php` or `bootstrap/app.php`)
- [ ] Custom error pages configured (no debug stack traces in production)
- [ ] External HTTP calls have timeouts set

## Supply Chain [A03:2025 | GV.SC]
- [ ] `composer audit` shows no critical CVEs
- [ ] `composer.lock` committed and up to date
- [ ] No wildcard version constraints in `composer.json`

## Dependency Audit Command
```bash
composer audit
```
