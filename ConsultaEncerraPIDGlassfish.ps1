$ErrorActionPreference = "SilentlyContinue"

While ($true) {

Clear-Host

Write-Host "Script para consultar o PID e encerrar o processo utilizado pela porta HTTPS do Glassfish" -ForegroundColor Green

# Definir o nome do servidor e a porta HTTPS do serviço
$serverName = Read-Host "Qual o nome do servidor? Ex. OCSENWSERVICE02"
$httpsPort = Read-Host "Qual a porta HTTPS utilizada? Ex. 31104"

# Comando para executar o netstat remotamente e filtrar pela porta
$netstatCommand = "netstat -ano | findstr `:$httpsPort"

# Executar o comando remoto via Invoke-Command
$netstatResult = Invoke-Command -ComputerName $serverName -ScriptBlock { param($cmd) Invoke-Expression $cmd } -ArgumentList $netstatCommand

# Verificar se o resultado foi obtido
if ($netstatResult) {
    # Extrair o PID do resultado do netstat
    $netstatLines = $netstatResult -split "`n"
    foreach ($line in $netstatLines) {
        if ($line -match "LISTENING\s+(\d+)$") {
            $processId = $matches[1]

            # Encerrar o processo com o PID obtido
            Invoke-Command -ComputerName $serverName -ScriptBlock { param($procId) Stop-Process -Id $procId -Force } -ArgumentList $processId
            Write-Host "Processo com PID $processId encerrado com sucesso."
        } else {
            Write-Host "Nenhum processo encontrado na porta $httpsPort."
        }
    }
} else {
    Write-Host "Nenhum processo encontrado na porta $httpsPort."
}

    # Laço de repetição
    $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Não(N)"
    if($restartScript -eq "S"){
        continue
    } else {
        break
    }
}
