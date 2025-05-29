#limpa o dns cache
function Clear-DnsCache {
    Write-Host "Limpando cache DNS..." -ForegroundColor Red
    try {
        ipconfig /flushdns | Out-Null
        Write-Host "Cache DNS limpo com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "`n⚠️Erro ao limpar cache DNS: $_" -ForegroundColor Yellow
    }
}
#reinicia o adaptador de rede
function Restart-NetworkAdapter {
    Write-Host "Reiniciando adaptador de rede..." -ForegroundColor Red
    try {
        Get-NetAdapter | Restart-NetAdapter -Confirm:$false -Force
        Write-Host "Adaptador de rede reiniciado com sucesso." -ForegroundColor Green
    } catch {
        Write-Host "`n⚠️Erro ao reiniciar adaptador de rede: $_" -ForegroundColor Yellow
    }
}
#limpa o disco
function Start-ProcessSafe {
    param (
        [string]$processPath,
        [string]$arguments = "",
        [string]$errorMessage = "Não foi possível iniciar o processo"
    )
    try {
        Start-Process $processPath -ArgumentList $arguments -NoNewWindow -Wait -ErrorAction Stop
    } catch {
        Write-Host "`n⚠️ $errorMessage : $_" -ForegroundColor Yellow
    }
}
#repaira os arquivos do sistema
function Repair-SystemFiles {
    Write-Host "Iniciando verificação de arquivos do sistema..." -ForegroundColor Red
    try {
        Start-ProcessSafe "sfc" "/scannow" -NoNewWindow -Wait
        Write-Host "Verificação concluída. Se foram encontrados problemas, eles foram corrigidos." -ForegroundColor Green
    } catch {
        Write-Host "`n⚠️Erro ao verificar arquivos do sistema: $_" -ForegroundColor Yellow
    }
}
#reinicia o explorer
function Restart-Explorer {
    Write-Host "Reiniciando Windows Explorer..." -ForegroundColor Red
    try {
        Stop-Process -Name explorer -Force -ErrorAction Stop
        Start-Process "explorer.exe"
        Write-Host "Windows Explorer reiniciado com sucesso." -ForegroundColor Green
    } catch {
        Write-Host "`n⚠️Erro ao reiniciar Windows Explorer: $_" -ForegroundColor Yellow
    }
}
#verificar atualizações do windows  
function Check-WindowsUpdates {
    Write-Host "Verificando atualizações do Windows..." -ForegroundColor Red
    try {
        Start-Process "ms-settings:windowsupdate" -ErrorAction Stop
        Write-Host "Verificação de atualizações iniciada." -ForegroundColor Green
    } catch {
        Write-Host "`n⚠️Erro ao verificar atualizações do Windows: $_" -ForegroundColor Yellow
    }
}
#testar conexao internet
function Test-Internet {
    Write-Host "Testando conexão com a Internet..." -ForegroundColor Red
    
    try {
        $pingresult = Test-Connection -ComputerName "google.com" -Count 4
        if ($pingresult) {
            Write-Host "Conexão com a Internet está normal." -ForegroundColor Green
        } else {
            Write-Host "Não foi possível conectar à Internet." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "`n⚠️Erro ao testar conexão com a Internet: $_" -ForegroundColor Yellow
    }
}
#uso de cpu e ram
function Get-TopProcesses {
    Write-Host "Obtendo processor com maior uso de CPU e RAM..." -ForegroundColor Red
    try {
        $processes = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
        Write-Host "Top 5 processos por uso de CPU:" -ForegroundColor Green
        $processes | Format-Table -AutoSize
    } catch {
        Write-Host "`n⚠️Erro ao obter processos: $_" -ForegroundColor Yellow
    }
    try {
        $ramProcesses = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5
        Write-Host "`nTop 5 processos por uso de RAM:" -ForegroundColor Green
        $ramProcesses | Format-Table -AutoSize
    } catch {
        Write-Host "`n⚠️Erro ao obter processos de RAM: $_" -ForegroundColor Yellow
    }

}
#verifica ativação do windows
function Check-WindowsActivation {
    Write-Host "Verificando status de ativação do Windows..." -ForegroundColor Red
    try {
        $activationStatus = (Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.PartialProductKey }) | Select-Object -Property LicenseStatus, Description
        if ($activationStatus.LicenseStatus -eq 1) {
            Write-Host "Windows está ativado." -ForegroundColor Green
        } else {
            Write-Host "Windows esta desativado" -ForegroundColor Yellow
        }
        $activationStatus | Format-Table -AutoSize
    } catch {
        Write-Host "`n⚠️Erro ao verificar ativação do Windows: $_" -ForegroundColor Yellow
    }
}
#verifica proxy
function Check-ProxySettings {
    Write-Host "Verificando configurações de proxy..." -ForegroundColor Red
    try {
        $proxy = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -ErrorAction Stop
        $isEnabled = $proxy.ProxyEnable -eq 1
        $proxyServer = $proxy.ProxyServer

        if ($isEnabled -and $proxyServer) {
            Write-Host "Proxy está habilitado: $proxyServer" -ForegroundColor Green
        } else {
            Write-Host "Proxy está desabilitado." -ForegroundColor Yellow
            $ativar = Read-Host "Deseja ativar o proxy? (s/n)"
            if ($ativar -eq 's') {
                $novoProxy = Read-Host "Digite o endereço do servidor proxy (ex: 192.168.1.100:8080)"
                if ($novoProxy) {
                    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 1
                    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Value $novoProxy
                    Write-Host "Proxy ativado com sucesso: $novoProxy" -ForegroundColor Green
                } else {
                    Write-Host "Endereço de proxy não informado. Proxy não ativado." -ForegroundColor Yellow
                }
            } else {
                Write-Host "Proxy não foi ativado." -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "`n⚠️ Erro ao acessar configurações de proxy: $_" -ForegroundColor Yellow
        # Permite criar as chaves se não existirem
        $ativar = Read-Host "Deseja criar e ativar o proxy? (s/n)"
        if ($ativar -eq 's') {
            $novoProxy = Read-Host "Digite o endereço do servidor proxy (ex: 192.168.1.100:8080)"
            if ($novoProxy) {
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 1 -PropertyType DWord -Force | Out-Null
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Value $novoProxy -PropertyType String -Force | Out-Null
                Write-Host "Proxy ativado com sucesso: $novoProxy" -ForegroundColor Green
            } else {
                Write-Host "Endereço de proxy não informado. Proxy não ativado." -ForegroundColor Yellow
            }
        }
    }
}


# Pesquisa no Google
function Search-Google {
    $query = Read-Host "Digite o que deseja pesquisar no google"
    if ($query) {
        $encodedQuery = [uri]::EscapeDataString($query)
        Start-Process "https://www.google.com/search?q=$encodedQuery" "Não foi possível abrir o navegador."
    } else {
        Write-Host "Pesquisa cancelada." -ForegroundColor Yellow
    }
}

# Pesquisar no Youtube
function Search-Youtube {
    $query = Read-Host "Digite o que deseja pesquisar no youtube"
    if ($query) {
        $encodedQuery = [uri]::EscapeDataString($query)
        Start-Process "https://www.youtube.com/results?search_query=$encodedQuery" "Não foi possível abrir o navegador."
    } else {
        Write-Host "Pesquisa cancelada." -ForegroundColor Yellow
    }
}



