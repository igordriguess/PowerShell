$ErrorActionPreference = "SilentlyContinue"

While ($true) {

Clear-Host

    Write-Host "Script de Manipulacao Geral HCM" -ForegroundColor Green

<# Pergunta qual o tipo de comando #>
    $tipComando = Read-Host "Ola usuario, o que você deseja fazer? (1)Cosultar um cliente, (2)Manipular um servico, (3)Manipular um processo"

<# Comando 1 - Consulta um cliente #>
#INICIO
    if ($tipComando -eq "1") {
    $computerName = "OCSENAPL01", "OCSENAPL02", "OCSENAPL03", "OCSENAPL04", "OCSENAPLH01", "OCSENINT01", "OCSENMDW01"

    #INFORMAcÕES DO CLIENTE
    Invoke-Command -ScriptBlock {
        $nome = Read-Host "Qual o nome do cliente?"
        $codCliQ = Read-Host "Sabe qual o codigo HCM do cliente? (S)Sim, (N)Nao"

        Write-Host "Confirme o codigo" -ForegroundColor Green

    if ($codCliQ -eq "N") {
        Get-WMIObject win32_service -ComputerName $computerName | Where-Object { $_.pathname -like "*$nome*" -and $_.name -like "*SeniorInstInfoService*" } | Format-Table -AutoSize PSComputerName, Name, State, PathName}

    $codCli = Read-Host "Digite o codigo do cliente"

    if ($codCliQ -eq "S") {
        Get-WMIObject win32_service -ComputerName $computerName | Where-Object {$_.pathname -like "*$nome*"} | Where-Object {$_.pathname -like "*$codCli*"} | Where-Object { $_.name -like "*SeniorInstInfoService*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName}

    $tipAmb = Read-Host "Qual o tipo de ambiente? (p)Producao, (h)Homologacao"
    $cliente = "$nome" + "_" + "$codCli" + "_" + "$tipAmb"

#DEFINE O TIPO DE CONSULTA E EXECUTA O COMANDO
    $tipConsulta = Read-Host "O que voce deseja consultar? (1) Servicos, (2) Aplicativos, (3) Aplicacoes Web, (4)Informacoes do Banco, (5)Versao do WS, (6)Todos"

    Write-Host "Realizando consulta..." -ForegroundColor Green

    if ($tipConsulta -eq "1") {
        Get-WMIObject win32_service -ComputerName $computerName | Where-Object { $_.pathname -like "*$cliente*" } | Format-Table -AutoSize PSComputerName, Name, State, PathName}

                if ($tipConsulta -eq "2") {
            Invoke-Command -ComputerName $computerName -ScriptBlock {
            $path = "D:\$using:cliente\Sapiens\"
            Get-ChildItem -Path $path | Where-Object { $_.Extension -eq '.exe' } | Where-Object { $_.Name -notlike '*altstrwin*' } |
            Where-Object { $_.Name -notlike '*bsserver*' } | Where-Object { $_.Name -notlike '*DiscoverNetwork*' } | Where-Object { $_.Name -notlike '*geraajuda*' } |
            Where-Object { $_.Name -notlike '*HTMLTranslator*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*IntegrationBackend64*' } | Where-Object { $_.Name -notlike '*motoresocial*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*OGU*' } | Where-Object { $_.Name -notlike '*prunsrv*' } | Where-Object { $_.Name -notlike '*rondaserver*' } | Where-Object { $_.Name -notlike '*rubiserver*' } |
            Where-Object { $_.Name -notlike '*smserver*' } | Where-Object { $_.Name -notlike '*TrImpExp*' } | Where-Object { $_.Name -notlike '*View*' } | Where-Object { $_.Name -notlike '*VisLog*' } |
            Where-Object { $_.Name -notlike '*WA*' } | Where-Object { $_.Name -notlike '*depurasid*' } | Where-Object { $_.Name -notlike '*erp_service*' } | Where-Object { $_.Name -notlike '*IntegradorReceituarioAgronomico*' } |
            Where-Object { $_.Name -notlike '*sapienssrv*' } | Where-Object { $_.Name -notlike '*server*' } | Format-Table Name, Extension, FullName
            }
                }if ($tipConsulta -eq "2") {
            Invoke-Command -ComputerName $computerName -ScriptBlock {
            $path = "D:\$using:cliente\Vetorh\"
            Get-ChildItem -Path $path | Where-Object { $_.Extension -eq '.exe' } | Where-Object { $_.Name -notlike '*altstrwin*' } |
            Where-Object { $_.Name -notlike '*bsserver*' } | Where-Object { $_.Name -notlike '*DiscoverNetwork*' } | Where-Object { $_.Name -notlike '*geraajuda*' } |
            Where-Object { $_.Name -notlike '*HTMLTranslator*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*IntegrationBackend64*' } | Where-Object { $_.Name -notlike '*motoresocial*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*OGU*' } | Where-Object { $_.Name -notlike '*prunsrv*' } | Where-Object { $_.Name -notlike '*rondaserver*' } | Where-Object { $_.Name -notlike '*rubiserver*' } |
            Where-Object { $_.Name -notlike '*smserver*' } | Where-Object { $_.Name -notlike '*TrImpExp*' } | Where-Object { $_.Name -notlike '*View*' } | Where-Object { $_.Name -notlike '*VisLog*' } |
            Where-Object { $_.Name -notlike '*jrserver*' } | Where-Object { $_.Name -notlike '*server*' } | Where-Object { $_.Name -notlike '*WA*' } | Format-Table Name, Extension, FullName
            }
                }if ($tipConsulta -eq "2") {
            Invoke-Command -ComputerName $computerName -ScriptBlock {
            $path = "D:\$using:cliente\SP\"
            Get-ChildItem -Path $path | Where-Object { $_.Extension -eq '.exe' } | Where-Object { $_.Name -notlike '*altstrwin*' } |
            Where-Object { $_.Name -notlike '*bsserver*' } | Where-Object { $_.Name -notlike '*DiscoverNetwork*' } | Where-Object { $_.Name -notlike '*geraajuda*' } |
            Where-Object { $_.Name -notlike '*HTMLTranslator*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*IntegrationBackend64*' } | Where-Object { $_.Name -notlike '*motoresocial*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*OGU*' } | Where-Object { $_.Name -notlike '*prunsrv*' } | Where-Object { $_.Name -notlike '*rondaserver*' } | Where-Object { $_.Name -notlike '*rubiserver*' } |
            Where-Object { $_.Name -notlike '*smserver*' } | Where-Object { $_.Name -notlike '*TrImpExp*' } | Where-Object { $_.Name -notlike '*View*' } | Where-Object { $_.Name -notlike '*VisLog*' } |
            Where-Object { $_.Name -notlike '*WA*' } | Where-Object { $_.Name -notlike '*server*' } | Where-Object { $_.Name -notlike '*SRVTCP*' } | Where-Object { $_.Name -notlike '*SServer*' } | Format-Table Name, Extension, FullName
            }
                }

            if ($tipConsulta -eq "3") {
                Invoke-Command -ComputerName $computerName -ScriptBlock {
            $path = "D:\$using:cliente\$using:cliente.cfg"
            Get-Content -Path $path | Where-Object { $_ -like "*url>https://webmg*" } | Where-Object { $_ -notlike "*connector_url*" } | Format-Table
                }
                    }

            if ($tipConsulta -eq "4") {
                Invoke-Command -ComputerName $computerName -ScriptBlock {
            $path = "D:\$using:cliente\$using:cliente.cfg"
            Get-Content -Path $path | Where-Object { $_ -like "*jdbc:oracle*"} | Format-Table
            Get-Content -Path $path | Where-Object { $_ -like "*username*"} | Format-Table
                }
                    }

            if ($tipConsulta -eq "5") {
                Invoke-Command -ComputerName $computerName -ScriptBlock {
            $path = "D:\$using:cliente\$using:cliente.cfg"
            Get-Content -Path $path | Where-Object { $_ -like "<ws_version>*</ws_version>"} | Format-Table
                }
                    }

            if ($tipConsulta -eq "6") {
            Get-WMIObject win32_service -ComputerName $computerName | Where-Object { $_.pathname -like "*$cliente*" } | Format-Table -AutoSize PSComputerName, Name, State, PathName
                }

                if ($tipConsulta -eq "6") {
            Invoke-Command -ComputerName $computerName -ScriptBlock {
            $path = "D:\$using:cliente\Sapiens\"
            Get-ChildItem -Path $path | Where-Object { $_.Extension -eq '.exe' } | Where-Object { $_.Name -notlike '*altstrwin*' } |
            Where-Object { $_.Name -notlike '*bsserver*' } | Where-Object { $_.Name -notlike '*DiscoverNetwork*' } | Where-Object { $_.Name -notlike '*geraajuda*' } |
            Where-Object { $_.Name -notlike '*HTMLTranslator*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*IntegrationBackend64*' } | Where-Object { $_.Name -notlike '*motoresocial*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*OGU*' } | Where-Object { $_.Name -notlike '*prunsrv*' } | Where-Object { $_.Name -notlike '*rondaserver*' } | Where-Object { $_.Name -notlike '*rubiserver*' } |
            Where-Object { $_.Name -notlike '*smserver*' } | Where-Object { $_.Name -notlike '*TrImpExp*' } | Where-Object { $_.Name -notlike '*View*' } | Where-Object { $_.Name -notlike '*VisLog*' } |
            Where-Object { $_.Name -notlike '*WA*' } | Where-Object { $_.Name -notlike '*depurasid*' } | Where-Object { $_.Name -notlike '*erp_service*' } | Where-Object { $_.Name -notlike '*IntegradorReceituarioAgronomico*' } |
            Where-Object { $_.Name -notlike '*sapienssrv*' } | Where-Object { $_.Name -notlike '*server*' } | Format-Table Name, Extension, FullName
            }
                }if ($tipConsulta -eq "6") {
            Invoke-Command -ComputerName $computerName -ScriptBlock {
            $path = "D:\$using:cliente\Vetorh\"
            Get-ChildItem -Path $path | Where-Object { $_.Extension -eq '.exe' } | Where-Object { $_.Name -notlike '*altstrwin*' } |
            Where-Object { $_.Name -notlike '*bsserver*' } | Where-Object { $_.Name -notlike '*DiscoverNetwork*' } | Where-Object { $_.Name -notlike '*geraajuda*' } |
            Where-Object { $_.Name -notlike '*HTMLTranslator*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*IntegrationBackend64*' } | Where-Object { $_.Name -notlike '*motoresocial*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*OGU*' } | Where-Object { $_.Name -notlike '*prunsrv*' } | Where-Object { $_.Name -notlike '*rondaserver*' } | Where-Object { $_.Name -notlike '*rubiserver*' } |
            Where-Object { $_.Name -notlike '*smserver*' } | Where-Object { $_.Name -notlike '*TrImpExp*' } | Where-Object { $_.Name -notlike '*View*' } | Where-Object { $_.Name -notlike '*VisLog*' } |
            Where-Object { $_.Name -notlike '*jrserver*' } | Where-Object { $_.Name -notlike '*server*' } | Where-Object { $_.Name -notlike '*WA*' } | Format-Table Name, Extension, FullName
            }
                }if ($tipConsulta -eq "6") {
            Invoke-Command -ComputerName $computerName -ScriptBlock {
            $path = "D:\$using:cliente\SP\"
            Get-ChildItem -Path $path | Where-Object { $_.Extension -eq '.exe' } | Where-Object { $_.Name -notlike '*altstrwin*' } |
            Where-Object { $_.Name -notlike '*bsserver*' } | Where-Object { $_.Name -notlike '*DiscoverNetwork*' } | Where-Object { $_.Name -notlike '*geraajuda*' } |
            Where-Object { $_.Name -notlike '*HTMLTranslator*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*IntegrationBackend64*' } | Where-Object { $_.Name -notlike '*motoresocial*' } | Where-Object { $_.Name -notlike '*IntegrationBackend32*' } |
            Where-Object { $_.Name -notlike '*OGU*' } | Where-Object { $_.Name -notlike '*prunsrv*' } | Where-Object { $_.Name -notlike '*rondaserver*' } | Where-Object { $_.Name -notlike '*rubiserver*' } |
            Where-Object { $_.Name -notlike '*smserver*' } | Where-Object { $_.Name -notlike '*TrImpExp*' } | Where-Object { $_.Name -notlike '*View*' } | Where-Object { $_.Name -notlike '*VisLog*' } |
            Where-Object { $_.Name -notlike '*WA*' } | Where-Object { $_.Name -notlike '*server*' } | Where-Object { $_.Name -notlike '*SRVTCP*' } | Where-Object { $_.Name -notlike '*SServer*' } | Format-Table Name, Extension, FullName
            }
                }

                if ($tipConsulta -eq "6") {
            Invoke-Command -ComputerName $computerName -ScriptBlock {
            $path = "D:\$using:cliente\$using:cliente.cfg"
            Get-Content -Path $path | Where-Object { $_ -like "*url>https://webmg*" } | Where-Object { $_ -notlike "*connector_url*" } | Format-List
            Get-Content -Path $path | Where-Object { $_ -like "*jdbc:oracle*"} | Format-List
            Get-Content -Path $path | Where-Object { $_ -like "*username*"} | Format-List
            Get-Content -Path $path | Where-Object { $_ -like "<ws_version>*</ws_version>"} | Format-List
            }
                }

#LACO DE REPETICAO
        $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Nao(N)"
        if($restartScript -eq "S"){
            continue
        }else{
            break
        }
            }
#FIM

<# Comando 2 - Manipula servicos de um cliente #>
#INÍCIO
        }if ($tipComando -eq "2") {
   Invoke-Command -ScriptBlock{
    $nome = Read-Host "Qual o nome do cliente?"
    $codCliQ = Read-Host "Sabe qual o codigo HCM do cliente? (S)Sim, (N)Nao"

    Write-Host "Confirme o codigo" -ForegroundColor Green

    if($codcliQ -eq "N"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.name -like "*SeniorInstInfoService*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName
            }

    $codCli = Read-Host "Digite o codigo do cliente"

       if($codCliQ -eq "S"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*$codCli*"} | Where-Object{$_.name -like "*SeniorInstInfoService*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName
            }

    $tipAmb = Read-Host "Qual o tipo de ambiente? (p)Producao, (h)Homologacao"
    $codAmb = $codCli + "_" + $tipAmb;
    Write-Host "Consultando cliente..." -ForegroundColor Green

#APRESENTA O STATUS DE TODOS OS SERVICOS DO CLIENTE
       Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} | Where-Object{$_.pathname -like "*$codAmb*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

#APRESENTA OS SERVICOS DO CLIENTE
    $service = Read-Host "Deseja manipular algum servico? (S)Sim, (N)Nao"

        if($service -eq "S"){
        $service = Read-Host "Qual servico você deseja manipular? (I)InfoService, (W)Wiipo, (M)Motor, (MD)Middleware, (CSM) CSM Center, (C)Concentradora, (INT)Integrador HCM, (T)Todos"

   }if($service -eq "N"){
   $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Nao(N)"
        if($restartScript -eq "S"){
            continue
        }else{
            break
        }
            }

#APRESENTA AS INFORMACOES COLETADAS
    Write-Host Nome = $nome -ForegroundColor Yellow
    Write-Host Servico = $service -ForegroundColor Yellow
    Write-Host codigo do cliente = $codCli -ForegroundColor Yellow
    Write-Host Ambiente = $tipAmb -ForegroundColor Yellow

     if($service -eq "I"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*SeniorInstInfoService*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "W"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Wiipo*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "M"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Motor*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "MD"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Middleware*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "CSM"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*CSMCenter*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "C"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Concentradora*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "INT"){
        Get-WMIObject win32_service -ComputerName OCSENINT01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*HCM_Integrador*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "T"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName
        }

#EXECUTA O COMANDO
    $comando = Read-Host "Qual o comando desejado? (1)Iniciar, (2)Parar, (3)Iniciar Todos, (4)Parar Todos"

#INICIAR SERVICO
      if($comando -eq "1" -and $service -eq "I"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*SeniorInstInfoService*"}).StartService()

     }if($comando -eq "1" -and $service -eq "W"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Wiipo*"}).StartService()

     }if($comando -eq "1" -and $service -eq "M"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Motor*"}).StartService()

     }if($comando -eq "1" -and $service -eq "MD"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Middleware*"}).StartService()

     }if($comando -eq "1" -and $service -eq "CSM"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*CSMCenter*"}).StartService()

     }if($comando -eq "1" -and $service -eq "C"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Concentradora*"}).StartService()

     }if($comando -eq "1" -and $service -eq "INT"){
        (Get-WMIObject win32_service -ComputerName OCSENINT01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*HCM_Integrador*"}).StartService()

     }if($comando -eq "3" -and $service -eq "T"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"}).StartService()
        }

#PARA O SERVICO
      if($comando -eq "2" -and $service -eq "I"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*SeniorInstInfoService*"}).StopService()

     }if($comando -eq "2" -and $service -eq "W"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Wiipo*"}).StopService()

     }if($comando -eq "2" -and $service -eq "M"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Motor*"}).StopService()

     }if($comando -eq "2" -and $service -eq "MD"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Middleware*"}).StopService()

     }if($comando -eq "2" -and $service -eq "CSM"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*CSMCenter*"}).StopService()

     }if($comando -eq "2" -and $service -eq "C"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Concentradora*"}).StopService()

     }if($comando -eq "2" -and $service -eq "INT"){
        (Get-WMIObject win32_service -ComputerName OCSENINT01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*HCM_Integrador*"}).StopService()

     }if($comando -eq "4" -and $service -eq "T"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"}).StopService()
            }

#APRESENTA O STATUS DO SERVICO MANIPULADO APoS EXECUCAO DO COMANDO
      if($service -eq "I"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*SeniorInstInfoService*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "W"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Wiipo*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "M"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Motor*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "MD"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Middleware*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "CSM"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*CSMCenter*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "C"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Concentradora*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "INT"){
        Get-WMIObject win32_service -ComputerName OCSENINT01| Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*HCM_Integrador*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName
     }

#APRESENTA O STATUS DE TODOS OS SERVICOS DO CLIENTE
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

#CONFIRMA SE O USUARIO DESEJA MANIPULAR MAIS ALGUM SERVICO
        $service = Read-Host "Deseja manipular mais algum servico? (S)Sim, (N)Nao"

    if($service -eq "S"){
        $service = Read-Host "Qual servico você deseja manipular? (I)InfoService, (W)Wiipo, (M)Motor, (MD)Middleware, (CSM) CSM Center, (C)Concentradora, (INT)Integrador HCM, (T)Todos"

    if($service -eq "I"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*SeniorInstInfoService*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "W"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Wiipo*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "M"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Motor*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "MD"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Middleware*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "CSM"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*CSMCenter*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "C"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Concentradora*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "INT"){
        Get-WMIObject win32_service -ComputerName OCSENINT01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*HCM_Integrador*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "T"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName
        }

#TIPO DE COMANDO
    $comando = Read-Host "Qual o comando desejado? (1)Iniciar, (2)Parar, (3)Iniciar Todos, (4)Parar Todos"

#INICIA O SERVICO
      if($comando -eq "1" -and $service -eq "I"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*SeniorInstInfoService*"}).StartService()

     }if($comando -eq "1" -and $service -eq "W"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Wiipo*"}).StartService()

     }if($comando -eq "1" -and $service -eq "M"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Motor*"}).StartService()

     }if($comando -eq "1" -and $service -eq "MD"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Middleware*"}).StartService()

     }if($comando -eq "1" -and $service -eq "CSM"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*CSMCenter*"}).StartService()

     }if($comando -eq "1" -and $service -eq "C"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Concentradora*"}).StartService()

     }if($comando -eq "1" -and $service -eq "INT"){
        (Get-WMIObject win32_service -ComputerName OCSENINT01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*HCM_Integrador*"}).StartService()

     }if($comando -eq "3" -and $service -eq "T"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"}).StartService()
        }

#PARA O SERVICO
      if($comando -eq "2" -and $service -eq "I"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*SeniorInstInfoService*"}).StopService()

     }if($comando -eq "2" -and $service -eq "W"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Wiipo*"}).StopService()

     }if($comando -eq "2" -and $service -eq "M"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Motor*"}).StopService()

     }if($comando -eq "2" -and $service -eq "MD"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Middleware*"}).StopService()

     }if($comando -eq "2" -and $service -eq "CSM"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*CSMCenter*"}).StopService()

     }if($comando -eq "2" -and $service -eq "C"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Concentradora*"}).StopService()

     }if($comando -eq "2" -and $service -eq "INT"){
        (Get-WMIObject win32_service -ComputerName OCSENINT01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*HCM_Integrador*"}).StopService()

     }if($comando -eq "4" -and $service -eq "T"){
        (Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"}).StopService()
            }

#APRESENTA O STATUS DO SERVICO MANIPULADO APOS EXECUCAO DO COMANDO
      if($service -eq "I"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*SeniorInstInfoService*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "W"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Wiipo*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "M"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Motor*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "MD"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Middleware*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "CSM"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*CSMCenter*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "C"){
        Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*Concentradora*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

     }if($service -eq "INT"){
        Get-WMIObject win32_service -ComputerName OCSENINT01| Where-Object{$_.pathname -like "*$nome*"} |
        Where-Object{$_.pathname -like "*_$codAmb*"} | Where-Object{$_.pathname -like "*HCM_Integrador*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName
     }

#APRESENTA O STATUS DE TODOS OS SERVICOS DO CLIENTE
    Get-WMIObject win32_service -ComputerName OCSENAPL01, OCSENAPL02, OCSENAPL03, OCSENAPL04, OCSENAPLH01, OCSENINT01, OCSENMDW01 | Where-Object{$_.pathname -like "*$nome*"} |
    Where-Object{$_.pathname -like "*_$codAmb*"} | Format-Table -AutoSize PSComputerName, Name, State, PathName

        }if($service -eq "N"){
        $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Nao(N)"
        if($restartScript -eq "S"){
            continue
        }else{
            break
        }
            }

#LACO DE REPETICAO
$restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Nao(N)"
        if($restartScript -eq "S"){
            continue
        }else{
            break
        }
            }
#FIM

<# Comando 3 - Manipula processos #>
#INICIO
            }if ($tipComando -eq "3") {
    $computerName = Read-Host "Digite o nome do servidor remoto"

    Invoke-Command -ComputerName $computerName -ScriptBlock{
    $cliente = Read-Host "Qual o nome do cliente?"
    $tipAmb = Read-Host "Qual o tipo de ambiente? (P)Producao, (H)Homologacao"

    Write-Host "Consultando processos..." -ForegroundColor Yellow

#CONSULTA OS PROCESSOS EM EXECUCAO
    Get-Process -Name * | Where-Object {$_.path -like "*$cliente*"} | Where-Object {$_.path -like "*_$tipAmb*"} | Format-Table -AutoSize ID, ProcessName, Path

    $processo = Read-Host "Deseja Encerrar algum processo? (S)Sim, (N)Nao"

    if($processo -eq "S"){
    $comando = Read-Host "Digite o ID do processo que você deseja encerrar"

#ENCERRA O PROCESSO DESEJADO
    Get-Process | Where-Object  {$_.id -like "*$comando*"} | Stop-Process -Force

    Write-Host "Processo encerrado com sucesso!!" -ForegroundColor Yellow

    Get-Process -Name * | Where-Object {$_.path -like "*$cliente*"} | Where-Object {$_.path -like "*_$tipAmb*"} | Format-Table -AutoSize ID, ProcessName, Path
    }
        }
    }else{
            break
        }

#LACO DE REPETICAO
$restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Nao(N)"
        if($restartScript -eq "S"){
            continue
        }else{
            break
        }
            }
#FIM

Exit
