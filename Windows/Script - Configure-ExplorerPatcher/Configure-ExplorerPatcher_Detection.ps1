<#
Version: 1.0
Author: 
- Brandon Miller-Mumford
Script: Configure-ExplorerPatcher_Detection.ps1
Description: 
Version 1.0: Init
Run as: User
Context: 64 Bit
#> 

# Output: (single line)
#  For each key: {Name of the key} + {Error Values} (max 37 characters)
#   e.g: YourFirstKeyName ErrorCode = Path, Name, Type, Value | YourSecondKeyName ErrorCode = Path, Name

#region Define registry keys to validate here
$RegistrySettingsToValidate = @(
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'ImportOK'
        Type  = 'REG_DWORD'
        Value = 1
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'OldTaskbar'
        Type  = 'REG_DWORD'
        Value = 1
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'Virtualized_{D17F1E1A-5919-4427-8F89-A1A8503CA3EB}_TaskbarPosition'
        Type  = 'REG_DWORD'
        Value = 3
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'IVirtualized_{D17F1E1A-5919-4427-8F89-A1A8503CA3EB}_MMTaskbarPosition'
        Type  = 'REG_DWORD'
        Value = 3
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Search'
        Name  = 'SearchboxTaskbarMode'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        Name  = 'ShowTaskViewButton'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'Virtualized_{D17F1E1A-5919-4427-8F89-A1A8503CA3EB}_AutoHideTaskbar'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'OrbStyle'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'OldTaskbarAl'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'MMOldTaskbarAl'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'TaskbarGlomLevel'
        Type  = 'REG_DWORD'
        Value = 2
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'MMTaskbarGlomLevel'
        Type  = 'REG_DWORD'
        Value = 2
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        Name  = 'TaskbarSmallIcons'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'SkinMenus'
        Type  = 'REG_DWORD'
        Value = 1
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'CenterMenus'
        Type  = 'REG_DWORD'
        Value = 1
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'FlyoutMenus'
        Type  = 'REG_DWORD'
        Value = 1
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\TabletTip\1.7'
        Name  = 'TipbandDesiredVisibility'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        Name  = 'ShowSecondsInSystemClock'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'HideControlCenterButton'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        Name  = 'TaskbarSD'
        Type  = 'REG_DWORD'
        Value = 1
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network'
        Name  = 'ReplaceNetwork'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network'
        Name  = 'ReplaceVan'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows NT\CurrentVersion\MTCUVC'
        Name  = 'EnableMtcUvc'
        Type  = 'REG_DWORD'
        Value = 1
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'SSoftware\Microsoft\Windows\CurrentVersion\ImmersiveShell'
        Name  = 'UseWin32TrayClockExperience'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\ImmersiveShell'
        Name  = 'AUseWin32BatteryFlyout'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'IMEStyle'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'Virtualized_{D17F1E1A-5919-4427-8F89-A1A8503CA3EB}_RegisterAsShellExtension'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'LegacyFileTransferDialog'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'UseClassicDriveGrouping'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'Virtualized_{D17F1E1A-5919-4427-8F89-A1A8503CA3EB}_FileExplorerCommandUI'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'DisableImmersiveContextMenu'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'Virtualized_{D17F1E1A-5919-4427-8F89-A1A8503CA3EB}_DisableModernSearchBar'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'SSoftware\ExplorerPatcher'
        Name  = 'ShrinkExplorerAddressBar'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'HideExplorerSearchBar'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'MicaEffectOnTitlebar'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'SSoftware\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        Name  = 'Start_ShowClassicMode'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        Name  = 'TaskbarAl'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'Virtualized_{D17F1E1A-5919-4427-8F89-A1A8503CA3EB}_Start_MaximumFrequentApps'
        Type  = 'REG_DWORD'
        Value = 6
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage'
        Name  = 'MonitorOverride'
        Type  = 'REG_DWORD'
        Value = 1
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'Virtualized_{D17F1E1A-5919-4427-8F89-A1A8503CA3EB}_StartDocked_DisableRecommendedSection'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage'
        Name  = 'MakeAllAppsDefault'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Explorer'
        Name  = 'AltTabSettings'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'Virtualized_{D17F1E1A-5919-4427-8F89-A1A8503CA3EB}_PeopleBand'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'LastSectionInProperties'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'ClockFlyoutOnWinC'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'ToolbarSeparators'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'PropertiesInWinX'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'NoMenuAccelerator'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'DisableOfficeHotkeys'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'DisableWinFHotkey'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'Virtualized_{D17F1E1A-5919-4427-8F89-A1A8503CA3EB}_DisableRoundedCorners'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'DisableAeroSnapQuadrants'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        Name  = 'Start_PowerButtonAction'
        Type  = 'REG_DWORD'
        Value = 2
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'DoNotRedirectSystemToSettingsApp'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'SOFTWARE\Contoso\Product'
        Name  = 'AnotherKey'
        Type  = 'REG_DWORD'
        Value = "SomeValue"
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'DoNotRedirectProgramsAndFeaturesToSettingsApp'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'DoNotRedirectDateAndTimeToSettingsApp'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'AnotherKey'
        Type  = 'REG_DWORD'
        Value = "SomeValue"
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'DoNotRedirectNotificationIconsToSettingsApp'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'UpdatePolicy'
        Type  = 'REG_DWORD'
        Value = 1
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'UpdatePreferStaging'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'UpdateAllowDowngrades'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'UpdateUseLocal'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'AllocConsole'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'Memcheck'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'TaskbarAutohideOnDoubleClick'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Control Panel\Desktop'
        Name  = 'PaintDesktopVersion'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'ClassicThemeMitigations'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'NoPropertiesInContextMenu'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'EnableSymbolDownload'
        Type  = 'REG_DWORD'
        Value = 1
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'PinnedItemsActAsQuickLaunch'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'RemoveExtraGapAroundPinnedItems'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ExplorerPatcher'
        Name  = 'AXamlSounds'
        Type  = 'REG_DWORD'
        Value = 0
    },
    [pscustomobject]@{
        Hive  = 'HKCU:\'
        Key   = 'Software\ExplorerPatcher'
        Name  = 'Language'
        Type  = 'REG_DWORD'
        Value = 0
    }
)
#endregion

#region helper functions, enums and maps
$RegTypeMap = @{
    REG_DWORD     = [Microsoft.Win32.RegistryValueKind]::DWord
    REG_SZ        = [Microsoft.Win32.RegistryValueKind]::String
    REG_QWORD     = [Microsoft.Win32.RegistryValueKind]::QWord
    REG_BINARY    = [Microsoft.Win32.RegistryValueKind]::Binary
    REG_MULTI_SZ  = [Microsoft.Win32.RegistryValueKind]::MultiString
    REG_EXPAND_SZ = [Microsoft.Win32.RegistryValueKind]::ExpandString
}
[Flags()] enum RegKeyError {
    None  = 0
    Path  = 1
    Name  = 2
    Type  = 4
    Value = 8
}
#endregion

#region Check if registry keys are set correctly
$KeyErrors = @()
$Output = ""
Foreach ($reg in $RegistrySettingsToValidate) {
    [RegKeyError]$CurrentKeyError = 15

    $DesiredPath          = "$($reg.Hive)$($reg.Key)"
    $DesiredName          = $reg.Name
    $DesiredType          = $RegTypeMap[$reg.Type]
    $DesiredValue         = $reg.Value

    # Check if the registry key path exists
    If (Test-Path -Path $DesiredPath) {
        $CurrentKeyError -= [RegKeyError]::Path

        # Check if the registry value exists
        If (Get-ItemProperty -Path $DesiredPath -Name $DesiredName -ErrorAction SilentlyContinue) {
            $CurrentKeyError -= [RegKeyError]::Name

            # Check if the registry value type is correct
            If ($(Get-Item -Path $DesiredPath).GetValueKind($DesiredName) -eq $DesiredType) {
                $CurrentKeyError -= [RegKeyError]::Type
                
                # Check if the registry value is correct
                If ($((Get-ItemProperty -Path $DesiredPath -Name $DesiredName).$DesiredName) -eq $DesiredValue) {
                    $CurrentKeyError -= [RegKeyError]::Value
                    # Write-Host "[$DesiredPath | $DesiredName | $RetTypeRegistry | $DesiredValue] exists and is correct"
                } 
            }
        }
    }
    $KeyErrors += $CurrentKeyError
    $Output += " | $DesiredName ErrorCode = $CurrentKeyError"
}
#endregion

#region Check if all registry keys are correct
if (($KeyErrors.value__ | Measure-Object -Sum).Sum -eq 0) {
    $ExitCode = 0
}
else {
    $ExitCode = 1
}
#endregion

Write-Output $Output.TrimStart(" |")
Exit $ExitCode