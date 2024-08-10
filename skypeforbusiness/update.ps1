import-module au

$releases = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=49117'

if ($MyInvocation.InvocationName -ne '.') {
    function global:au_BeforeUpdate {
        $Latest.Checksum = Get-RemoteChecksum $Latest.URL
    }
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(?i)(^\s*url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"
        }
     }
}

function global:au_GetLatest {

    $download_page = Invoke-WebRequest -Uri "$releases" -UseBasicParsing
    $url = $download_page.links | ? href -match '/officedeploymenttool_\d{5}-\d{5}\.exe$' | % href | select -First 1

    @{
        URL           = "$url"
        Version       = ($url -split '_|.exe' | select -Last 1 -Skip 1) -replace "-","."
        RemoteVersion = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor none
}