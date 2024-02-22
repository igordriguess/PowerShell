Clear-Host

Write-Host "Replica pasta de aplicação TSMETA - HCM" -ForegroundColor Green

Write-Host "IMPORTANTE - Executar este script após instalar manualmente a aplicação do cliente no servidor OCMEGTSHCM01" -ForegroundColor Yellow

Write-Host "Diretório padrão: D:\Clientes\Senior\CÓDIGO_PDB_CLIENTE\" -ForegroundColor Yellow

$Aplicacao = Read-Host "Qual o código PDB do cliente que corresponde a instalação realizada no OCMEGTSHCM01?"

#COPIA A PASTA OCMEGTSHCM02
    Copy-Item -Path \\ocmegtshcm01\d$\Clientes\Senior\$Aplicacao\ -Destination \\ocmegtshcm02\d$\Clientes\Senior\$Aplicacao\ -Recurse -Force -Passthru

#COPIA AS PERMISSÕES OCMEGTSHCM02
    $PERMISSIONS = Get-Acl -Path "\\ocmegtshcm01\d$\Clientes\Senior\$Aplicacao\"
    $PERMISSIONS.SetAccessRuleProtection($true, $false)
    Set-Acl -AclObject $PERMISSIONS -Path "\\ocmegtshcm02\d$\Clientes\Senior\$Aplicacao\"

#COPIA A PASTA OCMEGTSHCM03
    Copy-Item -Path \\ocmegtshcm01\d$\Clientes\Senior\$Aplicacao\ -Destination \\ocmegtshcm03\d$\Clientes\Senior\$Aplicacao\ -Recurse -Force -Passthru

#COPIA AS PERMISSÕES OCMEGTSHCM03
    $PERMISSIONS = Get-Acl -Path "\\ocmegtshcm01\d$\Clientes\Senior\$Aplicacao\"
    $PERMISSIONS.SetAccessRuleProtection($true, $false)
    Set-Acl -AclObject $PERMISSIONS -Path "\\ocmegtshcm03\d$\Clientes\Senior\$Aplicacao\"

#COPIA A PASTA OCMEGTSMETA03
    Copy-Item -Path \\ocmegtshcm01\d$\Clientes\Senior\$Aplicacao\ -Destination \\ocmegtsmeta03\d$\Clientes\Senior\$Aplicacao\ -Recurse -Force -Passthru

#COPIA AS PERMISSÕES OCMEGTSMETA03
    $PERMISSIONS = Get-Acl -Path "\\ocmegtshcm01\d$\Clientes\Senior\$Aplicacao\"
    $PERMISSIONS.SetAccessRuleProtection($true, $false)
    Set-Acl -AclObject $PERMISSIONS -Path "\\ocmegtsmeta03\d$\Clientes\Senior\$Aplicacao\"

#COPIA A PASTA OCMEGTSMETA04
    Copy-Item -Path \\ocmegtshcm01\d$\Clientes\Senior\$Aplicacao\ -Destination \\ocmegtsmeta04\d$\Clientes\Senior\$Aplicacao\ -Recurse -Force -Passthru

#COPIA AS PERMISSÕES OCMEGTSMETA04
    $PERMISSIONS = Get-Acl -Path "\\ocmegtshcm01\d$\Clientes\Senior\$Aplicacao\"
    $PERMISSIONS.SetAccessRuleProtection($true, $false)
    Set-Acl -AclObject $PERMISSIONS -Path "\\ocmegtsmeta04\d$\Clientes\Senior\$Aplicacao\"


powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Pasta replicada com sucesso!! Valide as permissões e a estrutura das pastas...','SUCESSO')}"
