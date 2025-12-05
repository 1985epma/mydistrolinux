#!/bin/bash
# Script para criar release manual

set -e

echo "🚀 MyDistroLinux - Release Manager"
echo "=================================="
echo ""

# Obter versão atual
CURRENT_VERSION=$(cat VERSION | grep CURRENT_VERSION | cut -d'=' -f2)
echo "📌 Versão atual: $CURRENT_VERSION"
echo ""

# Perguntar tipo de release
echo "Escolha o tipo de release:"
echo "1) patch  - Correções de bugs (ex: 1.0.0 -> 1.0.1)"
echo "2) minor  - Novas funcionalidades (ex: 1.0.0 -> 1.1.0)"
echo "3) major  - Mudanças incompatíveis (ex: 1.0.0 -> 2.0.0)"
echo "4) custom - Versão personalizada"
echo ""
read -p "Opção [1-4]: " OPTION

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

case $OPTION in
  1)
    PATCH=$((PATCH + 1))
    TYPE="patch"
    ;;
  2)
    MINOR=$((MINOR + 1))
    PATCH=0
    TYPE="minor"
    ;;
  3)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    TYPE="major"
    ;;
  4)
    read -p "Digite a nova versão (ex: 2.0.0): " CUSTOM_VERSION
    MAJOR=$(echo $CUSTOM_VERSION | cut -d'.' -f1)
    MINOR=$(echo $CUSTOM_VERSION | cut -d'.' -f2)
    PATCH=$(echo $CUSTOM_VERSION | cut -d'.' -f3)
    TYPE="custom"
    ;;
  *)
    echo "❌ Opção inválida"
    exit 1
    ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
NEW_TAG="v$NEW_VERSION"

echo ""
echo "📦 Nova versão: $NEW_VERSION"
echo ""

# Confirmar
read -p "Deseja criar release $NEW_TAG? [y/N]: " CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
  echo "❌ Cancelado"
  exit 0
fi

# Atualizar VERSION
sed -i "s/CURRENT_VERSION=.*/CURRENT_VERSION=$NEW_VERSION/" VERSION

# Pedir descrição da release
echo ""
echo "Digite a descrição da release (CTRL+D para finalizar):"
DESCRIPTION=$(cat)

# Commitar mudanças
git add VERSION
git commit -m "chore: bump version to $NEW_VERSION" || true

# Criar tag anotada
git tag -a "$NEW_TAG" -m "Release $NEW_TAG

$DESCRIPTION"

echo ""
echo "✅ Tag $NEW_TAG criada localmente"
echo ""
echo "Para enviar ao GitHub, execute:"
echo "  git push origin main"
echo "  git push origin $NEW_TAG"
echo ""
echo "Ou execute agora:"
read -p "Enviar para o GitHub agora? [y/N]: " PUSH_NOW

if [[ $PUSH_NOW =~ ^[Yy]$ ]]; then
  git push origin main
  git push origin "$NEW_TAG"
  echo ""
  echo "🎉 Release publicada com sucesso!"
  echo "🔗 https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/releases/tag/$NEW_TAG"
else
  echo "👍 Lembre-se de fazer push quando estiver pronto!"
fi
