# CLAUDE.md

## Project

Claude Code slash command for white-box and gray-box security auditing. Maps findings to OWASP Top 10:2025, CWE, NIST CSF 2.0, SANS/CWE Top 25, OWASP ASVS 5.0, PCI DSS 4.0.1, MITRE ATT&CK, SOC 2 and ISO 27001:2022. Includes security hotspots, code smells and framework-specific checks.

## Conventions

- No em-dashes. Use ` - ` (space-hyphen-space) instead
- No comma before "and" (no Oxford comma)
- No AI jargon: avoid "leverage", "utilize", "cutting-edge"
- Every finding must have OWASP, CWE ID and NIST CSF 2.0 mapping (other compliance frameworks where applicable, skip extras with `--lite`)
- Every finding must include exact file path, line number and vulnerable code
- Code fixes are only included when user passes `--fix` flag
- Severity indicators: 🔴 CRITICAL, 🟠 HIGH, 🟡 MEDIUM, 🟢 LOW, 🔵 INFO
- Reports save to `./security-audit-report.md` (and `.pdf` if a converter is installed)

## Modes

- `full` (default) - All phases (1-5)
- `quick` - CRITICAL and HIGH only (phases 1-2)
- `gray` - Gray-box testing only (phases 1, 3)
- `focus:auth` / `focus:api` / `focus:config` - Deep dives (phases 1, 2, 4)
- `diff` / `diff:BRANCH` - Git-changed files only (phases 0, 1, 2, 4)
- `recheck:PATH` - Re-audit specific files/directories (phases 1, 2, 4)
- `triage` - Interactive triage of existing report
- `phase:1` through `phase:5` - Single phase execution
- `--fix` - Include remediation code blocks
- `--lite` - OWASP + CWE + NIST only (reduces token usage)
- `--fail-on critical|high|medium` - CI gating with exit summary
- `--format sarif|json` - Structured output (SARIF v2.1.0 or JSON)
- `--update-baseline` - Write finding fingerprints for future comparison
- `--diff-report path` - Compare with previous report
- `--pack name` - Load compliance packs (hipaa, gdpr, fintech, saas-multi-tenant, soc2, education)

## Structure

- `.claude/commands/security-audit.md` - The slash command (entry point)
- `references/attack-vectors.md` - Detailed checklists per attack category
- `references/nist-csf-mapping.md` - NIST CSF 2.0 mapping tables
- `references/compliance-mapping.md` - CWE, SANS Top 25, ASVS, PCI DSS, ATT&CK, SOC 2, ISO 27001 mapping
- `references/custom-template.md` - Template for custom security checks
- `references/frameworks/` - Framework-specific checklists (Laravel, Next.js, FastAPI, Express, Django, Rails, Spring Boot, ASP.NET Core, Go, Flask, Nuxt.js, SvelteKit)
- `references/features-extended.md` - Baseline, SARIF/JSON, report diff and triage specs
- `references/packs/` - Compliance packs (HIPAA, GDPR, fintech, SaaS multi-tenant, SOC 2, Education)
- `security-audit-guidelines.md` - Severity ratings, modes and conventions
- `install.sh` - Installs command and references to `~/.claude/`
