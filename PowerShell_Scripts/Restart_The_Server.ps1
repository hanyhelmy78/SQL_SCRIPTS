# Restart the server
try {
    Write-Output "Restarting the server..."
    Restart-Computer -Force
} catch {
    Write-Error "Failed to restart the server: $_"
    exit 1
}