#requires -version 7.3

return "This is a demo script file"

Get-PackageSource

#add nuget
Register-PackageSource -Name NuGet.org -Location https://www.nuget.org/api/v2 -ProviderName NuGet
Find-Package Terminal.Gui -ProviderName Nuget

Install-Package -Name Terminal.Gui -Force -Source nuget.org -Scope AllUsers -SkipDependencies

Get-Package Terminal.GUI -ov p

#get the assembly for your project
expand-archive $p.source -DestinationPath c:\temp\terminalgui
Get-ChildItem c:\temp\terminalgui
Get-ChildItem c:\temp\terminalgui\lib
Get-ChildItem c:\temp\terminalgui\lib\net7.0
Copy-Item c:\temp\terminalgui\lib\net7.0\terminal.gui.dll -Destination .\assemblies\ -PassThru
#dir c:\temp\terminalgui\lib\netstandard2.1
#copy c:\temp\terminalgui\lib\netstandard2.1\terminal.gui.dll -Destination .\assemblies\ -PassThru

#also need the latest version of NStack.core
Find-Package NStack.Core -ProviderName Nuget
Install-Package -Name NStack.Core -Force -Source nuget.org -Scope AllUsers -SkipDependencies
$src = (Get-Package NStack.core).source

expand-archive $src -DestinationPath c:\temp\NStack
Get-ChildItem c:\temp\NStack
Copy-Item c:\temp\NStack\lib\netstandard2.0\NStack.dll -Destination .\assemblies -PassThru -force

#check your NStack version
Get-ChildItem .\assemblies\ |
Select-Object Name,@{Name="Version";Expression={$_.VersionInfo.FileVersion}}

