$ErrorActionPreference = "Stop"

$UpstreamRepo = "https://github.com/GuDong2003/xianyu-auto-reply-fix.git"
$TargetDir = Join-Path "vendor" "xianyu-auto-reply-fix"

function New-RandomSecret([int]$Bytes = 32) {
    $buffer = New-Object byte[] $Bytes
    [System.Security.Cryptography.RandomNumberGenerator]::Fill($buffer)
    return [Convert]::ToBase64String($buffer)
}

function Set-EnvValue([string]$Key, [string]$Value) {
    $content = Get-Content ".env" -Raw
    $escapedValue = $Value -replace '\$', '$$'
    if ($content -match "(?m)^$Key=") {
        $content = $content -replace "(?m)^$Key=.*$", "$Key=$escapedValue"
    } else {
        $content = $content.TrimEnd() + "`n$Key=$escapedValue`n"
    }
    Set-Content -Path ".env" -Value $content -NoNewline
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git is required. Please install Git for Windows first."
}

New-Item -ItemType Directory -Force -Path "vendor", "data", "logs", "backups" | Out-Null

if (Test-Path (Join-Path $TargetDir ".git")) {
    Write-Host "Updating upstream project in $TargetDir"
    git -C $TargetDir pull --ff-only
} else {
    Write-Host "Cloning upstream project into $TargetDir"
    if (Test-Path $TargetDir) {
        Remove-Item -Recurse -Force $TargetDir
    }
    git clone --depth 1 $UpstreamRepo $TargetDir
}

if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Set-EnvValue "ADMIN_PASSWORD" (New-RandomSecret 24)
    Set-EnvValue "JWT_SECRET_KEY" ((New-RandomSecret 32) + (New-RandomSecret 32))
    Write-Host "Created .env with a random ADMIN_PASSWORD and JWT_SECRET_KEY."
    Write-Host "Open .env to view or change the admin password before signing in."
}

$EnvFile = Get-Content ".env" -Raw
$Port = if ($EnvFile -match "(?m)^APP_PORT=(.+)$") { $Matches[1].Trim() } else { "9000" }

Write-Host "Done. Next steps:"
Write-Host "  1. review .env"
Write-Host "  2. docker compose up -d --build"
Write-Host "  3. open http://localhost:$Port"
