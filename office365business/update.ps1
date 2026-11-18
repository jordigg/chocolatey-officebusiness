# Prefer the maintained Chocolatey-AU module, fall back to the legacy 'au' module
if (Get-Module -ListAvailable -Name Chocolatey-AU) { Import-Module Chocolatey-AU } else { Import-Module au }

# Function to calculate the checksum before updating
if ($MyInvocation.InvocationName -ne '.') {
    function global:au_BeforeUpdate {
        try {
            $Latest.Checksum = Get-RemoteChecksum $Latest.URL
        }
        catch {
            throw "Failed to calculate checksum for URL: $($Latest.URL). Error: $_"
        }
    }
}

# The package description is README.md from its "## Description" heading on, so the title,
# badges and links above it stay on GitHub only (update runs with -NoReadme to skip AU's
# default, which copies everything after line 2).
# Chocolatey rejects descriptions over 4000 characters with a bare 409 Conflict on push,
# so fail here with a clear message instead. au_AfterUpdate runs before choco pack.
function global:au_AfterUpdate($Package) {
    $readme = Join-Path $PSScriptRoot 'README.md'
    $start = (Select-String -Path $readme -Pattern '^## Description\s*$' | Select-Object -First 1).LineNumber
    if (-not $start) { throw "README.md has no '## Description' heading to start the package description from" }
    Set-DescriptionFromReadme -Package $Package -ReadmePath $readme -SkipFirst ($start - 1)

    $nuspec = Get-Content "$PSScriptRoot\office365business.nuspec" -Raw
    $description = [regex]::Match($nuspec, '(?s)<description><!\[CDATA\[(.*?)\]\]></description>').Groups[1].Value
    if ($description.Length -gt 4000) {
        throw "Package description is $($description.Length) characters (limit 4000). Shorten office365business/README.md."
    }
}

# Function to search and replace values in the Chocolatey install script
function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(?i)(^\s*url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"
        }
    }
}

# Function to fetch the latest release details
function global:au_GetLatest {
    $releases = 'https://www.microsoft.com/en-us/download/details.aspx?id=49117'
    $headers = @{
        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0"
        "Accept"     = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    }

    try {
        # Fetch the download page
        $download_page = Invoke-WebRequest -Uri "$releases" -Headers $headers -UseBasicParsing

        # Extract the download URL
        $url = $download_page.Links | Where-Object { $_.href -match '/officedeploymenttool_\d{5}-\d{5}\.exe$' } |
        Select-Object -ExpandProperty href -First 1

        # Ensure the full URL
        $url = if ($url -notmatch '^https?://') { "https://download.microsoft.com$url" } else { $url }

        # Extract and clean the version from the URL
        $rawVersion = ($url -split '_|\.exe' | Select-Object -Last 1 -Skip 1)
        $cleanVersion = $rawVersion -replace "-", "."

        # Validate the version
        if (-not ($cleanVersion -match '^\d+(\.\d+)*$')) {
            throw "Invalid version format: $cleanVersion"
        }

        # Return the latest details
        @{
            URL           = $url
            Version       = $cleanVersion
            RemoteVersion = $cleanVersion
        }
    }
    catch {
        throw "Failed to fetch the latest release details. Error: $_"
    }
}

# Update command
if ($MyInvocation.InvocationName -ne '.') {
    try {
        update -ChecksumFor none -NoReadme
    }
    catch {
        throw "Update process failed. Error: $_"
    }
}