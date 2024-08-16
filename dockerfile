FROM mcr.microsoft.com/powershell:latest
ARG version=0.1

LABEL description="Run a web service using PowerShell and the Pode module by Matthew Kelly (Badgerati)."
LABEL maintainer="Joshua Hendricks (joshooaj)"
LABEL vendor="joshooaj"
LABEL license="MIT"
LABEL org.opencontainers.image.source="https://github.com/joshooaj/PodeServer"
LABEL org.opencontainers.image.documentation="https://github.com/joshooaj/PodeServer"
LABEL version="${version}"

WORKDIR /app

RUN \
    apt-get update && apt-get upgrade -y && \
    apt-get autoclean && \
    apt-get autoremove && \
    pwsh -c Install-Module pode -Scope AllUsers -Force

ENTRYPOINT [ "pwsh", "-c", "pode" ]
CMD [ "start" ]
VOLUME [ "/app" ]
EXPOSE 80
