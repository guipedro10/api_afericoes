# Guia de Teste da API - Passo a Passo

## ✅ Passo 1: Verificar se a API está rodando

Abra um navegador ou use o PowerShell para verificar se a API está respondendo:

```powershell
# Teste básico (deve retornar erro 401, pois não tem token - isso é esperado!)
Invoke-WebRequest -Uri "http://localhost:8080/afericoes" -Method GET
```

Se você receber um erro 401 (Unauthorized), **perfeito!** Isso significa que a API está funcionando e protegida.

---

## 🔐 Passo 2: Autenticar e obter o token JWT

Você precisa primeiro obter um token JWT para usar os outros endpoints.

### Opção A: Usando PowerShell (Windows)

Crie um arquivo `teste-auth.ps1` ou execute diretamente:

```powershell
$body = @{
    nomeDeUsuario = "admin"
    senha = "senha123"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:8080/auth" -Method POST -Body $body -ContentType "application/json"
$token = $response.token
Write-Host "Token obtido: $token"
$token | Out-File -FilePath "token.txt" -Encoding utf8
```

### Opção B: Usando cURL (se instalado)

```bash
curl -X POST http://localhost:8080/auth -H "Content-Type: application/json" -d "{\"nomeDeUsuario\":\"admin\",\"senha\":\"senha123\"}"
```

### Opção C: Usando Postman ou Insomnia

1. **Método:** POST
2. **URL:** `http://localhost:8080/auth`
3. **Headers:**
   - `Content-Type: application/json`
4. **Body (raw JSON):**
   ```json
   {
     "nomeDeUsuario": "admin",
     "senha": "senha123"
   }
   ```

5. **Resposta esperada:**
   ```json
   {
     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
   }
   ```

**Copie o token retornado!** Você vai precisar dele para os próximos passos.

---

## 📝 Passo 3: Criar uma nova aferição

### Usando PowerShell:

```powershell
# Substitua <SEU_TOKEN> pelo token obtido no passo anterior
$token = Get-Content "token.txt"

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$body = @{
    idSensor = "SENSOR001"
    unidade = "ºC"
    valor = "25.5"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8080/afericoes" -Method POST -Headers $headers -Body $body
```

### Usando cURL:

```bash
curl -X POST http://localhost:8080/afericoes \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <SEU_TOKEN>" \
  -d "{\"idSensor\":\"SENSOR001\",\"unidade\":\"ºC\",\"valor\":\"25.5\"}"
```

**Resposta esperada:**
```json
{
  "id": 1,
  "idSensor": "SENSOR001",
  "unidade": "ºC",
  "valor": "25.5"
}
```

---

## 📋 Passo 4: Listar todas as aferições

### PowerShell:

```powershell
$token = Get-Content "token.txt"
$headers = @{
    "Authorization" = "Bearer $token"
}

Invoke-RestMethod -Uri "http://localhost:8080/afericoes" -Method GET -Headers $headers
```

### cURL:

```bash
curl -X GET http://localhost:8080/afericoes \
  -H "Authorization: Bearer <SEU_TOKEN>"
```

---

## 🔍 Passo 5: Buscar uma aferição por ID

### PowerShell:

```powershell
$token = Get-Content "token.txt"
$headers = @{
    "Authorization" = "Bearer $token"
}

# Substitua 1 pelo ID da aferição que você quer buscar
Invoke-RestMethod -Uri "http://localhost:8080/afericoes/1" -Method GET -Headers $headers
```

### cURL:

```bash
curl -X GET http://localhost:8080/afericoes/1 \
  -H "Authorization: Bearer <SEU_TOKEN>"
```

---

## ✏️ Passo 6: Atualizar uma aferição

### PowerShell:

```powershell
$token = Get-Content "token.txt"
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$body = @{
    idSensor = "SENSOR001"
    unidade = "ºC"
    valor = "26.0"
} | ConvertTo-Json

# Substitua 1 pelo ID da aferição que você quer atualizar
Invoke-RestMethod -Uri "http://localhost:8080/afericoes/1" -Method PUT -Headers $headers -Body $body
```

### cURL:

```bash
curl -X PUT http://localhost:8080/afericoes/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <SEU_TOKEN>" \
  -d "{\"idSensor\":\"SENSOR001\",\"unidade\":\"ºC\",\"valor\":\"26.0\"}"
```

---

## 🗑️ Passo 7: Deletar uma aferição

### PowerShell:

```powershell
$token = Get-Content "token.txt"
$headers = @{
    "Authorization" = "Bearer $token"
}

# Substitua 1 pelo ID da aferição que você quer deletar
Invoke-RestMethod -Uri "http://localhost:8080/afericoes/1" -Method DELETE -Headers $headers
```

### cURL:

```bash
curl -X DELETE http://localhost:8080/afericoes/1 \
  -H "Authorization: Bearer <SEU_TOKEN>"
```

---

## 🎯 Script Completo de Teste (PowerShell)

Crie um arquivo `teste-completo.ps1` com o seguinte conteúdo:

```powershell
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
} catch {
    Write-Host "✗ Erro na autenticação: $_" -ForegroundColor Red
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
    Write-Host "  Detalhes: $($afericao | ConvertTo-Json)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Erro ao criar aferição: $_" -ForegroundColor Red
}

# 3. Listar todas
Write-Host "`n3. Listando todas as aferições..." -ForegroundColor Yellow
try {
    $afericoes = Invoke-RestMethod -Uri "http://localhost:8080/afericoes" -Method GET -Headers $headers
    Write-Host "✓ Total de aferições: $($afericoes.Count)" -ForegroundColor Green
    $afericoes | ConvertTo-Json | Write-Host
} catch {
    Write-Host "✗ Erro ao listar aferições: $_" -ForegroundColor Red
}

# 4. Buscar por ID
Write-Host "`n4. Buscando aferição por ID..." -ForegroundColor Yellow
try {
    $afericao = Invoke-RestMethod -Uri "http://localhost:8080/afericoes/$afericaoId" -Method GET -Headers $headers
    Write-Host "✓ Aferição encontrada:" -ForegroundColor Green
    $afericao | ConvertTo-Json | Write-Host
} catch {
    Write-Host "✗ Erro ao buscar aferição: $_" -ForegroundColor Red
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
    $afericao | ConvertTo-Json | Write-Host
} catch {
    Write-Host "✗ Erro ao atualizar aferição: $_" -ForegroundColor Red
}

# 6. Deletar
Write-Host "`n6. Deletando aferição..." -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "http://localhost:8080/afericoes/$afericaoId" -Method DELETE -Headers $headers
    Write-Host "✓ Aferição deletada com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "✗ Erro ao deletar aferição: $_" -ForegroundColor Red
}

Write-Host "`n=== Teste concluído! ===" -ForegroundColor Green
```

Execute com:
```powershell
.\teste-completo.ps1
```

---

## 🐛 Troubleshooting

### Erro: "Não é possível conectar ao servidor remoto"
- Verifique se a aplicação está rodando na porta 8080
- Confira os logs do Spring Boot para ver se há erros

### Erro: "401 Unauthorized"
- Verifique se o token está correto
- Certifique-se de incluir "Bearer " antes do token
- O token pode ter expirado (válido por 24 horas), obtenha um novo

### Erro: "400 Bad Request"
- Verifique o formato JSON do body
- Certifique-se de que todos os campos obrigatórios estão presentes

---

## 🌐 Acessar o Console H2 (Banco de Dados)

Se quiser ver os dados diretamente no banco:

1. Acesse: `http://localhost:8080/h2-console`
2. JDBC URL: `jdbc:h2:mem:testdb`
3. Usuário: `sa`
4. Senha: (deixe vazio)
5. Clique em "Connect"

---

## 📱 Testando com Postman

1. **Coleção completa disponível:**
   - Importe a coleção do Postman (se disponível)
   - Ou crie manualmente seguindo os exemplos acima

2. **Configurar variável de token:**
   - Crie uma variável de coleção chamada `token`
   - Use `{{token}}` nos headers Authorization

---

## ✅ Checklist de Teste

- [ ] API está rodando (porta 8080)
- [ ] Autenticação funciona (POST /auth)
- [ ] Token JWT é retornado
- [ ] Criar aferição funciona (POST /afericoes)
- [ ] Listar aferições funciona (GET /afericoes)
- [ ] Buscar por ID funciona (GET /afericoes/{id})
- [ ] Atualizar funciona (PUT /afericoes/{id})
- [ ] Deletar funciona (DELETE /afericoes/{id})
- [ ] Endpoints protegidos retornam 401 sem token
- [ ] Token inválido retorna 401

