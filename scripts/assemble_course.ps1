
$coursePath = "$PSScriptRoot\.."
$outputPath = "$coursePath\CURSO_COMPLETO.md"

$titles = @(
    "Preconceptos y Fundamentos Científicos",
    "Biomecánica Aplicada y Evaluación Avanzada",
    "Fisiología del Esfuerzo y Adaptación Muscular",
    "Selección y Optimización de Ejercicios",
    "Diseño de Programas y Periodización Avanzada",
    "Nutrición y Suplementación",
    "Psicología del Coaching",
    "Métodos Avanzados de Entrenamiento",
    "Tecnología y Data Analytics",
    "Recuperación y Readaptación"
)

# Start content
$finalContent = @()
$finalContent += "# CURSO COMPLETO: OPTIMIZACIÓN DE ENTRENAMIENTOS (2025)"
$finalContent += ""
$finalContent += "Generado automáticamente el $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
$finalContent += ""
$finalContent += "---"
$finalContent += ""

# Iterate modules 0 to 9
0..9 | ForEach-Object {
    $modNum = $_
    $modDirName = "modulo_$modNum"
    $modPath = "$coursePath\modulos\$modDirName"
    
    if (Test-Path $modPath) {
        $title = if ($modNum -lt $titles.Count) { $titles[$modNum] } else { "Módulo $modNum" }
        Write-Host "Procesando Módulo $modNum: $title"
        
        $finalContent += "## Módulo $modNum: $title"
        $finalContent += ""
        
        # Get topics - sort by name (usually tema_X.Y_...)
        $topicFiles = Get-ChildItem -Path $modPath -Filter "*_contenido.md" | Sort-Object Name
        
        foreach ($file in $topicFiles) {
            if ($file.Name -match "tema_(\d+\.\d+)_(.+)_contenido.md") {
                $topicNum = $matches[1]
                $topicNameSlug = $matches[2]
                
                # Try to extract real title from file content
                $fileContent = Get-Content $file.FullName -Raw -Encoding UTF8
                $topicTitle = "Tema $topicNum"
                if ($fileContent -match '^#+\s*(.+)') {
                    $topicTitle = $matches[1]
                }
                
                $finalContent += "### $topicTitle"
                $finalContent += ""
                
                # Add Contenido
                $finalContent += "#### 📖 Contenido Teórico"
                $finalContent += ""
                $finalContent += $fileContent
                $finalContent += ""
                $finalContent += "---"
                $finalContent += ""
                
                # Add Ejercicios
                $ejFile = "$modPath\tema_${topicNum}_${topicNameSlug}_ejercicios.md"
                if (Test-Path $ejFile) {
                    $finalContent += "#### 💻 Ejercicios Prácticos"
                    $finalContent += ""
                    $finalContent += Get-Content -Path $ejFile -Raw -Encoding UTF8
                    $finalContent += ""
                    $finalContent += "---"
                    $finalContent += ""
                }
                
                # Add Evaluacion
                $evFile = "$modPath\tema_${topicNum}_${topicNameSlug}_evaluacion.md"
                if (Test-Path $evFile) {
                    $finalContent += "#### 🎯 Evaluación"
                    $finalContent += ""
                    $finalContent += Get-Content -Path $evFile -Raw -Encoding UTF8
                    $finalContent += ""
                    $finalContent += "---"
                    $finalContent += ""
                }
            }
        }
    }
}

$finalContent | Set-Content -Path $outputPath -Encoding UTF8
Write-Host "Curso completo generado en: $outputPath"
