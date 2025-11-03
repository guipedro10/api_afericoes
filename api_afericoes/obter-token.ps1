# Script para obter token JWT da API

Write-Host "=== Obtendo Token JWT ===" -ForegroundColor Green

$body = @{
    nomeDeUsuario = "admin"
    senha = "senha123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/auth" -Method POST -Body $body -ContentType "application/json"
    $token = $response.token
    
    Write-Host "`n✓ Token obtido com sucesso!" -ForegroundColor Green
    Write-Host "`nToken completo:" -ForegroundColor Yellow
    Write-Host $token -ForegroundColor White
    
    # Salvar token em arquivo
    $token | Out-File -FilePath "token.txt" -Encoding utf8 -NoNewline
    Write-Host "`n✓ Token salvo em: token.txt" -ForegroundColor Green
    Write-Host "`nUse este token nos headers das requisições:" -ForegroundColor Cyan
    Write-Host "Authorization: Bearer $($token.Substring(0, [Math]::Min(50, $token.Length)))..." -ForegroundColor Gray
    
} catch {
    Write-Host "`n✗ Erro ao obter token: $_" -ForegroundColor Red
    Write-Host "`nCertifique-se de que:" -ForegroundColor Yellow
    Write-Host "  1. A API está rodando em http://localhost:8080" -ForegroundColor Yellow
    Write-Host "  2. As credenciais estão corretas (admin / senha123)" -ForegroundColor Yellow
    Write-Host "`nDetalhes do erro:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

