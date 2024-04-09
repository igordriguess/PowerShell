Clear-Host
Write-Host "Cria pasta CLIENT do HCM no servidor OCMEGTSHCM01" -ForegroundColor Green;

Invoke-Command -ComputerName ocmegtshcm01 -ScriptBlock {
    # Coleta o PDB do cliente
    $codPDB = Read-Host "Qual o código PDB do cliente?"

    # Cria a pasta do cliente
    New-Item -Path "D:\Clientes\Senior\$codPDB" -ItemType Directory;

    Write-Host "Pasta criada com sucesso!!" -ForegroundColor Green;

    # Definição de subpasta do cliente
    $nomeCli = Read-Host "Qual o nome do cliente?"
    $codCli = Read-Host "Qual o código HCM do cliente?"
    $clientHomol = $nomeCli + "_" + $codCli + "_" + "clienth"
    $clientProd = $nomeCli + "_" + $codCli + "_" + "clientp"

    # Remove todas as permissões existentes e desabilita a herança
    $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$codPDB"
    $PERMISSIONS.SetAccessRuleProtection($true, $false) # Desabilita a herança sem remover as permissões atuais
    $PERMISSIONS.Access | ForEach-Object { $PERMISSIONS.RemoveAccessRule($_) }
    Set-Acl -Path "D:\Clientes\Senior\$codPDB" -AclObject $PERMISSIONS

    # Aplica as novas permissões na pasta
    $grupoPROD = "HCM_PROD_" + $codPDB
    $grupoPRD = "MEGACLOUD\" + $grupoPROD
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupoPRD,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $PERMISSIONS.AddAccessRule($NEWPERMISSION)

    # Aplica as permissões do cliente
    $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$codPDB\";
    $grupoPRD = "MEGACLOUD\" + $codPDB + " - " + $nomeCli + "_HCM_PRODUCAO"
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupoPRD,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$codPDB";

    $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$codPDB\";
    $grupoHML = "MEGACLOUD\" + $codPDB + " - " + $nomeCli + "_HCM_HOMOLOGACAO"
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupoHML,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$codPDB";

    $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$codPDB\";
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\Resolvedores Cloud","Modify", "ContainerInherit,ObjectInherit", "None", "Allow");
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$codPDB";

    $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$codPDB\";
    $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\CloudOps", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$codPDB";

    $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$codPDB\";
    $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\HCM Manager", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$codPDB";

    # Define o proprietário da pasta
    $acl = Get-Acl -Path "D:\Clientes\Senior\$codPDB\"
    $owner = New-Object System.Security.Principal.NTAccount("MEGACLOUD\CloudOps")
    $acl.SetOwner($owner)
    Set-Acl -Path "D:\Clientes\Senior\$codPDB\" -AclObject $acl

    Write-Host "Aplicando permissões..." -ForegroundColor Green;

    # Definição de subpasta do cliente
    $clientHomol = $nomeCli + "_" + $codCli + "_" + "clienth"
    $clientProd = $nomeCli + "_" + $codCli + "_" + "clientp"

    # Cria as pastas de aplicação do cliente
    New-Item -Path "D:\Clientes\Senior\$codPDB\$clientHomol" -ItemType Directory;
    New-Item -Path "D:\Clientes\Senior\$codPDB\$clientProd" -ItemType Directory;
}

powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Pasta criada com sucesso!! Valide se as permissões estão corretas.','SUCESSO')}"
