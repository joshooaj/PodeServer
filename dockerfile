FROM mcr.microsoft.com/powershell:7.4-alpine-3.17
ARG version=0.1

LABEL description="Run a web service using PowerShell and the Pode module by Matthew Kelly (Badgerati)."
LABEL maintainer="Joshua Hendricks (joshooaj)"
LABEL vendor="joshooaj"
LABEL license="MIT"
LABEL org.opencontainers.image.source="https://github.com/joshooaj/PodeServer"
LABEL org.opencontainers.image.documentation="https://github.com/joshooaj/PodeServer"
LABEL version="${version}"

WORKDIR /app

SHELL [ "pwsh", "-NoLogo", "-NoProfile", "-Command" ]
RUN Install-Module pode -Scope AllUsers -Force; apk upgrade --no-cache --force-refresh
ENTRYPOINT [ "pwsh", "-c", "pode" ]
CMD [ "start" ]
VOLUME [ "/app" ]
EXPOSE 80
