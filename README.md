# MyDistroLinux - Criador de Distribuições Linux Personalizadas

Script automatizado para criar distribuições Linux personalizadas baseadas no Ubuntu, com interface gráfica intuitiva usando Zenity.

## 📋 Descrição

Este script bash permite criar uma distribuição Linux ISO customizada a partir de releases do Ubuntu (22.04 LTS ou 24.04 LTS), com ambiente desktop XFCE4, configurações personalizadas e pacotes pré-instalados.

## ✨ Características

- **Interface Gráfica**: Todo o processo é guiado por diálogos Zenity
- **Personalização Completa**: Escolha nome, versão, usuário e senha da distro
- **Base Ubuntu**: Suporte para Ubuntu 22.04 LTS (Jammy) e 24.04 LTS (Noble)
- **Boot Dual**: Suporte para BIOS (ISOLINUX) e UEFI (GRUB)
- **Ambiente Desktop**: XFCE4 pré-configurado com LightDM
- **Aplicativos Incluídos**: Firefox, VLC, GParted, Zsh e mais
- **Live System**: Sistema funcional em modo Live com opção de instalação

## 🔧 Requisitos

### Sistema Operacional
- Ubuntu/Debian ou derivados (testado em Ubuntu 24.04)
- Ambiente com interface gráfica (para Zenity)

### Pacotes Necessários
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

### Espaço em Disco
- Mínimo: **15 GB** livres
- Recomendado: **20 GB** ou mais

### Permissões
- Acesso `sudo` (o script solicitará senha quando necessário)

## 🚀 Como Usar

1. **Clone o repositório ou baixe o script**:
   ```bash
   git clone https://github.com/1985epma/mydistrolinux.git
   cd mydistrolinux
   ```

2. **Torne o script executável**:
   ```bash
   chmod +x distro.sh
   ```

3. **Execute o script**:
   ```bash
   ./distro.sh
   ```

4. **Siga os diálogos**:
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

## 📦 Pacotes Incluídos

A distribuição vem com os seguintes pacotes pré-instalados:

- **Sistema Base**: linux-generic, systemd-sysv, sudo
- **Rede**: network-manager
- **Live System**: casper, discover, laptop-detect, os-prober
- **Boot**: grub-pc-bin, grub-efi-amd64-bin
- **Desktop**: xorg, lightdm, xfce4, xfce4-goodies
- **Aplicativos**: firefox, vlc, gparted, vim, curl, wget, zsh
- **Utilitários**: dialog

## 🎨 Personalização

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

### Erro no debootstrap
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

### VirtualBox
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
sudo dd if=~/minha-distro/MinhaDistro-1.0-amd64.iso of=/dev/sdX bs=4M status=progress && sync
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
- Não execute em sistemas de produção sem testar antes
- Sempre teste a ISO em ambiente virtual antes de usar em hardware real

## 🔗 Recursos Úteis

- [Documentação Ubuntu Customization](https://help.ubuntu.com/community/LiveCDCustomization)
- [Debian Debootstrap](https://wiki.debian.org/Debootstrap)
- [ISOLINUX Documentation](https://wiki.syslinux.org/wiki/index.php?title=ISOLINUX)
- [GRUB Manual](https://www.gnu.org/software/grub/manual/)

## 👤 Autor

**Everton** - [@1985epma](https://github.com/1985epma)

---

**Nota**: Este é um projeto educacional/experimental. Para distribuições de produção, considere usar ferramentas mais robustas como Ubuntu Customization Kit ou Live-Build.