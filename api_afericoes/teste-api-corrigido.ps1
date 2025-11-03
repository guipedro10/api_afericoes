# Script de teste completo e corrigido da API

Write-Host "=== TESTE DA API - VERSAO CORRIGIDA ===" -ForegroundColor Green

# PASSO 1: Autenticar e obter token
Write-Host ""
Write-Host "[PASSO 1] Autenticando..." -ForegroundColor Yellow

$body = @{
    nomeDeUsuario = "admin"
    senha = "senha123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/auth" -Method POST -Body $body -ContentType "application/json"
    
    $token = $response.token.ToString().Trim()
    $global:token = $token
    
    Write-Host "Token obtido com sucesso!" -ForegroundColor Green
    Write-Host "Token (primeiros 50 caracteres): $($token.Substring(0, [Math]::Min(50, $token.Length)))..." -ForegroundColor Gray
} catch {
    Write-Host "ERRO na autenticacao!" -ForegroundColor Red
    Write-Host "Detalhes: $_" -ForegroundColor Red
    exit 1
}

# PASSO 2: Criar uma nova afericao
Write-Host ""
Write-Host "[PASSO 2] Criando nova afericao..." -ForegroundColor Yellow

$headers = @{
    "Authorization" = "Bearer $($global:token)"
    "Content-Type" = "application/json"
}

$novaAfericao = @{
    idSensor = "SENSOR001"
    unidade = "ºC"
    valor = "25.5"
} | ConvertTo-Json

try {
    $resultado = Invoke-RestMethod -Uri "http://localhost:8080/afericoes" -Method POST -Headers $headers -Body $novaAfericao
    
    $afericaoId = $resultado.id
    Write-Host "Afericao criada com sucesso!" -ForegroundColor Green
    Write-Host "ID da afericao: $afericaoId" -ForegroundColor Cyan
    Write-Host "Detalhes:" -ForegroundColor Gray
    $resultado | ConvertTo-Json | Write-Host
    
    $global:afericaoId = $afericaoId
} catch {
    Write-Host "ERRO ao criar afericao!" -ForegroundColor Red
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    Write-Host "Detalhes: $_" -ForegroundColor Red
}

# PASSO 3: Listar todas as afericoes
Write-Host ""
Write-Host "[PASSO 3] Listando todas as afericoes..." -ForegroundColor Yellow

$headers = @{
    "Authorization" = "Bearer $($global:token)"
}

try {
    $afericoes = Invoke-RestMethod -Uri "http://localhost:8080/afericoes" -Method GET -Headers $headers
    
    Write-Host "Listagem concluida!" -ForegroundColor Green
    Write-Host "Total de afericoes: $($afericoes.Count)" -ForegroundColor Cyan
    
    if ($afericoes.Count -gt 0) {
        Write-Host ""
        Write-Host "Lista de afericoes:" -ForegroundColor Gray
        $afericoes | ConvertTo-Json -Depth 3 | Write-Host
    } else {
        Write-Host "Nenhuma afericao encontrada." -ForegroundColor Yellow
    }
} catch {
    Write-Host "ERRO ao listar afericoes!" -ForegroundColor Red
    Write-Host "Detalhes: $_" -ForegroundColor Red
}

# PASSO 4: Buscar afericao por ID
if ($global:afericaoId) {
    Write-Host ""
    Write-Host "[PASSO 4] Buscando afericao por ID ($($global:afericaoId))..." -ForegroundColor Yellow
    
    $headers = @{
        "Authorization" = "Bearer $($global:token)"
    }
    
    try {
        $afericao = Invoke-RestMethod -Uri "http://localhost:8080/afericoes/$($global:afericaoId)" -Method GET -Headers $headers
        
        Write-Host "Afericao encontrada!" -ForegroundColor Green
        $afericao | ConvertTo-Json | Write-Host
    } catch {
        Write-Host "ERRO ao buscar afericao!" -ForegroundColor Red
        Write-Host "Detalhes: $_" -ForegroundColor Red
    }
}

# PASSO 5: Atualizar afericao
if ($global:afericaoId) {
    Write-Host ""
    Write-Host "[PASSO 5] Atualizando afericao..." -ForegroundColor Yellow
    
    $headers = @{
        "Authorization" = "Bearer $($global:token)"
        "Content-Type" = "application/json"
    }
    
    $afericaoAtualizada = @{
        idSensor = "SENSOR001"
        unidade = "ºC"
        valor = "26.0"
    } | ConvertTo-Json
    
    try {
        $resultado = Invoke-RestMethod -Uri "http://localhost:8080/afericoes/$($global:afericaoId)" -Method PUT -Headers $headers -Body $afericaoAtualizada
        
        Write-Host "Afericao atualizada!" -ForegroundColor Green
        $resultado | ConvertTo-Json | Write-Host
    } catch {
        Write-Host "ERRO ao atualizar afericao!" -ForegroundColor Red
        Write-Host "Detalhes: $_" -ForegroundColor Red
    }
}

# PASSO 6: Deletar afericao
if ($global:afericaoId) {
    Write-Host ""
    Write-Host "[PASSO 6] Deletando afericao..." -ForegroundColor Yellow
    
    $headers = @{
        "Authorization" = "Bearer $($global:token)"
    }
    
    try {
        Invoke-RestMethod -Uri "http://localhost:8080/afericoes/$($global:afericaoId)" -Method DELETE -Headers $headers
        
        Write-Host "Afericao deletada com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "ERRO ao deletar afericao!" -ForegroundColor Red
        Write-Host "Detalhes: $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== TESTE CONCLUIDO ===" -ForegroundColor Green
