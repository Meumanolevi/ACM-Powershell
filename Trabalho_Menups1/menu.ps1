# Feito por: Glenda e Levi 1IF3

# Configurações de codificação
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8BOM'
chcp 65001 > $null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Importa utilidades
. "$PSScriptRoot\util.ps1"

function Show-Welcome {
    Clear-Host
    $width = 105
    $border = "═" * $width
    $title = "BEM-VINDO"
    $padding = " " * [math]::Floor(($width - $title.Length) / 2)

    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host "      ╔$border╗" -ForegroundColor Red
    Write-Host "      ║$padding$title$padding║" -ForegroundColor White
    Write-Host "      ╚$border╝" -ForegroundColor Red
    Write-Host ""
    Write-Host (" " * [math]::Floor(($width - 44) / 2)) "           Desenvolvido por Glenda e Levi do 1IF3" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host ("─" * ($width + 15)) -ForegroundColor Red
    Start-Sleep -Seconds 3

    # Efeito de carregando
    Write-Host ""
    for ($i=0; $i -lt 3; $i++) {
        Write-Host (" " * [math]::Floor($width/2)) -NoNewline
        Write-Host "." -NoNewline -ForegroundColor Yellow
        Start-Sleep -Milliseconds 400
    }
    Write-Host ""
    Start-Sleep -Seconds 1
}


function Show-Menu {
    Clear-Host
    $width = 110
    $border = "═" * $width
    $title = "MENU DE UTILIDADES DE CORREÇÂO"
    $padding = " " * [math]::Floor(($width - $title.Length) / 2)

    # Cabeçalho formatado
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host "   ╔$border╗" -ForegroundColor Red
    Write-Host "   ║$padding$title$padding║" -ForegroundColor White
    Write-Host "   ╚$border╝" -ForegroundColor Red
    Write-Host ""

    # Opções centralizadas
    $opcoes = @(
    " [1]  🧹 Limpar Cache DNS (corrigir problemas de acesso a sites)",
    " [2]  🌐 Reiniciar Adaptador de Rede (corrigir problemas de conexão)",
    " [3]  💾 Liberar Espaço em Disco (abrir limpeza de disco)",
    " [4]  🛠️ Corrigir Arquivos do Sistema (sfc /scannow)",
    " [5]  🔄 Reiniciar Windows Explorer (corrigir travamentos da área de trabalho)",
    " [6]  📝 Verificar Atualizações do Windows",
    " [7]  📶 Testar Conexão com a Internet (ping)",
    " [8]  📊 Verificar Uso de CPU/RAM",
    " [9]  🔑 Verificar Status de Ativação do Windows",
    " [10] 🗂️ Verificar Logs de Eventos (eventvwr)",
    " [11] 🌍 Verificar Configurações de Proxy",
    " [12] 🔎 Pesquisar no Google",
    " [13] ▶️ Pesquisar no YouTube",
    " [0]  🚪 Sair"
)
    foreach ($opcao in $opcoes) {
    $cor = if ($opcao -like "*[0]*Sair*") { "Yellow" } else { "Cyan" }
    $opcaoPadding = " " * [math]::Max(0, [math]::Floor(($width - $opcao.Length) / 2))
    Write-Host "$opcaoPadding$opcao$opcaoPadding" -ForegroundColor $cor
}

    Write-Host ""
    Write-Host ("─" * ($width + 10)) -ForegroundColor Red

    # Rodapé formatado
    
    $footer2Padding = " " * [math]::Max(0, [math]::Floor(($width - $footer2.Length) / 2))
    Write-Host "$footer2Padding$footer2$footer2Padding" -ForegroundColor DarkGray


    $corRodape = "DarkGray"
    $dataHora = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    $footer = "Use os números para selecionar uma opção."
    $footer2 = "Data e hora: $dataHora"
    $footerPadding = " " * [math]::Max(0, [math]::Floor(($width - $footer.Length) / 2))
    $footer2Padding = " " * [math]::Max(0, [math]::Floor(($width - $footer2.Length) / 2))
    Write-Host "$footerPadding$footer$footerPadding" -ForegroundColor $corRodape
    Write-Host "$footer2Padding$footer2$footer2Padding" -ForegroundColor $corRodape




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
    0 {
    Write-Host "`nSaindo" -NoNewline -ForegroundColor Yellow
    for ($i=0; $i -lt 3; $i++) {
        Start-Sleep -Milliseconds 400
        Write-Host "." -NoNewline -ForegroundColor Yellow
    }
    Write-Host "`nAté logo!" -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Stop-Process -Id $PID
}
    default { Write-Host "`n⚠️  Opção inválida. Tente novamente." -ForegroundColor Red }
}
}

Show-Welcome

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
