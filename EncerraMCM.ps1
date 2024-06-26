$ErrorActionPreference = "SilentlyContinue"

While ($true) {

    Clear-Host

    Write-Host "Script para consultar o PID e encerrar o processo utilizado pelo MCM nos servidores de suporte" -ForegroundColor Green

    # Definir o nome do servidor e a porta HTTPS do serviço
    $computers = @("OCMEGSUP01", "OCMEGSUP02", "OCMEGSUP03", "OCMEGSUP04", "OCMEGACDEV01")
    $httpsPort = Read-Host "Qual a porta MCM utilizada pelo cliente? Ex. 31104"

    # Comando para executar o netstat remotamente e filtrar pela porta
    $netstatCommand = "netstat -ano | findstr `:$httpsPort"

    # Iterar sobre cada computador
    foreach ($computer in $computers) {
        $netstatResult = Invoke-Command -ComputerName $computer -ScriptBlock { param($cmd) Invoke-Expression $cmd } -ArgumentList $netstatCommand

        # Verificar se o resultado foi obtido
        if ($netstatResult) {
            # Extrair o PID do resultado do netstat
            $netstatLines = $netstatResult -split "`n"
            $processFound = $false
            $pids = @()

            foreach ($line in $netstatLines) {
                if ($line -match "LISTENING\s+(\d+)$") {
                    $processId = $matches[1]

                    # Evitar duplicação de PID
                    if ($pids -notcontains $processId) {
                        $pids += $processId

                        # Encerrar o processo com o PID obtido
                        Invoke-Command -ComputerName $computer -ScriptBlock { param($procId) Stop-Process -Id $procId -Force } -ArgumentList $processId
                        Write-Host "Processo com PID $processId encerrado com sucesso no servidor $computer." -ForegroundColor Green
                        $processFound = $true
                    }
                }
            }
            if (-not $processFound) {
                Write-Host "Nenhum processo encontrado na porta $httpsPort do servidor $computer." -ForegroundColor Yellow
            }
        } else {
            Write-Host "Nenhum processo encontrado na porta $httpsPort do servidor $computer." -ForegroundColor Yellow
        }
    }

    # Laço de repetição
    $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Não(N)"
    if ($restartScript -eq "S") {
        continue
    } else {
        break
    }
}
