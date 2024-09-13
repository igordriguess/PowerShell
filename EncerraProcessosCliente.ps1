While ($true) {

    Clear-Host;
    Write-Host "Mega Cloud HCM - Verifica processos em execução por cliente..." -ForegroundColor Green

    Write-Host "Digite o nome do servidor remoto:" -ForegroundColor Cyan
    $computerName = Read-Host

    # DEFINIÇÃO DO CLIENTE
    Write-Host "Qual o nome do cliente?" -ForegroundColor Cyan
    $nomeCli = Read-Host

    Write-Host "Sabe qual o código HCM do cliente? (S)Sim, (N)Não" -ForegroundColor Cyan
    $codCliQ = Read-Host;

    if ($codCliQ -eq "N") {
        # Caso o código do cliente não seja conhecido
        Invoke-Command -ComputerName $computerName -ScriptBlock {
            param($nomeCli)
            Get-WMIObject win32_service | Where-Object { $_.pathname -like "*$nomeCli*" -and $_.name -like "*SeniorInstInfoService*" } | Format-Table -AutoSize PSComputerName, Name, State, PathName
        } -ArgumentList $nomeCli

        Write-Host "Digite o código do cliente:" -ForegroundColor Cyan
        $codCli = Read-Host
    } else {
        Write-Host "Confirme o código..." -ForegroundColor Cyan
        $codCli = Read-Host
    }

    Write-Host "Qual o tipo de ambiente? (p)Produção, (h)Homologação" -ForegroundColor Cyan
    $tipAmb = Read-Host
    $cliente = "$nomeCli" + "_" + "$codCli" + "_" + "$tipAmb"

    Write-Host "Consultando processos..." -ForegroundColor Cyan
    
$nenhumProcesso = $false

# CONSULTA OS PROCESSOS EM EXECUÇÃO
Invoke-Command -ComputerName $computerName -ScriptBlock {
    param($cliente)

    # Armazena os processos em uma variável
    $processos = Get-Process -Name * | Where-Object { $_.path -like "*$cliente*" }

    # Verifica se a lista de processos está vazia
    if ($processos) {
        # Se houver processos, exibe-os em formato de tabela
        $processos | Format-Table -AutoSize ID, ProcessName, Path
    } else {
        # Caso contrário, exibe a mensagem e define uma flag para pular o encerramento
        Write-Host "Nenhum processo encontrado para o cliente $cliente" -ForegroundColor Yellow
        return $true
    }

} -ArgumentList $cliente -OutVariable resultado

    $nenhumProcesso = $resultado

# Verifica se nenhum processo foi encontrado
if ($nenhumProcesso -eq $true) {
    # Pula o encerramento e vai direto para o laço de repetição
    Write-Host "Deseja reiniciar o script? Sim(S) Não(N)" -ForegroundColor Cyan
    $restartScript = Read-Host
    if ($restartScript -eq "S") {
        continue
    } else {
        break
    }
}

# Se processos foram encontrados, continua o fluxo para encerrar processos
Write-Host "Deseja encerrar algum processo? (S)Sim, (N)Não" -ForegroundColor Cyan
$processo = Read-Host

if ($processo -eq "S") {
    do {
        Write-Host "Digite o ID do processo que você deseja encerrar" -ForegroundColor Cyan
        $comando = Read-Host

        # ENCERRA O PROCESSO DESEJADO
        Invoke-Command -ComputerName $computerName -ScriptBlock {
            param($comando)
            Get-Process | Where-Object { $_.id -eq $comando } | Stop-Process -Force
        } -ArgumentList $comando

        Write-Host "Processo encerrado com sucesso!!" -ForegroundColor Cyan

        # Exibe os processos restantes
        Invoke-Command -ComputerName $computerName -ScriptBlock {
            param($cliente)
            Get-Process -Name * | Where-Object { $_.path -like "*$cliente*" } | Format-Table -AutoSize ID, ProcessName, Path
        } -ArgumentList $cliente

        # Pergunta se deseja encerrar mais algum processo
        Write-Host "Deseja encerrar mais algum processo? (S)Sim, (N)Não" -ForegroundColor Cyan
        $maisProcessos = Read-Host

    } while ($maisProcessos -eq "S")
}

# LACO DE REPETIÇÃO
Write-Host "Deseja reiniciar o script? Sim(S) Não(N)" -ForegroundColor Cyan
$restartScript = Read-Host
if ($restartScript -eq "S") {
    continue
} else {
    break
}

}

Exit
