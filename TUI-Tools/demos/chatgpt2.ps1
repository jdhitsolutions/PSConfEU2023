<#
User
Display the output in a grid in the form.

To display the output in a grid, you can use a ListView control instead of a TextView control. Here's an updated version of the PowerShell script that uses a ListView to display the service name, display name, start mode, and state in columns:
#>

Add-Type -AssemblyName Terminal.Gui

# Define a function to query services and update the list view
function Query-Services {
    $computerName = $txtComputer.Text

    # Query services using Get-CimInstance
    $services = Get-CimInstance -ComputerName $computerName -ClassName Win32_Service

    # Clear the list view and add column headers
    $listView.Items.Clear()
    $listView.Columns.Clear()
    $listView.Columns.Add('Service Name', 20)
    $listView.Columns.Add('Display Name', 30)
    $listView.Columns.Add('Start Mode', 15)
    $listView.Columns.Add('State', 15)

    # Loop through the services and add each one to the list view
    foreach ($service in $services) {
        $listViewItem = New-Object Terminal.Gui.ListViewItem($service.Name, $service.DisplayName, $service.StartMode, $service.State)
        $listView.Items.Add($listViewItem)
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

# Add a list view to display the results
$listView = New-Object Terminal.Gui.ListView -Property @{
    X = 1
    Y = 5
    Width = [Windows.SystemMetrics]::ScreenWidth - 2
    Height = [Windows.SystemMetrics]::ScreenHeight - 7
    AllowsMarking = $false
    AllowsColumnReordering = $false
    AllowsColumnResizing = $false
    AllowsColumnSorting = $false
}
$window.Add($listView)

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
