While ($true) {

Clear-Host

Write-Host "AppControl HCM" -ForegroundColor Green

$tipComando = Read-Host "O que você deseja fazer? (1)Consultar os aplicativos de um cliente, (2)Inserir um aplicativo"

#COMANDO 1
       if($tipComando -eq "1"){
        Invoke-Command -ComputerName OCMEGTSMETA03 -ScriptBlock {
        $cliente = Read-Host "Qual o nome do cliente?"
        $AppControl = "\\ocmegtsmeta03\c$\Program Files (x86)\TSplus\UserDesktop\files\AppControl.ini"
        Get-Content -Path $AppControl | Where-Object { $_ -like "*$cliente*" } | Where-Object { $_ -like "*.exe*" } | Format-Table -AutoSize
          }
             }
        
#COMANDO 2
        if($tipComando -eq "2"){
Write-Host "Manipulando o AppControl HCM" -ForegroundColor Green

Write-Host "Servidor OCMEGTSMETA03" -ForegroundColor Yellow

Write-Host "Segue número do último aplicativo:" -ForegroundColor Magenta

#APRESENTA A ULTIMA LINHA COM O FILTRO APP2 NO APPCONTROL.INI
Invoke-Command -ComputerName OCMEGTSMETA03 -ScriptBlock {
    $AppControl = "\\ocmegtsmeta03\c$\Program Files (x86)\TSplus\UserDesktop\files\AppControl.ini"
    (Get-Content -Path $AppControl | Where-Object { $_ -like "*App2*" } | Select-Object -Last 1).Trim()

#DEFINIÇÃO DAS VARIÁVEIS
$app = Read-Host "Qual o número do aplicativo? Insira o próximo número do valor apresentado anteriormente"
$appname = Read-Host "Qual o nome do aplicativo? Ex. Teste"
$path = Read-Host "Qual o diretório do path? Ex. D:\Teste\Teste\teste.exe"
$startup = Read-Host "Qual o diretório de inicialização? E. D:\Teste\Teste\"
$cmdline = Read-Host "Qual o comando de inicialização? Ex. -impeso (Deixe em branco caso não tenha comando)"
$groups = Read-Host "Quais os grupos pertencentes ao aplicativo? Ex. MEGACLOUD\Teste"
$folder = Read-Host "Qual o nome do ambiente? Ex. TESTE - HML"

#INSERIR DADOS NO APPCONTROL.INI
    $linesToAdd = @(
        "", #Linha em branco
        "[App$app]",
        "appname=$appname",
        "path=$path",
        "startup=$startup",
        "cmdline=$cmdline",
        "groups=$groups",
        "users=",
        "maximized=no",
        "minimized=no",
        "hide=no",
        "all_users=no",
        "folder=$folder"
    )

    foreach ($line in $linesToAdd) {
        Add-Content -Path $AppControl -Value $line
    }

#APRESENTA AS LINHAS INSERIDAS
    Write-Host App = $app -ForegroundColor Yellow
    Write-Host AppName = $appname -ForegroundColor Yellow
    Write-Host Path = $path -ForegroundColor Yellow
    Write-Host Startup = $startup -ForegroundColor Yellow
    Write-Host cmdline = $cmdline -ForegroundColor Yellow
    Write-Host groups = $groups -ForegroundColor Yellow
    Write-Host folder = $folder -ForegroundColor Yellow

Write-Host "AppControl modificado!! Confira se está correto e replique para os demais servidores." -ForegroundColor Green
      }
            }

#LAÇO DE REPETIÇÃO
$restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Não(N)"
        if($restartScript -eq "S"){
            continue
        }else{
            break
        }

}

Exit
