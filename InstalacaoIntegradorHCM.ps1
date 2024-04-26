Clear-Host

Write-Host "Automação de Instalação do Integrador HCM" -ForegroundColor Green

$server = "OCSENINT01"

Invoke-Command -ComputerName $server -ScriptBlock{
    param (
        $name,
        $getCode,
        $tipAmb,
        $cliente,
        $codPDB,
        $porta1,
        $porta2,
        $porta3,
        $arquivoPEM,
        $portas,
        $compartilhamentoFormatado,
        $integration
    )

    <# Coletando as informações #>
    $name = Read-Host "Digite o nome do cliente"
    $getCode = Read-Host "Digite o código HCM do cliente"
    $tipAmb = Read-Host "Qual o tipo de ambiente? (p)Produção, (h)Homologação"
    $cliente = $name + "_" + $getCode + "_" + $tipAmb
    Write-Host Servidor = $env:COMPUTERNAME -ForegroundColor Yellow
    Write-Host Cliente = $name -ForegroundColor Yellow
    Write-Host Código = $getCode -ForegroundColor Yellow
    Write-Host Tipo de ambiente = $tipAmb -ForegroundColor Yellow
    Write-Host Pasta = $cliente -ForegroundColor Yellow

    # Criando a pasta
    New-Item -Path "D:\HCM_Integrador\$cliente" -ItemType Directory

    Write-Host "Pasta criada com sucesso!!" -ForegroundColor Green

    Write-Host "Aplicando permissões e criando o compartilhamento da pasta..." -ForegroundColor Green

    # Remove todas as permissões existentes e desabilita a herança
    $PERMISSIONS = Get-ACL -Path "D:\HCM_Integrador\$cliente"
    $PERMISSIONS.SetAccessRuleProtection($true, $false) # Desabilita a herança sem remover as permissões atuais
    $PERMISSIONS.Access | ForEach-Object { $PERMISSIONS.RemoveAccessRule($_) }
    Set-Acl -Path "D:\HCM_Integrador\$cliente" -AclObject $PERMISSIONS

    # Aplica as permissões do cliente
    $codPDB = Read-Host "Digite o código PDB do cliente"
    if ($tipAmb -eq "p") {
        $grupo1 = "MEGACLOUD\" + $codPDB + " - " + $name + "_HCM_Producao"

        # Aplica as novas permissões na pasta
        $PERMISSIONS = Get-ACL -Path "D:\HCM_Integrador\$cliente"
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupo1,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
        $PERMISSIONS.AddAccessRule($NEWPERMISSION)
        $PERMISSIONS | Set-Acl -Path "D:\HCM_Integrador\$cliente\"

        $PERMISSIONS = Get-ACL -Path "D:\HCM_Integrador\$cliente\"
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\Resolvedores Cloud","Modify", "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\HCM_Integrador\$cliente\"

        $PERMISSIONS = Get-ACL -Path "D:\HCM_Integrador\$cliente\"
        $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\CloudOps", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\HCM_Integrador\$cliente\"

        $PERMISSIONS = Get-ACL -Path "D:\HCM_Integrador\$cliente\"
        $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\HCM Manager", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\HCM_Integrador\$cliente\"

        # Cria o compartilhamento da pasta
        $folderPath = "D:\HCM_Integrador\$cliente"
        $shareName = "$cliente" + "$"
        New-SmbShare -Path $folderPath -Name $shareName -FullAccess "MEGACLOUD\CloudOps", "MEGACLOUD\HCM MANAGER" -ChangeAccess "MEGACLOUD\Resolvedores Cloud", "$grupo1"

     } elseif ($tipAmb -eq "h") {
        $PERMISSIONS = Get-ACL -Path "D:\HCM_Integrador\$cliente\"
        $grupo2 = "MEGACLOUD\" + $codPDB + " - " + $name + "_HCM_Homologacao"
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupo2,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
        $PERMISSIONS.AddAccessRule($NEWPERMISSION)
        $PERMISSIONS | Set-Acl -Path "D:\HCM_Integrador\$cliente\"

        $PERMISSIONS = Get-ACL -Path "D:\HCM_Integrador\$cliente\"
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\Resolvedores Cloud","Modify", "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\HCM_Integrador\$cliente\"

        $PERMISSIONS = Get-ACL -Path "D:\HCM_Integrador\$cliente\"
        $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\CloudOps", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION)
        $PERMISSIONS | Set-Acl -Path "D:\HCM_Integrador\$cliente\"

        $PERMISSIONS = Get-ACL -Path "D:\HCM_Integrador\$cliente\"
        $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\HCM Manager", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\HCM_Integrador\$cliente\"

        # Cria o compartilhamento da pasta
        $folderPath = "D:\HCM_Integrador\$cliente"
        $shareName = "$cliente" + "$"
        New-SmbShare -Path $folderPath -Name $shareName -FullAccess "MEGACLOUD\CloudOps", "MEGACLOUD\HCM MANAGER" -ChangeAccess "MEGACLOUD\Resolvedores Cloud", "$grupo2"
    }

    # Caminho do arquivo .zip de origem
    $origemZip = "D:\HCM_Integrador\hcm-integration.zip"

    # Diretório de destino para extração
    $destinoExtracao = "D:\HCM_Integrador\$cliente"

    # Extrair o arquivo .zip
    Expand-Archive -Path $origemZip -DestinationPath $destinoExtracao

    Write-Host "Copie o arquivo .PEM do cliente para o disco D: do servidor OCSENINT01..." -ForegroundColor Yellow

    $arquivoPEM = Read-Host "Qual o nome do arquivo .PEM do cliente? EX. heatingcoolingcombr"

    Write-Host "Conferindo as portas utilizadas pelo último cliente..." -ForegroundColor Yellow

    Write-Host "Range de portas encontrado..." -ForegroundColor Green

    # Caminho do arquivo .txt de portas
    $caminhoPortas = "D:\Portas.txt"

    # Lê o conteúdo do arquivo .txt de portas e identifica as portas
    $portas = Get-Content -Path $caminhoPortas

    # Define as variáveis para as portas
    $porta1 = $portas | Where-Object {$_ -like "*80*"} | Select-Object -Last 1
    $porta2 = $portas | Where-Object {$_ -like "*27*"} | Select-Object -Last 1
    $porta3 = $portas | Where-Object {$_ -like "*90*"} | Select-Object -Last 1

    # Incrementa as portas encontradas em uma unidade
    $porta1Nova = ([int]$porta1) + 1
    $porta2Nova = ([int]$porta2) + 1
    $porta3Nova = ([int]$porta3) + 1

    # Preenche o arquivo Portas.txt
    $linesToAdd = @(
    "", #Linha em branco
    "$cliente",
    "$porta1Nova",
    "$porta2Nova",
    "$porta3Nova"
                )

    # Adiciona as novas portas ao arquivo
    $linesToAdd | ForEach-Object { Add-Content -Path $caminhoPortas -Value $_ }

    Write-Host "Confirme em qual servidor o sistema do cliente está instalado..." -ForegroundColor Yellow

    $compartilhamento = Read-Host "Qual o nome do servidor onde o sistema está instalado? Ex. OCSENAPL01"

    # Caminho do arquivo .properties
    $arquivoProperties = "D:\HCM_Integrador\$cliente\integration.properties"

    # Defina as novas linhas que deseja inserir
    $novasLinhas = @{
        "integration.inbound.port" = $porta1Nova
        "integration.inbound.host" = "OCSENINT01"
        "integration.fromFile.dir" = "\\\\" + "$compartilhamento" + "\\" + $cliente + "$" + "\\HCM"
        "hcm.tenant.id" = $arquivoPEM
        "config.rootdir" = "\\\\" + "$compartilhamento" + "\\" + $cliente + "$"
        "config.environment" = $cliente
        "updater.socket.port" = $porta2Nova
        "updater.integration.healthcheck.port" = $porta3Nova
        # Adicione mais propriedades conforme necessário
                                                        }

    # Ler todas as linhas do arquivo
    $linhas = Get-Content -Path $arquivoProperties

    # Percorrer cada linha e encontrar as linhas que deseja alterar
    foreach ($chave in $novasLinhas.Keys) {
        for ($i = 0; $i -lt $linhas.Count; $i++) {
            if ($linhas[$i] -match "^$chave=") {
                # Substituir a linha existente pela nova linha
                $linhas[$i] = "$chave=" + $novasLinhas[$chave]
                break
                    }
                        }
                            }

    # Escrever as linhas atualizadas de volta para o arquivo
    $linhas | Set-Content -Path $arquivoProperties

    # Editando o app.js
    $app = "D:\HCM_Integrador\$cliente\hcm-monitor\js\app.js"

    # String de busca
    $antigoTexto = "http://localhost:8082"

    # Texto de substituição
    $novoTexto = "http://OCSENINT01:" + $porta1Nova

    # Ler o conteúdo do arquivo
    $conteudo = Get-Content $app

    # Substituir a string
    $novoConteudo = $conteudo -replace [regex]::Escape($antigoTexto), $novoTexto

    # Escrever o novo conteúdo de volta para o arquivo
    $novoConteudo | Set-Content $app

    # Modo não interativo - define um caminho padrão (ajuste conforme necessário)
    $caminhoDoArquivoPEM = "D:\$arquivoPEM.pem"

    # Verifica se o arquivo .PEM existe
        if (Test-Path $caminhoDoArquivoPEM) {
        # Define o diretório de destino para salvar o arquivo
        $diretorioDeDestinoPEM = "D:\HCM_Integrador\$cliente\"

        # Move o arquivo para o diretório de destino
        Move-Item -Path $caminhoDoArquivoPEM -Destination $diretorioDeDestinoPEM

        Write-Host "Arquivo .PEM importado com sucesso para $diretorioDeDestinoPEM"
            } else {
        Write-Host "O arquivo .PEM especificado não foi encontrado."
                    }

    Write-Host "Realizando a instalação do serviço do Integrador HCM..." -ForegroundColor Yellow

    # Caminho do diretório onde está o arquivo .bat
    $batDirectory = "D:\HCM_Integrador\$cliente"

    # Caminho completo do arquivo .bat
    $batFile = Join-Path -Path $batDirectory -ChildPath "InstallService64.bat"

    # Verifica se o arquivo .bat existe
    if (Test-Path $batFile) {
        # Define o diretório atual como o diretório do arquivo .bat
        Set-Location $batDirectory

        # Executa o arquivo .bat
        & $batFile

        # Verifica se o serviço foi instalado corretamente
    if (Get-Service -Name "SeniorHCMIntegrator_$arquivoPEM" -ErrorAction SilentlyContinue) {
        Write-Host "Serviço do Integrador HCM instalado com sucesso!!" -ForegroundColor Green
    } else {
        Write-Host "Falha ao instalar o serviço do Integrador HCM. Verifique o arquivo .bat para mais detalhes." -ForegroundColor Red
    }
    } else {
    Write-Host "Arquivo .bat não encontrado em $batFile. A instalação do serviço não pôde ser concluída." -ForegroundColor Red
    }

    # Verifica o status do serviço
    Get-WMIObject win32_service | Where-Object{$_.pathname -like "*$cliente*"} | Format-Table PSComputerName, Name, PathName, StartName, State

    # Coleta a senha do usuário para atribuir ao serviço
    $newUsername = "MEGACLOUD\seniorapp1"
    $newPassword = "Seniorsuporte.."

    Write-Host "Aplicando alterações..." -ForegroundColor Yellow

    # Obtenha o objeto de serviço usando WMI
    $service = Get-WMIObject win32_service | Where-Object{$_.pathname -like "*$cliente*"}

    # Para o serviço antes de fazer alterações
    $service.StopService()

    # Altera o usuário e senha do serviço
    $service.Change($null, $null, $null, $null, $null, $null, $newUsername, $newPassword)

    # Inicia o serviço novamente
    $service.StartService()

    Write-Host "Iniciando o serviço do Integrador HCM..." -ForegroundColor Yellow

    # Verifica o status do serviço
    Get-WMIObject win32_service | Where-Object{$_.pathname -like "*$cliente*"} | Format-Table PSComputerName, Name, PathName, StartName, State

} -ArgumentList $name, $getCode, $tipAmb, $cliente, $codPDB, $porta1, $porta2, $porta3, $arquivoPEM, $portas, $compartilhamentoFormatado, $integration

# Exibe o MessageBox
powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('IMPORTANTE' + [Environment]::NewLine + 'Valide as permissões da pasta e se o compartilhamento está correto.' + [Environment]::NewLine + 'Finalize a configuração do alias no site do IIS antes de liberar ao cliente...','SERVIÇO INSTALADO COM SUCESSO!!')}"
