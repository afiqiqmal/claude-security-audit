# CLAUDE.md

## Project

Claude Code slash command for white-box and gray-box security auditing. Maps findings to OWASP Top 10:2025, CWE, NIST CSF 2.0, SANS/CWE Top 25, OWASP ASVS 4.0, PCI DSS 4.0, MITRE ATT&CK, SOC 2 and ISO 27001:2022. Includes security hotspots, code smells and framework-specific checks.

## Conventions

- No em-dashes. Use ` - ` (space-hyphen-space) instead
- No comma before "and" (no Oxford comma)
- No AI jargon: avoid "leverage", "utilize", "cutting-edge"
- Every finding must have OWASP, CWE ID and NIST CSF 2.0 mapping (other compliance frameworks where applicable)
- Every finding must include exact file path, line number and vulnerable code
- Code fixes are only included when user passes `--fix` flag
- Reports save to `./security-audit-report.md` in the project root (not global)

## Structure

- `.claude/commands/security-audit.md` - The slash command (entry point)
- `references/attack-vectors.md` - Detailed checklists per attack category
- `references/nist-csf-mapping.md` - NIST CSF 2.0 mapping tables
- `references/compliance-mapping.md` - CWE, SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001 mapping
- `references/frameworks/` - Framework-specific checklists (Laravel, Next.js, FastAPI, Express, Django, Rails, Spring Boot, ASP.NET Core, Go, Flask)
- `security-audit-guidelines.md` - Severity ratings and conventions
- `install.sh` - Installs command and references to `~/.claude/`
