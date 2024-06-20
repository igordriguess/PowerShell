While ($true) {
Clear-Host

Write-Host "Script para ajustar e iniciar os serviços de produção do Glassfish" -ForegroundColor Yellow

Write-Host "Verificando e corrigindo os serviços..." -ForegroundColor Green

# Ajusta o modo de inicialização do serviço para "Automatic (Delayed Start)"
Get-WMIObject win32_service -ComputerName OCSENWSERVICE01, OCSENWSERVICE02, OCSENWSERVICE03, OCSENWSERVICE04, OCSENWSERVICE05 |
Where-Object{$_.PathName -like "*Glassfish*" -and $_.PathName -like "*Prod*" -and $_.StartMode -eq "Manual" -and $_.PathName -notlike "*Mega*" -and $_.PathName -notlike "*Teste*"} |
    ForEach-Object {
        $serviceName = $_.Name
        $systemName = $_.SystemName
        $command = "sc.exe \\$systemName config $serviceName start= delayed-auto"
        Invoke-Expression $command
    }

#Get-WmiObject win32_service -ComputerName OCSENWSERVICE01, OCSENWSERVICE02, OCSENWSERVICE03, OCSENWSERVICE04, OCSENWSERVICE05 | Where-Object {$_.PathName -like "*Glassfish*" -and $_.PathName -like "*Prod*" -and $_.State -eq "Stopped" -and $_.StartMode -eq "Auto" -and $_.PathName -notlike "*Mega*" -and $_.PathName -notlike "*Teste*"} | Format-Table Name, PathName, State, StartMode

# Consulta os serviços e inicia se estiver parado
$services = Get-WmiObject win32_service -ComputerName OCSENWSERVICE01, OCSENWSERVICE02, OCSENWSERVICE03, OCSENWSERVICE04, OCSENWSERVICE05 | Where-Object {$_.PathName -like "*Glassfish*" -and $_.PathName -like "*Prod*" -and $_.State -eq "Stopped" -and $_.StartMode -eq "Auto" -and $_.PathName -notlike "*Mega*" -and $_.PathName -notlike "*Teste*"}

if ($services) {
    Write-Host "Iniciando o(s) serviço(s) de PRODUÇÃO..." -ForegroundColor Yellow

    ($services).StartService()

    Write-Host "Serviço(s) iniciado(s)!!" -ForegroundColor Green

    $services | Format-Table -AutoSize Name, PathName, State, StartMode

} else {
    Write-Host "Nenhum serviço AUTO de PRODUÇÃO está parado!!" -ForegroundColor Green
}

    # Laço de repetição
    $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Não(N)"
    if ($restartScript -ne "S") {
        break
    }
}
