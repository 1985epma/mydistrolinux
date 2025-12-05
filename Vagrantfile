# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Box base: Ubuntu 24.04 LTS
  config.vm.box = "ubuntu/noble64"
  config.vm.box_version = ">= 20240101.0.0"

  # Nome da VM
  config.vm.hostname = "mydistrolinux-builder"

  # Configuração de recursos
  config.vm.provider "virtualbox" do |vb|
    vb.name = "MyDistroLinux Builder"
    vb.memory = "4096"  # 4GB RAM
    vb.cpus = 2
    vb.gui = true  # Interface gráfica habilitada para Zenity
    
    # Habilitar aceleração 3D
    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    vb.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
  end

  # Configuração de rede
  config.vm.network "private_network", type: "dhcp"
  
  # Compartilhar pasta do projeto
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  
  # Provisioning: Instalar dependências
  config.vm.provision "shell", inline: <<-SHELL
    echo "================================================"
    echo "  Configurando MyDistroLinux Builder"
    echo "================================================"
    
    # Atualizar sistema
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    
    # Instalar ambiente gráfico leve (XFCE)
    echo "📦 Instalando ambiente gráfico..."
    apt-get install -y \
      xfce4 \
      xfce4-terminal \
      lightdm \
      xinit \
      x11-xserver-utils
    
    # Configurar autologin
    mkdir -p /etc/lightdm/lightdm.conf.d
    cat > /etc/lightdm/lightdm.conf.d/50-autologin.conf << 'EOF'
[Seat:*]
autologin-user=vagrant
autologin-user-timeout=0
user-session=xfce
EOF
    
    # Instalar dependências do script
    echo "📦 Instalando dependências do MyDistroLinux..."
    apt-get install -y \
      debootstrap \
      squashfs-tools \
      xorriso \
      isolinux \
      syslinux-utils \
      grub-pc-bin \
      grub-efi-amd64-bin \
      mtools \
      zenity \
      genisoimage \
      git \
      curl \
      wget
    
    # Criar atalho na área de trabalho
    mkdir -p /home/vagrant/Desktop
    cat > /home/vagrant/Desktop/MyDistroLinux.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=MyDistroLinux Builder
Comment=Criar distribuição Linux personalizada
Exec=/vagrant/distro.sh
Icon=system-software-install
Terminal=false
Categories=Development;
EOF
    
    chmod +x /home/vagrant/Desktop/MyDistroLinux.desktop
    chown vagrant:vagrant /home/vagrant/Desktop/MyDistroLinux.desktop
    
    # Tornar script executável
    chmod +x /vagrant/distro.sh
    
    # Adicionar vagrant ao grupo sudo sem senha para o script
    echo "vagrant ALL=(ALL) NOPASSWD: /usr/sbin/debootstrap" >> /etc/sudoers.d/vagrant-distro
    echo "vagrant ALL=(ALL) NOPASSWD: /usr/bin/mount" >> /etc/sudoers.d/vagrant-distro
    echo "vagrant ALL=(ALL) NOPASSWD: /usr/bin/umount" >> /etc/sudoers.d/vagrant-distro
    echo "vagrant ALL=(ALL) NOPASSWD: /usr/bin/chroot" >> /etc/sudoers.d/vagrant-distro
    echo "vagrant ALL=(ALL) NOPASSWD: /usr/bin/mksquashfs" >> /etc/sudoers.d/vagrant-distro
    echo "vagrant ALL=(ALL) NOPASSWD: /usr/bin/xorriso" >> /etc/sudoers.d/vagrant-distro
    echo "vagrant ALL=(ALL) NOPASSWD: /usr/bin/tee" >> /etc/sudoers.d/vagrant-distro
    echo "vagrant ALL=(ALL) NOPASSWD: /usr/bin/cp" >> /etc/sudoers.d/vagrant-distro
    echo "vagrant ALL=(ALL) NOPASSWD: /usr/bin/du" >> /etc/sudoers.d/vagrant-distro
    chmod 0440 /etc/sudoers.d/vagrant-distro
    
    # Mensagem de sucesso
    echo ""
    echo "================================================"
    echo "✅ VM configurada com sucesso!"
    echo "================================================"
    echo ""
    echo "📋 Próximos passos:"
    echo "   1. A VM será reiniciada automaticamente"
    echo "   2. Login será feito automaticamente"
    echo "   3. Execute o ícone 'MyDistroLinux Builder' na área de trabalho"
    echo ""
    echo "💡 Ou execute manualmente:"
    echo "   cd /vagrant && ./distro.sh"
    echo ""
  SHELL
  
  # Reiniciar para aplicar interface gráfica
  config.vm.provision "shell", inline: "systemctl set-default graphical.target", run: "always"
end
