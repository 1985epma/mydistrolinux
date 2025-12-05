# 🔐 Guia de Configuração do Sudo

Guia rápido para configurar o comportamento do sudo na sua distribuição personalizada.

## 📋 Opções Disponíveis

### ✅ Opção 1: Sudo SEM Senha (Padrão - Já Ativo)

**Quando usar:**
- ✅ Desenvolvimento pessoal
- ✅ Ambientes de teste/VM
- ✅ Uso individual
- ✅ Scripts de automação

**Como está configurado:**
```bash
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
chmod 0440 /etc/sudoers.d/$USERNAME
```

**Já funciona sem modificações!** Ao rodar `./distro.sh`, o usuário criado poderá usar sudo sem senha.

**Exemplo de uso:**
```bash
sudo apt update        # Executa sem pedir senha
sudo systemctl status  # Executa sem pedir senha
```

---

### 🔒 Opção 2: Sudo COM Senha + Timeout Maior (60 minutos)

**Quando usar:**
- ⚡ Uso compartilhado com segurança moderada
- ⚡ Quer segurança mas sem digitar senha toda hora
- ⚡ Trabalho colaborativo

**Como ativar:**

1. Abra `distro.sh` no editor
2. **Comente** a linha da OPÇÃO 1 (adicione `#` no início):
   ```bash
   # echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
   ```

3. **Descomente** a linha da OPÇÃO 2 (remova `#` do início):
   ```bash
   echo "Defaults timestamp_timeout=60" >> /etc/sudoers.d/sudo-timeout
   ```

**Resultado:**
- Primeira vez pede senha
- Senha válida por 60 minutos
- Depois de 60 minutos pede novamente

**Personalizar timeout:**
```bash
# 30 minutos
echo "Defaults timestamp_timeout=30" >> /etc/sudoers.d/sudo-timeout

# 2 horas (120 minutos)
echo "Defaults timestamp_timeout=120" >> /etc/sudoers.d/sudo-timeout

# Sessão completa (até reboot)
echo "Defaults timestamp_timeout=-1" >> /etc/sudoers.d/sudo-timeout
```

---

### 🔐 Opção 3: Sudo Padrão (Senha + 15 minutos)

**Quando usar:**
- 🔒 Segurança máxima
- 🔒 Ambientes de produção
- 🔒 Sistemas multi-usuário
- 🔒 Servidores

**Como ativar:**

1. Abra `distro.sh`
2. **Comente TODAS as opções** (OPÇÃO 1 e OPÇÃO 2):
   ```bash
   # echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
   # echo "Defaults timestamp_timeout=60" >> /etc/sudoers.d/sudo-timeout
   ```

**Resultado:**
- Sempre pede senha no primeiro sudo
- Senha válida por 15 minutos (padrão Ubuntu)
- Comportamento idêntico ao Ubuntu padrão

---

### 🚫 Opção 4: Desabilitar Senha de Root

**Quando usar:**
- 🧪 VMs de teste descartáveis
- 🧪 Ambientes isolados
- 🧪 Desenvolvimento local

**Como ativar:**

No `distro.sh`, **descomente**:
```bash
passwd -d root
```

**⚠️ ATENÇÃO:** Isso remove a senha do usuário root completamente. Use apenas em ambientes controlados!

---

## 🔄 Modificar Após Criar a ISO

Se já criou a ISO e quer mudar o comportamento do sudo:

### Adicionar Sudo Sem Senha
```bash
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
sudo chmod 0440 /etc/sudoers.d/$USER
```

### Aumentar Timeout para 60 minutos
```bash
echo "Defaults timestamp_timeout=60" | sudo tee /etc/sudoers.d/sudo-timeout
```

### Voltar ao Padrão (remover customizações)
```bash
sudo rm /etc/sudoers.d/$USER
sudo rm /etc/sudoers.d/sudo-timeout
```

### Verificar Configuração Atual
```bash
# Ver timeout atual
sudo -V | grep timeout

# Listar configurações sudo
sudo cat /etc/sudoers.d/*

# Testar sudo
sudo -v  # Se pedir senha, está com senha habilitada
```

---

## 🛠️ Troubleshooting

### Erro: "syntax error near unexpected token"
**Causa:** Arquivo sudoers com erro de sintaxe

**Solução:**
```bash
# Validar sintaxe antes de aplicar
visudo -c -f /etc/sudoers.d/seu-arquivo

# Remover arquivo com erro
sudo rm /etc/sudoers.d/arquivo-com-erro

# Recriar corretamente
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
sudo chmod 0440 /etc/sudoers.d/$USER
```

### Sudo pede senha mesmo com NOPASSWD configurado
**Possíveis causas:**
1. Arquivo em `/etc/sudoers.d/` com permissões erradas
2. Múltiplos arquivos conflitantes

**Solução:**
```bash
# Verificar permissões (deve ser 0440)
ls -l /etc/sudoers.d/

# Corrigir permissões
sudo chmod 0440 /etc/sudoers.d/*

# Verificar ordem de aplicação
sudo cat /etc/sudoers | grep includedir
```

### Não consigo executar sudo de jeito nenhum
**Causa:** Usuário não está no grupo sudo

**Solução:**
```bash
# Adicionar usuário ao grupo sudo (como root)
su -
usermod -aG sudo seu-usuario
exit

# Verificar
groups seu-usuario
```

---

## 📊 Comparação de Opções

| Opção | Pede Senha? | Timeout | Segurança | Conveniência | Uso Recomendado |
|-------|-------------|---------|-----------|--------------|-----------------|
| **NOPASSWD** | ❌ Nunca | N/A | ⚠️ Baixa | ⭐⭐⭐⭐⭐ | Dev/Pessoal |
| **60 minutos** | ✅ 1x/hora | 60 min | ⚡ Média | ⭐⭐⭐⭐ | Compartilhado |
| **15 minutos** | ✅ Várias | 15 min | ✅ Alta | ⭐⭐⭐ | Produção |
| **Sempre** | ✅ Toda vez | 0 min | 🔒 Máxima | ⭐ | Servidores |

---

## 💡 Dicas de Segurança

### Para Desenvolvimento (NOPASSWD)
✅ **Seguro quando:**
- Máquina pessoal
- VM isolada
- Desenvolvimento local
- Não exposto à internet

⚠️ **Evitar quando:**
- Sistema compartilhado
- Servidor de produção
- Acesso remoto habilitado
- Dados sensíveis

### Para Produção (Senha Sempre)
✅ **Recomendado:**
- Use timeout padrão (15 min) ou menor
- Implemente autenticação de 2 fatores
- Use chaves SSH com senha
- Monitore logs de sudo: `/var/log/auth.log`

### Boas Práticas
```bash
# Logs de comandos sudo
sudo cat /var/log/auth.log | grep sudo

# Ver quem tem privilégios sudo
grep -Po '^sudo.+:\K.*$' /etc/group

# Auditar configurações sudo
sudo visudo -c
```

---

## 📚 Recursos Adicionais

- **Documentação oficial do sudo:** https://www.sudo.ws/docs/man/sudoers.man/
- **Ubuntu sudoers guide:** https://help.ubuntu.com/community/Sudoers
- **Security best practices:** https://wiki.debian.org/sudo

---

## 🎯 Exemplos Práticos

### Desenvolvimento Web (NOPASSWD)
```bash
# distro.sh - OPÇÃO 1 ativa (padrão)
sudo systemctl restart nginx    # Sem senha
sudo docker-compose up         # Sem senha
sudo npm install -g pm2        # Sem senha
```

### Servidor Compartilhado (Timeout 60min)
```bash
# distro.sh - OPÇÃO 2 ativa
sudo apt update               # Pede senha
sudo apt upgrade              # Usa mesma sessão (60min)
# ... trabalha por 1 hora ...
sudo systemctl restart apache # Pede senha novamente
```

### Produção (Sempre Senha)
```bash
# distro.sh - TODAS opções comentadas
sudo systemctl stop nginx     # Pede senha
sudo nano /etc/nginx/nginx.conf  # Usa sessão (15min)
# ... após 20 minutos ...
sudo systemctl start nginx    # Pede senha novamente
```

---

**Data de atualização:** Dezembro 2024  
**Versão do documento:** 1.0  
**Testado em:** Ubuntu 22.04 LTS, 24.04 LTS
