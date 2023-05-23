#requires -version 7.2

#this needs a later version of Terminal.Gui - see Get-TerminalGUI.ps1

#https://migueldeicaza.github.io/gui.cs/api/Terminal.Gui/Terminal.Gui.ProgressBar.html

$scriptVer = '0.3.0'
$dlls = "$PSScriptRoot\assemblies\NStack.dll", "$PSScriptRoot\assemblies\Terminal.Gui.dll"
ForEach ($item in $dlls) {
    Try {
        Add-Type -Path $item -ErrorAction Stop
    }
    Catch [System.IO.FileLoadException] {
        #write-host "already loaded" -ForegroundColor yellow
    }
    Catch {
        Throw $_
    }
}

[Terminal.Gui.Application]::Init()

[Terminal.Gui.Application]::QuitKey = 1073741905
#[Terminal.Gui.key]'q' -bor [Terminal.Gui.Key]::CtrlMask

$window = [Terminal.Gui.window]::new()
$window.title = 'Progress Demo [$([terminal.gui.application]::QuitKey)]'

$statusbar = [Terminal.Gui.StatusBar]::new(
    @(
        [Terminal.Gui.StatusItem]::new('Unknown', $(Get-Date -Format d), {}),
        [Terminal.Gui.StatusItem]::new("Unknown", 'Ctrl+Q to quit', {}),
        [Terminal.Gui.StatusItem]::new('Unknown', "v$scriptVer", {})
    )
)
[Terminal.Gui.application]::Top.add($statusbar)

$label = [Terminal.Gui.Label]::new($($env:Computername))
$label.y = [Terminal.Gui.pos]::Top($Window)
$cs = [Terminal.Gui.ColorScheme]::new()
$n = [Terminal.Gui.Attribute]::new('BrightYellow', $window.ColorScheme.Normal.Background)
$cs.Normal = $n
$label.ColorScheme = $cs
$window.add($label)

$rec = [Terminal.Gui.Rect]::new(1, 5, 50, 5)
$p = [Terminal.Gui.ProgressBar]::new($rec)
$p.text = 'Drive'
$p.x = 2
$p.y = 2
$p.width = [Terminal.Gui.dim]::Fill() - 10
$p.Height = 2
$p.fraction = .75
# Simple, SimplePlusPercentage, Framed, FramedPlusPercentage, FramedProgressPadded
$p.ProgressBarFormat = 'Simple'

#Blocks, Continuous, MarqueeBlocks, MarqueeContinuous""
$p.ProgressBarStyle = 'continuous'

$window.Add($p)

#in a frame
$frame = [Terminal.Gui.FrameView]::new('Drive C')
$frame.x = 2
$frame.y = [Terminal.Gui.pos]::Bottom($p)
$frame.width = 50
$frame.Height = 4
#
#$frame.AutoSize = $True

$p2 = [Terminal.Gui.ProgressBar]::new()
$p2.width = [Terminal.Gui.dim]::Fill()
$p2.Height = 2
$p2.fraction = .44
$p2.ProgressBarFormat = 'SimplePlusPercentage'
$p2.progressBarStyle = 'continuous'
$frame.add($p2)
$window.add($frame)

[Terminal.Gui.Application]::Top.Add($window)
[Terminal.Gui.Application]::run()
[Terminal.Gui.Application]::shutdown()