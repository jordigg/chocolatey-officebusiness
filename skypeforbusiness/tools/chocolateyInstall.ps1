﻿$script                     = $MyInvocation.MyCommand.Definition
$packageName                = 'SkypeforBusinessRetail'
$configFile                 = Join-Path $(Split-Path -parent $script) 'configuration.xml'
$configFile64               = Join-Path $(Split-Path -parent $script) 'configuration64.xml'
$bitCheck                   = Get-ProcessorBits
$configurationFile          = if ($BitCheck -eq 64) { $configFile64 } else { $configFile }
$officetempfolder           = Join-Path $env:Temp 'chocolatey\SkypeforBusinessRetail'
$packageArgs                = @{
    packageName             = 'Office365DeploymentTool'
    fileType                = 'exe'
    url                     = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_9119.3601.exe'
    checksum                = '1DA31BB6F4BCD487F1DA3BDD1B3E8C0A87877A8EB599FF6DAD39DD2B4D230590'
    checksumType            = 'sha256'
    softwareName            = 'SkypeforBusinessEntryRetail*'
    silentArgs              = "/extract:`"$officetempfolder`" /log:`"$officetempfolder\SkypeforBusinessEntryRetail.log`" /quiet /norestart"
    validExitCodes          = @(
        0, # success
        3010, # success, restart required
        2147781575, # pending restart required
        2147205120  # pending restart required for setup update
    )
}

# Download and install the deployment tool
Install-ChocolateyPackage @packageArgs

# Use the deployment tool to download the setup files
$packageArgs['packageName'] = 'SkypeforBusinessRetail'
$packageArgs['file'] = "$officetempfolder\Setup.exe"
$packageArgs['silentArgs'] = "/download $configurationFile `"$officetempfolder\setup.exe`""
Install-ChocolateyInstallPackage @packageArgs

# Run the actual Office setup
$packageArgs['file'] = "$officetempfolder\Setup.exe"
$packageArgs['packageName'] = $packageName
$packageArgs['silentArgs'] = "/configure $configurationFile"
Install-ChocolateyInstallPackage @packageArgs

if (Test-Path "$officetempfolder") {
    Remove-Item -Recurse "$officetempfolder"
}