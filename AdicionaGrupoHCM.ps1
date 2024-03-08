Clear-Host

Write-Host "Filtra os GRUPOS em massa no Active Directory e adiciona em um GRUPO especifico..." -ForegroundColor Green

$grupoHCM = Read-Host "Em qual GRUPO voce deseja adicionar? EX: TODOS-HCM-RUBI-HML"

$condicao = Read-Host "Qual a condicao a ser alterada? EX: RH_Homologacao"

# Conecte-se ao Active Directory
Import-Module ActiveDirectory

# Defina o padrão do grupo
$grupoPadrao = "*$condicao"

# Obtenha todos os grupos que correspondem ao padrão
$grupos = Get-ADGroup -Filter { Name -like $grupoPadrao }

# Lista os grupos
foreach ($grupo in $grupos) {
    Write-Host "Realizando consulta..." -ForegroundColor Green
    Write-Host "Nome do grupo: $($grupo.Name)"
    #Write-Host "DistinguishedName: $($grupo.DistinguishedName)"
    Write-Host "-----"

    # Obtém o nome do cliente e o número do cliente
    $NomeCliente = ($grupo.Name -split '_')[0]
    $NumCli = ($grupo.Name -split '_')[1]

    # Cria o nome completo do grupo
    $nomeGrupoCompleto = "$NumCli - $NomeCliente"

    $question = Read-Host 'O filtro aplicado esta correto? Confirme o resultado acima... (S)Sim e APLICAR, (N)Nao e SAIR'

    if($question -eq "S"){
        Add-ADGroupMember -Identity "CN=$grupoHCM,OU=HCM,OU=Grupos de Acessos Sistemas,OU=Grupos,OU=Datacenter,DC=megacloud,DC=local" -Members $grupo

        powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Alteracao realizada com sucesso!!','SUCESSO')}"

    }if($question -eq "N"){
        break
    }
        }
