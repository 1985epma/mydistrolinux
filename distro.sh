#!/usr/bin/env bash

set -e

### FUNÇÕES AUXILIARES ###

erro() {
  zenity --error --title="Erro" --text="$1"
  exit 1
}

info() {
  zenity --info --title="Informação" --text="$1"
}

pergunta() {
  zenity --question --title="Confirmação" --text="$1"
}

### 1) COLETAR INFORMAÇÕES COM ZENITY ###

# Nome da distro
DISTRO_NAME=$(zenity --entry \
    --title="Nome da Distro" \
    --text="Digite o nome da sua distribuição:" \
    --entry-text="MinhaDistro") || exit 1
[ -z "$DISTRO_NAME" ] && erro "Nome da distro não pode ser vazio."

# Versão da distro
DISTRO_VERSION=$(zenity --entry \
    --title="Versão da Distro" \
    --text="Digite a versão da sua distribuição:" \
    --entry-text="1.0") || exit 1
[ -z "$DISTRO_VERSION" ] && erro "Versão da distro não pode ser vazia."

# Release do Ubuntu
UBUNTU_RELEASE=$(zenity --list \
    --title="Release do Ubuntu" \
    --text="Escolha a release base do Ubuntu:" \
    --radiolist \
    --column="Selecionar" --column="Release" --column="Descrição" \
    TRUE  "jammy" "Ubuntu 22.04 LTS" \
    FALSE "noble" "Ubuntu 24.04 LTS") || exit 1

# Usuário padrão
USERNAME=$(zenity --entry \
    --title="Usuário Padrão" \
    --text="Digite o nome do usuário padrão:" \
    --entry-text="everton") || exit 1
[ -z "$USERNAME" ] && erro "Usuário não pode ser vazio."

# Senha padrão
PASSWORD=$(zenity --password \
    --title="Senha do Usuário Padrão") || exit 1
[ -z "$PASSWORD" ] && erro "Senha não pode ser vazia."

# Confirmação
pergunta "Criar distro:\n\nNome: $DISTRO_NAME\nVersão: $DISTRO_VERSION\nBase Ubuntu: $UBUNTU_RELEASE\nUsuário padrão: $USERNAME\n\nDeseja continuar?"
[ $? -ne 0 ] && exit 0

### 2) VARIÁVEIS BÁSICAS ###

ARCH="amd64"
WORKDIR="$HOME/minha-distro"
CHROOT_DIR="$WORKDIR/chroot"
IMAGE_DIR="$WORKDIR/image"
EFI_DIR="$WORKDIR/efi"
UBUNTU_MIRROR="http://archive.ubuntu.com/ubuntu"

mkdir -p "$CHROOT_DIR" "$IMAGE_DIR"/{casper,isolinux,boot/grub} "$EFI_DIR"

### 3) BARRA DE PROGRESSO GERAL ###

(
  P=0
  STEP() { P=$((P + $1)); echo "$P"; echo "# $2"; }

  # 3.1 Debootstrap
  STEP 5 "Preparando ambiente... (5%)"
  sleep 1

  STEP 10 "Instalando sistema base Ubuntu com debootstrap... (15%)"
  sudo debootstrap --arch="$ARCH" "$UBUNTU_RELEASE" "$CHROOT_DIR" "$UBUNTU_MIRROR" > /tmp/debootstrap.log 2>&1 || erro "Falha no debootstrap. Veja /tmp/debootstrap.log"

  # 3.2 Montar sistemas de arquivos
  STEP 10 "Montando /dev, /proc, /sys dentro do chroot... (25%)"
  sudo mount --bind /dev "$CHROOT_DIR/dev"
  sudo mount --bind /run "$CHROOT_DIR/run"
  sudo mount -t proc /proc "$CHROOT_DIR/proc"
  sudo mount -t sysfs /sys "$CHROOT_DIR/sys"
  sudo mount -t devpts devpts "$CHROOT_DIR/dev/pts"

  # 3.3 Script interno do chroot
  STEP 5 "Criando script de configuração dentro do chroot... (30%)"
  CHROOT_SCRIPT="/tmp/chroot-setup.sh"
  sudo tee "$CHROOT_DIR$CHROOT_SCRIPT" > /dev/null << EOF_CHROOT
#!/usr/bin/env bash
set -e

echo "==> Dentro do chroot: configurando sistema básico..."

echo "minhadistro" > /etc/hostname

cat << EOT > /etc/hosts
127.0.0.1   localhost
127.0.1.1   minhadistro
::1         localhost ip6-localhost ip6-loopback
EOT

cat << EOT > /etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu $UBUNTU_RELEASE main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu $UBUNTU_RELEASE-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu $UBUNTU_RELEASE-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu $UBUNTU_RELEASE-backports main restricted universe multiverse
EOT

# Adicionar repositórios de terceiros

# ===== KERNEL E DRIVERS =====

# Kernel Mainline (kernels mais recentes)
apt-add-repository -y ppa:cappelikan/ppa

# Graphics Drivers PPA (NVIDIA, AMD, Intel drivers atualizados)
apt-add-repository -y ppa:graphics-drivers/ppa

# OEM Kernel (otimizado para hardware mais recente)
# Disponível nos repositórios padrão

# Intel Graphics (repositório oficial Intel)
wget -qO- https://repositories.intel.com/gpu/intel-graphics.key | gpg --dearmor -o /usr/share/keyrings/intel-graphics.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu $UBUNTU_RELEASE client" > /etc/apt/sources.list.d/intel-graphics.list

# ===== NAVEGADORES =====

# Google Chrome
wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Microsoft Edge
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-edge-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge-keyring.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list

# ===== FERRAMENTAS DE DESENVOLVIMENTO =====

# Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list

# Docker (containerização)
wget -qO- https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $UBUNTU_RELEASE stable" > /etc/apt/sources.list.d/docker.list

# Git (versão mais recente)
apt-add-repository -y ppa:git-core/ppa

# .NET SDK (Microsoft)
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-dotnet.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-dotnet.gpg] https://packages.microsoft.com/ubuntu/$UBUNTU_RELEASE/prod $UBUNTU_RELEASE main" > /etc/apt/sources.list.d/dotnet.list

# NodeJS (via NodeSource)
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg
echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" > /etc/apt/sources.list.d/nodesource.list

# Yarn (gerenciador de pacotes JavaScript)
wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn.gpg
echo "deb [signed-by=/usr/share/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

# PostgreSQL (banco de dados)
wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql.gpg
echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt $UBUNTU_RELEASE-pgdg main" > /etc/apt/sources.list.d/postgresql.list

# ===== MULTIMÍDIA =====

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | gpg --dearmor -o /usr/share/keyrings/spotify-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/spotify-keyring.gpg] http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list

# OBS Studio
apt-add-repository -y ppa:obsproject/obs-studio

# ===== COMUNICAÇÃO E COLABORAÇÃO =====

# Microsoft Teams
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/teams.gpg
echo "deb [signed-by=/usr/share/keyrings/teams.gpg arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list

# Zoom
wget -qO /tmp/zoom_pubkey.gpg https://zoom.us/linux/download/pubkey
gpg --dearmor -o /usr/share/keyrings/zoom.gpg < /tmp/zoom_pubkey.gpg
echo "deb [signed-by=/usr/share/keyrings/zoom.gpg] https://zoom.us/linux/deb/ stable main" > /etc/apt/sources.list.d/zoom.list

# ===== FERRAMENTAS GIT/DEVOPS =====

# GitHub CLI (gh)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list

# GitLab Runner (opcional - para CI/CD)
curl -fsSL https://packages.gitlab.com/runner/gitlab-runner/gpgkey | gpg --dearmor -o /usr/share/keyrings/gitlab-runner.gpg
echo "deb [signed-by=/usr/share/keyrings/gitlab-runner.gpg] https://packages.gitlab.com/runner/gitlab-runner/ubuntu/ $UBUNTU_RELEASE main" > /etc/apt/sources.list.d/gitlab-runner.list

# Steam (repositório multiverse já está habilitado)
dpkg --add-architecture i386

apt update

# PACOTES BÁSICOS - customize aqui
DEBIAN_FRONTEND=noninteractive apt install -y \
    linux-generic \
    linux-generic-hwe-$(lsb_release -rs | cut -d. -f1).$(lsb_release -rs | cut -d. -f2) \
    systemd-sysv \
    sudo \
    vim \
    network-manager \
    casper \
    discover \
    laptop-detect \
    os-prober \
    grub-pc-bin \
    grub-efi-amd64-bin \
    dialog \
    wget \
    curl \
    xorg \
    lightdm \
    xfce4 xfce4-goodies \
    firefox \
    zsh \
    vlc \
    gparted \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# DRIVERS DE HARDWARE (descomente conforme necessário)
# NVIDIA Drivers (detecta automaticamente a GPU)
# DEBIAN_FRONTEND=noninteractive apt install -y nvidia-driver-535 nvidia-utils-535

# AMD Drivers (já incluídos no kernel, mas pode instalar mesa atualizado)
# DEBIAN_FRONTEND=noninteractive apt install -y mesa-vulkan-drivers mesa-vdpau-drivers

# Intel Graphics (drivers e ferramentas)
# DEBIAN_FRONTEND=noninteractive apt install -y intel-gpu-tools intel-media-va-driver

# Kernel Mainline Manager
# DEBIAN_FRONTEND=noninteractive apt install -y mainline

# FERRAMENTAS DE DESENVOLVIMENTO (descomente as que desejar)

# Visual Studio Code
# DEBIAN_FRONTEND=noninteractive apt install -y code

# Git (versão mais recente)
# DEBIAN_FRONTEND=noninteractive apt install -y git git-lfs

# Docker
# DEBIAN_FRONTEND=noninteractive apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Java (OpenJDK)
# DEBIAN_FRONTEND=noninteractive apt install -y openjdk-17-jdk openjdk-17-jre maven gradle

# Oracle Java (requer aceitar licença manualmente, use OpenJDK acima como alternativa)
# echo "oracle-java17-installer shared/accepted-oracle-license-v1-3 select true" | debconf-set-selections
# DEBIAN_FRONTEND=noninteractive apt install -y oracle-java17-installer oracle-java17-set-default

# .NET SDK
# DEBIAN_FRONTEND=noninteractive apt install -y dotnet-sdk-8.0

# Node.js e NPM
# DEBIAN_FRONTEND=noninteractive apt install -y nodejs

# Yarn
# DEBIAN_FRONTEND=noninteractive apt install -y yarn

# Python (desenvolvimento)
# DEBIAN_FRONTEND=noninteractive apt install -y python3-pip python3-venv python3-dev build-essential

# Go
# DEBIAN_FRONTEND=noninteractive apt install -y golang-go

# Ruby e Rails
# DEBIAN_FRONTEND=noninteractive apt install -y ruby-full bundler

# Rust
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# PostgreSQL
# DEBIAN_FRONTEND=noninteractive apt install -y postgresql postgresql-contrib

# MySQL
# DEBIAN_FRONTEND=noninteractive apt install -y mysql-server

# MongoDB (requer repositório adicional)
# DEBIAN_FRONTEND=noninteractive apt install -y mongodb-org

# Redis
# DEBIAN_FRONTEND=noninteractive apt install -y redis-server

# JETBRAINS TOOLBOX (instalador para IntelliJ IDEA, PyCharm, etc)
# wget -O /tmp/jetbrains-toolbox.tar.gz "https://download.jetbrains.com/toolbox/jetbrains-toolbox-latest.tar.gz"
# tar -xzf /tmp/jetbrains-toolbox.tar.gz -C /opt/
# chmod +x /opt/jetbrains-toolbox-*/jetbrains-toolbox

# NAVEGADORES (descomente os que desejar)
# Google Chrome
# DEBIAN_FRONTEND=noninteractive apt install -y google-chrome-stable

# Microsoft Edge
# DEBIAN_FRONTEND=noninteractive apt install -y microsoft-edge-stable

# MULTIMÍDIA
# Spotify
# DEBIAN_FRONTEND=noninteractive apt install -y spotify-client

# OBS Studio
# DEBIAN_FRONTEND=noninteractive apt install -y obs-studio

# Steam (requer aceitar EULA)
# echo steam steam/question select "I AGREE" | debconf-set-selections
# echo steam steam/license note '' | debconf-set-selections
# DEBIAN_FRONTEND=noninteractive apt install -y steam-installer

# FERRAMENTAS EXTRAS
# Postman (API testing)
# snap install postman

# DBeaver (GUI para bancos de dados)
# snap install dbeaver-ce

# Insomnia (REST client)
# snap install insomnia

# ==========================================
# CONFIGURAÇÃO DE USUÁRIO E SUDO
# ==========================================

# Usuário padrão
USERNAME="$USERNAME"
PASSWORD="$PASSWORD"

# Criar usuário
useradd -m -s /bin/bash "\$USERNAME"
echo "\$USERNAME:\$PASSWORD" | chpasswd
usermod -aG sudo "\$USERNAME"

# ==========================================
# CONFIGURAÇÃO DO SUDO (personalize aqui)
# ==========================================

# OPÇÃO 1: Sudo SEM senha (recomendado para uso pessoal/desenvolvimento)
# Descomente a linha abaixo para permitir sudo sem senha
echo "\$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/\$USERNAME

# OPÇÃO 2: Sudo COM senha mas com timeout maior (padrão é 15 minutos)
# Descomente para aumentar timeout para 60 minutos
# echo "Defaults timestamp_timeout=60" >> /etc/sudoers.d/sudo-timeout

# OPÇÃO 3: Sudo com senha e timeout padrão (15 minutos)
# Se deseja manter comportamento padrão, comente a OPÇÃO 1 acima

# OPÇÃO 4: Desabilitar completamente a necessidade de senha de root
# Útil para ambientes de desenvolvimento
# passwd -d root

# Garantir permissões corretas no arquivo sudoers
chmod 0440 /etc/sudoers.d/\$USERNAME

# Autologin no TTY1 (pode remover se não quiser)
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat << EOT > /etc/systemd/system/getty@tty1.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin \$USERNAME --noclear %I \$TERM
EOT

# Limpeza
apt clean
rm -rf /tmp/* /var/tmp/*
history -c || true

echo "==> Chroot configurado."
EOF_CHROOT

  sudo chmod +x "$CHROOT_DIR$CHROOT_SCRIPT"

  STEP 15 "Entrando no chroot para instalar pacotes... (45%) - Isso pode demorar!"
  sudo chroot "$CHROOT_DIR" "$CHROOT_SCRIPT" > /tmp/chroot-setup.log 2>&1 || erro "Falha ao configurar chroot. Veja /tmp/chroot-setup.log"
  sudo rm "$CHROOT_DIR$CHROOT_SCRIPT"

  # 3.4 Desmontar chroot
  STEP 5 "Desmontando sistemas de arquivos do chroot... (50%)"
  sudo umount -lf "$CHROOT_DIR/dev/pts" || true
  sudo umount -lf "$CHROOT_DIR/proc" || true
  sudo umount -lf "$CHROOT_DIR/sys" || true
  sudo umount -lf "$CHROOT_DIR/run" || true
  sudo umount -lf "$CHROOT_DIR/dev" || true

  # 3.5 Kernel e initrd
  STEP 5 "Copiando kernel e initrd para a imagem... (55%)"
  KERNEL_VERSION=$(ls "$CHROOT_DIR/boot" | grep -E '^vmlinuz-' | sed 's/vmlinuz-//')
  sudo cp "$CHROOT_DIR/boot/vmlinuz-$KERNEL_VERSION" "$IMAGE_DIR/casper/vmlinuz"
  sudo cp "$CHROOT_DIR/boot/initrd.img-$KERNEL_VERSION" "$IMAGE_DIR/casper/initrd"

  # 3.6 Criar filesystem.squashfs
  STEP 15 "Criando filesystem.squashfs... (70%) - Comprimindo sistema!"
  sudo mksquashfs "$CHROOT_DIR" "$IMAGE_DIR/casper/filesystem.squashfs" -e boot > /tmp/mksquashfs.log 2>&1 || erro "Falha ao criar squashfs. Veja /tmp/mksquashfs.log"

  # 3.7 Metadados
  STEP 3 "Criando arquivos de metadados... (73%)"
  echo "$DISTRO_NAME $DISTRO_VERSION" | sudo tee "$IMAGE_DIR/README" > /dev/null
  echo "$DISTRO_NAME" | sudo tee "$IMAGE_DIR/casper/hostname" > /dev/null
  printf "LABEL=%s\n" "$DISTRO_NAME" | sudo tee "$IMAGE_DIR/casper/label" > /dev/null
  sudo du -sx --block-size=1 "$CHROOT_DIR" | cut -f1 | sudo tee "$IMAGE_DIR/casper/filesystem.size" > /dev/null

  # 3.8 ISOLINUX BIOS CUSTOMIZADO
  STEP 5 "Configurando ISOLINUX customizado (boot BIOS)... (78%)"
  sudo tee "$IMAGE_DIR/isolinux/isolinux.cfg" > /dev/null << EOF_ISO
UI menu.c32
PROMPT 0
MENU TITLE $DISTRO_NAME $DISTRO_VERSION - Boot Menu
TIMEOUT 100
MENU BACKGROUND isolinux.png

# Cores personalizadas
MENU COLOR screen       37;40      #80ffffff #00000000 std
MENU COLOR border       30;44      #40ffffff #00000000 std
MENU COLOR title        1;36;44    #ff00ffff #00000000 std
MENU COLOR sel          7;37;40    #e0000000 #20ff8000 all
MENU COLOR unsel        37;44      #50ffffff #00000000 std
MENU COLOR help         37;40      #c0ffffff #00000000 std
MENU COLOR timeout_msg  37;40      #80ffffff #00000000 std
MENU COLOR timeout      1;37;40    #c0ffffff #00000000 std
MENU COLOR msg07        37;40      #90ffffff #00000000 std
MENU COLOR tabmsg       31;40      #90ffff00 #00000000 std

LABEL live
  menu label ^Iniciar $DISTRO_NAME (Live Mode)
  kernel /casper/vmlinuz
  append initrd=/casper/initrd boot=casper quiet splash ---

LABEL safe
  menu label ^Modo Seguro
  kernel /casper/vmlinuz
  append initrd=/casper/initrd boot=casper nomodeset quiet splash ---

LABEL text
  menu label ^Modo Texto (Sem Interface Gráfica)
  kernel /casper/vmlinuz
  append initrd=/casper/initrd boot=casper text ---

MENU SEPARATOR

LABEL hd
  menu label ^Boot do Disco Rígido
  localboot 0x80
EOF_ISO

  sudo cp /usr/lib/ISOLINUX/isolinux.bin "$IMAGE_DIR/isolinux/" || erro "Não encontrei isolinux.bin"
  sudo cp /usr/lib/syslinux/modules/bios/menu.c32 "$IMAGE_DIR/isolinux/" || erro "Não encontrei menu.c32"

  # 3.9 GRUB UEFI CUSTOMIZADO
  STEP 5 "Configurando GRUB customizado (UEFI)... (83%)"
  sudo tee "$IMAGE_DIR/boot/grub/grub.cfg" > /dev/null << EOF_GRUB
# Configuração personalizada do GRUB
set default=0
set timeout=10

# Cores personalizadas (tema escuro moderno)
set color_normal=white/black
set color_highlight=black/white

# Papel de parede e tema
set menu_color_normal=cyan/black
set menu_color_highlight=white/cyan

# Título personalizado
set gfxmode=auto
insmod all_video
insmod gfxterm
terminal_output gfxterm

# Banner ASCII Art
echo ""
echo "  ╔════════════════════════════════════════════╗"
echo "  ║                                            ║"
echo "  ║         $DISTRO_NAME v$DISTRO_VERSION                    ║"
echo "  ║                                            ║"
echo "  ║      Bem-vindo ao Sistema Live             ║"
echo "  ║                                            ║"
echo "  ╚════════════════════════════════════════════╝"
echo ""

menuentry "▶ Iniciar $DISTRO_NAME (Live Mode)" {
    echo "Iniciando sistema live..."
    linux   /casper/vmlinuz boot=casper quiet splash ---
    initrd  /casper/initrd
}

menuentry "▶ Iniciar $DISTRO_NAME (Modo Seguro)" {
    echo "Iniciando em modo seguro..."
    linux   /casper/vmlinuz boot=casper nomodeset quiet splash ---
    initrd  /casper/initrd
}

menuentry "▶ Iniciar $DISTRO_NAME (Sem Interface Gráfica)" {
    echo "Iniciando modo texto..."
    linux   /casper/vmlinuz boot=casper text ---
    initrd  /casper/initrd
}

menuentry "▶ Testar Memória RAM (Memtest86+)" --class memtest {
    echo "Carregando teste de memória..."
    linux16 /boot/memtest86+.bin
}

submenu "⚙ Opções Avançadas" {
    menuentry "▶ Boot com drivers proprietários" {
        linux   /casper/vmlinuz boot=casper modprobe.blacklist=nouveau quiet splash ---
        initrd  /casper/initrd
    }
    
    menuentry "▶ Boot com ACPI desabilitado" {
        linux   /casper/vmlinuz boot=casper acpi=off quiet splash ---
        initrd  /casper/initrd
    }
    
    menuentry "▶ Boot modo debug (verbose)" {
        linux   /casper/vmlinuz boot=casper debug verbose ---
        initrd  /casper/initrd
    }
}

menuentry "⎌ Reiniciar" --class restart {
    echo "Reiniciando..."
    reboot
}

menuentry "⏻ Desligar" --class shutdown {
    echo "Desligando..."
    halt
}
EOF_GRUB

  STEP 5 "Criando imagem de boot UEFI... (88%)"
  truncate -s 64M "$EFI_DIR/efiboot.img"
  mkfs.vfat "$EFI_DIR/efiboot.img" > /dev/null

  mmd -i "$EFI_DIR/efiboot.img" ::/EFI
  mmd -i "$EFI_DIR/efiboot.img" ::/EFI/boot

  grub-mkstandalone \
    -O x86_64-efi \
    --output="$EFI_DIR/bootx64.efi" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=$IMAGE_DIR/boot/grub/grub.cfg" > /tmp/grub-standalone.log 2>&1 || erro "Falha no grub-mkstandalone. Veja /tmp/grub-standalone.log"

  mcopy -i "$EFI_DIR/efiboot.img" "$EFI_DIR/bootx64.efi" ::/EFI/boot/

  mkdir -p "$IMAGE_DIR/EFI/boot"
  cp "$EFI_DIR/efiboot.img" "$IMAGE_DIR/EFI/boot/efiboot.img"

  # 3.10 Criar ISO
  STEP 12 "Gerando ISO final... (100%) - Quase lá!"
  cd "$IMAGE_DIR"

  ISO_NAME="${DISTRO_NAME}-${DISTRO_VERSION}-${ARCH}.iso"

  sudo xorriso \
    -as mkisofs \
    -iso-level 3 \
    -o "$WORKDIR/$ISO_NAME" \
    -full-iso9660-filenames \
    -volid "$DISTRO_NAME" \
    -eltorito-boot isolinux/isolinux.bin \
      -eltorito-catalog isolinux/boot.cat \
      -no-emul-boot -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot \
      -e EFI/boot/efiboot.img \
      -no-emul-boot \
    . > /tmp/xorriso.log 2>&1 || erro "Falha ao criar ISO. Veja /tmp/xorriso.log"

  STEP 10 "Concluído! 🎉"
  sleep 1

) | zenity --progress \
      --title="Construindo sua Distro" \
      --text="Iniciando..." \
      --percentage=0 \
      --auto-close \
      --width=500

if [ $? -ne 0 ]; then
  erro "Processo cancelado pelo usuário ou ocorreu um erro."
fi

info "ISO gerada com sucesso!\n\nLocal:\n$WORKDIR/${DISTRO_NAME}-${DISTRO_VERSION}-${ARCH}.iso"
