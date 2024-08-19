param(
    [Parameter()]
    [string]
    $Version,

    [Parameter()]
    [string[]]
    $Platform = @('linux/amd64', 'linux/arm64')
)

if ([string]::IsNullOrWhiteSpace($Version)) {
    dotnet tool restore
    $Version = (dotnet nbgv get-version -f json | ConvertFrom-Json).SimpleVersion
}
$platforms = $Platform -join ','
docker buildx build --progress=plain --platform $platforms -t joshooaj/podeserver:latest -t joshooaj/podeserver:$Version --build-arg version=$Version .