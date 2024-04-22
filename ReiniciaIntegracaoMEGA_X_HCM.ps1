While ($true) {

Clear-Host

    Write-Host "Reinicia processo de integração MEGA X HCM" -ForegroundColor Green
    
    <# Coleta de informações do MEGA #>   
    $codMega = Read-Host "Qual o código MEGA do cliente?"

    Invoke-Command -ComputerName OCMEGINT01, OCMEGINT02, OCMEGINT03, OCMEGINT04, OCMEGINT05, OCMEGINT06, OCMEGAPL42, OCMEGINTHCM01 -ScriptBlock {
    param($codMega)

    <# Verifica a execução do processo SrvMegaIntegracaoSeniorAgenda #>
    Get-Process -Name SrvMegaIntegracaoSeniorAgenda | Where-Object {$_.Path -like "*$codMega*\Sistema*"} | Format-Table -AutoSize Id, ProcessName, Path

    <# Encerra os processos do SrvMega #>
    Get-Process -Name SrvMegaFinancAgenda | Where-Object {$_.path -like "*$codMega$\Sistema*"} | Stop-Process -Force
    Get-Process -Name SrvMegaIntegracaoCFSAgenda | Where-Object {$_.path -like "*$codMega$\Sistema*"} | Stop-Process -Force
    Get-Process -Name SrvMegaIntegracaoFolhaHCM_ADO | Where-Object {$_.path -like "*$codMega$\Sistema*"} | Stop-Process -Force
    Get-Process -Name SrvMegaIntegracaoSenior| Where-Object {$_.path -like "*$codMega$\Sistema*"} | Stop-Process -Force
    Get-Process -Name SrvMegaIntegracaoSeniorAgenda| Where-Object {$_.path -like "*$codMega$\Sistema*"} | Stop-Process -Force
    } -ArgumentList $codMega

    Write-Host "SrvMegaIntegracaoSeniorAgenda reiniciado com sucesso!!" -ForegroundColor Green

        <# Coleta de informações do HCM #>
        $nome = Read-Host "Qual o nome do cliente?"

        $codCliQ = Read-Host "Sabe qual o código HCM do cliente? (S)Sim, (N)Não"

        Write-Host "Confirme o código" -ForegroundColor Green

        if($codcliQ -eq "N"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.name -like "*SeniorInstInfoService*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName
            }

        $codCli = Read-Host "Digite o código HCM do cliente"

        if($codCliQ -eq "S"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*$codCli*"} | Where-Object{$_.name -like "*Middleware*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName
            }

        $tipAmb = Read-Host "Qual o tipo de ambiente? (p)Produção, (h)Homologação"
        $cliente = "$nome" + "_" + "$codCli" + "_" + "$tipAmb"

        Write-Host "Consultando cliente..." -ForegroundColor Green
        Write-Host Cliente = $cliente -ForegroundColor Yellow

        <# Verifica os serviços em execução #>
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01 | Where-Object{$_.pathname -like "*$cliente*"} |
        Where-Object{$_.pathname -like "*SeniorInstInfoService*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$cliente*"} |
        Where-Object{$_.pathname -like "*Middleware*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

        <# Verifica os processos em execução #>
        Write-Host "Processos em execução:" -ForegroundColor Green

        Invoke-Command -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01 -ScriptBlock {
        param($cliente)

        <# Verifica os processos em execução #>
        Get-Process -Name *Middleware* | Where-Object {$_.path -like "*$cliente*"} | Format-Table -AutoSize ID, ProcessName, Path
        Get-Process -Name *SeniorInstInfoService* | Where-Object {$_.path -like "*$cliente*"} | Format-Table -AutoSize ID, ProcessName, Path

        <# Encerra os processos em execução #>
        Get-Process -Name *Middleware* | Where-Object {$_.path -like "*$cliente*"} | Stop-Process -Force
        Get-Process -Name *SeniorInstInfoService* | Where-Object {$_.path -like "*$cliente*"} | Stop-Process -Force
        } -ArgumentList $cliente

        <# Inicia o serviço #>
        Write-Host "Processos encerrados e INICIANDO os serviços do cliente..." -ForegroundColor Green

        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01 | Where-Object{$_.pathname -like "*$cliente*"} |
        Where-Object{$_.pathname -like "*SeniorInstInfoService*"}).StartService()

        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$cliente*"} |
        Where-Object{$_.pathname -like "*Middleware*"}).StartService()

        <# Verifica novamente os processos em execução #>
        Invoke-Command -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01 -ScriptBlock {
        param($cliente)

        Get-Process -Name *Middleware* | Where-Object {$_.path -like "*$cliente*"} | Format-Table -AutoSize ID, ProcessName, Path
        Get-Process -Name *SeniorInstInfoService* | Where-Object {$_.path -like "*$cliente*"} | Format-Table -AutoSize ID, ProcessName, Path
        } -ArgumentList $cliente

        Write-Host "Processo de integração MEGA X HCM reiniciado com sucesso!!!" -ForegroundColor Green

        <# Apresenta a URL do webservice #>

        Write-Host "Segue abaixo a URL do servidor Java EE:" -ForegroundColor Green

        $ErrorActionPreference = "SilentlyContinue"

        Invoke-Command -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01 -ScriptBlock{
        $path = "D:\$using:cliente\$using:cliente.cfg"
        Get-Content -Path $path | Where-Object { $_ -like "*url>https://webmg*" } | Where-Object { $_ -notlike "*connector_url*" } |
        Where-Object { $_ -notlike "*access_url*" } | Where-Object { $_ -notlike "*gestaoponto-frontend*" } |
        Where-Object { $_ -notlike "*SeniorMonitorCenter*" } | Where-Object { $_ -notlike "*gestaoponto*" } |
        Where-Object { $_ -notlike "*basapiens*" } | Format-Table}

        Write-Host "Extensão para testes no Rubi: /g5-senior-services/rubi_Synccom_senior_g5_rh_fp_integracoes?wsdl" -ForegroundColor Yellow

        Write-Host "Extensão para testes no Sapiens: /g5-senior-services/sapiens_Synccom_senior_g5_co_ger_cad_produto?wsdl" -ForegroundColor Yellow

        <# Laço de repetição #>
        $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Não(N)"
        if($restartScript -eq "S"){
            continue
        }else{
            break
        }
            }

Exit
