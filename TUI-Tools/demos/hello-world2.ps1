#requires -version 7.3

#be careful running this in VSCode to avoid keybinding conflicts
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
#change the quit key
#THIS WILL PERSIST IF NOT SPECIFIED
#https://gui-cs.github.io/Terminal.Gui/api/Terminal.Gui/Terminal.Gui.Key.html
[Terminal.Gui.Application]::QuitKey = 27
#[Terminal.Gui.Key]::Esc


$win = [Terminal.Gui.Window] @{
  Title = 'Hello World'
  Text  = 'I came, I saw, I scripted.'
  <#
  #Experiment with sizing
  X=5
  Y=5
  Width = [Terminal.Gui.Dim]::Fill(5)
  Height = [Terminal.Gui.Dim]::Fill(5)
  #>
}
$btn = [Terminal.Gui.Button] @{
  X    = [Terminal.Gui.Pos]::Center()
  Y    = [Terminal.Gui.Pos]::Center() + 1
  Text = '_Quit (ESC)'
}

# Attach an event handler to the button.
# Note: Register-ObjectEvent -Action is NOT an option, because
# the [Application]::Run() method used to display the window is blocking.
$btn.add_Clicked({
    # Close the modal window.
    # This call is also necessary to stop printing garbage in response to mouse
    # movements later.
    [Terminal.Gui.Application]::RequestStop()
  })

$win.Add($btn)

[Terminal.Gui.Application]::Top.Add($win)
[Terminal.Gui.Application]::Run()
[Terminal.Gui.Application]::ShutDown()