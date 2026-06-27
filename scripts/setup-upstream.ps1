$ErrorActionPreference = "Stop"

$UpstreamRepo = "https://github.com/GuDong2003/xianyu-auto-reply-fix.git"
$TargetDir = Join-Path "vendor" "xianyu-auto-reply-fix"

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
    Write-Host "Created .env from .env.example. Edit ADMIN_PASSWORD and JWT_SECRET_KEY before starting."
}

$EnvFile = Get-Content ".env" -Raw
$Port = if ($EnvFile -match "(?m)^APP_PORT=(.+)$") { $Matches[1].Trim() } else { "9000" }

Write-Host "Done. Next steps:"
Write-Host "  1. edit .env"
Write-Host "  2. docker compose up -d --build"
Write-Host "  3. open http://localhost:$Port"
