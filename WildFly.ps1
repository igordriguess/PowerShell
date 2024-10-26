Clear-Host

Write-Host "Script para download dos aplicativos de pré-requisitos Statum" -ForegroundColor Cyan

Write-Host 'Informe a letra da unidade de disco para salvar os arquivos, Exemplo "C"'
$disco = Read-Host

$unidadeDisco = $disco + ":"

Write-Host "Realizando downloads! Aguarde..." -ForegroundColor Cyan

$destinationFolder = "$unidadeDisco\Statum\"

# Criando a pasta de destino, caso ela não exista
if (!(Test-Path -Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder -Force
}

# Diretório de log
$logFilePath = "$unidadeDisco\Statum\script.log"

# Limpa o arquivo de log existente ou cria um novo
Out-File -FilePath $logFilePath -Force

# Definindo as URLs de download e os caminhos de destino
$downloads = @{
    "7z2408-x64.exe" = "https://www.7-zip.org/a/7z2408-x64.exe"
    "PSTools.zip" = "https://download.sysinternals.com/files/PSTools.zip"
    "TCPView.zip" = "https://download.sysinternals.com/files/TCPView.zip"
    "baretail.exe" = "https://www.baremetalsoft.com/baretail/download.php?p=m"
    "npp.8.6.7.Installer.x64.exe" = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.7/npp.8.6.7.Installer.x64.exe"
    "msodbcsql.msi" = "https://go.microsoft.com/fwlink/?linkid=2281260"
    "VC_redist.x64.exe" = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
    "ChromeSetup.exe" = "https://dl.google.com/chrome/chrome_installer.exe"
    "FileZilla_3.67.1_win64-setup.exe" = "https://fossies.org/windows/misc/FileZilla_3.67.1_win64-setup.exe"
    #"Wireshark-4.4.0-x64.exe" = "https://www.wireshark.org/download/win64/Wireshark-4.2.6-x64.exe"
    #"TreeSizeFreeSetup.exe" = "https://downloads.jam-software.de/treesize_free/TreeSizeFreeSetup.exe"
}

# Baixando cada arquivo e salvando no caminho especificado
foreach ($fileName in $downloads.Keys) {
    $downloadUrl = $downloads[$fileName]
    $destinationPath = Join-Path -Path $destinationFolder -ChildPath $fileName

    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath
        $message = "Download de $fileName concluído e salvo em: $destinationPath"
        $message | Out-File -FilePath $logFilePath -Append
    } catch {
        $message = "Erro ao baixar o arquivo $fileName"
        $message | Out-File -FilePath $logFilePath -Append
    }
}

# Definir credenciais de FTP e informações do servidor
$ftpServer = "ftp://ftp.senior-rp.com.br"
$username = "cli_tja"
$password = "tg3yDYdeD443%6%%usnpJM"

# Lista de arquivos para download com seus caminhos remotos e locais
$filesToDownload = @(
    @{
        RemotePath = "/Utilitarios/Pre-RequisitosSenior/RequisitosGestaoPonto/Redis.zip"
        LocalPath = "$unidadeDisco\Statum\Redis.zip"
    },
    @{
        RemotePath = "/Utilitarios/Pre-RequisitosSenior/jdk-8u231-windows-x64.exe"
        LocalPath = "$unidadeDisco\Statum\jdk-8u231-windows-x64.exe"
    },
    @{
        RemotePath = "/Utilitarios/Pre-RequisitosSenior/RequisitosSDE/mongodb-win32-x86_64-2012plus-4.2.13-signed.msi"
        LocalPath = "$unidadeDisco\Statum\mongodb-win32-x86_64-2012plus-4.2.13-signed.msi"
    },
    @{
        RemotePath = "/Utilitarios/Pre-RequisitosSenior/RequisitosSDE/otp_win64_26.2.1.exe"
        LocalPath = "$unidadeDisco\Statum\otp_win64_26.2.1.exe"
    },
    @{
        RemotePath = "/Utilitarios/Pre-RequisitosSenior/RequisitosSDE/rabbitmq-server-3.12.11.exe"
        LocalPath = "$unidadeDisco\Statum\rabbitmq-server-3.12.11.exe"
    },
    @{
        RemotePath = "/Utilitarios/Pre-RequisitosSenior/wildfly-30.0.1.Final.zip"
        LocalPath = "$unidadeDisco\Statum\wildfly-30.0.1.Final.zip"
    }
)

foreach ($file in $filesToDownload) {
    $remoteFile = $file.RemotePath
    $localPath = $file.LocalPath

    # Criar uma solicitação de FTP
    $ftpRequest = [System.Net.FtpWebRequest]::Create("$ftpServer$remoteFile")
    $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
    $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($username, $password)
    
    try {
        # Obter a resposta do FTP
        $ftpResponse = $ftpRequest.GetResponse()
        $responseStream = $ftpResponse.GetResponseStream()
        $fileStream = [System.IO.File]::Create($localPath)
        
        # Copiar o arquivo do FTP para o local
        $buffer = New-Object byte[] 1024
        do {
            $read = $responseStream.Read($buffer, 0, $buffer.Length)
            $fileStream.Write($buffer, 0, $read)
        } while ($read -gt 0)

        # Fechar streams
        $fileStream.Close()
        $responseStream.Close()
        $ftpResponse.Close()
        
        $message = "Download via FTP do arquivo $remoteFile concluído com sucesso e salvo em $localPath"
        $message | Out-File -FilePath $logFilePath -Append
    } catch {
        $message = "Ocorreu um erro ao baixar o arquivo $remoteFile do FTP"
        $message | Out-File -FilePath $logFilePath -Append
    }
}

########### DOWNLOAD E INSTALAÇÃO DO JDK 17 ###########

# Define o link para o download do JDK
$jdkUrl = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.13%2B11/OpenJDK17U-jdk_x64_windows_hotspot_17.0.13_11.msi"
# Define o caminho onde o JDK será salvo temporariamente
$jdkInstallerPath = "$env:TEMP\OpenJDK17.msi"

# Baixa o JDK
#Write-Output "Baixando o JDK 17..."
$message = "Baixando o JDK 17..."
$message | Out-File -FilePath $logFilePath -Append
Invoke-WebRequest -Uri $jdkUrl -OutFile $jdkInstallerPath

# Verifica se o download foi concluído com sucesso
if (Test-Path $jdkInstallerPath) {
    #Write-Output "Download concluído. Iniciando a instalação..."
    $message = "Download do JDK17 concluído, iniciando a instalação..."
    $message | Out-File -FilePath $logFilePath -Append
    # Instala o JDK de forma silenciosa
    Start-Process msiexec.exe -ArgumentList "/i `"$jdkInstallerPath`" /quiet /norestart" -Wait
    #Write-Output "Instalação concluída."
    $message = "Instalação concluída."
    $message | Out-File -FilePath $logFilePath -Append
    # Remove o instalador
    Remove-Item $jdkInstallerPath -Force
} else {
    #Write-Output "Ocorreu um erro durante o download. Verifique o link e tente novamente."
    $message = "Ocorreu um erro durante o download. Verifique o link e tente novamente."
    $message | Out-File -FilePath $logFilePath -Append
}

# Define o caminho do JAVA_HOME
$javaHomePath = "C:\Program Files\Eclipse Adoptium\jdk-17.0.13.11-hotspot"

# Configura a variável de ambiente JAVA_HOME no sistema
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHomePath, [System.EnvironmentVariableTarget]::Machine)

# Adiciona o JAVA_HOME ao PATH do sistema, se não estiver presente
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
if ($currentPath -notlike "*$javaHomePath*") {
    $newPath = "$currentPath;$javaHomePath\bin"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
    #Write-Output "Variável JAVA_HOME configurada e adicionada ao PATH com sucesso."
    $message = "Variável JAVA_HOME configurada e adicionada ao PATH com sucesso."
    $message | Out-File -FilePath $logFilePath -Append
} else {
    #Write-Output "JAVA_HOME já está configurado no PATH."
    $message = "Variável JAVA_HOME já está configurada no PATH."
    $message | Out-File -FilePath $logFilePath -Append
}

########### Extração do zip WildFly e instalação do serviço ###########

# Diretório do arquivo zip e caminho de extração
$zipPath = "$unidadeDisco\Statum\wildfly-30.0.1.Final.zip"
$extractPath = "$unidadeDisco\wildfly-30.0.1.Final"

# Verifica se o arquivo zip existe
if (Test-Path $zipPath) {
    #Write-Output "Extraindo o arquivo WildFly..."
    $message = "Extraindo o arquivo WildFly..."
    $message | Out-File -FilePath $logFilePath -Append

    # Extrai o conteúdo do arquivo zip
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, "C:\")

    #Write-Output "Arquivo extraído com sucesso."
    $message = "Arquivo extraído com sucesso."
    $message | Out-File -FilePath $logFilePath -Append

    # Caminho do script de instalação do serviço
    $serviceScriptPath = "$extractPath\bin\service\service.bat"

    # Verifica se o arquivo de instalação do serviço existe
    if (Test-Path $serviceScriptPath) {
        #Write-Output "Instalando o serviço WildFly..."
        $message = "Instalando o serviço WildFly..."
        $message | Out-File -FilePath $logFilePath -Append

        # Executa o comando de instalação do serviço
        Start-Process -FilePath $serviceScriptPath -ArgumentList "install" -Wait

        #Write-Output "Serviço WildFly instalado com sucesso."
        $message = "Serviço instalado com sucesso."
        $message | Out-File -FilePath $logFilePath -Append
    } else {
        #Write-Output "Arquivo service.bat não encontrado em $serviceScriptPath. Verifique o diretório de instalação."
        $message = "Arquivo service.bat não encontrado em $serviceScriptPath. Verifique o diretório de instalação."
        $message | Out-File -FilePath $logFilePath -Append
    }
} else {
    #Write-Output "Arquivo zip não encontrado em $zipPath. Verifique o caminho e tente novamente."
    $message = "Arquivo zip não encontrado em $zipPath. Verifique o caminho e tente novamente."
    $message | Out-File -FilePath $logFilePath -Append
}

# Nome do serviço a ser configurado e novo nome de exibição
$serviceName = "wildfly"
$newDisplayName = "Senior - WildFly"

# Renomeia o serviço
#Write-Output "Renomeando o serviço para '$newDisplayName'..."
$message = "Renomeando o serviço para '$newDisplayName'..."
$message | Out-File -FilePath $logFilePath -Append
sc.exe config $serviceName DisplayName= "$newDisplayName"

#Write-Output "Serviço renomeado com sucesso para '$newDisplayName'."
$message = "Serviço renomeado com sucesso."
$message | Out-File -FilePath $logFilePath -Append

# Exibe a caixa de mensagem no final
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("Processo finalizado, consulte o log em $unidadeDisco\Senior\Statum\script.log")
