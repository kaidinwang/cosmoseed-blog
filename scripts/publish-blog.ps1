<#
.SYNOPSIS
  Publish a markdown article to the cosmoseed-blog repo and trigger Netlify deploy.

.DESCRIPTION
  Copies a .md file into src/content/blog/, runs a local build to validate the
  frontmatter schema, then commits + pushes to GitHub. Netlify auto-deploys on push.

.PARAMETER File
  Path to the markdown article to publish. Required.

.PARAMETER Message
  Optional commit message. Defaults to "publish: <slug>".

.PARAMETER SkipBuild
  Skip the local build verification (faster, but no schema check).

.EXAMPLE
  .\scripts\publish-blog.ps1 -File "C:\drafts\2026-05-20-my-article.md"

.EXAMPLE
  .\scripts\publish-blog.ps1 -File ".\drafts\post.md" -Message "publish: AEO 第二篇"
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$File,

  [string]$Message,

  [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'

# Resolve repo root (parent of scripts/)
$repoRoot = Split-Path -Parent $PSScriptRoot
$contentDir = Join-Path $repoRoot 'src\content\blog'

if (-not (Test-Path $File)) {
  Write-Error "File not found: $File"
  exit 1
}

$fileName = Split-Path -Leaf $File
$slug = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
$dest = Join-Path $contentDir $fileName

if (-not $Message) {
  $Message = "publish: $slug"
}

Write-Host "→ Copying $fileName to src/content/blog/" -ForegroundColor Cyan
Copy-Item -Path $File -Destination $dest -Force

if (-not $SkipBuild) {
  Write-Host "→ Validating with astro build" -ForegroundColor Cyan
  Push-Location $repoRoot
  try {
    npm run build
    if ($LASTEXITCODE -ne 0) {
      Write-Error "Build failed. Frontmatter may be invalid. File staged at: $dest"
      exit 1
    }
  } finally {
    Pop-Location
  }
}

Push-Location $repoRoot
try {
  Write-Host "→ git add + commit + push" -ForegroundColor Cyan
  git add "src/content/blog/$fileName"
  git commit -m $Message
  git push

  if ($LASTEXITCODE -ne 0) {
    Write-Error "git push failed."
    exit 1
  }

  Write-Host ""
  Write-Host "✓ Published. Netlify will auto-deploy in ~30s." -ForegroundColor Green
  Write-Host "  Live URL (after deploy): https://cosmoseed.com.tw/blog/$slug" -ForegroundColor Green
} finally {
  Pop-Location
}
