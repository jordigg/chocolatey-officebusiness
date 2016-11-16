$configFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'configuration.xml')
$packageName = 'Office365BusinessBasic'
$installerType = 'EXE'
$url = 'https://c2rsetup.officeapps.live.com/c2r/download.aspx?productReleaseID=SkypeforBusinessEntryRetail&platform=x86&language=en-us&source=O16O365&version=O16GA'
$checksum = '07B3291CEAAF3AC3B597183D4778C12572857CA5B3D87DC0A7F26797FE473640'

$silentArgs = "/extract:$env:temp\office /log:$env:temp\officeInstall.log /quiet /norestart"
$validExitCodes = @(0)

$architecture = Get-ProcessorBits
If ($architecture -eq 64) {
   $url        = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?productReleaseID=SkypeforBusinessEntryRetail&platform=x64&language=en-us&source=O16O365&version=O16GA"
   $checksum   = 'B8EF77B2DF1C68F209B5C97F85E4B815592D8B9D4813A0BB4E3A73E8C34635BD'
   $configFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'configuration64.xml')
}

Write-Host "Extracting to $silentArgs"
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes -Checksum $checksum -ChecksumType "sha256"
Install-ChocolateyInstallPackage "$packageName" "$installerType" "/download $configFile" "$env:temp\office\setup.exe"
Install-ChocolateyInstallPackage "$packageName" "$installerType" "/configure $configFile" "$env:temp\office\setup.exe"