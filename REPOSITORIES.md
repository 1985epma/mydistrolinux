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

# Git (versão mais recente)
git
git-lfs
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

## ⚙️ Configurações Avançadas

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
