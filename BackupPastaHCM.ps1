Clear-Host

$pasta = Read-Host "Qual o nome da pasta? Ex. BASEI_13320_p"

$source = "D:\$pasta"
$destination = "D:\SeniorTI\Backup\$pasta"
$logFile = "D:\SeniorTI\Backup\Log_Copia_Pasta_$pasta.txt"

# Inicia a transcrição para o arquivo de log
Start-Transcript -Path $logFile -Append

# Cria a pasta de destino
New-Item -ItemType Directory -Path $destination

# Copia os arquivos e pastas, exceto .xml e .log
Get-ChildItem -Path $source -Recurse -File | 
    Where-Object { $_.Extension -notin ".xml", ".log" } | 
    ForEach-Object {
        $destPath = $_.FullName.Replace($source, $destination)
        $destDir = [System.IO.Path]::GetDirectoryName($destPath)
        if (-not (Test-Path -Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir
        }
        Copy-Item -Path $_.FullName -Destination $destPath
    }

# Copia as pastas vazias
Get-ChildItem -Path $source -Recurse -Directory | 
    ForEach-Object {
        $destPath = $_.FullName.Replace($source, $destination)
        if (-not (Test-Path -Path $destPath)) {
            New-Item -ItemType Directory -Path $destPath
        }
    }

# Encerra a transcrição
Stop-Transcript

powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Backup da pasta realizado com sucesso!!','CONCLUÍDO')}"
