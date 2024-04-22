# Especifique o caminho do diretorio que voce deseja exportar as permissoes
$diretorio = "\\ocmegtshcm01\d$\Clientes\Senior\*"

# Use Get-Acl para obter as informacoess de controle de acesso (permissions)
$acl = Get-Acl -Path $diretorio

# Especifique o caminho do arquivo de sai­da
$arquivoSaida = "\\ocmegfs03\Datafiles$\Resolvedores\Igor\Scripts\Permissoes OCMEGTSHCM01\OCMEGTSHCM01_CLIENTES_SENIOR.txt"

# Exporte as informacoes de controle de acesso para o arquivo
$acl | Export-Clixml -Path $arquivoSaida

Write-Host "Permissoes exportadas com sucesso para: $arquivoSaida"
