Clear-Host
Write-Host "Backup do banco HCM" -ForegroundColor Green;

Invoke-Command -ScriptBlock {
    #COLETA DE INFORMAÇÕES
    $getCode = Read-Host "Digite o código PDB do cliente";
    $pdb = "OCPDB$getCode";
    $schema = Read-Host "Digite o OWNER HCM do cliente";
    $getDate = Read-Host "Informe a data do backup no padrão 23012024";
    $dateSchema = $getDate + "_" + $schema

    Write-Host "EXPDP_BKP_$dateSchema" -ForegroundColor Green;

    Write-Host "Script de backup da base de dados:" -ForegroundColor Green;

    #DEFINE O COMANDO DE EXPORT
    Write-Host "cd C:\Oracle\product\12.2.0\client_1\bin";
    
    $expdpCommand = "expdp ""system/M_gA#sEN10r@$pdb"" directory=tmp_dir dumpfile=EXPDP_BKP_$dateSchema.dmp logfile=EXPDP_BKP_$dateSchema.log schemas=$schema flashback_time=systimestamp exclude=statistics logtime=all"
    
    Write-Host $expdpCommand;
    Write-Host "Executando backup da base de dados, AGUARDE A CONCLUSÃO e verifique o log em D:\SeniorTI\Backup" -ForegroundColor Green;
    
    #EXECUTA O COMANDO DE EXPORT E SALVA NO ARQUIVO DE LOG
    Invoke-Expression $expdpCommand *> "D:\SeniorTI\Backup\Log_Backup_$schema.txt"
}

powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Backup realizado com sucesso!!','CONCLUÍDO')}"
