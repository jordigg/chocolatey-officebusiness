# [<img src="https://cdn.jsdelivr.net/gh/jordigg/chocolatey-officebusiness@5434a8cc227584a97700ba72ff56b84ae3fc53bf/icons/Windows365.png" height="48" width="48" /> office365business](https://community.chocolatey.org/packages/office365business)

Microsoft 365 Apps for business is the subscription edition of the Microsoft Office desktop apps (Word, Excel, PowerPoint, Outlook, OneNote and more), kept up to date automatically for as long as the subscription is active. This package installs it with the official [Office Deployment Tool](https://learn.microsoft.com/en-us/microsoft-365-apps/deploy/overview-office-deployment-tool), downloaded from Microsoft.

## Features

- Installs [Microsoft 365 Apps for business](https://www.microsoft.com/en-us/microsoft-365/business/microsoft-365-apps-for-business) (`O365BusinessRetail`) with all of its default apps.
- Matches the language of the operating system and the architecture of the device (64-bit on 64-bit Windows).
- Uses the `Current` [update channel](https://learn.microsoft.com/en-us/microsoft-365-apps/updates/overview-update-channels) with automatic updates enabled.
- Can install another product, a subset of apps or another language, or use your own configuration file, through package parameters.

## Package Parameters

- `/configpath` - Path to a [custom XML configuration](https://learn.microsoft.com/en-us/microsoft-365-apps/deploy/office-deployment-tool-configuration-options) on the system to use instead of the default one.
- `/productid` - [Product ID](https://learn.microsoft.com/en-us/troubleshoot/microsoft-365-apps/office-suite-issues/product-ids-supported-office-deployment-click-to-run) to install instead of `O365BusinessRetail`.
- `/exclude` - Apps to leave out of the product, separated by spaces (for example `Access Publisher`).
- `/language` - [Language](https://learn.microsoft.com/en-us/microsoft-365-apps/deploy/overview-deploying-languages-microsoft-365-apps#languages-culture-codes-and-companion-proofing-languages) to install instead of the operating system's (for example `fr-FR`).
- `/updates` - `TRUE` (default) or `FALSE` to enable or disable automatic updates.
- `/eula` - `TRUE` (default) or `FALSE` to accept the EULA automatically.

Example: Microsoft 365 Home Premium in 32-bit, with only Excel, PowerPoint and Word, in French, with updates disabled and the EULA not accepted automatically:

`choco install office365business --forcex86 --params "'/productid:O365HomePremRetail /exclude:Access Groove Lync OneDrive OneNote Outlook Publisher /language:fr-FR /updates:FALSE /eula:FALSE'"`

## Notes

- **Installing this package removes any MSI-installed Office products** (including Visio, Project and language packs) before installing, to avoid conflicts. This doesn't apply when you pass your own file with `/configpath`.
- To install the 32-bit version on 64-bit Windows, add `--forcex86`.
- Using the apps requires a Microsoft 365 subscription that includes them.
