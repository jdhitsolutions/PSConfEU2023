#requires -version 7.3

return "This is a demo script file"

Get-PackageSource

#add nuget
Register-PackageSource -Name NuGet.org -Location https://www.nuget.org/api/v2 -ProviderName NuGet
Find-Package Terminal.Gui -ProviderName Nuget

Install-Package -Name Terminal.Gui -Force -Source nuget.org -Scope AllUsers -SkipDependencies

Get-Package Terminal.GUI -ov p

#get the assembly for your project
expand-archive $p.source -DestinationPath d:\temp\terminalgui
dir d:\temp\terminalgui
dir d:\temp\terminalgui\lib
dir D:\temp\terminalgui\lib\net7.0
copy D:\temp\terminalgui\lib\net7.0\terminal.gui.dll -Destination .\assemblies\ -PassThru
#dir d:\temp\terminalgui\lib\netstandard2.1
#copy D:\temp\terminalgui\lib\netstandard2.1\terminal.gui.dll -Destination .\assemblies\ -PassThru

#also need the latest version of NStack.core
Find-Package NStack.Core -ProviderName Nuget
Install-Package -Name NStack.Core -Force -Source nuget.org -Scope AllUsers -SkipDependencies
$src = (Get-Package Nstack.core).source

expand-archive $src -DestinationPath d:\temp\nstack
dir D:\temp\nstack
copy D:\temp\nstack\lib\netstandard2.0\NStack.dll -Destination .\assemblies -PassThru -force

#check your NStack version
dir .\assemblies\ |
Select Name,@{Name="Version";Expression={$_.versioninfo.fileversion}}