$script                     = $MyInvocation.MyCommand.Definition
$packageName                = 'Office365Business'
$configFile                 = Join-Path $(Split-Path -parent $script) 'configuration.xml'
$configFile64               = Join-Path $(Split-Path -parent $script) 'configuration64.xml'
$configurationFile          = if (Get-ProcessorBits -eq 64) { $configFile64 } else { $configFile }
$officetempfolder           = Join-Path $env:Temp 'chocolatey\Office365Business'
$packageArgs                = @{
    packageName             = 'Office365DeploymentTool'
    fileType                = 'exe'
    url                     = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_8008-3601.exe'
    checksum                = 'A7F8CD73AD61EDDB42303E7D2A0D4F4080B8330267E7B6AD63C17F12926F04DD'
    checksumType            = 'sha256'
    softwareName            = 'Office365Business*'
    silentArgs              = "/extract:`"$officetempfolder`" /log:`"$officetempfolder\OfficeInstall.log`" /quiet /norestart"
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
$packageArgs['packageName'] = 'Office365BusinessInstaller'
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
