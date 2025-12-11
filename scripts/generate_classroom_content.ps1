
param(
    [string]$RootPath = "$PSScriptRoot\..",
    [string]$SourceDirName = "modulos",
    [string]$DestDirName = "classroom"
)

$SourcePath = Join-Path $RootPath $SourceDirName
$DestPath = Join-Path $RootPath $DestDirName
$GlobalMediaDestPath = Join-Path $DestPath "media"

# Create destination directory if it doesn't exist
if (-not (Test-Path $DestPath)) {
    New-Item -ItemType Directory -Path $DestPath | Out-Null
}
if (-not (Test-Path $GlobalMediaDestPath)) {
    New-Item -ItemType Directory -Path $GlobalMediaDestPath | Out-Null
}

Write-Host "Iniciando generación de contenido para Classroom..." -ForegroundColor Cyan
Write-Host "Origen: $SourcePath"
Write-Host "Destino: $DestPath"

# Get all module directories
$Modules = Get-ChildItem -Path $SourcePath -Directory | Where-Object { $_.Name -match '^modulo_\d+$' } | Sort-Object Name

foreach ($Module in $Modules) {
    $ModuleName = $Module.Name
    # Format Module Name for folder: "modulo_0" -> "Modulo_0"
    $DestModuleName = $ModuleName -replace "^modulo_", "Modulo_" 
    $ModuleDestPath = Join-Path $DestPath $DestModuleName

    Write-Host "Procesando $ModuleName -> $DestModuleName..." -ForegroundColor Yellow

    if (-not (Test-Path $ModuleDestPath)) {
        New-Item -ItemType Directory -Path $ModuleDestPath | Out-Null
    }

    # Find unique topics based on content files
    $TopicFiles = Get-ChildItem -Path $Module.FullName -Filter "*_contenido.md"
    
    foreach ($File in $TopicFiles) {
        if ($File.Name -match 'tema_(\d+\.\d+)_.*_contenido\.md') {
            $TopicId = $Matches[1]
            $BaseName = $File.Name -replace "_contenido\.md$", ""
            
            Write-Host "  > Generando Tema $TopicId ($BaseName)..." -NoNewline

            # Define source file paths
            $ContentFile = $File.FullName
            $ExercicesFile = $File.FullName -replace "_contenido\.md$", "_ejercicios.md"
            $EvalFile = $File.FullName -replace "_contenido\.md$", "_evaluacion.md"

            # Validating existence
            $HasExercises = Test-Path $ExercicesFile
            $HasEval = Test-Path $EvalFile

            # Prepare content buffer
            $FinalContent = @()

            # --- PROCESS CONTENT ---
            if (Test-Path $ContentFile) {
                # Read content
                $Text = Get-Content -Path $ContentFile -Raw -Encoding UTF8
                # Fix Images
                $Text = $Text -replace '\((.*?/)?media/(.*?)\)', '(--MEDIA-MARKER--$2)'
                $FinalContent += $Text
                $FinalContent += "`n`n---`n`n"
            }

            # --- PROCESS EXERCISES ---
            if ($HasExercises) {
                $FinalContent += "## 📝 Ejercicios Prácticos`n`n"
                $Text = Get-Content -Path $ExercicesFile -Raw -Encoding UTF8
                # Remove main header if redundant (optional, keeping simple for now)
                 # Fix Images
                $Text = $Text -replace '\((.*?/)?media/(.*?)\)', '(--MEDIA-MARKER--$2)'
                $FinalContent += $Text
                $FinalContent += "`n`n---`n`n"
            }

            # --- PROCESS EVALUATION ---
            if ($HasEval) {
                $FinalContent += "## 🧠 Evaluación de Conocimientos`n`n"
                $Text = Get-Content -Path $EvalFile -Raw -Encoding UTF8
                 # Fix Images
                $Text = $Text -replace '\((.*?/)?media/(.*?)\)', '(--MEDIA-MARKER--$2)'
                $FinalContent += $Text
            }

            # --- HANDLE IMAGES AND FINAL REPLACEMENT ---
            # We used a marker (--MEDIA-MARKER--filename.ext) to capture the filename
            # Now we need to process this and replace with correct relative path
            # Assuming original structure was relative to module folder, likely pointing to ../../media or similar
            # We will copy any referenced image from root/media to classroom/media

            # Re-join content to process regex
            $FullText = $FinalContent -join ""
            
            # Find all media markers
            $MatchesList = [regex]::Matches($FullText, '\(--MEDIA-MARKER--(.*?)\)')
            foreach ($Match in $MatchesList) {
                $ImageName = $Match.Groups[1].Value
                $OriginalImagePath = Join-Path $RootPath "media" $ImageName
                
                if (Test-Path $OriginalImagePath) {
                    # Copy to classroom/media
                    $DestImgPath = Join-Path $GlobalMediaDestPath $ImageName
                    if (-not (Test-Path $DestImgPath)) {
                        Copy-Item -Path $OriginalImagePath -Destination $DestImgPath
                    }
                } else {
                    Write-Warning "    [!] Imagen no encontrada: $ImageName"
                }
            }

            # Replace marker with relative path: ../media/filename.ext
            # Path from classroom/Modulo_X/file.md to classroom/media is ../media
            $FullText = $FullText -replace '\(--MEDIA-MARKER--(.*?)\)', '(../media/$1)'

            # Write to destination
            $DestFileName = "Tema_$TopicId.md"
            $DestFilePath = Join-Path $ModuleDestPath $DestFileName
            Set-Content -Path $DestFilePath -Value $FullText -Encoding UTF8

            Write-Host " [OK]" -ForegroundColor Green
        }
    }
}

Write-Host "Generación completada." -ForegroundColor Cyan
