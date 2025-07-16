Import-Module au

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
        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
    }

    try {
        # Fetch the page content
        $page = Invoke-WebRequest -Uri $releases -Headers $headers -UseBasicParsing

        # Look for the direct .exe link in the HTML (as you saw)
        $exeUrl = ($page.RawContent -split '"') | Where-Object { $_ -match '^https://.*\.exe$' } | Select-Object -First 1

        if (-not $exeUrl) {
            throw "Could not find direct .exe download URL in page content."
        }

        # Extract version from filename
        $filename = [System.IO.Path]::GetFileNameWithoutExtension($exeUrl)
        $versionPart = ($filename -split '_')[-1]
        $cleanVersion = $versionPart -replace '-', '.'

        if (-not ($cleanVersion -match '^\d+(\.\d+)*$')) {
            throw "Invalid version format extracted from: $filename"
        }

        return @{
            URL           = $exeUrl
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
        update -ChecksumFor none
    }
    catch {
        throw "Update process failed. Error: $_"
    }
}
