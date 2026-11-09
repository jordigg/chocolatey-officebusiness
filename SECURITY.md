# Security Policy

## Reporting a vulnerability

Please **do not** open a public issue for security problems.

Report them privately through GitHub instead: go to the
[Security tab](https://github.com/jordigg/chocolatey-officebusiness/security) and choose
**Report a vulnerability**. You will get a response as soon as possible.

## Scope

These packages contain only installation routines. Office itself is downloaded from
Microsoft's official servers and verified with a SHA-256 checksum. Vulnerabilities in
Microsoft 365 or the Office Deployment Tool should be reported to Microsoft through the
[Microsoft Security Response Center](https://msrc.microsoft.com/).

In scope for this repository:

- The install and update scripts (`*.ps1`)
- The package metadata (`*.nuspec`)
- The GitHub Actions workflows in `.github/`
