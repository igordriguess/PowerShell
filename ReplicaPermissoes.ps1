#Lista os diretórios para armazená-los em um .TXT
Get-ChildItem -Path "\\OCMEGTSMETA03\d$\Clientes" | select name

#Realiza a leitura do arquivo .TXT, copia as permissões do diretório 1 e aplica no diretório 2
$content = Get-Content -Path "X:\Resolvedores\Igor\Scripts\Permissões\Lista.txt";
Foreach($line in $content){
	Get-Acl -Path "\\OCMEGTSMETA03\d$\Clientes\$line" | Set-Acl -Path "\\OCMEGTSHCM01\d$\Clientes\$line";
}

#Copia as permissões do diretório 1 e aplica no diretório 2
Get-Acl -Path "\\ocmegtsmeta03\d$\Clientes" | Set-Acl -Path "\\ocmegtshcm01\d$\Clientes";
