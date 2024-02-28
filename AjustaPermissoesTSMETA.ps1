Clear-Host

Write-Host "Ajuste de permissões no TSMETA"

$diretorio = Read-Host "Qual diretório você deseja manipular? (1)Dentro da pasta CLIENTES, (2)Dentro da pasta SENIOR"

if ($diretorio -eq "1") {
    Invoke-Command -ComputerName ocmegtshcm01 -ScriptBlock {
        <# Apresenta as pastas do diretório #>
        Get-ChildItem D:\Clientes\ | Format-Table Name

        $pasta = Read-Host "Qual pasta você deseja modificar? Confira acima e escreva aqui CORRETAMENTE o nome da pasta"

        <# Aplica as permissões NTFS de um diretório modelo #>
        $PERMISSIONS = Get-Acl -Path "D:\Clientes\MODELO\"
        $PERMISSIONS.SetAccessRuleProtection($true, $false)
        Set-Acl -AclObject $PERMISSIONS -Path "D:\Clientes\$pasta"

        $grupoPROD = Read-Host "Escreva corretamente o nome do grupo de PRODUÇÃO que você deseja inserir, no padrão 202 - CMK_RH_PROD"

        $grupoHML = Read-Host "Escreva corretamente o nome do grupo de HOMOLOGAÇÃO que você deseja inserir, no padrão 202 - CMK_RH_HOMOLOG"

        <# Aplica as permissões na pasta #>
        $PERMISSIONS = Get-ACL -Path "D:\Clientes\$pasta\";
        $grupoPRD = "MEGACLOUD\" + $grupoPROD
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupoPRD,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\Clientes\$pasta\";

        $PERMISSIONS = Get-ACL -Path "D:\Clientes\$pasta\";
        $grupoHML = "MEGACLOUD\" + $grupoHML
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupoHML,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\Clientes\$pasta\";

        $PERMISSIONS = Get-ACL -Path "D:\Clientes\$pasta\";
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\Resolvedores Cloud","Modify", "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\Clientes\$pasta\";

        $PERMISSIONS = Get-ACL -Path "D:\Clientes\$pasta\";
        $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\CloudOps", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS.SetOwner([System.Security.Principal.NTAccount]::new("MEGACLOUD\CloudOps"))
        $PERMISSIONS | Set-Acl -Path "D:\Clientes\$pasta\";

        $PERMISSIONS = Get-ACL -Path "D:\Clientes\$pasta\";
        $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\HCM Manager", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\Clientes\$pasta\";

    }
}

if ($diretorio -eq "2") {
    Invoke-Command -ComputerName ocmegtshcm01 -ScriptBlock {
        
        $numPasta = Read-Host "Digite o número da pasta que você deseja modificar"

        <# Aplica as permissões NTFS de um diretório modelo #>
        $PERMISSIONS = Get-Acl -Path "D:\Clientes\MODELO\"
        $PERMISSIONS.SetAccessRuleProtection($true, $false)
        Set-Acl -AclObject $PERMISSIONS -Path "D:\Clientes\Senior\$numPasta"

        $grupoPROD = Read-Host "Escreva corretamente o nome do grupo de PRODUÇÃO que você deseja inserir, no padrão 202 - CMK_RH_PROD"

        $grupoHML = Read-Host "Escreva corretamente o nome do grupo de HOMOLOGAÇÃO que você deseja inserir, no padrão 202 - CMK_RH_HOMOLOG"

        <# Aplica as permissões na pasta #>
        $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$numPasta\";
        $grupoPRD = "MEGACLOUD\" + $grupoPROD
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupoPRD,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$numPasta\";

        $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$numPasta\";
        $grupoHML = "MEGACLOUD\" + $grupoHML
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupoHML,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$numPasta\";

        $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$numPasta\";
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\Resolvedores Cloud","Modify", "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$numPasta\";

        $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$numPasta\";
        $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\CloudOps", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS.SetOwner([System.Security.Principal.NTAccount]::new("MEGACLOUD\CloudOps"))
        $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$numPasta\";

        $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$numPasta";
        $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\HCM Manager", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
        $PERMISSIONS.SetAccessRule($NEWPERMISSION);
        $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$numPasta\";

    }
}

<# Apresenta uma caixa de mensagem #>
powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Permissões aplicadas com sucesso!!!','SUCESSO')}"
