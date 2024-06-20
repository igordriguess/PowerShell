While ($true) {

    Clear-Host

    Write-Host "Verificando e corrigindo os serviços..." -ForegroundColor Green

    # Ajusta o modo de inicialização do serviço para "Manual"
    Get-WMIObject win32_service -ComputerName OCSENWSERVICE01, OCSENWSERVICE02, OCSENWSERVICE03, OCSENWSERVICE04, OCSENWSERVICE05 |
    Where-Object{$_.PathName -like "*Glassfish*" -and $_.PathName -like "*Homol*" -and $_.StartMode -eq "Auto" -and $_.PathName -notlike "*TEX31151h*" -and $_.PathName -notlike "*CIVIL10465h*"} |
        ForEach-Object {
            $serviceName = $_.Name
            $systemName = $_.SystemName
            $command = "sc.exe \\$systemName config $serviceName start= delayed-auto"
            Invoke-Expression $command
        }

    Write-Host "Verificando os serviços de Homologação do Glassfish que estão em execução..." -ForegroundColor Yellow

    # Consulta os serviços de homologação que estão em execução
    $comandServices = Get-WmiObject win32_service -ComputerName OCSENWSERVICE01, OCSENWSERVICE02, OCSENWSERVICE03, OCSENWSERVICE04, OCSENWSERVICE05 | Where-Object {$_.PathName -like "*Glassfish*" -and $_.PathName -like "*Homol*" -and $_.StartMode -eq "Manual" -and $_.State -eq "Running"}

    if ($comandServices) {
        $comandServices | ForEach-Object {
            # Mostra o serviço e seu estado
            $_ | Format-Table PSComputerName, Name, PathName, State

            # Realiza o stop dos serviços
            $_.StopService()
        }
    }
    else {
        Write-Host "Nenhum serviço MANUAL de Homologação do Glassfish em execução..." -ForegroundColor Green
    }

    # Iniciando a consulta da porta HTTPS dos serviços
    # Definir os nomes dos computadores em um array
    $computers = @("OCSENWSERVICE01", "OCSENWSERVICE02")

    # Obter os serviços uma vez fora do loop
    $services = Get-WmiObject win32_service -ComputerName $computers | Where-Object {$_.PathName -like "*Glassfish*" -and $_.PathName -like "*Homol*" -and $_.StartMode -eq "Manual" -and $_.State -like "*Pending*"}

    # Iterar sobre cada serviço encontrado
    foreach ($service in $services) {

        # Extrair o diretório base a partir do PathName
        $pathName = $service.PathName
        $baseDir = Split-Path -Path $pathName -Parent

        # Extrair o nome do cliente a partir do PathName usando uma expressão regular
        if ($pathName -match 'domains\\([^\\]+)\\bin') {
            $clientName = $matches[1]
        } else {
            Write-Output "Não foi possível extrair o nome do cliente do caminho: $pathName"
            continue
        }

        # Construir dinamicamente o caminho para o arquivo domain.xml
        $domainDir = "D:\glassfish40\glassfish\domains\$clientName\config"

        $port = Invoke-Command -ComputerName $computers -ScriptBlock {
            param ($domainDir)

            # Encontrar os arquivos domain.xml dentro do caminho especificado
            $domainConfigFiles = Get-ChildItem -Path $domainDir -Filter "domain.xml" -ErrorAction SilentlyContinue

            foreach ($file in $domainConfigFiles) {
                # Ler o conteúdo do arquivo domain.xml e buscar a linha do admin-listener
                $adminListenerLine = Get-Content -Path $file.FullName | Where-Object {
                    $_ -like '*name="admin-listener" thread-pool="admin-thread-pool"*'
                }

                # Extrair o valor da porta da linha encontrada
                if ($adminListenerLine) {
                    if ($adminListenerLine -match 'port="(\d+)"') {
                        return $matches[1]
                    }
                }
            }
            return $null
        } -ArgumentList $domainDir

        # Exibir a porta, se encontrada
        if ($port) {
            Write-Output "O serviço $($clientName) instalado no servidor $($service.PSComputerName) está $($service.State) e a porta HTTPS do serviço é: $port"
        } else {
            Write-Output "Não foi possível encontrar a configuração da porta do admin-listener para o serviço $($service.Name)."
        }
    }

    # Definir os nomes dos computadores em um array
    $computers = @("OCSENWSERVICE03", "OCSENWSERVICE04", "OCSENWSERVICE05")

    # Obter os serviços uma vez fora do loop
    $services = Get-WmiObject win32_service -ComputerName $computers | Where-Object {$_.PathName -like "*Glassfish*" -and $_.PathName -like "*Homol*" -and $_.StartMode -eq "Manual" -and $_.State -like "*Pending*"}

    # Iterar sobre cada serviço encontrado
    foreach ($service in $services) {

        # Extrair o diretório base a partir do PathName
        $pathName = $service.PathName
        $baseDir = Split-Path -Path $pathName -Parent

        # Extrair o nome do cliente a partir do PathName usando uma expressão regular
        if ($pathName -match 'domains\\([^\\]+)\\bin') {
            $clientName = $matches[1]
        } else {
            Write-Output "Não foi possível extrair o nome do cliente do caminho: $pathName"
            continue
        }

        # Construir dinamicamente o caminho para o arquivo domain.xml
        $domainDir = "D:\glassfish-4.0\glassfish\domains\$clientName\config"

        $port = Invoke-Command -ComputerName $computers -ScriptBlock {
            param ($domainDir)

            # Encontrar os arquivos domain.xml dentro do caminho especificado
            $domainConfigFiles = Get-ChildItem -Path $domainDir -Filter "domain.xml" -ErrorAction SilentlyContinue

            foreach ($file in $domainConfigFiles) {
                # Ler o conteúdo do arquivo domain.xml e buscar a linha do admin-listener
                $adminListenerLine = Get-Content -Path $file.FullName | Where-Object {
                    $_ -like '*name="admin-listener" thread-pool="admin-thread-pool"*'
                }

                # Extrair o valor da porta da linha encontrada
                if ($adminListenerLine) {
                    if ($adminListenerLine -match 'port="(\d+)"') {
                        return $matches[1]
                    }
                }
            }
            return $null
        } -ArgumentList $domainDir

        # Exibir a porta, se encontrada
        if ($port) {
            Write-Output "O serviço $($clientName) instalado no servidor $($service.PSComputerName) está $($service.State) e a porta HTTPS do serviço é: $port"
        } else {
            Write-Output "Não foi possível encontrar a configuração da porta do admin-listener para o serviço $($service.Name)."
        }
    }

    # Laço de repetição
    $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Não(N)"
    if($restartScript -eq "S"){
        continue
    } else {
        break
    }
}
