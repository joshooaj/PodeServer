FROM --platform=$BUILDPLATFORM mcr.microsoft.com/powershell:7.4-debian-bookworm AS download
RUN pwsh -c Install-Module Pode -RequiredVersion 2.10.1 -Scope AllUsers -Force

FROM ubuntu:noble

ARG version=0.1
ARG TARGETPLATFORM
ARG BUILDPLATFORM

LABEL description="Run a web service using PowerShell and the Pode module by Matthew Kelly (Badgerati)."
LABEL maintainer="Joshua Hendricks (joshooaj)"
LABEL vendor="joshooaj"
LABEL license="MIT"
LABEL org.opencontainers.image.source="https://github.com/joshooaj/PodeServer"
LABEL org.opencontainers.image.documentation="https://github.com/joshooaj/PodeServer"
LABEL version="${version}"

WORKDIR /app
COPY app/ .
COPY --from=download /usr/local/share/powershell/Modules/Pode/ /usr/local/share/powershell/Modules/Pode
RUN \
    apt-get update && \
    apt-get install -y curl wget apt-transport-https software-properties-common  && \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then PWSH_URL="https://github.com/PowerShell/PowerShell/releases/download/v7.4.4/powershell-7.4.4-linux-x64.tar.gz"; else PWSH_URL="https://github.com/PowerShell/PowerShell/releases/download/v7.4.4/powershell-7.4.4-linux-arm64.tar.gz"; fi && \
    curl -L -o /tmp/powershell.tar.gz "$PWSH_URL" && \
    mkdir -p /opt/microsoft/powershell/7 && \
    tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 && \
    rm /tmp/powershell.tar.gz && \
    chmod +x /opt/microsoft/powershell/7/pwsh && \
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
ENTRYPOINT [ "pwsh", "-c", "pode" ]
CMD [ "start" ]
VOLUME [ "/app" ]
EXPOSE 80
