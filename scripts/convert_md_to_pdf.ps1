# Requires: Pandoc installed and in PATH
# Usage: pwsh ./scripts/convert_md_to_pdf.ps1

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$pdfOut = Join-Path $root "pdf"
$css = Join-Path $root "resources/pandoc.css"

# Markdown sources in módulo 0
$mdFiles = @(
    "modulos/modulo_0/informe_sintesis_entrenamiento_evidencia.md",
    "modulos/modulo_0/articulo_brujula_fitness.md",
    "modulos/modulo_0/infografia_brujula_cientifica.md",
    "modulos/modulo_0/referencias_ia_mercado_laboral.md",
    "modulos/modulo_0/recursos_multimedia.md",
    "modulos/modulo_0/tema_0.1_metodo_cientifico_contenido.md",
    "modulos/modulo_0/tema_0.1_metodo_cientifico_ejercicios.md",
    "modulos/modulo_0/tema_0.1_metodo_cientifico_evaluacion.md",
    "modulos/modulo_0/tema_0.2_estadistica_basica_contenido.md",
    "modulos/modulo_0/tema_0.2_estadistica_basica_ejercicios.md",
    "modulos/modulo_0/tema_0.2_estadistica_basica_evaluacion.md",
    "modulos/modulo_0/tema_0.3_mitos_evidencia_contenido.md",
    "modulos/modulo_0/tema_0.3_mitos_evidencia_ejercicios.md",
    "modulos/modulo_0/tema_0.3_mitos_evidencia_evaluacion.md"
)

# Ensure output directory exists
if (!(Test-Path $pdfOut)) { New-Item -ItemType Directory -Path $pdfOut | Out-Null }

function Convert-MdToPdf($mdRelPath) {
    $mdPath = Join-Path $root $mdRelPath
    if (!(Test-Path $mdPath)) { Write-Warning "No existe: $mdRelPath"; return }

    $name = [System.IO.Path]::GetFileNameWithoutExtension($mdPath)
    $pdfPath = Join-Path $pdfOut ($name + ".pdf")

    Write-Host "Convirtiendo $mdRelPath -> pdf/$name.pdf"

    pandoc `
        --from=gfm `
        --to=pdf `
        --pdf-engine=wkhtmltopdf `
        --metadata title="$name" `
        --embed-resources `
        --resource-path "$root;$root/media" `
        --standalone `
        --table-of-contents `
        --toc-depth=3 `
        --css "$css" `
        -o "$pdfPath" `
        "$mdPath"
}

# Check dependencies
$pandoc = Get-Command pandoc -ErrorAction SilentlyContinue
if (-not $pandoc) { throw "Pandoc no está instalado o no está en PATH. Instala desde https://pandoc.org/installing.html" }
$wkhtml = Get-Command wkhtmltopdf -ErrorAction SilentlyContinue
if (-not $wkhtml) { Write-Warning "wkhtmltopdf no está instalado. Pandoc intentará usar otro motor PDF (puede variar el estilo)." }

foreach ($f in $mdFiles) { Convert-MdToPdf $f }

Write-Host "Listo. PDFs en: $pdfOut"