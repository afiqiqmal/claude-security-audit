# CLAUDE.md

## Project

Claude Code slash command for white-box and gray-box security auditing with OWASP Top 10:2025 and NIST CSF 2.0 mapping. Includes security hotspots, code smells and framework-specific checks.

## Conventions

- No em-dashes. Use ` - ` (space-hyphen-space) instead
- No comma before "and" (no Oxford comma)
- No AI jargon: avoid "leverage", "utilize", "cutting-edge"
- Every finding must map to a NIST CSF 2.0 function and category
- Every finding must include exact file path, line number and vulnerable code
- Code fixes are only included when user passes `--fix` flag
- Reports save to `./security-audit-report.md` in the project root (not global)

## Structure

- `.claude/commands/security-audit.md` - The slash command (entry point)
- `references/attack-vectors.md` - Detailed checklists per attack category
- `references/nist-csf-mapping.md` - NIST CSF 2.0 mapping tables
- `references/frameworks/` - Framework-specific checklists (Laravel, Next.js, FastAPI, Express, Django, Rails, Spring Boot, ASP.NET Core, Go, Flask)
- `security-audit-guidelines.md` - Severity ratings and conventions
- `install.sh` - Installs command and references to `~/.claude/`
