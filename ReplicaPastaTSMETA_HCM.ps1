Clear-Host

Write-Host "Replica a pasta de aplicação TSMETA - HCM" -ForegroundColor Green

Write-Host "IMPORTANTE: Execute este script após instalar manualmente a aplicação do cliente no servidor OCMEGTSHCM01" -ForegroundColor Yellow

Write-Host "Diretório padrão: D:\Clientes\Senior\CODIGO_PDB_CLIENTE\" -ForegroundColor Yellow

$Aplicacao = Read-Host "Qual o código PDB do cliente que corresponde à instalação realizada no OCMEGTSHCM01?"

# Copia a pasta OCMEGTSHCM02
robocopy "\\ocmegtshcm01\d$\Clientes\Senior\$Aplicacao\" "\\OCMEGTSHCM02\d$\Clientes\Senior\$Aplicacao\" /E /COPYALL /LOG+:\\ocmegfs03\Datafiles$\Resolvedores\Igor\Scripts\Automação\TSMETA\AjusteTSMETA\LogOCMEGTSHCM02.txt

# Copia a pasta OCMEGTSHCM03
robocopy "\\ocmegtshcm01\d$\Clientes\Senior\$Aplicacao\" "\\OCMEGTSHCM03\d$\Clientes\Senior\$Aplicacao\" /E /COPYALL /LOG+:\\ocmegfs03\Datafiles$\Resolvedores\Igor\Scripts\Automação\TSMETA\AjusteTSMETA\LogOCMEGTSHCM03.txt

# Copia a pasta OCMEGTSMETA03
robocopy "\\ocmegtshcm01\d$\Clientes\Senior\$Aplicacao\" "\\OCMEGTSHCM04\d$\Clientes\Senior\$Aplicacao\" /E /COPYALL /LOG+:\\ocmegfs03\Datafiles$\Resolvedores\Igor\Scripts\Automação\TSMETA\AjusteTSMETA\LogOCMEGTSHCM04.txt

powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Pasta replicada com sucesso!! Valide as permissões e a estrutura das pastas...','SUCESSO')}"
