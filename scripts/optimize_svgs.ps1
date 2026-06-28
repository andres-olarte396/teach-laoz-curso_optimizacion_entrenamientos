
param(
    [string]$RootPath = "$PSScriptRoot\..",
    [string]$MediaDirName = "media"
)

$MediaPath = Join-Path $RootPath $MediaDirName

# CSS to inject for fonts
$FontImport = '@import url(''https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap'');'
$FontFamily = "'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif"

# Styles for modernization
$SoftShadowFilter = @"
    <filter id="soft-shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="8" stdDeviation="12" flood-color="#000" flood-opacity="0.15"/>
    </filter>
"@

Write-Host "Iniciando optimización de SVGs..." -ForegroundColor Cyan
Write-Host "Directorio: $MediaPath"

$SvgFiles = Get-ChildItem -Path $MediaPath -Filter "*.svg"

foreach ($File in $SvgFiles) {
    Write-Host "Procesando $($File.Name)..." -NoNewline
    
    $Content = Get-Content -Path $File.FullName -Raw -Encoding UTF8

    # 1. Inject Font Import if not present
    if ($Content -notmatch "fonts.googleapis.com") {
        # Try to insert after <defs> or just after <svg> if no defs
        if ($Content -match "<defs>") {
            $Content = $Content -replace "<defs>", "<defs><style>$FontImport</style>"
        }
        else {
            $Content = $Content -replace "(<svg[^>]*>)", "$1<defs><style>$FontImport</style></defs>"
        }
    }

    # 2. Replace Fonts
    # Regex to find font-family="..." and replace content
    $Content = $Content -replace 'font-family="[^"]+"', "font-family=""$FontFamily"""
    # Also Check CSS styles (font-family: ...)
    $Content = $Content -replace 'font-family:[^;"]+', "font-family: $FontFamily"

    # 3. Soften Shadows
    # If file has existing shadow filter, replace it or update it?
    # Simple approach: Replace 'stdDeviation="4"' (common in existing) with larger value if found
    $Content = $Content -replace 'stdDeviation="4"', 'stdDeviation="8"'
    # Reduce opacity if found close to common pattern
    $Content = $Content -replace 'flood-opacity="0.3"', 'flood-opacity="0.15"'    
    $Content = $Content -replace 'flood-opacity="0.25"', 'flood-opacity="0.15"'

    # 4. Add Metadata comment
    if ($Content -notmatch "<!-- Optimized by Teach-Laoz Script -->") {
        $Content = $Content -replace "</svg>", "<!-- Optimized by Teach-Laoz Script -->`n</svg>"
    }

    Set-Content -Path $File.FullName -Value $Content -Encoding UTF8
    Write-Host " [OK]" -ForegroundColor Green
}

Write-Host "Optimización completada." -ForegroundColor Cyan
