Clear-Host
Write-Host "Cria pasta de aplicação HCM" -ForegroundColor Green;

$server = Read-Host "Digite o nome do servidor onde a aplicação será instalada";

Invoke-Command -ComputerName $server -ScriptBlock{
    <# Coletando as informações #>
    $name = Read-Host "Digite o nome do cliente";
    $getCode = Read-Host "Digite o código HCM do cliente";
    $tipAmb = Read-Host "Qual o tipo de ambiente? (p)Produção, (h)Homologação";
    $cliente = $name + "_" + $getCode + "_" + $tipAmb;
    Write-Host Servidor = $server -ForegroundColor Yellow;
    Write-Host Cliente = $name -ForegroundColor Yellow;
    Write-Host Código = $getCode -ForegroundColor Yellow;
    Write-Host Tipo de ambiente = $tipAmb -ForegroundColor Yellow;
    Write-Host Pasta = $cliente -ForegroundColor Yellow;

    <# Criando a pasta #>
    New-Item -Path "D:\$cliente" -ItemType Directory;

    <# Aplica as permissões NTFS de um diretório de origem #>
    $PERMISSIONS = Get-Acl -Path "D:\SeniorTI\Modelo\"
    Set-Acl -AclObject $PERMISSIONS -Path "D:\$cliente"

    Write-Host "Pasta criada com sucesso!!" -ForegroundColor Green;

    <# Aplica as permissões do cliente #>
    $PERMISSIONS = Get-ACL -Path "D:\$cliente\"
    $codPDB = Read-Host "Digite o código PDB do cliente"
    if ($tipAmb -eq "p") {
        $grupo1 = "MEGACLOUD\" + $codPDB + " - " + $name + "_HCM_Producao"
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupo1,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
        $PERMISSIONS.SetAccessRule($NEWPERMISSION)
        $PERMISSIONS | Set-Acl -Path "D:\$cliente"

        <# Cria o compartilhamento da pasta #>
            $folderPath = "D:\$cliente"
            $shareName = "$cliente" + "$"
            New-SmbShare -Path $folderPath -Name $shareName -FullAccess "MEGACLOUD\CloudOps", "MEGACLOUD\HCM MANAGER" -ChangeAccess "MEGACLOUD\Resolvedores Cloud", "$grupo1"

     }if ($tipAmb -eq "h") {
        $grupo2 = "MEGACLOUD\" + $codPDB + " - " + $name + "_HCM_Homologacao"
        $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule($grupo2,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
        $PERMISSIONS.SetAccessRule($NEWPERMISSION)
        $PERMISSIONS | Set-Acl -Path "D:\$cliente"

        <# Cria o compartilhamento da pasta #>
            $folderPath = "D:\$cliente"
            $shareName = "$cliente" + "$"
            New-SmbShare -Path $folderPath -Name $shareName -FullAccess "MEGACLOUD\CloudOps", "MEGACLOUD\HCM MANAGER" -ChangeAccess "MEGACLOUD\Resolvedores Cloud", "$grupo2"}

    Write-Host "Aplicando permissões e criando o compartilhamento da pasta..." -ForegroundColor Green;
}

powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Pasta criada com sucesso!! Valide as permissões e se o compartilhamento da pasta está correto.','SUCESSO')}"
