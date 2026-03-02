# Extended Features Reference

Detailed specifications for baseline suppression, SARIF/JSON output, report diff and triage mode. Loaded conditionally - only when the corresponding flag or mode is used.

## Baseline Suppression (`--update-baseline`)

### Baseline File Format

The baseline file `.security-audit-baseline.json` stores fingerprints of known findings:

```json
{
  "version": 1,
  "date": "2026-03-02",
  "tool": "claude-security-audit",
  "findings": [
    {
      "id": "CRITICAL-001",
      "fingerprint": "a1b2c3d4e5f67890",
      "file": "src/auth/login.php",
      "cwe": "CWE-89",
      "owasp": "A05:2025",
      "title": "SQL Injection in login query"
    }
  ]
}
```

### Fingerprint Calculation

Each finding fingerprint is a short hash derived from:
- Finding ID pattern (e.g., "CRITICAL", "HIGH", "MEDIUM")
- File path (relative to project root)
- CWE ID
- Finding title (normalized to lowercase, trimmed)

Format: first 16 characters of SHA-256 hex digest of `{severity}:{file_path}:{cwe}:{normalized_title}`.

### Update Baseline Flow

When `--update-baseline` is passed:
1. Run the audit normally (all requested phases)
2. After generating the report, collect all findings
3. Compute fingerprints for each finding
4. Write `.security-audit-baseline.json` to the project root
5. Tell the developer: `Baseline updated with X findings. Future runs will mark these as "Known".`

### Baseline Comparison Flow

On every run (when no `--update-baseline` flag):
1. Check if `.security-audit-baseline.json` exists in the project root
2. If it exists, read and parse the baseline
3. For each finding in the current audit, compute its fingerprint
4. If the fingerprint matches a baseline entry, tag the finding as `[Known]` in the report
5. Add a "New since baseline" row to the Executive Summary table:
   - Count findings NOT in the baseline
   - Format: `| New since baseline | X |`
6. Known findings still appear in the report (they are not hidden) but are clearly tagged

### Report Tagging

Known findings appear with a `[Known]` badge after the severity:
```
### 🟡 [MEDIUM-003] [Known] Missing CSRF token on settings form
```

New findings (not in baseline) appear normally with no extra badge.

---

## SARIF Output (`--format sarif`)

### SARIF v2.1.0 Schema

Output file: `./security-audit-report.sarif`

The SARIF output follows the OASIS SARIF v2.1.0 standard for integration with GitHub Advanced Security, Azure DevOps and other SARIF-compatible tools.

### Structure

```json
{
  "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/main/sarif-2.1/schema/sarif-schema-2.1.0.json",
  "version": "2.1.0",
  "runs": [
    {
      "tool": {
        "driver": {
          "name": "claude-security-audit",
          "version": "1.0.0",
          "informationUri": "https://github.com/afiqiqmal/claude-security-audit",
          "rules": []
        }
      },
      "results": []
    }
  ]
}
```

### Rule Mapping

Each unique finding type becomes a SARIF rule:

| Finding Field | SARIF Rule Field |
|--------------|-----------------|
| OWASP ID + CWE | `rule.id` (e.g., `A05-CWE-89`) |
| Finding title | `rule.shortDescription.text` |
| Attack vector | `rule.fullDescription.text` |
| Severity | `rule.defaultConfiguration.level` |
| OWASP category | `rule.properties.tags[]` |

### Severity Mapping

| Audit Severity | SARIF Level |
|---------------|-------------|
| CRITICAL | `error` |
| HIGH | `error` |
| MEDIUM | `warning` |
| LOW | `note` |
| INFO | `note` |

### Result Mapping

Each finding becomes a SARIF result:

| Finding Field | SARIF Result Field |
|--------------|-------------------|
| Finding ID | `result.ruleId` |
| File path + line | `result.locations[0].physicalLocation` |
| Vulnerable code | `result.locations[0].physicalLocation.region.snippet.text` |
| Impact | `result.message.text` |
| CWE ID | `result.properties.cwe` |
| NIST CSF | `result.properties.nist-csf` |

### SARIF Fix Objects

When `--fix` is set, each SARIF result includes a `fixes` array with replacement text mapped to SARIF `artifactChange` objects. This allows SARIF-compatible tools to offer one-click remediation.

```json
{
  "ruleId": "A05-CWE-89",
  "message": { "text": "SQL Injection in login query" },
  "fixes": [
    {
      "description": { "text": "Use parameterized query" },
      "artifactChanges": [
        {
          "artifactLocation": { "uri": "src/auth/login.php" },
          "replacements": [
            {
              "deletedRegion": {
                "startLine": 123,
                "startColumn": 1,
                "endLine": 125,
                "endColumn": 1
              },
              "insertedContent": {
                "text": "$stmt = $pdo->prepare('SELECT * FROM users WHERE email = ?');\n$stmt->execute([$email]);\n"
              }
            }
          ]
        }
      ]
    }
  ]
}
```

| Fix Field | Source |
|----------|--------|
| `fixes[].description.text` | Remediation description from finding |
| `artifactChanges[].artifactLocation.uri` | File path from finding location |
| `replacements[].deletedRegion` | Line range of vulnerable code |
| `replacements[].insertedContent.text` | Fixed code block content |

Without `--fix`, the `fixes` array is omitted from results.

---

## JSON Output (`--format json`)

### JSON Schema

Output file: `./security-audit-report.json`

A structured JSON representation for custom tooling and dashboards.

### Structure

```json
{
  "meta": {
    "tool": "claude-security-audit",
    "version": "1.0.0",
    "date": "2026-03-02",
    "project": "project-name",
    "mode": "full",
    "flags": ["--fix", "--lite"]
  },
  "summary": {
    "critical": 0,
    "high": 0,
    "medium": 0,
    "low": 0,
    "info": 0,
    "graybox": 0,
    "hotspots": 0,
    "smells": 0,
    "total": 0,
    "risk_assessment": "..."
  },
  "findings": [
    {
      "id": "CRITICAL-001",
      "title": "...",
      "severity": "CRITICAL",
      "owasp": "A05:2025",
      "cwe": "CWE-89",
      "nist_csf": "PR.DS",
      "compliance": {
        "sans_top25": "#3",
        "asvs": "V5.3.4",
        "pci_dss": "6.2.4",
        "mitre_attack": "T1190",
        "soc2": "CC6.6",
        "iso27001": "A.8.28"
      },
      "location": {
        "file": "src/auth/login.php",
        "line": 123,
        "code": "..."
      },
      "attack_vector": "...",
      "impact": "...",
      "remediation": "...",
      "fix_code": null,
      "baseline_status": "new"
    }
  ],
  "owasp_coverage": {},
  "nist_coverage": {}
}
```

The `fix_code` field is `null` unless `--fix` is set. The `compliance` object is empty when `--lite` is set. The `baseline_status` field is `"new"` or `"known"` when a baseline file exists, otherwise omitted.

---

## Report Diff (`--diff-report path`)

### Comparison Logic

When `--diff-report ./previous-report.md` is passed:
1. Run the audit normally and generate the new report
2. Parse the previous report at the given path
3. Extract findings from both reports by matching:
   - Finding ID pattern (e.g., `CRITICAL-001`)
   - File path from the Location field
   - Finding title (approximate match - 80%+ word overlap)
4. Classify each finding as:
   - **New** - exists in current report but not in previous
   - **Resolved** - exists in previous report but not in current
   - **Changed severity** - same finding, different severity level
   - **Unchanged** - same finding, same severity

### Report Section

Add a "Changes Since Previous Audit" section immediately after the Executive Summary:

```markdown
## Changes Since Previous Audit

Compared with: `./previous-report.md` (dated YYYY-MM-DD)

| Change Type | Count |
|------------|-------|
| New findings | X |
| Resolved findings | X |
| Changed severity | X |
| Unchanged | X |

### New Findings
- 🔴 [CRITICAL-002] SQL injection in search endpoint (`src/api/search.php:45`)
- 🟡 [MEDIUM-005] Missing rate limit on password reset (`src/auth/reset.php:12`)

### Resolved Findings
- ~~🟠 [HIGH-003] Hardcoded API key in config~~ (`config/services.php:8`)

### Changed Severity
- [MEDIUM-001] XSS in comment field: 🟢 LOW -> 🟡 MEDIUM (`src/views/comments.php:67`)
```

### Matching Strategy

Findings are matched between reports using a two-pass approach:
1. **Exact match**: Same file path AND same CWE AND similar title (80%+ word overlap)
2. **Fuzzy match**: Same CWE AND same title across different file paths (handles moved code)

Unmatched findings in the current report are "New". Unmatched findings in the previous report are "Resolved".

---

## Triage Mode

### Activation

Triage mode runs after an audit when `./security-audit-report.md` exists:
- Command: `/security-audit triage`
- Requires an existing report file in the project root

### Triage Flow

For each finding in the existing report (ordered by severity, CRITICAL first):

1. Display the finding summary (ID, title, severity, location)
2. Ask the developer to choose one of:
   - **Accept** - Will fix this finding (assign to current sprint/backlog)
   - **Defer** - Known risk, accepted for now (document reason)
   - **Dismiss** - False positive or not applicable (document reason)
   - **Escalate** - Needs team review or architect decision
3. For Defer and Dismiss, ask for a one-line reason
4. Move to the next finding

### Triage Output

Save triage results to `./security-audit-triage.md`:

```markdown
# Security Audit Triage

**Report**: ./security-audit-report.md
**Date**: 2026-03-02
**Triaged by**: [developer]

## Summary

| Decision | Count |
|----------|-------|
| Accept (will fix) | X |
| Defer (known risk) | X |
| Dismiss (false positive) | X |
| Escalate (needs review) | X |
| **Total triaged** | **X** |

---

## Decisions

### 🔴 [CRITICAL-001] SQL Injection in login query
- **Decision**: Accept
- **Action**: Fix in current sprint

### 🟠 [HIGH-002] Hardcoded API key
- **Decision**: Defer
- **Reason**: Key rotates monthly, migrating to vault next quarter

### 🟡 [MEDIUM-003] Missing CSRF token
- **Decision**: Dismiss
- **Reason**: API-only endpoint, no browser clients

### 🟡 [MEDIUM-004] Verbose error messages
- **Decision**: Escalate
- **Reason**: Need architect input on error handling strategy
```

### Triage Templates

Pre-written reason templates for common triage decisions. Present these as suggestions when the developer chooses Defer, Dismiss or Escalate.

**Defer templates:**
- "Scheduled for remediation in [sprint/quarter]. Tracking in [ticket]."
- "Risk accepted - compensating control in place ([describe control])."
- "Low-traffic endpoint - fixing after higher-priority items."
- "Dependency update pending upstream fix. Monitoring [advisory URL]."

**Dismiss templates:**
- "False positive - [variable/function] is internally controlled, never user input."
- "Test/fixture code only - not deployed to production."
- "Mitigated by [WAF rule / network policy / framework default]."
- "Deprecated endpoint scheduled for removal in [version/date]."

**Escalate templates:**
- "Requires architectural decision on [topic]. Assigning to [team/person]."
- "Cross-team dependency - needs coordination with [team]."
- "Regulatory/compliance implication - needs legal/compliance review."
- "Performance trade-off - needs benchmarking before applying fix."

### Severity Override

During triage, the developer may adjust a finding's severity. When overriding:
1. Ask for the new severity level (CRITICAL, HIGH, MEDIUM, LOW, INFO)
2. Ask for a one-line justification
3. Record the override in the triage output:

```markdown
### 🟡 [MEDIUM-003] Missing CSRF token
- **Decision**: Accept
- **Severity override**: MEDIUM -> 🟢 LOW
- **Override reason**: API-only endpoint behind VPN, no browser clients
- **Action**: Fix in next sprint
```

Severity overrides appear in the triage file only. They do not modify the original audit report.

### Triage Integration

When a triage file exists and a new audit is run:
- Note the existence of the triage file in the Methodology section
- Do not automatically apply previous triage decisions (each audit is fresh)
- The developer can re-run triage after each new audit
