# MyDistroLinux - Criador de Distribuições Linux Personalizadas

Script automatizado para criar distribuições Linux personalizadas baseadas no Ubuntu, com interface gráfica intuitiva usando Zenity.

## 📋 Descrição

Este script bash permite criar uma distribuição Linux ISO customizada a partir de releases do Ubuntu (22.04 LTS ou 24.04 LTS), com ambiente desktop XFCE4, configurações personalizadas e pacotes pré-instalados.

## ✨ Características

- **Interface Gráfica**: Todo o processo é guiado por diálogos Zenity
- **Personalização Completa**: Escolha nome, versão, usuário e senha da distro
- **Base Ubuntu**: Suporte para Ubuntu 22.04 LTS (Jammy) e 24.04 LTS (Noble)
- **Boot Dual**: Suporte para BIOS (ISOLINUX) e UEFI (GRUB)
- **GRUB Customizado**: Menu de boot personalizado com múltiplas opções e tema visual
- **Ambiente Desktop**: XFCE4 pré-configurado com LightDM
- **Aplicativos Incluídos**: Firefox, VLC, GParted, Zsh e mais
- **Repositórios Extensivos**: Kernels mais recentes, drivers proprietários (Intel/AMD/NVIDIA), ferramentas de desenvolvimento (VSCode, Docker, .NET, Node.js, Go, Ruby, PostgreSQL)
- **Live System**: Sistema funcional em modo Live com opção de instalação

## 📚 Documentação

- **[README.md](README.md)** - Guia principal de instalação e uso
- **[REPOSITORIES.md](REPOSITORIES.md)** - Lista completa de repositórios e pacotes disponíveis
- **[SUDO-CONFIG.md](SUDO-CONFIG.md)** - Guia de configuração do sudo (com/sem senha, timeouts)
- **[VAGRANT.md](VAGRANT.md)** - Guia detalhado para usar com Vagrant
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Como contribuir com o projeto
- **[CHANGELOG.md](CHANGELOG.md)** - Histórico de versões

## 🔧 Requisitos

### Opção 1: Sistema Local

#### Sistema Operacional
- Ubuntu/Debian ou derivados (testado em Ubuntu 24.04)
- Ambiente com interface gráfica (para Zenity)

#### Pacotes Necessários
```bash
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

#### Espaço em Disco
- Mínimo: **15 GB** livres
- Recomendado: **20 GB** ou mais

#### Permissões
- Acesso `sudo` (o script solicitará senha quando necessário)

### Opção 2: Vagrant (Recomendado para Windows/Mac)

#### Pré-requisitos
- [Vagrant](https://www.vagrantup.com/downloads) 2.0 ou superior
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 6.0 ou superior
- **8 GB RAM** no host (VM usa 4 GB)
- **25 GB** de espaço em disco livre

#### Sistemas Suportados
- ✅ Windows 10/11
- ✅ macOS (Intel e Apple Silicon via Rosetta)
- ✅ Linux (qualquer distribuição)

**Vantagens do Vagrant:**
- ✅ Configuração automática completa
- ✅ Ambiente isolado e reproduzível
- ✅ Interface gráfica incluída
- ✅ Todas as dependências pré-instaladas
- ✅ Não afeta o sistema host

## 🚀 Como Usar

### Opção 1: Sistema Local (Linux com GUI)

1. **Clone o repositório ou baixe o script**:
   ```bash
   git clone https://github.com/1985epma/mydistrolinux.git
   cd mydistrolinux
   ```

2. **Instale as dependências**:
   ```bash
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

3. **Torne o script executável**:
   ```bash
   chmod +x distro.sh
   ```

4. **Execute o script**:
   ```bash
   ./distro.sh
   ```

### Opção 2: Vagrant (Qualquer SO - Windows/Mac/Linux)

Vagrant cria automaticamente uma VM Ubuntu com interface gráfica e todas as dependências pré-instaladas.

1. **Instale os pré-requisitos**:
   - [Vagrant](https://www.vagrantup.com/downloads) (v2.0+)
   - [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (v6.0+)

2. **Clone o repositório**:
   ```bash
   git clone https://github.com/1985epma/mydistrolinux.git
   cd mydistrolinux
   ```

3. **Execute o script de setup**:
   ```bash
   ./vagrant-setup.sh
   ```
   
   Ou manualmente:
   ```bash
   vagrant up
   ```

4. **Usar a VM**:
   - A janela do VirtualBox abrirá automaticamente
   - Login automático (usuário: vagrant)
   - Clique no ícone "MyDistroLinux Builder" na área de trabalho
   
   Ou via terminal:
   ```bash
   vagrant ssh
   cd /vagrant
   ./distro.sh
   ```

**Comandos Vagrant úteis:**
```bash
vagrant suspend      # Pausar VM
vagrant resume       # Retomar VM
vagrant reload       # Reiniciar VM
vagrant halt         # Desligar VM
vagrant destroy      # Remover VM completamente
vagrant ssh          # Acessar terminal da VM
```

### Seguindo os Diálogos

Independente do método escolhido:
   - Digite o nome da sua distribuição
   - Digite a versão
   - Escolha a release base do Ubuntu (22.04 ou 24.04)
   - Defina o usuário padrão
   - Defina a senha do usuário
   - Confirme as informações

5. **Aguarde a construção**:
   - O processo pode levar de 30 minutos a 1 hora
   - Uma barra de progresso mostrará o andamento

6. **ISO pronta**:
   - A ISO será gerada em: `~/minha-distro/NomeDaDistro-Versão-amd64.iso`

## 📦 Pacotes e Repositórios

### Repositórios Incluídos

O script configura automaticamente os seguintes repositórios para garantir acesso às versões mais recentes:

#### 🖥️ Kernel e Drivers
- **Kernel Mainline PPA** (`cappelikan/ppa`) - Kernels Linux mais recentes
- **Graphics Drivers PPA** (`graphics-drivers/ppa`) - Drivers NVIDIA, AMD e Intel atualizados
- **Intel Graphics** (repositório oficial) - Drivers Intel otimizados
- **Kernel OEM** - Suporte aprimorado para hardware recente

#### 🌐 Navegadores
- **Google Chrome** (repositório oficial)
- **Microsoft Edge** (repositório oficial)

#### 💻 Ferramentas de Desenvolvimento
- **Visual Studio Code** (repositório Microsoft)
- **Docker** (repositório oficial Docker)
- **Git PPA** (`git-core/ppa`) - Versões mais recentes do Git
- **.NET SDK** (repositório Microsoft)
- **Node.js 20.x** (repositório NodeSource)
- **Yarn** (gerenciador de pacotes JavaScript)
- **PostgreSQL** (repositório oficial PostgreSQL)

#### 🎵 Multimídia
- **Spotify** (repositório oficial)
- **OBS Studio PPA** - Software de gravação/streaming
- **Steam** (para jogos)

### Pacotes Disponíveis para Instalação

Todos os pacotes abaixo estão disponíveis. Para instalar, edite `distro.sh` e descomente as linhas desejadas:

#### Drivers de Hardware
```bash
# NVIDIA (auto-detecta GPU)
nvidia-driver-535, nvidia-utils-535

# AMD (drivers Mesa atualizados)
mesa-vulkan-drivers, mesa-vdpau-drivers

# Intel
intel-gpu-tools, intel-media-va-driver

# Kernel Manager (GUI para atualizar kernel)
mainline
```

#### Linguagens de Programação
```bash
# Java OpenJDK
openjdk-17-jdk, openjdk-17-jre, maven, gradle

# .NET
dotnet-sdk-8.0

# Node.js v20
nodejs, yarn

# Python
python3-pip, python3-venv, python3-dev

# Go
golang-go

# Ruby
ruby-full, bundler

# Rust
rustup (instalador oficial)
```

#### IDEs e Editores
```bash
# Visual Studio Code
code

# JetBrains Toolbox (IntelliJ, PyCharm, etc)
# Instalação via wget script

# Vim (incluído por padrão)
vim
```

#### Bancos de Dados
```bash
# PostgreSQL
postgresql, postgresql-contrib

# MySQL
mysql-server

# MongoDB
mongodb-org

# Redis
redis-server
```

#### DevOps e Ferramentas
```bash
# Docker + Compose
docker-ce, docker-ce-cli, docker-compose-plugin

# Git atualizado
git, git-lfs

# Postman (via Snap)
postman

# DBeaver (GUI BD, via Snap)
dbeaver-ce

# Insomnia (REST client, Snap)
insomnia
```

#### Navegadores
```bash
google-chrome-stable
microsoft-edge-stable
firefox (padrão)
```

#### Multimídia
```bash
spotify-client
obs-studio
steam-installer
vlc (padrão)
```

### Como Personalizar Pacotes

1. Abra `distro.sh` em um editor
2. Localize a seção "PACOTES BÁSICOS" e "FERRAMENTAS DE DESENVOLVIMENTO"
3. Descomente as linhas dos pacotes desejados:

```bash
# Antes (não instala)
# DEBIAN_FRONTEND=noninteractive apt install -y docker-ce

# Depois (instala)
DEBIAN_FRONTEND=noninteractive apt install -y docker-ce
```

### Pacotes Básicos (sempre instalados)

- **Kernel**: linux-generic, linux-generic-hwe
- **Sistema**: systemd-sysv, sudo, vim
- **Rede**: network-manager
- **Desktop**: xorg, lightdm, xfce4, xfce4-goodies
- **Apps**: firefox, vlc, gparted, zsh
- **Boot**: casper, grub-pc-bin, grub-efi-amd64-bin

## 🎨 Personalização

### Configuração do Sudo

O script oferece múltiplas opções de configuração do sudo para diferentes necessidades:

#### Opção 1: Sudo SEM Senha (Padrão Ativo)
**Ideal para:** Ambientes de desenvolvimento, uso pessoal, VMs de teste

```bash
# Já configurado por padrão no script
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
```

**Vantagens:**
- ✅ Não precisa digitar senha em cada comando sudo
- ✅ Ideal para desenvolvimento e automação
- ✅ Conveniente para uso diário

**Desvantagens:**
- ⚠️ Menos seguro para ambientes de produção
- ⚠️ Qualquer processo pode executar comandos privilegiados

#### Opção 2: Sudo COM Senha e Timeout Maior
**Ideal para:** Uso compartilhado, maior segurança com conveniência

Para ativar, edite `distro.sh` e descomente:

```bash
# OPÇÃO 2: Sudo COM senha mas com timeout maior
echo "Defaults timestamp_timeout=60" >> /etc/sudoers.d/sudo-timeout
```

E **comente** a OPÇÃO 1:
```bash
# echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
```

**Configurações de Timeout:**
- `timestamp_timeout=60` - 60 minutos (recomendado)
- `timestamp_timeout=30` - 30 minutos
- `timestamp_timeout=0` - Sempre pedir senha
- `timestamp_timeout=-1` - Nunca pedir senha novamente (sessão)

#### Opção 3: Sudo Padrão (Senha + 15 minutos)
**Ideal para:** Segurança máxima, ambientes multi-usuário

Comente a OPÇÃO 1 e 2 no script:
```bash
# echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
# echo "Defaults timestamp_timeout=60" >> /etc/sudoers.d/sudo-timeout
```

#### Opção 4: Desabilitar Senha de Root
**Ideal para:** Ambientes de desenvolvimento isolados

Descomente no script:
```bash
passwd -d root  # Remove senha do root
```

### Configuração Pós-Instalação

Se já criou a ISO, pode modificar depois:

```bash
# Adicionar usuário sem senha no sudo
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
sudo chmod 0440 /etc/sudoers.d/$USER

# Aumentar timeout do sudo
echo "Defaults timestamp_timeout=60" | sudo tee /etc/sudoers.d/sudo-timeout

# Voltar ao padrão
sudo rm /etc/sudoers.d/$USER
sudo rm /etc/sudoers.d/sudo-timeout
```

### GRUB Customizado

O script inclui um GRUB totalmente personalizado com:

#### Características Visuais
- **Tema escuro moderno** com cores cyan/preto
- **Banner ASCII Art** de boas-vindas
- **Timeout de 10 segundos** para seleção automática
- **Cores personalizadas** para melhor legibilidade

#### Opções de Boot Disponíveis

1. **Iniciar em Live Mode** (padrão)
   - Sistema completo com interface gráfica
   - Modo não persistente

2. **Modo Seguro**
   - Desabilita aceleração gráfica (nomodeset)
   - Útil para problemas de compatibilidade de hardware

3. **Modo Texto**
   - Sem interface gráfica
   - Apenas terminal/console

4. **Teste de Memória RAM**
   - Memtest86+ integrado
   - Diagnóstico de hardware

5. **Opções Avançadas** (submenu)
   - Boot com drivers proprietários desabilitados
   - Boot com ACPI desabilitado
   - Modo debug/verbose para diagnóstico

6. **Reiniciar/Desligar**
   - Opções diretas do menu

#### Personalizando o GRUB

Para modificar cores, edite as linhas no script:

```bash
# Cores do tema (linha ~233)
set color_normal=white/black          # Texto normal
set color_highlight=black/white       # Texto destacado
set menu_color_normal=cyan/black      # Menu normal
set menu_color_highlight=white/cyan   # Menu selecionado
```

**Esquema de cores disponíveis:**
- `black`, `blue`, `green`, `cyan`, `red`, `magenta`, `brown`, `light-gray`
- `dark-gray`, `light-blue`, `light-green`, `light-cyan`, `light-red`
- `light-magenta`, `yellow`, `white`

#### Adicionando Wallpaper ao GRUB

Para adicionar uma imagem de fundo:

```bash
# Adicione antes do menuentry (linha ~250)
if background_image /boot/grub/background.png; then
  set color_normal=white/black
  set color_highlight=black/white
else
  set menu_color_normal=cyan/black
  set menu_color_highlight=white/cyan
fi
```

Depois copie sua imagem PNG (640x480 ou 800x600) para:
```bash
sudo cp seu-wallpaper.png "$IMAGE_DIR/boot/grub/background.png"
```

#### Personalizando o Banner

Edite o banner ASCII no script (linha ~242):

```bash
echo "  ╔════════════════════════════════════════════╗"
echo "  ║         SEU TEXTO AQUI                     ║"
echo "  ╚════════════════════════════════════════════╝"
```

**Geradores de ASCII Art:**
- [patorjk.com/software/taag](https://patorjk.com/software/taag/)
- [ascii-generator.site](https://ascii-generator.site/)

### ISOLINUX Customizado (BIOS)

O menu de boot BIOS também foi personalizado com:
- **Cores temáticas** cyan/azul
- **Múltiplas opções** de boot
- **Menu estilizado** com separadores

Para personalizar as cores do ISOLINUX, edite a seção de cores (linha ~215):

```bash
MENU COLOR title    1;36;44    #ff00ffff #00000000 std  # Título
MENU COLOR sel      7;37;40    #e0000000 #20ff8000 all  # Seleção
MENU COLOR unsel    37;44      #50ffffff #00000000 std  # Não selecionado
```

### Adicionar/Remover Pacotes

Edite a seção de pacotes no script (linha ~103):

```bash
DEBIAN_FRONTEND=noninteractive apt install -y \
    linux-generic \
    # ... adicione ou remova pacotes aqui
```

### Mudar Ambiente Desktop

Substitua `xfce4 xfce4-goodies` por:
- **GNOME**: `ubuntu-desktop`
- **KDE**: `kubuntu-desktop`
- **MATE**: `ubuntu-mate-desktop`
- **LXQt**: `lubuntu-desktop`

### Configurações Adicionais

Adicione suas personalizações no script do chroot (após linha ~80).

## 📁 Estrutura de Diretórios

```
~/minha-distro/
├── chroot/              # Sistema base descompactado
├── image/               # Estrutura da ISO
│   ├── casper/         # Kernel, initrd e filesystem.squashfs
│   ├── isolinux/       # Configuração BIOS
│   ├── boot/grub/      # Configuração UEFI
│   └── EFI/boot/       # Imagem EFI
├── efi/                 # Arquivos temporários EFI
└── *.iso               # ISO final gerada
```

## 🐛 Solução de Problemas

### Drivers e Hardware

#### Drivers NVIDIA não funcionam
```bash
# Verificar GPU detectada
lspci | grep -i nvidia

# Reinstalar driver
sudo apt purge nvidia-* -y
sudo apt install nvidia-driver-535 -y
sudo reboot

# Verificar instalação
nvidia-smi
```

#### Problemas com drivers Intel
```bash
# Instalar drivers Intel completos
sudo apt install intel-gpu-tools intel-media-va-driver -y

# Verificar aceleração
vainfo
```

#### Atualizar kernel para hardware novo
```bash
# Instalar Mainline (GUI para kernels)
sudo apt install mainline -y
mainline-gtk  # Interface gráfica

# Ou instalar kernel OEM manualmente
sudo apt install linux-oem-22.04 -y
sudo reboot
```

### Desenvolvimento

#### VSCode não abre
```bash
# Reinstalar
sudo apt remove code -y
sudo apt update
sudo apt install code -y

# Ou via Snap
sudo snap install code --classic
```

#### Docker permissões negadas
```bash
# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
newgrp docker

# Testar
docker run hello-world
```

#### Node.js/NPM comandos não encontrados
```bash
# Verificar versão instalada
node --version
npm --version

# Se não instalado, instalar Node.js 20
sudo apt update
sudo apt install nodejs -y
```

#### .NET SDK não encontrado
```bash
# Verificar instalação
dotnet --version

# Reinstalar se necessário
sudo apt install dotnet-sdk-8.0 -y
```

#### PostgreSQL não inicia
```bash
# Verificar status
sudo systemctl status postgresql

# Iniciar manualmente
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Acessar
sudo -u postgres psql
```

### Vagrant

#### VM não inicia
```bash
# Verificar status
vagrant status

# Ver logs detalhados
vagrant up --debug

# Reinstalar VM do zero
vagrant destroy -f
vagrant up
```

#### Interface gráfica não aparece
1. Abra o VirtualBox Manager
2. Clique duas vezes na VM "MyDistroLinux Builder"
3. A janela deve aparecer com login automático

#### Erro de permissões dentro da VM
```bash
vagrant ssh
sudo chmod +x /vagrant/distro.sh
```

### Sistema Local

#### Erro no debootstrap
- Verifique sua conexão com a internet
- Confira o log: `/tmp/debootstrap.log`

### Erro ao criar squashfs
- Verifique espaço em disco disponível
- Confira o log: `/tmp/mksquashfs.log`

### Erro ao criar ISO
- Verifique se todos os pacotes estão instalados
- Confira o log: `/tmp/xorriso.log`

### Sistema não inicia
- Teste a ISO em máquina virtual primeiro (VirtualBox, QEMU)
- Verifique se habilitou UEFI/Secure Boot na VM

## 🧪 Testando a ISO

### Opção 1: Vagrant (Dentro da VM)
Se você usou Vagrant, a ISO estará em `/home/vagrant/minha-distro/` dentro da VM.

### Opção 2: VirtualBox (Manual)
```bash
# Criar e iniciar VM
VBoxManage createvm --name "MinhaDistro" --register
VBoxManage modifyvm "MinhaDistro" --memory 2048 --vram 128 --cpus 2
VBoxManage storagectl "MinhaDistro" --name "IDE" --add ide
VBoxManage storageattach "MinhaDistro" --storagectl "IDE" \
    --port 0 --device 0 --type dvddrive \
    --medium ~/minha-distro/MinhaDistro-1.0-amd64.iso
```

### Opção 3: QEMU
```bash
# Criar e iniciar VM
VBoxManage createvm --name "MinhaDistro" --register
VBoxManage modifyvm "MinhaDistro" --memory 2048 --vram 128 --cpus 2
VBoxManage storagectl "MinhaDistro" --name "IDE" --add ide
VBoxManage storageattach "MinhaDistro" --storagectl "IDE" \
    --port 0 --device 0 --type dvddrive \
    --medium ~/minha-distro/MinhaDistro-1.0-amd64.iso
```

### QEMU
```bash
qemu-system-x86_64 -m 2048 -cdrom ~/minha-distro/MinhaDistro-1.0-amd64.iso -boot d
```

### Gravar em USB
```bash
# CUIDADO: Substitua /dev/sdX pelo dispositivo correto!
# Use 'lsblk' para identificar o dispositivo USB
sudo dd if=~/minha-distro/MinhaDistro-1.0-amd64.iso of=/dev/sdX bs=4M status=progress && sync
```

**No Windows (use Rufus ou balenaEtcher):**
- [Rufus](https://rufus.ie/) - Recomendado
- [balenaEtcher](https://www.balena.io/etcher/) - Multiplataforma

**No macOS:**
```bash
# Identificar o disco
diskutil list

# Desmontar o disco (substitua diskN)
diskutil unmountDisk /dev/diskN

# Gravar ISO
sudo dd if=MinhaDistro-1.0-amd64.iso of=/dev/rdiskN bs=1m
```

## 📝 Logs

Os logs de construção ficam em `/tmp/`:
- `/tmp/debootstrap.log` - Instalação do sistema base
- `/tmp/chroot-setup.log` - Configuração do chroot
- `/tmp/mksquashfs.log` - Criação do filesystem comprimido
- `/tmp/grub-standalone.log` - Criação do bootloader UEFI
- `/tmp/xorriso.log` - Geração da ISO

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir novas funcionalidades
- Enviar pull requests

## 📄 Licença

Este projeto é de código aberto. Sinta-se livre para usar, modificar e distribuir.

## ⚠️ Avisos

- Este script requer privilégios de superusuário (sudo)
- O processo consome bastante CPU, memória e disco
- **Vagrant**: A primeira execução baixa ~1GB (Ubuntu box)
- **Local**: Não execute em sistemas de produção sem testar antes
- Sempre teste a ISO em ambiente virtual antes de usar em hardware real
- No Windows/Mac, use Vagrant para melhor experiência

## 🔗 Recursos Úteis

- [Documentação Ubuntu Customization](https://help.ubuntu.com/community/LiveCDCustomization)
- [Debian Debootstrap](https://wiki.debian.org/Debootstrap)
- [ISOLINUX Documentation](https://wiki.syslinux.org/wiki/index.php?title=ISOLINUX)
- [GRUB Manual](https://www.gnu.org/software/grub/manual/)

## 🔄 CI/CD e Versionamento

Este projeto utiliza GitHub Actions para automação completa de releases e controle de qualidade.

### Workflows Disponíveis

#### 1. Validação Contínua (`validate.yml`)
- **Trigger**: Push ou PR em `main`/`develop`
- **Ações**:
  - ✅ Validação de sintaxe bash
  - ✅ Análise com ShellCheck
  - ✅ Verificação de permissões
  - ✅ Resumo no GitHub

#### 2. Linter e Quality Check (`lint.yml`)
- **Trigger**: Push ou PR em `main`/`develop`
- **Ações**:
  - ✅ ShellCheck detalhado
  - ✅ Validação de Markdown
  - ✅ Verificações básicas

#### 3. Release Automática (`tag-release.yml`)
- **Trigger**: Push de tags `v*` (exemplo: `v1.0.0`)
- **Ações**:
  - ✅ Validação completa
  - ✅ Geração de changelog automático
  - ✅ Criação de release no GitHub
  - ✅ Upload de arquivos:
    - `distro.sh` - Script principal
    - `README.md` - Documentação
    - `mydistrolinux-X.Y.Z.zip` - Pacote completo
    - `install.sh` - Instalador rápido

### Como Criar uma Release

#### Método 1: Script Interativo (Recomendado)
```bash
# Executar script de release
./release.sh

# Escolher tipo de release:
# 1) patch  - Correções (1.0.0 → 1.0.1)
# 2) minor  - Features (1.0.0 → 1.1.0)
# 3) major  - Breaking (1.0.0 → 2.0.0)
# 4) custom - Versão específica

# O script automaticamente:
# - Atualiza VERSION
# - Cria tag anotada
# - Faz push (opcional)
```

#### Método 2: Tag Manual
```bash
# Criar e enviar tag
git tag -a v1.2.0 -m "Release 1.2.0 - Nova funcionalidade X"
git push origin v1.2.0

# O CI/CD automaticamente:
# 1. Detecta a tag
# 2. Valida o código
# 3. Gera changelog
# 4. Cria release no GitHub
# 5. Faz upload dos arquivos
```

#### Método 3: GitHub Interface
1. Acesse: `https://github.com/1985epma/mydistrolinux/releases/new`
2. Crie uma nova tag (ex: `v1.2.0`)
3. Preencha título e descrição
4. Publique a release
5. O CI/CD será executado automaticamente
git tag -a v1.2.0 -m "Release 1.2.0 - Descrição"
git push origin v1.2.0

# O CI/CD detecta a tag e cria a release
```

### Estrutura de Versões

Seguimos [Semantic Versioning](https://semver.org/):

```
MAJOR.MINOR.PATCH
  │     │     │
  │     │     └─ Correções de bugs
  │     └─────── Novas funcionalidades (compatível)
  └───────────── Mudanças incompatíveis
```

### Badges de Status

[![Release](https://img.shields.io/github/v/release/1985epma/mydistrolinux)](https://github.com/1985epma/mydistrolinux/releases)
[![CI/CD](https://img.shields.io/github/actions/workflow/status/1985epma/mydistrolinux/release.yml)](https://github.com/1985epma/mydistrolinux/actions)
[![License](https://img.shields.io/github/license/1985epma/mydistrolinux)](LICENSE)

### Arquivos de Release

Cada release inclui:
- `distro.sh` - Script principal
- `README.md` - Documentação completa
- `mydistrolinux-X.Y.Z.zip` - Pacote completo
- `install.sh` - Instalador rápido
- Changelog automático com histórico de commits

## 👤 Autor

**Everton** - [@1985epma](https://github.com/1985epma)

---

**Nota**: Este é um projeto educacional/experimental. Para distribuições de produção, considere usar ferramentas mais robustas como Ubuntu Customization Kit ou Live-Build.