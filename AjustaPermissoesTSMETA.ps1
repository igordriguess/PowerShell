Clear-Host

Write-Host "Ajuste de permissoes no TSMETA"

Invoke-Command -ComputerName ocmegtshcm01 -ScriptBlock {
        
    $numPasta = Read-Host "Qual o codigo PDB do cliente que voce deseja modificar?"

    $grupoPROD = Read-Host "Escreva corretamente o nome do grupo de PRODUCAO que voce deseja inserir, no padrao '231 - NAMOUR_RH_PRODUCAO'"

    $grupoHML = Read-Host "Escreva corretamente o nome do grupo de HOMOLOGACAO que voce deseja inserir, no padrao '231 - NAMOUR_RH_HOMOLOGACAO'"

    # Remove todas as permissoes existentes e desabilita a heranca
    $PERMISSIONS = Get-ACL -Path "D:\Clientes\Senior\$numPasta"
    $PERMISSIONS.SetAccessRuleProtection($true, $false) # Desabilita a heranca sem remover as permissoes atuais
    $PERMISSIONS.Access | ForEach-Object { $PERMISSIONS.RemoveAccessRule($_) }
    Set-Acl -Path "D:\Clientes\Senior\$numPasta" -AclObject $PERMISSIONS

    # Aplica as novas permissoes na pasta
    $grupoPRD = "MEGACLOUD\" + $grupoPROD
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupoPRD,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$numPasta\";

    $grupoHML = "MEGACLOUD\" + $grupoHML
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupoHML,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$numPasta\";

    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\Resolvedores Cloud","Modify", "ContainerInherit,ObjectInherit", "None", "Allow");
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$numPasta\";

    $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\CloudOps", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS.SetOwner([System.Security.Principal.NTAccount]::new("MEGACLOUD\CloudOps"))
    $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$numPasta\";

    $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl;
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("MEGACLOUD\HCM Manager", $fullControl, "ContainerInherit,ObjectInherit", "None", "Allow");
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS | Set-Acl -Path "D:\Clientes\Senior\$numPasta\";

}

# Apresenta uma caixa de mensagem
powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Permissoes aplicadas com sucesso!!!','SUCESSO')}"
