# 📦 Repositórios e Pacotes Disponíveis

Este documento lista todos os repositórios e pacotes disponíveis no MyDistroLinux Builder.

## 📚 Repositórios Configurados

Todos os repositórios abaixo são configurados automaticamente pelo script `distro.sh`, garantindo acesso às versões mais recentes de software.

### 🖥️ Kernel e Drivers de Hardware

| Repositório | Descrição | Pacotes Principais |
|-------------|-----------|-------------------|
| **Kernel Mainline PPA** | Kernels Linux mais recentes | `mainline`, kernels 6.x+ |
| **Graphics Drivers PPA** | Drivers gráficos atualizados | `nvidia-driver-535`, `mesa-vulkan-drivers` |
| **Intel Graphics (oficial)** | Drivers Intel otimizados | `intel-media-va-driver`, `intel-gpu-tools` |
| **Ubuntu Backports** | Kernels e drivers recentes | `linux-oem-22.04` |

**GPG Keys:**
- Kernel Mainline: `78BD65473CB3BD13`
- Graphics Drivers: PPA automático

**Por que usar:**
- ✅ Suporte para hardware mais recente
- ✅ Melhor desempenho gráfico
- ✅ Correções de bugs de kernel
- ✅ Compatibilidade com GPUs recentes

---

### 🌐 Navegadores

| Repositório | Descrição | Instalação |
|-------------|-----------|-----------|
| **Google Chrome** | Navegador oficial Google | `google-chrome-stable` |
| **Microsoft Edge** | Navegador oficial Microsoft | `microsoft-edge-stable` |

**GPG Keys:**
- Google: `https://dl.google.com/linux/linux_signing_key.pub`
- Microsoft: `https://packages.microsoft.com/keys/microsoft.asc`

---

### 💻 Ferramentas de Desenvolvimento

#### Visual Studio Code
- **Repositório:** `https://packages.microsoft.com/repos/code`
- **Pacote:** `code`
- **GPG Key:** Microsoft oficial

#### Docker
- **Repositório:** `https://download.docker.com/linux/ubuntu`
- **Pacotes:** `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-compose-plugin`
- **GPG Key:** Docker oficial (`9DC858229FC7DD38854AE2D88D81803C0EBFCD88`)

#### Git (versão mais recente)
- **PPA:** `ppa:git-core/ppa`
- **Pacotes:** `git`, `git-lfs`

#### .NET SDK
- **Repositório:** `https://packages.microsoft.com/ubuntu/`
- **Pacotes:** `dotnet-sdk-8.0`
- **GPG Key:** Microsoft oficial

#### Node.js 20.x
- **Repositório:** NodeSource oficial
- **Pacotes:** `nodejs`
- **Setup:** Via script NodeSource

#### Yarn
- **Repositório:** `https://dl.yarnpkg.com/debian/`
- **Pacote:** `yarn`
- **GPG Key:** Yarn oficial

#### PostgreSQL
- **Repositório:** `https://apt.postgresql.org/pub/repos/apt`
- **Pacotes:** `postgresql`, `postgresql-contrib`
- **GPG Key:** PostgreSQL oficial (`ACCC4CF8`)

---

### 🎵 Multimídia e Gaming

| Repositório | Descrição | Pacotes |
|-------------|-----------|---------|
| **Spotify** | Streaming de música | `spotify-client` |
| **OBS Studio PPA** | Gravação/streaming | `obs-studio` |
| **Steam** | Plataforma de jogos | `steam-installer` |

**PPA OBS Studio:** `ppa:obsproject/obs-studio`

---

### 💬 Comunicação e Colaboração

| Repositório | Descrição | Instalação |
|-------------|-----------|-----------|
| **Microsoft Teams** | Videoconferência e chat | `teams` |
| **Zoom** | Videoconferência | `zoom` |
| **Slack** | Chat corporativo | Snap: `slack` |
| **Discord** | Comunicação e comunidades | Snap: `discord` |

**GPG Keys:**
- Microsoft Teams: Mesma chave Microsoft oficial
- Zoom: `https://zoom.us/linux/download/pubkey`

---

### 🔧 Ferramentas Git e DevOps

| Repositório | Descrição | Pacotes |
|-------------|-----------|---------|
| **GitHub CLI** | Linha de comando GitHub | `gh` |
| **GitHub Desktop** | Interface gráfica GitHub | `github-desktop` (download direto) |
| **GitLab Runner** | CI/CD GitLab | `gitlab-runner` |

**GPG Keys:**
- GitHub CLI: `https://cli.github.com/packages/githubcli-archive-keyring.gpg`
- GitLab Runner: `https://packages.gitlab.com/runner/gitlab-runner/gpgkey`

**Comandos úteis:**
```bash
# GitHub CLI
gh auth login        # Autenticar no GitHub
gh repo clone        # Clonar repositório
gh pr create         # Criar pull request

# GitLab Runner
gitlab-runner register   # Registrar runner
gitlab-runner run        # Executar runner
```

---

### ☁️ Cloud e Infraestrutura como Código

| Repositório | Descrição | Pacotes |
|-------------|-----------|---------|
| **Google Cloud SDK** | Ferramentas GCP | `google-cloud-cli`, `gke-gcloud-auth-plugin` |
| **Azure CLI** | Ferramentas Azure | `azure-cli` |
| **HashiCorp** | Terraform, Packer, Vault | `terraform`, `packer`, `vault` |
| **Kubernetes** | Orquestração de containers | `kubectl` |
| **AWS CLI** | Ferramentas AWS | Download direto (v2) |
| **Pulumi** | IaC multi-cloud | Instalador oficial |

**GPG Keys:**
- Google Cloud: `https://packages.cloud.google.com/apt/doc/apt-key.gpg`
- Azure CLI: Microsoft oficial
- HashiCorp: `https://apt.releases.hashicorp.com/gpg`
- Kubernetes: `https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key`

**Comandos úteis:**
```bash
# Google Cloud
gcloud init                    # Configurar credenciais
gcloud compute instances list  # Listar VMs

# Azure
az login                       # Autenticar
az vm list                     # Listar VMs

# AWS CLI
aws configure                  # Configurar credenciais
aws s3 ls                      # Listar buckets

# Terraform
terraform init                 # Inicializar projeto
terraform plan                 # Planejar mudanças
terraform apply                # Aplicar infraestrutura

# Kubectl
kubectl get pods               # Listar pods
kubectl apply -f deploy.yaml   # Aplicar manifesto

# Minikube
minikube start                 # Iniciar cluster local
minikube dashboard             # Abrir dashboard
```

**Ferramentas Adicionais:**
- **Podman** - Alternativa ao Docker sem daemon
- **Minikube** - Kubernetes local para desenvolvimento
- **Neovim** - Editor de texto moderno e extensível

---

### 📦 Flatpak e Flathub

| Componente | Descrição | Status |
|------------|-----------|--------|
| **Flatpak** | Gerenciador de pacotes universal | Instalado por padrão |
| **Flathub** | Repositório com 2000+ apps | Configurado automaticamente |
| **GNOME Software Plugin** | Integração com loja de apps | Instalado |

**Repositório Flathub:** `https://flathub.org/repo/flathub.flatpakrepo`

**Categorias de Apps Disponíveis:**
- 🎨 Design e Criação (GIMP, Inkscape, Blender)
- 📝 Produtividade (LibreOffice, Thunderbird)
- 🎵 Multimídia (VLC, Audacity, Kdenlive, OBS)
- 💬 Comunicação (Telegram, Spotify, Discord)
- 🎮 Gaming (Steam, Lutris, RetroArch)
- 💻 Desenvolvimento (VS Code, Android Studio, IDEs)

**Comandos úteis:**
```bash
# Pesquisar
flatpak search gimp

# Instalar
flatpak install flathub org.gimp.GIMP

# Listar instalados
flatpak list

# Atualizar todos
flatpak update

# Remover
flatpak uninstall org.gimp.GIMP

# Ver informações
flatpak info org.gimp.GIMP
```

---

## 📦 Pacotes Disponíveis para Instalação

Todos os pacotes abaixo podem ser instalados editando o arquivo `distro.sh` e descomentando as linhas correspondentes.

### 🔧 Drivers de Hardware

```bash
# NVIDIA (detecta GPU automaticamente)
nvidia-driver-535
nvidia-utils-535

# AMD (drivers Mesa atualizados)
mesa-vulkan-drivers
mesa-vdpau-drivers

# Intel Graphics
intel-gpu-tools
intel-media-va-driver

# Kernel Mainline Manager (GUI)
mainline
```

### 💻 Linguagens de Programação

```bash
# Java (OpenJDK)
openjdk-17-jdk
openjdk-17-jre
maven
gradle

# .NET Core/8.0
dotnet-sdk-8.0

# Node.js v20
nodejs
npm (incluído com Node.js)

# Yarn
yarn

# Python 3
python3-pip
python3-venv
python3-dev
build-essential

# Go
golang-go

# Ruby
ruby-full
bundler

# Rust (via rustup)
rustup
cargo
```

### 🛠️ IDEs e Editores

```bash
# Visual Studio Code
code

# Vim (incluído por padrão)
vim

# JetBrains Toolbox (gerenciador)
# Baixa via wget, instala IntelliJ IDEA, PyCharm, etc.
jetbrains-toolbox
```

### 🗄️ Bancos de Dados

```bash
# PostgreSQL
postgresql
postgresql-contrib

# MySQL
mysql-server

# MongoDB (requer repo adicional)
mongodb-org

# Redis
redis-server
```

### 🐳 DevOps e Containers

```bash
# Docker Engine
docker-ce
docker-ce-cli
containerd.io

# Docker Compose (plugin)
docker-compose-plugin

# Docker Buildx (plugin)
docker-buildx-plugin

# Podman (alternativa Docker)
podman
podman-compose

# Git (versão mais recente)
git
git-lfs

# GitHub CLI
gh

# GitHub Desktop
github-desktop

# GitLab Runner
gitlab-runner
```

### ☁️ Cloud e Infraestrutura

```bash
# Google Cloud SDK
google-cloud-cli
google-cloud-cli-gke-gcloud-auth-plugin

# Azure CLI
azure-cli

# AWS CLI (via instalador)
# Download: https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip

# Terraform
terraform

# Pulumi (via instalador)
# curl -fsSL https://get.pulumi.com | sh

# Kubernetes CLI
kubectl

# Minikube (via download)
# https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```

### ✏️ Editores e Ferramentas

```bash
# Neovim (moderno e extensível)
neovim

# Vim (clássico)
vim

# Visual Studio Code
code
```

# Git (versão mais recente)
git
git-lfs

# GitHub CLI
gh

# GitHub Desktop
github-desktop

# GitLab Runner
gitlab-runner
```

### 💬 Comunicação e Colaboração

```bash
# Microsoft Teams
teams

# Zoom
zoom

# Slack (via Snap)
slack

# Discord (via Snap)
discord
```

### 🌐 Navegadores

```bash
# Google Chrome
google-chrome-stable

# Microsoft Edge
microsoft-edge-stable

# Firefox (incluído por padrão)
firefox
```

### 🎵 Multimídia

```bash
# Spotify
spotify-client

# OBS Studio
obs-studio

# Steam
steam-installer

# VLC (incluído por padrão)
vlc
```

### 📦 Aplicativos via Flatpak (Flathub)

```bash
# DESIGN E CRIAÇÃO
org.gimp.GIMP                    # Editor de imagens profissional
org.inkscape.Inkscape            # Editor gráfico vetorial
org.blender.Blender              # Modelagem 3D e animação
org.kde.krita                    # Pintura digital
com.github.maoschanz.drawing     # Desenho simples

# PRODUTIVIDADE
org.libreoffice.LibreOffice      # Suite de escritório completa
org.mozilla.Thunderbird          # Cliente de e-mail
com.jgraph.drawio.desktop        # Diagramas e fluxogramas
md.obsidian.Obsidian             # Notas em Markdown

# MULTIMÍDIA
org.videolan.VLC                 # Player de vídeo universal
org.audacityteam.Audacity        # Editor de áudio
org.kde.kdenlive                 # Editor de vídeo profissional
com.obsproject.Studio            # OBS Studio (streaming)
fr.handbrake.ghb                 # Conversor de vídeo
org.shotcut.Shotcut              # Editor de vídeo alternativo

# COMUNICAÇÃO
org.telegram.desktop             # Telegram messenger
com.spotify.Client               # Spotify music
com.discordapp.Discord           # Discord
com.slack.Slack                  # Slack
us.zoom.Zoom                     # Zoom conferências

# GAMING
com.valvesoftware.Steam          # Steam platform
net.lutris.Lutris                # Gaming platform Linux
org.libretro.RetroArch           # Emuladores retro

# DESENVOLVIMENTO
com.visualstudio.code            # VS Code (alternativa)
com.jetbrains.IntelliJ-IDEA-Community  # IntelliJ IDEA
org.gnome.Builder                # GNOME Builder IDE
com.getpostman.Postman           # API testing

# UTILIDADES
com.mattjakeman.ExtensionManager # Gerenciar extensões GNOME
org.gnome.Calculator             # Calculadora
org.gnome.FileRoller             # Gerenciador de arquivos compactados
```

### 📊 Ferramentas de Produtividade (via Snap)

```bash
# Postman (API testing)
snap install postman

# DBeaver (GUI para bancos de dados)
snap install dbeaver-ce

# Insomnia (REST client)
snap install insomnia
```

---

## 🚀 Como Instalar Pacotes

### Método 1: Durante a Criação da ISO

1. Abra o arquivo `distro.sh` em um editor
2. Localize a seção **"FERRAMENTAS DE DESENVOLVIMENTO"**
3. Descomente as linhas dos pacotes desejados:

```bash
# Antes (não será instalado)
# DEBIAN_FRONTEND=noninteractive apt install -y docker-ce

# Depois (será instalado na ISO)
DEBIAN_FRONTEND=noninteractive apt install -y docker-ce
```

4. Salve e execute o script normalmente

### Método 2: Após a Instalação da Distro

Se já criou a ISO, pode instalar pacotes depois:

```bash
# Atualizar repositórios
sudo apt update

# Instalar pacote desejado
sudo apt install <nome-do-pacote>
```

**Exemplos:**
```bash
# Instalar Docker
sudo apt install docker-ce docker-ce-cli containerd.io

# Instalar VSCode
sudo apt install code

# Instalar .NET SDK
sudo apt install dotnet-sdk-8.0

# Instalar Node.js
sudo apt install nodejs

# Instalar PostgreSQL
sudo apt install postgresql
```

---

## 🔑 Gerenciamento de GPG Keys

Todas as chaves GPG são automaticamente importadas pelo script. Caso precise adicionar manualmente:

```bash
# Adicionar chave de repositório
curl -fsSL <URL-da-chave> | gpg --dearmor -o /etc/apt/trusted.gpg.d/<nome>.gpg

# Adicionar repositório
echo "deb [signed-by=/etc/apt/trusted.gpg.d/<nome>.gpg] <URL> <codename> <componente>" | sudo tee /etc/apt/sources.list.d/<nome>.list

# Atualizar
sudo apt update
```

---

## 📋 Verificar Repositórios Configurados

Para ver todos os repositórios ativos na sua distro:

```bash
# Listar todos os repositórios
cat /etc/apt/sources.list
ls /etc/apt/sources.list.d/

# Ver chaves GPG instaladas
apt-key list
ls /etc/apt/trusted.gpg.d/

# Atualizar e ver se há erros
sudo apt update
```

---

---

### 🍺 Homebrew (Gerenciador de Pacotes)

| Componente | Descrição | Status |
|------------|-----------|--------|
| **Homebrew** | Gerenciador de pacotes universal | Instalação opcional |
| **Formulae** | 6000+ pacotes disponíveis | Acesso após instalação |
| **Casks** | Apps GUI para Linux | Suporte limitado no Linux |

**Site oficial:** `https://brew.sh`

**Instalação:**
O Homebrew é instalado como usuário (não root) e fica em `/home/linuxbrew/.linuxbrew/`

**Comandos úteis:**
```bash
# Pesquisar pacotes
brew search <nome>

# Informações sobre pacote
brew info <pacote>

# Instalar
brew install <pacote>

# Atualizar Homebrew
brew update

# Atualizar pacotes
brew upgrade

# Listar instalados
brew list

# Remover pacote
brew uninstall <pacote>

# Limpar cache
brew cleanup
```

**Pacotes populares via Homebrew:**
```bash
# Ferramentas modernas
brew install ripgrep       # Busca rápida (rg)
brew install bat           # Cat com syntax highlight
brew install exa           # ls melhorado
brew install fd            # find melhorado
brew install fzf           # Fuzzy finder

# Desenvolvimento
brew install node          # Node.js
brew install python@3.12   # Python
brew install go            # Golang
brew install rust          # Rust
brew install gcc           # GCC

# DevOps
brew install k9s           # Kubernetes TUI
brew install helm          # Kubernetes package manager
brew install kind          # Kubernetes in Docker

# Utilitários
brew install htop          # Monitor de processos
brew install tmux          # Terminal multiplexer
brew install neofetch      # System info
```

**Vantagens do Homebrew:**
- ✅ Versões mais recentes que apt
- ✅ Instalação sem sudo
- ✅ Isolamento do sistema
- ✅ Fácil atualização de tudo
- ✅ Comunidade ativa

---

### ⚙️ Configurações Avançadas

### Sudo sem Senha (Padrão)

Por padrão, o script configura sudo sem senha para conveniência em desenvolvimento:

```bash
# Já configurado automaticamente
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
```

Para **desabilitar** e exigir senha, edite `distro.sh` e comente:
```bash
# echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
```

### Opções de Sudo Disponíveis

| Configuração | Descrição | Segurança |
|--------------|-----------|-----------|
| **NOPASSWD** (padrão) | Sudo sem senha | ⚠️ Baixa |
| **Timeout 60min** | Senha válida por 1 hora | ⚡ Média |
| **Padrão (15min)** | Senha válida por 15 min | ✅ Alta |
| **Sempre pedir** | Senha em cada comando | 🔒 Máxima |

**Exemplo - Timeout personalizado:**
```bash
# Adicione em distro.sh
echo "Defaults timestamp_timeout=30" >> /etc/sudoers.d/sudo-timeout
```

---

## ⚠️ Notas Importantes

1. **Oracle Java:** Requer aceitação manual de licença. Prefira OpenJDK.
2. **MongoDB:** Requer configuração adicional de repositório (não incluído por padrão).
3. **JetBrains:** Instalação via wget/script, não via apt.
4. **Rust:** Instalado via rustup, não via apt.
5. **Snap packages:** Alguns pacotes só estão disponíveis via Snap.

---

## 🔄 Atualizações

Para manter todos os pacotes atualizados:

```bash
# Atualizar lista de pacotes
sudo apt update

# Atualizar todos os pacotes instalados
sudo apt upgrade -y

# Atualizar distribuição completa
sudo apt dist-upgrade -y

# Limpar cache
sudo apt autoremove -y
sudo apt autoclean
```

---

## 📚 Recursos Adicionais

- **Kernel Mainline:** https://github.com/bkw777/mainline
- **Docker Docs:** https://docs.docker.com/engine/install/ubuntu/
- **VSCode:** https://code.visualstudio.com/docs/setup/linux
- **.NET SDK:** https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
- **Node.js:** https://github.com/nodesource/distributions
- **PostgreSQL:** https://www.postgresql.org/download/linux/ubuntu/

---

**Data de última atualização:** 2024
**Compatibilidade:** Ubuntu 22.04 LTS (Jammy) e 24.04 LTS (Noble)
