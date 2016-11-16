$configFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'configuration.xml')
$packageName = 'Office365Business'
$installerType = 'EXE'
$url = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_7213-5776.exe'
$checksum = '50EC41172C31EA6BDABD35F633A3DC4AC7BB37D7935902EE1A1F3B1641406D68'

$silentArgs = "/extract:$env:temp\office /log:$env:temp\officeInstall.log /quiet /norestart"
$validExitCodes = @(0)

$architecture = Get-ProcessorBits
If ($architecture -eq 64) {
   $configFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'configuration64.xml')
}

Write-Host "Extracting to $silentArgs"
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes -Checksum $checksum -ChecksumType "sha256"
Install-ChocolateyInstallPackage "$packageName" "$installerType" "/download $configFile" "$env:temp\office\setup.exe"
Install-ChocolateyInstallPackage "$packageName" "$installerType" "/configure $configFile" "$env:temp\office\setup.exe"