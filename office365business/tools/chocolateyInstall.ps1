$packageName                = 'Office365Business'
$bitCheck                   = Get-ProcessorBits
$forceX86                   = $env:chocolateyForceX86
$arch                       = if ($BitCheck -eq 32 -Or $forceX86 ) {'32'} else {'64'}
$officetempfolder           = Join-Path $env:Temp 'Office365Business'
$configurationFile          = Join-Path $officetempfolder 'configuration.xml'
$defaultProductID           = 'O365BusinessRetail'
$defaultLanguageID          = 'MatchOS'
$defaultUpdates             = 'TRUE'
$defaulAcceptEULA           = 'TRUE'
$defaultExclude             = @()

$pp = Get-PackageParameters

if ($pp['configpath'])
{
    $configurationFile = $pp['configpath']
    Write-Output "Custom config specified: $configurationFile"
}
else
{
    Write-Output 'No custom configuration specified. Generating one...'

    if ($pp['productid']) {
        $paramProductID = $pp['productid']
        Write-Output "Custom Product ID specified: $paramProductID"
    }
    else {
        Write-Output "No Product ID specified, using default: $defaultProductID"
        $paramProductID = $defaultProductID
    }

    if ($pp['exclude']) {
        $paramExclude = $pp['exclude'].split(" ")
        Write-Output "The following apps will not be installed: $paramExclude"
    }
    else {
        Write-Output "No excluded apps specified, installing all"
        $paramExclude = $defaultExclude
    }

    if ($pp['language']) {
        $paramLanguageID = $pp['language']
        Write-Output "Custom Language ID specified: $paramLanguageID"
    }
    else {
        Write-Output "No Language ID specified, using default: $defaultLanguageID"
        $paramLanguageID = $defaultLanguageID
    }

    if ($pp['updates']) {
        $paramUpdate = $pp['updates']
        Write-Output "Custom updates value specified: $paramUpdate"
    }
    else {
        Write-Output "No updates value specified, using default: $defaultUpdates"
        $paramUpdate = $defaultUpdates
    }

    if ($pp['eula']) {
        $paramEula = $pp['updates']
        Write-Output "Custom updates value specified: $paramEula"
    }
    else {
        Write-Output "No updates value specified, using default: $defaulAcceptEULA"
        $paramEula = $defaulAcceptEULA
    }

    # Assign the CSV and XML Output File Paths
    $XML_Path = $configurationFile

    #create path
    if (-Not(Test-Path $officetempfolder)) {
        New-Item -ItemType Directory -Force -Path $officetempfolder
    }

    # Create the XML File Tags
    $xmlWriter = New-Object System.XMl.XmlTextWriter($XML_Path, $Null)
    $xmlWriter.Formatting = 'Indented'
    $xmlWriter.Indentation = 1
    $XmlWriter.IndentChar = "`t"
    $xmlWriter.WriteStartDocument()
    $xmlWriter.WriteComment('Office 365 client deployment configuration')
    $xmlWriter.WriteStartElement('Configuration')
    $xmlWriter.WriteEndElement()
    $xmlWriter.WriteEndDocument()
    $xmlWriter.Flush()
    $xmlWriter.Close()

    # Create the Initial  Node
    $xmlDoc = [System.Xml.XmlDocument](Get-Content $XML_Path);
    $addNode = $xmlDoc.CreateElement("Add")
    $xmlDoc.SelectSingleNode("//Configuration").AppendChild($addNode)
    $addNode.SetAttribute("OfficeClientEdition", "$arch")
    $addNode.SetAttribute("Channel", "Current")


    $productNode = $addNode.AppendChild($xmlDoc.CreateElement("Product"));
    $productNode.SetAttribute("ID", $paramProductID)


    $languageNode = $productNode.AppendChild($xmlDoc.CreateElement("Language"));
    $languageNode.SetAttribute("ID", $paramLanguageID)

    foreach ($ExcludeApp in $paramExclude) {
        $excludeNode = $productNode.AppendChild($xmlDoc.CreateElement("ExcludeApp"));
        $excludeNode.SetAttribute("ID", $ExcludeApp)
    }

    $updatesNode = $xmlDoc.CreateElement("Updates")
    $xmlDoc.SelectSingleNode("//Configuration").AppendChild($updatesNode)
    $updatesNode.SetAttribute("Enabled", $paramUpdate)

    $displayNode = $xmlDoc.CreateElement("Display")
    $xmlDoc.SelectSingleNode("//Configuration").AppendChild($displayNode)
    $displayNode.SetAttribute("Level", "None")
    $displayNode.SetAttribute("AcceptEULA", $paramEula)

    $loggingNode = $xmlDoc.CreateElement("Logging")
    $xmlDoc.SelectSingleNode("//Configuration").AppendChild($loggingNode)
    $loggingNode.SetAttribute("Path", "%temp%")

    $removeMSINode = $xmlDoc.CreateElement("RemoveMSI")
    $xmlDoc.SelectSingleNode("//Configuration").AppendChild($removeMSINode)
    $removeMSINode.SetAttribute("All", "TRUE")

    $xmlDoc.Save($XML_Path)
}

$packageArgs                = @{
    packageName             = 'Office365DeploymentTool'
    fileType                = 'exe'
    url                     = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_15726-20202.exe'
    checksum                = '332E1373634C8F550BAEE3AF2E97B6FA91BF8478E169C56A28029C34F93EB73D'
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
$packageArgs['silentArgs'] = "/download $configurationFile"
Install-ChocolateyInstallPackage @packageArgs

# Run the actual Office setup
$packageArgs['file'] = "$officetempfolder\Setup.exe"
$packageArgs['packageName'] = $packageName
$packageArgs['silentArgs'] = "/configure $configurationFile"
Install-ChocolateyInstallPackage @packageArgs

if (Test-Path "$officetempfolder") {
    Remove-Item -Recurse "$officetempfolder"
}
