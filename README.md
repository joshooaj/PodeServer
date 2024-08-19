# PodeServer

The Pode module is a great way for a PowerShell enthusiast to rapidly create a simple web application or API using nothing but PowerShell. This image allows you to run your Pode application in a container on `amd64` and `arm64` by overwriting the `/app` directory with your application.

## Getting started

A placeholder Pode service is embedded in the container image in the `/app` directory. To run the image...

```powershell
docker run -p 8000:80 joshooaj/podeserver:latest
```

This will start the PodeServer container listening on TCP port 80 for HTTP connections, and forward TCP port 8000 from your host machine into the container. You can verify that Pode is serving requests by accessing `http://localhost:8000/` from the same machine, or by running `irm http://localhost:8000/` to retrieve the following JSON response:

```json
{
    "Success": "Replace ./app/server.ps1 with your own pode application by mounting a volume to /app or building your own container image from joshooaj/podeserver.",
    "PodeRepo": "https://github.com/Badgerati/Pode"
}
```

## Use your own application

The `entrypoint` for this image is the command `pode start` and it runs in the default working directory `/app`. The `pode` command looks for `package.json` and runs the command found in that file under `scripts` and `start`.

To supply your own application, you can mount your own `package.json` and your Pode service file(s) to `/app`. For reference, the default contents of `/app` include the following `package.json` and `server.ps1` files...

### package.json

```json
{
    "name": "podeserver",
    "version": "0.0.0",
    "main": "./server.ps1",
    "scripts": {
        "start": "./server.ps1",
        "install": "",
        "test": "",
        "build": ""
    },
    "dependencies": {
    },
    "modules": {},
    "devModules": {
        "pester": "latest"
    },
    "author": "Joshua Hendricks (joshooaj)",
    "license": "MIT"
}
```

### server.ps1

```powershell title="server.ps1"
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
```

## Docker Compose

Create a `compose.yml` or `docker-compose.yml` file similar to the one below, and then run `docker compose up -d` in the
same directory to start the application. You can check `stdout` for log messages and errors from Pode using `docker compose logs -f`.

```yaml
services:
  server:
    image: joshooaj/podeserver:${PODE_VERSION:-latest}
    restart: unless-stopped
    volumes:
      - ./app:/app
    ports:
      - 8000:80
```

## Configuration Options

There are none at the moment.

### HTTPS

Put this container behind your own reverse proxy like Traefik or nginx, or refer to Pode's [Certificates doc](https://badgerati.github.io/Pode/Tutorials/Certificates/).

### Alternate HTTP port

You can use whichever port(s) you want with Pode. Port 80 is the canonical port for the HTTP protocol and the typical method of accessing a container on a different port is to bind the port of your choice on the host side and forward that port to the container on port 80 such as in the examples here. However, if you prefer to configure Pode to listen on a different port, you will do so in your own `server.ps1`, and update your port binding accordingly in your compose file, or in your `docker run` command.

## Documentation

Matthew Kelly (Badgerati) has excellent documentation, examples, and tutorials for Pode at [https://badgerati.github.io/Pode/](https://badgerati.github.io/Pode/) and there's also a 1st-party container image at [https://hub.docker.com/r/badgerati/pode](https://hub.docker.com/r/badgerati/pode).
