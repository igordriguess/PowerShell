Clear-Host

Add-Type -AssemblyName Microsoft.VisualBasic

Write-Host "Script para criacao do DOMAIN e servico do Glassfish..." -ForegroundColor Green

Write-Host 'IMPORTANTE!! Antes de iniciar, valide quais portas serao utilizadas e se a pasta do Glassfish esta com o nome no padrao "glassfish4"' -ForegroundColor Yellow

$dirGlassfish = Read-Host "Informe a unidade de disco da pasta Glassfish [Exemplo: C]"
$user = Read-Host "Informe o usuario do servidor com o dominio [Exemplo srvlocal\senior]"
$pass = Read-Host "Informe a senha do usuario" -AsSecureString
# Converte a senha de SecureString para String
$pass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))

$defDomain = Read-Host "O dominio sera do Gestao do Ponto? (S)Sim, (N)Nao"
if ($defDomain -eq "S") 
{
$usrdatabase = Read-Host 'Digite o nome do usuario da base de dados [Exemplo: sa]'
$passdatabase = Read-Host 'Digite a senha do usuario' -AsSecureString
# Converte a senha de SecureString para String
$passdatabase = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passdatabase))
$database = Read-Host 'Digite o nome da base de dados [Exemplo: vetorh]'
$serverdatabase = Read-Host 'Digite o IP do banco [Exemplo: 192.168.3.5]'
$portNumber = Read-Host 'Qual a porta utilizada pelo banco? [Exemplo: 1433]'
}

$portConsole = Read-Host "Informe a porta do console Glassfish [Exemplo: 4848]"
$portHTTP = Read-Host "Informe a porta HTTP Listener1 [Exemplo: 8080]"
$portHTTPS = Read-Host "Informe a porta do HTTPS Listener2 [Exemplo: 8181]"
$nameDomain = Read-Host "Informe o nome do dominio [Exemplo: domain, domainteste, gestaoponto, gestaopontoteste]"

$scriptdir = "$dirGlassfish" + ":\glassfish4\Configura_glassfish_full"
$gfdir = "$dirGlassfish" + ":\glassfish4\glassfish\bin"
$gfdirdom = "$dirGlassfish" + ":\glassfish4\glassfish\domains"
$servername = hostname

#Write-Host $scriptdir -ForegroundColor Yellow
#Write-Host $gfdir -ForegroundColor Yellow
#Write-Host $gfdirdom -ForegroundColor Yellow

# Assume que $dirGlassfish contem a letra da unidade, como "C:"
$basePath = Join-Path -Path $scriptdir -ChildPath "\Senha_Glassfish"

# Verifica se a pasta "Senha_Glassfish" ja existe
if (-Not (Test-Path -Path $basePath)) {
    # Se a pasta não existir, cria a pasta
    New-Item -Path $basePath -ItemType Directory *> $null
}

# Conteudo do arquivo "pwdfile"
$pwdfileContent = "AS_ADMIN_PASSWORD=adminadmin"

# Constroi o caminho completo para o arquivo "pwdfile"
$pwdfilePath = Join-Path -Path $basePath -ChildPath "pwdfile"

# Cria ou sobrescreve o arquivo "pwdfile" com o conteúdo especificado
Set-Content -Path $pwdfilePath -Value $pwdfileContent

# Conteudo do arquivo "tmpfile"
$tmpfileContent = @"
AS_ADMIN_PASSWORD=
AS_ADMIN_NEWPASSWORD=adminadmin
"@

# Constroi o caminho completo para o arquivo "tmpfile"
$tmpfilePath = Join-Path -Path $basePath -ChildPath "tmpfile"

# Cria ou sobrescreve o arquivo "tmpfile" com o conteudo especificado
Set-Content -Path $tmpfilePath -Value $tmpfileContent

# Deleta .bat se existir
$FileName = "$scriptdir\1_Cria_Dominio.bat"
if (Test-Path $FileName) 
{
    Remove-Item $FileName
}

$FileName = "$scriptdir\2_Inicia_Dominio.bat"
if (Test-Path $FileName) 
{
    Remove-Item $FileName
}

$FileName = "$scriptdir\3_Altera_Senha_Dominio.bat"
if (Test-Path $FileName) 
{
    Remove-Item $FileName
}

$FileName = "$scriptdir\4_Reinicia_Dominio.bat"
if (Test-Path $FileName) 
{
    Remove-Item $FileName
}

$FileName = "$scriptdir\5_Ativa_Secure_Admin.bat"
if (Test-Path $FileName) 
{
    Remove-Item $FileName
}

$FileName = "$scriptdir\6_Cria_Servico.bat"
if (Test-Path $FileName) 
{
    Remove-Item $FileName
}

$FileName = "$scriptdir\7_Parar_Dominio.bat"
if (Test-Path $FileName) 
{
    Remove-Item $FileName
}

$FileName = "$scriptdir\8_Cria_Connection_Pool_GP.bat"
if (Test-Path $FileName) 
{
    Remove-Item $FileName
}

$FileName = "$scriptdir\9_Cria_Connection_Resource_GP.bat"
if (Test-Path $FileName) 
{
    Remove-Item $FileName
}

$FileName = "$scriptdir\91_Cria_Connection_Resource_GP.bat"
if (Test-Path $FileName) 
{
    Remove-Item $FileName
}

# Cria arquivos .bat do Glassfish
Add-Content $scriptdir\1_Cria_Dominio.bat -value "cd $gfdir" *> $null
Add-Content $scriptdir\1_Cria_Dominio.bat -value "asadmin.bat create-domain --user admin --nopassword true --savelogin --checkports=false --adminport $portConsole --instanceport $portHTTP $nameDomain" *> $null
Add-Content $scriptdir\2_Inicia_Dominio.bat -value "cd $gfdir" *> $null
Add-Content $scriptdir\2_Inicia_Dominio.bat -value "asadmin.bat start-domain $nameDomain" *> $null
Add-Content $scriptdir\3_Altera_Senha_Dominio.bat -value "cd $gfdir" *> $null
Add-Content $scriptdir\3_Altera_Senha_Dominio.bat -value "asadmin.bat change-admin-password --user admin --domain_name $nameDomain --passwordfile=$scriptdir\Senha_Glassfish\tmpfile" *> $null
Add-Content $scriptdir\4_Reinicia_Dominio.bat -value "cd $gfdir" *> $null
Add-Content $scriptdir\4_Reinicia_Dominio.bat -value "asadmin.bat restart-domain $nameDomain" *> $null
Add-Content $scriptdir\5_Ativa_Secure_Admin.bat -value "cd $gfdir" *> $null
Add-Content $scriptdir\5_Ativa_Secure_Admin.bat -value "asadmin.bat enable-secure-admin --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile" *> $null
Add-Content $scriptdir\6_Cria_Servico.bat -value "cd $gfdir" *> $null
Add-Content $scriptdir\6_Cria_Servico.bat -value "asadmin.bat create-service --name=$nameDomain --serviceproperties=DISPLAY_NAME=""Senior Glassfish 4 $nameDomain"" $nameDomain" *> $null
Add-Content $scriptdir\7_Parar_Dominio.bat -value "cd $gfdir" *> $null
Add-Content $scriptdir\7_Parar_Dominio.bat -value "asadmin.bat stop-domain $nameDomain" *> $null

# Executa scripts de criacao do dominio
cd $scriptdir
Start-Process 1_Cria_Dominio.bat
Start-Sleep -s 30
Start-Process 2_Inicia_Dominio.bat
Start-Sleep -s 15
Start-Process 3_Altera_Senha_Dominio.bat
Start-Sleep -s 10
Start-Process 4_Reinicia_Dominio.bat
Start-Sleep -s 30
Start-Process 5_Ativa_Secure_Admin.bat
Start-Sleep -s 15
Start-Process 4_Reinicia_Dominio.bat
Start-Sleep -s 30
Start-Process 6_Cria_Servico.bat
Start-Sleep -s 15

# Configura dominio Glassfish
cd $gfdir *> $null

# Cálculo automatico das portas
$jmxPort = [int]$portHTTPS + 505
$iioplistener = [int]$portConsole - 1148
$iiopservice1 = [int]$portConsole - 1028
$iiopservice2 = [int]$portConsole - 928
$telnetport = [int]$portConsole + 1818

.\asadmin.bat delete-jvm-options "-XX\:MaxPermSize=192m" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat create-jvm-options "-XX\:MaxPermSize=768m" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat delete-jvm-options "-\client" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat create-jvm-options "-\server" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat delete-jvm-options "-XX\:NewRatio=2" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat create-jvm-options "-Xrs" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat delete-jvm-options "-Xmx512m" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat create-jvm-options "-Xmx'2g'" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat create-jvm-options "-Xms'2g'" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat create-jvm-options "-Xmn512m" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat create-jvm-options "-XX\:+UseConcMarkSweepGC" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat create-jvm-options "-XX\:+UseParNewGC" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat create-jvm-options "-XX\:SurvivorRatio=20" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat create-jvm-options "-XX\:+CMSParallelRemarkEnabled" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
#.\asadmin.bat delete-jvm-options "-Dosgi.shell.telnet.port=6666" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
#.\asadmin.bat create-jvm-options "-Dosgi.shell.telnet.port=$telnetport" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
#.\asadmin.bat create-jvm-options "-Dhk2.parser.timeout=300" --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat set server.thread-pools.thread-pool.http-thread-pool.max-thread-pool-size=200 --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat set configs.config.server-config.network-config.protocols.protocol.http-listener-1.http.request-timeout-seconds=3600 --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-2.port=$portHTTPS --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat set configs.config.server-config.admin-service.jmx-connector.system.port=$jmxPort --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat set configs.config.server-config.iiop-service.iiop-listener.orb-listener-1.port=$iioplistener --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat set configs.config.server-config.iiop-service.iiop-listener.SSL.port=$iiopservice1 --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null
.\asadmin.bat set configs.config.server-config.iiop-service.iiop-listener.SSL_MUTUALAUTH.port=$iiopservice2 --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile *> $null

#############################################################

# Cálculo automatico da porta JMSProviderPort
$JMSProviderPort = [int]$portHTTPS - 505
# Realiza o ajute na porta JMSProviderPort
# Caminho para o arquivo de configuracao do Glassfish
$configFilePath = "$gfdirdom\$nameDomain\config\domain.xml"
# Nova porta que deseja definir
$newPort = "$JMSProviderPort"
# Ler o conteudo do arquivo XML
$content = Get-Content -Path $configFilePath -Raw
# Substituir a porta antiga pela nova
$content = $content -replace 'value="7676"', "value=`"$newPort`""
# Salvar o conteudo modificado de volta no arquivo
Set-Content -Path $configFilePath -Value $content

#############################################################

# Exibe as portas calculadas
#Write-Host "JMX Port: $jmxPort"
#Write-Host "IIOP Listener Port: $iioplistener"
#Write-Host "JMS Provider Port: $JMSProviderPort"
#Write-Host "IIOP Service 1 Port: $iiopservice1"
#Write-Host "IIOP Service 2 Port: $iiopservice2"
#Write-Host "JMSProviderPort Port: $JMSProviderPort"

cd $scriptdir *> $null

Start-Process 4_Reinicia_Dominio.bat
Start-Sleep -s 35

# Corrigindo a criacao do compartilhamento SMB
New-SMBShare -Name "$nameDomain$" -Path "$gfdirdom\$nameDomain" -FullAccess "$user" *> $null

# Ajusta permissoes
$acl = Get-Acl "$gfdirdom\$nameDomain"
$acl.SetAccessRuleProtection($true, $false)
$acl | Set-Acl "$gfdirdom\$nameDomain"

$ACLRULE = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($ACLRULE)
Set-Acl "$gfdirdom\$nameDomain" $acl

#$ACLRULE = New-Object System.Security.AccessControl.FileSystemAccessRule("srvlocal\igor", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
#$acl.AddAccessRule($ACLRULE)
#Set-Acl "$gfdirdom\$nameDomain" $acl

$ACLRULE = New-Object System.Security.AccessControl.FileSystemAccessRule("$user", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($ACLRULE)
Set-Acl "$gfdirdom\$nameDomain" $acl

Start-Process 7_Parar_Dominio.bat
Start-Sleep -s 15

# Ajusta o servico
cmd.exe /c sc config "$nameDomain" obj="$user" password="$pass" *> $null
cmd.exe /c sc config "$nameDomain" start=demand *> $null

# Inicia o servico
Start-Service "$nameDomain"

# Configura o domain do Gestao do Ponto
if ($defDomain -eq "S") 
{
$tipBanco = Read-Host "Qual o banco de dados utilizado? (1)SQL Server, (2)Oracle"

$urlBanco = $serverdatabase + ":" + $portNumber
$infoBancoSQL = "user" + "=" + $usrdatabase + ":password=" + $passdatabase + ":" + "url="
$infoBancoORA = "user" + "=" + $usrdatabase + ":password=" + $passdatabase + ":" + "url="

if ($tipBanco -eq "1") 
{
    Add-Content "$scriptdir\8_Cria_Connection_Pool_GP.bat" -Value "cd $gfdir" *> $null
    Add-Content "$scriptdir\8_Cria_Connection_Pool_GP.bat" -Value "asadmin.bat --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile create-jdbc-connection-pool --restype=java.sql.Driver --driverclassname=com.microsoft.sqlserver.jdbc.SQLServerDriver --property $infoBancoSQL'jdbc:sqlserver://$urlBanco;instanceName=MSSQLSERVER;databaseName=$database' $nameDomain-dataaccess" *> $null
    Add-Content "$scriptdir\9_Cria_Connection_Resource_GP.bat" -Value "cd $gfdir" *> $null
    Add-Content "$scriptdir\9_Cria_Connection_Resource_GP.bat" -Value "asadmin.bat --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile create-jdbc-resource --connectionpoolid $nameDomain-dataaccess jdbc/$nameDomain-dataaccess__pm" *> $null
    Add-Content "$scriptdir\91_Cria_Connection_Resource_GP.bat" -Value "cd $gfdir" *> $null
    Add-Content "$scriptdir\91_Cria_Connection_Resource_GP.bat" -Value "asadmin.bat --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile create-jdbc-resource --connectionpoolid $nameDomain-dataaccess jdbc/$nameDomain-dataaccess__nontx" *> $null
}
elseif ($tipBanco -eq "2") 
{
    Add-Content "$scriptdir\8_Cria_Connection_Pool_GP.bat" -Value "cd $gfdir" *> $null
    Add-Content "$scriptdir\8_Cria_Connection_Pool_GP.bat" -Value "asadmin.bat --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile create-jdbc-connection-pool --restype=java.sql.Driver --driverclassname=oracle.jdbc.driver.OracleDriver --property $infoBancoORA'jdbc:oracle:thin:@$urlBanco/$database.landb.lan.oraclevcn.com' $nameDomain-dataaccess" *> $null
    Add-Content "$scriptdir\9_Cria_Connection_Resource_GP.bat" -Value "cd $gfdir" *> $null
    Add-Content "$scriptdir\9_Cria_Connection_Resource_GP.bat" -Value "asadmin.bat --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile create-jdbc-resource --connectionpoolid $nameDomain-dataaccess jdbc/$nameDomain-dataaccess__pm" 
    Add-Content "$scriptdir\91_Cria_Connection_Resource_GP.bat" -Value "cd $gfdir" *> $null
    Add-Content "$scriptdir\91_Cria_Connection_Resource_GP.bat" -Value "asadmin.bat --port $portConsole --passwordfile=$scriptdir\Senha_Glassfish\pwdfile create-jdbc-resource --connectionpoolid $nameDomain-dataaccess jdbc/$nameDomain-dataaccess__nontx" *> $null
}
else
{
    Write-Host "Opcao invalida. Selecione (1) para SQL Server ou (2) para Oracle."
}

# Executa inclusao do JDBC no Glassfish
cd $scriptdir *> $null
Start-Sleep -s 15
Start-Process 8_Cria_Connection_Pool_GP.bat
Start-Sleep -s 10
Start-Process 9_Cria_Connection_Resource_GP.bat
Start-Sleep -s 10
Start-Process 91_Cria_Connection_Resource_GP.bat
Start-Sleep -s 10}

[Microsoft.VisualBasic.Interaction]::MsgBox("Dominio criado com sucesso!!")
