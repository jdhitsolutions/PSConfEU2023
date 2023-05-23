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
$Window = [Window]::New()
$Window.Title = "FileDialog Demo"

$Dialog = [OpenDialog]::new("View PowerShell Script", "")
$Dialog.CanChooseDirectories = $false
$Dialog.CanChooseFiles = $true
$Dialog.AllowsMultipleSelection = $false

$Dialog.DirectoryPath = "C:\scripts"
$Dialog.AllowedFileTypes = @(".ps1")

#need to run the dialog
[Application]::Run($Dialog)
[Application]::Shutdown()

If (-Not $Dialog.Canceled -AND $dialog.FilePath.ToString()) {
    Write-host $dialog.FilePath.ToString()
    Notepad $($dialog.FilePath.ToString())
}

