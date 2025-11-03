# Script de teste completo da API

Write-Host "=== Teste da API de Aferições ===" -ForegroundColor Green

# 1. Autenticar
Write-Host "`n1. Autenticando..." -ForegroundColor Yellow
$body = @{
    nomeDeUsuario = "admin"
    senha = "senha123"
} | ConvertTo-Json

try {
    $authResponse = Invoke-RestMethod -Uri "http://localhost:8080/auth" -Method POST -Body $body -ContentType "application/json"
    $token = $authResponse.token
    Write-Host "✓ Token obtido com sucesso!" -ForegroundColor Green
    Write-Host "Token: $($token.Substring(0, [Math]::Min(50, $token.Length)))..." -ForegroundColor Gray
} catch {
    Write-Host "✗ Erro na autenticação: $_" -ForegroundColor Red
    Write-Host "Certifique-se de que a API está rodando em http://localhost:8080" -ForegroundColor Yellow
    exit 1
}

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# 2. Criar aferição
Write-Host "`n2. Criando nova aferição..." -ForegroundColor Yellow
$novaAfericao = @{
    idSensor = "SENSOR001"
    unidade = "ºC"
    valor = "25.5"
} | ConvertTo-Json

try {
    $afericao = Invoke-RestMethod -Uri "http://localhost:8080/afericoes" -Method POST -Headers $headers -Body $novaAfericao
    $afericaoId = $afericao.id
    Write-Host "✓ Aferição criada com ID: $afericaoId" -ForegroundColor Green
    Write-Host "  Detalhes:" -ForegroundColor Gray
    $afericao | ConvertTo-Json | Write-Host
} catch {
    Write-Host "✗ Erro ao criar aferição: $_" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

# 3. Listar todas
Write-Host "`n3. Listando todas as aferições..." -ForegroundColor Yellow
try {
    $afericoes = Invoke-RestMethod -Uri "http://localhost:8080/afericoes" -Method GET -Headers $headers
    Write-Host "✓ Total de aferições: $($afericoes.Count)" -ForegroundColor Green
    if ($afericoes.Count -gt 0) {
        $afericoes | ConvertTo-Json -Depth 3 | Write-Host
    }
} catch {
    Write-Host "✗ Erro ao listar aferições: $_" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

# 4. Buscar por ID
if ($afericaoId) {
    Write-Host "`n4. Buscando aferição por ID ($afericaoId)..." -ForegroundColor Yellow
    try {
        $afericao = Invoke-RestMethod -Uri "http://localhost:8080/afericoes/$afericaoId" -Method GET -Headers $headers
        Write-Host "✓ Aferição encontrada:" -ForegroundColor Green
        $afericao | ConvertTo-Json -Depth 3 | Write-Host
    } catch {
        Write-Host "✗ Erro ao buscar aferição: $_" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }

    # 5. Atualizar
    Write-Host "`n5. Atualizando aferição..." -ForegroundColor Yellow
    $afericaoAtualizada = @{
        idSensor = "SENSOR001"
        unidade = "ºC"
        valor = "26.0"
    } | ConvertTo-Json

    try {
        $afericao = Invoke-RestMethod -Uri "http://localhost:8080/afericoes/$afericaoId" -Method PUT -Headers $headers -Body $afericaoAtualizada
        Write-Host "✓ Aferição atualizada!" -ForegroundColor Green
        $afericao | ConvertTo-Json -Depth 3 | Write-Host
    } catch {
        Write-Host "✗ Erro ao atualizar aferição: $_" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }

    # 6. Deletar
    Write-Host "`n6. Deletando aferição..." -ForegroundColor Yellow
    try {
        Invoke-RestMethod -Uri "http://localhost:8080/afericoes/$afericaoId" -Method DELETE -Headers $headers
        Write-Host "✓ Aferição deletada com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "✗ Erro ao deletar aferição: $_" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

Write-Host "`n=== Teste concluído! ===" -ForegroundColor Green

