# Autor: Kayã Haufe Bedim

# Configurações de codificação
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8BOM'
chcp 65001 > $null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Importa utilidades
. "$PSScriptRoot\util.ps1"

function Show-Menu {
    Clear-Host
    $width = 110
    $border = "═" * $width
    $title = "MENU DE UTILIDADES"
    $padding = " " * [math]::Floor(($width - $title.Length) / 2)

    # Cabeçalho formatado
    Write-Host ""
    Write-Host "╔$border╗" -ForegroundColor Red
    Write-Host "║$padding$title$padding║" -ForegroundColor White
    Write-Host "╚$border╝" -ForegroundColor Red
    Write-Host ""

    # Opções centralizadas
    $opcoes = @(
    " [1]  Limpar Cache DNS (corrigir problemas de acesso a sites)",
    " [2]  Reiniciar Adaptador de Rede (corrigir problemas de conexão)",
    " [3]  Liberar Espaço em Disco (abrir limpeza de disco)",
    " [4]  Corrigir Arquivos do Sistema (sfc /scannow)",
    " [5]  Reiniciar Windows Explorer (corrigir travamentos da área de trabalho)",
    " [6]  Verificar Atualizações do Windows",
    " [7]  Testar Conexão com a Internet (ping)",
    " [8]  Verificar Uso de CPU/RAM",
    " [9]  Verificar Status de Ativação do Windows",
    " [10] Verificar Logs de Eventos (eventvwr)",
    " [11] Verificar Configurações de Proxy",
    " [12] Pesquisar no Google",
    " [13] Pesquisar no YouTube",
    " [0]  Sair"
    )
    foreach ($opcao in $opcoes) {
    $opcaoPadding = " " * [math]::Max(0, [math]::Floor(($width - $opcao.Length) / 2))
    Write-Host "$opcaoPadding$opcao$opcaoPadding" -ForegroundColor White
}

    Write-Host ""
    Write-Host ("─" * ($width + 2)) -ForegroundColor Red
}
function Invoke-Option {
    param ([int]$Option)

    switch ($Option) {
    1 { Clear-DnsCache }
    2 { Restart-NetworkAdapter }
    3 { Start-Process cleanmgr }
    4 { Repair-SystemFiles }
    5 { Restart-Explorer }
    6 { Check-WindowsUpdates }
    7 { Test-Internet }
    8 { Get-TopProcesses }
    9 { Check-WindowsActivation }
    10 { Start-Process eventvwr }
    11 { Check-ProxySettings }
    12 { Search-Google } # Pesquisar no Google
    13 { Search-Youtube } # Pesquisar no YouTube
    0 { Write-Host "`nSaindo... Até logo!`n" -ForegroundColor DarkYellow; exit }
    default { Write-Host "`n⚠️  Opção inválida. Tente novamente." -ForegroundColor Red }
}
}

do {
    Show-Menu
    $entrada = Read-Host "Digite o número da opção desejada"

    if ($entrada -match '^\d+$') {
        $opcao = [int]$entrada
        Invoke-Option $opcao
    }
    else {
        Write-Host "`n⚠️  Entrada inválida. Por favor, digite apenas números." -ForegroundColor Yellow
    }

    if ($opcao -ne 0) {
        Write-Host "`nPressione Enter para continuar..." -ForegroundColor DarkGray
        [void][Console]::ReadLine()
    }
} while ($opcao -ne 0)
