# Ruby on Rails Security Checks [A01-A10:2025]

Detection: `Gemfile` + `config/routes.rb`

## Configuration [A02:2025 | PR.PS]
- [ ] `config.force_ssl = true` in production
- [ ] `config.consider_all_requests_local = false` in production
- [ ] `SECRET_KEY_BASE` set and not committed to source
- [ ] Content Security Policy configured via `content_security_policy` initializer
- [ ] `config.action_dispatch.default_headers` includes security headers
- [ ] Credentials encrypted with `rails credentials:edit` (not plain text)

## Access Control [A01:2025 | PR.AA]
- [ ] `protect_from_forgery with: :exception` in ApplicationController
- [ ] Strong parameters used (`params.require().permit()`) on all controllers
- [ ] No mass assignment via `update(params)` without strong params
- [ ] Pundit, CanCanCan or custom authorization enforced on every action
- [ ] Active Record callbacks don't bypass authorization checks
- [ ] Scoped queries (`current_user.posts` not `Post.find(params[:id])`)
- [ ] No SSRF in `Net::HTTP`, `Faraday` or `HTTParty` calls with user URLs

## Injection [A05:2025 | PR.DS]
- [ ] No `html_safe`, `raw()` or `sanitize` bypass on user input in views
- [ ] No raw SQL via `find_by_sql`, `execute` or `where("col = '#{input}'")`
- [ ] No `render inline:` with user-controlled content
- [ ] ERB templates use `<%= %>` (escaped) not `<%== %>` (unescaped) for user data
- [ ] No `send()` or `public_send()` with user-controlled method names
- [ ] No `constantize` or `safe_constantize` on user input
- [ ] Regex doesn't use `\A` and `\z` instead of `^` and `$` for full-string matching

## Authentication [A07:2025 | PR.AA]
- [ ] Devise or `has_secure_password` configured with strong defaults
- [ ] Session store is server-side for sensitive apps (not cookie-only)
- [ ] Rack::Attack or similar rate limiting configured
- [ ] Password minimum length enforced (>= 8 characters)
- [ ] Session timeout configured (`expire_after` option)
- [ ] Remember me token has expiry and rotation

## Data Integrity [A08:2025 | PR.DS]
- [ ] ActiveJob payloads don't serialize sensitive user objects
- [ ] `Marshal.load` not used with untrusted data
- [ ] Webhook receivers validate signatures
- [ ] File uploads use Active Storage with validated content types

## Logging [A09:2025 | DE.CM]
- [ ] `config.filter_parameters` includes passwords, tokens and secrets
- [ ] Auth events (login, logout, failures) logged
- [ ] Admin actions logged with actor identity
- [ ] `config.log_level` set to `:info` or higher in production

## Error Handling [A10:2025 | DE.AE]
- [ ] Custom error pages in `public/` (404.html, 500.html)
- [ ] `rescue_from` in ApplicationController returns generic messages
- [ ] External HTTP calls have timeouts (`open_timeout`, `read_timeout`)
- [ ] Background jobs (Sidekiq, Resque) have retry and dead-letter handling

## Supply Chain [A03:2025 | GV.SC]
- [ ] `bundle audit` shows no critical CVEs
- [ ] `Gemfile.lock` committed
- [ ] No gems with wildcard version constraints
- [ ] Rails version is actively supported (check end-of-life)

## Dependency Audit Command
```bash
bundle audit check --update
```
