while ($true) {
    Clear-Host
    Write-Host "Script para consultar os compartilhamentos de PRODUÇÃO do HCM" -ForegroundColor Green

    # Define o nome do servidor remoto
    $nomeServidor = "OCSENAPLH01"

    Write-Host "Realizando a consulta no servidor OCSENAPLH01" -ForegroundColor Yellow

    # Obtém a lista de pastas que atendem aos critérios
    $listaPastas = Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
        Get-ChildItem -Path D:\* -Directory | Where-Object {
            $_.Name -like "*_p*" -and $_.Name -notlike "*OLD*" -and $_.Name -notlike "*Teste*"
        }
    }

    # Obtém todos os compartilhamentos do servidor remoto 
    $compartilhamentos = Get-WmiObject -ComputerName $nomeServidor -Class Win32_Share | Where-Object {
        $_.Path -like "D:\*" -and $_.Name -notlike "\\OCSEN*" -and $_.Name -notlike "*_h*" -and $_.Name -notlike "D$" -and $_.Name -notlike "*csmcenter*" -and $_.Name -notlike "*config*"
    }

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

        # Verifica se a pasta está compartilhada e compartilha se necessário
        if ($pastaCompartilhada) {
            Write-Host "A pasta $($pasta.Name) está compartilhada."
        } else {
            Write-Host "A pasta $($pasta.Name) não está compartilhada." -ForegroundColor Red
            
            # Define o nome do compartilhamento
            $nomeCompartilhamento = $pasta.Name + "$"

            # Obtém a lista de grupos diferentes para compartilhar
            $gruposFull = @("MEGACLOUD\CloudOps", "MEGACLOUD\HCM MANAGER")

            # Obtém a ACL da pasta e filtra os grupos apropriados
            $acl = Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
                param ($pasta)
                $acl = Get-Acl -Path $pasta.FullName
                $filteredGroups = $acl.Access | Where-Object { $_.IdentityReference -match "RH" } | Select-Object -ExpandProperty IdentityReference
                return $filteredGroups
            } -ArgumentList $pasta

            $ChangeAccess = $acl -replace '.*\\(.*?)$', '$1'

            # Obtém a lista de grupos para conceder permissões de alteração
            $grupoChangeAccess = @("MEGACLOUD\Resolvedores Cloud", "MEGACLOUD\$ChangeAccess")

            # Compartilha a pasta sem alterar permissões NTFS
            Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
                param ($nomeCompartilhamento, $caminhoPasta, $gruposFull, $grupoChangeAccess)
    
                # Cria o compartilhamento mantendo as permissões NTFS existentes
                New-SmbShare -Name $nomeCompartilhamento -Path $caminhoPasta -FullAccess $gruposFull -ChangeAccess $grupoChangeAccess | Out-Null
            } -ArgumentList $nomeCompartilhamento, $pasta.FullName, $gruposFull, $grupoChangeAccess
            
            Write-Host "A pasta $($pasta.Name) foi compartilhada como \\$nomeServidor\$nomeCompartilhamento." -ForegroundColor Green
        }
    }

    # Define o nome do servidor remoto
    $nomeServidor = "OCSENAPL01"

    Write-Host "Realizando a consulta no servidor OCSENAPL01" -ForegroundColor Yellow

    # Obtém a lista de pastas que atendem aos critérios
    $listaPastas = Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
        Get-ChildItem -Path D:\* -Directory | Where-Object {
            $_.Name -like "*_p*" -and $_.Name -notlike "*OLD*" -and $_.Name -notlike "*Teste*"
        }
    }

    # Obtém todos os compartilhamentos do servidor remoto 
    $compartilhamentos = Get-WmiObject -ComputerName $nomeServidor -Class Win32_Share | Where-Object {
        $_.Path -like "D:\*" -and $_.Name -notlike "\\OCSEN*" -and $_.Name -notlike "*_h*" -and $_.Name -notlike "D$" -and $_.Name -notlike "*csmcenter*" -and $_.Name -notlike "*config*"
    }

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

        # Verifica se a pasta está compartilhada e compartilha se necessário
        if ($pastaCompartilhada) {
            Write-Host "A pasta $($pasta.Name) está compartilhada."
        } else {
            Write-Host "A pasta $($pasta.Name) não está compartilhada." -ForegroundColor Red
            
            # Define o nome do compartilhamento
            $nomeCompartilhamento = $pasta.Name + "$"

            # Obtém a lista de grupos diferentes para compartilhar
            $gruposFull = @("MEGACLOUD\CloudOps", "MEGACLOUD\HCM MANAGER")

            # Obtém a ACL da pasta e filtra os grupos apropriados
            $acl = Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
                param ($pasta)
                $acl = Get-Acl -Path $pasta.FullName
                $filteredGroups = $acl.Access | Where-Object { $_.IdentityReference -match "RH" } | Select-Object -ExpandProperty IdentityReference
                return $filteredGroups
            } -ArgumentList $pasta

            $ChangeAccess = $acl -replace '.*\\(.*?)$', '$1'

            # Obtém a lista de grupos para conceder permissões de alteração
            $grupoChangeAccess = @("MEGACLOUD\Resolvedores Cloud", "MEGACLOUD\$ChangeAccess")

            # Compartilha a pasta sem alterar permissões NTFS
            Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
                param ($nomeCompartilhamento, $caminhoPasta, $gruposFull, $grupoChangeAccess)
    
                # Cria o compartilhamento mantendo as permissões NTFS existentes
                New-SmbShare -Name $nomeCompartilhamento -Path $caminhoPasta -FullAccess $gruposFull -ChangeAccess $grupoChangeAccess | Out-Null
            } -ArgumentList $nomeCompartilhamento, $pasta.FullName, $gruposFull, $grupoChangeAccess
            
            Write-Host "A pasta $($pasta.Name) foi compartilhada como \\$nomeServidor\$nomeCompartilhamento." -ForegroundColor Green
        }
    }

    # Define o nome do servidor remoto
    $nomeServidor = "OCSENAPL02"

    Write-Host "Realizando a consulta no servidor OCSENAPL02" -ForegroundColor Yellow

    # Obtém a lista de pastas que atendem aos critérios
    $listaPastas = Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
        Get-ChildItem -Path D:\* -Directory | Where-Object {
            $_.Name -like "*_p*" -and $_.Name -notlike "*OLD*" -and $_.Name -notlike "*Teste*"
        }
    }

    # Obtém todos os compartilhamentos do servidor remoto 
    $compartilhamentos = Get-WmiObject -ComputerName $nomeServidor -Class Win32_Share | Where-Object {
        $_.Path -like "D:\*" -and $_.Name -notlike "\\OCSEN*" -and $_.Name -notlike "*_h*" -and $_.Name -notlike "D$" -and $_.Name -notlike "*csmcenter*" -and $_.Name -notlike "*config*"
    }

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

        # Verifica se a pasta está compartilhada e compartilha se necessário
        if ($pastaCompartilhada) {
            Write-Host "A pasta $($pasta.Name) está compartilhada."
        } else {
            Write-Host "A pasta $($pasta.Name) não está compartilhada." -ForegroundColor Red
            
            # Define o nome do compartilhamento
            $nomeCompartilhamento = $pasta.Name + "$"

            # Obtém a lista de grupos diferentes para compartilhar
            $gruposFull = @("MEGACLOUD\CloudOps", "MEGACLOUD\HCM MANAGER")

            # Obtém a ACL da pasta e filtra os grupos apropriados
            $acl = Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
                param ($pasta)
                $acl = Get-Acl -Path $pasta.FullName
                $filteredGroups = $acl.Access | Where-Object { $_.IdentityReference -match "RH" } | Select-Object -ExpandProperty IdentityReference
                return $filteredGroups
            } -ArgumentList $pasta

            $ChangeAccess = $acl -replace '.*\\(.*?)$', '$1'

            # Obtém a lista de grupos para conceder permissões de alteração
            $grupoChangeAccess = @("MEGACLOUD\Resolvedores Cloud", "MEGACLOUD\$ChangeAccess")

            # Compartilha a pasta sem alterar permissões NTFS
            Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
                param ($nomeCompartilhamento, $caminhoPasta, $gruposFull, $grupoChangeAccess)
    
                # Cria o compartilhamento mantendo as permissões NTFS existentes
                New-SmbShare -Name $nomeCompartilhamento -Path $caminhoPasta -FullAccess $gruposFull -ChangeAccess $grupoChangeAccess | Out-Null
            } -ArgumentList $nomeCompartilhamento, $pasta.FullName, $gruposFull, $grupoChangeAccess
            
            Write-Host "A pasta $($pasta.Name) foi compartilhada como \\$nomeServidor\$nomeCompartilhamento." -ForegroundColor Green
        }
    }

    # Define o nome do servidor remoto
    $nomeServidor = "OCSENAPL03"

    Write-Host "Realizando a consulta no servidor OCSENAPL03" -ForegroundColor Yellow

    # Obtém a lista de pastas que atendem aos critérios
    $listaPastas = Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
        Get-ChildItem -Path D:\* -Directory | Where-Object {
            $_.Name -like "*_p*" -and $_.Name -notlike "*OLD*" -and $_.Name -notlike "*Teste*"
        }
    }

    # Obtém todos os compartilhamentos do servidor remoto 
    $compartilhamentos = Get-WmiObject -ComputerName $nomeServidor -Class Win32_Share | Where-Object {
        $_.Path -like "D:\*" -and $_.Name -notlike "\\OCSEN*" -and $_.Name -notlike "*_h*" -and $_.Name -notlike "D$" -and $_.Name -notlike "*csmcenter*" -and $_.Name -notlike "*config*"
    }

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

        # Verifica se a pasta está compartilhada e compartilha se necessário
        if ($pastaCompartilhada) {
            Write-Host "A pasta $($pasta.Name) está compartilhada."
        } else {
            Write-Host "A pasta $($pasta.Name) não está compartilhada." -ForegroundColor Red
            
            # Define o nome do compartilhamento
            $nomeCompartilhamento = $pasta.Name + "$"

            # Obtém a lista de grupos diferentes para compartilhar
            $gruposFull = @("MEGACLOUD\CloudOps", "MEGACLOUD\HCM MANAGER")

            # Obtém a ACL da pasta e filtra os grupos apropriados
            $acl = Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
                param ($pasta)
                $acl = Get-Acl -Path $pasta.FullName
                $filteredGroups = $acl.Access | Where-Object { $_.IdentityReference -match "RH" } | Select-Object -ExpandProperty IdentityReference
                return $filteredGroups
            } -ArgumentList $pasta

            $ChangeAccess = $acl -replace '.*\\(.*?)$', '$1'

            # Obtém a lista de grupos para conceder permissões de alteração
            $grupoChangeAccess = @("MEGACLOUD\Resolvedores Cloud", "MEGACLOUD\$ChangeAccess")

            # Compartilha a pasta sem alterar permissões NTFS
            Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
                param ($nomeCompartilhamento, $caminhoPasta, $gruposFull, $grupoChangeAccess)
    
                # Cria o compartilhamento mantendo as permissões NTFS existentes
                New-SmbShare -Name $nomeCompartilhamento -Path $caminhoPasta -FullAccess $gruposFull -ChangeAccess $grupoChangeAccess | Out-Null
            } -ArgumentList $nomeCompartilhamento, $pasta.FullName, $gruposFull, $grupoChangeAccess
            
            Write-Host "A pasta $($pasta.Name) foi compartilhada como \\$nomeServidor\$nomeCompartilhamento." -ForegroundColor Green
        }
    }

    # Define o nome do servidor remoto
    $nomeServidor = "OCSENAPL04"

    Write-Host "Realizando a consulta no servidor OCSENAPL04" -ForegroundColor Yellow

    # Obtém a lista de pastas que atendem aos critérios
    $listaPastas = Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
        Get-ChildItem -Path D:\* -Directory | Where-Object {
            $_.Name -like "*_p*" -and $_.Name -notlike "*OLD*" -and $_.Name -notlike "*Teste*"
        }
    }

    # Obtém todos os compartilhamentos do servidor remoto 
    $compartilhamentos = Get-WmiObject -ComputerName $nomeServidor -Class Win32_Share | Where-Object {
        $_.Path -like "D:\*" -and $_.Name -notlike "\\OCSEN*" -and $_.Name -notlike "*_h*" -and $_.Name -notlike "D$" -and $_.Name -notlike "*csmcenter*" -and $_.Name -notlike "*config*"
    }

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

        # Verifica se a pasta está compartilhada e compartilha se necessário
        if ($pastaCompartilhada) {
            Write-Host "A pasta $($pasta.Name) está compartilhada."
        } else {
            Write-Host "A pasta $($pasta.Name) não está compartilhada." -ForegroundColor Red
            
            # Define o nome do compartilhamento
            $nomeCompartilhamento = $pasta.Name + "$"

            # Obtém a lista de grupos diferentes para compartilhar
            $gruposFull = @("MEGACLOUD\CloudOps", "MEGACLOUD\HCM MANAGER")

            # Obtém a ACL da pasta e filtra os grupos apropriados
            $acl = Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
                param ($pasta)
                $acl = Get-Acl -Path $pasta.FullName
                $filteredGroups = $acl.Access | Where-Object { $_.IdentityReference -match "RH" } | Select-Object -ExpandProperty IdentityReference
                return $filteredGroups
            } -ArgumentList $pasta

            $ChangeAccess = $acl -replace '.*\\(.*?)$', '$1'

            # Obtém a lista de grupos para conceder permissões de alteração
            $grupoChangeAccess = @("MEGACLOUD\Resolvedores Cloud", "MEGACLOUD\$ChangeAccess")

            # Compartilha a pasta sem alterar permissões NTFS
            Invoke-Command -ComputerName $nomeServidor -ScriptBlock {
                param ($nomeCompartilhamento, $caminhoPasta, $gruposFull, $grupoChangeAccess)
    
                # Cria o compartilhamento mantendo as permissões NTFS existentes
                New-SmbShare -Name $nomeCompartilhamento -Path $caminhoPasta -FullAccess $gruposFull -ChangeAccess $grupoChangeAccess | Out-Null
            } -ArgumentList $nomeCompartilhamento, $pasta.FullName, $gruposFull, $grupoChangeAccess
            
            Write-Host "A pasta $($pasta.Name) foi compartilhada como \\$nomeServidor\$nomeCompartilhamento." -ForegroundColor Green
        }
    }

    # Laço de repetição
    $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Não(N)"
    if ($restartScript -ne "S") {
        break
    }
}
