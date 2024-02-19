Clear-Host
Write-Host "Cria pasta de aplicação HCM" -ForegroundColor Green;

    $server = Read-Host "Digite o nome do servidor onde a aplicação será instalada";

Invoke-Command -ComputerName $server -ScriptBlock{
#COLETA AS INFORMAÇÕES
    $name = Read-Host "Digite o nome do cliente";
    $getCode = Read-Host "Digite o código do cliente";
    $tipAmb = Read-Host "Digite o tipo de ambiente (p para produção ou h para homologação) ";
    $cliente = $name + "_" + $getCode + "_" + $tipAmb;
        Write-Host Servidor = $server -ForegroundColor Yellow;
        Write-Host Cliente = $name -ForegroundColor Yellow;
        Write-Host Código = $getCode -ForegroundColor Yellow;
        Write-Host Tipo de ambiente = $tipAmb -ForegroundColor Yellow;
        Write-Host Pasta = $cliente -ForegroundColor Yellow;

#CRIA A PASTA
    New-Item -Path "D:\$cliente" -ItemType Directory;

#APLICA AS PERMISSÕES NTFS DE UM DIRETÓRIO DE ORIGEM
    $PERMISSIONS = Get-Acl -Path "D:\SeniorTI\Modelo\"
    Set-Acl -AclObject $PERMISSIONS -Path "D:\$cliente"

    Write-Host "Pasta criada com sucesso!!" -ForegroundColor Green;

#APLICA AS PERMISSÕES DO CLIENTE
    $PERMISSIONS = Get-ACL -Path "D:\$cliente\";
    $grupoCli = Read-Host "Digite o nome do GRUPO DO CLIENTE seguindo o padrão: MEGACLOUD\271 - DRIVETECH_HCM_HOMOLOGACAO";
    $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("$grupoCli","Modify", "ContainerInherit,ObjectInherit", "None", "Allow");
    $PERMISSIONS.SetAccessRule($NEWPERMISSION);
    $PERMISSIONS | Set-Acl -Path "D:\$cliente";

    Write-Host "Aplicando permissões e criando o compartilhamento da pasta..." -ForegroundColor Green;

#REALIZA O COMPARTILHAMENTO DA PASTA
#Caminho da pasta a ser compartilhada
    $folderPath = "D:\$cliente"

#Nome do compartilhamento
    $shareName = "$cliente" + "$"

#Cria o compartilhamento
    New-SmbShare -Path $folderPath -Name $shareName -FullAccess "MEGACLOUD\CloudOps", "MEGACLOUD\HCM MANAGER" -ChangeAccess "MEGACLOUD\Resolvedores Cloud", "$grupoCli"
        }

powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Pasta criada com sucesso!! Valide as permissões e se o compartilhamento da pasta está correto.','SUCESSO')}"
