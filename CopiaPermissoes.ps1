# Especifique o caminho do diretório que você deseja exportar as permissões
$diretorio = "\\ocmegtsmeta03\d`$\Clientes\Senior\*"

# Use Get-Acl para obter as informações de controle de acesso (permissions)
$acl = Get-Acl -Path $diretorio

# Especifique o caminho do arquivo de saída
$arquivoSaida = "X:\Resolvedores\Igor\Scripts\Permissões\PermissoesTSMETA03_SENIOR.txt"

# Exporte as informações de controle de acesso para o arquivo
$acl | Export-Clixml -Path $arquivoSaida

Write-Host "Permissões exportadas com sucesso para: $arquivoSaida"
