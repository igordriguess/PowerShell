While ($true) {

    Clear-Host
    
    Write-Host "Encerra os processos e inicia os servicos" -ForegroundColor Green
    
    $nomeCli = Read-Host "Qual o nome do cliente?"
    
    $codCliQuestion = Read-Host "Sabe qual o codigo HCM do cliente? (S)Sim, (N)Nao"
    
    if ($codCliQuestion -eq "S") {
        $codCli = Read-Host "Digite o codigo do cliente"
    } elseif ($codCliQuestion -eq "N") {
        $serviceCli = Get-WmiObject Win32_Service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 |
                    Where-Object {$_.pathname -like "*$nomeCli*"}
        $serviceCli | Where-Object {$_.pathname -like "*SeniorInstInfo*"} | Format-Table PSComputerName, Name, State, PathName
        $codCli = Read-Host "Confirme o codigo acima e digite o codigo do cliente"
    }
    
    $tipAmb = Read-Host "Qual o tipo de ambiente? (p)Producao, (h)Homologacao"
    
    $cliente = $nomeCli + "_" + $codCli + "_" + $tipAmb
    
    Write-Host $cliente -ForegroundColor Green
    
    Write-Host "Consultando os processos em execucao do cliente..." -ForegroundColor Green
    
    <# Consulta os processos em execução #>
    Invoke-Command -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 -ScriptBlock {
        param ($cliente)
        Get-Process -Name *Middleware* | Where-Object {$_.Path -like "*$cliente*"} | Format-Table ID, Name, Path
        Get-Process -Name *Wiipo* | Where-Object {$_.Path -like "*$cliente*"} | Format-Table ID, Name, Path
        Get-Process -Name *SeniorInstInfo* | Where-Object {$_.Path -like "*$cliente*"} | Format-Table ID, Name, Path
        Get-Process -Name *prunsrv* | Where-Object {$_.Path -like "*$cliente*"} | Format-Table ID, Name, Path
        Get-Process -Name *Integra* | Where-Object {$_.Path -like "*$cliente*"} | Format-Table ID, Name, Path
        Get-Process -Name *CSM* | Where-Object {$_.Path -like "*$cliente*"} | Format-Table ID, Name, Path
        Get-Process -Name *Concentradora* | Where-Object {$_.Path -like "*$cliente*"} | Format-Table ID, Name, Path
    } -ArgumentList $cliente
    
    Write-Host "Encerrando os processos e iniciando os servicos..." -ForegroundColor Green
    
    <# Encerra os processos em execução #>
    Invoke-Command -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 -ScriptBlock {
        param ($cliente)
        Get-Process -Name *Middleware* | Where-Object {$_.Path -like "*$cliente*"} | Stop-Process -Force
        Get-Process -Name *Wiipo* | Where-Object {$_.Path -like "*$cliente*"} | Stop-Process -Force
        Get-Process -Name *SeniorInstInfo* | Where-Object {$_.Path -like "*$cliente*"} | Stop-Process -Force
        Get-Process -Name *prunsrv* | Where-Object {$_.Path -like "*$cliente*"} | Stop-Process -Force
        Get-Process -Name *Integra* | Where-Object {$_.Path -like "*$cliente*"} | Stop-Process -Force
        Get-Process -Name *CSM* | Where-Object {$_.Path -like "*$cliente*"} | Stop-Process -Force
        Get-Process -Name *Concentradora* | Where-Object {$_.Path -like "*$cliente*"} | Stop-Process -Force
    } -ArgumentList $cliente
    
    <# Realiza a consulta nos serviços filtrando pelo nome do cliente e armazena na variável #>
    $services = Get-WmiObject Win32_Service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 |
    Where-Object {$_.pathname -like "*$cliente*"}
    
    <# Realiza o comando para iniciar os serviços #>
    ($services).StartService()
    
    Write-Host "Servicos iniciados com sucesso!!" -ForegroundColor Green
    
    <# Laço de repetição #>
    $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Nao(N)"
    if($restartScript -eq "S"){
        continue
    }else{
        break
    }
    }
    
Exit
