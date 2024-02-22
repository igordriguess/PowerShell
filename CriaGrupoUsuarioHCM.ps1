(Import-module activedirectory)

<# -- Coletando as informações para criar a OU do cliente -- #>
Write-Host "Coletando as informações do Cliente" -ForegroundColor Green
$NumCli = Read-Host -Prompt "Digite o numero do cliente"
$NomeCli = Read-Host -Prompt "Digite o nome do cliente"

<# -- Rotina para criar a OU do cliente -- #>
Write-Host "Criando as OU's do Cliente $NumCli - $NomeCli ..." -ForegroundColor Green
dsadd OU "OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
dsadd OU "OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
dsadd OU "OU=Usuarios,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"

    $hcm_prod = "$NomeCli" + "_" + "HCM_Producao";
    $hcm_homolog = "$NomeCli" + "_" + "HCM_Homologacao";
    $edocs_prod = "$NomeCli" + "_" + "eDocs_Producao";
    $edocs_homolog = "$NomeCli" + "_" + "eDocs_Homologacao";
    $arquivos_prod = "$NomeCli" + "_" + "Arquivos_Producao";
    $arquivos_homolog = "$NomeCli" + "_" + "Arquivos_Homologacao";

<# -- Rotina para criar os grupos padrões na OU do cliente -- #>
New-ADGroup -Name "$NumCli - $NomeCli" -SamAccountName "$NumCli - $NomeCli" -Path "OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -GroupScope Global -GroupCategory Security
New-ADGroup -Name "$NumCli - $hcm_prod" -SamAccountName "$NumCli - $hcm_prod" -Path "OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -GroupScope Global -GroupCategory Security
New-ADGroup -Name "$NumCli - $hcm_homolog" -SamAccountName "$NumCli - $hcm_homolog" -Path "OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -GroupScope Global -GroupCategory Security
New-ADGroup -Name "$NumCli - $edocs_prod" -SamAccountName "$NumCli - $edocs_prod" -Path "OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -GroupScope Global -GroupCategory Security
New-ADGroup -Name "$NumCli - $edocs_homolog" -SamAccountName "$NumCli - $edocs_homolog" -Path "OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -GroupScope Global -GroupCategory Security
New-ADGroup -Name "$NumCli - $arquivos_prod" -SamAccountName "$NumCli - $arquivos_prod" -Path "OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -GroupScope Global -GroupCategory Security
New-ADGroup -Name "$NumCli - $arquivos_homolog" -SamAccountName "$NumCli - $arquivos_homolog" -Path "OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -GroupScope Global -GroupCategory Security

<# -- Rotina para pegar os parâmetros para criar o usuário HCM na OU do cliente -- #>
$SenhaUsuario = Read-Host -Prompt "Digite a senha do usuário" -AsSecureString

    $CriaUserHCM = @{
    'Path'                  = "OU=Usuarios,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
    'Name'                  = "$NumCli - HCM"
    'GivenName'             = "$NumCli -"
    'Surname'               = "HCM" 
    'displayname'           = "$NumCli - HCM"
    'SamAccountName'        = "$NumCli.hcm"
    'UserPrincipalName'     = "$NumCli.hcm@megacloud.local"
    'Description'           = "Usuário utilizado pelo consultor da Mega Sistemas"
    'HomeDirectory'         = "\\ocmegfs06\home$\$NumCli.hcm"
    'HomeDrive'             = "H:"
    'AccountPassword'       = $SenhaUsuario
    'Enabled'               = $true
    'ChangePasswordAtLogon' = $false 
    'PasswordNeverExpires'  = $true 
      
    }

<# -- Rotina para criar o diretório HOME do usuário HCM, no servidor OCMEGFS06 -- #>
New-Item -Path \\ocmegfs06\home$\$NumCli.hcm -ItemType directory

<# -- Comando para criar o usuário HCM do cliente  -- #>
New-ADUser @CriaUserHCM

<# -- Rotina para adicionar o usuário HCM nos grupos -- #>
Add-ADGroupMember -Identity "CN=$NumCli - $NomeCli,OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -Members "CN=$NumCli - HCM,OU=Usuarios,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
Add-ADGroupMember -Identity "CN=App - FloatingPanel,OU=Grupos de Acessos Sistemas,OU=Grupos,OU=Datacenter,DC=megacloud,DC=local" -Members "CN=$NumCli - HCM,OU=Usuarios,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
Add-ADGroupMember -Identity "CN=$NumCli - $hcm_prod,OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -Members "CN=$NumCli - HCM,OU=Usuarios,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
Add-ADGroupMember -Identity "CN=$NumCli - $hcm_homolog,OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -Members "CN=$NumCli - HCM,OU=Usuarios,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
Add-ADGroupMember -Identity "CN=$NumCli - $edocs_prod,OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -Members "CN=$NumCli - HCM,OU=Usuarios,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
Add-ADGroupMember -Identity "CN=$NumCli - $edocs_homolog,OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -Members "CN=$NumCli - HCM,OU=Usuarios,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
Add-ADGroupMember -Identity "CN=$NumCli - $arquivos_prod,OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -Members "CN=$NumCli - HCM,OU=Usuarios,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
Add-ADGroupMember -Identity "CN=$NumCli - $arquivos_homolog,OU=Grupos,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local" -Members "CN=$NumCli - HCM,OU=Usuarios,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
Add-ADGroupMember -Identity "CN=Editor de usuario Mega Cloud,OU=Grupos de Acessos Globais,OU=Grupos,OU=Datacenter,DC=megacloud,DC=local" -Members "CN=$NumCli - HCM,OU=Usuarios,OU=$NumCli - $NomeCli,OU=Clientes,DC=megacloud,DC=local"
