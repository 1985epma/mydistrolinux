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
  STEP 5 "Preparando ambiente..."
  sleep 1

  STEP 10 "Instalando sistema base Ubuntu com debootstrap..."
  sudo debootstrap --arch="$ARCH" "$UBUNTU_RELEASE" "$CHROOT_DIR" "$UBUNTU_MIRROR" > /tmp/debootstrap.log 2>&1 || erro "Falha no debootstrap. Veja /tmp/debootstrap.log"

  # 3.2 Montar sistemas de arquivos
  STEP 10 "Montando /dev, /proc, /sys dentro do chroot..."
  sudo mount --bind /dev "$CHROOT_DIR/dev"
  sudo mount --bind /run "$CHROOT_DIR/run"
  sudo mount -t proc /proc "$CHROOT_DIR/proc"
  sudo mount -t sysfs /sys "$CHROOT_DIR/sys"
  sudo mount -t devpts devpts "$CHROOT_DIR/dev/pts"

  # 3.3 Script interno do chroot
  STEP 5 "Criando script de configuração dentro do chroot..."
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
EOT

# Adicionar repositórios de terceiros

# Google Chrome
wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Microsoft Edge
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-edge-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge-keyring.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | gpg --dearmor -o /usr/share/keyrings/spotify-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/spotify-keyring.gpg] http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list

# Steam (repositório multiverse já está habilitado)
dpkg --add-architecture i386

apt update

# PACOTES BÁSICOS - customize aqui
DEBIAN_FRONTEND=noninteractive apt install -y \
    linux-generic \
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
    gparted

# PACOTES DE TERCEIROS (descomente os que desejar)
# Google Chrome
# DEBIAN_FRONTEND=noninteractive apt install -y google-chrome-stable

# Microsoft Edge
# DEBIAN_FRONTEND=noninteractive apt install -y microsoft-edge-stable

# Spotify
# DEBIAN_FRONTEND=noninteractive apt install -y spotify-client

# Steam (requer aceitar EULA)
# echo steam steam/question select "I AGREE" | debconf-set-selections
# echo steam steam/license note '' | debconf-set-selections
# DEBIAN_FRONTEND=noninteractive apt install -y steam-installer

# Usuário padrão
USERNAME="$USERNAME"
PASSWORD="$PASSWORD"

useradd -m -s /bin/bash "\$USERNAME"
echo "\$USERNAME:\$PASSWORD" | chpasswd
usermod -aG sudo "\$USERNAME"

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

  STEP 15 "Entrando no chroot para instalar pacotes (isso pode demorar)..."
  sudo chroot "$CHROOT_DIR" "$CHROOT_SCRIPT" > /tmp/chroot-setup.log 2>&1 || erro "Falha ao configurar chroot. Veja /tmp/chroot-setup.log"
  sudo rm "$CHROOT_DIR$CHROOT_SCRIPT"

  # 3.4 Desmontar chroot
  STEP 5 "Desmontando sistemas de arquivos do chroot..."
  sudo umount -lf "$CHROOT_DIR/dev/pts" || true
  sudo umount -lf "$CHROOT_DIR/proc" || true
  sudo umount -lf "$CHROOT_DIR/sys" || true
  sudo umount -lf "$CHROOT_DIR/run" || true
  sudo umount -lf "$CHROOT_DIR/dev" || true

  # 3.5 Kernel e initrd
  STEP 5 "Copiando kernel e initrd para a imagem..."
  KERNEL_VERSION=$(ls "$CHROOT_DIR/boot" | grep -E '^vmlinuz-' | sed 's/vmlinuz-//')
  sudo cp "$CHROOT_DIR/boot/vmlinuz-$KERNEL_VERSION" "$IMAGE_DIR/casper/vmlinuz"
  sudo cp "$CHROOT_DIR/boot/initrd.img-$KERNEL_VERSION" "$IMAGE_DIR/casper/initrd"

  # 3.6 Criar filesystem.squashfs
  STEP 15 "Criando filesystem.squashfs (sistema comprimido)..."
  sudo mksquashfs "$CHROOT_DIR" "$IMAGE_DIR/casper/filesystem.squashfs" -e boot > /tmp/mksquashfs.log 2>&1 || erro "Falha ao criar squashfs. Veja /tmp/mksquashfs.log"

  # 3.7 Metadados
  STEP 3 "Criando arquivos de metadados..."
  echo "$DISTRO_NAME $DISTRO_VERSION" | sudo tee "$IMAGE_DIR/README" > /dev/null
  echo "$DISTRO_NAME" | sudo tee "$IMAGE_DIR/casper/hostname" > /dev/null
  printf "LABEL=%s\n" "$DISTRO_NAME" | sudo tee "$IMAGE_DIR/casper/label" > /dev/null
  sudo du -sx --block-size=1 "$CHROOT_DIR" | cut -f1 | sudo tee "$IMAGE_DIR/casper/filesystem.size" > /dev/null

  # 3.8 ISOLINUX BIOS CUSTOMIZADO
  STEP 5 "Configurando ISOLINUX customizado (boot BIOS)..."
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
  STEP 5 "Configurando GRUB customizado (UEFI)..."
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

  STEP 5 "Criando imagem de boot UEFI..."
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
  STEP 12 "Gerando ISO final..."
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

  STEP 10 "Finalizando..."
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
