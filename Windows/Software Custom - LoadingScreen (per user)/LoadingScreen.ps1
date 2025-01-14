﻿<#
Version: 2
Author: 
- Brandon Miller-Mumford
Script: LoadingScreen.ps1
Description: Updated to use registry key for installation detection
Run as: User
Context: 64 Bit
#>

Add-Type -AssemblyName PresentationFramework

# Define the XAML for the window
$xaml = @"
<Window xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation'
        xmlns:x='http://schemas.microsoft.com/winfx/2006/xaml'
        WindowState='Maximized'
        WindowStyle='None'
        ResizeMode='NoResize'
        Topmost='True'
        Background='#0078D7'>
    <Window.Effect>
        <DropShadowEffect Color='Black' BlurRadius='20' ShadowDepth='0' Opacity='0.5'/>
    </Window.Effect>
    <Grid>
        <TextBlock Text='It's your first time logging-in. Just a moment while device is being configured...'
                   Foreground='White'
                   FontSize='48'
                   FontFamily='Segoe UI'
                   HorizontalAlignment='Center'
                   VerticalAlignment='Center'
                   Margin='0,0,0,150'/>
        <TextBlock Text='This process may take 1.5 hours and will reboot upon completion.'
                   Foreground='White'
                   Opacity='0.7'
                   FontSize='24'
                   FontFamily='Segoe UI'
                   HorizontalAlignment='Center'
                   VerticalAlignment='Bottom'
                   Margin='0,0,0,50'/>
    </Grid>
</Window>
"@

# Load the XAML
[xml]$xamlWindow = $xaml
$reader = (New-Object System.Xml.XmlNodeReader $xamlWindow)
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Define the KeyDown event handler function
function Window_KeyDown {
    param ($sender, $e)
    if ($e.Key -eq [System.Windows.Input.Key]::M -and
        [System.Windows.Input.Keyboard]::Modifiers -eq ([System.Windows.Input.ModifierKeys]::Control -bor [System.Windows.Input.ModifierKeys]::Shift)) {
        $sender.Close()
    }
}

# Attach the KeyDown event handler to the Window
$Window.add_KeyDown({
    param ($sender, $e)
    Window_KeyDown -sender $sender -e $e
})

# Schedule a restart after 1 hour and 30 minutes
$script = {
    # Define the registry key and value
    $regPath = "HKCU:\Software\IntuneDependencies"
    $regName = "DeviceConfigurationComplete"

    # Check if registry path exists and create if not
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }

    # Create the registry value
    Set-ItemProperty -Path $regPath -Name $regName -Value $true -Force

    # Wait for 1 hour and 30 minutes (5400 seconds)
    Start-Sleep -Seconds 5400

    # Restart the computer
    Restart-Computer -Force
}

# Start the scheduled script block as a job
Start-Job -ScriptBlock $script

# Show the window
$Window.ShowDialog()