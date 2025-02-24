# Verifica se o script está sendo executado como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "Reiniciando o script como Administrador..."
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}


While ($true) {
    Clear-Host
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host "MENU DE GERENCIAMENTO AD" -ForegroundColor Yellow
    Write-Host "==============================================" -ForegroundColor Cyan

    $domain = "DOMINIO_DO_CLIENTE"

    Write-Host "Domínio: $domain.com.br" -ForegroundColor Green

    Write-Host "---------------------------------------------------------------------"

    # Verifica se o módulo Active Directory está instalado
    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        Write-Host "O módulo Active Directory não está instalado. Instale-o antes de executar o script." -ForegroundColor Red
        exit
    }

    # Definição da OU padrão
    $OU_Padrao = "CN=Users,DC=$domain,DC=com,DC=br"

    # Função para consultar um usuário no AD pelo First Name
    function Get-ADUserInfo {
        param (
            [string]$FirstName
        )
        try {
            $users = Get-ADUser -Filter {GivenName -eq $FirstName} -Properties DisplayName, Mail, Enabled, SamAccountName, MemberOf
            if ($users) {
                Write-Host "Usuários encontrados:" -ForegroundColor Green
                $userTable = @()
                foreach ($user in $users) {
                    $groups = ($user.MemberOf | ForEach-Object { (Get-ADGroup $_).Name }) -join ", "
                    
                    # Define o status como "Ativo" ou "Inativo"
                    $status = if ($user.Enabled) { "Ativo" } else { "Inativo" }

                    $userTable += [PSCustomObject]@{
                        "Nome Completo"   = $user.DisplayName
                        "Usuário"         = $user.SamAccountName
                        "E-mail"          = $user.Mail
                        "Status"          = $status
                        "Grupos"          = $groups
                    }
                }
                $userTable | Format-Table -AutoSize -Wrap
            } else {
                Write-Host "Nenhum usuário encontrado com o First Name '$FirstName'." -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Erro ao consultar o usuário: $_" -ForegroundColor Red
        }
    }

    # Função para consultar TODOS os usuários no AD
    function Get-ADUserInfoALL {
        # Consulta todos os usuários no AD
        $users = Get-ADUser -Filter {
        SamAccountName -notlike "administrador" -and
        SamAccountName -notlike "administrator" -and
        SamAccountName -notlike "opc" -and
        SamAccountName -notlike "guest"
    } -Properties DisplayName, Mail, Enabled, SamAccountName, MemberOf

        if ($users) {
            Write-Host "Usuários encontrados:" -ForegroundColor Green
            $userTable = @()
            foreach ($user in $users) {
                # Verifica se o usuário pertence a algum grupo
                $groups = if ($user.MemberOf) {
                    ($user.MemberOf | ForEach-Object { (Get-ADGroup $_).Name }) -join ", "
                } else {
                    "Nenhum grupo"
                }

                # Define o status como "Ativo" ou "Inativo"
                $status = if ($user.Enabled) { "Ativo" } else { "Inativo" }

                $userTable += [PSCustomObject]@{
                    "Nome Completo" = $user.DisplayName
                    "Usuário"       = $user.SamAccountName
                    "E-mail"        = $user.Mail
                    "Status"        = $status
                    "Grupos"        = $groups
                }
            }
            $userTable | Format-Table -AutoSize -Wrap
        } else {
            Write-Host "Nenhum usuário encontrado." -ForegroundColor Yellow
        }
    }

    # Função para modificar os grupos de um usuário
    function Modify-UserGroups {
        param (
            [string]$SamAccountName
        )
        try {
            $user = Get-ADUser -Identity $SamAccountName -Properties MemberOf
            if ($user) {
                Write-Host "Grupos do usuário '$SamAccountName':" -ForegroundColor Green
                $user.MemberOf | ForEach-Object { (Get-ADGroup $_).Name } | Format-Table -AutoSize
                $action = Read-Host "Digite [A] para Adicionar ou [R] para Remover um grupo"
                if ($action -ieq "A") {
                    $grupoAdicionar = Read-Host "Digite o nome do grupo a adicionar"
                    Add-ADGroupMember -Identity $grupoAdicionar -Members $SamAccountName
                    Write-Host "Usuário '$SamAccountName' adicionado ao grupo '$grupoAdicionar'" -ForegroundColor Green
                } elseif ($action -ieq "R") {
                    $grupoRemover = Read-Host "Digite o nome do grupo a remover"
                    Remove-ADGroupMember -Identity $grupoRemover -Members $SamAccountName -Confirm:$false
                    Write-Host "Usuário '$SamAccountName' removido do grupo '$grupoRemover'" -ForegroundColor Yellow
                } else {
                    Write-Host "Opção inválida." -ForegroundColor Red
                }
            } else {
                Write-Host "Usuário '$SamAccountName' não encontrado." -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Erro ao modificar os grupos do usuário: $_" -ForegroundColor Red
        }
    }

    # Função para remover um usuário do AD
    function Remove-ADUserAccount {
        param (
            [string]$SamAccountName
        )
        try {
            Get-ADUser -Identity $SamAccountName | Remove-ADUser -Confirm:$false
            Write-Host "Usuário '$SamAccountName' removido com sucesso." -ForegroundColor Green
        } catch {
            Write-Host "Erro ao remover usuário: $_" -ForegroundColor Red
        }
    }

    # Função para criar um novo usuário no AD
    function New-ADUserAccount {
        param (
            [string]$SamAccountName,
            [string]$FirstName,
            [string]$LastName,
            [string]$Email,
            [string]$Cargo,
            [string]$Senha,
            [array]$Grupos
        )
        try {
            # Cria o novo usuário no Active Directory
            New-ADUser -SamAccountName $SamAccountName -GivenName $FirstName -Surname $LastName -DisplayName "$FirstName $LastName" `
                -Name "$FirstName $LastName" -UserPrincipalName "$SamAccountName@$domain.com.br" -EmailAddress $Email -Title $Cargo `
                -AccountPassword (ConvertTo-SecureString -AsPlainText $Senha -Force) -Enabled $true -PassThru | Out-Null

            # Adiciona o usuário aos grupos especificados
            foreach ($grupo in $Grupos) {
                Add-ADGroupMember -Identity $grupo -Members $SamAccountName
            }

            Write-Host "Usuário '$SamAccountName' criado e adicionado aos grupos." -ForegroundColor Green
        } catch {
            Write-Host "Erro ao criar o usuário: $_" -ForegroundColor Red
        }
    }

    # Função para resetar a senha do usuário no AD
    function Reset-ADUserPassword {
        param (
            [string]$SamAccountName
        )
        try {
            # Verifica se o usuário existe
            $user = Get-ADUser -Filter {SamAccountName -eq $SamAccountName} -SearchBase "DC=$domain,DC=com,DC=br" -Properties PasswordNeverExpires -ErrorAction Stop

            if ($user) {
                # Solicita a nova senha
                $novaSenha = Read-Host "Digite a nova senha" -AsSecureString

                # Desativa PasswordNeverExpires antes de resetar
                if ($user.PasswordNeverExpires -eq $true) {
                    Set-ADUser -Identity $user.DistinguishedName -PasswordNeverExpires $false
                }

                # Reseta a senha
                Set-ADAccountPassword -Identity $user.DistinguishedName -NewPassword $novaSenha -Reset

                # Pergunta se o usuário deve alterar a senha no próximo login
                $mudarSenha = Read-Host "O usuário deve alterar a senha no próximo login? (S/N)"
                if ($mudarSenha -ieq "S") {
                    Set-ADUser -Identity $user.DistinguishedName -ChangePasswordAtLogon $true
                } else {
                    Set-ADUser -Identity $user.DistinguishedName -ChangePasswordAtLogon $false
                }

                # Pergunta se a senha nunca deve expirar
                $senhaExpira = Read-Host "Marcar a opção para nunca expirar a senha? (S/N)"
                if ($senhaExpira -ieq "S") {
                    Set-ADUser -Identity $user.DistinguishedName -PasswordNeverExpires $true
                } else {
                    Set-ADUser -Identity $user.DistinguishedName -PasswordNeverExpires $false
                }

                Write-Host "Senha do usuário '$SamAccountName' foi resetada com sucesso." -ForegroundColor Green
            } else {
                Write-Host "Usuário '$SamAccountName' não encontrado." -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Erro ao resetar senha: $_" -ForegroundColor Red
        }
    }

    # Menu de opções
    Write-Host "[1] Consultar Usuário pelo Primeiro Nome"
    Write-Host "[2] Listar TODOS os usuários"
    Write-Host "[3] Criar Novo Usuário"
    Write-Host "[4] Remover Usuário"
    Write-Host "[5] Resetar Senha do Usuário"
    Write-Host "[6] Modificar Grupos do Usuário"
    Write-Host "[7] Inativar Usuário"
    Write-Host "[8] Ativar Usuário"
    Write-Host "[9] Sair do script" -ForegroundColor Red
    Write-Host "==============================================" -ForegroundColor Cyan

    $opcao = Read-Host "Escolha uma opção"

    switch ($opcao) {
        "1" {
            $firstName = Read-Host "Digite o Primeiro Nome do usuário"
            Get-ADUserInfo -FirstName $firstName
        }
        "2" {
        Get-ADUserInfoALL
        }
        "3" {
            $SamAccountName = Read-Host "Digite o nome de login do usuário (Ex. suporte.senior)"
            $FirstName = Read-Host "Digite o Primeiro Nome"
            $LastName = Read-Host "Digite o Segundo Nome"
            $Email = Read-Host "Digite o E-mail"
            $Cargo = Read-Host "Digite o Cargo do Usuário"
            $Senha = Read-Host "Digite a Senha (Mín. 8 caracteres)" -AsSecureString

            if ($Senha.Length -lt 8) {
                Write-Host "A senha deve ter pelo menos 8 caracteres." -ForegroundColor Red
            } else {
                $grupos = Read-Host "Digite os grupos separados por vírgula (Ex: TI,Financeiro,Administrativo)"
                $gruposArray = $grupos -split "," | ForEach-Object { $_.Trim() }
                New-ADUserAccount -SamAccountName $SamAccountName -FirstName $FirstName -LastName $LastName -Email $Email -Cargo $Cargo -Senha $Senha -Grupos $gruposArray
            }
        }
        "4" {
            $SamAccountName = Read-Host "Digite o nome de login do usuário a ser removido"

            # Verifica se o usuário existe antes de remover
            $user = Get-ADUser -Filter {SamAccountName -eq $SamAccountName} -ErrorAction SilentlyContinue

            if ($user) {
                Remove-ADUserAccount -SamAccountName $SamAccountName
            } else {
                Write-Host "Usuário '$SamAccountName' não encontrado." -ForegroundColor Yellow
            }
        }
        "5" {
            $SamAccountName = Read-Host "Digite o nome de login do usuário para resetar a senha"

            # Verifica se o usuário existe antes resetar a senha
            $user = Get-ADUser -Filter {SamAccountName -eq $SamAccountName} -ErrorAction SilentlyContinue

            if ($user) {
                Reset-ADUserPassword -SamAccountName $SamAccountName
            } else {
                Write-Host "Usuário '$SamAccountName' não encontrado." -ForegroundColor Yellow
            }

        }
        "6" {
            $SamAccountName = Read-Host "Digite o nome de login do usuário para modificar os grupos"
    
            # Verifica se o usuário existe antes de modificar os grupos
            $user = Get-ADUser -Filter {SamAccountName -eq $SamAccountName} -ErrorAction SilentlyContinue

            if ($user) {
                Modify-UserGroups -SamAccountName $SamAccountName
            } else {
                Write-Host "Usuário '$SamAccountName' não encontrado." -ForegroundColor Yellow
            }
        }
        "7" {
            $SamAccountName = Read-Host "Digite o nome de login do usuário a ser inativado"

            # Verifica se o usuário existe antes inativar
            $user = Get-ADUser -Filter {SamAccountName -eq $SamAccountName} -ErrorAction SilentlyContinue

            if ($user) {
                Disable-ADAccount -Identity $SamAccountName
                Write-Host "Usuário '$SamAccountName' inativado com sucesso!" -ForegroundColor Green
            } else {
                Write-Host "Usuário '$SamAccountName' não encontrado." -ForegroundColor Yellow
            }
        }
        "8" {
            $SamAccountName = Read-Host "Digite o nome de login do usuário a ser ativado"

            # Verifica se o usuário existe antes ativar
            $user = Get-ADUser -Filter {SamAccountName -eq $SamAccountName} -ErrorAction SilentlyContinue

            if ($user) {
                Enable-ADAccount -Identity $SamAccountName
                Write-Host "Usuário '$SamAccountName' ativado com sucesso!" -ForegroundColor Green
            } else {
                Write-Host "Usuário '$SamAccountName' não encontrado." -ForegroundColor Yellow
            }

        }
        "9" {
            Write-Host "Saindo..." -ForegroundColor Cyan
            exit
        }
        default {
            Write-Host "Opção inválida!" -ForegroundColor Red
        }
    }

    # Laço de repetição
    $restartScript = Read-Host -Prompt "Deseja reiniciar o script? (S/N)"
    if ($restartScript -ieq "S") {
        continue
    } else {
        break
    }
}

Exit
