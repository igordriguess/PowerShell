Clear-Host

Write-Host 'Verifica e exclui os servicos de homologacao do WIIPO nos servidores de aplicacao' -ForegroundColor Green

# Define o caminho do arquivo de log
$logFilePath = "\\ocmegfs03\Datafiles$\Resolvedores\Igor\Scripts\Automação\Wiipo\servicos_desinstalados.log"

# Verifica os servicos instalados e o status do mesmo
$services = Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01 |
    Where-Object {$_.pathname -like "*Wiipo*"} | Where-Object {$_.pathname -like "*_h_v1*"}

if ($services) {
    $services | ForEach-Object {
        # Registra o nome do servico desinstalado no log
        $_.Name | Out-File -FilePath $logFilePath -Append
        
        # Mostra o serviço e seu estado
        $_ | Format-Table Name, State

        # Realiza o stop dos serviços
        $_.StopService()

        # Desinstala o serviço
        $_.Delete()
    }

    powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Servico(s) desinstalado(s) com sucesso!! Consulte os detalhes no arquivo de log...','SUCESSO')}"

} else {
    powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Nenhum servico encontrado para ser desinstalado','MENSAGEM')}"
}
