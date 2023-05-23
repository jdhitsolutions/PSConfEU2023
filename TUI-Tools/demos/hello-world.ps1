#requires -version 7.3

<#
Be careful running this in VSCode to avoid keybinding conflicts
Or se this code in VS Code to allow Ctrl + Q to pass to the terminal
https://github.com/microsoft/vscode/issues/108130
"terminal.integrated.commandsToSkipShell": [
"-workbench.action.quickOpenView"
]
  - Thank you, Andrew Pla
#>


If ($host.name -ne 'ConsoleHost') {
  Write-Warning "This must be run in a console host."
  Return
}
#load .NET specific version
Add-Type -path $PSScriptRoot\assemblies\NStack.dll
Add-Type -path $PSScriptRoot\assemblies\Terminal.Gui.dll

#need to initialize
[Terminal.Gui.Application]::Init()

$win = New-Object Terminal.Gui.Window
$win.Title = "Hello, World"
$win.Text = "I was here."
$win.AutoSize = $True
# $win | Get-Member

<#
$win = [Terminal.Gui.Window] @{sd
  Title = 'Hello, World'
  Text = 'I was here.'
} #>

[Terminal.Gui.Application]::Top.Add($win)
[Terminal.Gui.Application]::Run()
#press Ctrl+Q to quit
[Terminal.Gui.Application]::ShutDown()
