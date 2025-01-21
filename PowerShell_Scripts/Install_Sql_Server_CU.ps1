# Define the cumulative update installer path and arguments
$CUInstallerPath = "C:\PathToSQLServerCU.exe" # Replace with the actual path to the CU installer
$LogFile = "C:\PathToInstallationLog.txt"    # Replace with the desired log file path
$CUInstallerArguments = "/quiet /norestart /IAcceptSQLServerLicenseTerms=true"

# Function to check for admin privileges
function Test-AdminRights {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check if running as administrator
if (-not (Test-AdminRights)) {
    Write-Error "This script requires administrative privileges. Please run as Administrator."
    exit 1
}

# Run the cumulative update installer
try {
    Write-Output "Starting SQL Server CU installation..."
    Start-Process -FilePath $CUInstallerPath -ArgumentList $CUInstallerArguments -Wait -NoNewWindow -PassThru

    # Check the exit code of the installer
    if ($LASTEXITCODE -eq 0) {
        Write-Output "SQL Server CU installation completed successfully."
    } else {
        Write-Error "SQL Server CU installation failed with exit code $LASTEXITCODE. Check the log file: $LogFile"
        exit 1
    }
} catch {
    Write-Error "An error occurred during the installation: $_"
    exit 1
}