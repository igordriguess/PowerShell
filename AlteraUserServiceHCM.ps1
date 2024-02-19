While ($true) {
Clear-Host

Write-Host "Altera usuário de serviço" -ForegroundColor Green

$computerName = Read-Host "Qual o nome do servidor?"

Invoke-Command -ComputerName $computerName -ScriptBlock{

#Especifique o nome do serviço
$serviceName = Read-Host "Qual o nome do serviço? Exemplo: Motor, Middleware, SeniorInst, Wiipo"

Write-Host "Verificando serviços..." -ForegroundColor Yellow

#Verifica o status dos serviços
Get-WMIObject win32_service | Where-Object{$_.pathname -like "*$serviceName*"} | ft PSComputerName, Name, PathName, StartName, State

#Especifique o novo nome de usuário e senha
$newUsername = Read-Host "Qual o nome do usuário? Utilizar o padrão: MEGACLOUD\seniorapp1"
$newPassword = Read-Host "Qual a senha do usuário?"

Write-Host "Aplicando alterações..." -ForegroundColor Yellow

#Obtenha o objeto de serviço usando WMI
$service = Get-WMIObject win32_service | Where-Object{$_.pathname -like "*$serviceName*"}

#Pare o serviço antes de fazer alterações
$service.StopService()

#Altere o usuário e senha do serviço
$service.Change($null, $null, $null, $null, $null, $null, $newUsername, $newPassword)

#Inicie o serviço novamente
$service.StartService()

#Verifica o status dos serviços
Get-WMIObject win32_service | Where-Object{$_.pathname -like "*$serviceName*"} | ft PSComputerName, Name, PathName, StartName, State

$restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Não(N)"
        if($restartScript -eq "S"){
            continue
        }else{
            break
        }

break
}

    }

exit
