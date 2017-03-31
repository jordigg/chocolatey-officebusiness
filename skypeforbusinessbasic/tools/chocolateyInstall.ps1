$architecture = Get-ProcessorBits
$configFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) "configuration$architecture.xml")
$packageName = 'SkypeforBusinessEntryRetail'
$installerType = 'EXE'
$url = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_8008-3601.exe'
$checksum = 'A7F8CD73AD61EDDB42303E7D2A0D4F4080B8330267E7B6AD63C17F12926F04DD'

$silentArgs = "/extract:$env:temp\office /log:$env:temp\officeInstall.log /quiet /norestart"
$validExitCodes = @(0)

Write-Host "Extracting to $silentArgs"
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes -Checksum $checksum -ChecksumType "sha256"
Install-ChocolateyInstallPackage "$packageName" "$installerType" "/download $configFile" "$env:temp\office\setup.exe"
Install-ChocolateyInstallPackage "$packageName" "$installerType" "/configure $configFile" "$env:temp\office\setup.exe"