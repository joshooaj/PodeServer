param(
    # Specifies the IP interface to listen on. The default is to listen on all interfaces.
    [Parameter()]
    [string]
    $Address = '0.0.0.0',

    # Specifies the TCP port to listen on. Default value is port 80.
    [Parameter()]
    [ValidateRange(0, 65535)]
    [int]
    $Port = 80
)

Start-PodeServer -Threads 2 {
    Add-PodeEndpoint -Address $Address -Port $Port -Protocol Http
    Set-PodeViewEngine -Type Pode

    # Log requests to the terminal/stdout
    New-PodeLoggingMethod -Terminal -Batch 10 -BatchTimeout 10 | Enable-PodeRequestLogging
    New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging

    Add-PodeRoute -Method Get -Path '/' -ScriptBlock {
        Write-PodeJsonResponse -Value ([pscustomobject]@{
            Success  = 'Replace ./app/server.ps1 with your own pode application by mounting a volume to /app or building your own container image from joshooaj/podeserver.'
            PodeRepo = 'https://github.com/Badgerati/Pode'
        })
    }
}
