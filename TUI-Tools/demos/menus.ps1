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

$version = "0.2.0"
[Application]::Init()

# Create the window to use
$Window = [Window]::New()
$Window.Title = 'Insert Title Here'

#this is the menu item
$MenuItem = [MenuItem]::new('_Close', '', { [Application]::RequestStop() })
#this is what will be on the menu bar
$MenuBarItem = [MenuBarItem]::new('_Quit', @($MenuItem))

$about = @"
PSConfEU2023
v$version
PSVersion $($PSVersionTable.PSVersion)
"@
$MenuItem2 = [MenuItem]::New("A_bout", "", { [Terminal.Gui.MessageBox]::Query("About",$About) })
$MenuItem3 = [MenuItem]::new('_Documentation', '', { Start-Process 'https://gui-cs.github.io/Terminal.Gui/api/Terminal.Gui/Terminal.Gui.html' })
$MenuBarItem2 = [MenuBarItem]::New("_Help", @($MenuItem2,$MenuItem3))

#define the main menu bar
$MenuBar = [Terminal.Gui.MenuBar]::new(@($MenuBarItem,$MenuBarItem2))
$Window.Add($MenuBar)

$Text = [Terminal.Gui.TextField] @{
    X     = [Terminal.Gui.Pos]::Center()
    Y     = [Terminal.Gui.Pos]::Center()
    Width = 30
    Text  = 'You can enter text here'
}
$window.Add($Text)

$MsgButton = [Terminal.Gui.Button] @{
    X    = [Terminal.Gui.Pos]::At(88)
    Y    = [Terminal.Gui.Pos]::At(28)
    Text = '_Message'
}

$MsgButton.add_Clicked({
        #display the text as a message box with an OK button
        $r = [Terminal.Gui.MessageBox]::Query('Look at me!', 'What do you want to do?', 0, @('Yes', 'No', 'Cancel'))
        $Text.text = "Your response is $r"
    })
$window.Add($MsgButton)

[Application]::Top.Add($Window)
[Application]::Run()
[Application]::Shutdown()