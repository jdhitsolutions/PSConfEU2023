#requires -version 7.2

#this needs a later version of Terminal.Gui - see Get-TerminalGUI.ps1

#https://gui-cs.github.io/Terminal.Gui/api/Terminal.Gui/Terminal.Gui.ProgressBar.html

$scriptVer = '0.4.0'
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
$window.title = "Progress Bar Demo"

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

$labelC = [Terminal.Gui.Label]::New()
$labelC.Text = "C:"
$labelC.x = 2
$labelC.y =2

$window.Add($labelC)

$rec = [Terminal.Gui.Rect]::new(1, 5, 50, 5)
$p = [Terminal.Gui.ProgressBar]::new($rec)
$p.Text = "free space"
$p.x = 5
$p.y = 2
$p.width = [Terminal.Gui.dim]::Fill() - 10
$p.Height = 2
$p.fraction = .75
# Simple, SimplePlusPercentage, Framed, FramedPlusPercentage, FramedProgressPadded
$p.ProgressBarFormat = 'Simple'

#Blocks, Continuous, MarqueeBlocks, MarqueeContinuous""
$p.ProgressBarStyle = 'continuous'
$global:pp = $p
$window.Add($p)

#add radio buttons to test progress bar formats
$RadioGroup = [Terminal.Gui.RadioGroup]::New(60, 2, @('Simple', 'SimplePlusPercentage', 'Framed','FramedPlusPercentage','FramedProgressPadded'), 0)
$RadioGroup.DisplayMode = 'Vertical'

$radioGroup.Add_SelectedItemChanged({
    Switch ($radioGroup.SelectedItem) {
        0 { $p.ProgressBarFormat = "Simple" }
        1 { $p.ProgressBarFormat = "SimplePlusPercentage"  }
        2 { $p.ProgressBarFormat = "Framed"  }
        3 { $p.ProgressBarFormat = "FramedPlusPercentage"  }
        4 { $p.ProgressBarFormat = "FramedProgressPadded"  }
    }
})
$Window.Add($RadioGroup)

#in a frame
$frame = [Terminal.Gui.FrameView]::new('Drive C')
$frame.x = 3
$frame.y = [Terminal.Gui.pos]::Bottom($p)+3
$frame.width = 50
$frame.Height = 4
#
#$frame.AutoSize = $True

#change the color scheme

$cs = [Terminal.Gui.ColorScheme]::new()
$n = [Terminal.Gui.Attribute]::new('Red', 'Green')
$cs.Normal = $n


$p2 = [Terminal.Gui.ProgressBar]::new()
$p2.width = [Terminal.Gui.dim]::Fill()
$p2.Height = 2
$p2.fraction = .56
$p2.ProgressBarFormat = 'SimplePlusPercentage'
$p2.progressBarStyle = 'continuous'
$p2.ColorScheme = $cs
$frame.add($p2)
$window.add($frame)

[Terminal.Gui.Application]::Top.Add($window)
[Terminal.Gui.Application]::run()
[Terminal.Gui.Application]::shutdown()