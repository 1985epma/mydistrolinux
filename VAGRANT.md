# MyDistroLinux com Vagrant

Guia completo para usar o MyDistroLinux através do Vagrant.

## O que é Vagrant?

Vagrant é uma ferramenta que cria e configura ambientes de desenvolvimento virtualizados de forma automatizada. Perfeito para executar o MyDistroLinux em Windows, macOS ou Linux sem modificar seu sistema.

## Requisitos

- **Vagrant** 2.0 ou superior
- **VirtualBox** 6.0 ou superior
- **8 GB RAM** (4 GB para a VM)
- **25 GB** de espaço em disco

## Instalação

### Windows

1. Baixe e instale:
   - [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
   - [Vagrant](https://www.vagrantup.com/downloads)

2. Reinicie o computador

3. Abra PowerShell ou CMD:
   ```powershell
   vagrant --version
   ```

### macOS

```bash
# Usando Homebrew
brew install --cask virtualbox
brew install vagrant

# Verificar instalação
vagrant --version
```

### Linux (Ubuntu/Debian)

```bash
# Instalar VirtualBox
sudo apt update
sudo apt install virtualbox

# Instalar Vagrant
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install vagrant
```

## Uso Rápido

```bash
# Clonar repositório
git clone https://github.com/1985epma/mydistrolinux.git
cd mydistrolinux

# Iniciar VM (setup automático)
./vagrant-setup.sh

# Ou manualmente
vagrant up
```

**Primeira execução**: 5-10 minutos (download da imagem Ubuntu)

## Acessando a VM

### Interface Gráfica (Recomendado)

1. A janela do VirtualBox abre automaticamente
2. Login automático como usuário `vagrant`
3. Desktop XFCE4 carregado
4. Clique no ícone **"MyDistroLinux Builder"** na área de trabalho

### Terminal SSH

```bash
# Acessar via SSH
vagrant ssh

# Navegar para o projeto
cd /vagrant

# Executar script
./distro.sh
```

## Estrutura de Pastas

| Host                    | VM              | Descrição                    |
|-------------------------|-----------------|------------------------------|
| `./`                    | `/vagrant`      | Pasta compartilhada (sync)   |
| `./distro.sh`           | `/vagrant/distro.sh` | Script principal        |
| N/A                     | `~/minha-distro` | ISOs geradas dentro da VM   |

## Comandos Úteis

```bash
# Ver status da VM
vagrant status

# Iniciar VM
vagrant up

# Pausar VM (salva estado)
vagrant suspend

# Retomar VM pausada
vagrant resume

# Reiniciar VM
vagrant reload

# Reiniciar com reprovisionamento
vagrant reload --provision

# Desligar VM
vagrant halt

# Acessar via SSH
vagrant ssh

# Destruir VM (libera espaço)
vagrant destroy

# Ver logs
vagrant up --debug
```

## Configuração da VM

**Recursos padrão:**
- **Sistema**: Ubuntu 24.04 LTS (Noble)
- **RAM**: 4 GB
- **CPUs**: 2 cores
- **VRAM**: 128 MB
- **Interface**: XFCE4 Desktop
- **Display**: Aceleração 3D habilitada

**Modificar recursos** (edite `Vagrantfile`):
```ruby
config.vm.provider "virtualbox" do |vb|
  vb.memory = "8192"  # 8 GB RAM
  vb.cpus = 4         # 4 CPUs
end
```

## Copiando a ISO para o Host

### Método 1: Pasta Compartilhada
```bash
# Dentro da VM, mover ISO para /vagrant
mv ~/minha-distro/*.iso /vagrant/

# No host, a ISO estará na pasta do projeto
ls *.iso
```

### Método 2: SCP (de fora da VM)
```bash
# Obter configuração SSH
vagrant ssh-config

# Copiar arquivo
scp -P 2222 vagrant@127.0.0.1:~/minha-distro/*.iso .
```

## Resolução de Problemas

### VM não inicia

```bash
# Verificar VirtualBox
VBoxManage --version

# Ver detalhes do erro
vagrant up --debug

# Recriar do zero
vagrant destroy -f
rm -rf .vagrant
vagrant up
```

### Interface gráfica não aparece

1. Abra **VirtualBox Manager**
2. Selecione a VM "MyDistroLinux Builder"
3. Clique em **Mostrar** ou dê duplo clique
4. Login deve ser automático

### Tela preta após login

```bash
# SSH na VM
vagrant ssh

# Reiniciar display manager
sudo systemctl restart lightdm
```

### Erro de memória insuficiente

Edite `Vagrantfile` e reduza RAM:
```ruby
vb.memory = "2048"  # 2 GB
```

### Pasta compartilhada não funciona

```bash
# Reinstalar VirtualBox Guest Additions
vagrant plugin install vagrant-vbguest
vagrant vbguest --do install
vagrant reload
```

## Performance

### Melhorar velocidade de build

```bash
# Aumentar RAM da VM (edite Vagrantfile)
vb.memory = "8192"

# Usar mais CPUs
vb.cpus = 4

# Usar mirror local do Ubuntu (dentro da VM)
# Edite distro.sh e mude UBUNTU_MIRROR
```

### Reduzir uso de disco

```bash
# Após criar ISO, limpar cache
vagrant ssh -c "sudo apt-get clean"

# Remover builds antigos
rm -rf ~/minha-distro/chroot
```

## Automação

### Script de build completo

```bash
# Criar script no host
cat > build-distro.sh << 'EOF'
#!/bin/bash
vagrant up
vagrant ssh -c "cd /vagrant && ./distro.sh"
vagrant ssh -c "mv ~/minha-distro/*.iso /vagrant/"
echo "ISO disponível em: $(ls *.iso)"
EOF

chmod +x build-distro.sh
./build-distro.sh
```

## Limpeza

```bash
# Desligar e remover VM
vagrant destroy -f

# Remover box base (libera ~1GB)
vagrant box remove ubuntu/noble64

# Limpar cache global do Vagrant
rm -rf ~/.vagrant.d/tmp/*
```

## Dicas

1. **Primeira vez**: Deixe baixar a box completa (pode demorar)
2. **Snapshots**: Use snapshots do VirtualBox antes de builds longos
3. **Backup**: Faça backup das ISOs criadas regularmente
4. **Performance**: Feche programas pesados no host durante o build
5. **Updates**: Atualize Vagrant e VirtualBox periodicamente

## Comparação: Vagrant vs Local

| Aspecto            | Vagrant                  | Local                |
|--------------------|--------------------------|----------------------|
| Setup              | Automático               | Manual               |
| Tempo inicial      | 10 min                   | 5 min                |
| Isolamento         | ✅ Completo              | ❌ Nenhum            |
| Windows/Mac        | ✅ Funciona              | ❌ Não suportado     |
| Recursos           | Configurável             | Sistema host         |
| Limpeza            | `vagrant destroy`        | Arquivos espalhados  |
| GUI                | ✅ Incluída              | Depende do sistema   |

## Recursos Adicionais

- [Documentação Vagrant](https://www.vagrantup.com/docs)
- [Vagrant Boxes](https://app.vagrantup.com/boxes/search)
- [VirtualBox Manual](https://www.virtualbox.org/manual/)

## Suporte

Problemas com Vagrant? Abra uma [issue](https://github.com/1985epma/mydistrolinux/issues) com:
- Output de `vagrant --version`
- Output de `VBoxManage --version`
- Sistema operacional do host
- Log completo (`vagrant up --debug > vagrant.log 2>&1`)
