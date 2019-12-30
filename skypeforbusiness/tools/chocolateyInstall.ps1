$script                     = $MyInvocation.MyCommand.Definition
$packageName                = 'SkypeforBusinessRetail'
$configFile                 = Join-Path $(Split-Path -parent $script) 'configuration.xml'
$configFile64               = Join-Path $(Split-Path -parent $script) 'configuration64.xml'
$bitCheck                   = Get-ProcessorBits
$configurationFile          = if ($BitCheck -eq 64) { $configFile64 } else { $configFile }
$officetempfolder           = Join-Path $env:Temp 'chocolatey\SkypeforBusinessRetail'
$packageArgs                = @{
    packageName             = 'Office365DeploymentTool'
    fileType                = 'exe'
    url                     = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_12130-20272.exe'
    checksum                = 'E94CA0062ED610CDED2399E22AD2CAB6377989CB0744CEED1CF3500C9810C45D'
    checksumType            = 'sha256'
    softwareName            = 'SkypeforBusinessEntryRetail*'
    silentArgs              = "/extract:`"$officetempfolder`" /log:`"$officetempfolder\SkypeforBusinessRetail.log`" /quiet /norestart"
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