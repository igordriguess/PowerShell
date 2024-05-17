while ($true) {
    Clear-Host
    Write-Host "Script para consultar os compartilhamentos de PRODUÇÃO do HCM" -ForegroundColor Green

    # Define o nome do servidor remoto
    $nomeServidor = Read-Host "Qual servidor você deseja consultar o compartilhamento?"

    Write-Host "Realizando a consulta..." -ForegroundColor Yellow

    # Obtém a lista de pastas que atendem aos critérios
    $listaPastas = Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
        Get-ChildItem -Path D:\* -Directory | Where-Object {$_.Name -like "*_p*" -and $_.Name -notlike "*OLD*" -and $_.Name -notlike "*Teste*"}
    }

    # Obtém todos os compartilhamentos do servidor remoto 
    $compartilhamentos = Get-WmiObject -ComputerName $nomeServidor -Class Win32_Share | Where-Object {$_.Path -like "D:\*" -and $_.Name -notlike "\\OCSEN*" -and $_.Name -notlike "*_h*" -and $_.Name -notlike "D$" -and $_.Name -notlike "*csmcenter*" -and $_.Name -notlike "*config*"}

    # Itera sobre cada pasta encontrada
    foreach ($pasta in $listaPastas) {
        $pastaCompartilhada = $false

        # Compara com cada compartilhamento
        foreach ($compartilhamento in $compartilhamentos) {
            if ($pasta.FullName -eq $compartilhamento.Path) {
                $pastaCompartilhada = $true
                break
            }
        }

        # Exibe se a pasta está compartilhada ou não
        if ($pastaCompartilhada) {
            Write-Host "A pasta $($pasta.Name) está compartilhada."
        } else {
            Write-Host "A pasta $($pasta.Name) não está compartilhada." -ForegroundColor Red
        }
    }

    # Laço de repetição
    $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Não(N)"
    if ($restartScript -ne "S") {
        break
    }
}
