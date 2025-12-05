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
- **Repositórios Extras**: Suporte para Chrome, Edge, Spotify e Steam
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

## 🔄 CI/CD e Versionamento

Este projeto utiliza GitHub Actions para automação completa de releases e controle de qualidade.

### Workflows Disponíveis

#### Release Automática
- **Trigger**: Push de tags `v*` ou commits na branch `main`
- **Ações**:
  - Validação de sintaxe bash com ShellCheck
  - Versionamento semântico automático
  - Geração de changelog
  - Criação de releases no GitHub
  - Upload de arquivos (script, README, ZIP)

#### Linter e Quality Check
- **Trigger**: Push ou PR em `main`/`develop`
- **Ações**:
  - Análise estática de código
  - Validação de Markdown
  - Verificação de ortografia

### Como Criar uma Release

#### Método 1: Automático (recomendado)
```bash
# Fazer commit normal
git add .
git commit -m "feat: adicionar nova funcionalidade"
git push origin main

# O CI/CD automaticamente cria a versão patch/minor/major
# baseado na mensagem de commit
```

**Convenção de commits**:
- `feat:` ou `feature:` → incrementa versão **minor** (1.0.0 → 1.1.0)
- `fix:` ou `bugfix:` → incrementa versão **patch** (1.0.0 → 1.0.1)
- `BREAKING CHANGE:` ou `major:` → incrementa versão **major** (1.0.0 → 2.0.0)

#### Método 2: Manual com Script
```bash
# Executar script interativo
./release.sh

# Escolher tipo de release:
# 1) patch  - Correções (1.0.0 → 1.0.1)
# 2) minor  - Features (1.0.0 → 1.1.0)
# 3) major  - Breaking (1.0.0 → 2.0.0)
# 4) custom - Versão específica
```

#### Método 3: Tag Manual
```bash
# Criar tag manualmente
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