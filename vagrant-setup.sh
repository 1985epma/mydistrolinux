#!/bin/bash
# Script de inicialização rápida para Vagrant

set -e

echo "🚀 MyDistroLinux - Vagrant Setup"
echo "================================="
echo ""

# Verificar se Vagrant está instalado
if ! command -v vagrant &> /dev/null; then
    echo "❌ Vagrant não está instalado!"
    echo ""
    echo "📥 Instale o Vagrant:"
    echo "   - Linux: sudo apt install vagrant virtualbox"
    echo "   - macOS: brew install vagrant"
    echo "   - Windows: https://www.vagrantup.com/downloads"
    echo ""
    exit 1
fi

# Verificar se VirtualBox está instalado
if ! command -v VBoxManage &> /dev/null; then
    echo "❌ VirtualBox não está instalado!"
    echo ""
    echo "📥 Instale o VirtualBox:"
    echo "   - Linux: sudo apt install virtualbox"
    echo "   - macOS: brew install --cask virtualbox"
    echo "   - Windows: https://www.virtualbox.org/wiki/Downloads"
    echo ""
    exit 1
fi

echo "✅ Vagrant: $(vagrant --version)"
echo "✅ VirtualBox: $(VBoxManage --version)"
echo ""

# Verificar se VM já existe
if vagrant status | grep -q "running"; then
    echo "ℹ️  VM já está em execução"
    echo ""
    read -p "Deseja recarregar a VM? [y/N]: " RELOAD
    if [[ $RELOAD =~ ^[Yy]$ ]]; then
        echo "🔄 Recarregando VM..."
        vagrant reload --provision
    fi
else
    echo "🏗️  Criando e iniciando VM..."
    echo "⏱️  Isso pode levar 5-10 minutos na primeira vez..."
    echo ""
    vagrant up
fi

echo ""
echo "================================================"
echo "✅ VM pronta para uso!"
echo "================================================"
echo ""
echo "📋 Comandos úteis:"
echo ""
echo "  🖥️  Abrir interface gráfica da VM:"
echo "     A janela do VirtualBox abrirá automaticamente"
echo ""
echo "  📂 Acessar VM via SSH:"
echo "     vagrant ssh"
echo ""
echo "  ▶️  Executar script dentro da VM:"
echo "     vagrant ssh -c 'cd /vagrant && ./distro.sh'"
echo ""
echo "  🔄 Reiniciar VM:"
echo "     vagrant reload"
echo ""
echo "  ⏹️  Pausar VM:"
echo "     vagrant suspend"
echo ""
echo "  🗑️  Destruir VM:"
echo "     vagrant destroy"
echo ""
echo "💡 O script distro.sh está disponível em /vagrant dentro da VM"
echo "   e na área de trabalho como 'MyDistroLinux Builder'"
echo ""
