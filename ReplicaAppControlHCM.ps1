While ($true) {

Clear-Host;
Write-Host "Replicar aquivo 'appcontrol.ini' do HCM" -ForegroundColor Yellow;
    
    $server = "OCMEGTSHCM02"
    Test-Connection -Computername $server -BufferSize 16 -Count 1 -Quiet

    $server2 = "OCMEGTSHCM03"
    Test-Connection -Computername $server2 -BufferSize 16 -Count 1 -Quiet

    $server3 = "OCMEGTSHCM04"
    Test-Connection -Computername $server2 -BufferSize 16 -Count 1 -Quiet

    $server4 = "OCMEGTSHCM05"
    Test-Connection -Computername $server2 -BufferSize 16 -Count 1 -Quiet

    $copy = Read-Host "Digite (S) para replicar o AppControl do HCM"

    if($copy -eq "S"){
        Copy-Item -Path "\\OCMEGTSHCM01\c$\Program Files (x86)\TSplus\UserDesktop\files\AppControl.ini" -Destination "\\$server\c$\Program Files (x86)\TSplus\UserDesktop\files\"

         }if($copy -eq "S"){
        Copy-Item -Path "\\OCMEGTSHCM01\c$\Program Files (x86)\TSplus\UserDesktop\files\AppControl.ini" -Destination "\\$server2\c$\Program Files (x86)\TSplus\UserDesktop\files\"

         }if($copy -eq "S"){
        Copy-Item -Path "\\OCMEGTSHCM01\c$\Program Files (x86)\TSplus\UserDesktop\files\AppControl.ini" -Destination "\\$server3\c$\Program Files (x86)\TSplus\UserDesktop\files\"

         }if($copy -eq "S"){
        Copy-Item -Path "\\OCMEGTSHCM01\c$\Program Files (x86)\TSplus\UserDesktop\files\AppControl.ini" -Destination "\\$server4\c$\Program Files (x86)\TSplus\UserDesktop\files\"}

	Write-Host "O Arquivo AppControl foi replicado com sucesso!!"

    $restartScript = Read-Host -Prompt "Deseja reiniciar o script? Sim(S) Não(N)"
        if($restartScript -eq "S"){
            continue
        }else{
            break
        }
            }

break

Exit
