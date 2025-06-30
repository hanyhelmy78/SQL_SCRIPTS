# Ensure the script runs with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to run this script as an administrator."
    exit
}

# Function to install updates
Function Install-Updates {
    Write-Host "Checking for updates in the Software Center..." -ForegroundColor Green

    # Load Configuration Manager WMI namespace
    $namespace = "ROOT\CCM\ClientSDK"
    $updatesClass = "CCM_SoftwareUpdate"

    try {
        $updates = Get-WmiObject -Namespace $namespace -Class $updatesClass
    } catch {
        Write-Error "Failed to access Configuration Manager. Ensure Software Center is installed and configured."
        return
    }

    if ($updates.Count -eq 0) {
        Write-Host "No updates found in the Software Center." -ForegroundColor Yellow
        return
    }

    Write-Host "Updates found: $($updates.Count). Initiating installation..." -ForegroundColor Cyan

    foreach ($update in $updates) {
        Write-Host "Installing update: $($update.Description)" -ForegroundColor Blue
        try {
            $update.Install()
            Write-Host "Successfully installed: $($update.Description)" -ForegroundColor Green
        } catch {
            Write-Error "Failed to install update: $($update.Description)"
        }
    }

    Write-Host "All updates processed." -ForegroundColor Green
}