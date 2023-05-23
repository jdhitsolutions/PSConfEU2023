<#
Create a PowerShell script using Terminal.Gui that has a text box
to input a computer name. The form should have a button with an action
that will use Get-CimInstance to query services. The form will then
display the service name, displayname, startmode, and state.
The form should be closed using Ctrl+q
#>

Add-Type -AssemblyName Terminal.Gui

# Define a function to query services and update the text view
function Query-Services {
    $computerName = $txtComputer.Text

    # Query services using Get-CimInstance
    $services = Get-CimInstance -ComputerName $computerName -ClassName Win32_Service

    # Clear the text view and add column headers
    $txtOutput.Text = "Service Name`tDisplay Name`tStart Mode`tState`n"

    # Loop through the services and add each one to the text view
    foreach ($service in $services) {
        $txtOutput.Text += "$($service.Name)`t$($service.DisplayName)`t$($service.StartMode)`t$($service.State)`n"
    }
}

# Define the form
$window = New-Object Terminal.Gui.Window -Property @{
    Title = 'Query Services'
}

# Add a label and text box for the computer name
$lblComputer = New-Object Terminal.Gui.Label -Property @{
    X = 1
    Y = 1
    Text = 'Computer Name:'
}
$window.Add($lblComputer)

$txtComputer = New-Object Terminal.Gui.TextField -Property @{
    X = [Windows.SystemMetrics]::CaptionWidth + 1
    Y = 1
    Width = 30
}
$window.Add($txtComputer)

# Add a button to query services
$btnQuery = New-Object Terminal.Gui.Button -Property @{
    X = 1
    Y = 3
    Text = 'Query Services'
}
$btnQuery.Add_Click({ Query-Services })
$window.Add($btnQuery)

# Add a text view to display the results
$txtOutput = New-Object Terminal.Gui.TextView -Property @{
    X = 1
    Y = 5
    Width = [Windows.SystemMetrics]::ScreenWidth - 2
    Height = [Windows.SystemMetrics]::ScreenHeight - 7
}
$window.Add($txtOutput)

# Show the form
$window | Out-Null
$window.SetFocus()
[Terminal.Gui.Application]::Run($window)

# Close the form when Ctrl+q is pressed
$window.KeyPress.Add({
    param($event)

    if (($event.Modifiers -band [Terminal.Gui.Keys]::Control) -and ($event.KeyEvent.Key -eq [Terminal.Gui.Keys]::Q)) {
        $window.Close()
    }
})
