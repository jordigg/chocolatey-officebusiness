<p align="center">
  <img src="icons/Windows365.png" alt="Microsoft 365" width="96">
</p>

<h1 align="center">Chocolatey packages for Microsoft 365</h1>

<p align="center">
  <a href="https://community.chocolatey.org/packages/office365business"><img src="https://img.shields.io/chocolatey/v/office365business?label=chocolatey&logo=chocolatey" alt="Chocolatey version"></a>
  <a href="https://community.chocolatey.org/packages/office365business"><img src="https://img.shields.io/chocolatey/dt/office365business?logo=chocolatey" alt="Chocolatey downloads"></a>
  <a href="https://github.com/jordigg/chocolatey-officebusiness/actions/workflows/update-office365business.yml"><img src="https://github.com/jordigg/chocolatey-officebusiness/actions/workflows/update-office365business.yml/badge.svg" alt="Auto-update"></a>
  <a href="https://github.com/jordigg/chocolatey-officebusiness/actions/workflows/lint.yml"><img src="https://github.com/jordigg/chocolatey-officebusiness/actions/workflows/lint.yml/badge.svg" alt="Lint"></a>
</p>

Source for the [Chocolatey](https://chocolatey.org) packages that install Microsoft 365 (Office) and Skype for Business on Windows.

## Packages

| Package | Chocolatey | Downloads | Updates |
| --- | --- | --- | --- |
| [Office 365 Business](office365business) | [![office365business](https://img.shields.io/chocolatey/v/office365business?label=)](https://community.chocolatey.org/packages/office365business) | [![downloads](https://img.shields.io/chocolatey/dt/office365business?label=)](https://community.chocolatey.org/packages/office365business) | Automatic, daily |
| [Skype for Business](skypeforbusiness) | [![SkypeForBusiness](https://img.shields.io/chocolatey/v/SkypeForBusiness?label=)](https://community.chocolatey.org/packages/skypeforbusiness) | [![downloads](https://img.shields.io/chocolatey/dt/SkypeForBusiness?label=)](https://community.chocolatey.org/packages/skypeforbusiness) | Manual (legacy) |
| [Skype for Business Basic](skypeforbusinessbasic) | [![SkypeForBusinessBasic](https://img.shields.io/chocolatey/v/SkypeForBusinessBasic?label=)](https://community.chocolatey.org/packages/skypeforbusinessbasic) | [![downloads](https://img.shields.io/chocolatey/dt/SkypeForBusinessBasic?label=)](https://community.chocolatey.org/packages/skypeforbusinessbasic) | Manual (legacy) |

## Quick start

```powershell
choco install office365business
```

The package installs Microsoft 365 Apps for business in the language and architecture of the device. Package parameters let you pick another product, language or app set, or supply your own deployment XML. See the [package README](office365business/README.md) for all options.

## How updates work

A [GitHub Actions workflow](.github/workflows/update-office365business.yml) runs every day:

1. [Chocolatey-AU](https://github.com/chocolatey-community/chocolatey-au) checks Microsoft's [Office Deployment Tool download page](https://www.microsoft.com/en-us/download/details.aspx?id=49117) for a new release.
2. If there is one, it updates the download URL and SHA-256 checksum and packs the package.
3. The package is pushed to the Chocolatey community repository, where it goes through Chocolatey's [moderation](https://docs.chocolatey.org/en-us/community-repository/moderation/) before it is published.
4. The version bump lands on `master` through an automatic pull request.

To run an update by hand, start the workflow from the [Actions tab](https://github.com/jordigg/chocolatey-officebusiness/actions/workflows/update-office365business.yml), or run `update.ps1` locally with Chocolatey-AU installed:

```powershell
choco install chocolatey-au
cd office365business
.\update.ps1
```

## Contributing

Issues and pull requests are welcome. Pull requests are checked with [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) and [zizmor](https://github.com/zizmorcore/zizmor).

To report a security problem, follow the [security policy](SECURITY.md) instead of opening a public issue.

## Disclaimer

These packages only contain installation routines. The software is downloaded from Microsoft's official servers. The maintainers have no affiliation with Microsoft.

## License

[Apache License 2.0](office365business/LICENSE)
