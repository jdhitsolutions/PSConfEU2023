return "This is a demo script file."

#region setup

#NStack
#the version with Out-ConsoleGridView is outdated
# Install-Module Microsoft.PowerShell.ConsoleGuiTools

Get-Process | Select-Object ID,Name,WS,StartTime | Out-ConsoleGridView

psedit .\Get-Requirements.ps1

#endregion
#region hello-world
https://gui-cs.github.io/Terminal.Gui/index.html
https://gui-cs.github.io/Terminal.Gui/api/Terminal.Gui/Terminal.Gui.html
https://gui-cs.github.io/Terminal.Gui/articles/overview.html

psedit .\hello-world.ps1
psedit .\hello-world2.ps1
psedit .\sample-tui.ps1

#demo in Ubuntu instance

#endregion
#region elements

psedit .\frames.ps1
psedit .\lists.ps1
psedit .\menus.ps1
psedit .\progress-sample.ps1
psedit .\filedialog.ps1

#endregion

#region complete examples

psedit .\tui-credential.ps1
psedit .\ServiceInfo.ps1

#endregion

#region TerminalGuiDesigner

https://blog.ironmansoftware.com/tui-powershell/

# Install-Module TerminalGuiDesigner -Force -Scope AllUsers
#there may be dll conflicts
import-Module TerminalGuiDesigner -force
#init to work around a bug related to dragging and moving controls
[Terminal.Gui.Application]::Init()
Show-TuiDesigner
#endregion
