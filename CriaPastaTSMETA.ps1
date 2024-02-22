Clear-Host
Write-Host "Cria pasta CLIENT do HCM no servidor OCMEGTSHCM01" -ForegroundColor Green;

Invoke-Command -ComputerName ocmegtshcm01 -ScriptBlock{
#COLETA O PDB DO CLIENTE
    $codPDB = Read-Host "Qual o código PDB do cliente?"

#CRIA A PASTA PDB DO CLIENTE
    New-Item -Path "D:\Clientes\Senior\$codPDB" -ItemType Directory;

#APLICA AS PERMISSÕES NTFS DE UM DIRETÓRIO DE ORIGEM
    $PERMISSIONS = Get-Acl -Path "D:\Clientes\MODELO\"
    $PERMISSIONS.SetAccessRuleProtection($true, $false)
    Set-Acl -AclObject $PERMISSIONS -Path "D:\Clientes\Senior\$codPDB"

    Write-Host "Pasta criada com sucesso!!" -ForegroundColor Green;

#APLICA AS PERMISSÕES DO CLIENTE
    $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$codPDB\";
    $grupoCli = Read-Host "Digite o nome do GRUPO DE HOMOLOGAÇÃO DO CLIENTE seguindo o padrão 271 - DRIVETECH_HCM_HOMOLOGACAO";
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\$grupoCli","Modify", "ContainerInherit,ObjectInherit", "None", "Allow");
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$codPDB";

    $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$codPDB\";
    $grupoCli = Read-Host "Digite o nome do GRUPO DE PRODUÇÃO DO CLIENTE seguindo o padrão 271 - DRIVETECH_HCM_PRODUCAO";
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\$grupoCli","Modify", "ContainerInherit,ObjectInherit", "None", "Allow");
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

    Write-Host "Aplicando permissões..." -ForegroundColor Green;

#DEFINIÇÃO DE SUBPASTA DO CLIENTE
    $nomeCli = Read-Host "Qual será o nome da pasta do cliente?"
    $codCli = Read-Host "Qual o código HCM do cliente?"
    $clientHomol = $nomeCli + "_" + $codCli + "_" + "clienth"
    $clientProd = $nomeCli + "_" + $codCli + "_" + "clientp"

#CRIA AS PASTAS DE APLICAÇÃO DO CLIENTE
    New-Item -Path "D:\Clientes\Senior\$codPDB\$clientHomol" -ItemType Directory;
    New-Item -Path "D:\Clientes\Senior\$codPDB\$clientProd" -ItemType Directory;

        }

powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Pasta criada com sucesso!! Valide se as permissões estão corretas.','SUCESSO')}"
