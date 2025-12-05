# 🔧 Troubleshooting - MyDistroLinux Builder

Guia para resolver problemas comuns ao executar o script de criação da ISO.

## 🚨 Erros Comuns

### 1. Script não cria a ISO

#### Sintomas:
- Script executa mas ISO não é gerada
- Erro ao final do processo
- Diretórios vazios

#### Possíveis Causas e Soluções:

**A. Falta de espaço em disco**
```bash
# Verificar espaço disponível
df -h ~/minha-distro

# Precisa de pelo menos 15GB livres
# Limpar espaço se necessário
sudo apt clean
sudo apt autoremove
```

**B. Falta de permissões**
```bash
# O script precisa ser executado com interface gráfica
# Não execute via SSH sem X11 forwarding
# Execute diretamente no desktop ou via VNC/RDP
```

**C. Dependências não instaladas**
```bash
# Instalar todas as dependências
sudo apt update
sudo apt install -y \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-utils \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    zenity
```

**D. Erro no debootstrap**
```bash
# Verificar logs
cat /tmp/debootstrap.log

# Problemas comuns:
# - Conexão de internet instável
# - Mirror do Ubuntu fora do ar
# - Proxy bloqueando

# Solução: Limpar e tentar novamente
sudo rm -rf ~/minha-distro
./distro.sh
```

**E. Erro nas variáveis de ambiente**
```bash
# Verificar se DISPLAY está configurado
echo $DISPLAY

# Se vazio, configure:
export DISPLAY=:0

# Ou execute via:
DISPLAY=:0 ./distro.sh
```

---

### 2. Erro ao executar o script

#### "bash: ./distro.sh: Permission denied"

```bash
# Tornar o script executável
chmod +x distro.sh
./distro.sh
```

#### "zenity: command not found"

```bash
# Instalar Zenity
sudo apt install -y zenity
```

#### "debootstrap: command not found"

```bash
# Instalar debootstrap
sudo apt install -y debootstrap
```

---

### 3. Erro durante chroot

#### Sintomas:
- Mensagens de erro sobre "cannot access /proc"
- Falha ao instalar pacotes no chroot

#### Solução:
```bash
# Limpar montagens anteriores
sudo umount ~/minha-distro/$DISTRO_NAME/chroot/proc 2>/dev/null || true
sudo umount ~/minha-distro/$DISTRO_NAME/chroot/sys 2>/dev/null || true
sudo umount ~/minha-distro/$DISTRO_NAME/chroot/dev 2>/dev/null || true

# Remover diretório e começar de novo
sudo rm -rf ~/minha-distro
./distro.sh
```

---

### 4. Erro ao adicionar repositórios

#### "GPG error: ... NO_PUBKEY"

**Causa:** Chaves GPG não foram importadas corretamente

**Solução:** O script já tenta importar automaticamente. Se falhar:

```bash
# Verificar conexão com internet
ping -c 3 google.com

# Verificar se curl/wget funcionam
curl -I https://packages.microsoft.com

# Se problemas de proxy, configure:
export http_proxy="http://seu-proxy:porta"
export https_proxy="http://seu-proxy:porta"
```

---

### 5. ISO gerada mas não boota

#### A. Teste em máquina virtual primeiro

```bash
# Instalar QEMU
sudo apt install qemu-system-x86

# Testar a ISO
qemu-system-x86_64 -m 2048 -cdrom ~/minha-distro/SuaDistro-1.0-amd64.iso
```

#### B. Problemas com UEFI

```bash
# Verificar se grub-efi foi instalado corretamente
# No script, a seção GRUB deve ter:
grub-mkstandalone \
    --format=x86_64-efi \
    ...

# Se erro, reinstalar pacotes:
sudo apt install --reinstall grub-efi-amd64-bin
```

#### C. Problemas com BIOS

```bash
# Verificar ISOLINUX
ls -la ~/minha-distro/$DISTRO_NAME/image/isolinux/

# Deve conter:
# - isolinux.bin
# - ldlinux.c32
# - libcom32.c32
# - libutil.c32
```

---

### 6. Script trava ou não responde

#### Sintomas:
- Barra de progresso do Zenity parada
- Script aparentemente congelado
- Nenhuma mensagem de erro

#### Diagnóstico:
```bash
# Em outro terminal, verificar processos
ps aux | grep -E 'debootstrap|apt|dpkg|chroot'

# Verificar uso de disco
df -h

# Verificar memória
free -h

# Ver logs em tempo real
tail -f /tmp/debootstrap.log
tail -f /tmp/apt-install.log
```

#### Soluções:
```bash
# Se sem espaço em disco
sudo apt clean
sudo rm -rf /tmp/*

# Se sem memória
# Fechar outros programas
# Ou aumentar swap:
sudo swapoff -a
sudo dd if=/dev/zero of=/swapfile bs=1M count=4096
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

---

## 🔍 Debug Avançado

### Executar o script com debug ativado

```bash
# Adicionar no início do distro.sh (após #!/bin/bash):
set -x  # Mostra todos os comandos executados
set -e  # Para em caso de erro

# Ou executar assim:
bash -x ./distro.sh 2>&1 | tee debug.log
```

### Verificar logs do sistema

```bash
# Ver erros do sistema
sudo dmesg | tail -50

# Ver logs gerais
sudo journalctl -xe
```

### Testar partes do script isoladamente

```bash
# Testar apenas o debootstrap
sudo debootstrap --arch=amd64 jammy /tmp/test-chroot http://archive.ubuntu.com/ubuntu/

# Testar criação de squashfs
sudo mksquashfs /tmp/test-chroot /tmp/test.squashfs

# Testar criação de ISO
xorriso -as mkisofs -version
```

---

## 📋 Checklist Pré-Execução

Antes de executar o script, verifique:

- [ ] Sistema: Ubuntu/Debian com GUI
- [ ] Espaço em disco: Mínimo 15GB livres
- [ ] RAM: Mínimo 4GB
- [ ] Internet: Conexão estável
- [ ] Dependências: Todas instaladas
- [ ] Permissões: Script executável (chmod +x)
- [ ] Display: Variável $DISPLAY configurada
- [ ] Usuário: Tem acesso sudo

```bash
# Script de verificação rápida
echo "=== Checklist ==="
echo "Espaço em disco: $(df -h ~ | awk 'NR==2 {print $4}') disponível"
echo "RAM livre: $(free -h | awk 'NR==2 {print $7}')"
echo "DISPLAY: $DISPLAY"
echo "Zenity: $(which zenity)"
echo "Debootstrap: $(which debootstrap)"
echo "Xorriso: $(which xorriso)"
echo "Sudo: $(sudo -n true 2>&1 && echo 'OK' || echo 'Precisa senha')"
```

---

## 🆘 Obter Ajuda

### 1. Coletar informações

```bash
# Criar relatório de erro
cat > ~/error-report.txt <<EOF
=== Sistema ===
$(lsb_release -a)
$(uname -a)

=== Espaço em Disco ===
$(df -h)

=== Memória ===
$(free -h)

=== Dependências ===
debootstrap: $(dpkg -l | grep debootstrap)
xorriso: $(dpkg -l | grep xorriso)
zenity: $(dpkg -l | grep zenity)

=== Logs (últimas 50 linhas) ===
$(tail -50 /tmp/debootstrap.log 2>/dev/null || echo "Log não encontrado")
EOF

cat ~/error-report.txt
```

### 2. Onde reportar

- **GitHub Issues:** https://github.com/1985epma/mydistrolinux/issues
- Inclua o error-report.txt
- Descreva o que estava tentando fazer
- Informe em qual etapa falhou

---

## 🔄 Começar do Zero

Se nada funcionar, limpe tudo e comece novamente:

```bash
# Limpar completamente
sudo umount -R ~/minha-distro/* 2>/dev/null || true
sudo rm -rf ~/minha-distro
rm -rf /tmp/debootstrap* /tmp/apt* /tmp/mksquashfs* /tmp/xorriso*

# Reinstalar dependências
sudo apt update
sudo apt install --reinstall -y \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-utils \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    zenity

# Executar script novamente
./distro.sh
```

---

## 💡 Dicas de Performance

### Para acelerar o processo:

```bash
# Usar mirror mais próximo (Brasil)
# Edite o script e mude:
http://archive.ubuntu.com/ubuntu
# Para:
http://br.archive.ubuntu.com/ubuntu

# Ou use um mirror específico:
http://mirror.unesp.br/ubuntu/
```

### Para reduzir tamanho da ISO:

```bash
# No script, após instalar pacotes, adicione:
apt clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
```

---

**Última atualização:** Dezembro 2024  
**Versão do documento:** 1.0
