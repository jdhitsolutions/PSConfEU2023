#requires -version 7.3

If ($host.name -ne 'ConsoleHost') {
  Write-Warning "This must be run in a console host."
  Return
}

#Clear-Host

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

#using namespace Terminal.Gui
# Initialize the "GUI".
# Note: This must come before creating windows and controls.
[Terminal.Gui.Application]::Init()
[Terminal.Gui.Application]::QuitKey =1073741905
#  ('q' -as [Terminal.Gui.Key])+[Terminal.Gui.Key]::CtrlMask
#1073741937
#('q' -as [Terminal.Gui.Key])+[Terminal.Gui.Key]::CtrlMask
#[int][char]'q' + [Terminal.Gui.Key]::CtrlMask
#[Terminal.Gui.Key]'CtrlMask' + [Terminal.Gui.Key]'q'
$win = [Terminal.Gui.Window] @{
  Title = "Hello, $([System.Environment]::UserName)"
  AutoSize = $True
}

$Text = [Terminal.Gui.TextField] @{
  X     =[Terminal.Gui.Pos]::Center()
  Y     = [Terminal.Gui.Pos]::Center()
  Width = 30
  Text  = "This text will be returned."
}

$win.Add($Text)

$MsgButton = [Terminal.Gui.Button] @{
  X    =  [Terminal.Gui.Pos]::Percent(68)
  #[Terminal.Gui.Pos]::At(68)
  #[Terminal.Gui.Pos]::Center()
  Y    = [Terminal.Gui.Pos]::At(25)
  #[Terminal.Gui.Pos]::Center() + 1
  Text = '_Message'
}

$MsgButton.add_Clicked({
  #display the text as a message box with an OK button
  $r = [Terminal.Gui.MessageBox]::Query("Look at me!","What do you want to do?",0,@("Yes","No","Cancel"))
  $Text.text = "Your response is $r"
})
$win.Add($MsgButton)

$QuitButton = [Terminal.Gui.Button] @{
  X    = [Terminal.Gui.Pos]::Percent(80)
  #[Terminal.Gui.Pos]::Center()
    #[Terminal.Gui.Pos]::At(80)
  Y    = [Terminal.Gui.Pos]::At(25)
  #[Terminal.Gui.Pos]::Center() + 1
  Text = '_Quit'
}

$QuitButton.add_Clicked({[Terminal.Gui.Application]::RequestStop()})

$win.Add($QuitButton)
[Terminal.Gui.Application]::Top.Add($win)
# Show the window (takes over the whole screen). Ctrl+Q should quit
# Note: This is a blocking call.
[Terminal.Gui.Application]::Run()
[Terminal.Gui.Application]::Shutdown()

# Output something
$Text.Text.ToString()
# [Terminal.Gui.Application]::QuitKey
