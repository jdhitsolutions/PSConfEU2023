# "Repurposed" from Andrew Pla

using namespace Terminal.Gui

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

[Application]::Init()
[Application]::QuitKey = 27
#[Terminal.Gui.Key]::Esc

# Create a window to add frames to
$Window = [Window]::new()
$Window.Title = "Window Title ($([Application]::QuitKey))"

$Frame1 = [FrameView]::new()
$Frame1.Width = [Dim]::Percent(50)
$Frame1.Height = [Dim]::Fill()
$Frame1.Title = 'Frame 1'
$Window.Add($Frame1)

$Frame2 = [FrameView]::new()
$Frame2.Width = [Dim]::Percent(50)
$Frame2.Height = [Dim]::Percent(50)

# Set position relative to frame1
$Frame2.X = [Pos]::Right($Frame1)
$Frame2.Title = 'Frame 2'
$Window.Add($Frame2)

$Label1 = [Label]::new()
$Label1.Text = 'Frame 1 Content'
$Label1.Height = 1
$Label1.Width = 20
$Frame1.Add($Label1)

$Label2 = [Label]::new()
$Label2.Text = 'Frame 2 Content'
$Label2.Height = 1
$Label2.Width = 20
$Frame2.Add($Label2)

[Application]::Top.Add($Window)

[Application]::Run()

# This makes it so it actually closes
[Application]::Shutdown()